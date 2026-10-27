---
title: "Simulado 01 — prova de 05/11 no formato da lista"
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
  - Simulado 01 — séries temporais
---

# Simulado 01

> [!IMPORTANT]
> **Regras**
> Sem consulta e sem calculadora gráfica, **1h50**, cronometrado. Total: 10,0 pontos, uma questão por bloco da lista. Comece pelos itens de conta curta (Q4 e Q1c) e só depois vá às demonstrações. Em todo item, escreva **primeiro a fórmula geral** e, se houver MA, **a convenção de sinal**. O gabarito com rubrica está em [simulado_01_gabarito.md](simulado_01_gabarito.md); não abra antes de terminar.

**Notação.** $a_t$, $\varepsilon_t$ e $u_t$ são ruído branco, $RB(0,\sigma^2)$. O operador de defasagem é $B$, e o MA segue a convenção da lista: $\theta(B)=1-\theta_1B-\dots-\theta_qB^q$.

---

## Questão 1 (1,5) — Bloco 1: processos e momentos

Seja o passeio aleatório sem drift $y_t=y_{t-1}+u_t$, com $y_0=2$ fixo.

a) Escreva $y_t$ em função de $y_0$ e dos choques e calcule $E(y_t)$, $\operatorname{Var}(y_t)$ e $\operatorname{Cov}(y_t,y_{t-k})$, $0\le k\lt t$. **(0,5)**

b) Mostre que $\operatorname{Corr}(y_t,y_{t-k})=\sqrt{(t-k)/t}$ e calcule-a para $t=100$ com $k=1$ e $k=10$. O que isso diz sobre a FAC amostral de um passeio aleatório? **(0,5)**

c) Dois processos estacionários e não correlacionados entre si têm autocovariâncias $x_t:\ \gamma_0=1{,}0$, $\gamma_1=0{,}4$, $\gamma_j=0$ ($j\ge2$) e $w_t:\ \gamma_0=1{,}5$, $\gamma_1=-0{,}6$, $\gamma_2=0{,}1$, $\gamma_j=0$ ($j\ge3$). Calcule a autocovariância de $y_t=2x_t+w_t$ e diga a que classe ARMA ele pertence. **(0,5)**

## Questão 2 (2,0) — Bloco 2: ARMA

Considere $z_t-0{,}6z_{t-1}=a_t-0{,}3a_{t-1}$, com $\sigma_a^2=1$.

a) Escreva o modelo com o operador $B$ e verifique estacionariedade e invertibilidade pelas raízes. **(0,4)**

b) Calcule $\gamma_0$, $\gamma_1$ e $\gamma_2$. **(0,6)**

c) Obtenha $\rho_1$ e $\rho_2$ e mostre que $\rho_k=\phi\rho_{k-1}$ para $k\ge2$. **(0,4)**

d) Obtenha os três primeiros pesos $\psi_j$ e $\pi_j$. **(0,6)**

## Questão 3 (1,5) — Bloco 3: integração e sobrediferenciação

Seja $y_t=0{,}5y_{t-1}+\varepsilon_t$, $\varepsilon_t\sim RB(0,1)$, e $w_t=\Delta y_t$.

a) Mostre que $(1-0{,}5B)w_t=(1-B)\varepsilon_t$ e diga por que $w_t$ não é invertível. **(0,5)**

b) Calcule $\operatorname{Var}(w_t)$ e $\rho_1(w)$ e compare com $\operatorname{Var}(y_t)$. **(0,6)**

c) Quais são as consequências de diferenciar esta série para a estimação e para a previsão? **(0,4)**

## Questão 4 (1,5) — Bloco 4: estimação e seleção

a) Com $T=200$, quatro modelos de média zero deram as log-verossimilhanças: AR(1) $-301{,}2$; ARMA(1,1) $-299{,}8$; AR(2) $-298{,}9$; AR(3) $-297{,}0$. Contando $\sigma^2$ em $k$ e usando $\ln200\approx5{,}2983$, calcule AIC e BIC e diga qual modelo cada critério escolhe. Por que podem discordar? **(0,9)**

b) Num AR(1) sem constante com $T=101$, as somas de $t=2$ a $T$ são $\sum y_ty_{t-1}=84$, $\sum y_{t-1}^2=120$ e $\sum y_t^2=130$. Escreva a log-verossimilhança condicional em $y_1$ e obtenha $\widehat\phi$ e $\widehat\sigma^2$. **(0,6)**

## Questão 5 (2,0) — Bloco 5: previsão

Seja $y_t-10=0{,}8(y_{t-1}-10)+a_t$, $\sigma_a^2=4$, e $y_T=12$.

a) Mostre que o previsor de mínimo EQM de $y_{T+h}$ é $E(y_{T+h}\mid\mathcal F_T)$. **(0,6)**

b) Calcule $y_{T+h\mid T}$ para $h=1,2,3$ e a fórmula geral. **(0,4)**

c) Mostre que o erro de previsão é um MA($h-1$) e calcule sua variância para $h=1,2,3$. **(0,5)**

d) Construa os intervalos de 95% para $h=1$ e $h=2$. Para onde vão a previsão e a variância quando $h\to\infty$? **(0,5)**

## Questão 6 (1,5) — Bloco 6: SARIMA aplicado

Uma série mensal com $T=180$ observações foi identificada como SARIMA$(0,1,1)(0,1,1)_{12}$, com $\theta=0{,}4$ e $\Theta=0{,}6$.

a) Escreva o modelo com o operador $B$ e expanda o lado MA. **(0,3)**

b) Quantos parâmetros são estimados? Quantas observações sobram depois das diferenças? **(0,3)**

c) Calcule a FAC teórica de $w_t=(1-B)(1-B^{12})y_t$ nas defasagens 1, 11, 12 e 13 e descreva a FACP. **(0,6)**

d) Para comparar com um SARIMA$(1,1,1)(0,1,1)_{12}$, que critério você usaria? **(0,3)**
