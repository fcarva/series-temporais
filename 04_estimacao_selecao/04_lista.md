---
title: "Módulo 04 — Estimação e seleção: lista resolvida (Q13–Q14) e teoria"
modulo: "04"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
aulas: "AU02 (p. 58–99), AU03"
lista: [13, 14]
status: rascunho
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
aliases:
  - Estimação e seleção
---

# Módulo 04 — Identificação, estimação e diagnóstico (Q13–Q14)

Conferência em [04_estimacao.R](04_estimacao.R). No [INPC](../trabalho_inpc/relatorio.md) §3–4, os mesmos critérios escolhem entre 64 SARIMA.

## Teoria em uma página

**Verossimilhança exata × condicional (AU02).** A densidade conjunta fatora como $f(y_1,\dots,y_T)=f(y_1,\dots,y_p)\prod_{t\gt p}f(y_t\mid y_{t-1},\dots)$.

- **Condicional:** trata os $p$ primeiros valores (e os $\varepsilon_t$ iniciais, no MA) como fixos. Para AR, isso é MQO.
- **Exata:** inclui $f(y_1,\dots,y_p)$ pela distribuição estacionária. No MA e no ARMA, isso exige o filtro de Kalman.

Os dois métodos são assintoticamente equivalentes. O exato é melhor em amostras pequenas e perto da fronteira de estacionariedade ou de invertibilidade.

**Ciclo de Box-Jenkins (AU03):** identificação (FAC/FACP, raiz unitária) → estimação → diagnóstico (resíduos e estabilidade) → previsão. Se o diagnóstico falha, volta-se à identificação.

### D04.1 · MV condicional do AR(1) é MQO

> [!NOTE]
> **O que se quer provar**
> No AR(1) gaussiano, $y_t=\phi y_{t-1}+\varepsilon_t$ com $\varepsilon_t\sim N(0,\sigma^2)$, o estimador de MV condicional em $y_1$ é
>
> $$\widehat\phi=\frac{\sum_{t=2}^{T}y_ty_{t-1}}{\sum_{t=2}^{T}y_{t-1}^2}\qquad\text{e}\qquad\widehat\sigma^2=\frac{1}{T-1}\sum_{t=2}^{T}\widehat\varepsilon_t^{\,2}.$$

**Passo a passo.**

1. Condicional em $y_{t-1}$: $y_t\mid y_{t-1}\sim N(\phi y_{t-1},\sigma^2)$ [normalidade de $\varepsilon_t$, independente do passado].

2. Fatoração da densidade conjunta condicional em $y_1$: $f(y_2,\dots,y_T\mid y_1)=\prod_{t=2}^{T}f(y_t\mid y_{t-1})$, pela propriedade de Markov do AR(1).

3. Log-verossimilhança condicional:

$$
\ell(\phi,\sigma^2)=-\frac{T-1}{2}\ln(2\pi)-\frac{T-1}{2}\ln\sigma^2-\frac{1}{2\sigma^2}\sum_{t=2}^{T}(y_t-\phi y_{t-1})^2 .
$$

4. Em $\phi$, maximizar $\ell$ é minimizar $\sum(y_t-\phi y_{t-1})^2$: é o problema de MQO sem intercepto. A condição de 1ª ordem é

$$
\frac{\partial\ell}{\partial\phi}=\frac{1}{\sigma^2}\sum_{t=2}^{T}y_{t-1}(y_t-\phi y_{t-1})=0
\ \Longrightarrow\ \widehat\phi=\frac{\sum y_ty_{t-1}}{\sum y_{t-1}^2}.
$$

5. Em $\sigma^2$: $\partial\ell/\partial\sigma^2=-\frac{T-1}{2\sigma^2}+\frac{1}{2\sigma^4}\sum\widehat\varepsilon_t^2=0$, logo $\widehat\sigma^2=\sum\widehat\varepsilon_t^2/(T-1)$. É viesado para baixo, porque não desconta o grau de liberdade de $\widehat\phi$.

$$\boxed{\widehat\phi_{MV\text{-}cond}=\widehat\phi_{MQO},\qquad \sqrt T(\widehat\phi-\phi)\xrightarrow{d}N(0,\,1-\phi^2)}$$

> [!TIP]
> **Como o professor pode torcer**
> - Com intercepto: vira MQO de $y_t$ em $(1,y_{t-1})$.
> - Com AR($p$): MQO de $y_t$ em $p$ defasagens, condicional nos $p$ primeiros valores.
> - Pedir a MV **exata**: some $\ln f(y_1)$, com $y_1\sim N\big(0,\sigma^2/(1-\phi^2)\big)$. A condição de 1ª ordem deixa de ser linear em $\phi$ e pede otimização numérica (AU02, p. 79).

**Conferência.** Numa série com $T=500$ e $\phi=0{,}7$: MQO, `lm()` e a maximização numérica da log-verossimilhança dão $\widehat\phi=0{,}6845$, iguais até $10^{-7}$. O erro-padrão assintótico é $\sqrt{(1-\widehat\phi^2)/T}=0{,}0326$.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| m04_q13_phi_mqo | 0,6845 |
| m04_q13_phi_mv | 0,6845 |
| m04_q13_phi_lm | 0,6845 |
| m04_q13_s2_mqo | 1,035 |
| m04_q13_s2_mv | 1,035 |
| m04_q13_ep_assint | 0,0326 |
-->

---

## Q13 — Log-verossimilhança condicional do AR(1) e o estimador de MQO

**Tipo:** derivação · **Resposta:** D04.1 acima, passos 1 a 5.

Na prova, escreva nesta ordem:
1. a densidade condicional;
2. a fatoração;
3. $\ell(\phi,\sigma^2)$;
4. a condição de 1ª ordem em $\phi$;
5. a conclusão: $\widehat\phi$ é o MQO da regressão de $y_t$ em $y_{t-1}$, sem intercepto.

## Q14 — AIC e BIC de três ARMA

**Tipo:** cálculo e conceito

**(a) Cálculo.** $T=150$, e todos os modelos têm média zero. Então $k$ = parâmetros ARMA + $\sigma^2$, que dá $k=3$ nos três casos. As fórmulas são $AIC=-2\ln L+2k$ e $BIC=-2\ln L+k\ln T$, com $\ln150=5{,}0106$.

| Modelo | $\ln L$ | $k$ | AIC | BIC | AIC/$T$ | BIC/$T$ |
|---|---|---|---|---|---|---|
| ARMA(1,1) | −210,3 | 3 | **426,6** | **435,63** | **2,844** | **2,904** |
| ARMA(2,0) | −212,8 | 3 | 431,6 | 440,63 | 2,877 | 2,938 |
| ARMA(0,2) | −214,1 | 3 | 434,2 | 443,23 | 2,895 | 2,955 |

**Os dois critérios escolhem o ARMA(1,1).** Como os três modelos têm o mesmo $k$, a penalidade é idêntica para todos: 6 no AIC e $3\ln150=15{,}03$ no BIC. A escolha se reduz a **maior verossimilhança**. A AU02 define os critérios divididos por $T$, e as duas colunas da direita mostram que a ordenação é a mesma.

**(b) Penalidades e propriedades assintóticas.**
- **Penalidade por parâmetro:** 2 no AIC e $\ln T$ no BIC. O BIC pune mais sempre que $\ln T\gt2$, isto é, a partir de $T=8$. Com $T=150$, cada parâmetro custa 5,01 no BIC, contra 2 no AIC.
- **BIC é consistente.** Se o modelo verdadeiro, de dimensão finita, está entre os candidatos, $P(\text{BIC escolhe o verdadeiro})\to1$. A penalidade $\ln T\to\infty$ elimina a sobreparametrização, e $\ln T/T\to0$ elimina a subparametrização.
- **AIC não é consistente.** A penalidade fixa deixa probabilidade positiva, mesmo assintoticamente, de **sobreparametrizar**.
- **AIC é eficiente.** Quando o processo verdadeiro não está entre os candidatos (por exemplo, é um AR($\infty$)), o AIC escolhe o modelo que minimiza o EQM de previsão de um passo assintoticamente (Shibata, 1980).
- **Implicação prática:** BIC para identificar a estrutura; AIC quando o objetivo é prever. No INPC, eles discordam exatamente assim (relatório, §3).

**Monte Carlo** (AR(1) verdadeiro, candidatos AR(1) a AR(4), 300 réplicas):

| $T$ | AIC acerta | BIC acerta |
|---|---|---|
| 100 | 74,3% | 95,3% |
| 1000 | 78,0% | 99,0% |

O BIC converge para 100%. O AIC estabiliza em torno de 3/4: o resto é sobreparametrização que não desaparece com $T$.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| m04_q14_ln_t | 5,0106 |
| m04_q14_aic_arma11 | 426,6 |
| m04_q14_bic_arma11 | 435,63 |
| m04_q14_aic_t_arma11 | 2,844 |
| m04_q14_bic_t_arma11 | 2,904 |
| m04_q14_aic_arma20 | 431,6 |
| m04_q14_bic_arma20 | 440,63 |
| m04_q14_aic_t_arma20 | 2,877 |
| m04_q14_bic_t_arma20 | 2,938 |
| m04_q14_aic_arma02 | 434,2 |
| m04_q14_bic_arma02 | 443,23 |
| m04_q14_aic_t_arma02 | 2,895 |
| m04_q14_bic_t_arma02 | 2,955 |
| m04_q14_pen_bic | 15,03 |
| m04_q14_t_cruza | 8 |
| m04_q14_mc_aic_t100 | 0,743 |
| m04_q14_mc_bic_t100 | 0,953 |
| m04_q14_mc_aic_t1000 | 0,780 |
| m04_q14_mc_bic_t1000 | 0,990 |
-->
