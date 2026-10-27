---
title: "Lista 01 — auditoria do material (INPC)"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
status: revisado
tags:
  - series-temporais
  - mestrado/ppgeco
  - trabalho
aliases:
  - Auditoria Lista 01
---

# Auditoria da Lista 01 (INPC)

Esta auditoria cruza três coisas: o enunciado da Lista 01 (LST01), os slides das aulas 01 a 03 (Box-Jenkins, diagnóstico e avaliação, em especial a AU03) e as seis versões do trabalho que existem neste repositório. Os números citados foram reproduzidos em R 4.3 com `forecast` 8.21, `urca` 1.3 e `sidrar` 0.6, sobre o INPC de jan/2013 a set/2026 baixado do SIDRA em 27/10/2026. Ele é idêntico, mês a mês, ao `lista01/dados/inpc_lista01.csv` versionado.

O resultado da auditoria é o [laboratório](lab/README.md): `lista01/lab/lab_inpc.R`, um script único que baixa a série com o `sidrar`, segue o ciclo de Box-Jenkins dos slides e responde cada item do enunciado.

## 1. O achado principal: as versões não contam a mesma história

| Versão | Série modelada | Janela | $d$ | Modelo | Q7: bate os benchmarks? |
|---|---|---|---|---|---|
| `trabalho_inpc/` | variação mensal, sem log | 2000–2026 (321) | 0 | SARIMA(1,0,0)(1,0,1)₁₂ | bate o passeio aleatório, **perde para o sazonal ingênuo** |
| `lista01/` (01–07, Rmd) | $100\ln P$ | 2013–2026 (165) | 1 | SARIMA(1,1,0)(1,0,0)₁₂ | bate os dois, com DM significativo |
| `lista01/laboratorio_lista01.R` | $100\ln P$ | 2013–2026 | 1 | o mesmo | bate os dois (sem DM) |
| `lista01/lista01_inpc.R` | $100\ln P$ | 2013–2026 | 1 | o mesmo | bate os dois |
| `lista01/simples/*.qmd` | $100\ln P$ | 2013–2026 | 1 | o mesmo, contra um ARIMA sem sazonal | bate os dois |
| `lista01/dupla/*.qmd` | variação mensal | 2013–2026 | 0 | SARMA para a variação | ver a [revisão](dupla/revisao.md) |

O `README.md` da raiz resume o `trabalho_inpc` ("não bate o ingênuo sazonal"), e o `lista01/README.md` resume o contrário ("bate o passeio aleatório e o sazonal ingênuo"). **As duas frases estão certas, mas medem coisas diferentes**, e é isso que a dupla precisa saber explicar:

- Com $y=100\ln P$, os benchmarks do enunciado ($y_{t+h}=y_t$ e $y_{t+h}=y_{t+h-s}$) preveem, em termos de inflação, **zero** e **a inflação de um ano inteiro omitida**. São benchmarks fracos para uma série com drift, e qualquer modelo com drift os bate.
- Na escala da inflação mensal, a que o SARIMA de fato modela, com os ingênuos definidos em $\Delta y$, o resultado se inverte. No esquema 2, o RMSE do SARIMA é 0,407 p.p., contra 0,513 do passeio aleatório da inflação e **0,364 do sazonal ingênuo da inflação**. O DM não rejeita a igualdade em nenhum dos dois casos ($p=0{,}06$ e $p=0{,}61$).
- No esquema 2, o erro do SARIMA é o mesmo nas duas escalas, porque $y_t$ é conhecido na origem: $y_{t+1}-\widehat y_{t+1\mid t}=\pi_{t+1}-\widehat\pi_{t+1\mid t}$. Só o benchmark muda.

**Recomendação:** entregar uma versão só, a de $d=1$ sobre $100\ln P$, que exercita todas as etapas do enunciado (transformação, teste no nível e na diferença, $d^*+1=2$ na Q6), e reportar **as duas** comparações na Q7(f). A do enunciado vem primeiro; a da inflação, como leitura honesta. O enunciado proíbe mudar o modelo para virar o resultado, e não proíbe mostrar que o benchmark é fraco.

## 2. Conformidade com o enunciado, item a item

Status da versão completa (`lista01/01_`…`07_` + Rmd) e do laboratório novo. ✅ atende; ⚠️ atende em parte; ❌ não atende.

| Item | Exigência | Versão completa | Simples (.qmd) | Laboratório novo |
|---|---|---|---|---|
| Normas | código, banco usado e `sessionInfo` | ✅ | ⚠️ não grava o banco | ✅ CSV com a janela no nome e `sessionInfo.txt` |
| Normas | "não vale série de pacote do R" | ✅ SIDRA | ✅ | ✅ |
| Q1(a) | tendência, sazonalidade, nível, outliers, dispersão | ✅ | ⚠️ sem outliers nem dispersão | ✅ média e dp por ano, meses com $\lvert z\rvert>2{,}5$ |
| Q2(a) | estatística, crítico, p-valor, defasagens **e critério**, termos | ✅ | ❌ só `summary()` | ✅ tabela única com MacKinnon e KPSS interpolado |
| Q2(b) | justificar constante e tendência; mostrar a mudança | ✅ | ⚠️ sem $\phi$ | ✅ $\tau_3,\tau_2,\tau_1$ e $\phi_3,\phi_1$ |
| Q2(c) | $d$ e $D$ | ✅ dummies sazonais | ⚠️ $D$ só pela FAC | ✅ dummies (teste F), OCSB, Canova-Hansen e FAC |
| Q2(d) | DS × TS e a ambiguidade | ✅ | ⚠️ | ✅ DF-GLS e a série longa |
| Q3 | FAC/FACP com 2 ciclos ou mais, leitura em $s\pm1$, três candidatos | ✅ | ✅ | ✅ tabela com 1–3, 11–13, 24 e 36 contra a banda |
| Q4(a) | **tabela única**: coef., e.p., $t$, $\widehat\sigma^2$, logLik, AIC, BIC | ✅ | ❌ três `coeftest` soltos | ✅ |
| Q4(b)(c) | $n$ efetivo e validade da comparação | ✅ | ✅ | ✅ conferida em código (`mesma_base`) |
| Q4(d) | $\widehat\sigma^2$ entra em $k$? | ✅ | ✅ | ✅ AIC e BIC refeitos à mão |
| Q4(e) | AIC × BIC e a escolha | ✅ | ⚠️ | ✅ regra fixada antes da validação, com $\Delta$AIC |
| Q4(f) | raízes e gráfico | ✅ | ✅ | ✅ polinômio regular × sazonal multiplicado |
| Q5(a) | resíduos no tempo, FAC, **FACP**, histograma, QQ | ✅ | ⚠️ sem FACP | ✅ painel 2×3, mais a FAC de $\widehat\varepsilon^2$ (slide 22) |
| Q5(b) | Ljung-Box com gl corrigido | ✅ | ✅ (`checkresiduals`) | ✅ K = 12, 24 e 36, $\nu=K-(p+q+P+Q)$ |
| Q5(c) | JB e ARCH-LM | ✅ | ✅ | ✅ e McLeod-Li (slide 21) |
| Q5(d) | **lista dos descartados e o motivo** | ✅ grade de 64 | ⚠️ só o M0 | ✅ grade de 36, com o motivo de cada um |
| Q5(e) | sobreajuste AR e MA | ✅ | ✅ | ✅ $t$ e razão de verossimilhança |
| Q6(a)–(d) | $\widehat\theta$, raiz, $\widehat\sigma^2$, FAC, sinais | ✅ | ✅ | ✅ |
| Q7(a)–(c) | 24 meses, esquema 1 e esquema 2 sem reestimar | ✅ | ✅ | ✅ |
| Q7(d)(e) | RMSE, MAE, MAPE; tabela modelos × esquemas | ✅ | ⚠️ seis linhas soltas | ✅ e MASE (slide 49) |
| Q7(f) | superou? sem forçar | ⚠️ só no índice | ⚠️ só no índice | ✅ no índice e na inflação, com DM |
| Q7(g) | cobertura do IC de 95% | ✅ e $LR_{uc}$ | ✅ | ✅ $LR_{uc}$, $LR_{ind}$, $LR_{cc}$ e Winkler (slides 53–60) |
| Q8 | manuscrita | — | — | — (sugestão: Q6 e Q12 da lista teórica) |

## 3. Problemas encontrados, por gravidade

### Alta: mudam a nota ou a defesa oral

1. **Conclusões opostas da Q7 entre versões** (seção 1). Escolher uma versão e explicar a escala dos benchmarks.
2. **A versão simples não cumpre a Q2(a) nem a Q4(a).** O enunciado pede o critério das defasagens, o crítico e o p-valor de cada teste. O `urca` não dá p-valor, e o `summary()` não mostra quantas defasagens o AIC escolheu. Pede também os três modelos em **tabela única**. Se a dupla for de versão simples, ela perde pontos aqui.
3. **Q5(d) incompleta na versão simples.** "A lista de modelos descartados e o motivo de cada descarte fazem parte da entrega." Mostrar só o ARIMA sem sazonal não é a lista.

### Média: imprecisões que um avaliador atento pega

4. **`CONVENCOES.md` §2 se contradiz sobre o sinal do MA.** Diz que o `forecast` "imprime na lógica" de Box-Jenkins ($1-\theta B$) e, duas linhas depois, que o `Arima` imprime sempre no sinal positivo. Vale a segunda: `forecast::Arima` herda a convenção de `stats::arima`, $1+\theta B$. Na Q6, $\widehat\theta_R=-1{,}000$ é $\theta=1$ na lista. **Corrigido nesta revisão.**
5. **Q4(e): a escolha do C1 contradiz o próprio argumento.** O texto diz que prever "favorece o AIC" e fica com o modelo do BIC. Isso é defensável, mas pelo argumento certo: o $\Delta$AIC é de 0,51 (< 2, indistinguíveis; Burnham e Anderson, 2002), e o $\phi_2$ extra tem $p=0{,}11$. O laboratório imprime os dois números.
6. **Q6(c): a FAC dos resíduos com $d=2$ não mostra o $\rho_1$ negativo.** Com as mesmas ordens, o AR do modelo sobrediferenciado troca de sinal e absorve a autocorrelação: $\widehat\rho_1$ dos resíduos é $-0{,}05$. Quem mostra o $-0{,}34$ é a **série** $\Delta^2y$, perto do teórico $-(1-\phi)/2=-0{,}25$. A resposta precisa separar as duas coisas; o laboratório imprime as quatro.
7. **Estabilidade por MQO sem a restrição multiplicativa.** Chow e CUSUM usam $\Delta y_t$ em $\Delta y_{t-1},\Delta y_{t-12},\Delta y_{t-13}$, sem impor $\phi_{13}=-\phi_1\Phi$. É uma aproximação aceitável (a AU03 aplica esses testes a regressões), mas convém dizer isso numa frase.
8. **KPSS com p-valor limitado.** A tabela de Kwiatkowski et al. só vai de 1% a 10%. Um "0,10" significa "≥ 0,10" e deve ser escrito assim.

### Baixa: estética e robustez do código

9. **Ordem dos pacotes.** O `FinTS` exporta um `Acf` que mascara o do `forecast` quando é carregado depois. Os valores são os mesmos, mas o eixo sai em anos (0,5; 1,0…) em vez de defasagens (12, 24…). Afeta `simples/lista01_simples.qmd` (linhas 79, 159 e 189). O laboratório carrega o `forecast` por último.
10. **Números digitados nos comentários** de `laboratorio_lista01.R` (por exemplo, "$-2{,}21$ contra $-3{,}43$" e "0,22 em 12"). Com o `sidrar` baixando dados novos, eles ficam velhos sem aviso. O laboratório novo não digita nenhum número: os números vêm das saídas do código.
11. **Download sem cache.** `lista01_inpc.R` e o `.qmd` simples baixam a série a cada execução. Uma revisão do IBGE, ou um mês a mais, mudaria os números do relatório entregue. O laboratório grava `dados/inpc_AAAAMM_AAAAMM.csv` e só baixa de novo com `ATUALIZAR <- TRUE`.
12. **Encoding dos nomes do `sidrar`.** As colunas vêm com acento ("Mês (Código)"), e o acesso por nome falha fora de um locale UTF-8. O laboratório identifica a coluna do período pelo conteúdo (códigos AAAAMM).

## 4. O que os slides pedem e onde está

| Slide (AU03) | Ferramenta | No laboratório |
|---|---|---|
| 4–7 | ciclo iterativo; *model checking* × *model assessment* | estrutura do script: Q1–Q5 checam, Q7 avalia |
| 10 | painel gráfico dos resíduos | Q5(a) |
| 11–14 | Jarque-Bera | Q5(c) |
| 15–17 | Ljung-Box com $\nu=k-p-q$ | Q5(b); o `checkresiduals` faz a mesma correção (`modeldf` = $p+q+P+Q$) |
| 19–22 | ARCH-LM, FAC de $\widehat\varepsilon^2$, Portmanteau Q | Q5(a) e Q5(c) |
| 24–26 | Chow com data a priori | estabilidade, `DATA_QUEBRA` na seção 0 |
| 27–31 | resíduos recursivos, CUSUM, CUSUM-Q | estabilidade |
| 36–37 | janela fixa × recursiva × deslizante | o esquema 2 do enunciado é a janela fixa (coeficientes do treino) |
| 39–44 | iterada × direta | o esquema 1 é iterado; em $h=1$ as duas coincidem |
| 45–49 | RMSE, MAD (MAE), MAPE, MASE | Q7(d)(e); MAPE fora da escala da inflação (slide 46: instável perto de zero) |
| 50–51 | Diebold-Mariano | Q7(f); o `dm.test` aplica a correção de Harvey, Leybourne e Newbold (1997) e a $t_{n-1}$ |
| 53–55 | Winkler | Q7(g) |
| 59–60 | Christoffersen: $LR_{uc}$, $LR_{ind}$, $LR_{cc}$ | Q7(g) |

## 5. Pesquisa complementar (o que foi conferido fora dos slides)

As afirmações técnicas do laboratório foram conferidas no código-fonte dos pacotes, não só na documentação:

- **AIC do `Arima`:** $k$ = coeficientes + 1. Refeito à mão: 125,618 nos dois.
- **Graus de liberdade do `checkresiduals`:** `forecast:::modeldf.Arima` devolve $p+q+P+Q$; o drift não entra. É a regra do slide 15.
- **`dm.test`:** multiplica a estatística por $\sqrt{(n+1-2h+h(h-1)/n)/n}$ e usa a $t_{n-1}$ (HLN, 1997).
- **Amostra efetiva do `Arima`:** `nobs` = $T-d-sD$ = 164.
- **`sidrar`:** a API `/t/1736/n1/all/v/2289/p/201301-202609` devolve os 165 meses, idênticos ao CSV versionado (diferença máxima de 0).

Referências usadas além das aulas e de Mattos (2019):

- Burnham, K. P.; Anderson, D. R. *Model Selection and Multimodel Inference*. 2ª ed. Springer, 2002 (a regra $\Delta$AIC < 2).
- Canova, F.; Hansen, B. E. Are seasonal patterns constant over time? *JBES*, 13(3), 1995.
- Christoffersen, P. Evaluating interval forecasts. *International Economic Review*, 39(4), 1998.
- Dickey, D. A.; Fuller, W. A. Likelihood ratio statistics for autoregressive time series with a unit root. *Econometrica*, 49(4), 1981 (as estatísticas $\phi$).
- Elliott, G.; Rothenberg, T.; Stock, J. Efficient tests for an autoregressive unit root. *Econometrica*, 64(4), 1996 (DF-GLS).
- Harvey, D.; Leybourne, S.; Newbold, P. Testing the equality of prediction mean squared errors. *IJF*, 13(2), 1997.
- Hyndman, R. J.; Athanasopoulos, G. *Forecasting: Principles and Practice*. 3ª ed. OTexts, 2021, cap. 5 (o sazonal ingênuo para $h>s$: $y_{T+h-s(k+1)}$, com $k=\lfloor(h-1)/s\rfloor$).
- MacKinnon, J. G. Numerical distribution functions for unit root and cointegration tests. *JAE*, 11(6), 1996.
- Osborn, D. R.; Chui, A. P. L.; Smith, J. P.; Birchenhall, C. R. Seasonality and the order of integration for consumption. *Oxford Bulletin of Economics and Statistics*, 50(4), 1988 (OCSB).

O loop `autoestudo` (skill do repositório) não foi rodado: ele mede a cobertura das aulas nos módulos teóricos e depende de `materiais/_txt/`, que está fora do git e não existe neste clone.

## 6. O que fazer antes de entregar

1. Rodar `lista01/lab/lab_inpc.R` na máquina de entrega (Windows, R 4.6) e conferir que os números batem com os desta auditoria. O `sessionInfo.txt` gerado é o que vai na entrega.
2. Decidir a versão única e apagar do texto as frases das outras.
3. Na Q7(f), escrever as duas comparações (seção 1).
4. Trocar `[nomes da dupla]` e comunicar a série ao professor.
5. Q8 à mão.
