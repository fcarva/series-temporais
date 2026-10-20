---
title: "Formulário — ARMA, ARIMA e SARIMA"
disciplina: Econometria II (PPGEco/UFES)
periodo: 2026
tags:
  - series-temporais
  - mestrado/ppgeco
aliases:
  - Formulário
---

# Formulário

O MA está na convenção **Box-Jenkins**, $\theta(B)=1-\theta_1B-\cdots$, salvo indicação. Para a convenção de sinal positivo dos slides, troque $\theta\to-\theta$. Ver [CONVENCOES](../CONVENCOES.md) §2.

## Processos de referência

| Processo | $E(y_t)$ | $\operatorname{Var}(y_t)$ | $\operatorname{Cov}(y_t,y_{t-k})$ |
|---|---|---|---|
| RB$(0,\sigma^2)$ | 0 | $\sigma^2$ | 0 |
| Passeio aleatório, $y_0$ fixo | $y_0$ | $t\sigma^2$ | $(t-k)\sigma^2$ |
| Passeio com drift $c$ | $y_0+ct$ | $t\sigma^2$ | $(t-k)\sigma^2$ |
| Drift e tendência $\delta t$ | $y_0+ct+\delta t(t+1)/2$ | $t\sigma^2$ | $(t-k)\sigma^2$ |
| Processo linear $\sum\psi_j\varepsilon_{t-j}$ | $\mu$ | $\sigma^2\sum\psi_j^2$ | $\sigma^2\sum_j\psi_j\psi_{j+k}$ |

## AR, MA e ARMA

| Modelo | $\gamma_0$ | FAC | FACP |
|---|---|---|---|
| AR(1) | $\sigma^2/(1-\phi^2)$ | $\rho_k=\phi^k$ | $\phi_{11}=\phi$; zero depois |
| AR(2) | $\dfrac{(1-\phi_2)\sigma^2}{(1+\phi_2)[(1-\phi_2)^2-\phi_1^2]}$ | $\rho_1=\frac{\phi_1}{1-\phi_2}$, $\rho_2=\phi_1\rho_1+\phi_2$ | corta após 2 |
| MA(1) | $(1+\theta^2)\sigma^2$ | $\rho_1=-\theta/(1+\theta^2)$; zero depois | decai |
| MA($q$), sinal positivo | $\sigma^2\sum_{j=0}^{q}\theta_j^2$ | $\gamma_k=\sigma^2\sum_{j=0}^{q-k}\theta_j\theta_{j+k}$; corta em $q$ | decai |
| ARMA(1,1) | $\frac{1+\theta^2-2\phi\theta}{1-\phi^2}\sigma^2$ | $\rho_1=\frac{(1-\phi\theta)(\phi-\theta)}{1+\theta^2-2\phi\theta}$, $\rho_k=\phi^{k-1}\rho_1$ | decai |

- **Pesos do ARMA(1,1):** $\psi_j=(\phi-\theta)\phi^{j-1}$ e $\pi_j=(\phi-\theta)\theta^{j-1}$.
- **Yule-Walker:** $\rho_k=\sum_i\phi_i\rho_{k-i}$ para $k\ge1$, e $\gamma_0=\sigma^2/(1-\sum_i\phi_i\rho_i)$.
- **FACP:** $\phi_{11}=\rho_1$ e $\phi_{22}=(\rho_2-\rho_1^2)/(1-\rho_1^2)$.
- **Estacionariedade e invertibilidade:** as raízes de $\phi(z)$ e de $\theta(z)$ devem ficar fora do círculo unitário.
- **AR(2):** $\phi_1+\phi_2\lt1$, $\phi_2-\phi_1\lt1$ e $\lvert\phi_2\rvert\lt1$.
- **MA(1):** $\lvert\rho_1\rvert\le\frac12$.
- **Média e constante:** $c=(1-\sum\phi_i)\mu$.

## Integração e sazonalidade

- **Sobrediferenciação:** se $\phi(B)y_t=\theta(B)\varepsilon_t$, então $\phi(B)\Delta y_t=(1-B)\theta(B)\varepsilon_t$, e o MA fica não invertível. Se $y$ é RB, $\rho_1(\Delta y)=-1/2$.
- **TS diferenciada:** $y_t=\alpha+\beta t+u_t$ dá $\Delta y_t=\beta+u_t-u_{t-1}$.
- **SAR(1)$_s$:** $\gamma_{ms}=\Phi^m\sigma^2/(1-\Phi^2)$ e zero fora dos múltiplos de $s$. A FACP tem um pico, em $s$.
- **Multiplicativo:** $(1-\phi B)(1-\Phi B^s)=1-\phi B-\Phi B^s+\phi\Phi B^{s+1}$.
- **Observações perdidas** com $(1-B)^d(1-B^s)^D$: $d+sD$.

## Raiz unitária

- **ADF:** $\Delta y_t=\alpha+\beta t+\gamma y_{t-1}+\sum\delta_i\Delta y_{t-i}+e_t$, com $H_0:\gamma=0$.
- **Críticos assintóticos de 5%:** −1,95 sem determinísticos, −2,86 com constante e −3,41 com constante e tendência.
- **KPSS:** $H_0$ é estacionariedade.

## Estimação e seleção

- **AR(1), MV condicional:** $\widehat\phi=\sum y_ty_{t-1}/\sum y_{t-1}^2$, que é o MQO. Assintoticamente, $\operatorname{Var}(\widehat\phi)\approx(1-\phi^2)/T$.
- **Critérios no R:** $AIC=-2\ln L+2k$ e $BIC=-2\ln L+k\ln T$.
- **Critérios na AU02:** os mesmos divididos por $T$.
- **Contagem de $k$:** ARMA($p,q$) com média tem $k=p+q+1$, mais $\sigma^2$ se a questão contar a variância.

## Diagnóstico (AU03)

| Teste | $H_0$ | Estatística | Distribuição |
|---|---|---|---|
| Ljung-Box | $\rho_1=\dots=\rho_K=0$ | $T(T+2)\sum_{i=1}^{K}\widehat\rho_i^2/(T-i)$ | $\chi^2_{K-p-q}$ (resíduos) |
| Jarque-Bera | $S=0$ e $K=3$ | $\frac{T}{6}\widehat S^2+\frac{T}{24}(\widehat K-3)^2$ | $\chi^2_2$ |
| ARCH-LM | $\alpha_1=\dots=\alpha_p=0$ | $nR^2$ de $\widehat\varepsilon_t^2$ em $p$ defasagens | $\chi^2_p$ |
| Breusch-Godfrey | sem autocorrelação até $m$ | $nR^2$ da auxiliar | $\chi^2_m$ |
| Chow (data a priori) | coeficientes iguais | $F$ | $F(k,\,T-2k)$ |
| Diebold-Mariano | $E(d_t)=0$ | $\bar d/\sqrt{\widehat V(\bar d)}$ | $N(0,1)$ |

## Previsão

- **Previsor ótimo:** $y_{T+h\mid T}=E(y_{T+h}\mid\mathcal F_T)$.
- **Erro e sua variância:** $e_T(h)=\sum_{j=0}^{h-1}\psi_ja_{T+h-j}$ e $\operatorname{Var}=\sigma^2\sum_{j\lt h}\psi_j^2\to\gamma_0$.
- **ARMA(1,1):** $y_{T+1\mid T}=\phi y_T-\theta a_T$ e $y_{T+h\mid T}=\phi^{h-1}y_{T+1\mid T}$.
- **ARIMA(0,1,1) = SES:** $y_{T+1\mid T}=(1-\theta)y_T+\theta y_{T\mid T-1}$, com $\alpha=1-\theta$.
- **MASE:** $\frac{1}{n}\sum\lvert e_t\rvert/Q$, com $Q=\frac{1}{T_{tr}-m}\sum\lvert y_t-y_{t-m}\rvert$.
- **Winkler:** $W=(u-\ell)+\frac{2}{\alpha}(\ell-y)\mathbf 1\{y\lt\ell\}+\frac{2}{\alpha}(y-u)\mathbf 1\{y\gt u\}$.
