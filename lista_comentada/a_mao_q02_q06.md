---
title: "Demonstrações à mão — Q2 e Q6, linha a linha"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: [2, 6]
aulas: "AU01 p. 25, 30; AU02 p. 11, 21–23, 81–85; MAT §1.3"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Demonstrações à mão — Q2 e Q6
---

# Demonstrações à mão: Q2 e Q6

Esta é a demonstração **como se escreve no caderno**: cada linha numerada, (1), (2), (3)…, uma operação por linha e o motivo entre colchetes à direita. A base é o enunciado da lista, escrito com os **mesmos símbolos dos slides e do caderno**: $Y_t$, $\alpha_1$, $\alpha_2$ e $y_0$ na Q2 (AU01, p. 28–30); $c$, $\mu$, $\phi_1$, $\theta_1$, $\varepsilon_t$ e os desvios $(y_t-\mu)$ na Q6 (AU02, p. 81–84). A única diferença é gráfica: os slides escrevem a esperança com colchetes, e aqui, como no resto do repositório, ela vem com parênteses, $E(\cdot)$. As versões comentadas, com livro, caderno e armadilhas, estão em [Q2](q02.md) e [Q6](q06.md).

**Legenda dos colchetes:**
- [RB]: ruído branco, $E(\varepsilon_t)=0$, $E(\varepsilon_t^2)=\sigma^2$ e $E(\varepsilon_i\varepsilon_j)=0$ se $i\ne j$;
- [lin.]: linearidade da esperança, em que constantes saem e a esperança da soma é a soma das esperanças;
- [estac.]: estacionariedade, os momentos não dependem da data: $E(y_t)=\mu$ e $E\big((y_{t-j}-\mu)^2\big)=\gamma_0$ para todo $j$;
- [caus.]: causalidade, o choque de hoje não se correlaciona com o passado de $y$;
- [(n)]: usando a linha (n).

---

# Q2 · Passeio com drift e tendência determinística

**Enunciado (lista, Q2).** Um passeio aleatório recebe, a cada período, um drift constante $c$ e um termo de tendência $\delta t$, com valor inicial $y_0=0$ e choques ruído branco. Pede-se:
- (a) a solução explícita;
- (b) média, variância e autocovariância;
- (c) a comparação com o passeio só com drift;
- (d) a natureza da tendência e como tirar a não estacionariedade.

**Nos slides** (AU01, p. 30):

$$
Y_t=\alpha_1+Y_{t-1}+\alpha_2\,t+\varepsilon_t,\qquad \varepsilon_t\sim RB(0,\sigma^2),\qquad Y_0=0,
$$

com $\alpha_1=c$ (drift) e $\alpha_2=\delta$ (tendência). O slide escreve o valor inicial genérico, $Y_0=y_0$, fixo e não aleatório; a lista fixa $y_0=0$. No caderno (19/08), o mesmo modelo aparece como $Y_t=\alpha+Y_{t-1}+\alpha_2t+\varepsilon_t$, com $\alpha=\alpha_1$.

## (a) Solução explícita

**Caminho 1 — substituição recursiva.**

$$
\begin{aligned}
\text{(1)}\quad & Y_1=\alpha_1+Y_0+\alpha_2\cdot1+\varepsilon_1=\alpha_1+\alpha_2+\varepsilon_1 && [Y_0=0]\\
\text{(2)}\quad & Y_2=\alpha_1+Y_1+2\alpha_2+\varepsilon_2 && [\text{modelo}]\\
\text{(3)}\quad & \phantom{Y_2}=\alpha_1+(\alpha_1+\alpha_2+\varepsilon_1)+2\alpha_2+\varepsilon_2 && [(1)]\\
\text{(4)}\quad & \phantom{Y_2}=2\alpha_1+(1+2)\alpha_2+\varepsilon_1+\varepsilon_2\\
\text{(5)}\quad & Y_3=\alpha_1+Y_2+3\alpha_2+\varepsilon_3=3\alpha_1+(1+2+3)\alpha_2+\varepsilon_1+\varepsilon_2+\varepsilon_3 && [(4)]
\end{aligned}
$$

O padrão: cada período soma um $\alpha_1$, mais um múltiplo de $\alpha_2$ igual à data, e um choque novo.

$$
\text{(6)}\qquad Y_t=\alpha_1t+\alpha_2(1+2+\cdots+t)+\sum_{s=1}^{t}\varepsilon_s
$$

**Prova de (6) por indução.**
- **Base, $t=1$:** (6) dá $\alpha_1+\alpha_2\cdot1+\varepsilon_1$, que é a linha (1). ✓
- **Passo:** suponha (6) válida em $t$. Então:

$$
\begin{aligned}
\text{(7)}\quad & Y_{t+1}=\alpha_1+Y_t+\alpha_2(t+1)+\varepsilon_{t+1} && [\text{modelo}]\\
\text{(8)}\quad & \phantom{Y_{t+1}}=\alpha_1+\Big[\alpha_1t+\alpha_2(1+\cdots+t)+\sum_{s=1}^{t}\varepsilon_s\Big]+\alpha_2(t+1)+\varepsilon_{t+1} && [\text{hip. de indução}]\\
\text{(9)}\quad & \phantom{Y_{t+1}}=\alpha_1(t+1)+\alpha_2\big(1+\cdots+t+(t+1)\big)+\sum_{s=1}^{t+1}\varepsilon_s && [\text{agrupando}]
\end{aligned}
$$

  que é (6) em $t+1$. ✓

**A soma de Gauss.** Seja $S=1+2+\cdots+t$. Escreva a soma de novo, de trás para frente, $S=t+(t-1)+\cdots+1$, e some as duas linhas coluna a coluna. Cada coluna dá $t+1$, e são $t$ colunas: $2S=t(t+1)$, logo $S=\frac{t(t+1)}{2}$.

$$
\text{(10)}\qquad \boxed{Y_t=\alpha_1\,t+\alpha_2\,\frac{t(t+1)}{2}+\sum_{s=1}^{t}\varepsilon_s}
$$

**Caminho 2 — soma telescópica**, a conferência. Do modelo, $Y_s-Y_{s-1}=\alpha_1+\alpha_2s+\varepsilon_s$. Somando de $s=1$ a $t$:
- à esquerda, $(Y_1-Y_0)+(Y_2-Y_1)+\cdots+(Y_t-Y_{t-1})=Y_t-Y_0=Y_t$, porque os termos do meio se cancelam;
- à direita, $\alpha_1t+\alpha_2\frac{t(t+1)}{2}+\sum\varepsilon_s$.

É a mesma (10). **Com $y_0$ genérico**, a esquerda dá $Y_t-y_0$, e o resultado é $Y_t=y_0+\alpha_1t+\alpha_2\frac{t(t+1)}{2}+\sum_{s=1}^{t}\varepsilon_s$: tudo o que vem abaixo vale somando $y_0$ à média, exatamente como na AU01, p. 30. **Na lista:** $y_t=ct+\delta\frac{t(t+1)}{2}+\sum_{s=1}^{t}u_s$.

## (b) Média, variância e autocovariância

**Média.**

$$
\begin{aligned}
\text{(11)}\quad & E(Y_t)=E\Big(\alpha_1t+\alpha_2\tfrac{t(t+1)}{2}+\sum_{s=1}^{t}\varepsilon_s\Big) && [(10)]\\
\text{(12)}\quad & \phantom{E(Y_t)}=\alpha_1t+\alpha_2\tfrac{t(t+1)}{2}+\sum_{s=1}^{t}E(\varepsilon_s) && [\text{lin.}]\\
\text{(13)}\quad & \phantom{E(Y_t)}=\alpha_1t+\alpha_2\tfrac{t(t+1)}{2}\equiv\mu_t && [\text{RB}]
\end{aligned}
$$

**Desvio em relação à média.** Subtraindo (13) de (10):

$$
\text{(14)}\qquad Y_t-\mu_t=\sum_{s=1}^{t}\varepsilon_s
$$

**Variância.**

$$
\begin{aligned}
\text{(15)}\quad & V(Y_t)=E\big((Y_t-\mu_t)^2\big)=E\Big(\Big(\sum_{i=1}^{t}\varepsilon_i\Big)^2\Big) && [(14)]\\
\text{(16)}\quad & \phantom{V(Y_t)}=E\Big(\sum_{i=1}^{t}\sum_{j=1}^{t}\varepsilon_i\varepsilon_j\Big) && [\text{quadrado da soma}]\\
\text{(17)}\quad & \phantom{V(Y_t)}=\sum_{i=1}^{t}\sum_{j=1}^{t}E(\varepsilon_i\varepsilon_j) && [\text{lin.}]\\
\text{(18)}\quad & \phantom{V(Y_t)}=\sum_{i=1}^{t}E(\varepsilon_i^2)+\sum_{i\ne j}E(\varepsilon_i\varepsilon_j) && [\text{separa } i=j]\\
\text{(19)}\quad & \phantom{V(Y_t)}=t\sigma^2+0=t\sigma^2 && [\text{RB}]
\end{aligned}
$$

**Autocovariância**, para $0\le k\lt t$:

$$
\begin{aligned}
\text{(20)}\quad & \operatorname{Cov}(Y_t,Y_{t-k})=E\big((Y_t-\mu_t)(Y_{t-k}-\mu_{t-k})\big)\\
\text{(21)}\quad & \phantom{\operatorname{Cov}}=E\Big(\Big(\sum_{i=1}^{t}\varepsilon_i\Big)\Big(\sum_{j=1}^{t-k}\varepsilon_j\Big)\Big) && [(14)\text{ em } t \text{ e } t-k]\\
\text{(22)}\quad & \phantom{\operatorname{Cov}}=\sum_{i=1}^{t}\sum_{j=1}^{t-k}E(\varepsilon_i\varepsilon_j) && [\text{lin.}]\\
\text{(23)}\quad & \phantom{\operatorname{Cov}}=\sum_{j=1}^{t-k}E(\varepsilon_j^2) && [\text{RB: só } i=j]\\
\text{(24)}\quad & \phantom{\operatorname{Cov}}=(t-k)\sigma^2
\end{aligned}
$$

Em (23), os pares com $i=j$ só existem para $j=1,\dots,t-k$, porque a segunda soma para em $t-k$: são os choques que $Y_t$ e $Y_{t-k}$ têm em comum.

**Correlação:**

$$
\text{(25)}\qquad \rho(t,k)=\frac{(t-k)\sigma^2}{\sqrt{t\sigma^2\cdot(t-k)\sigma^2}}=\sqrt{\frac{t-k}{t}}
$$

$$
\boxed{E(Y_t)=\alpha_1t+\alpha_2\tfrac{t(t+1)}{2},\qquad V(Y_t)=t\sigma^2,\qquad \operatorname{Cov}(Y_t,Y_{t-k})=(t-k)\sigma^2}
$$

**Conclusão:** média, variância e autocovariância dependem de $t$. **O processo não é estacionário** (AU01, p. 25).

## (c) Comparação com o passeio com drift

Repetindo (1)–(24) com $\alpha_2=0$, isto é, com $Y_t=\alpha_1+Y_{t-1}+\varepsilon_t$ e $Y_0=0$, obtém-se $Y_t=\alpha_1t+\sum_{s=1}^{t}\varepsilon_s$, e:

| Momento | Só drift ($\alpha_2=0$) | Drift e tendência |
|---|---|---|
| $E(Y_t)$ | $\alpha_1t$ (reta) | $\alpha_1t+\alpha_2\frac{t(t+1)}{2}$ (parábola) |
| $V(Y_t)$ | $t\sigma^2$ | $t\sigma^2$ |
| $\operatorname{Cov}(Y_t,Y_{t-k})$ | $(t-k)\sigma^2$ | $(t-k)\sigma^2$ |

**Só a média muda**, pelo termo $\alpha_2\frac{t(t+1)}{2}$. A parte aleatória, $\sum\varepsilon_s$, é idêntica nos dois, e por isso variância e covariância são iguais.

## (d) Natureza da tendência e como removê-la

**Decomposição.** Por (10):

$$
\text{(26)}\qquad Y_t=\underbrace{\alpha_1t+\alpha_2\tfrac{t(t+1)}{2}}_{\text{tendência determinística}}+\underbrace{\sum_{s=1}^{t}\varepsilon_s}_{\text{tendência estocástica}}
$$

- **Os dois processos têm tendência estocástica** (raiz unitária). Por (10), $\partial Y_{t+j}/\partial\varepsilon_t=1$ para todo $j\ge0$: o choque é **permanente**.
- **A tendência determinística muda:** é linear com drift e quadrática com drift e tendência (MAT, §1.3, "tendência geral").

**Primeira diferença:**

$$
\begin{aligned}
\text{(27)}\quad & \Delta Y_t=Y_t-Y_{t-1}=\alpha_1+\alpha_2t+\varepsilon_t && [\text{modelo}]\\
\text{(28)}\quad & E(\Delta Y_t)=\alpha_1+\alpha_2t && [\text{lin., RB}]
\end{aligned}
$$

- **Só drift ($\alpha_2=0$):** $\Delta Y_t=\alpha_1+\varepsilon_t$, que é estacionário. Uma diferença basta.
- **Drift e tendência:** por (28), $\Delta Y_t$ **ainda tem tendência linear** na média. Uma diferença não basta.

**Caminho recomendado.** Diferenciar uma vez e **tirar a tendência linear de $\Delta Y_t$ por regressão** em $(1,t)$. Por (27), o resíduo dessa regressão estima $\varepsilon_t$, que é ruído branco.

**Caminho a evitar: diferenciar duas vezes.**

$$
\begin{aligned}
\text{(29)}\quad & \Delta^2Y_t=\Delta Y_t-\Delta Y_{t-1} && [\text{definição}]\\
\text{(30)}\quad & \phantom{\Delta^2Y_t}=(\alpha_1+\alpha_2t+\varepsilon_t)-\big(\alpha_1+\alpha_2(t-1)+\varepsilon_{t-1}\big) && [(27)]\\
\text{(31)}\quad & \phantom{\Delta^2Y_t}=\alpha_2+\varepsilon_t-\varepsilon_{t-1}=\alpha_2+(1-L)\,\varepsilon_t
\end{aligned}
$$

A média fica constante, $\alpha_2$, mas sobra um MA(1) com $\theta_1=-1$. O polinômio $\theta(z)=1-z$ tem raiz $z=1$, sobre o círculo: **não invertível** (AU02, p. 33). É a sobrediferenciação da [Q9](q09.md).

**Conclusão (implicação prática):** tendência estocástica se remove com **diferença**; tendência determinística se remove com **regressão em $t$**. Aqui, uma diferença e depois a regressão de $\Delta Y_t$ em $t$. A segunda diferença também estacionariza, mas deixa um MA não invertível.

## Versão para a prova (Q2)

O mínimo que precisa estar no papel:
1. Some o modelo de 1 a $t$ (telescópica) e use $\sum s=\frac{t(t+1)}{2}$: $Y_t=\alpha_1t+\alpha_2\frac{t(t+1)}{2}+\sum_{s=1}^{t}\varepsilon_s$.
2. $E(Y_t)=\alpha_1t+\alpha_2\frac{t(t+1)}{2}$ [lin., RB].
3. $Y_t-\mu_t=\sum\varepsilon_s$, logo $V(Y_t)=E\big((\sum\varepsilon_s)^2\big)=t\sigma^2$ [RB: só $i=j$].
4. $\operatorname{Cov}(Y_t,Y_{t-k})=E\big(\sum_{i\le t}\varepsilon_i\sum_{j\le t-k}\varepsilon_j\big)=(t-k)\sigma^2$.
5. Os momentos dependem de $t$: **não estacionário**.
6. Comparação: só a média muda (reta → parábola); $V$ e $\operatorname{Cov}$ são iguais.
7. Tendência estocástica $\sum\varepsilon_s$ + determinística quadrática. $\Delta Y_t=\alpha_1+\alpha_2t+\varepsilon_t$ ainda tem tendência: regredir $\Delta Y_t$ em $t$. $\Delta^2Y_t=\alpha_2+(1-L)\varepsilon_t$ não é invertível: evitar.

## Conferência (Q2)

Com $\alpha_1=1$ e $\alpha_2=0{,}2$:
- a recursão dá $E(Y_1)=1{,}2$, $E(Y_2)=2{,}6$ e $E(Y_3)=4{,}2$;
- a fórmula (13) dá os mesmos valores: $2+0{,}2\cdot3=2{,}6$ e $3+0{,}2\cdot6=4{,}2$;
- com 50 mil trajetórias simuladas e $\sigma^2=1$: $V(Y_3)\approx2{,}99$ (fórmula: 3), $\operatorname{Cov}(Y_3,Y_1)\approx1{,}00$ (fórmula: 1) e $\operatorname{Corr}(Y_3,Y_1)\approx0{,}58$ (fórmula: $\sqrt{1/3}=0{,}577$).

---

# Q6 · ARMA(1,1)

**Enunciado (lista, Q6).** O ARMA(1,1) $z_t-\phi z_{t-1}=a_t-\theta a_{t-1}$, com $\lvert\phi\rvert\lt1$ e $\lvert\theta\rvert\lt1$, na convenção de Box-Jenkins. Pede-se:
- (a) $\gamma_0$, $\gamma_1$ e $\gamma_k$ ($k\ge2$);
- (b) $\rho_1$, e mostrar que $\rho_k=\phi^{k-1}\rho_1$;
- (c) as formas AR($\infty$) e MA($\infty$), e para que parâmetros a convergência é mais lenta.

**Nos slides** (AU02, p. 81–84), com a constante $c$, como o professor e o caderno escrevem:

$$
y_t=c+\phi_1y_{t-1}+\varepsilon_t+\theta_1\varepsilon_{t-1},\qquad \varepsilon_t\sim RB(0,\sigma^2),
$$

ou seja, $(1-\phi_1L)\,y_t=c+(1+\theta_1L)\,\varepsilon_t$. A tradução da lista:
- $y_t=z_t$ e $\varepsilon_t=a_t$;
- $\phi_1=\phi$ e **$\theta_1=-\theta$**, por causa do sinal positivo dos slides;
- a lista não tem constante: $c=0$, logo $\mu=0$ e $y_t-\mu=z_t$.

Hipóteses: [RB]; $\lvert\phi_1\rvert\lt1$ (estacionário); $\lvert\theta_1\rvert\lt1$ (invertível). No fim, cada resultado volta para o sinal da lista.

## (0) Média, forma em desvios e momentos auxiliares

**Valor esperado** (AU02, p. 82):

$$
\begin{aligned}
\text{(1)}\quad & E(y_t)=c+\phi_1E(y_{t-1})+E(\varepsilon_t)+\theta_1E(\varepsilon_{t-1}) && [\text{lin.}]\\
\text{(2)}\quad & \mu=c+\phi_1\mu+0+0 && [\text{estac., RB}]\\
\text{(3)}\quad & \mu(1-\phi_1)=c\ \Longrightarrow\ \mu=\frac{c}{1-\phi_1} && [\lvert\phi_1\rvert\lt1]
\end{aligned}
$$

**Forma em desvios.** Subtraia $\mu$ dos dois lados do modelo e troque $c$ por $(1-\phi_1)\mu$, que vem de (3):

$$
\begin{aligned}
\text{(4)}\quad & y_t-\mu=(1-\phi_1)\mu-\mu+\phi_1y_{t-1}+\varepsilon_t+\theta_1\varepsilon_{t-1} && [(3)]\\
\text{(5)}\quad & \phantom{y_t-\mu}=-\phi_1\mu+\phi_1y_{t-1}+\varepsilon_t+\theta_1\varepsilon_{t-1}\\
\text{(6)}\quad & y_t-\mu=\phi_1(y_{t-1}-\mu)+\varepsilon_t+\theta_1\varepsilon_{t-1} && [\text{evidência}]
\end{aligned}
$$

A linha (6) é o "já sabemos que" da AU02, p. 82 e 84. A constante sumiu: todas as contas abaixo usam (6).

**Momentos auxiliares** (como no caderno, 02/09). Pelo item (c), $y_t-\mu=\sum_{j\ge0}\psi_j\varepsilon_{t-j}$: o desvio de hoje só contém choques de hoje e do passado.

$$
\begin{aligned}
\text{(7)}\quad & E(\varepsilon_t\varepsilon_t)=\sigma^2 && [\text{RB}]\\
\text{(8)}\quad & E\big((y_{t-k}-\mu)\,\varepsilon_t\big)=0\quad\text{para } k\ge1 && [\text{caus., RB}]\\
\text{(9)}\quad & E\big((y_t-\mu)\,\varepsilon_t\big)=E\big((\phi_1(y_{t-1}-\mu)+\varepsilon_t+\theta_1\varepsilon_{t-1})\,\varepsilon_t\big) && [(6)]\\
\text{(10)}\quad & \phantom{E\big((y_t-\mu)\,\varepsilon_t\big)}=\phi_1\cdot0+\sigma^2+\theta_1\cdot0=\sigma^2 && [(8),(7),\text{ RB}]\\
\text{(11)}\quad & E\big((y_{t+1}-\mu)\,\varepsilon_t\big)=E\big((\phi_1(y_t-\mu)+\varepsilon_{t+1}+\theta_1\varepsilon_t)\,\varepsilon_t\big) && [(6)\text{ em } t+1]\\
\text{(12)}\quad & \phantom{E\big((y_{t+1}-\mu)\,\varepsilon_t\big)}=\phi_1\sigma^2+0+\theta_1\sigma^2=(\phi_1+\theta_1)\,\sigma^2 && [(10),\text{ RB},\ (7)]
\end{aligned}
$$

Por estacionariedade, (10) vale em qualquer data. Em $t-1$, $E\big((y_{t-1}-\mu)\varepsilon_{t-1}\big)=\sigma^2$, que é o "lembre que" da AU02, p. 83.

## (a) $\gamma_0$, $\gamma_1$ e $\gamma_k$

**$\gamma_0$** (AU02, p. 82–83). Por (6):

$$
\text{(13)}\qquad \gamma_0=E\big((y_t-\mu)^2\big)=E\Big(\big(\phi_1(y_{t-1}-\mu)+\varepsilon_t+\theta_1\varepsilon_{t-1}\big)^2\Big)
$$

O quadrado é o produto do parêntese por ele mesmo: $3\times3=9$ termos, na ordem do slide. Cada termo com a sua esperança:

$$
\begin{aligned}
\text{(14)}\quad & E\big(\phi_1^2(y_{t-1}-\mu)^2\big)=\phi_1^2\gamma_0 && [\text{estac.}]\\
\text{(15)}\quad & E\big(\phi_1(y_{t-1}-\mu)\,\varepsilon_t\big)=0 && [(8)]\\
\text{(16)}\quad & E\big(\phi_1(y_{t-1}-\mu)\,\theta_1\varepsilon_{t-1}\big)=\phi_1\theta_1\sigma^2 && [(10)\text{ em } t-1]\\
\text{(17)}\quad & E\big(\varepsilon_t\,\phi_1(y_{t-1}-\mu)\big)=0 && [(8)]\\
\text{(18)}\quad & E(\varepsilon_t^2)=\sigma^2 && [(7)]\\
\text{(19)}\quad & E(\varepsilon_t\,\theta_1\varepsilon_{t-1})=0 && [\text{RB}]\\
\text{(20)}\quad & E\big(\theta_1\varepsilon_{t-1}\,\phi_1(y_{t-1}-\mu)\big)=\theta_1\phi_1\sigma^2 && [(10)\text{ em } t-1]\\
\text{(21)}\quad & E(\theta_1\varepsilon_{t-1}\,\varepsilon_t)=0 && [\text{RB}]\\
\text{(22)}\quad & E(\theta_1^2\varepsilon_{t-1}^2)=\theta_1^2\sigma^2 && [\text{RB}]
\end{aligned}
$$

Somando (14)–(22): os termos (16) e (20) são iguais e dão $2\theta_1\phi_1\sigma^2$; os quatro zeros somem.

$$
\begin{aligned}
\text{(23)}\quad & \gamma_0=\phi_1^2\gamma_0+2\theta_1\phi_1\sigma^2+\sigma^2+\theta_1^2\sigma^2 && [(14)\text{–}(22)]\\
\text{(24)}\quad & \gamma_0-\phi_1^2\gamma_0=\sigma^2(2\theta_1\phi_1+1+\theta_1^2) && [\text{passa } \phi_1^2\gamma_0]\\
\text{(25)}\quad & \gamma_0\,(1-\phi_1^2)=\sigma^2(2\theta_1\phi_1+1+\theta_1^2) && [\text{evidência}]
\end{aligned}
$$

$$
\text{(26)}\qquad \boxed{\gamma_0=\frac{\sigma^2(2\theta_1\phi_1+1+\theta_1^2)}{1-\phi_1^2}}\qquad[\,1-\phi_1^2\ne0 \text{ porque } \lvert\phi_1\rvert\lt1\,]
$$

É a forma da AU02, p. 83. **Atenção ao erro do caderno:** é $\theta_1^2$, ao quadrado, no numerador.

**$\gamma_k$, equação geral** (AU02, p. 84). Multiplique (6) por $(y_{t-k}-\mu)$ e tire a esperança:

$$
\text{(27)}\qquad \underbrace{E\big((y_t-\mu)(y_{t-k}-\mu)\big)}_{\gamma_k}=\phi_1\underbrace{E\big((y_{t-1}-\mu)(y_{t-k}-\mu)\big)}_{\gamma_{k-1}}+E\big(\varepsilon_t(y_{t-k}-\mu)\big)+\theta_1E\big(\varepsilon_{t-1}(y_{t-k}-\mu)\big)
$$

**$k=1$:**

$$
\begin{aligned}
\text{(28)}\quad & \gamma_1=\phi_1E\big((y_{t-1}-\mu)^2\big)+E\big(\varepsilon_t(y_{t-1}-\mu)\big)+\theta_1E\big(\varepsilon_{t-1}(y_{t-1}-\mu)\big) && [(27),\ k=1]\\
\text{(29)}\quad & \phantom{\gamma_1}=\phi_1\gamma_0+0+\theta_1\sigma^2 && [\text{estac., }(8),\ (10)]
\end{aligned}
$$

Substituindo (26) em (29), com tudo sobre o denominador $1-\phi_1^2$:

$$
\begin{aligned}
\text{(30)}\quad & \gamma_1=\frac{\phi_1(1+2\phi_1\theta_1+\theta_1^2)+\theta_1(1-\phi_1^2)}{1-\phi_1^2}\,\sigma^2 && [(26)]\\
\text{(31)}\quad & \phantom{\gamma_1}=\frac{\phi_1+2\phi_1^2\theta_1+\phi_1\theta_1^2+\theta_1-\phi_1^2\theta_1}{1-\phi_1^2}\,\sigma^2 && [\text{distributiva}]\\
\text{(32)}\quad & \phantom{\gamma_1}=\frac{\phi_1+\theta_1+\phi_1^2\theta_1+\phi_1\theta_1^2}{1-\phi_1^2}\,\sigma^2 && [2\phi_1^2\theta_1-\phi_1^2\theta_1]
\end{aligned}
$$

**Fatoração do numerador**, conferida por expansão: $(1+\phi_1\theta_1)(\phi_1+\theta_1)=\phi_1+\theta_1+\phi_1^2\theta_1+\phi_1\theta_1^2$ ✓. Logo:

$$
\text{(33)}\qquad \boxed{\gamma_1=\phi_1\gamma_0+\theta_1\sigma^2=\frac{(1+\phi_1\theta_1)(\phi_1+\theta_1)}{1-\phi_1^2}\,\sigma^2}
$$

**$k\ge2$:** em (27), os dois últimos termos são zero por (8):
- $E\big(\varepsilon_t(y_{t-k}-\mu)\big)=0$, porque $k\ge1$;
- $E\big(\varepsilon_{t-1}(y_{t-k}-\mu)\big)=0$, porque a distância entre $t-1$ e $t-k$ é $k-1\ge1$.

Sobra $\gamma_k=\phi_1\gamma_{k-1}$. **Indução:**
- base, $k=2$: $\gamma_2=\phi_1\gamma_1$;
- passo: se $\gamma_{k-1}=\phi_1^{k-2}\gamma_1$, então $\gamma_k=\phi_1\cdot\phi_1^{k-2}\gamma_1=\phi_1^{k-1}\gamma_1$.

$$
\text{(34)}\qquad \boxed{\gamma_k=\phi_1\,\gamma_{k-1}=\phi_1^{\,k-1}\gamma_1\quad(k\ge2)}
$$

**Atenção ao erro do caderno:** o expoente é $k-1$, não $k$. Confira com $k=2$: um único $\phi_1$.
## (b) FAC

$$
\begin{aligned}
\text{(35)}\quad & \rho_1=\frac{\gamma_1}{\gamma_0}=\frac{(1+\phi_1\theta_1)(\phi_1+\theta_1)\sigma^2/(1-\phi_1^2)}{(1+2\phi_1\theta_1+\theta_1^2)\sigma^2/(1-\phi_1^2)} && [(33),(26)]\\
\text{(36)}\quad & \phantom{\rho_1}=\frac{(1+\phi_1\theta_1)(\phi_1+\theta_1)}{1+2\phi_1\theta_1+\theta_1^2} && [\text{cancela } \sigma^2 \text{ e } 1-\phi_1^2]
\end{aligned}
$$

**$\rho_k=\phi_1^{k-1}\rho_1$ por indução**, dividindo (34) por $\gamma_0$:
- **base, $k=1$:** $\phi_1^{0}\rho_1=\rho_1$ ✓;
- **passo:** se $\rho_{k-1}=\phi_1^{k-2}\rho_1$, então $\rho_k=\frac{\gamma_k}{\gamma_0}=\frac{\phi_1\gamma_{k-1}}{\gamma_0}=\phi_1\rho_{k-1}=\phi_1\cdot\phi_1^{k-2}\rho_1=\phi_1^{k-1}\rho_1$ ✓.

$$
\text{(37)}\qquad \boxed{\rho_k=\phi_1^{\,k-1}\rho_1\quad(k\ge1)}
$$

**Conclusão:** a FAC decai geometricamente, à taxa $\phi_1$, mas **a partir de $\rho_1$, e não de 1**. O MA só altera o primeiro valor.

## (c) MA($\infty$), AR($\infty$) e a velocidade de convergência

Como na lista, $c=0$: então $\mu=0$ e $y_t-\mu=y_t$. Com constante, troque cada $y$ por $y-\mu$, pela forma em desvios (6).

**MA($\infty$), caminho 1 — substituição recursiva.**

$$
\begin{aligned}
\text{(38)}\quad & y_t=\phi_1y_{t-1}+\varepsilon_t+\theta_1\varepsilon_{t-1} && [\text{modelo}]\\
\text{(39)}\quad & \phantom{y_t}=\phi_1(\phi_1y_{t-2}+\varepsilon_{t-1}+\theta_1\varepsilon_{t-2})+\varepsilon_t+\theta_1\varepsilon_{t-1} && [\text{modelo em } t-1]\\
\text{(40)}\quad & \phantom{y_t}=\varepsilon_t+(\phi_1+\theta_1)\varepsilon_{t-1}+\phi_1\theta_1\varepsilon_{t-2}+\phi_1^2y_{t-2} && [\text{agrupando}]\\
\text{(41)}\quad & \phantom{y_t}=\varepsilon_t+(\phi_1+\theta_1)\varepsilon_{t-1}+\phi_1(\phi_1+\theta_1)\varepsilon_{t-2}+\phi_1^2\theta_1\varepsilon_{t-3}+\phi_1^3y_{t-3} && [\text{modelo em } t-2]
\end{aligned}
$$

Em (41), o coeficiente de $\varepsilon_{t-2}$ é $\phi_1\theta_1+\phi_1^2=\phi_1(\phi_1+\theta_1)$. O padrão: o coeficiente de $\varepsilon_{t-j}$, $j\ge1$, é $(\phi_1+\theta_1)\phi_1^{j-1}$. Depois de $n$ substituições, o resto é $\phi_1^{n-1}\theta_1\varepsilon_{t-n}+\phi_1^{n}y_{t-n}$. Ele vai a zero em média quadrática, porque $E(\phi_1^{2n}y_{t-n}^2)=\phi_1^{2n}\gamma_0\to0$ quando $\lvert\phi_1\rvert\lt1$.

**MA($\infty$), caminho 2 — igualdade de coeficientes.** $\Psi(L)=\frac{1+\theta_1L}{1-\phi_1L}$ significa $\Psi(L)(1-\phi_1L)=1+\theta_1L$. Expandindo o lado esquerdo:

$$
(1+\psi_1L+\psi_2L^2+\cdots)(1-\phi_1L)=1+(\psi_1-\phi_1)L+(\psi_2-\phi_1\psi_1)L^2+\cdots+(\psi_j-\phi_1\psi_{j-1})L^j+\cdots
$$

Igualando com $1+\theta_1L$, potência por potência:
- $L^1$: $\psi_1-\phi_1=\theta_1$, logo $\psi_1=\phi_1+\theta_1$;
- $L^j$, $j\ge2$: $\psi_j-\phi_1\psi_{j-1}=0$, logo $\psi_j=\phi_1\psi_{j-1}$.

$$
\text{(42)}\qquad \boxed{\psi_0=1,\quad \psi_j=(\phi_1+\theta_1)\,\phi_1^{\,j-1}\ (j\ge1)}\qquad y_t=\varepsilon_t+(\phi_1+\theta_1)\sum_{j\ge1}\phi_1^{\,j-1}\varepsilon_{t-j}
$$

**AR($\infty$).** $\pi(L)=\frac{1-\phi_1L}{1+\theta_1L}$, com $\pi(L)=1-\pi_1L-\pi_2L^2-\cdots$ (AU02, p. 19).
- Pela série geométrica com razão $-\theta_1L$, válida porque $\lvert\theta_1\rvert\lt1$: $(1+\theta_1L)^{-1}=\sum_{j\ge0}(-\theta_1)^jL^j$.
- Multiplicando por $(1-\phi_1L)$, o coeficiente de $L^j$, $j\ge1$, é

$$
(-\theta_1)^j-\phi_1(-\theta_1)^{j-1}=(-\theta_1)^{j-1}(-\theta_1-\phi_1)=-(\phi_1+\theta_1)(-\theta_1)^{j-1}.
$$

- Comparando com $-\pi_j$:

$$
\text{(43)}\qquad \boxed{\pi_j=(\phi_1+\theta_1)\,(-\theta_1)^{\,j-1}\ (j\ge1)}\qquad y_t=\sum_{j\ge1}\pi_j\,y_{t-j}+\varepsilon_t
$$

**Quando cada série converge.**
- $\sum_j\lvert\psi_j\rvert=1+\lvert\phi_1+\theta_1\rvert\sum_{j\ge1}\lvert\phi_1\rvert^{j-1}=1+\frac{\lvert\phi_1+\theta_1\rvert}{1-\lvert\phi_1\rvert}\lt\infty\iff\lvert\phi_1\rvert\lt1$, que é a **estacionariedade**.
- $\sum_j\lvert\pi_j\rvert=\frac{\lvert\phi_1+\theta_1\rvert}{1-\lvert\theta_1\rvert}\lt\infty\iff\lvert\theta_1\rvert\lt1$, que é a **invertibilidade**.

**Quando a convergência é mais lenta.** Os $\lvert\psi_j\rvert$ encolhem por um fator $\lvert\phi_1\rvert$ a cada período. A **meia-vida**, o número de períodos para um peso cair à metade, resolve $\lvert\phi_1\rvert^{h}=\frac12$:

$$
h=\frac{\ln0{,}5}{\ln\lvert\phi_1\rvert}:\qquad \phi_1=0{,}5\Rightarrow h=1;\qquad \phi_1=0{,}9\Rightarrow h=6{,}58;\qquad \phi_1=0{,}99\Rightarrow h=68{,}97 .
$$

- **MA($\infty$) mais lento quando $\lvert\phi_1\rvert\to1$**: perto da raiz unitária, os choques demoram a morrer.
- **AR($\infty$) mais lento quando $\lvert\theta_1\rvert\to1$**: perto da não invertibilidade, é preciso muito passado de $y$ para recuperar $\varepsilon_t$.
- **Caso extremo, $\phi_1=-\theta_1$:** $\psi_j=\pi_j=0$ para $j\ge1$, e $y_t=\varepsilon_t$. Os fatores se cancelam: é um fator comum.

## De volta ao sinal da lista ($\theta_1=-\theta$)

| | Slides | Lista |
|---|---|---|
| $\gamma_0$ | $\frac{1+2\phi_1\theta_1+\theta_1^2}{1-\phi_1^2}\sigma^2$ | $\frac{1-2\phi\theta+\theta^2}{1-\phi^2}\sigma_a^2$ |
| $\gamma_1$ | $\frac{(1+\phi_1\theta_1)(\phi_1+\theta_1)}{1-\phi_1^2}\sigma^2$ | $\frac{(1-\phi\theta)(\phi-\theta)}{1-\phi^2}\sigma_a^2$ |
| $\rho_1$ | $\frac{(1+\phi_1\theta_1)(\phi_1+\theta_1)}{1+2\phi_1\theta_1+\theta_1^2}$ | $\frac{(1-\phi\theta)(\phi-\theta)}{1-2\phi\theta+\theta^2}$ |
| $\rho_k$ | $\phi_1^{k-1}\rho_1$ | $\phi^{k-1}\rho_1$ |
| $\psi_j$ | $(\phi_1+\theta_1)\phi_1^{j-1}$ | $(\phi-\theta)\phi^{j-1}$ |
| $\pi_j$ | $(\phi_1+\theta_1)(-\theta_1)^{j-1}$ | $(\phi-\theta)\theta^{j-1}$ |

## Versão para a prova (Q6)

1. Convenção: sinais dos slides, $\theta_1=-\theta$.
2. $\mu=\frac{c}{1-\phi_1}$ e a forma em desvios $y_t-\mu=\phi_1(y_{t-1}-\mu)+\varepsilon_t+\theta_1\varepsilon_{t-1}$ (na lista, $c=0$).
3. Momentos auxiliares: $E(\varepsilon_t\varepsilon_t)=\sigma^2$; $E\big((y_{t-k}-\mu)\varepsilon_t\big)=0$ para $k\ge1$; $E\big((y_t-\mu)\varepsilon_t\big)=\sigma^2$; $E\big((y_{t+1}-\mu)\varepsilon_t\big)=(\phi_1+\theta_1)\sigma^2$.
4. $\gamma_0=E\big((\phi_1(y_{t-1}-\mu)+\varepsilon_t+\theta_1\varepsilon_{t-1})^2\big)$: nove termos, quatro zeros, $\gamma_0=\phi_1^2\gamma_0+2\theta_1\phi_1\sigma^2+\sigma^2+\theta_1^2\sigma^2$, logo $\gamma_0=\frac{\sigma^2(2\theta_1\phi_1+1+\theta_1^2)}{1-\phi_1^2}$.
5. $\gamma_1=\phi_1\gamma_0+\theta_1\sigma^2=\frac{(1+\phi_1\theta_1)(\phi_1+\theta_1)}{1-\phi_1^2}\sigma^2$.
6. $k\ge2$: $\gamma_k=\phi_1\gamma_{k-1}$, porque os dois choques do modelo são posteriores a $y_{t-k}$.
7. $\rho_1=\gamma_1/\gamma_0$; $\rho_k=\phi_1\rho_{k-1}=\phi_1^{k-1}\rho_1$ (indução).
8. $\Psi(L)(1-\phi_1L)=1+\theta_1L$ dá $\psi_j=(\phi_1+\theta_1)\phi_1^{j-1}$, que converge se $\lvert\phi_1\rvert\lt1$.
9. $\pi(L)(1+\theta_1L)=1-\phi_1L$ dá $\pi_j=(\phi_1+\theta_1)(-\theta_1)^{j-1}$, que converge se $\lvert\theta_1\rvert\lt1$.
10. Mais lento: $\lvert\phi_1\rvert\to1$ para os $\psi$ e $\lvert\theta_1\rvert\to1$ para os $\pi$. Meia-vida $\ln0{,}5/\ln\lvert\phi_1\rvert$.
11. Traduzir para a lista com $\theta_1=-\theta$.

## Conferência (Q6)

Com $\phi_1=0{,}7$, $\theta_1=-0{,}4$ (isto é, $\theta^{\text{lista}}=0{,}4$) e $\sigma^2=1$:
- $\gamma_0=\frac{1-0{,}56+0{,}16}{0{,}51}=1{,}1765$;
- $\gamma_1=0{,}7(1{,}1765)-0{,}4=0{,}4235$;
- $\rho_1=0{,}36$ e $\rho_2=0{,}252$;
- $\psi_1,\psi_2,\psi_3=0{,}3;\ 0{,}21;\ 0{,}147$ e $\pi_1,\pi_2,\pi_3=0{,}3;\ 0{,}12;\ 0{,}048$.

A substituição recursiva (42) e a fórmula (43) coincidem com o `ARMAtoMA` do R, com diferença zero.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| lc_am_q2_ey1 | 1,2 |
| lc_am_q2_ey2 | 2,6 |
| lc_am_q2_ey3 | 4,2 |
| lc_am_q2_dif_formula | 0 |
| lc_am_q2_var3 | 2,99 |
| lc_am_q2_cov31 | 1,00 |
| lc_am_q2_corr31 | 0,58 |
| lc_am_q2_corr31_formula | 0,577 |
| lc_am_q6_meiavida_05 | 1 |
| lc_am_q6_meiavida_09 | 6,58 |
| lc_am_q6_meiavida_099 | 68,97 |
| lc_q6_g0 | 1,1765 |
| lc_q6_g1 | 0,4235 |
| lc_q6_rho1 | 0,36 |
| lc_q6_rho2 | 0,252 |
| lc_q6_psi1 | 0,3 |
| lc_q6_psi2 | 0,21 |
| lc_q6_psi3 | 0,147 |
| lc_q6_pi1 | 0,3 |
| lc_q6_pi2 | 0,12 |
| lc_q6_pi3 | 0,048 |
| lc_am_q6_dif_psi | 0 |
| lc_am_q6_dif_pi | 0 |
-->
