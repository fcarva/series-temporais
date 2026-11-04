---
title: "Simulado 05 — gabarito com rubrica"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: LST
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
  - simulado
aliases:
  - Gabarito do Simulado 05 — séries temporais
---

# Simulado 05 — gabarito

Enunciado em [simulado_05.md](simulado_05.md). Todos os números saem de [prova.R](prova.R). As seções de apoio são as da folha [o que cai](o_que_cai.md) e as questões-tipo do [guia](nao_posso_errar.md).

> [!TIP]
> **Como se corrigir**
> Pontos **por passo**, pelo que está escrito. Desenho sem os números das barras vale metade; número sem o padrão descrito, também. Frase de fecho ausente perde o ponto dela. Cada perda vai para o [log](log_erros.md).

---

## Questão 1 (2,5) — processos

*Origem na lista:* item a): (lista, Q1); item b): (lista, Q3).

### a) Passeio aleatório (1,0)

- Pela soma telescópica, $y_t=y_0+\sum_{s=1}^{t}u_s=\sum_{s=1}^{t}u_s$.
- $E(y_t)=\sum_sE(u_s)=0$ *[F4 na soma finita; RB]*.
- $V(y_t)=E\big((\sum_su_s)^2\big)=\sum_sE(u_s^2)=1{,}5\,t$ *[RB: só $i=j$ sobra]*.
- $\operatorname{Cov}(y_t,y_{t-k})=1{,}5\,(t-k)$ *[os $t-k$ choques comuns]*.
- $V(y_{36})=54$; $\operatorname{Cov}(y_{36},y_{25})=1{,}5\cdot25=37{,}5$; $\operatorname{Corr}=\sqrt{25/36}=0{,}8333$.

**Não é estacionário:** a média é constante, mas a variância $1{,}5t$ depende de $t$.

| Rubrica | Pontos |
|---|---|
| Solução como soma dos choques | 0,2 |
| $E$, $V$ (com o $E$ escrito) e $\operatorname{Cov}$, com as hipóteses | 0,4 |
| Os três números | 0,2 |
| Frase de fecho: não estacionário, pela variância | 0,2 |

### b) Soma de processos (1,5)

$$
\gamma_3(k)=\operatorname{Cov}(z_{1t}+2z_{2t},\ z_{1,t-k}+2z_{2,t-k})=\gamma_1(k)+4\gamma_2(k),
$$

porque **$z_1$ e $z_2$ não são correlacionados**, o que zera os dois termos cruzados.

- $\gamma_3(0)=0{,}8+4(1{,}2)=5{,}6$;
- $\gamma_3(1)=0{,}3+4(-0{,}5)=-1{,}7$;
- $\gamma_3(2)=0+4(0{,}2)=0{,}8$;
- $\gamma_3(3)=0$.

Assim, $\rho_1=-1{,}7/5{,}6=-0{,}3036$ e $\rho_2=0{,}8/5{,}6=0{,}1429$. A FAC **corta** depois da defasagem 2, e nada depende de $t$: **$z_3$ é estacionário e é um MA(2).**

| Rubrica | Pontos |
|---|---|
| Os quatro produtos e os cruzados zerados **citando a hipótese** | 0,4 |
| O fator 4 no $\gamma_2$ | 0,2 |
| Os quatro $\gamma_3(k)$ | 0,4 |
| $\rho_1$ e $\rho_2$ | 0,2 |
| **MA(2)** pelo corte da FAC, e estacionário | 0,3 |

---

## Questão 2 (2,5) — ARMA

*Origem na lista:* item a): (lista, Q5); itens b) a d): (lista, Q6).

### a) Estacionariedade (0,5)

$(1+0{,}5B)y_t=u_t$ é o AR(1) $y_t=-0{,}5y_{t-1}+u_t$: $\phi=-0{,}5$. A raiz é $1+0{,}5x=0\Rightarrow x=-2$, com $\lvert x\rvert=2\gt1$: **estacionário**. O mesmo que $\lvert\phi\rvert\lt1$.

| Rubrica | Pontos |
|---|---|
| Ler $\phi=-0{,}5$ (o sinal!) | 0,2 |
| Raiz $-2$ fora do círculo e a conclusão | 0,3 |

### b) A FAC pela conta (1,0)

- Multiplicando por $y_t$: $\gamma_0=\phi\gamma_1+\sigma^2$; por $y_{t-1}$: $\gamma_1=\phi\gamma_0$ *[caus.]*.
- $\gamma_0=\sigma^2/(1-\phi^2)=3/0{,}75=4$ e $\gamma_1=-0{,}5(4)=-2$.
- $\rho_k=\phi^k$: $\rho_1=-0{,}5$, $\rho_2=0{,}25$, $\rho_3=-0{,}125$.

| Rubrica | Pontos |
|---|---|
| $\gamma_0$ com a fórmula | 0,3 |
| $\gamma_1$ | 0,2 |
| Os três $\rho_k$, com o sinal alternado | 0,5 |

### c) Os desenhos (0,6)

- **FAC:** barras em $-0{,}5$; $0{,}25$; $-0{,}125$; $0{,}0625$; $-0{,}03$: **alterna de sinal e decai** geometricamente.
- **FACP:** **uma barra só**, de $-0{,}5$, em $k=1$, e zero depois: a FACP de um AR(1) corta em 1.

| Rubrica | Pontos |
|---|---|
| FAC alternada e decaindo, com números | 0,3 |
| FACP com um pico negativo em 1 | 0,3 |

### d) Identificação (0,4)

Um **MA(1)**: a FAC de um MA($q$) corta depois de $q$, porque choques a mais de $q$ períodos de distância não se sobrepõem; a FACP de um MA decai.

| Rubrica | Pontos |
|---|---|
| MA(1), com o motivo | 0,4 |

---

## Questão 3 (2,5) — SARIMA

*Origem na lista:* item a): (lista, Q11); item b): (lista, Q12).

### a) O SMA(1)$_4$ (1,2)

- $\gamma_0=(1+\Theta^2)\sigma^2=1{,}64$ e $\gamma_4=E\big((a_t-0{,}8a_{t-4})(a_{t-4}-0{,}8a_{t-8})\big)=-0{,}8\sigma^2=-0{,}8$.
- $\rho_4=-0{,}8/1{,}64=-0{,}4878$.
- **Todas as outras autocorrelações são zero**: os dois choques do modelo só coincidem a 4 períodos de distância.
- **FAC:** uma barra só, de $-0{,}4878$, em $k=4$.
- **FACP:** barras em 4, 8 e 12, de $-0{,}4878$, $-0{,}3123$ e $-0{,}2215$, decaindo, e zero no resto.

| Rubrica | Pontos |
|---|---|
| $\gamma_0$ e $\gamma_4$ | 0,3 |
| $\rho_4$ e os zeros, com o motivo | 0,3 |
| FAC desenhada: pico só em 4 | 0,3 |
| FACP desenhada: 4, 8 e 12, decaindo | 0,3 |

### b) A equação de previsão (1,3)

Expandindo $(1-B)(1-B^4)y_t=(1-0{,}4B)(1-0{,}6B^4)a_t$:

$$
y_t=y_{t-1}+y_{t-4}-y_{t-5}+a_t-0{,}4a_{t-1}-0{,}6a_{t-4}+0{,}24a_{t-5}.
$$

Escrevendo em $T+1$ e em $T+2$, com o choque futuro igual a 0 e o $y$ futuro igual à sua previsão:

$$
\begin{aligned}
\widehat y_T(1)&=y_T+y_{T-3}-y_{T-4}-0{,}4\,\widehat a_T-0{,}6\,\widehat a_{T-3}+0{,}24\,\widehat a_{T-4},\\
\widehat y_T(2)&=\widehat y_T(1)+y_{T-2}-y_{T-3}-0{,}6\,\widehat a_{T-2}+0{,}24\,\widehat a_{T-3}.
\end{aligned}
$$

O MA vai até a defasagem 5, então os resíduos aparecem **até $h=5$**. Em $h=5$, sobra só $+0{,}24\,\widehat a_T$. De $h=6$ em diante, a previsão usa apenas valores observados e previstos.

| Rubrica | Pontos |
|---|---|
| Os dois produtos expandidos, com o $+0{,}24$ | 0,4 |
| $\widehat y_T(1)$ | 0,4 |
| $\widehat y_T(2)$, com $\widehat y_T(1)$ no lugar de $y_{T+1}$ | 0,3 |
| Até $h=5$ | 0,2 |

---

## Questão 4 (2,5) — ciclo e análise

*Origem na lista:* item a): (lista, Q16); item b): (lista, Q14); item c): (lista, Q15).

### a) O ciclo de Box-Jenkins (1,0)

1. **Identificação:** gráfico, diferenças até a estacionariedade ($d$ e $D$), FAC e FACP para propor $p,q,P,Q$.
2. **Estimação:** MV dos candidatos; AIC e BIC para escolher entre eles.
3. **Diagnóstico:** resíduos como ruído branco, com a FAC dentro das bandas e o Ljung-Box sem rejeitar.
4. **Previsão:** prever e avaliar fora da amostra, com RMSE e MAPE.

**Se o diagnóstico falha, volta-se à identificação**: é um ciclo.

| Rubrica | Pontos |
|---|---|
| As quatro etapas, na ordem | 0,4 |
| O que se olha em cada uma | 0,4 |
| A volta à identificação | 0,2 |

### b) Interpretar a tabela (1,1)

- **AIC:** escolhe **B** (209,8), mas só 0,6 abaixo de A: diferença menor que 2 é **empate prático**.
- **BIC:** escolhe **A** (218,1), 2,2 abaixo de B: a multa $\ln T$ do BIC não deixa o parâmetro extra de B se pagar.
- **RMSE e MAPE:** escolhem **A** (1,32 e 2,1%): A prevê melhor os 8 trimestres que não viu.
- C é o pior em tudo.

AIC e BIC discordam porque a multa por parâmetro é 2 no AIC e $\ln T$ no BIC; o BIC prefere o modelo menor. **Escolho A**: é o mais parcimonioso, o BIC o prefere, o AIC empata e ele tem o menor erro fora da amostra.

| Rubrica | Pontos |
|---|---|
| A escolha de cada medida | 0,4 |
| Empate prático no AIC (diferença menor que 2) | 0,2 |
| Por que AIC e BIC discordam | 0,2 |
| Decisão justificada: parcimônia e erro fora da amostra | 0,3 |

### c) O intervalo que alarga (0,4)

O erro de $h$ passos soma $h$ choques futuros, $e_T(h)=\sum_{j=0}^{h-1}\psi_ja_{T+h-j}$. Assim, $\operatorname{Var}(e_T(h))=\sigma^2\sum_{j\lt h}\psi_j^2$ **cresce com $h$**. Num processo estacionário, tende a $\gamma_0$; num integrado como este SARIMA, cresce sem limite.

| Rubrica | Pontos |
|---|---|
| A soma de choques futuros e a variância crescente | 0,3 |
| Estacionário × integrado | 0,1 |

---

## Questão extra — Dickey-Fuller

*Origem na lista:* (lista, Q10). O passo a passo está na seção 8 da folha [o que cai](o_que_cai.md#8-teste-de-raiz-unitária-a-cadeia-de-decisão-do-dickey-fuller).

**a)** A cadeia, passo a passo:
1. **Modelo 3** ($H_0$: $\gamma=0$): $-2{,}80\gt-3{,}45$, **não rejeita**.
2. **$\phi_3$** ($H_0$: $\gamma=a_2=0$): $4{,}10\lt6{,}49$, **não rejeita**. A tendência não pertence ao modelo; tira-se.
3. **Modelo 2:** $-2{,}20\gt-2{,}89$, **não rejeita**.
4. **$\phi_1$** ($H_0$: $a_0=\gamma=0$): $2{,}60\lt4{,}71$, **não rejeita**. A constante também sai.
5. **Modelo 1:** $-2{,}30\lt-1{,}95$, **rejeita**.

**Conclusão:** não há raiz unitária. A série é estacionária com média zero e **não deve ser diferenciada**: diferenciá-la seria sobrediferenciar.

**b)** $-3{,}90\lt-3{,}45$: rejeita já no passo 1. Não há raiz unitária, e a série é **estacionária em torno de uma tendência determinística** (TS). Remove-se a tendência por regressão em $t$, em vez de diferenciar.

| Rubrica (se valesse 2,5) | Pontos |
|---|---|
| Começar pelo modelo 3 e saber o motivo | 0,4 |
| Em cada passo, a hipótese e a regra (para $\tau$, rejeita se menor; para $\phi$, se maior) | 1,0 |
| Conclusão de a), sem diferenciar | 0,5 |
| b): TS, tirar a tendência | 0,6 |

---

## Depois de corrigir

1. Some por questão. Cada uma vale 2,5, como na prova.
2. Cada perda vai para o [log](log_erros.md), com a causa.
3. Refaça o item no papel pela seção correspondente da folha [o que cai](o_que_cai.md) ou pela questão-tipo do [guia](nao_posso_errar.md).

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s5_q1_var | 54 |
| pv_s5_q1_cov | 37,5 |
| pv_s5_q1_corr | 0,8333 |
| pv_s5_q1_g0 | 5,6 |
| pv_s5_q1_g1 | -1,7 |
| pv_s5_q1_g2 | 0,8 |
| pv_s5_q1_g3 | 0 |
| pv_s5_q1_rho1 | -0,3036 |
| pv_s5_q1_rho2 | 0,1429 |
| pv_s5_q2_raiz | -2 |
| pv_s5_q2_g0 | 4 |
| pv_s5_q2_g1 | -2 |
| pv_s5_q2_rho1 | -0,5 |
| pv_s5_q2_rho2 | 0,25 |
| pv_s5_q2_rho3 | -0,125 |
| pv_s5_q2_facp1 | -0,5 |
| pv_s5_q2_facp2 | 0 |
| pv_s5_q3_g0 | 1,64 |
| pv_s5_q3_g4 | -0,8 |
| pv_s5_q3_rho4 | -0,4878 |
| pv_s5_q3_rho1 | 0 |
| pv_s5_q3_rho8 | 0 |
| pv_s5_q3_facp4 | -0,4878 |
| pv_s5_q3_facp8 | -0,3123 |
| pv_s5_q3_facp12 | -0,2215 |
| pv_s5_q3_coef_y1 | 1 |
| pv_s5_q3_coef_y4 | 1 |
| pv_s5_q3_coef_y5 | -1 |
| pv_s5_q3_ma_a1 | -0,4 |
| pv_s5_q3_ma_a4 | -0,6 |
| pv_s5_q3_ma_a5 | 0,24 |
| pv_s5_q3_cruzado | 0,24 |
| pv_s5_q3_h_max_res | 5 |
| pv_s5_q4_daic | 0,6 |
| pv_s5_q4_dbic | 2,2 |
| pv_s5_extra_a | 1 |
| pv_s5_extra_b | 1 |
| pv_df_tau1_5 | -1,95 |
-->
