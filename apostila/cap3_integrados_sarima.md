---
title: "Apostila, cap. 3 — Integrados, ARIMA e SARIMA: a diferença na dose certa"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: [9, 10, 11, 12]
aulas: "AU01 p. 28–30; AU02 p. 30–36; MAT §1; AU05"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Apostila cap. 3 — Integrados e SARIMA
---

# Capítulo 3 · Integrados, ARIMA e SARIMA: a diferença na dose certa

[← apostila](README.md) · anterior: [cap. 2](cap2_ar_ma_arma.md) · próximo: [cap. 4](cap4_estimacao_selecao.md) · questões da lista: Q9 a Q12

## Pergunta de abertura

O PIB cresce há décadas. Para modelá-lo com um ARMA, você precisa de uma série estacionária. Há dois caminhos:
- **tirar a diferença**, $\Delta y_t$;
- **regredir em $t$** e usar o resíduo.

**Os dois dão o mesmo resultado?** E se, na dúvida, você diferenciar uma vez a mais, "por segurança", **o que se perde?**

A resposta depende de uma pergunta que veio do cap. 2: **o choque de hoje some ou fica para sempre?**
- Se fica, a tendência é **estocástica** e o remédio é a diferença.
- Se some, e a série só oscila em torno de uma reta, a tendência é **determinística** e o remédio é a regressão.

Errar o remédio, em qualquer das duas direções, tem custo (MAT, p. 1–16; lista, Q9 e Q10).

## A imagem

**A tendência determinística é um trem num trilho.** O trem balança, sai um pouco do eixo, mas o trilho o traz de volta: os desvios são transitórios. Saber em que ponto do trilho o trem está daqui a dez anos é fácil, e a incerteza não cresce com o horizonte.

**A tendência estocástica é um barco à deriva com vento a favor.** O vento, que é o drift, empurra para frente em média. Cada onda, que é o choque, desloca o barco, e **ninguém o traz de volta**: o desvio fica incorporado à rota. A incerteza sobre a posição daqui a dez anos cresce com o horizonte, exatamente como $\operatorname{Var}(y_t)=t\sigma^2$ do cap. 1.

**A diferença é um remédio, e a dose importa.**
- **Subdose** (não diferenciar uma série com raiz unitária): a doença continua, e a FAC decai devagar, quase em linha reta.
- **Sobredose** (diferenciar o que já era estacionário): aparece um efeito colateral, um MA com raiz **exatamente** em $z=1$. A assinatura é $\widehat\rho_1$ negativo, perto de $-0{,}5$.

Uma regra prática das notas de identificação de Duke: nunca mais de duas diferenças no total, contando a sazonal.

**A diferença sazonal compara com o mesmo mês do ano anterior.** Em vez de "quanto mudou desde o mês passado", $(1-L^{12})y_t$ pergunta "quanto mudou desde o mesmo mês do ano passado". O padrão de dezembro é comparado com dezembro, e a sazonalidade some se for estável.

**O SAR é a memória de calendário.** Num SAR(1)$_4$ trimestral, o primeiro trimestre lembra o primeiro trimestre do ano anterior, e só ele. **O multiplicativo são duas engrenagens acopladas:** uma gira a cada período (o $\phi$) e outra a cada ano (o $\Phi$). Quando se encaixam, aparece um dente a mais, o termo $\phi\Phi L^5$, e com ele os picos "satélites" em volta da defasagem sazonal.

> [!WARNING]
> **Onde a analogia quebra**
> - **A sobredose não "adoece" a série.** $\Delta y_t$ de um AR(1) estacionário **continua estacionária**. O custo é outro: um MA não invertível, sem AR($\infty$), com estimação e previsão piores. O efeito colateral é de eficiência, não de estacionariedade.
> - **O trilho pode ser elástico demais para se ver.** Um processo TS com desvios AR(1) de $\phi=0{,}98$ volta ao trilho tão devagar que, numa amostra curta, é praticamente indistinguível de um passeio. É por isso que os testes de raiz unitária têm pouco poder (MAT, §2).
> - **"Comparar com o ano anterior" só limpa sazonalidade estável.** Se o padrão sazonal muda ao longo dos anos, a diferença sazonal não basta, e o que sobra precisa de termos SAR/SMA.

## Teoria

**Processo integrado** (MAT, p. 8–9). $y_t\sim I(d)$ se é preciso diferenciar $d$ vezes para obter um processo estacionário e invertível. **ARIMA($p,d,q$)** quer dizer que $w_t=(1-L)^dy_t$ é ARMA($p,q$):

$$
\phi(L)(1-L)^d\,y_t=c+\theta(L)\,\varepsilon_t,\qquad \phi(z)\ne0 \text{ e } \theta(z)\ne0 \text{ para } \lvert z\rvert\le1 .
$$

Como $\phi(L)(1-L)^d$ tem $d$ raízes **exatamente** em $z=1$, as "raízes unitárias", o nível não é estacionário, mas a diferença é.

**Tendência estacionária (TS) × diferença estacionária (DS)** (MAT, p. 1–16; AU01, p. 28–30):

| | TS: $y_t=\alpha+\beta t+u_t$, $u_t$ estacionário | DS: $\Delta y_t=\beta+u_t$, $u_t$ estacionário |
|---|---|---|
| tendência | determinística | estocástica: $\sum u_s$ |
| efeito de um choque | transitório | **permanente** |
| variância do erro de previsão | limitada | cresce com o horizonte |
| como estacionarizar | regredir em $t$ | diferenciar |
| erro se trocar | diferenciar dá MA não invertível | regredir em $t$ deixa um passeio no resíduo |

A **decomposição de Beveridge-Nelson** (MAT, p. 11) separa um processo DS em uma tendência estocástica, que é um passeio, e um ciclo estacionário.

**Sobrediferenciação** (lista, Q9 e Q10). Diferenciar um processo já estacionário cria um MA com o fator $(1-L)$, de raiz $z=1$ (AU02, p. 33):
- o processo continua estacionário, mas **não é invertível**;
- some a forma AR($\infty$) convergente (AU02, p. 30–31);
- a variância pode aumentar;
- a previsão piora.

**SAR, SMA e SARIMA** (AU05; BJRL, cap. 9). Com período $s$:

$$
\phi(L)\,\Phi(L^s)\,(1-L)^d(1-L^s)^D\,y_t=c+\theta(L)\,\Theta(L^s)\,\varepsilon_t,\qquad \text{SARIMA}(p,d,q)(P,D,Q)_s .
$$

- A diferença sazonal, $(1-L^s)\,y_t=y_t-y_{t-s}$, compara cada período com o mesmo período do ano anterior. O polinômio $1-z^s$ tem as $s$ raízes da unidade, todas com módulo 1, e por isso ela remove uma sazonalidade estável, do tipo "passeio sazonal".
- O **SAR(1)$_s$**, $y_t=\Phi_1y_{t-s}+\varepsilon_t$, tem FAC não nula **só** nas defasagens múltiplas de $s$: $\rho_{js}=\Phi_1^j$.
- No **multiplicativo**, o produto dos polinômios cria termos cruzados, como $\phi\Phi L^{s+1}$, com coeficientes **restritos**.
- As diferenças $(1-L)^d(1-L^s)^D$ consomem $d+sD$ observações.

**Na lista**, troque $L$ por $B$. O MA usa o sinal de Box-Jenkins, $\Theta^{\text{lista}}=-\Theta_1$, e o lado AR não muda.

## Demonstrações

### D3.1 · Diferenciar um AR(1) estacionário cria uma raiz unitária no MA (Q9)

$y_t=\phi y_{t-1}+\varepsilon_t$, com $\lvert\phi\rvert\lt1$, e $w_t=\Delta y_t=y_t-y_{t-1}$.

$$
\begin{aligned}
\text{(1)}\quad & w_t=y_t-y_{t-1}=\phi y_{t-1}+\varepsilon_t-y_{t-1} && [\text{modelo}]\\
\text{(2)}\quad & w_t=-(1-\phi)\,y_{t-1}+\varepsilon_t && [\text{agrupa } y_{t-1}]\\
\text{(3)}\quad & (1-\phi L)\,y_t=\varepsilon_t && [\text{modelo em } L]\\
\text{(4)}\quad & (1-L)(1-\phi L)\,y_t=(1-L)\,\varepsilon_t && [\text{aplica } (1-L) \text{ aos dois lados}]\\
\text{(5)}\quad & (1-\phi L)\,(1-L)y_t=(1-L)\,\varepsilon_t && [\text{polinômios comutam}]\\
\text{(6)}\quad & (1-\phi L)\,w_t=(1-L)\,\varepsilon_t && [w_t=(1-L)y_t]\\
\text{(7)}\quad & \theta(z)=1-z=0\ \Longrightarrow\ z=1,\ \lvert z\rvert=1 && [\text{raiz no círculo}]\\
\text{(8)}\quad & (1-L)^{-1}=1+L+L^2+\cdots && [\text{F2 com razão } 1]
\end{aligned}
$$

Em (8), a série geométrica de razão 1 tem todos os pesos iguais a 1, e eles não encolhem. Os $\pi_j$ de $w_t$ não são somáveis, e **não existe AR($\infty$) convergente**. Os choques não podem ser recuperados do passado de $w$.

**A assinatura na FAC.** Com $\gamma_k$ de $y$ e $\gamma_k=\phi^k\gamma_0$:

$$
\begin{aligned}
\text{(9)}\quad & \gamma_w(0)=E\big((y_t-y_{t-1})^2\big)=2\gamma_0-2\gamma_1=2\gamma_0(1-\phi) && [\text{F5}]\\
\text{(10)}\quad & \gamma_w(1)=E\big((y_t-y_{t-1})(y_{t-1}-y_{t-2})\big)=2\gamma_1-\gamma_0-\gamma_2=-\gamma_0(1-\phi)^2 && [\text{F5, } \gamma_k=\phi^k\gamma_0]\\
\text{(11)}\quad & \rho_w(1)=\frac{-\gamma_0(1-\phi)^2}{2\gamma_0(1-\phi)}=-\frac{1-\phi}{2} && [(10)\div(9)]
\end{aligned}
$$

$$
\boxed{(1-\phi L)\,w_t=(1-L)\,\varepsilon_t:\ \text{ARMA(1,1) com MA não invertível};\qquad \rho_w(1)=-\tfrac{1-\phi}{2}\in(-1,0)}
$$

Com $\phi=0$, ou seja, diferenciando um ruído branco, $\rho_w(1)=-0{,}5$ **exatamente**: é a assinatura clássica da sobrediferenciação.

### D3.2 · Diferenciar uma tendência determinística (Q10d)

$y_t=\alpha+\beta t+u_t$, com $u_t\sim RB(0,\sigma^2)$.

$$
\begin{aligned}
\text{(1)}\quad & y_{t-1}=\alpha+\beta(t-1)+u_{t-1} && [\text{modelo em } t-1]\\
\text{(2)}\quad & \Delta y_t=\beta t-\beta(t-1)+u_t-u_{t-1} && [\text{subtrai}]\\
\text{(3)}\quad & \Delta y_t=\beta+u_t-u_{t-1}=\beta+(1-L)\,u_t && [\text{simplifica}]\\
\text{(4)}\quad & \gamma_0=E\big((u_t-u_{t-1})^2\big)=2\sigma^2 && [\text{RB}]\\
\text{(5)}\quad & \gamma_1=E\big((u_t-u_{t-1})(u_{t-1}-u_{t-2})\big)=-\sigma^2 && [\text{RB: só } u_{t-1}^2]\\
\text{(6)}\quad & \rho_1=-\tfrac12,\qquad \theta(z)=1-z \Rightarrow z=1 && [\text{não invertível}]
\end{aligned}
$$

$$
\boxed{\Delta(\text{TS})=\beta+(1-L)u_t:\ \text{estacionário, mas com MA não invertível; o certo é regredir } y_t \text{ em } (1,t)}
$$

Pela regressão, o resíduo estima $u_t$ diretamente, sem criar estrutura falsa. É o mesmo argumento da Q2(d), demonstrado na [folha à mão](../lista_comentada/a_mao_q02_q06.md).

### D3.3 · ARIMA(1,1,1): a equação de diferenças (Q10b)

Nos slides: $(1-\phi_1L)(1-L)\,y_t=(1+\theta_1L)\,\varepsilon_t$.

$$
\begin{aligned}
\text{(1)}\quad & (1-\phi_1L)(1-L)=1-L-\phi_1L+\phi_1L^2 && [\text{F8: termo a termo}]\\
\text{(2)}\quad & \phantom{(1-\phi_1L)(1-L)}=1-(1+\phi_1)L+\phi_1L^2 && [\text{agrupa}]\\
\text{(3)}\quad & y_t-(1+\phi_1)y_{t-1}+\phi_1y_{t-2}=\varepsilon_t+\theta_1\varepsilon_{t-1} && [\text{aplica a } y_t]\\
\text{(4)}\quad & y_t=(1+\phi_1)y_{t-1}-\phi_1y_{t-2}+\varepsilon_t+\theta_1\varepsilon_{t-1} && [\text{isola } y_t]\\
\text{(5)}\quad & \text{raízes do lado AR: } 1-\phi_1z=0\Rightarrow z=1/\phi_1;\quad 1-z=0\Rightarrow z=1 && [\text{uma raiz unitária}]\\
\text{(6)}\quad & \text{na lista: } \theta_1=-\theta\ \Rightarrow\ y_t=(1+\phi)y_{t-1}-\phi y_{t-2}+a_t-\theta a_{t-1} && [\text{tradução}]
\end{aligned}
$$

$$
\boxed{y_t=(1+\phi_1)\,y_{t-1}-\phi_1\,y_{t-2}+\varepsilon_t+\theta_1\varepsilon_{t-1}}
$$

Olhando para (4), parece um "AR(2)". Mas a soma dos coeficientes, $(1+\phi_1)-\phi_1=1$, é a marca de uma raiz unitária: $\phi(1)=0$.

### D3.4 · SAR(1)$_4$: a FAC só vive nos múltiplos de 4 (Q11a)

$y_t=\Phi_1y_{t-4}+\varepsilon_t$, com $\lvert\Phi_1\rvert\lt1$. Multiplique por $y_{t-k}$ e tire a esperança.

$$
\begin{aligned}
\text{(1)}\quad & \gamma_0=\Phi_1^2\gamma_0+\sigma^2\ \Longrightarrow\ \gamma_0=\frac{\sigma^2}{1-\Phi_1^2} && [\text{como no AR(1), cap. 2}]\\
\text{(2)}\quad & \gamma_k=\Phi_1\gamma_{k-4},\quad k\ge1 && [\text{caus.}]\\
\text{(3)}\quad & \gamma_4=\Phi_1\gamma_0,\qquad \gamma_8=\Phi_1\gamma_4=\Phi_1^2\gamma_0 && [(2)]\\
\text{(4)}\quad & k=2:\ \gamma_2=\Phi_1\gamma_{-2}=\Phi_1\gamma_2\ \Longrightarrow\ (1-\Phi_1)\gamma_2=0\ \Longrightarrow\ \gamma_2=0 && [\gamma_{-k}=\gamma_k]\\
\text{(5)}\quad & k=1:\ \gamma_1=\Phi_1\gamma_3;\qquad k=3:\ \gamma_3=\Phi_1\gamma_1 && [(2)]\\
\text{(6)}\quad & \gamma_1=\Phi_1^2\gamma_1\ \Longrightarrow\ (1-\Phi_1^2)\gamma_1=0\ \Longrightarrow\ \gamma_1=\gamma_3=0 && [(5)]
\end{aligned}
$$

Por (2), os zeros de $k=1,2,3$ se propagam para $5,6,7,9,\dots$

$$
\boxed{\gamma_{4j}=\Phi_1^{\,j}\gamma_0,\qquad \gamma_k=0 \text{ se } k \text{ não é múltiplo de } 4}
$$

**FAC:** decai geometricamente só nos múltiplos de 4, igual a um AR(1) "esticado". **FACP:** um único pico, em 4, e zero no resto.

### D3.5 · O multiplicativo é um AR(5) restrito (Q11c)

$(1-\phi L)(1-\Phi L^4)\,y_t=\varepsilon_t$.

$$
\begin{aligned}
\text{(1)}\quad & (1-\phi L)(1-\Phi L^4)=1\cdot1+1\cdot(-\Phi L^4)+(-\phi L)\cdot1+(-\phi L)(-\Phi L^4) && [\text{F8: quatro produtos}]\\
\text{(2)}\quad & \phantom{(1-\phi L)(1-\Phi L^4)}=1-\phi L-\Phi L^4+\phi\Phi L^5 && [\text{simplifica}]\\
\text{(3)}\quad & y_t=\phi\,y_{t-1}+\Phi\,y_{t-4}-\phi\Phi\,y_{t-5}+\varepsilon_t && [\text{isola } y_t]\\
\text{(4)}\quad & \text{AR(5)}:\ \phi_1=\phi,\ \phi_2=0,\ \phi_3=0,\ \phi_4=\Phi,\ \phi_5=-\phi\Phi && [\text{compara}]\\
\text{(5)}\quad & \text{restrições: } \phi_2=\phi_3=0 \text{ e } \phi_5=-\phi_1\phi_4 && [\text{3 restrições}]\\
\text{(6)}\quad & \text{parâmetros livres: } 5-3=2,\ (\phi,\Phi) && [\text{parcimônia}]
\end{aligned}
$$

$$
\boxed{(1-\phi L)(1-\Phi L^4)=1-\phi L-\Phi L^4+\phi\Phi L^5:\quad \phi_2=\phi_3=0,\ \ \phi_5=-\phi_1\phi_4}
$$

O termo $\phi\Phi L^5$ é o "dente a mais" das engrenagens. É ele que cria os satélites na FAC em volta da defasagem 4.

### D3.6 · Beveridge-Nelson e o mapa dos testes de raiz unitária (MAT §1.6 e §2)

**Beveridge-Nelson** (MAT, p. 11 e apêndice A). Todo processo I(1) é a soma de uma tendência estocástica, um passeio, com um ciclo estacionário. A conta no ARIMA(0,1,1) dos slides, $\Delta y_t=\mu+\varepsilon_t+\theta_1\varepsilon_{t-1}$, com $y_0$ e $\varepsilon_0=0$:

$$
\begin{aligned}
\text{(1)}\quad & \Delta y_t=\mu+\psi(L)\,\varepsilon_t,\qquad \psi(L)=1+\theta_1L && [\text{modelo}]\\
\text{(2)}\quad & \psi(L)=\psi(1)+(1-L)\,\psi^*(L) && [\text{divide } \psi(L)-\psi(1) \text{ por } (1-L)]\\
\text{(3)}\quad & 1+\theta_1L=(1+\theta_1)+(1-L)(-\theta_1) && [\text{confere: } 1+\theta_1-\theta_1+\theta_1L]\\
\text{(4)}\quad & y_t=y_0+\mu t+\psi(1)\textstyle\sum_{s=1}^{t}\varepsilon_s+\psi^*(L)\varepsilon_t-\psi^*(L)\varepsilon_0 && [\text{soma de 1 a } t;\ (1-L) \text{ telescopa}]\\
\text{(5)}\quad & \underbrace{y_0+\mu t+(1+\theta_1)\textstyle\sum_{s=1}^{t}\varepsilon_s}_{\text{tendência (passeio)}}\ +\ \underbrace{(-\theta_1)\,\varepsilon_t}_{\text{ciclo}} && [(3),(4),\ \varepsilon_0=0]\\
\text{(6)}\quad & \psi(1)=1+\theta_1:\ \text{a fração de um choque que fica para sempre} && [\text{persistência}]\\
\text{(7)}\quad & \theta_1\to-1\ \Rightarrow\ \psi(1)\to0:\ \text{nada é permanente, e } y_t \text{ é TS} && [\text{sobrediferenciação, D3.1}]
\end{aligned}
$$

$$
\boxed{y_t=\underbrace{y_0+\mu t+\psi(1)\textstyle\sum\varepsilon_s}_{\text{tendência estocástica}}+\underbrace{\psi^*(L)\varepsilon_t}_{\text{ciclo}},\qquad \psi(1)=\text{persistência}}
$$

Com $\theta_1=-0{,}6$, $\psi(1)=0{,}4$: 40% de cada choque é permanente, e o resto se desfaz no período seguinte. Numa série simulada de 5 000 períodos, a tendência mais o ciclo de (5) reconstroem $y_t$ com diferença da ordem de $10^{-13}$. A identidade (3) confere com diferença zero.

**O mapa dos testes** (MAT §2; AU04). Todos partem da mesma regressão; o que muda é como tratam o erro e os termos determinísticos.

$$
\begin{aligned}
\text{(8)}\quad & y_t=\rho\,y_{t-1}+u_t\ \Rightarrow\ \Delta y_t=\gamma\,y_{t-1}+u_t,\ \ \gamma=\rho-1;\ \ H_0:\gamma=0 && [\text{MAT §2.1, p. 17}]\\
\text{(9)}\quad & \text{DF: } \tau=\widehat\gamma/ep(\widehat\gamma),\ \text{críticos não padrão, três especificações} && [\text{MAT §2.2, p. 19–23}]\\
\text{(10)}\quad & \text{ADF: acrescenta } \textstyle\sum_{i=1}^{k}\delta_i\Delta y_{t-i} \text{ para branquear } u_t && [\text{MAT p. 24–28}]\\
\text{(11)}\quad & \text{PP: corrige } \tau \text{ pela variância de longo prazo, sem defasagens} && [\text{MAT §2.3, p. 29}]\\
\text{(12)}\quad & \text{DF-GLS: tira os determinísticos por MQG antes; mais poder} && [\text{MAT §2.4, p. 32}]\\
\text{(13)}\quad & \text{ERS ponto ótimo: o teste mais poderoso contra uma alternativa fixada} && [\text{MAT §2.5, p. 35}]\\
\text{(14)}\quad & \text{KPSS: nula invertida (estacionariedade), para cruzar com o ADF} && [\text{AU04}]\\
\text{(15)}\quad & \text{raiz unitária sazonal: HEGY, OCSB, Canova-Hansen} && [\text{MAT §2.6; AU05}]
\end{aligned}
$$

Em (15), o MAT, p. 38, estende o ADF para a frequência sazonal. A ligação com a lista: na Q10, decidir entre TS e DS é exatamente o que esses testes fazem. Com $\phi$ perto de 1, nenhum deles tem muito poder (D03.3 no aprofundamento deste bloco). Por isso a regra prática é cruzar um teste de nula "raiz unitária" com um de nula "estacionário".

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_c3_bn_psi1 | 0,4 |
| ap_c3_bn_dif | 0 |
| ap_c3_bn_recon | 0 |
-->

## Exemplo

**1. Quanto custa diferenciar um AR(1) estacionário.** Valores do R para $w_t=\Delta y_t$, com $\sigma^2=1$, a partir de (9)–(11) da D3.1:

| $\phi$ | $\operatorname{Var}(y_t)$ | $\operatorname{Var}(w_t)$ | $\rho_w(1)$ | leitura |
|---|---|---|---|---|
| 0,2 | 1,0417 | 1,6667 | $-0{,}40$ | a variância **aumenta** 60%: sobredose clara |
| 0,5 | 1,3333 | 1,3333 | $-0{,}25$ | empata |
| 0,9 | 5,2632 | 1,0526 | $-0{,}05$ | parece "melhorar", mas o MA tem raiz unitária |

- O caso $\phi=0$ (ruído branco diferenciado) dá $\rho_w(1)=-0{,}5$, conferido com o `ARMAacf`.
- Com $\phi=0{,}5$, o `ARMAacf(ar = 0.5, ma = -1)` confirma $-0{,}25$.

**A regra de Duke** ("a ordem certa de diferenciação costuma ser a de menor desvio padrão") acerta com $\phi=0{,}2$ e engana com $\phi=0{,}9$. Por isso o critério final é a raiz do MA, não a variância.

**2. SAR(1)$_4$ com $\Phi_1=0{,}6$.**
- $\gamma_0=1/(1-0{,}36)=1{,}5625$;
- $\gamma_4=0{,}9375$;
- $\gamma_8=0{,}5625$.

No R, $\rho_1=0$, $\rho_4=0{,}6$ e $\rho_8=0{,}36$: a FAC só vive nos múltiplos de 4.

**3. Multiplicativo com $\phi=0{,}5$ e $\Phi=0{,}6$.** Vira o AR(5) $y_t=0{,}5y_{t-1}+0{,}6y_{t-4}-0{,}3y_{t-5}+\varepsilon_t$.

**4. Observações perdidas** com $d=D=1$:
- trimestral (Q12): $1+4=5$;
- mensal (Q16): $1+12=13$.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_c3_rb_rho1 | -0,5 |
| ap_c3_w_rho1_02 | -0,40 |
| ap_c3_vary_02 | 1,0417 |
| ap_c3_varw_02 | 1,6667 |
| ap_c3_w_rho1_05 | -0,25 |
| ap_c3_vary_05 | 1,3333 |
| ap_c3_varw_05 | 1,3333 |
| ap_c3_w_rho1_09 | -0,05 |
| ap_c3_vary_09 | 5,2632 |
| ap_c3_varw_09 | 1,0526 |
| ap_c3_w_rho1_05_r | -0,25 |
| ap_c3_sar_g0 | 1,5625 |
| ap_c3_sar_g4 | 0,9375 |
| ap_c3_sar_g8 | 0,5625 |
| ap_c3_sar_rho1_r | 0 |
| ap_c3_sar_rho4_r | 0,6 |
| ap_c3_sar_rho8_r | 0,36 |
| ap_c3_mult_phi1 | 0,5 |
| ap_c3_mult_phi4 | 0,6 |
| ap_c3_mult_phi5 | -0,3 |
| ap_c3_perda_trim | 5 |
| ap_c3_perda_mensal | 13 |
-->

## Cadeia socrática

**P1.** Se $\Delta y_t$ é estacionário, $y_t$ é necessariamente um passeio aleatório?

> [!TIP]
> **Resposta**
> Não. $y_t$ é I(1), mas $\Delta y_t$ pode ser qualquer ARMA estacionário e invertível. O passeio é o caso particular em que $\Delta y_t$ é ruído branco. Um ARIMA(1,1,1) também tem $\Delta y_t$ estacionário (D3.3).

**P2.** A série tem tendência linear clara. Diferenciar resolve?

> [!TIP]
> **Resposta**
> Torna estacionário nos dois casos, TS ou DS. Mas, se a tendência é determinística, diferenciar cria um MA com raiz unitária (D3.2). O remédio certo para TS é a regressão em $t$. "Torna estacionário" não basta: precisa ser estacionário **e invertível**.

**P3.** Como reconhecer a sobrediferenciação pela FAC?

> [!TIP]
> **Resposta**
> $\widehat\rho_1$ negativo e forte, perto de $-0{,}5$, e a FAC cortando depois disso, que é a cara de um MA(1) com $\theta_1\approx-1$. Na estimação, $\widehat\theta_1$ encosta em $-1$. Pela regra de Duke, uma raiz unitária no MA pede **uma diferença a menos**.

**P4.** E a subdiferenciação?

> [!TIP]
> **Resposta**
> FAC com correlações positivas que decaem muito devagar, quase em linha reta (cap. 1, D1.1: $\operatorname{Corr}=\sqrt{(t-k)/t}$). No AR estimado, a soma dos coeficientes fica perto de 1, como em D3.3, em que $(1+\phi_1)-\phi_1=1$.

**P5.** Por que, num SAR(1)$_4$, $\gamma_1=0$, se o processo tem memória?

> [!TIP]
> **Resposta**
> Porque a memória é de **calendário**: $y_t$ depende de $y_{t-4}$, que depende de $y_{t-8}$… A cadeia nunca passa por $y_{t-1}$. Formalmente, $\gamma_1=\Phi_1^2\gamma_1$ força $\gamma_1=0$ (D3.4).

**P6.** No SARIMA(1,0,0)(1,0,0)$_4$, de onde vem o coeficiente de $y_{t-5}$?

> [!TIP]
> **Resposta**
> Do produto dos dois polinômios: $(-\phi L)(-\Phi L^4)=\phi\Phi L^5$. Ninguém o escolheu: ele é **imposto**, $\phi_5=-\phi_1\phi_4$. É isso que faz o multiplicativo ser parcimonioso, com 2 parâmetros no lugar de 5.

**P7.** Quantas observações a Q12 perde, e por quê?

> [!TIP]
> **Resposta**
> Cinco. $(1-L)(1-L^4)y_t=y_t-y_{t-1}-y_{t-4}+y_{t-5}$ precisa de $y_{t-5}$. O primeiro $w$ calculável é $w_6$. Em geral, perdem-se $d+sD$.

**P8.** "Raiz unitária" e "não estacionário" são sinônimos?

> [!TIP]
> **Resposta**
> Não. Toda raiz unitária no AR gera não estacionariedade, mas uma série TS também é não estacionária, porque a média depende de $t$, e não tem raiz unitária. E uma raiz unitária no **MA** não torna o processo não estacionário: torna-o não invertível (D3.1).

## Diálogo

*Sobre "diferenciar por segurança".*

**Aluno:** Na dúvida, eu diferencio. Se a série já era estacionária, diferenciar não estraga nada: continua estacionária.

**Professor:** Continua estacionária, sim. E invertível?

**Aluno:** … Pela D3.1, aparece $(1-L)$ no MA, com raiz em $z=1$. Então não é invertível.

**Professor:** E o que você perde sem a invertibilidade?

**Aluno:** A forma AR($\infty$). Sem ela, não dá para recuperar os $\varepsilon_t$ a partir dos dados… e a previsão precisa deles.

**Professor:** Algo mais? Olhe a variância na tabela do exemplo.

**Aluno:** Com $\phi=0{,}2$, a variância de $\Delta y$ é 1,67, contra 1,04 do nível. Eu acrescentei ruído.

**Professor:** Então "por segurança" tem um preço. Qual seria a regra?

**Aluno:** Diferenciar só com evidência de raiz unitária: FAC lenta e um teste. Depois de diferenciar, olhar $\widehat\rho_1$: se estiver perto de $-0{,}5$, ou se o $\widehat\theta_1$ encostar em $-1$, voltar uma diferença.

**Professor:** E se a tendência for determinística?

**Aluno:** Aí não diferencio: regrido em $t$. Diferenciar uma TS também cria o $(1-L)$ no MA (D3.2).

## Na prova

**A folha de caderno do bloco** está em [a_mao_cap3.md](a_mao_cap3.md): Q9 a Q12 em 67 linhas numeradas, cada uma com a justificativa, mais a versão para a prova e a conferência em R.

| Questão | O que este capítulo dá | Resolução completa |
|---|---|---|
| Q9 | sobrediferenciação do AR(1): $(1-\phi B)w_t=(1-B)\varepsilon_t$, raiz $z=1$, sem AR($\infty$) | [Q9](../lista_comentada/q09.md) |
| Q10 | ARIMA → ARMA na diferença; ARIMA(1,1,1) expandido; TS × DS; regressão × diferença | [Q10](../lista_comentada/q10.md) |
| Q11 | SAR(1)$_4$: $\gamma_{4j}$, zeros fora dos múltiplos; multiplicativo como AR(5) restrito | [Q11](../lista_comentada/q11.md) |
| Q12 | SARIMA(1,1,0)(0,1,1)$_4$: modelo, 5 perdas, previsão, diagnóstico | [Q12](../lista_comentada/q12.md) |

**Armadilhas:**
- dizer que a sobrediferenciação "torna a série não estacionária": ela torna **não invertível**;
- na Q11(a), esquecer de **provar** que $\gamma_1=\gamma_2=\gamma_3=0$ (D3.4, linhas 4–6);
- contar 5 parâmetros livres no AR(5) restrito: são 2;
- na Q10(b), errar o sinal de $\phi_1L^2$ na expansão;
- confundir "tem tendência" com "tem raiz unitária".

**Checklist de 30 segundos:**
1. Disse **qual** tendência (determinística ou estocástica) e o remédio correspondente?
2. Mostrei a raiz do MA ($z=1$) quando falei de sobrediferenciação?
3. Expandi os polinômios termo a termo (F8)?
4. Contei as observações perdidas com $d+sD$?
5. Traduzi o sinal do MA sazonal para a lista ($\Theta^{\text{lista}}=-\Theta_1$)?

## No material do professor

**Roteiro de releitura:**
- AU01, p. 28–30: passeio, drift e tendência;
- MAT, p. 1–9: tendência determinística, estocástica, processo integrado e raiz unitária;
- MAT, p. 11–16: Beveridge-Nelson, diferença estacionária, memória e os quatro processos;
- AU02, p. 30–36: invertibilidade, a razão pela qual $(1-L)$ no MA é um problema;
- MAT, p. 38: ADF com sazonalidade;
- AU05: ARIMA e SARIMA, com a notação $(p,d,q)(P,D,Q)_s$.

**Livros:**
- **BJRL**, cap. 4 (ARIMA) e cap. 9 (sazonais multiplicativos);
- **ENDERS**, cap. 4: tendências e raiz unitária;
- **HAMILTON**, cap. 15: processos com tendência, TS × DS.

**Na lista comentada:** [Q9](../lista_comentada/q09.md) · [Q10](../lista_comentada/q10.md) · [Q11](../lista_comentada/q11.md) · [Q12](../lista_comentada/q12.md) · ferramentas [F2 e F8](../lista_comentada/README.md#2-caixa-de-ferramentas).
