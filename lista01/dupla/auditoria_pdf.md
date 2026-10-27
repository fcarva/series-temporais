---
title: "Lista 01 — auditoria do PDF da dupla (versão de 33 páginas)"
disciplina: Econometria II (PPGEco/UFES)
periodo: 2026
lista: LST01
status: rascunho
tags:
  - series-temporais
  - mestrado/ppgeco
  - trabalho
aliases:
  - Auditoria do PDF da dupla
---

# Auditoria do PDF da dupla: o que está errado e o que é só discussão

Esta auditoria cobre o PDF `lista_avaliativa_econometria2.pdf`, de 33 páginas, de Patrick e Felipe. Ele modela a **variação mensal do INPC** de jan/2013 a set/2026 (165 meses), com $d=D=0$ e o modelo **M1 = SARIMA(1,0,0)(1,0,0)$_{12}$**. A [revisão anterior](revisao.md) tratava de uma versão sem as Q5 a Q7. Esta versão já traz as três.

Duas restrições valem para tudo o que segue: **o modelo não muda** (o próprio enunciado proíbe, Q7f), e **a análise do índice não entra**. Todos os números abaixo foram reproduzidos em R com `dados/inpc.csv`, e os do PDF batem até a quarta casa ($\tau_3=-5{,}202$, AIC do M1 $=128{,}65$, RMSE do M1 no esquema 1 $=0{,}3877$).

## 1. A pergunta central: "o modelo não previu nada" é um erro?

**Não é um erro. É a teoria funcionando, e é também um resultado conhecido da literatura.** O que falta no PDF é dizer isso com números.

### O que aconteceu

A previsão de origem fixa (esquema 1) fica praticamente plana em torno de $0{,}47\%$ a.m. desde o primeiro mês. No treino (até set/2024), o modelo estimado é $\widehat\phi=0{,}565$, $\widehat\Phi=0{,}109$ e $\widehat\mu=0{,}473$. A previsão é

$$
\widehat y_{T_0+h\mid T_0}-\widehat\mu=\text{(termos que decaem como }0{,}565^h\text{ e }0{,}109^{h/12}\text{)},
$$

e como o último dado do treino ($0{,}48$ em set/2024) já estava colado na média, não havia nada para propagar. **Num processo estacionário, a previsão de muitos passos converge para a média incondicional.** É exatamente isso que a Q7(b) mostra.

### A prova de que o M1 é, na prática, "a média"

Basta acrescentar um benchmark que o enunciado não pede, a **média do treino** ($\widehat y=0{,}470$ para todo $h$):

| Previsor | RMSE | MAE | MASE | Viés (ME) |
|---|---|---|---|---|
| M1, esquema 1 | 0,388 | 0,303 | 0,73 | $-0{,}084$ |
| M1, esquema 2 | 0,410 | 0,298 | 0,72 | $-0{,}027$ |
| Passeio aleatório, esquema 1 | 0,399 | 0,309 | 0,75 | $-0{,}096$ |
| Passeio aleatório, esquema 2 | 0,516 | 0,362 | 0,87 | $+0{,}014$ |
| Sazonal ingênuo, esquema 1 | **0,317** | **0,247** | **0,60** | $+0{,}049$ |
| Sazonal ingênuo, esquema 2 | 0,366 | 0,290 | 0,70 | $+0{,}008$ |
| Média do treino (extra) | 0,397 | 0,308 | 0,74 | $-0{,}086$ |

O MASE usa como escala o erro médio absoluto do sazonal ingênuo dentro do treino (Hyndman e Koehler, 2006). O M1 do esquema 1 erra quase o mesmo que a média histórica ($0{,}388$ contra $0{,}397$). O desvio-padrão da própria série na validação é $0{,}396$. Ou seja, **o conteúdo preditivo do M1 além da média está todo no primeiro ou segundo passo**, e mesmo ali é pequeno.

### Por que isso é um resultado, e não um defeito

1. **É o que a teoria prevê.** Para um ARMA estacionário, o erro de previsão converge para a variância incondicional quando $h$ cresce. Com $\widehat\phi\approx0{,}5$, a memória do AR some em cerca de três meses.
2. **É o que a literatura de inflação encontra.** Atkeson e Ohanian (2001) mostram que, nos EUA, modelos não batem uma regra ingênua para a inflação. Stock e Watson (2007) explicam isso pela queda da parte previsível da inflação. Faust e Wright (2013), no *Handbook of Economic Forecasting*, concluem que os melhores previsores de inflação são as pesquisas de expectativas e benchmarks simples, não modelos univariados. No Brasil, o equivalente é o boletim Focus.
3. **Os erros grandes vêm de choques que nenhum modelo univariado prevê.** O único mês fora do intervalo de 95% é **fev/2025** ($1{,}48\%$), quando a energia elétrica voltou ao normal depois do **bônus de Itaipu** creditado na conta de jan/2025 (mês em que o INPC foi $0{,}00\%$). São preços administrados, decididos fora da dinâmica passada da inflação. Os outros *outliers* da amostra têm a mesma natureza: jun/2018 (greve dos caminhoneiros) e jul–set/2022 (teto do ICMS sobre combustíveis e energia, LC 194/2022).
4. **O esquema 2 piora o M1 por causa desses choques.** Depois de fev/2025, o AR(1) com $\widehat\phi>0$ prevê que a inflação alta continue ($0{,}99$ para mar/2025), mas o choque era transitório e o dado veio $0{,}51$. Um modelo de persistência positiva erra justamente nos choques que se revertem. Por isso o RMSE do M1 no esquema 2 ($0{,}410$) é *maior* que no esquema 1 ($0{,}388$), embora o MAE seja menor ($0{,}298$ contra $0{,}303$): poucos erros grandes dominam o RMSE.

### Uma discussão econômica legítima: a média mudou

O viés é negativo em todos os previsores que puxam para a média do treino ($-0{,}084$ no M1). A média da validação foi $0{,}384\%$ a.m., contra $0{,}470\%$ no treino. As médias anuais da amostra vão de $0{,}17$ (2017) a $0{,}90$ (2015). Isso conversa com uma questão aberta na economia: **a inflação tem média constante ou uma "tendência" que se move?** Stock e Watson (2007) modelam a inflação dos EUA com uma tendência de passeio aleatório. No Brasil, o argumento a favor da média que se move é institucional: a meta caiu de 4,5% a.a. (até 2018) para 3% a.a. (desde 2024). Com meta crível, a média para onde a previsão converge deveria ser a da meta, não a média histórica da amostra.

Isso **não** obriga a mudar o modelo, e o enunciado proíbe mudá-lo. Mas é a discussão que transforma "perdemos para o ingênuo" em uma resposta de pós-graduação. Os testes de raiz unitária rejeitam com folga e o DF-GLS bem especificado também rejeita (ver Q2d abaixo), então $d=0$ continua defensável. O ponto é que, numa janela de 24 meses, a média amostral de 2013–2024 não é a média do regime de 2025–2026.

### As diferenças nem são significativas

Com 24 observações, o teste de Diebold e Mariano (perda quadrática) **não rejeita a igualdade de acurácia** em nenhuma comparação a 5%:

| Comparação | p-valor do DM |
|---|---|
| M1 × sazonal ingênuo, esquema 1 | 0,24 |
| M1 × sazonal ingênuo, esquema 2 | 0,62 |
| M1 × passeio aleatório, esquema 1 | 0,07 |
| M1 × passeio aleatório, esquema 2 | 0,06 |

A conclusão correta para a Q7(f) é então: **o M1 bate o passeio aleatório nos dois esquemas (com significância marginal, a 10%) e perde para o sazonal ingênuo nos dois, mas sem diferença estatisticamente significativa.**

## 2. Erros que precisam ser corrigidos (Q5 a Q7, novos nesta versão)

| Onde | O que o PDF diz | O problema | Correção |
|---|---|---|---|
| Q5(a) | legenda "Verificação da estabilidade e invertibilidade dos modelos candidatos" | a figura é dos **resíduos** do M1, e a legenda é de outra figura | "Diagnóstico dos resíduos do M1" |
| Q5(e) | "os novos coeficientes não são estatisticamente significativos" | o PDF mostra só `coef()`, sem erro-padrão; a afirmação fica sem prova | mostrar `lmtest::coeftest()`: $\widehat\phi_2=0{,}127$ ($t=1{,}61$, $p=0{,}11$) e $\widehat\theta_1=-0{,}175$ ($t=-1{,}40$, $p=0{,}16$). A conclusão se mantém, agora com números. Vale notar que o AIC do vizinho AR(2) ($128{,}08$) é ligeiramente menor que o do M1 ($128{,}65$), mas a diferença é menor que 2 e o BIC prefere o M1 |
| Q6(a) | "a raiz do polinômio MA resultou em $z=-1+0i$" | **erro de sinal**. No R, o MA é $1+\theta B$. Com $\widehat\theta=-1$, o polinômio é $1-z$ e a raiz é $z=+1$. O código `polyroot(c(1, -theta_est))` usa a convenção Box-Jenkins com um coeficiente impresso na convenção do R. A raiz em $+1$ é justamente o fator $(1-B)$ da diferença em excesso | `polyroot(c(1, theta_est))`, raiz $z=+1$: o MA "desfaz" a diferença. O módulo 1 (não invertível) já estava certo |
| Q6(a) | erro-padrão de $\widehat\theta$ igual a $0{,}025$ | com $\widehat\theta$ na fronteira $-1$, a teoria assintótica usual não vale, e esse erro-padrão não tem a interpretação de sempre | uma frase dizendo isso |
| Q6(b) | compara $0{,}1234$ (M1) com $0{,}1241$ e diz "+0,61%", sem interpretar | (i) o $0{,}1234$ não é o $0{,}1211$ da tabela da Q4: o `forecast::Arima` corrige $\widehat\sigma^2$ por graus de liberdade e o `stats::arima` não. Precisa avisar ou usar uma só função. (ii) Falta dizer **por que** a variância quase não sobe: o MA com $\widehat\theta=-1$ absorve a diferença extra | estimar também o SARIMA(1,1,0)(1,0,0) **sem** MA: $\widehat\sigma^2=0{,}144$, cerca de 19% acima do M1, e $\widehat\phi$ troca de sinal ($-0{,}35$). Esse é o custo visível da sobrediferenciação |
| Q6(c) | compara a FAC **dos resíduos** e diz que o pico negativo não aparece | a pergunta é se a **série sobrediferenciada** tem autocorrelação negativa no lag 1. Nos resíduos ela não aparece justamente porque o MA a absorveu | mostrar a FAC de $\Delta y_t$: $\widehat\rho_1=-0{,}34$, fora da banda de $\pm0{,}153$. Esse é o sinal clássico |
| Q6(d) | "aumento expressivo da variância residual" | contradiz o próprio resultado (+0,6%). Também não é verdade em geral: $\operatorname{Var}(\Delta y)=2\gamma_0(1-\rho_1)$, que só supera $\gamma_0$ se $\rho_1<0{,}5$. Aqui $\widehat\rho_1=0{,}52$ e $\operatorname{Var}(\Delta y)=0{,}166<\operatorname{Var}(y)=0{,}172$ | "aumento da variância residual **quando o modelo não inclui o MA que compensa**"; citar o $0{,}144$. Corrigir também o "\*\*" que sobrou no último item |
| Q7(a) | tabelas com `Jan … Dec` e anos 1 a 12 | o `ts()` foi criado sem `start`. O que está rotulado como "Jan" na validação é **out/2024**, e o "Apr 0.00" é jan/2025 | `ts(..., start = c(2013, 1), frequency = 12)` uma vez e `window()` depois. Isso também corrige os eixos "5, 10, 15" e "13, 14" de todos os gráficos |
| Q7(d) | MAPE $=\text{Inf}$, sem comentário | o MAPE divide pelo valor observado, e jan/2025 é $0{,}00$. Com vários meses perto de zero e negativos, ele não serve para esta série mesmo sem o zero | dizer isso e reportar o **MASE** (tabela da seção 1) |
| Q7(e) | tabela só com RMSE | o enunciado pede "as métricas" | RMSE, MAE e MASE na mesma tabela, modelos nas linhas e esquemas nas colunas |
| Q7(e) | `snaive(treino, h = 141)` | o horizonte é 24. O resultado sai certo só porque o `accuracy()` recorta pela interseção das datas | `h = 24` |
| Q7(f) | "**Caso** o modelo paramétrico não tenha superado…" | a resposta fala no condicional, como se não soubesse o resultado da própria tabela | afirmar: bate o RW nos dois esquemas, perde para o SN nos dois, nenhuma diferença significativa (DM) |
| Q7(f) | "no Esquema 2, o Passeio Aleatório impõe uma barreira competitiva elevada" | **contradiz a tabela**: no esquema 2 o RW é o **pior** previsor (0,516) | trocar pelo argumento dos choques transitórios (seção 1, item 4) |
| Q7(f) | "o Sazonal Ingênuo aproveita a forte persistência dos padrões sazonais" | contradiz a Q1, que diz não haver sazonalidade | corrigir a Q1 (ver seção 3). A sazonalidade existe, mas é fraca |
| Q7(g) | só imprime "23 de 24, 95,83%" | falta a resposta: corresponde à nominal? | sim, é compatível. Com 24 observações, o IC de 95% (binomial exato) da cobertura vai de 79% a quase 100%, então o teste tem pouco poder. O único mês fora é fev/2025 (Itaipu). Notar também que os intervalos são largos (cerca de $\pm0{,}8$ p.p.) porque convergem para a variância incondicional, e que o JB rejeitou a normalidade em que eles se apoiam |

## 3. Pendências da revisão anterior que continuam no PDF

| Onde | Problema | Correção |
|---|---|---|
| Q1 | "não é possível identificar um padrão sazonal" | a FAC no lag 12 é $0{,}217$, acima da banda de $0{,}153$, e o SAR é significativo ($t=2{,}31$). Sazonalidade fraca, mas presente. Isso precisa casar com a Q3 e a Q7 |
| Q1 | "não há evidência de mudança permanente de nível" | correto quanto a mudança *permanente*, mas a média anual vai de $0{,}17$ a $0{,}90$. Dizer que há **mudanças temporárias de patamar** e ligar com a seção 1 |
| Q2(a) | "($p<0{,}01$)" e nenhum p-valor | o `urca` não dá p-valor do $\tau$. Escrever "rejeita a 1% pelo valor crítico", ou tirar p-valores de MacKinnon (`tseries::adf.test` ou `fUnitRoots::punitroot`) |
| Q2(a) | DF-I (sem constante) usado como evidência | essa especificação está errada para uma série de média $0{,}46$. Deve ser citado só como especificação descartada |
| Q2(a) e (b) | "confirma de forma definitiva", "com total segurança" | teste não confirma $H_0$ nem dá certeza. "Os testes convergem para…" |
| Q2(b) | as estatísticas $\phi_1,\phi_2,\phi_3$ aparecem e não são lidas | são elas que justificam os termos determinísticos: $\phi_3=13{,}54>8{,}43$, $\phi_2=9{,}03>6{,}22$, $\phi_1=13{,}30>6{,}52$ |
| Q2(c) | "estritamente estacionária" | os testes falam de estacionariedade **fraca** |
| Q2(c) | não repete os testes na série diferenciada | o enunciado pede. Rodar ADF/PP/KPSS em $\Delta y$ (rejeitam com folga). Isso também prepara a Q6 |
| Q2(d) | "o DF-GLS pode confundir a alta persistência… por isso divergiu" | **é o contrário**: o DF-GLS tem *mais* poder. O problema é `lag.max = 12`, que no `urca` **fixa** 12 defasagens, sem seleção. Com 1 defasagem (a que o BIC escolheu no ADF): $-3{,}65$; com 2: $-3{,}49$; com 4: $-2{,}93$. Todos rejeitam (crítico $-1{,}94$). Só com 12 dá $-1{,}21$ |
| Q2(d) | não diz se é DS ou TS | dizer explicitamente: a variação **não é nem DS nem TS**. É estacionária em torno de uma média constante (tendência não significativa: $t=-0{,}745$ no ADF, $Z_{\tau\beta}=-0{,}68$ no PP) |
| Q3(b) | não responde sobre $2s$, $3s$ e $s\pm1$ | FAC: lag 11 $=0{,}190$, lag 12 $=0{,}217$, lag 13 $=0{,}095$, lag 24 $=-0{,}015$, lag 36 $=0{,}035$. Pico em 11–12, nada em 24 e 36: o padrão é de **SMA(1) ou SAR(1) fraco**, não de raiz sazonal |
| Q4(a) | "Intercepto" | no `arima()`, é a **média** $\mu=0{,}461$. A constante é $c=\mu(1-\phi)(1-\Phi)=0{,}187$ |
| Q4(a) | tabela digitada à mão | gerar a tabela no código (como já é feito com `metricas`) |
| Q4(d) | "a variância dos resíduos não é contada" | **errado**: $k=(AIC+2\ln L)/2=(128{,}65-120{,}66)/2=4$, ou seja, 3 coeficientes mais $\widehat\sigma^2$. O `logLik(modelo1)` mostra `df = 4`. O texto do PDF, aliás, parece ser o enunciado colado no lugar da resposta |
| Q4(e) | "não se verifica qualquer divergência" | certo, mas $\Delta\text{AIC}=0{,}46$ entre M1 e M2: são praticamente equivalentes. E o M3 tem SAR e SMA não significativos com erros-padrão enormes (0,57 e 0,61), sintoma de **fatores quase comuns** |
| Q4(f) | títulos "AR Roots" repetidos, gráfico do M1 chamado de "MA Roots", e **nenhuma conclusão** | cada `plot()` do `forecast` já desenha AR e MA. São **raízes inversas**: dentro do círculo significa raiz fora, logo estacionário e invertível. Uma chamada por modelo e uma frase de conclusão |

## 4. Forma e reprodutibilidade

- **Código cortado na margem** (p. 13, 14, 22, 23, 27, 31). O corretor não consegue ler a linha. No Quarto, `format: pdf` com `include-in-header` contendo `\usepackage{fvextra}` e `\DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,commandchars=\\\{\}}`, ou quebrar as linhas à mão.
- **Numeração duplicada** nos títulos ("1 1. Preparação…"). Ou se tira o número do texto, ou se desliga `number-sections`.
- **Caminho e pacotes**: `read_excel("inpc_13_a_26.xlsx")` precisa do arquivo junto; o `library(forecast)` está duplicado; o `library(seasonal)` não é usado e exige o X-13.
- **Mistura de `arima()` e `Arima()`**: elas dão $\widehat\sigma^2$ diferentes (0,1211 e 0,1234). Usar uma só.
- **Entrega**: o `sessionInfo()` continua faltando.

## 5. Ordem sugerida de trabalho

1. **Q7(f) e Q7(g)**: reescrever com os números (seção 1). É onde está a pergunta de vocês e onde o texto atual contradiz a própria tabela.
2. **Q4(d) e Q6(a)**: são erros factuais, um de conceito e um de sinal. A correção é de uma linha cada.
3. **Q2(d)**: o argumento do DF-GLS está invertido, e a correção (`lag.max` menor) reforça a conclusão $d=0$.
4. **Q1 × Q3 × Q7**: tornar a sazonalidade coerente nas três questões.
5. **Q5(e), Q6(b), Q6(c), Q7(d), Q7(e)**: acrescentar os números que faltam.
6. Forma: `start` no `ts()`, quebra de linha no código, legendas.

## Referências

- Atkeson, A.; Ohanian, L. E. (2001). Are Phillips curves useful for forecasting inflation? *Federal Reserve Bank of Minneapolis Quarterly Review*, 25(1), 2–11.
- Diebold, F. X.; Mariano, R. S. (1995). Comparing predictive accuracy. *Journal of Business & Economic Statistics*, 13(3), 253–263.
- Faust, J.; Wright, J. H. (2013). Forecasting inflation. In: Elliott, G.; Timmermann, A. (orgs.). *Handbook of Economic Forecasting*, v. 2A. Elsevier, p. 2–56.
- Hyndman, R. J.; Koehler, A. B. (2006). Another look at measures of forecast accuracy. *International Journal of Forecasting*, 22(4), 679–688.
- Stock, J. H.; Watson, M. W. (2007). Why has U.S. inflation become harder to forecast? *Journal of Money, Credit and Banking*, 39(s1), 3–33.
- Para a discussão de $d$ (inflação I(0) ou I(1)), ver [referencias_inpc.md](../referencias_inpc.md).
