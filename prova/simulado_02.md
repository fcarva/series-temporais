---
title: "Simulado 02 — prova de 05/11 com as torções do professor"
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
> Sem consulta, **1h50**, cronometrado, 10,0 pontos. Este simulado troca de convenção de sinal **dentro da prova** (Q1c e Q5 usam o sinal positivo dos slides; o resto usa Box-Jenkins). Antes de cada conta, escreva qual convenção está usando. Gabarito em [simulado_02_gabarito.md](simulado_02_gabarito.md).

---

## Questão 1 (1,5) — Bloco 1: estacionariedade e Wold

a) Sejam $A$ e $B$ variáveis aleatórias não correlacionadas, com média zero e variância $\sigma^2$, e $\omega\in(0,\pi)$ fixo. Mostre que $z_t=A\cos(\omega t)+B\sin(\omega t)$ é estacionário de segunda ordem. **(0,4)**

b) Com $\omega=\pi/2$ e $\sigma^2=1$, calcule $\operatorname{Cov}(z_t,z_{t-1})$ e $\operatorname{Cov}(z_t,z_{t-2})$. Por que esse processo é o exemplo típico do componente **determinístico** da decomposição de Wold? **(0,4)**

c) Na convenção de sinal positivo, seja $x_t=a_t+0{,}5a_{t-1}$ com $\sigma_a^2=2$. Calcule $\gamma_0$, $\gamma_1$ e $\rho_1$. Mostre que $x^*_t=e_t+2e_{t-1}$, com $\sigma_e^2=0{,}5$, tem exatamente as mesmas autocovariâncias. Qual dos dois se escolhe, e por quê? **(0,7)**

## Questão 2 (2,0) — Bloco 2: AR(2)

Seja $y_t=0{,}5y_{t-1}+0{,}3y_{t-2}+\varepsilon_t$, $\varepsilon_t\sim RB(0,1)$.

a) Verifique a estacionariedade pelas três desigualdades do triângulo e pelas raízes do polinômio AR. **(0,4)**

b) Escreva as equações de Yule-Walker e obtenha $\rho_1$, $\rho_2$ e $\rho_3$. **(0,5)**

c) Calcule $\gamma_0$. **(0,4)**

d) Calcule $\phi_{11}$, $\phi_{22}$ e $\phi_{33}$. **(0,3)**

e) Calcule $\psi_1$, $\psi_2$ e $\psi_3$. **(0,4)**

## Questão 3 (2,0) — Bloco 3: sazonalidade e ARIMA

a) Para o SAR$(1)_4$ $y_t=0{,}6y_{t-4}+\varepsilon_t$, $\sigma^2=1$: calcule $\gamma_0$, $\rho_4$ e $\rho_8$ e diga quanto valem $\rho_1$ e $\rho_3$. Descreva a FACP. **(0,7)**

b) Escreva $(1-0{,}5B)(1-0{,}6B^4)y_t=\varepsilon_t$ como AR(5) e dê a restrição que os coeficientes satisfazem. **(0,6)**

c) Expanda o ARIMA(1,1,1) $(1-0{,}4B)(1-B)y_t=(1-0{,}7B)a_t$ em equação de diferenças para $y_t$. **(0,4)**

d) Mostre que $w_t=\Delta y_t$ do item c) é um ARMA(1,1) estacionário e invertível. **(0,3)**

## Questão 4 (1,5) — Bloco 4: seleção e verossimilhança

Com $T=120$ e média zero: ARMA(1,1) $\ln L=-170{,}4$; AR(2) $\ln L=-171{,}9$; ARMA(2,1) $\ln L=-169{,}8$. Use $\ln120\approx4{,}7875$ e $\chi^2_{1;\,0{,}95}=3{,}84$.

a) Calcule AIC e BIC na forma da AU02 (divididos por $T$) e diga quais modelos são escolhidos. **(0,8)**

b) Teste ARMA(1,1) contra ARMA(2,1) pela razão de verossimilhança. **(0,4)**

c) Num AR(1), qual a diferença entre a verossimilhança exata e a condicional? Por que, com $T=120$, isso quase não importa? **(0,3)**

## Questão 5 (1,5) — Bloco 5: previsão

a) Na convenção de sinal positivo, $z_t=0{,}5z_{t-1}+a_t+0{,}4a_{t-1}$, $\sigma_a^2=1$, com $z_T=2$ e $\widehat a_T=1$. Calcule $z_{T+h\mid T}$ para $h=1,2,3$, os pesos $\psi_1$ e $\psi_2$, as variâncias dos erros para $h=1,2,3$ e o intervalo de 95% para $h=2$. **(1,0)**

b) No ARIMA(0,1,1) $\Delta y_t=a_t-0{,}7a_{t-1}$, com $y_T=50$ e $\widehat a_T=2$, calcule $y_{T+h\mid T}$ para todo $h\ge1$ e mostre que a previsão é uma suavização exponencial simples. Qual a constante de suavização? **(0,5)**

## Questão 6 (1,5) — Bloco 6: SARIMA aplicado

Uma série mensal com $T=144$ foi modelada como SARIMA$(1,0,0)(0,1,1)_{12}$.

a) Escreva o modelo em $B$ e a equação de $y_t$ em função do passado. **(0,4)**

b) Quantos parâmetros e quantas observações efetivas? **(0,2)**

c) Escreva $y_{T+1\mid T}$ e $y_{T+13\mid T}$. **(0,4)**

d) O Ljung-Box dos resíduos com $K=24$ deu $Q=28{,}5$. Quantos graus de liberdade? Com $\chi^2_{22;\,0{,}95}=33{,}92$, qual a conclusão? **(0,5)**
