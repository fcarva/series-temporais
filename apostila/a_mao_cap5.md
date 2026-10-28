---
title: "Cap. 5 à mão — Q15 linha a linha"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: [15]
aulas: "AU02 p. 54–57, 72–76, 85"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Cap. 5 à mão — Q15
---

# Cap. 5 à mão: Q15, linha a linha

[← capítulo 5](cap5_previsao.md) · [← apostila](README.md) · [cap. 4 à mão](a_mao_cap4.md)

Versão de **caderno** do bloco 5 da lista: cada passagem numerada, uma operação por linha e o motivo entre colchetes. A notação é a dos slides: $\Omega_T$, $\widehat y_{T+h/T}$, $\theta_1=-\theta^{\text{lista}}$. Para encurtar, $E_T(\cdot)\equiv E(\cdot\mid\Omega_T)$ e $\operatorname{Var}_T(\cdot)\equiv\operatorname{Var}(\cdot\mid\Omega_T)$.

**Legenda:**
- [RB]: ruído branco;
- [F2]: série geométrica;
- [F4]: linearidade da esperança;
- [F9]: as três regras da previsão: o que é conhecido em $T$ fica, choque futuro vira zero, $y$ futuro vira a previsão;
- [inv.]: invertibilidade, ou seja, $\varepsilon_T$ é calculável a partir de $y_T,y_{T-1},\dots$;
- [(n)]: usando a linha (n).

---

# Q15 · Previsão de um ARMA($p,q$) estacionário e invertível

**Enunciado (lista, Q15).** Para um ARMA($p,q$) estacionário e invertível:
- (a) o previsor de mínimo EQM é a esperança condicional;
- (b) as previsões de um e de dois passos do ARMA(1,1);
- (c) o erro de previsão é um MA($h-1$), com variância em função dos $\psi_j$;
- (d) o intervalo de 95% com erros gaussianos;
- (e) no ARIMA(0,1,1), a previsão de longo prazo é constante (suavização exponencial), e qual é a constante de suavização.

## (a) A esperança condicional minimiza o EQM

Seja $g$ qualquer previsor construído com $\Omega_T$, $y\equiv y_{T+h}$ e $m\equiv E_T(y)$.

$$
\begin{aligned}
\text{(1)}\quad & E_T\big((y-g)^2\big)=E_T\big((y-m+m-g)^2\big) && [\text{soma e subtrai } m]\\
\text{(2)}\quad & \phantom{E_T}=E_T\big((y-m)^2\big)+2E_T\big((y-m)(m-g)\big)+E_T\big((m-g)^2\big) && [\text{quadrado, F4}]\\
\text{(3)}\quad & E_T\big((y-m)(m-g)\big)=(m-g)\,E_T(y-m) && [m-g \text{ conhecido em } T]\\
\text{(4)}\quad & E_T(y-m)=m-m=0 && [\text{definição de } m]\\
\text{(5)}\quad & E_T\big((m-g)^2\big)=(m-g)^2 && [\text{conhecido em } T]\\
\text{(6)}\quad & E_T\big((y-g)^2\big)=\operatorname{Var}_T(y)+(m-g)^2 && [(2)\text{–}(5)]\\
\text{(7)}\quad & E_T\big((y-g)^2\big)\ge\operatorname{Var}_T(y),\ \text{com igualdade}\iff g=m && [(m-g)^2\ge0]
\end{aligned}
$$

$$
\boxed{\widehat y_{T+h/T}=E(y_{T+h}\mid\Omega_T)\ \text{minimiza o EQM}}
$$

## (b) ARMA(1,1): um e dois passos

Modelo: $y_t=c+\phi_1y_{t-1}+\varepsilon_t+\theta_1\varepsilon_{t-1}$ (AU02, p. 85).

> [!CAUTION]
> **Erro do caderno (26/08): a previsão do MA(2) misturou os horizontes e pôs $\theta_2$ nos dois lugares**
> O caderno trocou $E(y_t\mid\Omega_{t-1})$ por $E(y_{t+2}\mid\Omega_t)$ na mesma linha. A defesa é sempre escrever o modelo **na data futura** antes de tirar a esperança, como em (8) e (11), e só então aplicar as regras [F9].

$$
\begin{aligned}
\text{(8)}\quad & y_{T+1}=c+\phi_1y_T+\varepsilon_{T+1}+\theta_1\varepsilon_T && [\text{modelo em } T+1]\\
\text{(9)}\quad & \widehat y_{T+1/T}=c+\phi_1y_T+E_T(\varepsilon_{T+1})+\theta_1E_T(\varepsilon_T) && [\text{F4}]\\
\text{(10)}\quad & \phantom{\widehat y_{T+1/T}}=c+\phi_1y_T+0+\theta_1\varepsilon_T && [\text{F9; inv.}]\\
\text{(11)}\quad & y_{T+2}=c+\phi_1y_{T+1}+\varepsilon_{T+2}+\theta_1\varepsilon_{T+1} && [\text{modelo em } T+2]\\
\text{(12)}\quad & \widehat y_{T+2/T}=c+\phi_1\widehat y_{T+1/T}+0+0 && [\text{F9: os dois choques são futuros}]\\
\text{(13)}\quad & \widehat y_{T+h/T}=c+\phi_1\widehat y_{T+h-1/T},\quad h\ge2 && [\text{mesma conta}]\\
\text{(14)}\quad & \widehat y_{T+h/T}-\mu=\phi_1^{\,h-1}\big(\widehat y_{T+1/T}-\mu\big)\to0 && [c=(1-\phi_1)\mu;\ \lvert\phi_1\rvert\lt1]\\
\text{(15)}\quad & \text{lista } (\mu=0):\ \widehat z_{T+1\mid T}=\phi z_T-\theta a_T;\quad \widehat z_{T+2\mid T}=\phi\,\widehat z_{T+1\mid T} && [\theta_1=-\theta]
\end{aligned}
$$

$$
\boxed{\widehat y_{T+1/T}=c+\phi_1y_T+\theta_1\varepsilon_T,\qquad \widehat y_{T+2/T}=c+\phi_1\widehat y_{T+1/T}}
$$

## (c) O erro de previsão é um MA($h-1$)

Pela forma de Wold, $y_t=\mu+\sum_{j\ge0}\psi_j\varepsilon_{t-j}$, com $\psi_0=1$:

$$
\begin{aligned}
\text{(16)}\quad & y_{T+h}=\mu+\textstyle\sum_{j=0}^{h-1}\psi_j\varepsilon_{T+h-j}+\sum_{j\ge h}\psi_j\varepsilon_{T+h-j} && [\text{separa futuro e passado}]\\
\text{(17)}\quad & \widehat y_{T+h/T}=\mu+0+\textstyle\sum_{j\ge h}\psi_j\varepsilon_{T+h-j} && [\text{F9; inv.}]\\
\text{(18)}\quad & e_{T+h/T}=y_{T+h}-\widehat y_{T+h/T}=\textstyle\sum_{j=0}^{h-1}\psi_j\varepsilon_{T+h-j} && [(16)-(17)]\\
\text{(19)}\quad & \text{(18) envolve } h \text{ choques futuros, defasagens } 0 \text{ a } h-1:\ \text{MA}(h-1) && [\text{forma}]\\
\text{(20)}\quad & E(e_{T+h/T})=\textstyle\sum_{j=0}^{h-1}\psi_jE(\varepsilon_{T+h-j})=0 && [\text{F4, soma finita; RB}]\\
\text{(21)}\quad & \operatorname{Var}(e_{T+h/T})=\textstyle\sum_{i=0}^{h-1}\sum_{j=0}^{h-1}\psi_i\psi_jE(\varepsilon_{T+h-i}\varepsilon_{T+h-j}) && [\text{F4}]\\
\text{(22)}\quad & \phantom{\operatorname{Var}(e_{T+h/T})}=\sigma^2\textstyle\sum_{j=0}^{h-1}\psi_j^2 && [\text{RB: só } i=j]\\
\text{(23)}\quad & h\to\infty:\ \operatorname{Var}(e_{T+h/T})\to\sigma^2\textstyle\sum_{j\ge0}\psi_j^2=\gamma_0 && [\text{processo linear}]\\
\text{(24)}\quad & \text{ARMA(1,1): } \psi_1=\phi_1+\theta_1\ \Rightarrow\ \operatorname{Var}(e_{T+2/T})=\sigma^2\big(1+(\phi_1+\theta_1)^2\big) && [(22),\ h=2]\\
\text{(25)}\quad & \psi_2=\phi_1(\phi_1+\theta_1)\ \Rightarrow\ \operatorname{Var}(e_{T+3/T})=\sigma^2\big(1+\psi_1^2+\psi_2^2\big) && [(22),\ h=3]\\
\text{(26)}\quad & \text{MA}(q):\ \psi_j=0 \text{ para } j\gt q\ \Rightarrow\ \operatorname{Var}(e_{T+h/T})=\gamma_0 \text{ para } h\gt q && [(22),\ \text{AU02 p. 57}]
\end{aligned}
$$

$$
\boxed{e_{T+h/T}=\textstyle\sum_{j=0}^{h-1}\psi_j\varepsilon_{T+h-j}\ \ (\text{MA}(h-1)),\qquad \operatorname{Var}(e_{T+h/T})=\sigma^2\sum_{j=0}^{h-1}\psi_j^2}
$$

## (d) Intervalo de 95%

$$
\begin{aligned}
\text{(27)}\quad & \varepsilon_t\sim N(0,\sigma^2)\Rightarrow e_{T+h/T}\sim N\big(0,\ \sigma^2\textstyle\sum_{j=0}^{h-1}\psi_j^2\big) && [\text{soma de normais}]\\
\text{(28)}\quad & P\big(\lvert e_{T+h/T}\rvert\le1{,}96\,\sigma_h\big)=0{,}95,\quad \sigma_h\equiv\sigma\sqrt{\textstyle\sum_{j=0}^{h-1}\psi_j^2} && [\text{normal padrão}]\\
\text{(29)}\quad & y_{T+h}\in\big[\widehat y_{T+h/T}-1{,}96\,\sigma_h;\ \widehat y_{T+h/T}+1{,}96\,\sigma_h\big] \text{ com prob. } 0{,}95 && [y=\widehat y+e]\\
\text{(30)}\quad & \operatorname{Cov}(e_{T+1/T},e_{T+2/T})=E\big(\varepsilon_{T+1}(\varepsilon_{T+2}+\psi_1\varepsilon_{T+1})\big)=\psi_1\sigma^2 && [\text{RB}]
\end{aligned}
$$

$$
\boxed{\widehat y_{T+h/T}\pm1{,}96\,\sigma\sqrt{\textstyle\sum_{j=0}^{h-1}\psi_j^2}}
$$

Em (30): os erros de horizontes diferentes, feitos na mesma origem, são **correlacionados**. Não se pode tratá-los como independentes.

## (e) ARIMA(0,1,1) e suavização exponencial

Nos slides, $\Delta y_t=\varepsilon_t+\theta_1\varepsilon_{t-1}$; na lista, $\theta_1=-\theta$, com $0\lt\theta\lt1$.

$$
\begin{aligned}
\text{(31)}\quad & y_{T+1}=y_T+\varepsilon_{T+1}+\theta_1\varepsilon_T && [\text{modelo em } T+1]\\
\text{(32)}\quad & \widehat y_{T+1/T}=y_T+\theta_1\varepsilon_T && [\text{F9}]\\
\text{(33)}\quad & \varepsilon_T=y_T-\widehat y_{T/T-1} && [\text{o choque é o erro de 1 passo}]\\
\text{(34)}\quad & \widehat y_{T+1/T}=(1+\theta_1)\,y_T-\theta_1\,\widehat y_{T/T-1} && [(33) \text{ em } (32)]\\
\text{(35)}\quad & \alpha\equiv1+\theta_1=1-\theta:\ \ \widehat y_{T+1/T}=\alpha\,y_T+(1-\alpha)\,\widehat y_{T/T-1} && [\theta_1=-\theta]\\
\text{(36)}\quad & \widehat y_{T+1/T}=\alpha\textstyle\sum_{j\ge0}(1-\alpha)^jy_{T-j} && [(35) \text{ iterada}]\\
\text{(37)}\quad & \alpha\textstyle\sum_{j\ge0}(1-\alpha)^j=\alpha\cdot\frac{1}{1-(1-\alpha)}=1 && [\text{F2: pesos somam 1}]\\
\text{(38)}\quad & \widehat y_{T+h/T}=\widehat y_{T+h-1/T}+0=\cdots=\widehat y_{T+1/T},\ \ h\ge2 && [\text{F9: choques futuros}]\\
\text{(39)}\quad & y_t=\frac{1+\theta_1L}{1-L}\varepsilon_t:\ \ \psi_0=1,\ \ \psi_j=1+\theta_1=\alpha,\ j\ge1 && [\text{F2, F7}]\\
\text{(40)}\quad & \operatorname{Var}(e_{T+h/T})=\sigma^2\big(1+(h-1)\alpha^2\big)\to\infty && [(22)]
\end{aligned}
$$

$$
\boxed{\widehat y_{T+h/T}=\alpha\textstyle\sum_{j\ge0}(1-\alpha)^jy_{T-j}\ \text{para todo } h,\qquad \alpha=1-\theta=1+\theta_1}
$$

**A previsão é plana**, e a constante de suavização é $\alpha=1-\theta$. A **incerteza**, porém, cresce linearmente com $h$, por (40): o leque abre para sempre, porque o processo é I(1).

---

## Versão para a prova

1. **(a)** Some e subtraia $m$; o termo cruzado zera, e sobra $\operatorname{Var}_T(y)+(m-g)^2$, mínimo em $g=m$.
2. **(b)** Modelo em $T+1$ e $T+2$, regras [F9]: $\widehat y(1)=c+\phi_1y_T+\theta_1\varepsilon_T$ e $\widehat y(2)=c+\phi_1\widehat y(1)$.
3. **(c)** Separe futuro e passado na forma de Wold: $e=\sum_{j\lt h}\psi_j\varepsilon_{T+h-j}$, com variância $\sigma^2\sum_{j\lt h}\psi_j^2$.
4. **(d)** $\widehat y\pm1{,}96\,\sigma\sqrt{\sum_{j\lt h}\psi_j^2}$.
5. **(e)** $\widehat y(1)=\alpha y_T+(1-\alpha)\widehat y_{T/T-1}$, com $\alpha=1-\theta$; previsão plana; variância $\sigma^2(1+(h-1)\alpha^2)$.

## Conferência

**AR(1)** com $\mu=10$, $\phi_1=0{,}8$, $\sigma^2=1$ e $y_T=14$:
- previsões 13,2; 12,56; 12,048;
- variâncias do erro 1; 1,64; 2,0496, com limite 2,7778;
- intervalo em $h=1$: [11,24; 15,16].

**ARMA(1,1)** com $\phi_1=0{,}8$, $\theta_1=0{,}6$, $y_T=2$ e $\varepsilon_T=0{,}5$:
- $\widehat y(1)=1{,}9$ e $\widehat y(2)=1{,}52$;
- variâncias do erro 2,96 em $h=2$ e 4,2144 em $h=3$;
- intervalo em $h=2$: [$-1{,}852$; 4,892];
- $\operatorname{Cov}(e_1,e_2)=\psi_1=1{,}4$.

**Suavização exponencial** com $\theta=0{,}6$:
- $\alpha=0{,}4$, com pesos 0,4; 0,24; 0,144;
- a recursão (35) coincide com o `predict` do ARIMA(0,1,1) do R, com diferença zero, e a previsão de 3 passos é igual à de 1.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_c5_ar_prev1 | 13,2 |
| ap_c5_ar_prev2 | 12,56 |
| ap_c5_ar_prev3 | 12,048 |
| ap_c5_ar_var1 | 1 |
| ap_c5_ar_var2 | 1,64 |
| ap_c5_ar_var3 | 2,0496 |
| ap_c5_ar_varinf | 2,7778 |
| ap_c5_ar_ic1_inf | 11,24 |
| ap_c5_ar_ic1_sup | 15,16 |
| ap_c5_arma_prev1 | 1,9 |
| ap_c5_arma_prev2 | 1,52 |
| ap_c5_arma_var2 | 2,96 |
| ap_c5_arma_var3 | 4,2144 |
| ap_am5_ic2_inf | -1,852 |
| ap_am5_ic2_sup | 4,892 |
| ap_am5_cov12 | 1,4 |
| ap_c5_ses_alpha | 0,4 |
| ap_c5_ses_w0 | 0,4 |
| ap_c5_ses_w1 | 0,24 |
| ap_c5_ses_w2 | 0,144 |
| ap_c5_ses_dif | 0 |
| ap_c5_ses_plano | 0 |
-->
