---
title: "Simulado 02 — as nove questões-tipo, com números novos"
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
  - Simulado 02 — séries temporais
---

# Simulado 02

> [!IMPORTANT]
> **Regras**
> Sem consulta, **1h50**, cronometrado, 10,0 pontos. Convenção da lista em todas as questões: MA de Box-Jenkins, $1-\theta B$.
>
> Cada questão é uma das nove questões-tipo do [guia "não posso errar"](nao_posso_errar.md), na mesma ordem, com números que não aparecem lá.
>
> **Ordem sugerida, como na prova:**
> 1. 3 minutos de leitura;
> 2. uns 25 minutos só de contas curtas: Q7, Q8 a)–d), Q9 a)–b), Q3 b) e Q4 e);
> 3. as derivações, da mais curta para a mais longa;
> 4. a frase de fecho em cada item.
>
> A correção está no [gabarito](simulado_02_gabarito.md).

---

## Questão 1 (1,0) — passeio com drift

Seja $y_t=0{,}2+y_{t-1}+u_t$, com $y_0=5$ fixo e $u_t\sim RB(0,2)$.

a) Escreva $y_t$ em função de $y_0$ e dos choques. Calcule $E(y_t)$, $\operatorname{Var}(y_t)$ e $\operatorname{Cov}(y_t,y_{t-k})$, citando a hipótese usada em cada passo. **(0,5)**

b) Para $t=50$ e $k=10$, dê os três momentos e a correlação $\operatorname{Corr}(y_t,y_{t-k})$. **(0,3)**

c) O processo é estacionário? Responda com o critério. **(0,2)**

## Questão 2 (1,0) — soma de processos

O processo $z_{1t}$ tem $\gamma_0=1{,}0$, $\gamma_1=0{,}45$ e autocovariância nula a partir da defasagem 2. O processo $z_{2t}$ tem $\gamma_0=1{,}5$, $\gamma_1=0{,}6$, $\gamma_2=0{,}5$ e autocovariância nula a partir da defasagem 3. Os dois são estacionários, de média zero e não correlacionados em qualquer defasagem. Seja $z_{3t}=3z_{1t}+z_{2t}$.

a) Deduza a autocovariância de $z_3$ em função das de $z_1$ e $z_2$. **(0,4)**

b) Calcule $\gamma_3(k)$ para $k=0,1,2,3$, e também $\rho_1$ e $\rho_2$. **(0,3)**

c) $z_3$ é estacionário? Qual modelo ARMA ele segue, e por quê? **(0,3)**

## Questão 3 (1,0) — raízes e fator comum

Considere os modelos

$$
\text{(i)}\ \ \tilde z_t=a_t-0{,}65a_{t-1}+0{,}1a_{t-2};\qquad
\text{(ii)}\ \ \tilde z_t-0{,}25\tilde z_{t-1}=a_t-0{,}65a_{t-1}+0{,}1a_{t-2}.
$$

a) Escreva (i) com o operador $B$, classifique-o e diga se é estacionário. **(0,2)**

b) Calcule as raízes do polinômio MA de (i) e conclua sobre a invertibilidade. **(0,4)**

c) Mostre que (ii) é, na verdade, um MA(1), e calcule seus pesos $\pi_1$, $\pi_2$ e $\pi_3$. **(0,4)**

## Questão 4 (1,5) — ARMA(1,1)

Seja $z_t-0{,}5z_{t-1}=a_t-0{,}2a_{t-1}$, com $\sigma_a^2=2$.

a) Verifique estacionariedade e invertibilidade pelas raízes. **(0,2)**

b) Calcule os momentos auxiliares $E(z_ta_t)$ e $E(z_ta_{t-1})$. **(0,3)**

c) Calcule $\gamma_0$, $\gamma_1$ e $\gamma_2$. **(0,5)**

d) Obtenha $\rho_1$ e mostre que $\rho_k=0{,}5\,\rho_{k-1}$ para $k\ge2$. **(0,2)**

e) Calcule $\psi_1$, $\psi_2$, $\psi_3$ e $\pi_1$, $\pi_2$, $\pi_3$. **(0,3)**

## Questão 5 (1,0) — AR(2)

Seja $y_t=0{,}3y_{t-1}+0{,}4y_{t-2}+\varepsilon_t$, com $\varepsilon_t\sim RB(0,1)$.

a) Verifique a estacionariedade pelas raízes do polinômio AR. **(0,2)**

b) Escreva as equações de Yule-Walker e obtenha $\rho_1$, $\rho_2$ e $\rho_3$. **(0,4)**

c) Calcule $\gamma_0$. **(0,4)**

## Questão 6 (1,0) — diferenciar um AR(1)

Seja $y_t=0{,}2y_{t-1}+\varepsilon_t$, com $\varepsilon_t\sim RB(0,1)$, e $w_t=\Delta y_t$.

a) Mostre que $(1-0{,}2B)w_t=(1-B)\varepsilon_t$. O processo $w_t$ é invertível? **(0,4)**

b) Calcule $\operatorname{Var}(y_t)$, $\operatorname{Var}(w_t)$ e $\rho_1(w)$. **(0,4)**

c) O que a diferenciação fez com a variância, e o que isso diz sobre diferenciar esta série? **(0,2)**

## Questão 7 (1,0) — critérios e MQO

a) Com $T=150$ e média zero, as log-verossimilhanças foram: AR(1), $-215{,}0$; AR(2), $-213{,}1$; ARMA(1,1), $-213{,}6$; ARMA(2,1), $-212{,}4$. Use $\ln150=5{,}0106$ e conte $\sigma^2$ em $k$. Calcule AIC e BIC e diga qual modelo cada critério escolhe. **(0,6)**

b) Num AR(1) sem média com $T=81$, as somas de $t=2$ a $T$ são $\sum y_ty_{t-1}=45$, $\sum y_{t-1}^2=90$ e $\sum y_t^2=100$. Obtenha $\widehat\phi$ e $\widehat\sigma^2$ pela MV condicional. **(0,4)**

## Questão 8 (1,5) — previsão

Seja $y_t-50=0{,}6(y_{t-1}-50)+a_t$, com $\sigma_a^2=9$ e $y_T=55$.

a) Calcule $\widehat y_T(h)$ para $h=1,2,3$ e escreva a fórmula geral. **(0,4)**

b) Escreva os erros $e_T(1)$ e $e_T(2)$ e mostre que $e_T(h)$ é um MA($h-1$). **(0,3)**

c) Calcule as variâncias dos erros para $h=1,2,3$. **(0,3)**

d) Dê os intervalos de 95% para $h=1$ e $h=2$. **(0,3)**

e) O que acontece com a previsão e com a variância do erro quando $h\to\infty$? **(0,2)**

## Questão 9 (1,0) — SARIMA trimestral

Uma série trimestral com $T=100$ foi identificada como SARIMA$(0,1,1)(0,1,1)_4$, com $\theta=0{,}5$ e $\Theta=0{,}3$.

a) Escreva o modelo com o operador $B$ e expanda o produto dos polinômios MA. **(0,3)**

b) Quantos parâmetros são estimados, e quantas observações efetivas restam? **(0,2)**

c) Calcule a FAC de $w_t=(1-B)(1-B^4)y_t$ nas defasagens 1 a 6. **(0,4)**

d) Um colega propõe acrescentar um AR(1) comum ao modelo. Com que critério se compara os dois? **(0,1)**
