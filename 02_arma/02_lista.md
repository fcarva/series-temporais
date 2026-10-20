---
title: "Módulo 02 — Lista resolvida (Q5–Q8)"
modulo: "02"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
aulas: "AU02"
lista: [5, 6, 7, 8]
status: rascunho
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
aliases:
  - ARMA — lista
---

# Módulo 02 — Processos AR, MA e ARMA (Q5–Q8)

Teoria em [02_teoria.md](02_teoria.md). Tudo é conferido em [02_arma.R](02_arma.R).

> [!CAUTION]
> **Sinal do MA: a lista muda de convenção entre as questões**
> - Q5, Q6, Q9, Q10, Q12, Q15 e Q16 usam a convenção de **Box-Jenkins**: $\theta(B)=1-\theta_1B-\theta_2B^2-\cdots$.
> - Q8 (modelo I) e os slides (AU02, p. 13) usam **sinal positivo**: $\theta(L)=1+\theta_1L+\cdots$.
>
> Em cada resposta, escreva a convenção na primeira linha. As fórmulas mudam de sinal: o $\rho_1$ do MA(1) é $-\theta/(1+\theta^2)$ numa convenção e $\theta/(1+\theta^2)$ na outra.

---

## Q5 — Notação $B$, classificação, estacionariedade, invertibilidade e pesos $\psi_j$, $\pi_j$

**Tipo:** cálculo · **Convenção:** Box-Jenkins. Os pesos seguem $\tilde z_t=\sum_{j\ge0}\psi_ja_{t-j}$ e $\tilde z_t=\sum_{j\ge1}\pi_j\tilde z_{t-j}+a_t$, ou seja, $\pi(B)=1-\sum\pi_jB^j$.

**Método.** $\psi(B)=\theta(B)/\phi(B)$ e $\pi(B)=\phi(B)/\theta(B)$. Na prática:
- $\psi_j=\sum_{i=1}^{p}\phi_i\psi_{j-i}-\theta_j$, com $\psi_0=1$;
- os $\pi_j$ saem da mesma recursão com os papéis de $\phi$ e $\theta$ trocados.

### (1) $(1-0{,}5B)\tilde z_t=a_t$: AR(1) = ARMA(1,0)

- **Estacionário:** a raiz de $1-0{,}5z=0$ é $z=2$, e $\lvert2\rvert\gt1$.
- **Invertível:** sempre, porque é AR puro.
- **Pesos:** $\psi_j=0{,}5^j$, isto é, $\psi_1,\dots,\psi_4=0{,}5;\ 0{,}25;\ 0{,}125;\ 0{,}0625$. E $\pi_1=0{,}5$, $\pi_j=0$ para $j\ge2$: o AR(1) já está na forma AR.

### (2) $\tilde z_t=(1-1{,}3B+0{,}4B^2)a_t$: MA(2) = ARMA(0,2)

- **Estacionário:** sempre, porque é MA finito.
- **Invertível:** $1-1{,}3z+0{,}4z^2=0$ dá $z=\frac{1{,}3\pm\sqrt{1{,}69-1{,}6}}{0{,}8}=\frac{1{,}3\pm0{,}3}{0{,}8}$, isto é, $z=2$ e $z=1{,}25$. As duas estão fora do círculo unitário, então o processo é invertível. Equivalentemente, $\theta(B)=(1-0{,}5B)(1-0{,}8B)$.
- **Pesos $\psi$:** $\psi_1=-1{,}3$, $\psi_2=0{,}4$ e $\psi_j=0$ para $j\ge3$.
- **Pesos $\pi$:** de $\pi(B)=1/(1-1{,}3B+0{,}4B^2)$, os coeficientes $c_j$ da expansão seguem $c_j=1{,}3c_{j-1}-0{,}4c_{j-2}$, com $c_0=1$. Isso dá $c_1=1{,}3$, $c_2=1{,}29$, $c_3=1{,}157$ e $c_4=0{,}9881$. Como $\pi_j=-c_j$: $\pi_1,\dots,\pi_4=-1{,}3;\ -1{,}29;\ -1{,}157;\ -0{,}9881$. Os pesos decaem devagar, porque a raiz 1,25 está perto do círculo unitário.

### (3) $(1-0{,}5B)\tilde z_t=(1-1{,}3B+0{,}4B^2)a_t$: aparentemente ARMA(1,2), na verdade **MA(1)**

O polinômio MA fatora como $(1-0{,}5B)(1-0{,}8B)$, e o fator $(1-0{,}5B)$ **cancela** com o AR:

$$
(1-0{,}5B)\tilde z_t=(1-0{,}5B)(1-0{,}8B)a_t\ \Longrightarrow\ \tilde z_t=(1-0{,}8B)a_t .
$$

- **Estacionário e invertível:** as raízes são 2 (AR) e 2 e 1,25 (MA), todas fora do círculo. Depois do cancelamento, sobra só a raiz 1,25 do MA.
- **Pesos $\psi$:** pela recursão sem cancelar, $\psi_1=0{,}5-1{,}3=-0{,}8$, $\psi_2=0{,}5(-0{,}8)+0{,}4=0$ e $\psi_3=\psi_4=0$. É o MA(1), como esperado.
- **Pesos $\pi$:** $\pi_j=-0{,}8^j$, isto é, $-0{,}8;\ -0{,}64;\ -0{,}512;\ -0{,}4096$.

> [!WARNING]
> **Redundância de parâmetros**
> Estimar um ARMA(1,2) numa série gerada pelo modelo (3) é mal identificado. Qualquer par $(\phi,\theta)$ com o mesmo fator comum gera a mesma FAC, a verossimilhança fica plana, os erros-padrão explodem e o otimizador não converge. Antes de classificar um ARMA, procure raízes comuns.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| m02_q5_m1_raiz | 2 |
| m02_q5_m1_psi1 | 0,5 |
| m02_q5_m1_psi2 | 0,25 |
| m02_q5_m1_psi3 | 0,125 |
| m02_q5_m1_psi4 | 0,0625 |
| m02_q5_m1_pi1 | 0,5 |
| m02_q5_m1_pi2 | 0 |
| m02_q5_m2_raiz1 | 1,25 |
| m02_q5_m2_raiz2 | 2 |
| m02_q5_m2_psi1 | -1,3 |
| m02_q5_m2_psi2 | 0,4 |
| m02_q5_m2_psi3 | 0 |
| m02_q5_m2_pi1 | -1,3 |
| m02_q5_m2_pi2 | -1,29 |
| m02_q5_m2_pi3 | -1,157 |
| m02_q5_m2_pi4 | -0,9881 |
| m02_q5_m3_psi1 | -0,8 |
| m02_q5_m3_psi2 | 0 |
| m02_q5_m3_psi3 | 0 |
| m02_q5_m3_psi4 | 0 |
| m02_q5_m3_pi1 | -0,8 |
| m02_q5_m3_pi2 | -0,64 |
| m02_q5_m3_pi3 | -0,512 |
| m02_q5_m3_pi4 | -0,4096 |
-->

## Q6 — ARMA(1,1): autocovariâncias, FAC e representações infinitas

**Tipo:** derivação · **Convenção:** Box-Jenkins, $z_t-\phi z_{t-1}=a_t-\theta a_{t-1}$ · **Ferramenta:** D02.2

**(a) Autocovariâncias.** Dois resultados auxiliares, com $a_t$ não correlacionado com o passado de $z$:

$$
E(z_ta_t)=\sigma_a^2,\qquad E(z_ta_{t-1})=\phi E(z_{t-1}a_{t-1})-\theta\sigma_a^2=(\phi-\theta)\sigma_a^2 .
$$

Multiplicando o modelo por $z_t$ e por $z_{t-1}$ e tomando esperanças:

$$
\gamma_0=\phi\gamma_1+\sigma_a^2-\theta(\phi-\theta)\sigma_a^2,\qquad \gamma_1=\phi\gamma_0-\theta\sigma_a^2 .
$$

Resolvendo o sistema:

$$
\boxed{\gamma_0=\frac{1+\theta^2-2\phi\theta}{1-\phi^2}\,\sigma_a^2,\qquad
\gamma_1=\frac{(1-\phi\theta)(\phi-\theta)}{1-\phi^2}\,\sigma_a^2,\qquad
\gamma_k=\phi\,\gamma_{k-1}\ (k\ge2)}
$$

Para $k\ge2$, $a_t$ e $a_{t-1}$ não se correlacionam com $z_{t-k}$, e só sobra a parte AR.

**(b) FAC.**

$$
\rho_1=\frac{(1-\phi\theta)(\phi-\theta)}{1+\theta^2-2\phi\theta}.
$$

De $\gamma_k=\phi\gamma_{k-1}$ para $k\ge2$, segue por indução que $\rho_k=\phi^{k-1}\rho_1$ para $k\ge1$. O MA só "mexe" no ponto de partida $\rho_1$; daí em diante, o decaimento é o do AR.

Exemplo com $\phi=0{,}8$, $\theta=0{,}4$ e $\sigma_a^2=1$: $\gamma_0=1{,}444$, $\gamma_1=0{,}756$, $\rho_1=0{,}523$ e $\rho_3=0{,}8^2\rho_1=0{,}335$, igual ao `ARMAacf`.

**(c) Representações infinitas.**
- **MA($\infty$):** $\psi(B)=\dfrac{1-\theta B}{1-\phi B}=1+(\phi-\theta)\sum_{j\ge1}\phi^{j-1}B^j$, logo $\psi_j=(\phi-\theta)\phi^{j-1}$. Converge se $\lvert\phi\rvert\lt1$.
- **AR($\infty$):** $\pi(B)=\dfrac{1-\phi B}{1-\theta B}=1-(\phi-\theta)\sum_{j\ge1}\theta^{j-1}B^j$, logo $\pi_j=(\phi-\theta)\theta^{j-1}$. Converge se $\lvert\theta\rvert\lt1$.

A **convergência é mais lenta** quando $\lvert\phi\rvert\to1$, para os $\psi_j$, e quando $\lvert\theta\rvert\to1$, para os $\pi_j$. Para os pesos caírem abaixo de 0,01:
- com $\phi=0{,}8$, bastam 17 pesos $\psi$; com $\phi=0{,}95$, são 79;
- com $\theta=0{,}4$, bastam 5 pesos $\pi$; com $\theta=0{,}95$, são 53.

Caso limite: se $\phi=\theta$, os fatores cancelam e $z_t=a_t$ é ruído branco.

<!-- conferência numérica (phi = 0,8; theta = 0,4)
| chave_R | nota |
|---|---|
| m02_q6_g0 | 1,444 |
| m02_q6_g1 | 0,756 |
| m02_q6_rho1 | 0,523 |
| m02_q6_rho3_formula | 0,335 |
| m02_q6_rho3_armaacf | 0,335 |
| m02_q6_psi3 | 0,256 |
| m02_q6_psi3_formula | 0,256 |
| m02_q6_pi3 | 0,064 |
| m02_q6_pi3_formula | 0,064 |
| m02_q6_n_psi_phi08 | 17 |
| m02_q6_n_psi_phi095 | 79 |
| m02_q6_n_pi_th04 | 5 |
| m02_q6_n_pi_th095 | 53 |
-->

## Q7 — AR(2): Yule-Walker e variância

**Tipo:** derivação · **Ferramenta:** D02.3

**(a) Yule-Walker.** Multiplique $y_t=\phi_1y_{t-1}+\phi_2y_{t-2}+\varepsilon_t$ por $y_{t-k}$, com $k\ge1$, tome esperanças e divida por $\gamma_0$. Como $E(\varepsilon_ty_{t-k})=0$:

$$
\rho_k=\phi_1\rho_{k-1}+\phi_2\rho_{k-2}.
$$

- Com $k=1$ ($\rho_0=1$, $\rho_{-1}=\rho_1$): $\rho_1=\phi_1+\phi_2\rho_1$, logo $\boxed{\rho_1=\dfrac{\phi_1}{1-\phi_2}}$.
- Com $k=2$: $\boxed{\rho_2=\phi_1\rho_1+\phi_2=\dfrac{\phi_1^2}{1-\phi_2}+\phi_2}$.

**(b) Variância.** Multiplique por $y_t$. Agora $E(\varepsilon_ty_t)=\sigma^2$:

$$
\gamma_0=\phi_1\gamma_1+\phi_2\gamma_2+\sigma^2
\ \Longrightarrow\ \gamma_0=\frac{\sigma^2}{1-\phi_1\rho_1-\phi_2\rho_2}.
$$

Substituindo $\rho_1$ e $\rho_2$ e simplificando:

$$
\boxed{\gamma_0=\frac{(1-\phi_2)\,\sigma^2}{(1+\phi_2)\big[(1-\phi_2)^2-\phi_1^2\big]}}
$$

O denominador é positivo exatamente no triângulo de estacionariedade: $\phi_1+\phi_2\lt1$, $\phi_2-\phi_1\lt1$ e $\lvert\phi_2\rvert\lt1$ (AU02, p. 41).

Exemplo com $\phi_1=0{,}5$, $\phi_2=0{,}3$ e $\sigma^2=1$: $\rho_1=0{,}714$, $\rho_2=0{,}657$ e $\gamma_0=2{,}244$, pelas duas fórmulas. Invertendo Yule-Walker com as autocorrelações amostrais de $T=20.000$ observações, recuperam-se $\widehat\phi_1=0{,}497$ e $\widehat\phi_2=0{,}303$.

<!-- conferência numérica (phi1 = 0,5; phi2 = 0,3)
| chave_R | nota |
|---|---|
| m02_q7_rho1 | 0,714 |
| m02_q7_rho2 | 0,657 |
| m02_q7_g0 | 2,244 |
| m02_q7_g0_alt | 2,244 |
| m02_q7_yw_phi1 | 0,497 |
| m02_q7_yw_phi2 | 0,303 |
-->

## Q8 — Verdadeiro ou falso: ARMA(1,1) e passeio com drift e tendência

**Tipo:** verdadeiro ou falso com demonstração. No modelo (I), o sinal do MA é **positivo**. Para (I), supomos o processo em regime estacionário: o $Y_0$ fixo só afeta o transiente.

**Auxiliares de (I).** $E(Y_tu_t)=\sigma^2$ e $E(Y_tu_{t-1})=\alpha E(Y_{t-1}u_{t-1})+\beta\sigma^2=(\alpha+\beta)\sigma^2$.

**1 — VERDADEIRA.** Multiplique o modelo por $Y_t$:

$$
\gamma_0=E\big(Y_t(\alpha Y_{t-1}+u_t+\beta u_{t-1})\big)=\alpha\gamma_1+\sigma^2+\beta(\alpha+\beta)\sigma^2 .
$$

Por estacionariedade, $E(Y_tY_{t-1})=E(Y_tY_{t+1})=\gamma_1$.

**2 — FALSA.** Multiplique $Y_{t+1}=\alpha Y_t+u_{t+1}+\beta u_t$ por $Y_t$:

$$
\gamma_1=\alpha\gamma_0+0+\beta\sigma^2 .
$$

A afirmativa acrescenta um $\alpha\sigma^2$ que não existe. Com $\alpha=0{,}6$, $\beta=0{,}3$ e $\sigma^2=1$: $\gamma_1=1{,}659$, contra $2{,}259$ na afirmativa.

**3 — FALSA (só vale para $h=1$).** Resolvendo 1 e 2:

$$
\rho_1=\frac{(\alpha+\beta)(1+\alpha\beta)}{1+2\alpha\beta+\beta^2},
$$

que é a expressão da afirmativa. Mas, para $h\ge2$, $\gamma_h=\alpha\gamma_{h-1}$, logo $\rho_h=\alpha^{h-1}\rho_1$, que **depende de $h$**. No exemplo, $\rho_1=0{,}732$ coincide com a afirmativa, mas $\rho_2=0{,}439\neq0{,}732$.

**4 — FALSA.** Iterando (II) a partir de $Z_0$:

$$
Z_t=Z_0+ct+\theta\sum_{s=1}^{t}s+\sum_{j=1}^{t}\varepsilon_j=Z_0+ct+\frac{\theta}{2}t^2+\frac{\theta}{2}t+\sum_{j=1}^{t}\varepsilon_j .
$$

Falta o termo $\frac{\theta}{2}t$, que vem da soma de PA $t(t+1)/2$. Com $c=0{,}5$, $\theta=0{,}1$ e $t=40$, a média correta é 102, e a afirmativa daria 100. A simulação dá 102,0.

**5 — FALSA.** A parte determinística não tem variância, e $Z_0$ não é aleatório:

$$
\operatorname{Var}(Z_t)=\operatorname{Var}\Big(\sum_{j=1}^{t}\varepsilon_j\Big)=t\sigma^2,
$$

que não depende de $c$ nem de $\theta$. No exemplo, a simulação dá $\approx40=t\sigma^2$, e a afirmativa daria 4,5.

> [!TIP]
> **Formato de prova**
> "Verdadeira/Falsa" na primeira palavra, depois a derivação de duas ou três linhas e, se for falsa, a expressão correta. Questões assim (estilo ANPEC) premiam quem escreve as condições: "sob estacionariedade", "$Z_0$ não aleatório".

<!-- conferência numérica (alpha = 0,6; beta = 0,3; c = 0,5; theta = 0,1; t = 40)
| chave_R | nota |
|---|---|
| m02_q8_g0 | 2,266 |
| m02_q8_af1 | 2,266 |
| m02_q8_g1 | 1,659 |
| m02_q8_g1_correto | 1,659 |
| m02_q8_af2 | 2,259 |
| m02_q8_rho1 | 0,732 |
| m02_q8_af3 | 0,732 |
| m02_q8_rho2 | 0,439 |
| m02_q8_z_media_correta | 102 |
| m02_q8_z_media_af4 | 100 |
| m02_q8_z_media_sim | 102,0 |
| m02_q8_z_var_sim | 40 |
| m02_q8_z_var_af5 | 4,5 |
-->
