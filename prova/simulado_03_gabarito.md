---
title: "Simulado 03 — gabarito com rubrica"
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
  - Gabarito do Simulado 03 — séries temporais
---

# Simulado 03 — gabarito

Enunciado em [simulado_03.md](simulado_03.md). Números de [prova.R](prova.R). Erros vão para o [log](log_erros.md).

---

## Questão 1 (1,5)

*Origem na lista:* (lista, Q2) e (lista, Q10): tendência determinística × estocástica e sobrediferenciação.

### a) TS (0,4)

- $E(y_t)=2+0{,}5t+E(u_t)=2+0{,}5t$, porque $u$ é um AR(1) estacionário de média zero. Logo $E(y_{10})=7$.
- $\operatorname{Var}(y_t)=\operatorname{Var}(u_t)=\sigma^2/(1-0{,}6^2)=1{,}5625$, **constante**. A média tem tendência; a variância, não.

### b) DS (0,3)

$z_t=0{,}5t+\sum_{j=1}^t\varepsilon_j$, logo $E(z_t)=0{,}5t$ e $\operatorname{Var}(z_t)=t\sigma^2$: $\operatorname{Var}(z_{10})=10$. A variância cresce com $t$.

### c) Persistência do choque (0,3)

- Em $y$: $\partial y_{t+5}/\partial\varepsilon_t=\psi_5=0{,}6^5=0{,}0778$. O choque é **transitório** e morre geometricamente.
- Em $z$: $\partial z_{t+5}/\partial\varepsilon_t=1$, e o mesmo vale para todo horizonte. O choque é **permanente**: é a raiz unitária (D03.1).

### d) Diferenciar a TS (0,5)

$\Delta y_t=0{,}5+\Delta u_t$. Aplicando $(1-0{,}6B)$:

$$
(1-0{,}6B)(\Delta y_t-0{,}5)=(1-B)\varepsilon_t ,
$$

um ARMA(1,1) com $\theta=1$, cujo MA tem raiz sobre o círculo: **não invertível**. Pela fórmula da Q9, $\rho_1=-(1-\phi)/2=-0{,}2$.

**Como tirar a não estacionariedade:**
- $y$ (TS): regredir em $1$ e $t$ e modelar o resíduo $u_t$ como AR(1). Diferenciar sobrediferencia.
- $z$ (DS): diferenciar. Tirar a tendência por regressão deixa uma raiz unitária no resíduo, com risco de regressão espúria.

Na prática, quem decide qual é o caso é o ADF com tendência (Mattos; Enders, cap. 4; lista, Q10).

| Rubrica | Pontos |
|---|---|
| a) | 0,4 |
| b) | 0,3 |
| c) os dois efeitos com a palavra transitório/permanente | 0,3 |
| d) forma ARMA e raiz unitária no MA | 0,2 |
| d) $\rho_1=-0{,}2$ | 0,1 |
| d) regra para cada série | 0,2 |

---

## Questão 2 (2,0)

*Origem na lista:* (lista, Q8), modelo (I), com o ARMA(1,1) da (lista, Q6).

**Convenção:** sinal positivo. Os momentos auxiliares, multiplicando o modelo por $u_t$ e por $u_{t-1}$, são:
- $E(Y_tu_t)=\sigma^2$;
- $E(Y_tu_{t-1})=\alpha\sigma^2+\beta\sigma^2=(\alpha+\beta)\sigma^2$.

Multiplicando por $Y_t$ e por $Y_{t-1}$:

$$
\gamma_0=\alpha\gamma_1+\sigma^2+\beta(\alpha+\beta)\sigma^2,\qquad \gamma_1=\alpha\gamma_0+\beta\sigma^2 .
$$

**1. Verdadeira.** Substituindo $\gamma_1$ na primeira: $\gamma_0(1-\alpha^2)=\sigma^2(1+\alpha\beta+\alpha\beta+\beta^2)$. Com os números, $\gamma_0=1{,}75/0{,}75=2{,}3333$.

**2. Verdadeira.**

$$
\gamma_1=\alpha\gamma_0+\beta\sigma^2=\frac{\alpha+2\alpha^2\beta+\alpha\beta^2+\beta-\alpha^2\beta}{1-\alpha^2}\sigma^2=\frac{(1+\alpha\beta)(\alpha+\beta)}{1-\alpha^2}\sigma^2 .
$$

Com os números, $\gamma_1=1{,}25/0{,}75=1{,}6667$ e $\rho_1=0{,}7143$.

**3. Verdadeira.** Para $h\ge2$, $E(u_tY_{t-h})=E(u_{t-1}Y_{t-h})=0$ *[causalidade]*, então $\gamma_h=\alpha\gamma_{h-1}$ e $\rho_2=\alpha\rho_1=0{,}3571$.

**4. Falsa.** $\sigma^2/(1-\alpha^2)=1{,}3333$ é a variância do AR(1) puro. O MA soma $(2\alpha\beta+\beta^2)\sigma^2/(1-\alpha^2)$, e o certo é $2{,}3333$.

**5. Falsa.** $\pi(B)=\frac{1-\alpha B}{1+\beta B}=(1-\alpha B)\sum_j(-\beta)^jB^j$. Então $\pi_j=(\alpha+\beta)(-\beta)^{j-1}$, com **sinal alternado**: $\pi_1=1$, $\pi_2=-0{,}5$, $\pi_3=0{,}25$. A expressão da afirmativa é a da convenção BJ com $\beta\to\theta$.

**6. Falsa.** A invertibilidade depende só do MA: exige $\lvert\beta\rvert\lt1$, isto é, a raiz de $1+\beta z$ fora do círculo. $\lvert\alpha\rvert\lt1$ garante a **estacionariedade**.

| Rubrica | Pontos |
|---|---|
| Momentos auxiliares e o sistema de $\gamma_0,\gamma_1$ | 0,4 |
| Cada afirmativa julgada **com** a conta que a sustenta (6 × 0,25) | 1,5 |
| Conferência numérica | 0,1 |

> [!WARNING]
> **Erro que custa ponto aqui**
> "V" ou "F" sem demonstração vale zero. O enunciado manda demonstrar: a conclusão é a última linha, não a única. É a lição da Q5 da P1 de Econometria I, que parou antes de concluir.

---

## Questão 3 (2,0)

*Origem na lista:* (lista, Q12).

### a) Expansão (0,6)

$$
(1-0{,}5B)(1-B)=1-1{,}5B+0{,}5B^2,
$$

$$
(1-1{,}5B+0{,}5B^2)(1-B^4)=1-1{,}5B+0{,}5B^2-B^4+1{,}5B^5-0{,}5B^6 ,
$$

$$
\boxed{y_t=1{,}5y_{t-1}-0{,}5y_{t-2}+y_{t-4}-1{,}5y_{t-5}+0{,}5y_{t-6}+a_t-0{,}6a_{t-4}}
$$

### b) Observações perdidas (0,2)

$d+sD=1+4=5$.

### c) Previsões (1,0)

Regra: valor conhecido fica; $y$ futuro vira a própria previsão; $E(a_{T+j}\mid\mathcal F_T)=0$ para $j\ge1$.

| $h$ | Conta | $y_{T+h\mid T}$ |
|---|---|---|
| 1 | $1{,}5(103)-0{,}5(107)+98-1{,}5(104)+0{,}5(100)-0{,}6(1{,}0)$ | 92,4 |
| 2 | $1{,}5(92{,}4)-0{,}5(103)+101-1{,}5(98)+0{,}5(104)-0{,}6(-0{,}5)$ | 93,4 |
| 3 | $1{,}5(93{,}4)-0{,}5(92{,}4)+107-1{,}5(101)+0{,}5(98)-0{,}6(0{,}8)$ | 97,92 |
| 4 | $1{,}5(97{,}92)-0{,}5(93{,}4)+103-1{,}5(107)+0{,}5(101)-0{,}6(0{,}4)$ | 92,94 |
| 5 | $1{,}5(92{,}94)-0{,}5(97{,}92)+92{,}4-1{,}5(103)+0{,}5(107)$ | 81,85 |

**Leitura mais curta de $h=1$:** a previsão é $y_{T-3}+(y_T-y_{T-4})+0{,}5[(y_T-y_{T-4})-(y_{T-1}-y_{T-5})]-0{,}6\widehat a_{T-3}$. Ou seja, o mesmo trimestre do ano anterior, mais a variação anual recente, mais a correção AR, menos o choque sazonal.

### d) MA e longo prazo (0,2)

O termo $-0{,}6a_{T+h-4}$ usa resíduos observados só até $h=4$. Em $h=5$, ele é $a_{T+1}$, de esperança zero. Daí em diante, as previsões seguem a equação homogênea, cujas raízes são $1$ (dupla), $-1$, $\pm i$ e $2$: **tendência linear + padrão sazonal fixo de período 4 + termo $0{,}5^h$ que some** (lista, Q12c).

| Rubrica | Pontos |
|---|---|
| a) | 0,6 |
| b) | 0,2 |
| c) regra da esperança condicional escrita | 0,2 |
| c) cinco previsões (0,16 cada) | 0,8 |
| d) | 0,2 |

> [!TIP]
> **Ganhe tempo**
> Escreva a equação do item a) uma vez e, para cada $h$, só substitua. Errar $h=1$ contamina os outros, mas a rubrica dá o ponto do método em cada linha.

---

## Questão 4 (1,5)

*Origem na lista:* (lista, Q16), item (d), e (lista, Q14).

### a) Parâmetros e observações (0,3)

- M1: $\phi$, $\theta$, $\Theta$ e $\sigma^2$, isto é, $k=4$.
- M2: $\phi_1$, $\phi_2$, $\theta$, $\Theta$ e $\sigma^2$, isto é, $k=5$.
- Observações efetivas: $240-(1+12)=227$.

### b) Critérios (0,6)

| Modelo | AIC $=-2\ln L+2k$ | BIC $=-2\ln L+k\ln 227$ |
|---|---|---|
| M1 | **833,2** | **846,900** |
| M2 | 833,8 | 850,925 |

Os dois escolhem M1.

### c) LR (0,4)

- $H_0$: $\phi_2=0$ (M1).
- $LR=2(-411{,}9+412{,}6)=1{,}4\sim\chi^2(1)$.
- $1{,}4\lt3{,}84$, com $p=0{,}237$: não se rejeita $H_0$.
- **Conclusão:** fica M1.

### d) Recomendação (0,2)

O **BIC**, porque é consistente. Como os modelos são aninhados, o LR é a confirmação formal. Se o objetivo for prever, o AIC e o erro fora da amostra são os árbitros (lista, Q16d).

| Rubrica | Pontos |
|---|---|
| a) | 0,3 |
| b) | 0,6 |
| c) | 0,4 |
| d) | 0,2 |

---

## Questão 5 (1,5)

*Origem na lista:* (lista, Q15), item (c), no caso MA($q$).

### a) Previsões (0,5)

**Convenção:** BJ, com $\theta(B)=1-\theta_1B-\theta_2B^2$, $\theta_1=0{,}5$ e $\theta_2=-0{,}2$. É um MA(2), sempre estacionário. É invertível? As raízes de $1-0{,}5z+0{,}2z^2$ são complexas, com módulo $\sqrt{1/0{,}2}=2{,}2361\gt1$: sim.

- $y_{T+1\mid T}=3-0{,}5(1)+0{,}2(-2)=2{,}1$.
- $y_{T+2\mid T}=3+0{,}2(1)=3{,}2$.
- $y_{T+3\mid T}=3$.

### b) Variâncias e intervalo (0,5)

$\psi_0=1$, $\psi_1=-0{,}5$, $\psi_2=0{,}2$, e então:
- $\operatorname{Var}(e_T(1))=1$;
- $\operatorname{Var}(e_T(2))=1+0{,}25=1{,}25$;
- $\operatorname{Var}(e_T(3))=1{,}25+0{,}04=1{,}29=\gamma_0/\sigma^2$.

IC de 95% para $h=3$: $3\pm1{,}96\sqrt{1{,}29}=3\pm2{,}2261$.

### c) A memória finita (0,5)

$y_{T+h}=\mu+a_{T+h}-\theta_1a_{T+h-1}-\theta_2a_{T+h-2}$. Para $h\gt2$, todos os choques são **futuros**, com esperança condicional zero. Logo:
- $y_{T+h\mid T}=\mu$;
- $e_T(h)=y_{T+h}-\mu$, cuja variância é $\operatorname{Var}(y_t)=\gamma_0$.

**Conclusão:** um MA($q$) só "lembra" $q$ períodos. Além disso, a melhor previsão é a média incondicional, e o intervalo tem a largura da distribuição marginal.

| Rubrica | Pontos |
|---|---|
| a) convenção e três previsões | 0,5 |
| b) variâncias com $\psi_0=1$ e intervalo | 0,5 |
| c) argumento e conclusão | 0,5 |

---

## Questão 6 (1,5)

*Origem na lista:* (lista, Q16), item (c), lido ao contrário: da FAC amostral para o modelo.

### a) Banda (0,3)

Com 227 observações efetivas, a banda é $\pm2/\sqrt{227}=\pm0{,}1327$ (com 1,96, $\pm0{,}1301$).
- **FAC** significativa nas defasagens 1, 11, 12 e 13.
- **FACP** significativa nas defasagens 1, 2, 12, 13 e 24, decaindo.

### b) O modelo (0,6)

FAC cortando em 1 e em 12, com os "satélites" 11 e 13, e FACP decaindo: **SARIMA$(0,1,1)(0,1,1)_{12}$**, o modelo das companhias aéreas. Com $\theta=\Theta=0{,}5$:
- $\rho_1=-\theta/(1+\theta^2)=-0{,}4$;
- $\rho_{12}=-0{,}4$;
- $\rho_{11}=\rho_{13}=\theta\Theta/[(1+\theta^2)(1+\Theta^2)]=0{,}16$;
- zero nas demais.

Os valores amostrais $-0{,}41$, $-0{,}39$, $0{,}17$ e $0{,}15$ batem.

### c) Ljung-Box (0,4)

- $\nu=24-0-1-0-1=22$.
- $Q=30{,}1\lt33{,}92$, com $p=0{,}116$: não se rejeita $H_0$ de ausência de autocorrelação.
- **Conclusão:** os resíduos se comportam como ruído branco até a defasagem 24.

### d) Pico em 12 nos resíduos (0,2)

A parte **sazonal** está mal especificada: falta um termo em $B^{12}$, ou o $\Theta$ estimado está errado. Se $\widehat\Theta\approx1$, há **sobrediferenciação sazonal**: a sazonalidade é determinística, e o melhor é usar dummies mensais com $D=0$ (módulo 03, Q12d).

| Rubrica | Pontos |
|---|---|
| a) | 0,3 |
| b) modelo | 0,2 |
| b) quatro valores teóricos e comparação | 0,4 |
| c) | 0,4 |
| d) | 0,2 |

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s3_q1_e_y10 | 7 |
| pv_s3_q1_var_u | 1,5625 |
| pv_s3_q1_var_z10 | 10 |
| pv_s3_q1_resposta_k5 | 0,0778 |
| pv_s3_q1_rho1_dy | -0,2 |
| pv_s3_q2_g0 | 2,3333 |
| pv_s3_q2_g1 | 1,6667 |
| pv_s3_q2_rho1 | 0,7143 |
| pv_s3_q2_rho2 | 0,3571 |
| pv_s3_q2_g0_errado | 1,3333 |
| pv_s3_q2_pi1 | 1 |
| pv_s3_q2_pi2 | -0,5 |
| pv_s3_q2_pi3 | 0,25 |
| pv_s3_q3_c1 | 1,5 |
| pv_s3_q3_c2 | -0,5 |
| pv_s3_q3_c4 | 1 |
| pv_s3_q3_c5 | -1,5 |
| pv_s3_q3_c6 | 0,5 |
| pv_s3_q3_perda | 5 |
| pv_s3_q3_f1 | 92,4 |
| pv_s3_q3_f2 | 93,4 |
| pv_s3_q3_f3 | 97,92 |
| pv_s3_q3_f4 | 92,94 |
| pv_s3_q3_f5 | 81,85 |
| pv_s3_q4_n | 227 |
| pv_s3_q4_ln227 | 5,4250 |
| pv_s3_q4_aic_m1 | 833,2 |
| pv_s3_q4_aic_m2 | 833,8 |
| pv_s3_q4_bic_m1 | 846,900 |
| pv_s3_q4_bic_m2 | 850,925 |
| pv_s3_q4_lr | 1,4 |
| pv_s3_q4_lr_p | 0,237 |
| pv_s3_q5_raiz_mod | 2,2361 |
| pv_s3_q5_f1 | 2,1 |
| pv_s3_q5_f2 | 3,2 |
| pv_s3_q5_f3 | 3 |
| pv_s3_q5_v1 | 1 |
| pv_s3_q5_v2 | 1,25 |
| pv_s3_q5_v3 | 1,29 |
| pv_s3_q5_g0 | 1,29 |
| pv_s3_q5_meia3 | 2,2261 |
| pv_s3_q6_banda | 0,1327 |
| pv_s3_q6_banda196 | 0,1301 |
| pv_s3_q6_rho1 | -0,4 |
| pv_s3_q6_rho12 | -0,4 |
| pv_s3_q6_rho11 | 0,16 |
| pv_s3_q6_rho13 | 0,16 |
| pv_s3_q6_lb_p | 0,116 |
| pv_s3_q6_lb_crit | 33,92 |
-->
