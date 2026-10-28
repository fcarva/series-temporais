---
title: "Cap. 1 à mão — Q1 a Q4 linha a linha"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: [1, 2, 3, 4]
aulas: "AU01 p. 25–31; AU02 p. 15–34"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Cap. 1 à mão — Q1 a Q4
---

# Cap. 1 à mão: Q1 a Q4, linha a linha

[← capítulo 1](cap1_processos_momentos.md) · [← apostila](README.md) · [cap. 2 à mão](a_mao_cap2.md)

Versão de **caderno** do bloco 1 da lista: cada passagem numerada, uma operação por linha e o motivo entre colchetes. A numeração é contínua do início ao fim. Os símbolos são os dos slides; a lista usa $u_t$ ou $a_t$ para o choque, e aqui ele é $u_t$ ou $\varepsilon_t$, conforme o enunciado.

**Legenda:**
- [RB]: ruído branco;
- [F2]: série geométrica;
- [F3]: soma de Gauss;
- [F4]: linearidade da esperança, inclusive em soma finita;
- [F5]: covariância de combinações lineares;
- [estac.]: os momentos não dependem da data;
- [caus.]: o choque de hoje não se correlaciona com o passado;
- [(n)]: usando a linha (n).

As ferramentas estão na [caixa de ferramentas](../lista_comentada/README.md#2-caixa-de-ferramentas).

---

# Q1 · Passeio com drift e valor inicial 10

**Enunciado (lista, Q1).** $y_t=c+y_{t-1}+u_t$, com $y_0=10$ e $u_t$ ruído branco. Pede-se $E(y_t)$, $\operatorname{Var}(y_t)$ e $\operatorname{Cov}(y_t,y_{t-k})$, e se o processo é estacionário. A lista escreve $RB(0,\sigma)$; leia como variância $\sigma^2$.

**Nos slides:** é o passeio com drift da AU01, p. 29, com $\alpha_1=c$ e $y_0=10$.

$$
\begin{aligned}
\text{(1)}\quad & y_s-y_{s-1}=c+u_s && [\text{modelo}]\\
\text{(2)}\quad & \textstyle\sum_{s=1}^{t}(y_s-y_{s-1})=y_t-y_0 && [\text{telescópica}]\\
\text{(3)}\quad & y_t=10+ct+\textstyle\sum_{s=1}^{t}u_s && [(1),(2),\ y_0=10]\\
\text{(4)}\quad & E(y_t)=10+ct+\textstyle\sum_{s=1}^{t}E(u_s) && [\text{F4, soma finita}]\\
\text{(5)}\quad & \phantom{E(y_t)}=10+ct && [\text{RB}]\\
\text{(6)}\quad & y_t-E(y_t)=\textstyle\sum_{s=1}^{t}u_s && [(3)-(5)]\\
\text{(7)}\quad & \operatorname{Var}(y_t)=E\Big(\big(\textstyle\sum_{i=1}^{t}u_i\big)^2\Big)=\textstyle\sum_{i=1}^{t}\sum_{j=1}^{t}E(u_iu_j) && [(6),\ \text{F4}]\\
\text{(8)}\quad & \phantom{\operatorname{Var}(y_t)}=\textstyle\sum_{i=1}^{t}E(u_i^2)=t\sigma^2 && [\text{RB: só } i=j]\\
\text{(9)}\quad & \operatorname{Cov}(y_t,y_{t-k})=E\big(\textstyle\sum_{i=1}^{t}u_i\sum_{j=1}^{t-k}u_j\big) && [(6)\text{ em } t \text{ e } t-k]\\
\text{(10)}\quad & \phantom{\operatorname{Cov}(y_t,y_{t-k})}=\textstyle\sum_{j=1}^{t-k}E(u_j^2)=(t-k)\,\sigma^2 && [\text{RB: só os pares comuns}]\\
\text{(11)}\quad & \operatorname{Corr}(y_t,y_{t-k})=\frac{(t-k)\sigma^2}{\sqrt{t\sigma^2\,(t-k)\sigma^2}}=\sqrt{\frac{t-k}{t}} && [(8),(10)]\\
\text{(12)}\quad & \operatorname{Var}(y_t)=t\sigma^2 \text{ depende de } t\ \Rightarrow\ \text{não estacionário} && [\text{AU01 p. 25}]
\end{aligned}
$$

$$
\boxed{E(y_t)=10+ct,\qquad \operatorname{Var}(y_t)=t\sigma^2,\qquad \operatorname{Cov}(y_t,y_{t-k})=(t-k)\sigma^2:\ \text{não estacionário}}
$$

Mesmo com $c=0$, quando a média fica constante em 10, a variância cresce: a conclusão não depende do drift. E a correlação (11) vai a 1 para $k$ fixo e $t$ grande: com $t=100$ e $k=10$, $\sqrt{0{,}9}=0{,}95$. É a FAC que decai devagar, assinatura da raiz unitária.

> [!CAUTION]
> **Erro do caderno (19/08): $E(XY)=E(X)E(Y)$ escrito sem condição**
> Essa regra só vale para variáveis **não correlacionadas**, e $\sigma^2=E(X^2)$ só vale com média zero. Em (8), o que zera os termos com $i\ne j$ é a hipótese de ruído branco, $E(u_iu_j)=0$, e não uma regra geral da esperança.

---

# Q2 · Drift e tendência: o esqueleto, com a demonstração completa ao lado

A Q2 está demonstrada por inteiro na [folha da Q2 e da Q6](../lista_comentada/a_mao_q02_q06.md), em 38 linhas, inclusive a esperança do somatório parcela por parcela. O esqueleto, nos slides, com $Y_t=\alpha_1+Y_{t-1}+\alpha_2t+\varepsilon_t$ e $Y_0=0$:

$$
\begin{aligned}
\text{(13)}\quad & Y_t=\alpha_1t+\alpha_2\,\tfrac{t(t+1)}{2}+\textstyle\sum_{s=1}^{t}\varepsilon_s && [\text{telescópica, F3}]\\
\text{(14)}\quad & E(Y_t)=\alpha_1t+\alpha_2\,\tfrac{t(t+1)}{2} && [\text{F4, soma finita; RB}]\\
\text{(15)}\quad & \operatorname{Var}(Y_t)=t\sigma^2,\qquad \operatorname{Cov}(Y_t,Y_{t-k})=(t-k)\sigma^2 && [\text{RB: só } i=j]\\
\text{(16)}\quad & \text{comparado ao drift puro: só a média muda (reta} \to \text{parábola)} && [(14),(15)]\\
\text{(17)}\quad & \Delta Y_t=\alpha_1+\alpha_2t+\varepsilon_t:\ \text{ainda tem tendência; regredir em } t && [\text{diferença} + \text{regressão}]\\
\text{(18)}\quad & \Delta^2Y_t=\alpha_2+(1-L)\varepsilon_t:\ \text{MA com raiz } z=1,\ \text{não invertível} && [\text{evitar}]
\end{aligned}
$$

---

# Q3 · Soma de dois processos não correlacionados

**Enunciado (lista, Q3).** São dados dois processos estacionários e não correlacionados:
- $z_{1t}$, com $\gamma_0=0{,}5$, $\gamma_1=0{,}2$ e zero depois;
- $z_{2t}$, com $\gamma_0=2{,}30$, $\gamma_1=-1{,}43$, $\gamma_2=0{,}30$ e zero depois.

Seja $z_{3t}=z_{1t}+2z_{2t}$. Pede-se a autocovariância de $z_3$, se ele é estacionário e a sua classe ARMA.

Notação para as covariâncias cruzadas: $C_{12}(k)=\operatorname{Cov}(z_{1t},z_{2,t-k})$ e $C_{21}(k)=\operatorname{Cov}(z_{2t},z_{1,t-k})$.

$$
\begin{aligned}
\text{(19)}\quad & E(z_{3t})=E(z_{1t})+2E(z_{2t})=\mu_1+2\mu_2 && [\text{F4: constante}]\\
\text{(20)}\quad & \gamma_3(k)=\operatorname{Cov}\big(z_{1t}+2z_{2t},\ z_{1,t-k}+2z_{2,t-k}\big) && [\text{definição}]\\
\text{(21)}\quad & \phantom{\gamma_3(k)}=\gamma_1(k)+2C_{12}(k)+2C_{21}(k)+4\gamma_2(k) && [\text{F5}]\\
\text{(22)}\quad & \phantom{\gamma_3(k)}=\gamma_1(k)+4\,\gamma_2(k) && [\text{não correlacionados}]\\
\text{(23)}\quad & \gamma_3(0)=0{,}5+4(2{,}30)=0{,}5+9{,}2=9{,}7 && [(22),\ k=0]\\
\text{(24)}\quad & \gamma_3(1)=0{,}2+4(-1{,}43)=0{,}2-5{,}72=-5{,}52 && [(22),\ k=1]\\
\text{(25)}\quad & \gamma_3(2)=0+4(0{,}30)=1{,}2 && [(22),\ k=2]\\
\text{(26)}\quad & \gamma_3(k)=0+4\cdot0=0,\quad k\ge3 && [(22)]\\
\text{(27)}\quad & \text{média const.},\ \gamma_3(0)\lt\infty,\ \gamma_3(k)=f(k)\Rightarrow\text{estacionário} && [\text{AU01 p. 25}]\\
\text{(28)}\quad & \rho_1=\frac{-5{,}52}{9{,}7}=-0{,}5691;\qquad \rho_2=\frac{1{,}2}{9{,}7}=0{,}1237;\qquad \rho_k=0,\ k\ge3 && [\div\gamma_3(0)]\\
\text{(29)}\quad & \text{FAC corta depois de } 2\ \Rightarrow\ \text{MA(2)} && [\text{AU02 p. 51–52}]\\
\text{(30)}\quad & z_3 \text{ só contém choques de } t \text{ a } t-2 \text{ de cada parcela} && [\text{MA}(\max\{1,2\})]
\end{aligned}
$$

$$
\boxed{\gamma_3(k)=\gamma_1(k)+4\gamma_2(k)=(9{,}7;\ -5{,}52;\ 1{,}2;\ 0;\dots):\ \text{estacionário, MA(2)}}
$$

**Quem são $z_1$ e $z_2$?** O enunciado não pede, mas a conta mostra que os números são consistentes:

$$
\begin{aligned}
\text{(31)}\quad & z_1:\ \rho_1=\frac{0{,}2}{0{,}5}=0{,}4=\frac{\theta}{1+\theta^2}\ \Rightarrow\ 0{,}4\theta^2-\theta+0{,}4=0 && [\text{MA(1), D2.1}]\\
\text{(32)}\quad & \Delta=0{,}36;\ \ \theta=\tfrac{1\pm0{,}6}{0{,}8}\in\{2;\ 0{,}5\}\ \Rightarrow\ \theta=0{,}5,\ \sigma^2=\tfrac{0{,}2}{0{,}5}=0{,}4 && [\text{F1; invertível}]\\
\text{(33)}\quad & z_2:\ \sigma^2=1,\ \theta_2=0{,}3,\ \theta_1(1+\theta_2)=-1{,}43\Rightarrow\theta_1=-1{,}1 && [\gamma_1,\ \gamma_2 \text{ do MA(2)}]\\
\text{(34)}\quad & \text{confere: } \gamma_0=1+1{,}21+0{,}09=2{,}30;\ \ 1-1{,}1z+0{,}3z^2=0\Rightarrow z\in\{2;\ 1{,}667\} && [\text{invertível}]
\end{aligned}
$$

---

# Q4 · Teorema de Wold

**Enunciado (lista, Q4).** São três itens:
- (a) enunciar o teorema e discutir o componente determinístico;
- (b) mostrar que o AR(1) estacionário satisfaz a decomposição e identificar os $\psi_j$;
- (c) explicar por que a invertibilidade do MA é necessária para um AR($\infty$) convergente.

**(a) O enunciado**, para $y_t$ estacionário de 2ª ordem com média zero (HAMILTON, cap. 4; AU02, p. 15–18):

$$
\begin{aligned}
\text{(35)}\quad & y_t=\textstyle\sum_{j\ge0}\psi_j\varepsilon_{t-j}+\kappa_t && [\text{decomposição}]\\
\text{(36)}\quad & \psi_0=1,\qquad \textstyle\sum_{j\ge0}\psi_j^2\lt\infty && [\text{condições}]\\
\text{(37)}\quad & \varepsilon_t=y_t-\widehat E(y_t\mid y_{t-1},y_{t-2},\dots) && [\text{erro da melhor previsão linear}]\\
\text{(38)}\quad & E(\varepsilon_t)=0,\ \ E(\varepsilon_t^2)=\sigma^2,\ \ E(\varepsilon_t\varepsilon_s)=0\ (s\ne t) && [\varepsilon_t\perp\text{passado}]\\
\text{(39)}\quad & E(\kappa_t\varepsilon_s)=0 \text{ para todos } t,s && [\text{ortogonalidade}]\\
\text{(40)}\quad & \kappa_t \text{ previsto sem erro; ex.: } \kappa_t=a\cos\lambda t+b\sin\lambda t && [\text{determinístico}]
\end{aligned}
$$

O componente determinístico **não** é uma tendência: uma tendência faria a média depender de $t$, e o processo não seria estacionário. É a parte que o passado prevê com erro zero. Nos ARMA estacionários, $\kappa_t=0$: são **puramente não determinísticos**.

**(b) AR(1):** $y_t=\phi y_{t-1}+\varepsilon_t$, com $\lvert\phi\rvert\lt1$.

> [!CAUTION]
> **Erro do caderno (19/08): $y_2$ do AR(1) recursivo sem o $y_0$**
> O caderno escreveu $y_2=\phi^2+\phi\varepsilon_1+\varepsilon_2$. Pela linha (42), com $t=2$ e $n=2$, o certo é $y_2=\phi^2y_0+\phi\varepsilon_1+\varepsilon_2$. A fórmula final do caderno, $y_t=\phi^ty_0+\sum\phi^{t-i}\varepsilon_i$, está certa.

$$
\begin{aligned}
\text{(41)}\quad & y_t=\phi(\phi y_{t-2}+\varepsilon_{t-1})+\varepsilon_t=\phi^2y_{t-2}+\phi\varepsilon_{t-1}+\varepsilon_t && [\text{modelo em } t-1]\\
\text{(42)}\quad & y_t=\phi^ny_{t-n}+\textstyle\sum_{j=0}^{n-1}\phi^j\varepsilon_{t-j} && [n \text{ substituições}]\\
\text{(43)}\quad & E\Big(\big(y_t-\textstyle\sum_{j=0}^{n-1}\phi^j\varepsilon_{t-j}\big)^2\Big)=\phi^{2n}\gamma_0\ \to\ 0 && [(42),\ \text{estac.},\ \lvert\phi\rvert\lt1]\\
\text{(44)}\quad & y_t=\textstyle\sum_{j\ge0}\phi^j\varepsilon_{t-j}\ \Rightarrow\ \psi_j=\phi^j,\ \psi_0=1 && [\text{limite em média quadrática}]\\
\text{(45)}\quad & \textstyle\sum_{j\ge0}\psi_j^2=\sum_{j\ge0}\phi^{2j}=\frac{1}{1-\phi^2}\lt\infty && [\text{F2, razão } \phi^2]\\
\text{(46)}\quad & \widehat E(y_t\mid y_{t-1},\dots)=\phi y_{t-1}\ \Rightarrow\ \text{inovação}=\varepsilon_t,\ \ \kappa_t=0 && [\text{caus.}]
\end{aligned}
$$

$$
\boxed{\text{AR(1)}=\text{Wold com } \psi_j=\phi^j,\ \textstyle\sum\psi_j^2=\frac{1}{1-\phi^2}\lt\infty,\ \kappa_t=0}
$$

**(c) Invertibilidade e o AR($\infty$)**, no MA(1) dos slides, $y_t=\varepsilon_t+\theta_1\varepsilon_{t-1}$ (AU02, p. 30–34):

> [!CAUTION]
> **Erro do caderno (03/09): $+\theta_1^2\varepsilon_{t-2}$ no lugar de $-\theta_1^2\varepsilon_{t-2}$**
> Ao substituir $\varepsilon_{t-1}=y_{t-1}-\theta_1\varepsilon_{t-2}$, o sinal troca. Os pesos de (48) alternam: $+,-,+,\dots$

$$
\begin{aligned}
\text{(47)}\quad & \varepsilon_t=y_t-\theta_1\varepsilon_{t-1} && [\text{isola o choque}]\\
\text{(48)}\quad & \varepsilon_t=\textstyle\sum_{j=0}^{n-1}(-\theta_1)^jy_{t-j}+(-\theta_1)^n\varepsilon_{t-n} && [n \text{ vezes}]\\
\text{(49)}\quad & E\big(((-\theta_1)^n\varepsilon_{t-n})^2\big)=\theta_1^{2n}\sigma^2\to0\iff\lvert\theta_1\rvert\lt1 && [\text{RB}]\\
\text{(50)}\quad & y_t=\textstyle\sum_{j\ge1}\pi_jy_{t-j}+\varepsilon_t,\qquad \pi_j=-(-\theta_1)^j && [(48),\ \text{AU02 p. 23}]\\
\text{(51)}\quad & \textstyle\sum\lvert\pi_j\rvert\lt\infty\iff\lvert\theta_1\rvert\lt1;\ \text{senão o AR}(\infty) \text{ não converge} && [\text{F2; AU02 p. 32}]\\
\text{(52)}\quad & \theta_1 \text{ e } 1/\theta_1\text{: mesma FAC; só o invertível dá a inovação (37)} && [\text{AU02 p. 34}]
\end{aligned}
$$

$$
\boxed{\text{AR}(\infty) \text{ convergente}\iff\text{raízes de } \theta(z) \text{ fora do círculo}\iff\varepsilon_t \text{ é função do passado de } y}
$$

Em (52), com $\lvert\theta_1\rvert\gt1$, o choque $\varepsilon_t$ do modelo só pode ser escrito com valores **futuros** de $y$. Ele não é a "notícia" de Wold, que é sempre função do passado. Por isso a invertibilidade é a condição para o choque do modelo coincidir com a inovação.

---

## Versão para a prova

**Q1:**
1. Some de 1 a $t$ (telescópica): $y_t=10+ct+\sum u_s$.
2. $E=10+ct$ [F4, RB]; $\operatorname{Var}=t\sigma^2$; $\operatorname{Cov}=(t-k)\sigma^2$ [RB: pares comuns].
3. A variância depende de $t$, logo o processo não é estacionário.

**Q2:** linhas (13)–(18), ou a folha completa.

**Q3:**
1. $\gamma_3(k)=\gamma_1(k)+4\gamma_2(k)$, porque os cruzados zeram e a constante sai **ao quadrado**.
2. Os valores: 9,7; $-5{,}52$; 1,2; 0.
3. Estacionário, e MA(2), porque a FAC corta em 2.

**Q4:**
1. Enuncie (35)–(40) e diga que $\kappa_t$ é o previsível sem erro, não uma tendência.
2. AR(1): substituição recursiva, resto $\phi^{2n}\gamma_0\to0$, $\psi_j=\phi^j$.
3. MA(1): $\pi_j=-(-\theta_1)^j$, somável se e só se $\lvert\theta_1\rvert\lt1$.

## Conferência

**Q1**, com $c=0{,}5$, $\sigma^2=1$, $t=20$ e $k=5$: $E=20$, $\operatorname{Var}=20$, $\operatorname{Cov}=15$, $\operatorname{Corr}=0{,}866$. Em 40 mil trajetórias simuladas: 20,01; 19,98; 14,99.

**Q3:**
- $\gamma_3=(9{,}7;\ -5{,}52;\ 1{,}2;\ 0)$, $\rho_1=-0{,}5691$ e $\rho_2=0{,}1237$;
- simulando $z_1$ e $z_2$ com os parâmetros de (32)–(33), com 200 mil observações, as autocovariâncias de $z_3$ saem 9,73; $-5{,}56$; 1,23; $-0{,}01$;
- as autocovariâncias de $z_1$ e $z_2$ reconstruídas pelo R conferem com o enunciado: 0,5 e 0,2; 2,30, $-1{,}43$ e 0,30.

**Q4**, com $\phi=0{,}5$:
- $\psi_4=0{,}0625$ e $\sum\psi_j^2=1{,}3333$;
- na reconstrução do MA(1), o peso de $y_{t-4}$ é 0,0625 com $\theta_1=0{,}5$ e 16 com $\theta_1=2$.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_c1_rw_media | 20 |
| ap_c1_rw_var | 20 |
| ap_c1_rw_cov | 15 |
| ap_c1_rw_corr | 0,866 |
| ap_c1_rw_media_sim | 20,01 |
| ap_c1_rw_var_sim | 19,98 |
| ap_c1_rw_cov_sim | 14,99 |
| ap_am1_rw_corr_100_90 | 0,95 |
| ap_c1_z3_g0 | 9,7 |
| ap_c1_z3_g1 | -5,52 |
| ap_c1_z3_g2 | 1,2 |
| ap_c1_z3_g3 | 0 |
| ap_c1_z3_rho1 | -0,5691 |
| ap_c1_z3_rho2 | 0,1237 |
| ap_am1_z1_g0 | 0,5 |
| ap_am1_z1_g1 | 0,2 |
| ap_am1_z2_g0 | 2,30 |
| ap_am1_z2_g1 | -1,43 |
| ap_am1_z2_g2 | 0,30 |
| ap_am1_z2_delta | 0,01 |
| ap_am1_z2_zmin | 1,667 |
| ap_am1_z3_g0_sim | 9,73 |
| ap_am1_z3_g1_sim | -5,56 |
| ap_am1_z3_g2_sim | 1,23 |
| ap_am1_z3_g3_sim | -0,01 |
| ap_c1_wold_psi4 | 0,0625 |
| ap_c1_wold_soma2 | 1,3333 |
| ap_c2_ma_pi4_05 | 0,0625 |
| ap_c2_ma_pi4_2 | 16 |
-->
