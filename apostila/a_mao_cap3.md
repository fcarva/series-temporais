---
title: "Cap. 3 à mão — Q9 a Q12 linha a linha"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: [9, 10, 11, 12]
aulas: "AU01 p. 28–30; AU02 p. 27–33, 72–76, 93; AU03 p. 10–31; MAT p. 1–16; AU05"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Cap. 3 à mão — Q9 a Q12
---

# Cap. 3 à mão: Q9 a Q12, linha a linha

[← capítulo 3](cap3_integrados_sarima.md) · [← apostila](README.md) · [cap. 2 à mão](a_mao_cap2.md)

Versão de **caderno** do bloco 3 da lista: cada passagem numerada, uma operação por linha e o motivo entre colchetes. A numeração é contínua. Os símbolos são os dos slides; o MA, inclusive o sazonal, usa o sinal positivo, com $\theta_1=-\theta^{\text{lista}}$ e $\Theta_1=-\Theta^{\text{lista}}$. O lado AR é igual nas duas notações.

**Legenda:**
- [RB]: ruído branco;
- [F2]: série geométrica;
- [F4]: linearidade da esperança;
- [F5]: covariância de combinações lineares;
- [F7]: igualar coeficientes;
- [F8]: multiplicar polinômios;
- [F9]: esperança condicional na previsão (o que é conhecido fica, choque futuro é zero, $y$ futuro vira previsão);
- [caus.]: o choque de hoje não se correlaciona com o passado;
- [(n)]: usando a linha (n).

---

# Q9 · Sobrediferenciar um AR(1) estacionário

**Enunciado (lista, Q9).** $y_t=\phi y_{t-1}+\varepsilon_t$, com $\lvert\phi\rvert\lt1$, e $w_t=\Delta y_t$. Pede-se:
- (a) mostrar que $w_t=-(1-\phi)y_{t-1}+\varepsilon_t$ e que $(1-\phi B)w_t=(1-B)\varepsilon_t$, identificando os polinômios;
- (b) mostrar que o MA tem raiz unitária e discutir o AR($\infty$);
- (c) discutir por que diferenciar uma série estacionária é prejudicial.

$$
\begin{aligned}
\text{(1)}\quad & w_t=y_t-y_{t-1}=\phi y_{t-1}+\varepsilon_t-y_{t-1} && [\text{modelo}]\\
\text{(2)}\quad & w_t=-(1-\phi)\,y_{t-1}+\varepsilon_t && [\text{agrupa } y_{t-1}]\\
\text{(3)}\quad & y_t=(1-\phi L)^{-1}\varepsilon_t=\textstyle\sum_{j\ge0}\phi^j\varepsilon_{t-j} && [\text{MA}(\infty),\ \text{F2},\ \lvert\phi\rvert\lt1]\\
\text{(4)}\quad & w_t=(1-L)\,y_t=(1-L)(1-\phi L)^{-1}\varepsilon_t && [(3)]\\
\text{(5)}\quad & (1-\phi L)\,w_t=(1-L)\,\varepsilon_t && [\times(1-\phi L)]\\
\text{(6)}\quad & \phi(L)=1-\phi L;\ \ \theta(L)=1-L\ (\theta_1=-1;\ \text{lista: } \theta=1)\ \Rightarrow\ \text{ARMA(1,1)} && [\text{identifica}]\\
\text{(7)}\quad & \theta(z)=1-z=0\ \Rightarrow\ z=1,\ \lvert z\rvert=1 && [\text{raiz sobre o círculo}]\\
\text{(8)}\quad & \text{a raiz não está fora do círculo}\ \Rightarrow\ \text{não invertível} && [\text{AU02 p. 33}]\\
\text{(9)}\quad & \pi(L)=\frac{1-\phi L}{1-L}=(1-\phi L)(1+L+L^2+\cdots) && [\text{F2 com razão 1: formal}]\\
\text{(10)}\quad & \phantom{\pi(L)}=1+(1-\phi)L+(1-\phi)L^2+\cdots\ \Rightarrow\ \pi_j=-(1-\phi),\ j\ge1 && [\text{F7}]\\
\text{(11)}\quad & \textstyle\sum_j\lvert\pi_j\rvert=\sum_j(1-\phi)=\infty\ \Rightarrow\ \text{sem AR}(\infty) \text{ convergente} && [(10)]\\
\text{(12)}\quad & \gamma_w(0)=E\big((y_t-y_{t-1})^2\big)=2\gamma_0-2\gamma_1=2\gamma_0(1-\phi) && [\text{F5},\ \gamma_1=\phi\gamma_0]\\
\text{(13)}\quad & \gamma_w(1)=2\gamma_1-\gamma_0-\gamma_2=-\gamma_0(1-\phi)^2 && [\text{F5},\ \gamma_2=\phi^2\gamma_0]\\
\text{(14)}\quad & \rho_w(1)=-\tfrac{1-\phi}{2}\in\big(-\tfrac12,0\big) && [(13)\div(12)]\\
\text{(15)}\quad & \gamma_w(0)=\frac{2\sigma^2}{1+\phi}\gt\gamma_0=\frac{\sigma^2}{1-\phi^2}\iff2(1-\phi)\gt1\iff\phi\lt\tfrac12 && [(12),\ \gamma_0 \text{ do AR(1)}]
\end{aligned}
$$

$$
\boxed{(1-\phi L)\,w_t=(1-L)\,\varepsilon_t:\ \text{MA com raiz } z=1,\ \text{não invertível, sem AR}(\infty);\quad \rho_w(1)=-\tfrac{1-\phi}{2}}
$$

**(c) Por que é prejudicial.**

$$
\begin{aligned}
\text{(16)}\quad & \text{estimação: } \widehat\theta_1 \text{ encosta em } -1 && [\text{raiz no círculo}]\\
\text{(17)}\quad & \text{com } \varepsilon_0=0,\ \text{o erro do chute pesa } (-\theta_1)^t=1 \text{ para sempre} && [\text{MV condicional}]\\
\text{(18)}\quad & \text{modelo em diferenças: } \operatorname{Var}(e_{T+h}) \text{ cresce com } h && [\text{choque permanente}]\\
\text{(19)}\quad & \text{o verdadeiro é estacionário: } \operatorname{Var}(e_{T+h})\to\gamma_0 \text{, limitada} && [\text{cap. 5, D5.3}]\\
\text{(20)}\quad & \text{com } \phi\lt\tfrac12,\ \text{a variância da série aumenta: acrescenta-se ruído} && [(15)]
\end{aligned}
$$

---

# Q10 · ARIMA, tendência determinística e sobrediferenciação

**Enunciado (lista, Q10).** São cinco itens:
- (a) ARIMA($p,1,q$) na diferença é um ARMA($p,q$);
- (b) expandir o ARIMA(1,1,1);
- (c) raiz unitária × tendência determinística;
- (d) diferenciar uma série com tendência só determinística;
- (e) por que a regressão em $t$ é preferível.

$$
\begin{aligned}
\text{(21)}\quad & \phi(L)\,(1-L)\,y_t=\theta(L)\,\varepsilon_t && [\text{ARIMA}(p,1,q)]\\
\text{(22)}\quad & w_t\equiv(1-L)\,y_t\ \Rightarrow\ \phi(L)\,w_t=\theta(L)\,\varepsilon_t && [\text{substitui}]\\
\text{(23)}\quad & \text{raízes de } \phi(z),\theta(z) \text{ fora do círculo}\Rightarrow w_t\sim\text{ARMA}(p,q) && [\text{AU02 p. 27, 33}]
\end{aligned}
$$

**(b) ARIMA(1,1,1)**, na lista: $(1-\phi B)(1-B)y_t=(1-\theta B)a_t$.

$$
\begin{aligned}
\text{(24)}\quad & (1-\phi B)(1-B)=1-B-\phi B+\phi B^2=1-(1+\phi)B+\phi B^2 && [\text{F8}]\\
\text{(25)}\quad & y_t-(1+\phi)\,y_{t-1}+\phi\,y_{t-2}=a_t-\theta\,a_{t-1} && [\text{aplica a } y_t]\\
\text{(26)}\quad & y_t=(1+\phi)\,y_{t-1}-\phi\,y_{t-2}+a_t-\theta\,a_{t-1} && [\text{isola } y_t]\\
\text{(27)}\quad & \text{soma dos coeficientes AR}=(1+\phi)-\phi=1\ \Rightarrow\ \phi(1)=0:\ \text{raiz unitária} && [\text{confere}]
\end{aligned}
$$

**(c), (d) e (e): TS × DS.**

$$
\begin{aligned}
\text{(28)}\quad & \text{TS: } y_t=\alpha+\beta t+u_t\ (u_t \text{ estac.});\ \ \partial y_{t+h}/\partial u_t=\psi_h\to0 && [\text{transitório}]\\
\text{(29)}\quad & \text{DS: } y_t=y_0+\beta t+\textstyle\sum_{s=1}^{t}u_s;\quad \partial y_{t+h}/\partial u_t=1 && [\text{choque permanente}]\\
\text{(30)}\quad & \operatorname{Var}(y_t):\ \text{TS constante};\ \text{DS cresce com } t && [\text{AU01 p. 28–30}]\\
\text{(31)}\quad & \text{(d): } \Delta y_t=\beta+u_t-u_{t-1}=\beta+(1-L)\,u_t && [(28)\text{ em } t \text{ e } t-1]\\
\text{(32)}\quad & \gamma_0=2\sigma^2,\ \gamma_1=-\sigma^2,\ \rho_1=-\tfrac12;\ \ \theta(z)=1-z\Rightarrow z=1 && [u_t\ \text{RB; não invertível}]\\
\text{(33)}\quad & \text{(e): MQO de } y_t \text{ em } (1,t):\ \widehat u_t=y_t-\widehat\alpha-\widehat\beta t \text{ estima } u_t && [\text{MQO}]\\
\text{(34)}\quad & \widehat u_t \text{ herda o ARMA de } u_t,\ \text{sem o fator } (1-L) && [(31) \text{ evitado}]
\end{aligned}
$$

$$
\boxed{\text{DS} \to \text{diferença};\quad \text{TS} \to \text{regressão em } t;\quad \Delta(\text{TS}) \text{ cria } (1-L) \text{ no MA: sobrediferenciação}}
$$

---

# Q11 · SAR(1)$_4$ e o multiplicativo

**Enunciado (lista, Q11).** $y_t=\Phi_1y_{t-4}+\varepsilon_t$, com $\lvert\Phi_1\rvert\lt1$. Pede-se:
- (a) $\gamma_0$, $\gamma_4$, $\gamma_8$, $\gamma_k$ nos múltiplos de 4 e o que acontece fora deles;
- (b) a FAC e a FACP, comparadas com o AR(1);
- (c) o SARIMA$(1,0,0)(1,0,0)_4$ escrito como AR(5) restrito.

$$
\begin{aligned}
\text{(35)}\quad & \gamma_0=E\big((\Phi_1y_{t-4}+\varepsilon_t)^2\big)=\Phi_1^2\gamma_0+2\Phi_1E(y_{t-4}\varepsilon_t)+\sigma^2 && [\text{F4}]\\
\text{(36)}\quad & \gamma_0=\Phi_1^2\gamma_0+0+\sigma^2\ \Rightarrow\ \gamma_0=\frac{\sigma^2}{1-\Phi_1^2} && [\text{caus.; isola}]\\
\text{(37)}\quad & \gamma_k=E(y_ty_{t-k})=\Phi_1\gamma_{k-4}+E(\varepsilon_ty_{t-k})=\Phi_1\gamma_{k-4},\ \ k\ge1 && [\text{caus.}]\\
\text{(38)}\quad & \gamma_4=\Phi_1\gamma_0,\quad \gamma_8=\Phi_1\gamma_4=\Phi_1^2\gamma_0,\quad \gamma_{4j}=\Phi_1^{\,j}\gamma_0 && [(37),\ \text{indução}]\\
\text{(39)}\quad & k=2:\ \gamma_2=\Phi_1\gamma_{-2}=\Phi_1\gamma_2\ \Rightarrow\ (1-\Phi_1)\gamma_2=0\ \Rightarrow\ \gamma_2=0 && [\gamma_{-k}=\gamma_k]\\
\text{(40)}\quad & k=1 \text{ e } 3:\ \gamma_1=\Phi_1\gamma_3,\ \gamma_3=\Phi_1\gamma_1\ \Rightarrow\ (1-\Phi_1^2)\gamma_1=0 && [(37)]\\
\text{(41)}\quad & \gamma_1=\gamma_3=0,\ \text{e por (37) os zeros se propagam a } 5,6,7,9,\dots && [\lvert\Phi_1\rvert\lt1]\\
\text{(42)}\quad & \text{FAC: } \rho_{4j}=\Phi_1^{\,j};\ \ \rho_k=0 \text{ fora dos múltiplos de 4} && [(38)\text{–}(41)]\\
\text{(43)}\quad & \text{FACP: } \phi_{44}=\Phi_1 \text{ e } \phi_{kk}=0 \text{ para } k\ne4 && [\text{AU02 p. 93}]\\
\text{(44)}\quad & \text{comparação: o AR(1) "esticado" por 4; o AR(1) tem } \rho_k=\phi^k \text{ em todo } k && [\text{cap. 2, D2.4}]
\end{aligned}
$$

**(c) O multiplicativo:** $(1-\phi L)(1-\Phi L^4)\,y_t=\varepsilon_t$.

$$
\begin{aligned}
\text{(45)}\quad & (1-\phi L)(1-\Phi L^4)=1-\phi L-\Phi L^4+\phi\Phi L^5 && [\text{F8: quatro produtos}]\\
\text{(46)}\quad & y_t=\phi\,y_{t-1}+\Phi\,y_{t-4}-\phi\Phi\,y_{t-5}+\varepsilon_t && [\text{isola } y_t]\\
\text{(47)}\quad & \text{AR(5)}:\ \phi_1=\phi,\ \phi_2=\phi_3=0,\ \phi_4=\Phi,\ \phi_5=-\phi\Phi && [\text{compara}]\\
\text{(48)}\quad & \text{restrições: } \phi_2=0,\ \phi_3=0,\ \phi_5=-\phi_1\phi_4;\ \ \text{livres: } 5-3=2 && [\text{parcimônia}]
\end{aligned}
$$

$$
\boxed{\gamma_{4j}=\Phi_1^{\,j}\gamma_0,\ \gamma_k=0 \text{ fora dos múltiplos};\qquad (1-\phi L)(1-\Phi L^4)=\text{AR(5) com } \phi_2=\phi_3=0,\ \phi_5=-\phi_1\phi_4}
$$

---

# Q12 · SARIMA$(1,1,0)(0,1,1)_4$: modelo, perdas, previsão e diagnóstico

**Enunciado (lista, Q12).** Série trimestral com SARIMA$(1,1,0)(0,1,1)_4$. Pede-se:
- (a) o modelo em $B$;
- (b) as observações perdidas;
- (c) as previsões em $h=1,2,4,5$ e a propagação da sazonalidade;
- (d) o diagnóstico de resíduos.

**Nos slides:** $(1-\phi L)(1-L)(1-L^4)\,y_t=(1+\Theta_1L^4)\,\varepsilon_t$, com $\Theta_1=-\Theta^{\text{lista}}$. Na lista: $(1-\phi B)(1-B)(1-B^4)y_t=(1-\Theta B^4)a_t$.

$$
\begin{aligned}
\text{(49)}\quad & (1-\phi L)(1-L)=1-(1+\phi)L+\phi L^2 && [\text{F8}]\\
\text{(50)}\quad & \big(1-(1+\phi)L+\phi L^2\big)(1-L^4)=1-(1+\phi)L+\phi L^2-L^4+(1+\phi)L^5-\phi L^6 && [\text{F8}]\\
\text{(51)}\quad & y_t=(1+\phi)y_{t-1}-\phi y_{t-2}+y_{t-4}-(1+\phi)y_{t-5}+\phi y_{t-6}+\varepsilon_t+\Theta_1\varepsilon_{t-4} && [\text{isola } y_t]\\
\text{(52)}\quad & w_t=(1-L)(1-L^4)\,y_t=y_t-y_{t-1}-y_{t-4}+y_{t-5} && [\text{F8}]\\
\text{(53)}\quad & w_t \text{ precisa de } y_{t-5}:\ \text{o primeiro é } w_6;\ \text{perdem-se } d+sD=1+4=5 && [(52)]
\end{aligned}
$$

**(c) Previsões.** Escreva (51) na data $T+h$ e aplique [F9]. Notação: $\widehat y(h)=\widehat y_{T+h/T}$.

$$
\begin{aligned}
\text{(54)}\quad & \widehat y(1)=(1+\phi)y_T-\phi y_{T-1}+y_{T-3}-(1+\phi)y_{T-4}+\phi y_{T-5}+\Theta_1\varepsilon_{T-3} && [\varepsilon_{T+1}\to0]\\
\text{(55)}\quad & \widehat y(2)=(1+\phi)\widehat y(1)-\phi y_T+y_{T-2}-(1+\phi)y_{T-3}+\phi y_{T-4}+\Theta_1\varepsilon_{T-2} && [\text{F9}]\\
\text{(56)}\quad & \widehat y(3)=(1+\phi)\widehat y(2)-\phi\widehat y(1)+y_{T-1}-(1+\phi)y_{T-2}+\phi y_{T-3}+\Theta_1\varepsilon_{T-1} && [\text{intermediário}]\\
\text{(57)}\quad & \widehat y(4)=(1+\phi)\widehat y(3)-\phi\widehat y(2)+y_T-(1+\phi)y_{T-1}+\phi y_{T-2}+\Theta_1\varepsilon_T && [\text{último choque}]\\
\text{(58)}\quad & \widehat y(5)=(1+\phi)\widehat y(4)-\phi\widehat y(3)+\widehat y(1)-(1+\phi)y_T+\phi y_{T-1} && [\text{o MA some}]\\
\text{(59)}\quad & h\ge5:\ (1-\phi L)(1-L)(1-L^4)\,\widehat y(h)=0 && [\text{só a parte AR generalizada}]\\
\text{(60)}\quad & \text{raízes: } 1 \text{ (dupla)},\ -1,\ \pm i,\ 1/\phi && [z^4=1 \text{ e } 1-\phi z=0]
\end{aligned}
$$

A sazonalidade se propaga pelo termo $y_{T+h-4}$, ou $\widehat y(h-4)$, que copia o mesmo trimestre do ano anterior. O MA sazonal corrige esse desenho com os quatro últimos choques e **some a partir de $h=5$**. Por (60), a função de previsão de longo prazo é tendência linear, mais padrão sazonal fixo de período 4, mais um termo $\phi^h$ que se apaga.

**(d) Diagnóstico de resíduos** (AU03):

$$
\begin{aligned}
\text{(61)}\quad & \text{gráficos: resíduos padronizados, histograma, QQ-plot, FAC} && [\text{AU03 p. 10}]\\
\text{(62)}\quad & LB(K)=T(T+2)\textstyle\sum_{i=1}^{K}\frac{\widehat\rho_i^2}{T-i}\sim\chi^2_{K-p-q-P-Q}=\chi^2_{K-2} && [\text{AU03 p. 15}]\\
\text{(63)}\quad & \text{pico nas defasagens 4 ou 8: parte sazonal mal especificada} && [\text{sazonal}]\\
\text{(64)}\quad & JB=\tfrac{n}{6}\widehat S^2+\tfrac{n}{24}(\widehat K-3)^2\sim\chi^2_2 && [\text{AU03 p. 11–14}]\\
\text{(65)}\quad & \text{ARCH-LM e FAC de } \widehat\varepsilon_t^2 && [\text{AU03 p. 19–22}]\\
\text{(66)}\quad & \text{estabilidade: Chow numa data escolhida antes, CUSUM} && [\text{AU03 p. 25–31}]\\
\text{(67)}\quad & \widehat\Theta_1\approx-1 \Rightarrow \text{sobrediferenciação sazonal: usar dummies com } D=0 && [(7)\text{–}(8) \text{ na escala 4}]
\end{aligned}
$$

---

## Versão para a prova

**Q9:**
1. $w_t=-(1-\phi)y_{t-1}+\varepsilon_t$.
2. Aplique $(1-L)$ aos dois lados de $(1-\phi L)y_t=\varepsilon_t$: $(1-\phi L)w_t=(1-L)\varepsilon_t$.
3. A raiz do MA é $z=1$: não invertível, $\pi_j=-(1-\phi)$ não somáveis, sem AR($\infty$).
4. A assinatura é $\rho_w(1)=-(1-\phi)/2$.
5. Custos: estimação na fronteira, previsão com variância que cresce e, se $\phi\lt\frac12$, mais variância.

**Q10:**
1. $\phi(L)w_t=\theta(L)\varepsilon_t$.
2. $y_t=(1+\phi)y_{t-1}-\phi y_{t-2}+a_t-\theta a_{t-1}$, com a soma dos coeficientes AR igual a 1.
3. TS tem choque transitório, DS permanente.
4. A diferença de uma TS é $\beta+(1-L)u_t$, não invertível. O certo é regredir em $t$.

**Q11:**
1. $\gamma_0=\sigma^2/(1-\Phi_1^2)$ e $\gamma_{4j}=\Phi_1^j\gamma_0$.
2. Prove $\gamma_1=\gamma_2=\gamma_3=0$ pelas linhas (39)–(41).
3. A FACP tem um pico só, em 4.
4. Multiplicativo: AR(5) com $\phi_2=\phi_3=0$ e $\phi_5=-\phi_1\phi_4$.

**Q12:**
1. Expanda em duas etapas, (49)–(51).
2. Perdem-se 5 observações.
3. As previsões vêm de (54)–(58): o MA some em $h=5$, e $y_{T+h-4}$ propaga a sazonalidade.
4. Diagnóstico: as linhas (61)–(67).

## Conferência

**Q9 e Q10:**
- $\rho_w(1)$ é $-0{,}40$, $-0{,}25$ e $-0{,}05$ para $\phi=0{,}2$, $0{,}5$ e $0{,}9$, com $-0{,}25$ conferido pelo `ARMAacf`;
- $\operatorname{Var}(w)$ é 1,6667, 1,3333 e 1,0526, contra os 1,0417, 1,3333 e 5,2632 de $\operatorname{Var}(y)$, o que confirma o limiar $\phi=\frac12$ de (15);
- a diferença de um ruído branco tem $\rho_1=-0{,}5$;
- na Q10(b), com $\phi=0{,}5$ e $\theta=0{,}3$, os coeficientes AR são 1,5 e $-0{,}5$, e somam 1.

**Q11**, com $\Phi_1=0{,}6$:
- $\gamma_0=1{,}5625$, $\gamma_4=0{,}9375$ e $\gamma_8=0{,}5625$;
- pelo R, $\rho_1=0$, $\rho_4=0{,}6$ e $\rho_8=0{,}36$;
- o multiplicativo com $\phi=0{,}5$ dá $\phi_5=-0{,}3$.

**Q12**, com $\phi=0{,}4$ e $\Theta^{\text{lista}}=0{,}6$:
- os coeficientes de $y_{t-1}$ a $y_{t-6}$ são 1,4; $-0{,}4$; 0; 1; $-1{,}4$; 0,4;
- as previsões de (54)–(58), aplicadas a uma série simulada com os resíduos do modelo, coincidem com o `predict` do R em $h=1$ a $5$, com diferença máxima da ordem de $10^{-13}$;
- perdem-se 5 observações.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_c3_w_rho1_02 | -0,40 |
| ap_c3_w_rho1_05 | -0,25 |
| ap_c3_w_rho1_09 | -0,05 |
| ap_c3_w_rho1_05_r | -0,25 |
| ap_c3_varw_02 | 1,6667 |
| ap_c3_varw_05 | 1,3333 |
| ap_c3_varw_09 | 1,0526 |
| ap_c3_vary_02 | 1,0417 |
| ap_c3_vary_05 | 1,3333 |
| ap_c3_vary_09 | 5,2632 |
| ap_c3_rb_rho1 | -0,5 |
| ap_am3_q10_c1 | 1,5 |
| ap_am3_q10_c2 | -0,5 |
| ap_am3_q10_soma | 1 |
| ap_c3_sar_g0 | 1,5625 |
| ap_c3_sar_g4 | 0,9375 |
| ap_c3_sar_g8 | 0,5625 |
| ap_c3_sar_rho1_r | 0 |
| ap_c3_sar_rho4_r | 0,6 |
| ap_c3_sar_rho8_r | 0,36 |
| ap_c3_mult_phi5 | -0,3 |
| ap_am3_q12_c1 | 1,4 |
| ap_am3_q12_c2 | -0,4 |
| ap_am3_q12_c3 | 0 |
| ap_am3_q12_c4 | 1 |
| ap_am3_q12_c5 | -1,4 |
| ap_am3_q12_c6 | 0,4 |
| ap_am3_q12_perda | 5 |
| ap_am3_q12_dif | 0 |
-->
