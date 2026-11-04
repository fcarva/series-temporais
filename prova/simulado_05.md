---
title: "Simulado 05 — o formato anunciado: 4 questões de 2,5, em 1 hora"
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
  - Simulado 05 — séries temporais
---

# Simulado 05

> [!IMPORTANT]
> **Regras**
> Sem consulta, **1 hora**, cronometrado, 10,0 pontos. É o formato que o professor anunciou em 04/11: **4 questões de 2,5**, uma por bloco do quadro. Uns 15 minutos por questão.
>
> Convenção da lista: MA de Box-Jenkins, $1-\theta B$. Escreva a frase de fecho em cada item. Os desenhos são à mão, com os números das primeiras barras marcados.
>
> A correção está no [gabarito](simulado_05_gabarito.md).

---

## Questão 1 (2,5) — processos estocásticos

a) Seja o passeio aleatório $y_t=y_{t-1}+u_t$, com $y_0=0$ e $u_t\sim RB(0;\ 1{,}5)$. Calcule $E(y_t)$, $V(y_t)$ e $\operatorname{Cov}(y_t,y_{t-k})$; dê os valores de $V(y_{36})$, $\operatorname{Cov}(y_{36},y_{25})$ e da correlação entre os dois. O processo é estacionário? **(1,0)**

b) O processo $z_{1t}$ tem $\gamma_0=0{,}8$, $\gamma_1=0{,}3$ e autocovariância nula a partir da defasagem 2. O processo $z_{2t}$ tem $\gamma_0=1{,}2$, $\gamma_1=-0{,}5$, $\gamma_2=0{,}2$ e autocovariância nula a partir da defasagem 3. Os dois têm média zero, são estacionários e não são correlacionados em nenhuma defasagem. Para $z_{3t}=z_{1t}+2z_{2t}$: deduza $\gamma_3(k)$, calcule-a para $k=0,1,2,3$, dê $\rho_1$ e $\rho_2$ e diga qual modelo ARMA $z_3$ segue. **(1,5)**

## Questão 2 (2,5) — ARMA: estacionariedade e a FAC

Seja $(1+0{,}5B)y_t=u_t$, com $u_t\sim RB(0,3)$.

a) Verifique se o processo é estacionário. **(0,5)**

b) Monte a FAC pela conta: $\gamma_0$, $\gamma_1$, $\rho_1$, $\rho_2$ e $\rho_3$. **(1,0)**

c) Desenhe a FAC e a FACP teóricas até a defasagem 5 e descreva o padrão de cada uma. **(0,6)**

d) Outra série tem FAC com um único pico, na defasagem 1, e FACP que decai. Qual modelo você propõe, e por quê? **(0,4)**

## Questão 3 (2,5) — SARIMA e a equação de previsão

a) Seja a série trimestral $y_t=(1-0{,}8B^4)a_t$, com $a_t\sim RB(0,1)$. Calcule $\gamma_0$, $\gamma_4$ e $\rho_4$, diga quanto valem as demais autocorrelações e desenhe a FAC e a FACP até a defasagem 12. **(1,2)**

b) Uma série trimestral foi modelada como SARIMA$(0,1,1)(0,1,1)_4$, com $\theta=0{,}4$ e $\Theta=0{,}6$. Escreva $y_t$ em função dos valores e choques passados, escreva as equações de $\widehat y_T(1)$ e $\widehat y_T(2)$ e diga até que horizonte os resíduos $\widehat a$ aparecem nas previsões. **(1,3)**

## Questão 4 (2,5) — ciclo de modelagem e análise dos critérios

a) Descreva o ciclo de modelagem de Box-Jenkins: as etapas, o que se olha em cada uma e o que acontece quando o diagnóstico falha. **(1,0)**

b) Três modelos foram ajustados a uma série trimestral. AIC e BIC vêm da estimação; RMSE e MAPE, das previsões para os últimos 8 trimestres, deixados fora da estimação.

| Modelo | AIC | BIC | RMSE | MAPE |
|---|---|---|---|---|
| A: SARIMA$(0,1,1)(0,1,1)_4$ | 210,4 | 218,1 | 1,32 | 2,1% |
| B: SARIMA$(1,1,1)(0,1,1)_4$ | 209,8 | 220,3 | 1,35 | 2,2% |
| C: SARIMA$(2,1,0)(1,1,0)_4$ | 214,6 | 225,0 | 1,58 | 2,6% |

Sem calcular nenhum critério, interprete a tabela: qual modelo cada medida escolhe, por que AIC e BIC discordam e qual modelo você usaria para prever. **(1,1)**

c) Por que o intervalo de previsão fica mais largo à medida que o horizonte $h$ aumenta? **(0,4)**

## Questão extra (fora dos 10 pontos, 10 minutos) — Dickey-Fuller

Uma série com $T=100$ foi testada a 5%, seguindo a cadeia que começa pelo modelo com constante e tendência. Os valores críticos são: $\tau_\tau=-3{,}45$; $\phi_3=6{,}49$; $\tau_\mu=-2{,}89$; $\phi_1=4{,}71$; $\tau=-1{,}95$.

| Modelo 3 | Modelo 2 | Modelo 1 |
|---|---|---|
| $\tau_\tau=-2{,}80$; $\phi_3=4{,}10$ | $\tau_\mu=-2{,}20$; $\phi_1=2{,}60$ | $\tau=-2{,}30$ |

a) Percorra a cadeia, dizendo em cada passo qual hipótese testa, o que decide e por quê. A série tem raiz unitária? Deve ser diferenciada?

b) E se o modelo 3 tivesse dado $\tau_\tau=-3{,}90$? O que se conclui, e o que se faz com a série?
