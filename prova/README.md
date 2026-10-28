---
title: "Prova de 05/11 — guia de treino"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
prova: "05/11/2026"
lista: LST
status: verificado
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Guia da prova de séries temporais
---

# Prova de 05/11/2026: guia de treino

O que se sabe da prova: **5 ou 6 questões, de 1h50 a 2h, sem consulta, tiradas da lista** "Processos ARMA, ARIMA e SARIMA" (`LST`). A aposta é **uma questão por bloco da lista**, com números e torções novos. Este guia junta quatro coisas:
1. o mapa de cada bloco para a resolução, a demonstração e o livro;
2. a estratégia de tempo;
3. as lições da P1 de Econometria I, traduzidas para séries temporais;
4. o plano dos 8 dias até a prova.

| Arquivo | Para quê |
|---|---|
| volume único da P1 | **o PDF para imprimir**, `caderno_p1_completo.pdf`, na pasta `caderno/pdf/`: os seis blocos (apostila, folha à mão, comentadas, banco), os simulados e os gabaritos, o log e o formulário |
| [apostila](../apostila/README.md) | **um capítulo por bloco da lista**: teoria com página do slide, demonstrações linha a linha, exemplo em R, perguntas em cadeia, diálogo e imagens; leia o capítulo antes de fazer as questões do bloco |
| [lista comentada](../lista_comentada/README.md) | **as 16 questões da lista, passo a passo, na notação dos slides**, com o caderno corrigido: comece por aqui |
| [Q2 e Q6 à mão](../lista_comentada/a_mao_q02_q06.md) | as duas questões escolhidas para treinar no papel, linha a linha, no formato de caderno |
| [banco.md](banco.md) | as 16 questões da lista em **variações** curtas com resposta: o treino diário |
| [simulado_01.md](simulado_01.md) · [gabarito](simulado_01_gabarito.md) | próximo da lista, para calibrar o tempo |
| [simulado_02.md](simulado_02.md) · [gabarito](simulado_02_gabarito.md) | as torções: sinal positivo, AR(2), sazonal trimestral |
| [simulado_03.md](simulado_03.md) · [gabarito](simulado_03_gabarito.md) | integrador: V ou F, previsão numérica de SARIMA, identificação |
| [log_erros.md](log_erros.md) | registro dos erros com revisão em +1, +3 e +7 dias |
| [prova.R](prova.R) | todos os números dos simulados e do banco (id `pv`) |
| [formulário](../formulario/formulario.md) | todas as fórmulas |

## 1. O mapa da prova

| Bloco (questões da lista) | O que pode cair | Resolução e demonstrações | Livros |
|---|---|---|---|
| 1. Processos e momentos (Q1–Q4) | momentos de passeio com drift e com tendência; soma de processos e FAC; Wold | [01_lista](../01_processos_estacionariedade/01_lista.md), D01.1–D01.4 | ENDERS cap. 4; HAMILTON cap. 3–4; MAT |
| 2. AR, MA e ARMA (Q5–Q8) | raízes, fator comum, $\psi_j$ e $\pi_j$; $\gamma_k$ do ARMA(1,1); Yule-Walker; V ou F | [02_lista](../02_arma/02_lista.md), D02.1–D02.5 | ENDERS cap. 2; HAMILTON cap. 3; BJRL cap. 3 |
| 3. Integrados, ARIMA e SARIMA (Q9–Q12) | sobrediferenciação; DS × TS; SAR e AR restrito; previsão de SARIMA | [03_lista](../03_arima_sarima/03_lista.md), D03.1–D03.4 | ENDERS cap. 2 e 4; BJRL cap. 4 e 9; MAT |
| 4. Estimação e seleção (Q13–Q14) | MV condicional = MQO; AIC e BIC com $k$ incluindo $\sigma^2$ | [04_lista](../04_estimacao_selecao/04_lista.md), D04.1 | HAMILTON cap. 5; AU02 |
| 5. Previsão (Q15) | previsor ótimo; erro MA($h-1$); intervalo; SES | [05_lista](../05_previsao/05_lista.md), D05.1 | HAMILTON cap. 4; BJRL cap. 5 |
| 6. Aplicação (Q16) | escrever o SARIMA, contar parâmetros, FAC de $w_t$, escolher entre modelos | [06_lista](../06_aplicacao_sarima/06_lista.md) | BJRL cap. 9; AU03 |

> [!IMPORTANT]
> **Notação: a do professor, que é a da lista**
> - Operador $B$; $a_t$, $\varepsilon_t$, $u_t\sim RB(0,\sigma^2)$; $\gamma_k$, $\rho_k$, $\phi_{kk}$; $\psi_j$, $\pi_j$; $y_{T+h\mid T}=E(y_{T+h}\mid\mathcal F_T)$.
> - **MA de Box-Jenkins**, $\theta(B)=1-\theta_1B-\cdots$, em quase toda a lista.
> - **Sinal positivo**, $1+\theta_1L+\cdots$, na Q8 e nos slides (AU02).
>
> Primeira linha de toda resposta com MA: "convenção: BJ" ou "convenção: sinal positivo". Ver [CONVENCOES](../CONVENCOES.md) §2.

## 2. Estratégia no dia

Com 110 minutos e 10 pontos, cada ponto vale **11 minutos**: uma questão de 1,5 merece até 16 minutos, e uma de 2,0, até 22.

1. **Leitura (3 min).** Percorra a prova e marque, em cada questão, a convenção do MA, o $T$, o $s$ e os valores críticos dados.
2. **Contas curtas primeiro (≈25 min).** AIC e BIC, observações perdidas, raízes, $\psi_1$ a $\psi_3$, $\gamma_0$ de fórmula pronta, previsões de 1 a 3 passos. São os pontos mais baratos, e foi justamente o que ficou em branco na P1 de Econometria I.
3. **Derivações (≈70 min), da mais curta para a mais longa.** Momentos do passeio → FAC de soma → ARMA(1,1) → previsor ótimo → previsão de SARIMA.
4. **Revisão (10 min).** Sinal do MA, $\psi_0=1$, $k$ com $\sigma^2$, a frase de conclusão de cada item.
5. **Se faltar tempo:** escreva a fórmula geral e a estrutura da conta. A rubrica dá ponto por passo.

### O que cada verbo pede

| Verbo | O que precisa aparecer |
|---|---|
| **Calcule** | fórmula geral → números → resultado com unidade ou interpretação |
| **Mostre / demonstre** | hipóteses usadas, uma justificativa por linha ([RB], estacionariedade, causalidade, LEI) e **a frase final com o que se pediu** |
| **Verifique** (estacionariedade, invertibilidade) | raízes ou desigualdades → "estão fora do círculo" → **"logo, é estacionário"** |
| **Discuta / compare** | duas ou três consequências concretas: estimação, previsão, inferência |
| **Julgue (V ou F)** | a conta que decide; "V" sem conta vale zero |
| **Identifique / proponha** | o padrão da FAC e da FACP que leva ao modelo e quantos parâmetros ele tem |

## 3. Os erros da P1 de Econometria I e o equivalente aqui

Na P1 de Econometria I (09/10/2026), os pontos se perderam na **execução**, não no conceito. Ver o log em `econometria/provas/log_erros.md` e o mapa da prova em `econometria/provas/p1_2026_2/README.md`. Cerca de 2,5 pontos ficaram em contas de uma linha deixadas em branco, e mais pontos em demonstrações que pararam antes da conclusão. Cada erro tem um gêmeo nesta prova:

| Erro na P1 de Econometria I | Causa | Onde reaparece aqui | Regra para 05/11 |
|---|---|---|---|
| Q1, Q3c e Q4b em branco: matriz diagonal, $F$ de uma linha, $340/85$ | **T** tempo | AIC e BIC (Q14), observações perdidas $d+sD$ (Q12, Q16), raízes de $\phi(z)$ e $\theta(z)$, $\psi_1$ a $\psi_3$, $\widehat\phi=\sum y_ty_{t-1}/\sum y_{t-1}^2$ | **fazer primeiro** todo item de 1 a 3 linhas de conta |
| Q2d: efeito marginal 4,5% sem o termo $2\beta_3EXP$ | **A** número sem fórmula | $\rho_1$ do MA(1) com o sinal da convenção errada; $\gamma_0$ do ARMA(1,1) sem o termo $-2\phi\theta$; $\operatorname{Var}(e_T(h))$ sem $\psi_0=1$; $k$ sem $\sigma^2$; $a^2$ em vez de $a$ em $\gamma_{az}$ | **escrever a fórmula geral e a convenção** antes de pôr números |
| Q3c: rejeitou $H_0$ sem calcular $F$ | **E** passo pulado | Ljung-Box sem $\nu=K-p-q-P-Q$; LR sem $2(\ell_1-\ell_0)$ | todo teste em quatro linhas: $H_0$, estatística e distribuição, decisão, conclusão |
| Q5: Gauss-Markov parou em $\sigma^2\mathbf C\mathbf C'$ | **E** sem conclusão | "verifique se é estacionário" sem a frase final; Wold sem $\sum\psi_j^2\lt\infty$; previsor ótimo sem "logo, $g=E(\cdot\mid\mathcal F_T)$"; sobrediferenciação sem "raiz no círculo ⇒ não invertível ⇒ sem AR($\infty$)" | **reler o verbo** do enunciado e fechar com a frase que ele pede |
| Q4a: plim em branco por esquecimento | **E** resultado esquecido | ARMA(1,1): os momentos auxiliares $E(z_ta_t)$ e $E(z_ta_{t-1})$ | refazer de cabeça D02.2 e Q6 até sair em 8 minutos |
| (banco B12) covariância zerada sem citar a hipótese | **H** hipótese | FAC da soma sem "não correlacionados"; $E(a_ty_{t-k})=0$ sem "causalidade"; série geométrica sem $\lvert\phi\rvert\lt1$ | uma justificativa entre colchetes por linha |

> [!CAUTION]
> **As três armadilhas próprias desta prova**
> 1. **Trocar de convenção no meio da prova.** A lista faz isso na Q8. Na BJ, $\psi_1=\phi-\theta$; no sinal positivo, $\psi_1=\phi+\theta$.
> 2. **Confundir FAC e FACP.** No AR(2), $\phi_{22}=\phi_2$, mas $\rho_2\ne\phi_2$. No SAR(1)$_s$, a FAC decai em $s,2s,\dots$, e a FACP tem um pico só.
> 3. **Contar errado o que se perde e o que se estima.** Perdem-se $d+sD$ observações. Os parâmetros são $p+q+P+Q+1$ (o $\sigma^2$), mais a constante só se $d=D=0$ e houver média.

## 4. O mínimo para saber de cor

Tudo o mais se deriva disto em poucas linhas. Formulário completo em [formulario.md](../formulario/formulario.md).

| # | Resultado |
|---|---|
| 1 | Passeio com drift: $E=y_0+ct$, $\operatorname{Var}=t\sigma^2$, $\operatorname{Cov}=(t-k)\sigma^2$ |
| 2 | $\sum_{s=1}^ts=t(t+1)/2$ (drift com tendência; Q2 e Q8) |
| 3 | Processo linear: $\gamma_k=\sigma^2\sum_j\psi_j\psi_{j+k}$ |
| 4 | Estacionário ⇔ raízes de $\phi(z)$ fora do círculo; invertível ⇔ raízes de $\theta(z)$ fora |
| 5 | AR(2): $\phi_1+\phi_2\lt1$, $\phi_2-\phi_1\lt1$, $\lvert\phi_2\rvert\lt1$ |
| 6 | MA(1), BJ: $\rho_1=-\theta/(1+\theta^2)$; com sinal positivo, troque o sinal |
| 7 | ARMA(1,1), BJ: $\gamma_0=\frac{1+\theta^2-2\phi\theta}{1-\phi^2}\sigma^2$, $\rho_1=\frac{(1-\phi\theta)(\phi-\theta)}{1+\theta^2-2\phi\theta}$, $\rho_k=\phi\rho_{k-1}$ |
| 8 | Pesos do ARMA(1,1), BJ: $\psi_j=(\phi-\theta)\phi^{j-1}$, $\pi_j=(\phi-\theta)\theta^{j-1}$ |
| 9 | Yule-Walker: $\rho_k=\sum\phi_i\rho_{k-i}$; $\gamma_0=\sigma^2/(1-\sum\phi_i\rho_i)$; $\phi_{22}=\frac{\rho_2-\rho_1^2}{1-\rho_1^2}$ |
| 10 | Sobrediferenciação: $\phi(B)\Delta y=(1-B)\theta(B)\varepsilon$; RB diferenciado tem $\rho_1=-\frac12$; AR(1) diferenciado tem $\rho_1=-\frac{1-\phi}{2}$ |
| 11 | SAR(1)$_s$: $\rho_{ms}=\Phi^m$, zero fora dos múltiplos; $(1-\phi B)(1-\Phi B^s)$ tem o termo $+\phi\Phi B^{s+1}$ |
| 12 | Modelo das companhias aéreas: $\rho_1=\frac{-\theta}{1+\theta^2}$, $\rho_s=\frac{-\Theta}{1+\Theta^2}$, $\rho_{s\pm1}=\frac{\theta\Theta}{(1+\theta^2)(1+\Theta^2)}$ |
| 13 | MV condicional do AR(1) = MQO: $\widehat\phi=\sum y_ty_{t-1}/\sum y_{t-1}^2$ |
| 14 | $AIC=-2\ln L+2k$, $BIC=-2\ln L+k\ln T$ (a AU02 divide por $T$); $LR=2(\ell_1-\ell_0)\sim\chi^2(r)$ |
| 15 | Previsão: $e_T(h)=\sum_{j=0}^{h-1}\psi_ja_{T+h-j}$, $\operatorname{Var}=\sigma^2\sum_{j=0}^{h-1}\psi_j^2$, IC: $y_{T+h\mid T}\pm1{,}96\sqrt{\operatorname{Var}}$ |
| 16 | ARIMA(0,1,1) = SES com $\alpha=1-\theta$ |
| 17 | Ljung-Box: $\nu=K-p-q-P-Q$ |

## 5. Plano até a prova

### Como atacar a lista

1. **Não comece pela Q1. Comece pelo bloco 2 (Q5–Q8).** É o que mais pesa e é a base dos outros: raízes, $\psi$ e $\pi$, $\gamma_k$, Yule-Walker. A ordem é bloco 2 → 1 → 3 → 5 → 4 → 6, a mesma da [apostila](../apostila/README.md).
2. **Por questão, um ciclo de quatro passos**, sem ler a resolução antes:
   1. **Ler e marcar:** a convenção do MA (BJ ou sinal positivo), $s$, $T$ e o verbo de cada item.
   2. **Tentar sozinho, de 10 a 15 minutos, no papel,** mesmo travando. Pergunte-se qual ferramenta resolve (F1–F9).
   3. **Comparar com a folha à mão, linha a linha.** Ache a **primeira linha** em que você divergiu e anote no [log](log_erros.md), com o código.
   4. **No dia seguinte, refazer sem olhar**, usando só a "Versão para a prova" da folha como roteiro.
3. **A apostila serve para destravar, não para ler antes.** Quando travar, leia só a pergunta de abertura e a imagem do capítulo. Faça a cadeia socrática **cobrindo as respostas**. A teoria e as demonstrações gerais ficam para depois da tentativa.
4. **Treine os cinco moldes, não as 16 questões.** Se o molde sai de cabeça, a questão sai.

   | Molde | Questões |
   |---|---|
   | (a) somar de 1 a $t$ (telescópica), depois $E$ e $\operatorname{Var}$ da soma | Q1, Q2, Q8 (II), Q10 (c, d) |
   | (b) multiplicar pelo passado e tirar a esperança | Q3, Q6, Q7, Q8 (I), Q11 |
   | (c) raízes por Bhaskara e pesos por igualdade de coeficientes | Q5, Q6 (c), Q9, Q10 (b), Q11 (c) |
   | (d) esperança condicional com as três regras [F9] | Q12 (c), Q15 |
   | (e) contas de critério: AIC/BIC, LR, Ljung-Box, $d+sD$, parâmetros | Q14, Q16, Q12 (b) |

5. **Q2 e Q6, as questões escolhidas para fazer à mão:** copie a folha completa **uma vez**, depois refaça de cabeça em +1 e +3 dias, cronometrando. Metas: Q2 em até 12 minutos e Q6 em até 15.
6. **O mínimo de cor** (§4): escreva numa folha A4, de memória, a cada dois dias. O que faltar entra no log.
7. **No dia, as lições da P1 de Econometria I** (§3):
   - contas curtas primeiro;
   - fórmula geral e convenção antes dos números;
   - uma justificativa por linha;
   - fechar com a frase que o verbo pede.

### O ciclo de 29/10 a 05/11

Cerca de 2h30 a 3h por dia; os simulados levam 1h50 mais 40 minutos de correção. Revisões do log em +1 e +3 dias. No papel, tudo está no volume único `caderno_p1_completo.pdf`, e o mapa das questões na abertura dá as páginas.

| Dia | Foco | Tarefas |
|---|---|---|
| qui 29/10 | bloco 2 (Q5–Q8) | ciclo dos quatro passos em Q5, Q7 e Q8; **copiar a folha completa da Q6**; cadeia socrática do cap. 2 |
| sex 30/10 | bloco 1 (Q1–Q4) | ciclo em Q1, Q3 e Q4; **copiar a folha completa da Q2**; Q6 de cabeça, cronometrada (+1) |
| sáb 31/10 | blocos 3 e 5 (Q9–Q12, Q15) | ciclo nas cinco questões; Q2 de cabeça (+1); refazer os erros do log de 29/10 (+1) |
| dom 01/11 | diagnóstico | **Simulado 01** cronometrado, correção pela rubrica e log; blocos 4 e 6 (Q13, Q14, Q16) pelo molde (e) |
| seg 02/11 | treino | **Simulado 02** e correção; Q6 de cabeça (+3); refazer os itens do log do S1 (+1) |
| ter 03/11 | treino | **Simulado 03** e correção; Q2 de cabeça (+3); mínimo de cor de memória; refazer as 5 questões que mais aparecem no log |
| qua 04/11 | leve (1h) | só as perguntas das cadeias socráticas e as armadilhas (§3); esqueletos da Q2 e da Q6; **nada novo**; dormir cedo |
| **qui 05/11** | **prova** | 15 minutos antes: o mínimo de cor e a regra de ordem (contas curtas → derivações → revisão) |

Se sobrar tempo num dia, use o [banco](banco.md) do bloco do dia: cada questão tem uma variação curta com resposta.

## Os três simulados

Cada simulado tem 6 questões (uma por bloco), soma 10,0 pontos e cabe em 1h50 com 10 minutos de revisão. Os números não se repetem entre simulados nem com o banco.

| Bloco | Simulado 01 | Simulado 02 | Simulado 03 |
|---|---|---|---|
| 1. Processos | passeio sem drift e soma de processos | processo harmônico; MA(1) com par não invertível | TS × DS |
| 2. ARMA | ARMA(1,1), BJ | AR(2) completo | V ou F do ARMA(1,1) com sinal positivo |
| 3. ARIMA e SARIMA | AR(1) sobrediferenciado | SAR(1)$_4$, AR(5) restrito, ARIMA(1,1,1) | previsão numérica do SARIMA$(1,1,0)(0,1,1)_4$ |
| 4. Estimação | AIC/BIC com $T=200$; MV condicional | AIC/BIC da AU02, LR, MV exata | AIC, BIC e LR entre SARIMA |
| 5. Previsão | AR(1) com média e o previsor ótimo | ARMA(1,1) com sinal positivo; SES | MA(2): previsão e memória |
| 6. Aplicação | modelo das companhias aéreas | SARIMA$(1,0,0)(0,1,1)_{12}$ e Ljung-Box | identificação pela FAC amostral |
