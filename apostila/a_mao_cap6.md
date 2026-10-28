---
title: "Cap. 6 à mão — Q16 linha a linha"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: [16]
aulas: "AU02 p. 87, 90–99; AU03 p. 4–22; AU05"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Cap. 6 à mão — Q16
---

# Cap. 6 à mão: Q16, linha a linha

[← capítulo 6](cap6_aplicacao.md) · [← apostila](README.md) · [cap. 5 à mão](a_mao_cap5.md)

Versão de **caderno** do bloco 6 da lista: cada passagem numerada, uma operação por linha e o motivo entre colchetes. A notação é a dos slides, com o MA com sinal positivo: $\theta_1=-\theta^{\text{lista}}$ e $\Theta_1=-\Theta^{\text{lista}}$.

**Legenda:**
- [RB]: ruído branco;
- [F8]: multiplicar polinômios;
- [caus.]: o choque de hoje não se correlaciona com o passado;
- [(n)]: usando a linha (n).

---

# Q16 · SARIMA$(1,1,1)(0,1,1)_{12}$ com 240 meses

**Enunciado (lista, Q16).** Para 240 observações mensais e o modelo SARIMA$(1,1,1)(0,1,1)_{12}$, pede-se:
- (a) o modelo completo com o operador de retardo;
- (b) quantos e quais parâmetros estimar;
- (c) a FAC e a FACP esperadas de $(1-B)(1-B^{12})y_t$;
- (d) o critério para compará-lo com o SARIMA$(2,1,1)(0,1,1)_{12}$.

## (a) O modelo

$$
\begin{aligned}
\text{(1)}\quad & (1-\phi L)(1-L)(1-L^{12})\,y_t=(1+\theta_1L)(1+\Theta_1L^{12})\,\varepsilon_t && [\text{SARIMA, AU05}]\\
\text{(2)}\quad & (1+\theta_1L)(1+\Theta_1L^{12})=1+\theta_1L+\Theta_1L^{12}+\theta_1\Theta_1L^{13} && [\text{F8}]\\
\text{(3)}\quad & (1-\phi L)(1-L)=1-(1+\phi)L+\phi L^2 && [\text{F8}]\\
\text{(4)}\quad & (3)\times(1-L^{12})=1-(1+\phi)L+\phi L^2-L^{12}+(1+\phi)L^{13}-\phi L^{14} && [\text{F8}]\\
\text{(5)}\quad & y_t=(1+\phi)y_{t-1}-\phi y_{t-2}+y_{t-12}-(1+\phi)y_{t-13}+\phi y_{t-14}+m_t && [\text{isola } y_t]\\
\text{(6)}\quad & m_t=\varepsilon_t+\theta_1\varepsilon_{t-1}+\Theta_1\varepsilon_{t-12}+\theta_1\Theta_1\varepsilon_{t-13} && [(2)]\\
\text{(7)}\quad & w_t\equiv(1-L)(1-L^{12})y_t=y_t-y_{t-1}-y_{t-12}+y_{t-13} && [\text{F8}]\\
\text{(8)}\quad & w_t=\phi\,w_{t-1}+m_t && [(1),(7)]\\
\text{(9)}\quad & \text{lista: } (1-\phi B)(1-B)(1-B^{12})y_t=(1-\theta B)(1-\Theta B^{12})a_t,\ \text{cruzado } +\theta\Theta B^{13} && [(-\theta)(-\Theta)=+\theta\Theta]
\end{aligned}
$$

$$
\boxed{(1-\phi L)(1-L)(1-L^{12})\,y_t=(1+\theta_1L)(1+\Theta_1L^{12})\,\varepsilon_t}
$$

## (b) Os parâmetros e as observações

$$
\begin{aligned}
\text{(10)}\quad & \text{livres: } \phi,\ \theta_1,\ \Theta_1,\ \sigma^2 && [\text{3 polinômios} + \sigma^2]\\
\text{(11)}\quad & \text{o coeficiente de } \varepsilon_{t-13} \text{ é } \theta_1\Theta_1:\ \text{imposto, não é livre} && [(2)]\\
\text{(12)}\quad & \text{sem constante: com } d=D=1,\ c\ne0 \text{ daria tendência quadrática} && [\text{cap. 3}]\\
\text{(13)}\quad & w_t \text{ precisa de } y_{t-13}:\ \text{perdem-se } d+sD=1+12=13 && [(7)]\\
\text{(14)}\quad & T_{ef}=240-13=227 && [(13)]
\end{aligned}
$$

$$
\boxed{4 \text{ parâmetros } (\phi,\theta_1,\Theta_1,\sigma^2);\qquad 227 \text{ observações efetivas}}
$$

## (c) A FAC e a FACP esperadas de $w_t$

Comece pelo caso $\phi=0$, o modelo das companhias aéreas, em que $w_t=m_t$, com $\psi_0=1$, $\psi_1=\theta_1$, $\psi_{12}=\Theta_1$, $\psi_{13}=\theta_1\Theta_1$ e os demais zero.

$$
\begin{aligned}
\text{(15)}\quad & \gamma_k=\sigma^2\textstyle\sum_j\psi_j\psi_{j+k} && [\text{processo linear, AU02 p. 18}]\\
\text{(16)}\quad & \gamma_0=\sigma^2(1+\theta_1^2+\Theta_1^2+\theta_1^2\Theta_1^2)=\sigma^2(1+\theta_1^2)(1+\Theta_1^2) && [k=0;\ \text{fatora}]\\
\text{(17)}\quad & \gamma_1=\sigma^2(\psi_0\psi_1+\psi_{12}\psi_{13})=\sigma^2\theta_1(1+\Theta_1^2) && [k=1]\\
\text{(18)}\quad & \gamma_{11}=\sigma^2\psi_1\psi_{12}=\sigma^2\theta_1\Theta_1 && [k=11]\\
\text{(19)}\quad & \gamma_{12}=\sigma^2(\psi_0\psi_{12}+\psi_1\psi_{13})=\sigma^2\Theta_1(1+\theta_1^2) && [k=12]\\
\text{(20)}\quad & \gamma_{13}=\sigma^2\psi_0\psi_{13}=\sigma^2\theta_1\Theta_1 && [k=13]\\
\text{(21)}\quad & \gamma_k=0 \text{ para } k\notin\{0,1,11,12,13\} && [\text{nenhum par à distância } k]\\
\text{(22)}\quad & \rho_1=\frac{\theta_1}{1+\theta_1^2},\quad \rho_{12}=\frac{\Theta_1}{1+\Theta_1^2},\quad \rho_{11}=\rho_{13}=\rho_1\rho_{12} && [\div\gamma_0]
\end{aligned}
$$

Agora com o AR ($\phi\ne0$), $w_t=\phi w_{t-1}+m_t$:

$$
\begin{aligned}
\text{(23)}\quad & \gamma_k=\phi\gamma_{k-1}+E(m_tw_{t-k}),\ \ \text{e } E(m_tw_{t-k})=0 \text{ para } k\ge14 && [\text{caus.: } m_t \text{ vai até } t-13]\\
\text{(24)}\quad & k\ge14:\ \gamma_k=\phi\,\gamma_{k-1} && [\text{recursão do AR, AU02 p. 87}]\\
\text{(25)}\quad & \text{defasagens baixas: decaimento à taxa } \phi \text{ a partir de } \rho_1 && [\text{como no ARMA(1,1)}]\\
\text{(26)}\quad & \text{em torno de 12: pico de } \Theta_1 \text{ com satélites em 11 e 13} && [(18)\text{–}(20)]\\
\text{(27)}\quad & \text{FACP: decai nas defasagens baixas e em torno de } 12, 24,\dots && [\text{AU02 p. 95}]
\end{aligned}
$$

$$
\boxed{\text{FAC: decai à taxa } \phi \text{ perto da origem; pico em 12, satélites em 11 e 13; FACP decai}}
$$

## (d) Como comparar com o SARIMA$(2,1,1)(0,1,1)_{12}$

$$
\begin{aligned}
\text{(28)}\quad & \text{o rival contém o modelo: } \phi_2=0\ \Rightarrow\ \text{aninhados} && [\text{1 restrição}]\\
\text{(29)}\quad & LR=2\big(\ln L_{(2,1,1)}-\ln L_{(1,1,1)}\big)\xrightarrow{d}\chi^2(1) && [H_0:\phi_2=0]\\
\text{(30)}\quad & \text{rejeita } H_0 \text{ a 5\% se } LR\gt3{,}84 && [\chi^2_{1;0{,}95}]\\
\text{(31)}\quad & BIC=\frac{-2\ln L+k\ln T_{ef}}{T_{ef}},\ \ \ln227=5{,}42 && [\text{AU02 p. 99}]\\
\text{(32)}\quad & \text{o BIC prefere o rival}\iff LR\gt\ln227=5{,}42 && [\text{cap. 4, (38)}]\\
\text{(33)}\quad & \text{mesmo } T_{ef}=227 \text{ nos dois: } d \text{ e } D \text{ iguais} && [\text{AU02 p. 99}]\\
\text{(34)}\quad & \text{resíduos: } LB(24)\sim\chi^2_\nu,\ \ \nu=24-p-q-P-Q=21 && [\text{AU03 p. 15}]\\
\text{(35)}\quad & \text{rejeita "resíduo branco" se } LB(24)\gt32{,}67 && [\chi^2_{21;0{,}95}]\\
\text{(36)}\quad & \text{completam: JB, ARCH-LM, Chow/CUSUM} && [\text{AU03 p. 11–31}]\\
\text{(37)}\quad & \text{recomendação: BIC (identificação), com o LR como confirmação} && [\text{aninhados, mesmo } T]
\end{aligned}
$$

$$
\boxed{\text{BIC (multa } \ln227=5{,}42\text{) e LR (crítico } 3{,}84\text{), mesmo } T_{ef}=227;\ LB \text{ com } \nu=21}
$$

**O ciclo de Box-Jenkins** em que tudo isso se encaixa (AU03, p. 4–7):

$$
\begin{aligned}
\text{(38)}\quad & \text{identificar: gráfico, diferenças, FAC e FACP de } w_t && [\text{item (c)}]\\
\text{(39)}\quad & \text{estimar: MV exata ou condicional} && [\text{cap. 4}]\\
\text{(40)}\quad & \text{diagnosticar: resíduos, estabilidade, previsão; se falhar, voltar a (38)} && [\text{item (d)}]\\
\text{(41)}\quad & \text{usar: prever com as regras da esperança condicional} && [\text{cap. 5}]
\end{aligned}
$$

---

## Versão para a prova

1. **(a)** Escreva (1) e expanda o MA, (2): o termo cruzado é $\theta_1\Theta_1L^{13}$, que na lista vira $+\theta\Theta B^{13}$.
2. **(b)** São 4 parâmetros, $\phi,\theta,\Theta,\sigma^2$. Perdem-se 13 observações, e sobram 227.
3. **(c)**
   - pico em 12;
   - satélites em 11 e 13, iguais a $\rho_1\rho_{12}$ no airline;
   - decaimento à taxa $\phi$ nas defasagens baixas;
   - FACP decaindo.
4. **(d)** BIC e LR, porque os modelos são aninhados e têm o mesmo $T$, com críticos 3,84 e $\ln227=5{,}42$. O Ljung-Box tem 21 graus de liberdade.

## Conferência

**O lado AR**, com $\phi=0{,}5$: os coeficientes de $y_{t-1}$, $y_{t-2}$, $y_{t-12}$, $y_{t-13}$ e $y_{t-14}$ em (5) são 1,5; $-0{,}5$; 1; $-1{,}5$; 0,5. O produto dos polinômios no R confere, com diferença zero.

**A FAC.** Com $\theta^{\text{lista}}=0{,}4$ e $\Theta^{\text{lista}}=0{,}6$, o termo cruzado vale 0,24.
- No airline, (22) dá $\rho_1=-0{,}3448$, $\rho_{12}=-0{,}4412$ e $\rho_{11}=\rho_{13}=0{,}1521$, iguais ao `ARMAacf`, com $\rho_2=0$.
- Com $\phi=0{,}5$, $\rho_1=0{,}1052$ e $\rho_{12}=-0{,}4411$.

**Os testes:** $\chi^2_{1;0{,}95}=3{,}84$, $\ln227=5{,}42$ e $\chi^2_{21;0{,}95}=32{,}67$.

**A simulação** de 240 meses do modelo verdadeiro:
- o R usou 227 observações;
- $LB(24)=15{,}39$, com $p=0{,}80$;
- $LR=0{,}47$;
- BIC de 651,42 contra 656,38 do rival.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_am6_c1 | 1,5 |
| ap_am6_c2 | -0,5 |
| ap_am6_c12 | 1 |
| ap_am6_c13 | -1,5 |
| ap_am6_c14 | 0,5 |
| ap_am6_dif | 0 |
| ap_am6_ma13 | 0,24 |
| ap_c6_air_rho1 | -0,3448 |
| ap_c6_air_rho12 | -0,4412 |
| ap_c6_air_rho11 | 0,1521 |
| ap_c6_air_rho13_r | 0,1521 |
| ap_c6_air_rho2_r | 0 |
| ap_c6_q16_rho1 | 0,1052 |
| ap_c6_q16_rho12 | -0,4411 |
| ap_c6_npar | 4 |
| ap_c6_efetivas | 227 |
| ap_c6_ln227 | 5,42 |
| ap_c6_lb_gl | 21 |
| ap_c6_lb_crit | 32,67 |
| ap_c6_lr_crit | 3,84 |
| ap_c6_est_nobs | 227 |
| ap_c6_lb_stat | 15,39 |
| ap_c6_lb_p | 0,80 |
| ap_c6_lr | 0,47 |
| ap_c6_bic1 | 651,42 |
| ap_c6_bic2 | 656,38 |
-->
