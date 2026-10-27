---
title: "Simulado 03 — prova de 05/11, versão integradora"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: LST
status: verificado
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
  - simulado
aliases:
  - Simulado 03 — séries temporais
---

# Simulado 03

> [!IMPORTANT]
> **Regras**
> Sem consulta, **1h50**, 10,0 pontos. É o simulado mais longo: se aos 90 minutos faltar uma questão inteira, escreva só as **fórmulas e a estrutura** dela, porque elas valem ponto. Gabarito em [simulado_03_gabarito.md](simulado_03_gabarito.md).

---

## Questão 1 (1,5) — Bloco 1: tendência determinística × estocástica

Com $\varepsilon_t\sim RB(0,1)$, considere
- **(TS)** $y_t=2+0{,}5t+u_t$, com $u_t=0{,}6u_{t-1}+\varepsilon_t$;
- **(DS)** $z_t=0{,}5+z_{t-1}+\varepsilon_t$, com $z_0=0$.

a) Calcule $E(y_t)$ e $\operatorname{Var}(y_t)$, e $E(y_{10})$. **(0,4)**

b) Calcule $E(z_t)$ e $\operatorname{Var}(z_t)$, e $\operatorname{Var}(z_{10})$. **(0,3)**

c) Qual o efeito de um choque unitário em $\varepsilon_t$ sobre $y_{t+5}$ e sobre $z_{t+5}$? **(0,3)**

d) Mostre que $\Delta y_t$ é um ARMA(1,1) não invertível e calcule $\rho_1(\Delta y)$. Como se deve tirar a não estacionariedade de cada série? **(0,5)**

## Questão 2 (2,0) — Bloco 2: verdadeiro ou falso

Na convenção de sinal positivo, seja $Y_t=\alpha Y_{t-1}+u_t+\beta u_{t-1}$, com $\lvert\alpha\rvert\lt1$, $u_t\sim RB(0,\sigma^2)$, e $\gamma_h=E(Y_tY_{t-h})$. Julgue, **com demonstração**, cada afirmativa. Depois, confira os números com $\alpha=\beta=0{,}5$ e $\sigma^2=1$.

1. $\gamma_0=\dfrac{1+2\alpha\beta+\beta^2}{1-\alpha^2}\sigma^2$.
2. $\gamma_1=\dfrac{(1+\alpha\beta)(\alpha+\beta)}{1-\alpha^2}\sigma^2$.
3. $\rho_2=\alpha\rho_1$.
4. $\gamma_0=\sigma^2/(1-\alpha^2)$, porque a parte MA não afeta a variância.
5. Na representação $Y_t=\sum_{j\ge1}\pi_jY_{t-j}+u_t$, os pesos são $\pi_j=(\alpha+\beta)\beta^{j-1}$.
6. Como $\lvert\alpha\rvert\lt1$, o processo é invertível.

Cada afirmativa julgada com a conta que a sustenta vale 0,25; o sistema que dá $\gamma_0$ e $\gamma_1$ vale 0,4; a conferência numérica, 0,1.

## Questão 3 (2,0) — Bloco 3: previsão de um SARIMA trimestral

Para $(1-0{,}5B)(1-B)(1-B^4)y_t=(1-0{,}6B^4)a_t$, as últimas observações e resíduos são:

| | $T-5$ | $T-4$ | $T-3$ | $T-2$ | $T-1$ | $T$ |
|---|---|---|---|---|---|---|
| $y$ | 100 | 104 | 98 | 101 | 107 | 103 |
| $\widehat a$ | — | — | 1,0 | −0,5 | 0,8 | 0,4 |

a) Expanda o lado AR e escreva $y_t$ em função do passado. **(0,6)**

b) Quantas observações se perdem com as diferenças? **(0,2)**

c) Calcule $y_{T+h\mid T}$ para $h=1,\dots,5$. **(1,0)**

d) Por que o termo MA some a partir de $h=5$? Qual a forma da função de previsão a longo prazo? **(0,2)**

## Questão 4 (1,5) — Bloco 4: seleção de SARIMA mensais

Com $T=240$ observações mensais, ajustaram-se M1 = SARIMA$(1,1,1)(0,1,1)_{12}$, com $\ln L=-412{,}6$, e M2 = SARIMA$(2,1,1)(0,1,1)_{12}$, com $\ln L=-411{,}9$. Use o número de observações efetivas e $\ln227\approx5{,}4250$.

a) Quantos parâmetros tem cada modelo? Quantas observações efetivas há? **(0,3)**

b) Calcule AIC e BIC. **(0,6)**

c) Faça o teste LR de M1 contra M2. **(0,4)**

d) Qual critério você recomendaria, e por quê? **(0,2)**

## Questão 5 (1,5) — Bloco 5: previsão de um MA(2)

Seja $y_t=3+a_t-0{,}5a_{t-1}+0{,}2a_{t-2}$, com $\sigma_a^2=1$, $\widehat a_T=1$ e $\widehat a_{T-1}=-2$.

a) Classifique na convenção Box-Jenkins e calcule $y_{T+h\mid T}$ para $h=1,2,3$. **(0,5)**

b) Calcule $\operatorname{Var}(e_T(h))$ para $h=1,2,3$ e o intervalo de 95% para $h=3$. **(0,5)**

c) Mostre que, para $h\gt q$, a previsão é a média e a variância do erro é $\gamma_0$. O que isso diz sobre a "memória" de um MA($q$)? **(0,5)**

## Questão 6 (1,5) — Bloco 6: identificação e diagnóstico

Numa série mensal com $T=240$, a FAC e a FACP amostrais de $w_t=(1-B)(1-B^{12})y_t$ deram:

| Defasagem | 1 | 2 | 3 | 11 | 12 | 13 | 24 |
|---|---|---|---|---|---|---|---|
| FAC | −0,41 | 0,03 | −0,05 | 0,17 | −0,39 | 0,15 | 0,04 |
| FACP | −0,41 | −0,16 | −0,12 | 0,06 | −0,33 | −0,20 | −0,15 |

As demais defasagens ficaram dentro da banda.

a) Qual a banda aproximada de 95%? Que defasagens são significativas? **(0,3)**

b) Proponha um modelo e mostre que a FAC teórica com $\theta=\Theta=0{,}5$ reproduz o padrão. **(0,6)**

c) O Ljung-Box dos resíduos com $K=24$ deu $Q=30{,}1$. Conclua com $\chi^2_{22;\,0{,}95}=33{,}92$. **(0,4)**

d) E se a FAC dos resíduos tivesse um pico só na defasagem 12? **(0,2)**
