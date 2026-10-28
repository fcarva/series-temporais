---
title: "Cap. 2 à mão — Q5 a Q8 linha a linha"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: [5, 6, 7, 8]
aulas: "AU02 p. 11–41, 68–69, 81–84; AU01 p. 30"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Cap. 2 à mão — Q5 a Q8
---

# Cap. 2 à mão: Q5 a Q8, linha a linha

[← capítulo 2](cap2_ar_ma_arma.md) · [← apostila](README.md)

Esta é a versão de **caderno** do bloco 2 da lista, no mesmo formato da [folha da Q2 e da Q6](../lista_comentada/a_mao_q02_q06.md): cada passagem numerada, uma operação por linha e o motivo entre colchetes. Os símbolos são os dos slides: $L$, $\varepsilon_t$, $\phi_1$, e $\theta_1$ com sinal positivo. A tradução para a lista vem em cada questão. A numeração das linhas é contínua do início ao fim, para que "[(19)]" aponte sempre para a mesma linha.

**Legenda:**
- [RB]: ruído branco, $E(\varepsilon_t)=0$, $E(\varepsilon_t^2)=\sigma^2$ e $E(\varepsilon_t\varepsilon_s)=0$ se $t\ne s$;
- [F1]: Bhaskara;
- [F2]: série geométrica;
- [F3]: soma de Gauss;
- [F4]: linearidade da esperança;
- [F7]: igualar coeficientes;
- [F8]: multiplicar polinômios;
- [estac.]: os momentos não dependem da data;
- [caus.]: o choque de hoje não se correlaciona com o passado de $y$;
- [(n)]: usando a linha (n).

As ferramentas estão demonstradas na [caixa de ferramentas](../lista_comentada/README.md#2-caixa-de-ferramentas).

---

# Q5 · Três modelos: operador, classificação, raízes e pesos

**Enunciado (lista, Q5).** Três modelos em $\tilde z_t$ e $a_t$:
- (1) um AR(1) com coeficiente 0,5;
- (2) um MA(2) com $-1{,}3$ e $+0{,}4$;
- (3) os dois juntos.

Pede-se:
- escrever cada um com o operador de retardo e classificá-lo como ARMA($p,q$);
- verificar estacionariedade e invertibilidade;
- obter $\psi_1,\dots,\psi_4$ e $\pi_1,\dots,\pi_4$.

**Nos slides:** $a_t=\varepsilon_t$ e $B=L$. Os pesos $\psi_j$ e $\pi_j$ **não dependem** da convenção do MA, porque $\tilde z_t=\sum\psi_j\varepsilon_{t-j}$ e $\tilde z_t=\sum\pi_j\tilde z_{t-j}+\varepsilon_t$ são as mesmas equações nas duas notações (AU02, p. 16 e 19).

## Modelo (1): $\tilde z_t-0{,}5\tilde z_{t-1}=\varepsilon_t$

$$
\begin{aligned}
\text{(1)}\quad & \tilde z_t-0{,}5\,\tilde z_{t-1}=\varepsilon_t && [\text{lista}]\\
\text{(2)}\quad & (1-0{,}5L)\,\tilde z_t=\varepsilon_t && [\text{operador de defasagem: } L\tilde z_t=\tilde z_{t-1}]\\
\text{(3)}\quad & \phi(L)=1-0{,}5L \text{ (grau 1)},\ \ \theta(L)=1 \text{ (grau 0)}\ \Rightarrow\ \text{ARMA}(1,0) && [\text{classifica}]\\
\text{(4)}\quad & 1-0{,}5z=0\ \Rightarrow\ z=2 && [\text{raiz do AR}]\\
\text{(5)}\quad & \lvert z\rvert=2\gt1\ \Rightarrow\ \text{estacionário} && [\text{AU02 p. 27}]\\
\text{(6)}\quad & \text{não há polinômio MA}\ \Rightarrow\ \text{invertível} && [\text{AU02 p. 36}]\\
\text{(7)}\quad & \Psi(L)=(1-0{,}5L)^{-1}=\textstyle\sum_{j\ge0}0{,}5^jL^j && [\text{F2},\ \lvert0{,}5\rvert\lt1]\\
\text{(8)}\quad & \psi_1=0{,}5;\ \psi_2=0{,}25;\ \psi_3=0{,}125;\ \psi_4=0{,}0625 && [\psi_j=0{,}5^j]\\
\text{(9)}\quad & \pi(L)=1-0{,}5L\ \Rightarrow\ \pi_1=0{,}5,\ \ \pi_2=\pi_3=\pi_4=0 && [\text{já está na forma AR}]
\end{aligned}
$$

$$
\boxed{\text{AR(1)}:\ \text{estacionário (}z=2\text{) e invertível};\quad \psi_j=0{,}5^j;\quad \pi_1=0{,}5,\ \pi_{j\ge2}=0}
$$

## Modelo (2): $\tilde z_t=\varepsilon_t-1{,}3\varepsilon_{t-1}+0{,}4\varepsilon_{t-2}$

$$
\begin{aligned}
\text{(10)}\quad & \tilde z_t=\varepsilon_t-1{,}3\,\varepsilon_{t-1}+0{,}4\,\varepsilon_{t-2} && [\text{lista}]\\
\text{(11)}\quad & \tilde z_t=(1-1{,}3L+0{,}4L^2)\,\varepsilon_t,\quad \theta_1=-1{,}3,\ \theta_2=0{,}4 && [\text{slides: } \theta(L)=1+\theta_1L+\theta_2L^2]\\
\text{(12)}\quad & \phi(L)=1,\ \ \theta(L) \text{ de grau 2}\ \Rightarrow\ \text{ARMA}(0,2) && [\text{classifica}]\\
\text{(13)}\quad & \textstyle\sum\lvert\psi_j\rvert=1+1{,}3+0{,}4=2{,}7\lt\infty\ \Rightarrow\ \text{estacionário} && [\text{AU02 p. 29: MA finito}]\\
\text{(14)}\quad & \theta(z)=0\iff0{,}4z^2-1{,}3z+1=0:\ \ a=0{,}4,\ b=-1{,}3,\ c=1 && [\text{F1, forma padrão}]\\
\text{(15)}\quad & \Delta=b^2-4ac=(-1{,}3)^2-4(0{,}4)(1)=1{,}69-1{,}60=0{,}09 && [\text{F1}]\\
\text{(16)}\quad & z=\frac{-b\pm\sqrt\Delta}{2a}=\frac{1{,}3\pm0{,}3}{0{,}8}\ \Rightarrow\ z_1=2,\ z_2=1{,}25 && [\text{F1},\ \sqrt{0{,}09}=0{,}3]\\
\text{(17)}\quad & z_1+z_2=3{,}25=-b/a;\qquad z_1z_2=2{,}5=c/a && [\text{Vieta: confere}]\\
\text{(18)}\quad & \lvert2\rvert\gt1 \text{ e } \lvert1{,}25\rvert\gt1\ \Rightarrow\ \text{invertível} && [\text{AU02 p. 33}]\\
\text{(19)}\quad & 1-1{,}3L+0{,}4L^2=(1-0{,}5L)(1-0{,}8L) && [\text{F8: } 1-0{,}8L-0{,}5L+0{,}4L^2]\\
\text{(20)}\quad & \psi_1=-1{,}3;\ \psi_2=0{,}4;\ \psi_3=\psi_4=0 && [\text{o MA já é a forma MA}(\infty)]
\end{aligned}
$$

**Pesos $\pi$, igualando coeficientes.** Escreva $\theta(L)^{-1}=1+c_1L+c_2L^2+\cdots$ e exija $\theta(L)^{-1}\theta(L)=1$, potência por potência:

$$
\begin{aligned}
\text{(21)}\quad & (1+c_1L+c_2L^2+c_3L^3+\cdots)(1-1{,}3L+0{,}4L^2)=1 && [\text{F7}]\\
\text{(22)}\quad & L^1:\ c_1-1{,}3=0\ \Rightarrow\ c_1=1{,}3 && [\text{coeficiente de } L]\\
\text{(23)}\quad & L^2:\ c_2-1{,}3c_1+0{,}4=0\ \Rightarrow\ c_2=1{,}69-0{,}4=1{,}29 && [(22)]\\
\text{(24)}\quad & L^3:\ c_3-1{,}3c_2+0{,}4c_1=0\ \Rightarrow\ c_3=1{,}677-0{,}52=1{,}157 && [(22),(23)]\\
\text{(25)}\quad & L^4:\ c_4-1{,}3c_3+0{,}4c_2=0\ \Rightarrow\ c_4=1{,}5041-0{,}516=0{,}9881 && [(23),(24)]\\
\text{(26)}\quad & \pi(L)=\theta(L)^{-1}=1-\pi_1L-\pi_2L^2-\cdots\ \Rightarrow\ \pi_j=-c_j && [\text{AU02 p. 19–20}]\\
\text{(27)}\quad & \pi_1=-1{,}3;\ \pi_2=-1{,}29;\ \pi_3=-1{,}157;\ \pi_4=-0{,}9881 && [(22)\text{–}(26)]
\end{aligned}
$$

$$
\boxed{\text{MA(2)}:\ \text{estacionário; invertível (}z=2;\ 1{,}25\text{)};\quad \pi_j \text{ decaem devagar, à taxa } 1/1{,}25=0{,}8}
$$

## Modelo (3): $\tilde z_t-0{,}5\tilde z_{t-1}=\varepsilon_t-1{,}3\varepsilon_{t-1}+0{,}4\varepsilon_{t-2}$

$$
\begin{aligned}
\text{(28)}\quad & (1-0{,}5L)\,\tilde z_t=(1-1{,}3L+0{,}4L^2)\,\varepsilon_t && [\text{lista em } L]\\
\text{(29)}\quad & (1-0{,}5L)\,\tilde z_t=(1-0{,}5L)(1-0{,}8L)\,\varepsilon_t && [(19)]\\
\text{(30)}\quad & \tilde z_t=(1-0{,}8L)\,\varepsilon_t && [\times(1-0{,}5L)^{-1},\ \text{F2}]\\
\text{(31)}\quad & \text{parece ARMA(1,2), mas é MA(1)}=\text{ARMA}(0,1) && [\text{fator comum}]\\
\text{(32)}\quad & \text{estacionário: MA finito} && [\text{AU02 p. 29}]\\
\text{(33)}\quad & 1-0{,}8z=0\ \Rightarrow\ z=1{,}25\gt1\ \Rightarrow\ \text{invertível} && [\text{AU02 p. 33}]\\
\text{(34)}\quad & \psi_1=-0{,}8;\ \ \psi_j=0,\ j\ge2 && [(30)]
\end{aligned}
$$

**Conferência dos $\psi$ pelo modelo inteiro**, sem cancelar nada: exija $\Psi(L)(1-0{,}5L)=1-1{,}3L+0{,}4L^2$ potência por potência.

$$
\begin{aligned}
\text{(35)}\quad & L^1:\ \psi_1-0{,}5=-1{,}3\ \Rightarrow\ \psi_1=-0{,}8 && [\text{F7}]\\
\text{(36)}\quad & L^2:\ \psi_2-0{,}5\psi_1=0{,}4\ \Rightarrow\ \psi_2=0{,}4-0{,}4=0 && [\text{F7, } (35)]\\
\text{(37)}\quad & \pi_j=-(-\theta_1)^j \text{ com } \theta_1=-0{,}8\ \Rightarrow\ \pi_j=-0{,}8^{\,j} && [\text{AU02 p. 23}]\\
\text{(38)}\quad & \pi_1=-0{,}8;\ \pi_2=-0{,}64;\ \pi_3=-0{,}512;\ \pi_4=-0{,}4096 && [(37)]
\end{aligned}
$$

$$
\boxed{\text{fator comum } (1-0{,}5L):\ \text{o modelo (3) é o MA(1) } \tilde z_t=\varepsilon_t-0{,}8\varepsilon_{t-1}\ \text{(lista: } \theta=0{,}8\text{)}}
$$

**Como enxergar o fator comum sem fatorar:** a raiz do AR, $z=2$, aparece também entre as raízes do MA, $\{2;\ 1{,}25\}$.

---

# Q6 · ARMA(1,1): o roteiro, com a demonstração completa ao lado

A Q6 está demonstrada por inteiro, em 43 linhas, na [folha da Q2 e da Q6](../lista_comentada/a_mao_q02_q06.md#q6--arma11), com os nove termos de $\gamma_0$ na ordem do slide. Aqui fica o esqueleto, para conferir que nenhum passo foi esquecido. O modelo é $y_t-\mu=\phi_1(y_{t-1}-\mu)+\varepsilon_t+\theta_1\varepsilon_{t-1}$, com $\theta_1=-\theta^{\text{lista}}$.

$$
\begin{aligned}
\text{(39)}\quad & E\big((y_t-\mu)\varepsilon_t\big)=\sigma^2,\quad E\big((y_{t+1}-\mu)\varepsilon_t\big)=(\phi_1+\theta_1)\sigma^2 && [\text{momentos auxiliares}]\\
\text{(40)}\quad & \gamma_0=\phi_1^2\gamma_0+2\theta_1\phi_1\sigma^2+\sigma^2+\theta_1^2\sigma^2 && [\text{nove termos, quatro zeros}]\\
\text{(41)}\quad & \gamma_0=\frac{\sigma^2(2\theta_1\phi_1+1+\theta_1^2)}{1-\phi_1^2} && [\text{isola, AU02 p. 83}]\\
\text{(42)}\quad & \gamma_1=\phi_1\gamma_0+\theta_1\sigma^2=\frac{(1+\phi_1\theta_1)(\phi_1+\theta_1)}{1-\phi_1^2}\,\sigma^2 && [\times(y_{t-1}-\mu),\ \text{AU02 p. 84}]\\
\text{(43)}\quad & \gamma_k=\phi_1\gamma_{k-1}=\phi_1^{\,k-1}\gamma_1,\quad k\ge2 && [\text{caus.; indução}]\\
\text{(44)}\quad & \rho_k=\phi_1^{\,k-1}\rho_1,\quad k\ge1 && [\div\gamma_0]\\
\text{(45)}\quad & \psi_j=(\phi_1+\theta_1)\,\phi_1^{\,j-1};\qquad \pi_j=(\phi_1+\theta_1)(-\theta_1)^{j-1} && [\text{F7, F2}]\\
\text{(46)}\quad & \text{lista: } \psi_j=(\phi-\theta)\phi^{j-1};\qquad \pi_j=(\phi-\theta)\theta^{j-1} && [\theta_1=-\theta]
\end{aligned}
$$

---

# Q7 · AR(2): Yule-Walker, $\rho_1$, $\rho_2$ e $\gamma_0$

**Enunciado (lista, Q7).** Para $y_t=\phi_1y_{t-1}+\phi_2y_{t-2}+\varepsilon_t$:
- escrever as equações de Yule-Walker e obter $\rho_1$ e $\rho_2$ em função de $\phi_1$ e $\phi_2$;
- obter a variância $\gamma_0$.

**Nos slides:** a mesma notação (AU02, p. 66–69), com média zero.

> [!CAUTION]
> **Erro do caderno (03/09): o sinal de $\phi_2$ ao montar o polinômio**
> No exemplo $\phi_1=1{,}5$ e $\phi_2=-0{,}6$, o polinômio virou $1-1{,}5B-0{,}6B^2$. O certo é $1-\phi_1B-\phi_2B^2=1-1{,}5B+0{,}6B^2$, porque $-\phi_2B^2=-(-0{,}6)B^2$. Daí o $\Delta$ do caderno saiu errado e os módulos 0,6 e 0,52 também; o certo é $\sqrt{0{,}6}=0{,}7746$.

$$
\begin{aligned}
\text{(47)}\quad & y_t=\phi_1y_{t-1}+\phi_2y_{t-2}+\varepsilon_t,\quad E(y_t)=0 && [\text{modelo}]\\
\text{(48)}\quad & E(\varepsilon_t\,y_{t-k})=0,\quad k\ge1 && [\text{caus.}]\\
\text{(49)}\quad & E(\varepsilon_t\,y_t)=0+0+E(\varepsilon_t^2)=\sigma^2 && [\text{F4; (48) zera dois termos}]\\
\text{(50)}\quad & \times y_{t-1}:\ \ \gamma_1=\phi_1\gamma_0+\phi_2\gamma_1 && [E(y_{t-2}y_{t-1})=\gamma_1,\ (48)]\\
\text{(51)}\quad & \times y_{t-2}:\ \ \gamma_2=\phi_1\gamma_1+\phi_2\gamma_0 && [(48)]\\
\text{(52)}\quad & \rho_1=\phi_1+\phi_2\rho_1;\qquad \rho_2=\phi_1\rho_1+\phi_2 && [\div\gamma_0:\ \text{Yule-Walker, AU02 p. 68–69}]\\
\text{(53)}\quad & \rho_1(1-\phi_2)=\phi_1\ \Rightarrow\ \rho_1=\frac{\phi_1}{1-\phi_2} && [(52)]\\
\text{(54)}\quad & \rho_2=\frac{\phi_1^2}{1-\phi_2}+\phi_2=\frac{\phi_1^2+\phi_2-\phi_2^2}{1-\phi_2} && [(53)\text{; denominador comum}]\\
\text{(55)}\quad & \times y_t:\ \ \gamma_0=\phi_1\gamma_1+\phi_2\gamma_2+\sigma^2 && [(49)]\\
\text{(56)}\quad & \gamma_0=\frac{\sigma^2}{1-\phi_1\rho_1-\phi_2\rho_2} && [(55)\div\gamma_0\text{, isola}]\\
\text{(57)}\quad & 1-\phi_1\rho_1-\phi_2\rho_2=\frac{(1-\phi_2)-\phi_1^2-\phi_2(\phi_1^2+\phi_2-\phi_2^2)}{1-\phi_2} && [(53),(54)]\\
\text{(58)}\quad & \text{numerador}=(1-\phi_2)(1-\phi_2^2)-\phi_1^2(1+\phi_2) && [\text{agrupa}]\\
\text{(59)}\quad & \phantom{\text{numerador}}=(1+\phi_2)\big[(1-\phi_2)^2-\phi_1^2\big] && [1-\phi_2^2=(1-\phi_2)(1+\phi_2)]\\
\text{(60)}\quad & \gamma_0=\frac{(1-\phi_2)\,\sigma^2}{(1+\phi_2)\big[(1-\phi_2)^2-\phi_1^2\big]} && [(56)\text{–}(59)]\\
\text{(61)}\quad & (1-\phi_2)^2-\phi_1^2=(1-\phi_2-\phi_1)(1-\phi_2+\phi_1) && [\text{diferença de quadrados}]\\
\text{(62)}\quad & \gamma_0\gt0\iff 1+\phi_2\gt0,\ \ \phi_1+\phi_2\lt1,\ \ \phi_2-\phi_1\lt1 && [\text{o triângulo, AU02 p. 41}]
\end{aligned}
$$

$$
\boxed{\rho_1=\frac{\phi_1}{1-\phi_2},\qquad \rho_2=\frac{\phi_1^2+\phi_2-\phi_2^2}{1-\phi_2},\qquad \gamma_0=\frac{(1-\phi_2)\,\sigma^2}{(1+\phi_2)\big[(1-\phi_2)^2-\phi_1^2\big]}}
$$

Em (56), divide-se (55) por $\gamma_0$: $1=\phi_1\rho_1+\phi_2\rho_2+\sigma^2/\gamma_0$. Em (58), $(1-\phi_2)-\phi_2^2(1-\phi_2)=(1-\phi_2)(1-\phi_2^2)$. Em (62), os três fatores de (60)–(61) são exatamente as três desigualdades do triângulo de estacionariedade. A variância só existe, e é positiva, dentro dele.

**Com o exemplo do caderno**, $\phi_1=1{,}5$ e $\phi_2=-0{,}6$:
- $\rho_1=1{,}5/1{,}6=0{,}9375$ e $\rho_2=0{,}80625$;
- os fatores são $1+\phi_2=0{,}4$, $1-\phi_2-\phi_1=0{,}1$ e $1-\phi_2+\phi_1=3{,}1$, todos positivos;
- $\gamma_0=12{,}9032\,\sigma^2$. A variância é grande porque o fator $0{,}1$ está perto de zero: o processo está perto da borda do triângulo.

---

# Q8 · Verdadeiro ou falso, com demonstração

**Enunciado (lista, Q8).** São dois modelos, e cinco afirmativas para julgar com demonstração:
- **(I)** $Y_t=\alpha Y_{t-1}+u_t+\beta u_{t-1}$, com $0\lt\alpha\lt1$;
- **(II)** $Z_t=c+Z_{t-1}+\theta t+\varepsilon_t$.

**Nos slides:** a Q8 **já usa o sinal positivo**. O (I) é o ARMA(1,1) da AU02, p. 81, com $\phi_1=\alpha$ e $\theta_1=\beta$. O (II) é o passeio com drift e tendência da AU01, p. 30, com $\alpha_1=c$ e $\alpha_2=\theta$. Mantenho as letras da lista, e $\gamma_h=E(Y_tY_{t+h})$.

**Momentos auxiliares do (I):**

$$
\begin{aligned}
\text{(63)}\quad & E(Y_{t-1}u_t)=0 && [\text{caus.}]\\
\text{(64)}\quad & E(Y_tu_t)=\alpha E(Y_{t-1}u_t)+E(u_t^2)+\beta E(u_{t-1}u_t)=\sigma^2 && [\text{F4, (63), RB}]\\
\text{(65)}\quad & E(Y_tu_{t-1})=\alpha E(Y_{t-1}u_{t-1})+E(u_tu_{t-1})+\beta E(u_{t-1}^2)=(\alpha+\beta)\sigma^2 && [(64)\text{ em } t-1,\ \text{RB}]
\end{aligned}
$$

**Afirmativa 1:** $\gamma_0=\alpha\gamma_1+\sigma^2+\beta(\alpha+\beta)\sigma^2$.

$$
\begin{aligned}
\text{(66)}\quad & \gamma_0=E(Y_tY_t)=\alpha E(Y_{t-1}Y_t)+E(u_tY_t)+\beta E(u_{t-1}Y_t) && [\text{modelo}\times Y_t]\\
\text{(67)}\quad & \phantom{\gamma_0}=\alpha\gamma_1+\sigma^2+\beta(\alpha+\beta)\sigma^2\ \Rightarrow\ \textbf{VERDADEIRA} && [(64),(65)]
\end{aligned}
$$

**Afirmativa 2:** $\gamma_1=\alpha(\gamma_0+\sigma^2)+\beta\sigma^2$.

$$
\begin{aligned}
\text{(68)}\quad & \gamma_1=E(Y_{t+1}Y_t)=\alpha E(Y_tY_t)+E(u_{t+1}Y_t)+\beta E(u_tY_t) && [\text{modelo em } t+1,\ \times Y_t]\\
\text{(69)}\quad & \phantom{\gamma_1}=\alpha\gamma_0+0+\beta\sigma^2 && [\text{caus.: } u_{t+1} \text{ é futuro; (64)}]\\
\text{(70)}\quad & \text{afirmativa}-\text{certo}=\alpha\sigma^2\ne0\ \Rightarrow\ \textbf{FALSA} && [\alpha\gt0]
\end{aligned}
$$

**Afirmativa 3:** $\rho_h=\frac{(\beta+\alpha)(1+\alpha\beta)}{1+2\alpha\beta+\beta^2}$ para todo $h$.

$$
\begin{aligned}
\text{(71)}\quad & \gamma_0=\frac{1+2\alpha\beta+\beta^2}{1-\alpha^2}\sigma^2,\quad \gamma_1=\frac{(1+\alpha\beta)(\alpha+\beta)}{1-\alpha^2}\sigma^2 && [(67),(69)]\\
\text{(72)}\quad & \rho_1=\frac{(\alpha+\beta)(1+\alpha\beta)}{1+2\alpha\beta+\beta^2} && [(71)]\\
\text{(73)}\quad & \gamma_h=\alpha\gamma_{h-1},\ h\ge2\ \Rightarrow\ \rho_h=\alpha^{h-1}\rho_1 && [\text{caus.; (43)}]\\
\text{(74)}\quad & \text{a expressão só vale em } h=1;\ \text{para } h\ge2 \text{ falta } \alpha^{h-1}\ \Rightarrow\ \textbf{FALSA} && [(72),(73)]
\end{aligned}
$$

Em (71), resolve-se o sistema formado por (67) e (69), como na Q6.

**Afirmativa 4:** $Z_t=ct+\frac{\theta}{2}t^2+Z_0+\sum_{j=1}^{t}\varepsilon_j$.

$$
\begin{aligned}
\text{(75)}\quad & Z_s-Z_{s-1}=c+\theta s+\varepsilon_s && [\text{modelo}]\\
\text{(76)}\quad & Z_t-Z_0=ct+\theta\textstyle\sum_{s=1}^{t}s+\sum_{s=1}^{t}\varepsilon_s && [\text{soma de 1 a } t,\ \text{telescópica}]\\
\text{(77)}\quad & Z_t=Z_0+ct+\theta\,\frac{t(t+1)}{2}+\textstyle\sum_{j=1}^{t}\varepsilon_j && [\text{F3}]\\
\text{(78)}\quad & \theta\,\frac{t(t+1)}{2}=\frac{\theta}{2}t^2+\frac{\theta}{2}t\ne\frac{\theta}{2}t^2\ \Rightarrow\ \textbf{FALSA} && [\text{falta } \theta t/2]
\end{aligned}
$$

**Afirmativa 5:** $V(Z_t)=(c+\theta t)\sigma^2$.

$$
\begin{aligned}
\text{(79)}\quad & V(Z_t)=V\big(\textstyle\sum_{j=1}^{t}\varepsilon_j\big) && [(77):\ Z_0,\ ct,\ \theta t(t+1)/2 \text{ são constantes}]\\
\text{(80)}\quad & \phantom{V(Z_t)}=\textstyle\sum_{j=1}^{t}V(\varepsilon_j)=t\sigma^2\ne(c+\theta t)\sigma^2\ \Rightarrow\ \textbf{FALSA} && [\text{RB: sem covariâncias}]
\end{aligned}
$$

$$
\boxed{\text{Gabarito da Q8: V, F, F, F, F}}
$$

---

## Versão para a prova

**Q5**, para cada modelo, quatro linhas:
1. Escreva em $L$ e diga o grau de $\phi(L)$ e de $\theta(L)$.
2. Calcule as raízes: $\phi(z)$ para a estacionariedade e $\theta(z)$ para a invertibilidade, com Bhaskara e Vieta.
3. Obtenha os $\psi$ por $\Psi(L)\phi(L)=\theta(L)$ e os $\pi$ por $\pi(L)\theta(L)=\phi(L)$, potência por potência.
4. **Procure raiz repetida dos dois lados**: no modelo (3), o fator $(1-0{,}5L)$ cancela, e sobra um MA(1).

**Q6:** as linhas (39)–(46), ou a versão de 10 itens da [folha da Q6](../lista_comentada/a_mao_q02_q06.md).

**Q7:**
1. Multiplique por $y_{t-1}$ e $y_{t-2}$ e divida por $\gamma_0$: $\rho_1=\phi_1/(1-\phi_2)$ e $\rho_2=\phi_1\rho_1+\phi_2$.
2. Multiplique por $y_t$: $\gamma_0=\sigma^2/(1-\phi_1\rho_1-\phi_2\rho_2)$.
3. Simplifique até (60).
4. Feche com o triângulo.

**Q8:**
1. Escreva os dois momentos auxiliares.
2. Em cada item, a conta que leva à expressão certa e a comparação com a afirmativa.
3. Gabarito V, F, F, F, F. **Sem conta, V ou F vale zero.**

## Conferência

Todos os números desta folha vêm do R e são conferidos por dois caminhos.

**Q5:**
- as raízes 2 e 1,25 saem iguais pelo `polyroot`;
- os $\pi_j$ do modelo (2) por (22)–(27) coincidem com os do helper do repositório, com diferença 0;
- os $\psi_j$ do modelo (3) escrito inteiro e os do MA(1) cancelado coincidem até $j=20$, com diferença 0.

**Q7:** $\gamma_0=12{,}9032$ pela fórmula (60), por (56) e pela autocovariância do R.

**Q8**, com $\alpha=0{,}6$, $\beta=0{,}3$ e $\sigma^2=1$:
- $\gamma_0=2{,}265625$, e o lado direito da afirmativa 1 dá o mesmo;
- $\gamma_1=1{,}659375$, contra os $2{,}259375$ da afirmativa 2;
- $\rho_1=0{,}7324$ e $\rho_2=0{,}4394$;
- com $c=1$, $\theta=0{,}5$ e $t=4$: $E(Z_4)=9$, contra 8 da afirmativa 4, e $V(Z_4)=4$, contra 3 da afirmativa 5.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_am2_q5m1_z | 2 |
| ap_am2_q5m1_psi1 | 0,5 |
| ap_am2_q5m1_psi2 | 0,25 |
| ap_am2_q5m1_psi3 | 0,125 |
| ap_am2_q5m1_psi4 | 0,0625 |
| ap_am2_q5m2_delta | 0,09 |
| ap_am2_q5m2_z1 | 2 |
| ap_am2_q5m2_z2 | 1,25 |
| ap_am2_q5m2_zmin_r | 1,25 |
| ap_am2_q5m2_pi1 | -1,3 |
| ap_am2_q5m2_pi2 | -1,29 |
| ap_am2_q5m2_pi3 | -1,157 |
| ap_am2_q5m2_pi4 | -0,9881 |
| ap_am2_q5m2_dif | 0 |
| ap_am2_q5m3_psi1 | -0,8 |
| ap_am2_q5m3_psi2 | 0 |
| ap_am2_q5m3_dif | 0 |
| ap_am2_q5m3_pi1 | -0,8 |
| ap_am2_q5m3_pi2 | -0,64 |
| ap_am2_q5m3_pi3 | -0,512 |
| ap_am2_q5m3_pi4 | -0,4096 |
| ap_am2_q7_rho1 | 0,9375 |
| ap_am2_q7_rho2 | 0,80625 |
| ap_am2_q7_rho2_formula | 0,80625 |
| ap_am2_q7_g0_rho | 12,9032 |
| ap_am2_q7_g0_formula | 12,9032 |
| ap_am2_q7_g0_r | 12,9032 |
| ap_am2_q7_f1 | 0,4 |
| ap_am2_q7_f2 | 0,1 |
| ap_am2_q7_f3 | 3,1 |
| ap_am2_q8_g0 | 2,265625 |
| ap_am2_q8_g0_r | 2,265625 |
| ap_am2_q8_item1 | 2,265625 |
| ap_am2_q8_g1 | 1,659375 |
| ap_am2_q8_g1_r | 1,659375 |
| ap_am2_q8_item2 | 2,259375 |
| ap_am2_q8_rho1 | 0,7324 |
| ap_am2_q8_rho2 | 0,4394 |
| ap_am2_q8_ez4 | 9 |
| ap_am2_q8_ez4_item | 8 |
| ap_am2_q8_vz4 | 4 |
| ap_am2_q8_vz4_item | 3 |
-->
