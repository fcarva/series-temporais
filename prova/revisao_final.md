---
title: "Revisão final — a manhã da prova, pelo critério do quadro"
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
  - Revisão final da P1
---

# Revisão final: a manhã da prova

Esta é a síntese de tudo o que foi feito: o guia, a folha do que cai, a auditoria, os simulados, as correções e o log. Está organizada **pelo critério do quadro do professor**: quatro questões de 2,5 pontos. Não há matéria nova aqui. Cada molde é uma conta que você já fez pelo menos uma vez.

## 1. Como usar

- **Agora: dormir.** O que não entrou até aqui não entra em uma noite sem sono, e o sono é quando a revisão se fixa.
- **De manhã: 45 minutos**, no roteiro da seção 5, **cobrindo e tentando**: tampe o molde, escreva no papel, confira linha a linha.
- **Na ida para a prova:** só o [cartão de uma página](../caderno/pdf/caderno_cartao_prova.pdf).

## 2. As quatro questões do quadro

### Questão A — processos: passeio, $E$, $V$, $\operatorname{Cov}$ e $z_3=z_1+2z_2$

**O que o professor cobra:** "processos estocásticos, RW, $z_3=z_1+2z_2$, identificar $E(\cdot)$, $V(\cdot)$ e $\operatorname{Cov}(\cdot,\cdot)$". É a lista, Q1 a Q3.

**O que garante o ponto:**
- a soma telescópica escrita até $y_t=y_0+\sum u_s$;
- o $E$ em **toda** linha de momento;
- a soma dupla, com só $i=j$ sobrando;
- os choques comuns na covariância;
- em $z_3$: os quatro termos, "não correlacionados" citado e o **4** de $2^2$;
- os números pedidos **calculados**;
- a classe pela FAC que corta.

**O seu erro que já apareceu:**
- o $E$ sumiu (S1);
- os números com $t=36$ ficaram sem calcular (S5);
- o $\rho_1$ foi dividido pelo $\gamma_0$ de outro processo (S5).

**O molde**, com os números do Simulado 05:

$$
\begin{aligned}
\text{(1)}\quad & y_t=y_0+\textstyle\sum_{s=1}^{t}u_s && [\text{telescópica}]\\
\text{(2)}\quad & V(y_t)=E\big((\textstyle\sum u_s)^2\big)=t\sigma^2=1{,}5t;\ \ V(y_{36})=54 && [\text{RB: só } i=j]\\
\text{(3)}\quad & \operatorname{Cov}(y_t,y_{t-k})=(t-k)\sigma^2;\ \ \operatorname{Cov}(y_{36},y_{25})=37{,}5 && [\text{choques comuns}]\\
\text{(4)}\quad & \gamma_3(k)=\gamma_1(k)+4\gamma_2(k):\ 5{,}6;\ -1{,}7;\ 0{,}8;\ 0 && [\text{cruzados zeram}]\\
\text{(5)}\quad & \rho_1=-1{,}7/5{,}6=-0{,}3036;\ \ \rho_2=0{,}1429 && [\div\gamma_0 \text{ de } z_3]
\end{aligned}
$$

**Frase de fecho:** "a variância depende de $t$: não estacionário"; e "$\gamma_3$ não depende de $t$ e a FAC corta depois de 2: estacionário, **MA(2)**".

**Onde aprofundar:** [guia, QT1 e QT2](nao_posso_errar.md), [Q1 comentada](../lista_comentada/q01.md) e [Q3 comentada](../lista_comentada/q03.md).

### Questão B — ARMA: estacionário e montar a FAC

**O que o professor cobra:** "ARMA, verificar se é estacionário, $(1-\phi B)Y_t=u_t$; FAC e FACP; montar a FAC, com o desenho e a conta, $\gamma_0,\gamma_1,\rho_1,\rho_2,\rho_3$". É a lista, Q5 e Q6.

**O que garante o ponto:**
- a raiz de **um número** $x$, com o sinal;
- $\gamma_0=E(y_t^2)$;
- a multiplicação por $y_t$ e por $y_{t-1}$, com a causalidade;
- o sistema resolvido;
- os três $\rho$ escritos;
- **o desenho**, com as barras numeradas;
- a FACP.

**O seu erro que já apareceu:**
- $\gamma_0$ confundido com uma covariância (S1);
- a raiz com a série e o sinal trocado (S5);
- $E(\varepsilon_ty_{t-1})$ tratado como diferente de zero (S5);
- AR no lugar de MA na identificação (S5).

**O molde**, com o AR(1) $(1+0{,}5B)y_t=u_t$ e $\sigma^2=3$:

$$
\begin{aligned}
\text{(1)}\quad & y_t=-0{,}5y_{t-1}+u_t;\ \ 1+0{,}5x=0\Rightarrow x=-2,\ \lvert x\rvert\gt1 && [\text{estacionário}]\\
\text{(2)}\quad & \gamma_0=-0{,}5\gamma_1+E(u_ty_t)=-0{,}5\gamma_1+3 && [\times y_t]\\
\text{(3)}\quad & \gamma_1=-0{,}5\gamma_0+E(u_ty_{t-1})=-0{,}5\gamma_0+0 && [\times y_{t-1};\ \text{caus.}]\\
\text{(4)}\quad & \gamma_0=0{,}25\gamma_0+3\Rightarrow\gamma_0=4;\ \ \gamma_1=-2 && [\text{sistema}]\\
\text{(5)}\quad & \rho_k=\phi^k:\ -0{,}5;\ 0{,}25;\ -0{,}125 && [\rho_1=\phi \text{ confere}]\\
\text{(6)}\quad & \text{FAC alterna e decai; FACP: um pico em 1} && [\text{AR corta na FACP}]
\end{aligned}
$$

**Frase de fecho:** "raiz $-2$, fora do círculo: estacionário. $\rho_k=(-0{,}5)^k$: a FAC alterna e decai, e a FACP corta em 1, a assinatura de um AR(1)."

**O ARMA(1,1)**, se cair: os quatro movimentos, $\times a_t$, $\times a_{t-1}$, $\times z_t$, $\times z_{t-1}$. No S1, com $\phi=0{,}6$ e $\theta=0{,}3$, dá $\gamma_0=1{,}1406$, $\gamma_1=0{,}3844$ e $\rho_1=0{,}337$. **Onde aprofundar:** [folha, §2](o_que_cai.md), [guia, QT3 e QT4](nao_posso_errar.md) e [Q6 comentada](../lista_comentada/q06.md).

### Questão C — SARIMA: o desenho sazonal e a equação de previsão

**O que o professor cobra:** "SMA(1) com $s=4$: FAC e FACP desenhadas"; e "equação de previsão". É a lista, Q11, Q12 e Q16.

**O que garante o ponto:**
- ler **SAR ou SMA** antes de desenhar;
- os quatro termos do produto;
- os zeros **justificados**;
- os dois desenhos;
- os produtos de polinômios expandidos;
- o modelo escrito na data futura;
- as três regras;
- **o sinal trocado ao isolar**;
- até que $h$ vão os resíduos.

**O seu erro que já apareceu:**
- a Q3 em branco (S5);
- na refação, o $+y_{t-5}$ ficou com sinal errado ao isolar, e o 0,4 sumiu de $\widehat a_T$.

**O molde**, com o SMA(1)$_4$ $y_t=(1-0{,}8B^4)a_t$ e o SARIMA$(0,1,1)(0,1,1)_4$ com $\theta=0{,}4$ e $\Theta=0{,}6$:

$$
\begin{aligned}
\text{(1)}\quad & \gamma_k=E\big((a_t-0{,}8a_{t-4})(a_{t-k}-0{,}8a_{t-4-k})\big) && [\text{4 termos}]\\
\text{(2)}\quad & \gamma_0=1{,}64;\ \ \gamma_4=-0{,}8;\ \ \text{zero no resto};\ \ \rho_4=-0{,}4878 && [\text{datas que casam}]\\
\text{(3)}\quad & \text{FAC: um pico em 4; FACP: } -0{,}4878;\ -0{,}3123;\ -0{,}2215 && [\text{em 4, 8, 12}]\\
\text{(4)}\quad & (1-B)(1-B^4)=1-B-B^4+B^5;\ \ \text{MA: }1-0{,}4B-0{,}6B^4+0{,}24B^5 && [\text{distributiva}]\\
\text{(5)}\quad & y_t=y_{t-1}+y_{t-4}-y_{t-5}+a_t-0{,}4a_{t-1}-0{,}6a_{t-4}+0{,}24a_{t-5} && [\text{isola: troca o sinal}]\\
\text{(6)}\quad & \widehat y_T(1)=y_T+y_{T-3}-y_{T-4}-0{,}4\widehat a_T-0{,}6\widehat a_{T-3}+0{,}24\widehat a_{T-4} && [a_{T+1}\to0]\\
\text{(7)}\quad & \widehat y_T(2)=\widehat y_T(1)+y_{T-2}-y_{T-3}-0{,}6\widehat a_{T-2}+0{,}24\widehat a_{T-3} && [y_{T+1}\to\widehat y(1)]
\end{aligned}
$$

**As duas trocas que a lista faz:**
- **SAR(1)$_4$ (Q11)**, $y_t=\Phi y_{t-4}+\varepsilon_t$: é o espelho do SMA. A FAC decai em 4, 8, 12 ($\rho_4=0{,}7$ e $\rho_8=0{,}49$, com $\Phi=0{,}7$), e a FACP tem um pico só, em 4.
- **SARIMA$(1,1,0)(0,1,1)_4$ (Q12):** o lado AR tem três polinômios, e os resíduos **param em $h=4$**. No $(0,1,1)(0,1,1)_4$, eles vão até $h=5$, por causa do termo cruzado. As perdas são $d+sD=5$ nos dois.

**Frase de fecho:** "FAC com um pico só em $s$ e FACP decaindo em $s,2s,3s$: SMA(1)$_s$"; e "os resíduos entram na previsão até a maior defasagem do MA".

**Onde aprofundar:** [folha, §4 e §5](o_que_cai.md), [Q11 comentada](../lista_comentada/q11.md) e [Q12 comentada](../lista_comentada/q12.md).

### Questão D — ciclo de modelagem e análise

**O que o professor cobra:** "ciclo de modelagem"; "analisar RMSE, MAPE, BIC e AIC" (para interpretar); e, falado em aula, a ordem pela FAC e o Dickey-Fuller. É a lista, Q10, Q14 e Q16.

**O que garante o ponto:**
- as quatro etapas, **I, E, D, P**, com a ferramenta de cada uma, e a seta de volta;
- em cada critério, quem vence e **por quanto**;
- a regra do 2;
- dentro × fora da amostra;
- no Dickey-Fuller, a cadeia a partir do modelo 3 e a regra do $\tau$.

**O seu erro que já apareceu:**
- o ciclo foi confundido com o Dickey-Fuller (S5);
- a tabela ficou em branco (S5);
- a regra do $\tau$ foi invertida, e o $\phi_3$ foi comparado com o crítico do $\tau$ (S5).

**O molde:**

$$
\begin{aligned}
\text{(1)}\quad & \textbf{I}\text{dentificação: DF para o } d;\ \text{FAC e FACP para } p,q && [\text{etapa 1}]\\
\text{(2)}\quad & \textbf{E}\text{stimação: MV; AIC e BIC escolhem} && [\text{etapa 2}]\\
\text{(3)}\quad & \textbf{D}\text{iagnóstico: resíduos RB; Ljung-Box} && [\text{falhou: volta a I}]\\
\text{(4)}\quad & \textbf{P}\text{revisão: RMSE e MAPE fora da amostra} && [\text{etapa 4}]\\
\text{(5)}\quad & \Delta AIC=0{,}6\lt2:\ \text{empate};\ \ \Delta BIC=2{,}2:\ \text{BIC prefere A} && [\text{regra do 2}]\\
\text{(6)}\quad & \tau\lt\text{crítico}\Rightarrow\text{rejeita};\ \ \phi\gt\text{o próprio crítico}\Rightarrow\text{rejeita} && [\text{cadeia do DF}]\\
\text{(7)}\quad & \text{banda}=2/\sqrt T=0{,}2 \text{ com } T=100;\ \text{conta as barras até o corte} && [\text{ordem pela FAC}]
\end{aligned}
$$

**O Dickey-Fuller**, com os críticos a 5% para $T=100$:
- modelo 3: $\tau_\tau=-3{,}45$ e $\phi_3=6{,}49$;
- modelo 2: $\tau_\mu=-2{,}89$ e $\phi_1=4{,}71$;
- modelo 1: $\tau=-1{,}95$.

Pare no primeiro "rejeita". Se ficou raiz unitária, diferencie e repita.

**Frase de fecho:** "escolho o modelo A: o BIC o prefere, o AIC empata e ele tem o menor erro fora da amostra"; e "como $\tau$ é maior que o crítico, não rejeito: há raiz unitária, e a série deve ser diferenciada".

**Onde aprofundar:** [folha, §6 a §10](o_que_cai.md), [Q14 comentada](../lista_comentada/q14.md) e [Q10 comentada](../lista_comentada/q10.md).

## 3. Os 10 erros que você já cometeu

1. **$\gamma_0$ confundido com uma covariância.** **Regra:** $\gamma_0=E(y_t^2)$ é a variância; $\gamma_1=E(y_ty_{t-1})$.
2. **A raiz escrita com a série, e com o sinal trocado.** **Regra:** $\phi(x)=0$ com $x$ um número; $1+0{,}5x=0\Rightarrow x=-2$.
3. **O $E$ sumiu de uma linha de momento.** **Regra:** escreva $E(\cdot)$ em toda linha de variância e de covariância.
4. **O $\rho$ dividido pelo $\gamma_0$ errado.** **Regra:** $\rho_k=\gamma_k/\gamma_0$ do mesmo processo; $\lvert\rho\rvert\le1$; num AR(1), $\rho_1=\phi$.
5. **O choque de hoje correlacionado com o $y$ de ontem.** **Regra:** um choque mais novo que o $y$ dá esperança zero: $E(\varepsilon_ty_{t-k})=0$ para $k\ge1$.
6. **AR e MA trocados na identificação.** **Regra:** AR corta na FACP; MA corta na FAC; a ordem é a última barra fora da banda.
7. **A regra do Dickey-Fuller invertida.** **Regra:** o $\tau$ menor (mais negativo) que o crítico rejeita; cada $\phi$ se compara com o próprio crítico e rejeita se for maior.
8. **O sinal esquecido ao isolar.** **Regra:** um termo que passa de lado troca de sinal; depois, confira cada coeficiente, como o 0,4 de $\widehat a_T$.
9. **Item sem frase de fecho.** **Regra:** feche cada item com o que o verbo pede: estacionário ou não; a classe; a decisão.
10. **Tempo mal dividido.** **Regra:** 15 minutos por questão; os itens curtos de todas as questões primeiro; nenhuma questão em branco.

## 4. Na prova: a ordem e as cinco conferências

**A ordem:**
1. **3 minutos de leitura**, marcando:
   - o sinal do MA ($1-\theta B$ da lista ou $1+\theta L$ dos slides);
   - o $T$ e o $s$;
   - se é **SAR ou SMA**;
   - o que cada verbo pede.
2. **Os itens curtos de todas as questões:** raízes, perdas e parâmetros, a leitura da tabela de critérios, as previsões de um passo.
3. **As derivações**, da mais curta para a mais longa.
4. **A frase de fecho** em cada item.

**As cinco conferências de 10 segundos:**
1. Todo $\rho$ tem $\lvert\rho\rvert\le1$.
2. Num AR(1), $\rho_1=\phi$.
3. Nas raízes de grau 2, Vieta: a soma é $-b/a$ e o produto é $c/a$.
4. Ao isolar $y_t$, cada termo que mudou de lado trocou de sinal.
5. O $\tau$ do Dickey-Fuller, posto na reta: à esquerda do crítico, rejeita.

## 5. O roteiro da manhã e as dicas de revisão

| Tempo | O quê |
|---|---|
| 5 min | os 10 erros da seção 3, lendo só as regras |
| 10 min | tampar e refazer o molde B: o AR(1) com a FAC e o desenho |
| 10 min | tampar e refazer o molde C: o SMA com os quatro termos e a previsão, **conferindo o sinal ao isolar** |
| 10 min | I, E, D, P de memória, e o Dickey-Fuller nos críticos |
| 10 min | as frases de fecho das quatro questões, em voz baixa |

**As dicas de revisão:**
- **Recuperar, não reler.** Escrever de memória e conferir fixa muito mais do que ler de novo.
- **Nada de matéria nova** nem de simulado inteiro hoje. O que você já tem basta para os 10 pontos.
- **Errou um molde?** Leia só a linha errada e o sentido dela na folha. Não recomece tudo.
- **Café da manhã e água.** Chegue com 15 minutos de folga, levando só o [cartão](../caderno/pdf/caderno_cartao_prova.pdf).
- **Na prova, travou num item?** Escreva a definição, o molde e a frase de fecho, e siga em frente. Esse esqueleto já vale parte do ponto.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s5_q1_var | 54 |
| pv_s5_q1_cov | 37,5 |
| pv_s5_q1_g0 | 5,6 |
| pv_s5_q1_g1 | -1,7 |
| pv_s5_q1_g2 | 0,8 |
| pv_s5_q1_rho1 | -0,3036 |
| pv_s5_q1_rho2 | 0,1429 |
| pv_s5_q2_raiz | -2 |
| pv_s5_q2_g0 | 4 |
| pv_s5_q2_g1 | -2 |
| pv_s5_q2_rho1 | -0,5 |
| pv_s5_q2_rho2 | 0,25 |
| pv_s5_q2_rho3 | -0,125 |
| pv_s1_q2_g0 | 1,1406 |
| pv_s1_q2_g1 | 0,3844 |
| pv_s1_q2_rho1 | 0,337 |
| pv_s5_q3_g0 | 1,64 |
| pv_s5_q3_g4 | -0,8 |
| pv_s5_q3_rho4 | -0,4878 |
| pv_s5_q3_facp4 | -0,4878 |
| pv_s5_q3_facp8 | -0,3123 |
| pv_s5_q3_facp12 | -0,2215 |
| pv_s5_q3_cruzado | 0,24 |
| pv_s5_q3_coef_y5 | -1 |
| pv_s5_q3_ma_a1 | -0,4 |
| pv_s5_q3_h_max_res | 5 |
| lc_q11_rho4 | 0,7 |
| lc_q11_rho8 | 0,49 |
| lc_q12_perda | 5 |
| pv_s5_q4_daic | 0,6 |
| pv_s5_q4_dbic | 2,2 |
| pv_oc_banda100 | 0,2 |
| pv_df_tau3_5 | -3,45 |
| pv_df_phi3_5 | 6,49 |
| pv_df_tau2_5 | -2,89 |
| pv_df_phi1_5 | 4,71 |
| pv_df_tau1_5 | -1,95 |
-->
