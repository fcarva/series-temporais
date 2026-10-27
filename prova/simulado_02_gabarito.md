---
title: "Simulado 02 — gabarito com rubrica"
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
  - Gabarito do Simulado 02 — séries temporais
---

# Simulado 02 — gabarito

Enunciado em [simulado_02.md](simulado_02.md). Números de [prova.R](prova.R). Erros vão para o [log](log_erros.md).

---

## Questão 1 (1,5)

### a) O processo harmônico é estacionário (0,4)

- $E(z_t)=\cos(\omega t)E(A)+\sin(\omega t)E(B)=0$, para todo $t$.
- Como $\operatorname{Cov}(A,B)=0$ e $\operatorname{Var}(A)=\operatorname{Var}(B)=\sigma^2$:

$$
\operatorname{Cov}(z_t,z_{t-k})=\sigma^2\big[\cos(\omega t)\cos(\omega(t-k))+\sin(\omega t)\sin(\omega(t-k))\big]=\sigma^2\cos(\omega k),
$$

pela identidade $\cos(x-y)=\cos x\cos y+\sin x\sin y$.

**Conclusão:** média constante e autocovariância que só depende de $k$: **estacionário de segunda ordem**. A variância é $\sigma^2$, finita.

### b) Covariâncias e o componente determinístico (0,4)

Com $\omega=\pi/2$: $\operatorname{Cov}(z_t,z_{t-1})=\cos(\pi/2)=0$ e $\operatorname{Cov}(z_t,z_{t-2})=\cos(\pi)=-1$. Uma simulação com 20 mil pares $(A,B)$ dá $-0{,}9996$ para $z_7z_5$, sem depender de $t$.

**Por que é determinístico:** duas observações bastam para resolver $A$ e $B$ e, daí em diante, **todo o futuro é previsto sem erro**. Não há choque novo: o erro de previsão um passo à frente é zero. No Teorema de Wold, $y_t=\sum_j\psi_j\varepsilon_{t-j}+V_t$, esse é o termo $V_t$, previsível linearmente a partir do passado remoto e não correlacionado com os $\varepsilon$. Um processo "puramente não determinístico" é aquele em que $V_t=0$ (lista, Q4a; Hamilton, cap. 4).

### c) Duas representações para a mesma FAC (0,7)

**Convenção:** sinal positivo, $\theta(L)=1+\theta L$.

- $x_t=a_t+0{,}5a_{t-1}$, $\sigma^2=2$: $\gamma_0=(1+0{,}25)\cdot2=2{,}5$, $\gamma_1=0{,}5\cdot2=1$, $\rho_1=0{,}4$.
- $x^*_t=e_t+2e_{t-1}$, $\sigma^2=0{,}5$: $\gamma_0=(1+4)\cdot0{,}5=2{,}5$, $\gamma_1=2\cdot0{,}5=1$.

Em geral, $\theta$ e $1/\theta$ dão o mesmo $\rho_1=\theta/(1+\theta^2)$. A raiz de $1+0{,}5z$ é $z=-2$, com módulo 2, fora do círculo. A de $1+2z$ tem módulo 0,5, dentro.

**Escolha:** o invertível, $x_t$. Só ele tem uma representação AR($\infty$) convergente, $a_t=\sum_j(-0{,}5)^jx_{t-j}$. Isso permite recuperar os choques a partir dos dados, o que é necessário para a verossimilhança e para a previsão. Fixar a invertibilidade é o que torna o MA **identificado** (lista, Q4c).

| Rubrica | Pontos |
|---|---|
| a) média e $\operatorname{Cov}=\sigma^2\cos(\omega k)$ com a identidade citada | 0,3 |
| a) conclusão | 0,1 |
| b) os dois valores | 0,1 |
| b) previsível sem erro ⇒ termo $V_t$ de Wold | 0,3 |
| c) convenção declarada e as duas FAC | 0,4 |
| c) raízes, escolha do invertível e o porquê | 0,3 |

---

## Questão 2 (2,0)

### a) Estacionariedade (0,4)

- Triângulo: $\phi_1+\phi_2=0{,}8\lt1$; $\phi_2-\phi_1=-0{,}2\lt1$; $\lvert\phi_2\rvert=0{,}3\lt1$. As três valem.
- Raízes de $1-0{,}5z-0{,}3z^2=0$: $z=1{,}1736$ e $z=-2{,}8403$, ambas fora do círculo unitário.

**Conclusão: estacionário.** Como as raízes são reais, não há ciclo: a FAC decai sem a forma de senoide amortecida.

### b) Yule-Walker (0,5)

Multiplicando o modelo por $y_{t-k}$, $k\ge1$, e dividindo por $\gamma_0$: $\rho_k=\phi_1\rho_{k-1}+\phi_2\rho_{k-2}$.

- $k=1$: $\rho_1=\phi_1+\phi_2\rho_1\Rightarrow\rho_1=\frac{\phi_1}{1-\phi_2}=\frac{0{,}5}{0{,}7}=0{,}7143$.
- $k=2$: $\rho_2=\phi_1\rho_1+\phi_2=0{,}6571$.
- $k=3$: $\rho_3=\phi_1\rho_2+\phi_2\rho_1=0{,}5429$.

### c) Variância (0,4)

Multiplicando por $y_t$: $\gamma_0=\phi_1\gamma_1+\phi_2\gamma_2+\sigma^2$, logo

$$
\gamma_0=\frac{\sigma^2}{1-\phi_1\rho_1-\phi_2\rho_2}=\frac{(1-\phi_2)\sigma^2}{(1+\phi_2)\big[(1-\phi_2)^2-\phi_1^2\big]}=\frac{0{,}7}{1{,}3\cdot0{,}24}=2{,}2436 .
$$

### d) FACP (0,3)

$\phi_{11}=\rho_1=0{,}7143$; $\phi_{22}=\frac{\rho_2-\rho_1^2}{1-\rho_1^2}=0{,}3=\phi_2$; $\phi_{33}=0$. **A FACP de um AR(2) corta depois da defasagem 2**, e o último coeficiente não nulo é o próprio $\phi_2$.

### e) Pesos $\psi$ (0,4)

$\psi_j=\phi_1\psi_{j-1}+\phi_2\psi_{j-2}$, com $\psi_0=1$ e $\psi_{-1}=0$: $\psi_1=0{,}5$, $\psi_2=0{,}25+0{,}3=0{,}55$, $\psi_3=0{,}275+0{,}15=0{,}425$.

| Rubrica | Pontos |
|---|---|
| a) desigualdades e raízes, com a conclusão | 0,4 |
| b) equação geral de YW | 0,2 |
| b) três valores | 0,3 |
| c) $\gamma_0$ com a fórmula escrita | 0,4 |
| d) | 0,3 |
| e) recursão com $\psi_0=1$ e os três valores | 0,4 |

> [!WARNING]
> **Erro que custa ponto aqui**
> Escrever $\rho_2=\phi_2$ ou $\phi_{22}=\rho_2$. Quem é igual a $\phi_2$ é a **FACP** em 2, não a FAC.

---

## Questão 3 (2,0)

### a) SAR$(1)_4$ (0,7)

O modelo é um AR(1) em "anos": $y_t$ só se liga a $y_{t-4}$, $y_{t-8}$, e assim por diante.
- $\gamma_0=\sigma^2/(1-\Phi^2)=1/0{,}64=1{,}5625$.
- $\rho_{4m}=\Phi^m$: $\rho_4=0{,}6$ e $\rho_8=0{,}36$.
- $\rho_k=0$ fora dos múltiplos de 4, em particular $\rho_1=\rho_3=0$. Multiplicando por $y_{t-1}$: $\gamma_1=\Phi\gamma_3$ e $\gamma_3=\Phi\gamma_1$, logo $\gamma_1(1-\Phi^2)=0$.

A **FACP** tem um único pico, $\phi_{44}=0{,}6$, e é zero no resto. É o AR(1) "esticado" de 1 para 4 (lista, Q11).

### b) O AR(5) restrito (0,6)

$$
(1-0{,}5B)(1-0{,}6B^4)=1-0{,}5B-0{,}6B^4+0{,}3B^5
\ \Longrightarrow\
y_t=0{,}5y_{t-1}+0{,}6y_{t-4}-0{,}3y_{t-5}+\varepsilon_t .
$$

É um AR(5) com **três restrições**: $\phi_2=\phi_3=0$ e $\phi_5=-\phi_1\phi_4$, isto é, $-0{,}3=-(0{,}5)(0{,}6)$. O AR(5) livre teria 5 coeficientes; o multiplicativo tem 2.

### c) ARIMA(1,1,1) (0,4)

$(1-0{,}4B)(1-B)=1-1{,}4B+0{,}4B^2$, então

$$
\boxed{y_t=1{,}4y_{t-1}-0{,}4y_{t-2}+a_t-0{,}7a_{t-1}}
$$

Os coeficientes AR somam 1: é a raiz unitária aparecendo na equação em nível.

### d) A diferença é ARMA(1,1) (0,3)

$(1-0{,}4B)(1-B)y_t=(1-0{,}4B)w_t=(1-0{,}7B)a_t$. A raiz AR é $2{,}5$ e a raiz MA é $1{,}4286$, ambas fora do círculo: **estacionário e invertível**. O ARIMA($p$,1,$q$) é, por definição, um ARMA($p,q$) na diferença (lista, Q10a).

| Rubrica | Pontos |
|---|---|
| a) $\gamma_0$, $\rho_4$, $\rho_8$ | 0,3 |
| a) zeros fora dos múltiplos, com a justificativa | 0,2 |
| a) FACP | 0,2 |
| b) produto e equação | 0,3 |
| b) as três restrições | 0,3 |
| c) | 0,4 |
| d) | 0,3 |

---

## Questão 4 (1,5)

### a) Critérios (0,8)

$AIC=\frac{-2\ln L+2k}{T}$ e $BIC=\frac{-2\ln L+k\ln T}{T}$ (AU02), com $k$ incluindo $\sigma^2$.

| Modelo | $k$ | AIC (R) | BIC (R) | AIC$/T$ | BIC$/T$ |
|---|---|---|---|---|---|
| ARMA(1,1) | 3 | 346,8 | 355,162 | **2,890** | **2,960** |
| AR(2) | 3 | 349,8 | 358,162 | 2,915 | 2,985 |
| ARMA(2,1) | 4 | 347,6 | 358,750 | 2,897 | 2,990 |

**Os dois critérios escolhem o ARMA(1,1).** Dividir por $T$ não muda a ordenação; só muda a escala.

### b) Razão de verossimilhança (0,4)

- $H_0$: ARMA(1,1), isto é, $\phi_2=0$; $H_1$: ARMA(2,1).
- $LR=2(\ell_1-\ell_0)=2(-169{,}8+170{,}4)=1{,}2\sim\chi^2(1)$ sob $H_0$.
- $1{,}2\lt3{,}84$, com $p=0{,}273$: **não se rejeita $H_0$**.
- **Conclusão:** o segundo coeficiente AR não melhora o ajuste o bastante, e fica o ARMA(1,1), em linha com o BIC.

### c) Exata × condicional (0,3)

A exata acrescenta a densidade de $y_1\sim N\big(0,\sigma^2/(1-\phi^2)\big)$:

$$
\ell_{ex}=\ell_{cond}-\tfrac12\ln(2\pi)-\tfrac12\ln\frac{\sigma^2}{1-\phi^2}-\frac{(1-\phi^2)y_1^2}{2\sigma^2}.
$$

Esse termo não é quadrático em $\phi$, então a exata não tem forma fechada. Mas é **uma** parcela contra $T-1$: os dois estimadores são assintoticamente equivalentes (Hamilton, cap. 5).

| Rubrica | Pontos |
|---|---|
| a) fórmulas da AU02 com $k$ correto | 0,2 |
| a) números e escolha | 0,6 |
| b) quatro linhas do teste | 0,4 |
| c) | 0,3 |

---

## Questão 5 (1,5)

### a) ARMA(1,1) com sinal positivo (1,0)

**Convenção:** sinal positivo, $\theta=0{,}4$ entra **somando**.

- $z_{T+1\mid T}=0{,}5z_T+0{,}4\widehat a_T=1+0{,}4=1{,}4$.
- $z_{T+2\mid T}=0{,}5\cdot1{,}4=0{,}7$ e $z_{T+3\mid T}=0{,}35$: depois do primeiro passo, o MA some e a previsão decai como $\phi^{h-1}$.
- $\psi_1=\phi+\theta=0{,}9$ e $\psi_2=\phi\psi_1=0{,}45$. Na convenção BJ, seria $\phi-\theta$.
- $\operatorname{Var}(e_T(h))=\sigma^2\sum_{j=0}^{h-1}\psi_j^2$: $1$; $1{,}81$; $2{,}0125$.
- IC de 95% para $h=2$: $0{,}7\pm1{,}96\sqrt{1{,}81}=0{,}7\pm2{,}6369$, isto é, $[-1{,}9369;\ 3{,}3369]$.

### b) ARIMA(0,1,1) e suavização exponencial (0,5)

**Convenção:** BJ, $\theta=0{,}7$.
- $y_{T+1\mid T}=y_T-\theta\widehat a_T=50-1{,}4=48{,}6$.
- Para $h\ge2$: $y_{T+h\mid T}=y_{T+h-1\mid T}$. **A previsão é 48,6 para todo $h$**.

Como $\widehat a_T=y_T-y_{T\mid T-1}$:

$$
y_{T+1\mid T}=(1-\theta)y_T+\theta\,y_{T\mid T-1}=\alpha y_T+(1-\alpha)y_{T\mid T-1},\qquad \alpha=1-\theta=0{,}3 .
$$

Iterando, os pesos das observações passadas são $\alpha(1-\alpha)^j$: $0{,}3$; $0{,}21$; e assim por diante. É a suavização exponencial simples (lista, Q15e).

| Rubrica | Pontos |
|---|---|
| a) convenção declarada e três previsões | 0,3 |
| a) $\psi_1$, $\psi_2$ e variâncias | 0,4 |
| a) intervalo | 0,3 |
| b) previsão constante | 0,2 |
| b) forma de SES e $\alpha=1-\theta$ | 0,3 |

> [!CAUTION]
> **A troca de convenção é a armadilha da prova**
> Em 5a, $\psi_1=\phi+\theta$; em 5b, a previsão leva $-\theta\widehat a_T$. Quem resolve tudo na mesma convenção perde os dois itens. A lista faz isso de propósito na Q8.

---

## Questão 6 (1,5)

### a) Modelo (0,4)

$$
(1-\phi B)(1-B^{12})y_t=(1-\Theta B^{12})a_t
\ \Longrightarrow\
y_t=\phi y_{t-1}+y_{t-12}-\phi y_{t-13}+a_t-\Theta a_{t-12}.
$$

### b) Parâmetros e observações (0,2)

São $\phi$, $\Theta$ e $\sigma^2$: 3 parâmetros. Perdem-se $sD=12$ observações; sobram 132.

### c) Previsões (0,4)

$$
\begin{aligned}
y_{T+1\mid T}&=\phi y_T+y_{T-11}-\phi y_{T-12}-\Theta\widehat a_{T-11},\\
y_{T+13\mid T}&=\phi\,y_{T+12\mid T}+y_{T+1\mid T}-\phi y_T .
\end{aligned}
$$

O termo MA usa resíduos até $\widehat a_T$, o que vale para $h\le12$. Em $h=13$, ele já envolve $a_{T+1}$, cuja esperança é zero. O padrão sazonal de cada mês é carregado pelo $y_{T+h-12}$, ou pela sua previsão.

### d) Ljung-Box (0,5)

- $H_0$: $\rho_1=\dots=\rho_{24}=0$ nos erros; $H_1$: alguma autocorrelação.
- $Q=T(T+2)\sum_{k=1}^{24}\widehat r_k^2/(T-k)=28{,}5\sim\chi^2(\nu)$, com $\nu=K-p-q-P-Q=24-1-0-0-1=22$.
- $28{,}5\lt33{,}92$, com $p=0{,}160$: não se rejeita $H_0$.
- **Conclusão:** os resíduos não mostram autocorrelação até a defasagem 24, e o modelo capturou a dinâmica.

| Rubrica | Pontos |
|---|---|
| a) | 0,4 |
| b) | 0,2 |
| c) | 0,4 |
| d) $\nu=22$ descontando os parâmetros | 0,2 |
| d) decisão e conclusão | 0,3 |

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s2_q1_harm_mc | -0,9996 |
| pv_s2_q1_g0 | 2,5 |
| pv_s2_q1_g1 | 1 |
| pv_s2_q1_rho1 | 0,4 |
| pv_s2_q1_g0_nao_inv | 2,5 |
| pv_s2_q1_g1_nao_inv | 1 |
| pv_s2_q1_raiz_inv | 2 |
| pv_s2_q1_raiz_nao_inv | 0,5 |
| pv_s2_q2_soma | 0,8 |
| pv_s2_q2_dif | -0,2 |
| pv_s2_q2_raiz_pos | 1,1736 |
| pv_s2_q2_raiz_neg | -2,8403 |
| pv_s2_q2_rho1 | 0,7143 |
| pv_s2_q2_rho2 | 0,6571 |
| pv_s2_q2_rho3 | 0,5429 |
| pv_s2_q2_g0 | 2,2436 |
| pv_s2_q2_phi22 | 0,3 |
| pv_s2_q2_phi33 | 0 |
| pv_s2_q2_psi1 | 0,5 |
| pv_s2_q2_psi2 | 0,55 |
| pv_s2_q2_psi3 | 0,425 |
| pv_s2_q3_g0 | 1,5625 |
| pv_s2_q3_rho4 | 0,6 |
| pv_s2_q3_rho8 | 0,36 |
| pv_s2_q3_rho1 | 0 |
| pv_s2_q3_rho3 | 0 |
| pv_s2_q3_c1 | 0,5 |
| pv_s2_q3_c4 | 0,6 |
| pv_s2_q3_c5 | -0,3 |
| pv_s2_q3_arima_c1 | 1,4 |
| pv_s2_q3_arima_c2 | -0,4 |
| pv_s2_q4_aic_arma11 | 346,8 |
| pv_s2_q4_aic_ar2 | 349,8 |
| pv_s2_q4_aic_arma21 | 347,6 |
| pv_s2_q4_bic_arma11 | 355,162 |
| pv_s2_q4_bic_ar2 | 358,162 |
| pv_s2_q4_bic_arma21 | 358,750 |
| pv_s2_q4_aict_arma11 | 2,890 |
| pv_s2_q4_aict_ar2 | 2,915 |
| pv_s2_q4_aict_arma21 | 2,897 |
| pv_s2_q4_bict_arma11 | 2,960 |
| pv_s2_q4_bict_ar2 | 2,985 |
| pv_s2_q4_bict_arma21 | 2,990 |
| pv_s2_q4_ln120 | 4,7875 |
| pv_s2_q4_lr | 1,2 |
| pv_s2_q4_lr_p | 0,273 |
| pv_s2_q4_chi2_1 | 3,84 |
| pv_s2_q5_f1 | 1,4 |
| pv_s2_q5_f2 | 0,7 |
| pv_s2_q5_f3 | 0,35 |
| pv_s2_q5_psi1 | 0,9 |
| pv_s2_q5_psi2 | 0,45 |
| pv_s2_q5_v1 | 1 |
| pv_s2_q5_v2 | 1,81 |
| pv_s2_q5_v3 | 2,0125 |
| pv_s2_q5_meia2 | 2,6369 |
| pv_s2_q5_li2 | -1,9369 |
| pv_s2_q5_ls2 | 3,3369 |
| pv_s2_q5_ses_nivel | 48,6 |
| pv_s2_q5_ses_alfa | 0,3 |
| pv_s2_q5_ses_peso2 | 0,21 |
| pv_s2_q6_perda | 12 |
| pv_s2_q6_efetivas | 132 |
| pv_s2_q6_gl | 22 |
| pv_s2_q6_lb_crit | 33,92 |
| pv_s2_q6_lb_p | 0,160 |
-->
