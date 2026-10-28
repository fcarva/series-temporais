---
title: "Apostila, cap. 5 — Previsão: o elástico e o leque"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: [15]
aulas: "AU02 p. 44, 54–57, 72–76, 85; AU03 p. 32–41"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Apostila cap. 5 — Previsão
---

# Capítulo 5 · Previsão: o elástico e o leque

[← apostila](README.md) · anterior: [cap. 4](cap4_estimacao_selecao.md) · próximo: [cap. 6](cap6_aplicacao.md) · questão da lista: Q15

## Pergunta de abertura

A previsão do tempo para amanhã usa a frente fria que está chegando. A previsão para daqui a 40 dias é praticamente a **média histórica** daquele dia do ano. **Por que a informação de hoje "se gasta" com o horizonte?** E outra pergunta, mais de fundo: entre todas as regras possíveis para prever, por que a escolhida é **a média condicional**, e não, por exemplo, o valor mais provável ou a mediana?

A AU02 trata a previsão em três lugares: MA (p. 54–57), AR (p. 72–76) e ARMA(1,1) (p. 85). As três seguem o mesmo roteiro:
1. escrever o modelo na data futura;
2. tirar a esperança condicional ao que se sabe hoje, $\Omega_T$;
3. medir o erro.

Este capítulo mostra **por que** o roteiro é esse e o que ele implica.

## A imagem

**A previsão de um AR estacionário é um elástico preso na média.** Hoje a série está longe da média $\mu$. A previsão para amanhã puxa uma fração $1-\phi_1$ do caminho de volta; a de depois de amanhã puxa de novo; e assim por diante. O elástico nunca passa do ponto, se $\phi_1\gt0$, e a previsão converge para $\mu$ geometricamente: $\widehat y_{T+h/T}-\mu=\phi_1^h(y_T-\mu)$.

**A incerteza é um leque que abre e para de abrir.**
- No horizonte 1, a única coisa que você não sabe é o choque de amanhã: a variância do erro é $\sigma^2$.
- A cada passo, entra um choque novo, multiplicado pelo peso $\psi_j$ correspondente. O leque abre.
- Num processo estacionário, os $\psi_j$ encolhem, e o leque **para de abrir** em $\gamma_0$, a variância incondicional: o horizonte infinito é a "climatologia".
- Num processo I(1), os pesos não encolhem, e o leque abre **para sempre**.

**O MA($q$) é uma memória de $q$ dias.** Depois de $q$ passos, nenhum choque que você conhece afeta mais o futuro, e a melhor previsão é a média (AU02, p. 55).

**O ARIMA(0,1,1) é um termômetro com inércia.** A previsão é uma média das observações passadas com pesos que decaem geometricamente, $\alpha,\ \alpha(1-\alpha),\ \alpha(1-\alpha)^2,\dots$: o "esquecimento exponencial". É a suavização exponencial simples, vista como um modelo.

> [!WARNING]
> **Onde a analogia quebra**
> - **O elástico puxa a previsão, não a série.** A trajetória realizada não volta suavemente para $\mu$: ela continua levando choques e oscilando. Quem desliza suavemente para a média é a **esperança condicional**.
> - **Com $\phi_1\lt0$, o elástico passa do ponto a cada período.** A previsão oscila em torno de $\mu$ enquanto converge.
> - **O leque das fórmulas é estreito demais.** $\sigma^2\sum\psi_j^2$ supõe que os parâmetros são conhecidos. Com parâmetros estimados, há uma incerteza extra, e os intervalos reais são mais largos. A normalidade dos erros também é uma hipótese, que a AU03 manda testar.

## Teoria

**Elementos da previsão** (AU02, p. 54 e 72; AU03, p. 39–40): a origem $T$, a informação $\Omega_T=\{y_T,y_{T-1},\dots\}$, o horizonte $h$, e

$$
\widehat y_{T+h/T}=E(y_{T+h}\mid\Omega_T),\qquad e_{T+h/T}=y_{T+h}-\widehat y_{T+h/T} .
$$

**As três regras da esperança condicional** (AU02, p. 54–55 e 72–73):
- o que já foi observado sai como está: $E(y_{T-j}\mid\Omega_T)=y_{T-j}$ e $E(\varepsilon_{T-j}\mid\Omega_T)=\varepsilon_{T-j}$ para $j\ge0$;
- choque futuro vira zero: $E(\varepsilon_{T+j}\mid\Omega_T)=0$ para $j\ge1$;
- valor futuro vira a previsão dele: $E(y_{T+j}\mid\Omega_T)=\widehat y_{T+j/T}$.

**MA($q$)** (AU02, p. 54–57): $\widehat y_{T+h/T}=\mu$ para $h\gt q$. No MA(1), o EQM é $\sigma^2$ em $h=1$ e $(1+\theta_1^2)\sigma^2$ em $h\ge2$.

**AR(1)** (AU02, p. 72–76):
- $\widehat y_{T+h/T}=\mu+\phi_1^h(y_T-\mu)$: a previsão volta à média geometricamente, à taxa $\phi_1$ por passo;
- $e_{T+h/T}=\sum_{j=0}^{h-1}\phi_1^j\varepsilon_{T+h-j}$;
- $\operatorname{Var}(e_{T+h/T})=\sigma^2\frac{1-\phi_1^{2h}}{1-\phi_1^2}\to\frac{\sigma^2}{1-\phi_1^2}=\gamma_0$.

**Caso geral pelos pesos $\psi$** (lista, Q15c). Com $y_t=\mu+\sum_{j\ge0}\psi_j\varepsilon_{t-j}$:

$$
e_{T+h/T}=\sum_{j=0}^{h-1}\psi_j\,\varepsilon_{T+h-j}\quad(\text{um MA}(h-1)),\qquad \operatorname{Var}(e_{T+h/T})=\sigma^2\sum_{j=0}^{h-1}\psi_j^2 .
$$

**Intervalo de previsão** (AU02, p. 56 e 74), com erros gaussianos: $\widehat y_{T+h/T}\pm z_{\alpha/2}\sqrt{\operatorname{Var}(e_{T+h/T})}$. A 95%, $z=1{,}96$.

**ARIMA e longo prazo.** Para $h\gt q$, as previsões obedecem à parte autorregressiva generalizada, $\phi(L)(1-L)^d\,\widehat y_{T+h/T}=0$ (BJRL, cap. 5). Com $d=1$ e sem AR, a previsão fica **plana**. No ARIMA(0,1,1), ela é a suavização exponencial.

**Iterada × direta** (AU03, p. 41):
- a **iterada** usa o modelo de um passo recursivamente, como em todas as fórmulas acima;
- a **direta** estima um modelo diferente para cada horizonte.

Na prova teórica, a iterada é a que se deriva.

## Demonstrações

### D5.1 · O previsor de mínimo EQM é a esperança condicional (Q15a)

Seja $g$ qualquer previsor construído com $\Omega_T$, e $m=E(y_{T+h}\mid\Omega_T)$. Para encurtar, escreva $y\equiv y_{T+h}$, $E_T(\cdot)\equiv E(\cdot\mid\Omega_T)$ e $\operatorname{Var}_T(\cdot)\equiv\operatorname{Var}(\cdot\mid\Omega_T)$.

$$
\begin{aligned}
\text{(1)}\quad & E_T\big((y-g)^2\big)=E_T\big((y-m+m-g)^2\big) && [\text{soma e subtrai } m]\\
\text{(2)}\quad & \phantom{E}=E_T\big((y-m)^2\big)+2E_T\big((y-m)(m-g)\big)+E_T\big((m-g)^2\big) && [\text{quadrado, F4}]\\
\text{(3)}\quad & E_T\big((y-m)(m-g)\big)=(m-g)\,E_T\big(y-m\big) && [m-g \text{ é conhecido em } T]\\
\text{(4)}\quad & E_T\big(y-m\big)=m-m=0 && [\text{definição de } m]\\
\text{(5)}\quad & E_T\big((m-g)^2\big)=(m-g)^2 && [\text{conhecido em } T]\\
\text{(6)}\quad & E_T\big((y-g)^2\big)=\operatorname{Var}_T(y)+(m-g)^2 && [(2)\text{–}(5)]\\
\text{(7)}\quad & \ge\operatorname{Var}_T(y),\ \text{com igualdade} \iff g=m && [(m-g)^2\ge0]
\end{aligned}
$$

$$
\boxed{\widehat y_{T+h/T}=E(y_{T+h}\mid\Omega_T)\ \text{minimiza o EQM; qualquer outro previsor paga } (m-g)^2 \text{ a mais}}
$$

O critério é que decide: com perda quadrática, é a média. Com perda absoluta, $\lvert y-g\rvert$, seria a mediana condicional. Sob normalidade, as duas coincidem.

### D5.2 · ARMA(1,1): $\widehat y_{T+1/T}$ e $\widehat y_{T+2/T}$ (Q15b)

Modelo: $y_t=c+\phi_1y_{t-1}+\varepsilon_t+\theta_1\varepsilon_{t-1}$ (AU02, p. 85).

$$
\begin{aligned}
\text{(1)}\quad & y_{T+1}=c+\phi_1y_T+\varepsilon_{T+1}+\theta_1\varepsilon_T && [\text{modelo em } T+1]\\
\text{(2)}\quad & \widehat y_{T+1/T}=c+\phi_1y_T+0+\theta_1\varepsilon_T && [\text{regras: conhecido fica, futuro} \to 0]\\
\text{(3)}\quad & y_{T+2}=c+\phi_1y_{T+1}+\varepsilon_{T+2}+\theta_1\varepsilon_{T+1} && [\text{modelo em } T+2]\\
\text{(4)}\quad & \widehat y_{T+2/T}=c+\phi_1\widehat y_{T+1/T}+0+0 && [y_{T+1}\to\text{previsão}; \text{ os dois choques são futuros}]\\
\text{(5)}\quad & \widehat y_{T+h/T}=c+\phi_1\widehat y_{T+h-1/T},\quad h\ge2 && [\text{mesma conta}]\\
\text{(6)}\quad & \widehat y_{T+h/T}-\mu=\phi_1^{\,h-1}\big(\widehat y_{T+1/T}-\mu\big)\to0 && [c=(1-\phi_1)\mu;\ \lvert\phi_1\rvert\lt1]
\end{aligned}
$$

$$
\boxed{\widehat y_{T+1/T}=c+\phi_1y_T+\theta_1\varepsilon_T,\qquad \widehat y_{T+2/T}=c+\phi_1\widehat y_{T+1/T}}
$$

O MA só aparece no primeiro passo, através de $\varepsilon_T$, que é conhecido em $T$ porque o processo é **invertível**. Na lista, $\theta_1=-\theta$: $\widehat y_{T+1\mid T}=\phi y_T-\theta a_T$, com média zero.

### D5.3 · O erro de previsão é um MA($h-1$), e sua variância (Q15c)

$$
\begin{aligned}
\text{(1)}\quad & y_{T+h}=\mu+\sum_{j=0}^{h-1}\psi_j\varepsilon_{T+h-j}+\sum_{j\ge h}\psi_j\varepsilon_{T+h-j} && [\text{Wold, separa futuro e passado}]\\
\text{(2)}\quad & \widehat y_{T+h/T}=\mu+0+\sum_{j\ge h}\psi_j\varepsilon_{T+h-j} && [\text{futuro} \to 0;\ \text{passado conhecido, invertível}]\\
\text{(3)}\quad & e_{T+h/T}=y_{T+h}-\widehat y_{T+h/T}=\sum_{j=0}^{h-1}\psi_j\varepsilon_{T+h-j} && [(1)-(2)]\\
\text{(4)}\quad & E(e_{T+h/T}\mid\Omega_T)=\sum_{j=0}^{h-1}\psi_jE(\varepsilon_{T+h-j})=0 && [\text{F4, soma finita; RB}]\\
\text{(5)}\quad & \operatorname{Var}(e_{T+h/T})=E\Big(\Big(\sum_{j=0}^{h-1}\psi_j\varepsilon_{T+h-j}\Big)^2\Big)=\sigma^2\sum_{j=0}^{h-1}\psi_j^2 && [\text{RB: só termos quadrados}]\\
\text{(6)}\quad & \operatorname{Var}(e_{T+h/T})\to\sigma^2\sum_{j\ge0}\psi_j^2=\gamma_0 && [h\to\infty;\ \text{cap. 1, D1.3}]
\end{aligned}
$$

$$
\boxed{e_{T+h/T}=\sum_{j=0}^{h-1}\psi_j\varepsilon_{T+h-j}\ \ (\text{MA}(h-1)),\qquad \operatorname{Var}=\sigma^2\sum_{j=0}^{h-1}\psi_j^2\ \uparrow\ \gamma_0}
$$

**Intervalo de 95%** (Q15d): $\widehat y_{T+h/T}\pm1{,}96\,\sigma\sqrt{\sum_{j=0}^{h-1}\psi_j^2}$. Um detalhe que cai em prova: os erros de **horizontes diferentes** são correlacionados. $e_{T+1}$ e $e_{T+2}$ dividem o choque $\varepsilon_{T+1}$.

### D5.4 · ARIMA(0,1,1) é suavização exponencial (Q15e)

Nos slides, $\Delta y_t=\varepsilon_t+\theta_1\varepsilon_{t-1}$; na lista, $\theta_1=-\theta$, com $0\lt\theta\lt1$.

$$
\begin{aligned}
\text{(1)}\quad & y_{T+1}=y_T+\varepsilon_{T+1}+\theta_1\varepsilon_T && [\text{modelo em } T+1]\\
\text{(2)}\quad & \widehat y_{T+1/T}=y_T+\theta_1\varepsilon_T && [\text{futuro} \to 0]\\
\text{(3)}\quad & \varepsilon_T=y_T-\widehat y_{T/T-1} && [\text{o choque é o erro de um passo}]\\
\text{(4)}\quad & \widehat y_{T+1/T}=y_T+\theta_1(y_T-\widehat y_{T/T-1})=(1+\theta_1)\,y_T-\theta_1\,\widehat y_{T/T-1} && [(3)\text{ em }(2)]\\
\text{(5)}\quad & \alpha\equiv1+\theta_1=1-\theta:\quad \widehat y_{T+1/T}=\alpha\,y_T+(1-\alpha)\,\widehat y_{T/T-1} && [\text{lista: } \theta_1=-\theta]\\
\text{(6)}\quad & \widehat y_{T+1/T}=\alpha\sum_{j\ge0}(1-\alpha)^j\,y_{T-j} && [(5) \text{ iterada; } 0\lt1-\alpha\lt1]\\
\text{(7)}\quad & \widehat y_{T+h/T}=\widehat y_{T+h-1/T}=\cdots=\widehat y_{T+1/T},\quad h\ge2 && [\varepsilon_{T+1},\varepsilon_{T+2},\ldots \text{ futuros}]
\end{aligned}
$$

$$
\boxed{\widehat y_{T+h/T}=\alpha\sum_{j\ge0}(1-\alpha)^jy_{T-j}\ \text{para todo } h\ge1,\qquad \alpha=1-\theta=1+\theta_1}
$$

A previsão de longo prazo é **constante**: o nível suavizado de hoje. A constante de suavização é $\alpha=1-\theta$. Quanto maior o $\theta$ da lista, menor o $\alpha$, e mais a previsão "lembra" do passado distante. Os pesos de (6) somam 1, porque $\alpha\sum(1-\alpha)^j=\alpha\cdot\frac{1}{\alpha}=1$ (F2).

## Exemplo

**1. AR(1)** com $\mu=10$, $\phi_1=0{,}8$, $\sigma^2=1$, e a última observação $y_T=14$:

| $h$ | $\widehat y_{T+h/T}$ | $\operatorname{Var}(e)$ | intervalo de 95% |
|---|---|---|---|
| 1 | 13,2 | 1 | [11,24; 15,16] |
| 2 | 12,56 | 1,64 | |
| 3 | 12,048 | 2,0496 | |
| $\infty$ | 10 | 2,7778 | $10\pm3{,}267$ |

- O elástico puxa 20% do desvio por período: $4\to3{,}2\to2{,}56\to2{,}048$. A meia-vida do desvio é de 3,11 períodos.
- O leque abre de 1 para 1,64 e 2,05 e para em $\gamma_0=2{,}78$.

**2. ARMA(1,1)** da AU02, p. 86 ($\phi_1=0{,}8$, $\theta_1=0{,}6$, $\mu=0$), com $y_T=2$ e $\varepsilon_T=0{,}5$:
- $\widehat y_{T+1/T}=0{,}8(2)+0{,}6(0{,}5)=1{,}9$;
- $\widehat y_{T+2/T}=0{,}8(1{,}9)=1{,}52$.

Com $\psi=(1;\ 1{,}4;\ 1{,}12)$, a variância do erro é 1, depois $1+1{,}96=2{,}96$, depois 4,2144. O leque abre mais rápido que no AR(1), porque $\psi_1=1{,}4\gt1$.

**3. Suavização exponencial**, com $\theta^{\text{lista}}=0{,}6$:
- $\alpha=0{,}4$;
- os pesos de $y_T,y_{T-1},y_{T-2}$ são 0,4; 0,24; 0,144.

Numa série simulada de 300 observações, a recursão (5) e o `predict` do ARIMA(0,1,1) do R dão a mesma previsão, com diferença zero, e a previsão de 3 passos é igual à de 1: plana.

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
| ap_c5_ar_icinf_meia | 3,267 |
| ap_c5_ar_meiavida | 3,11 |
| ap_c5_arma_prev1 | 1,9 |
| ap_c5_arma_prev2 | 1,52 |
| ap_c5_arma_var2 | 2,96 |
| ap_c5_arma_var3 | 4,2144 |
| ap_c5_ses_alpha | 0,4 |
| ap_c5_ses_w0 | 0,4 |
| ap_c5_ses_w1 | 0,24 |
| ap_c5_ses_w2 | 0,144 |
| ap_c5_ses_dif | 0 |
| ap_c5_ses_plano | 0 |
-->

## Avaliar previsões

A Q15 pergunta como prever. A AU03, p. 32–60, completa com a pergunta seguinte: **como saber se a previsão foi boa**, e se um modelo prevê melhor que outro. Nada disso é cobrado diretamente na lista, mas é o fecho natural do bloco e cai bem como item de discussão.

**Treino, teste e janelas** (AU03, p. 32–38). A amostra é dividida:
- um trecho de **treino**, para estimar;
- um trecho de **teste**, para medir os erros fora da amostra, que é o único lugar onde o erro de previsão é honesto.

Ao avançar a origem da previsão, há três esquemas:
- **janela fixa**: estima uma vez, no treino original, e só prevê;
- **janela recursiva**, ou expansiva: reestima a cada origem com todos os dados até ali;
- **janela móvel**, ou deslizante: reestima com as últimas $R$ observações, que é o esquema que se adapta a quebras.

A AU03, p. 37–38, ressalta que essa escolha, o horizonte e a forma de prever (iterada ou direta) são três decisões independentes.

### DA5.1 · Iterada × direta: quando a direta ganha (AU03, p. 41–44)

A **iterada** estima o modelo de um passo e o aplica $h$ vezes. A **direta** regride $y_{t+h}$ diretamente em $y_t$, um modelo por horizonte. No AR(1) de média zero, a iterada usa $\widehat\phi^{\,h}y_T$, e a direta usa $\widehat b_hy_T$, com $\widehat b_h$ da regressão de $y_{t+h}$ em $y_t$.

$$
\begin{aligned}
\text{(1)}\quad & b_h^{*}=\frac{\operatorname{Cov}(y_{t+h},y_t)}{\operatorname{Var}(y_t)}=\rho_h && [\text{a direta}]\\
\text{(2)}\quad & \operatorname{plim}\widehat\phi=\rho_1\ \Rightarrow\ \text{iterada usa } \rho_1^{\,h} && [\text{MQO do AR(1)}]\\
\text{(3)}\quad & \text{AR(1) verdadeiro: } \rho_h=\phi^h=\rho_1^{\,h}:\ \text{mesmo alvo} && [\text{cap. 2, D2.4}]\\
\text{(4)}\quad & EQM(b)=E\big((y_{T+h}-by_T)^2\big)=\gamma_0\big(1-2b\rho_h+b^2\big) && [\text{F4, estac.}]\\
\text{(5)}\quad & \frac{d\,EQM}{db}=\gamma_0(-2\rho_h+2b)=0\ \Rightarrow\ b=\rho_h && [\text{a direta é a ótima linear}]\\
\text{(6)}\quad & \text{AR(2) verdadeiro, AR(1) ajustado: } \rho_1^{\,h}\ne\rho_h\ \Rightarrow\ EQM_{iter}\gt EQM_{dir} && [(4),(5)]
\end{aligned}
$$

$$
\boxed{\text{modelo certo: iterada (mesmo alvo, menos parâmetros);\quad modelo errado e } h \text{ longo: direta}}
$$

Com o AR(2) do caderno ($\phi_1=1{,}5$, $\phi_2=-0{,}6$) ajustado como AR(1), em $h=5$:
- a iterada usa $\rho_1^5=0{,}9375^5=0{,}7242$, mas o certo é $\rho_5=0{,}3417$;
- o EQM relativo da iterada é $1{,}0295\,\gamma_0$, pior até do que prever a média;
- o da direta é $0{,}8832\,\gamma_0$;
- a direta reduz o RMSE em 7,4%.

### DA5.2 · As métricas de previsão pontual (AU03, p. 45–49)

Com os erros fora da amostra $\widehat e_t=y_t-\widehat y_t$, $t=1,\dots,n$:

$$
\begin{aligned}
\text{(7)}\quad & MAD=\frac1n\textstyle\sum\lvert\widehat e_t\rvert && [\text{na unidade de } y]\\
\text{(8)}\quad & RMSE=\sqrt{\tfrac1n\textstyle\sum\widehat e_t^{\,2}} && [\text{pune erros grandes}]\\
\text{(9)}\quad & MAPE=\frac{100}{n}\textstyle\sum\big\lvert\widehat e_t/y_t\big\rvert && [\text{sem escala; exige } y_t\ne0]\\
\text{(10)}\quad & MASE=\frac{\frac1n\sum\lvert\widehat e_t\rvert}{Q},\quad Q=\frac{1}{T_{tr}-m}\textstyle\sum_{t=m+1}^{T_{tr}}\lvert y_t-y_{t-m}\rvert && [\text{escala do ingênuo no treino}]\\
\text{(11)}\quad & MASE\lt1\iff\text{melhor que o ingênuo} && [(10)]
\end{aligned}
$$

**Exemplo.** São cinco previsões, com reais $(102;98;105;110;107)$ e previstos $(100;101;103;106;109)$; o treino é $(95;97;96;99;101;100)$, com $m=1$.
- $MAD=2{,}6$, $RMSE=2{,}7203$ e $MAPE=2{,}49\%$;
- $Q=1{,}8$, logo $MASE=1{,}44$: o modelo é **pior que o ingênuo**, embora o MAPE pareça baixo.

### DA5.3 · Diebold-Mariano: a diferença é real? (AU03, p. 50–51)

$$
\begin{aligned}
\text{(12)}\quad & d_t=L(e_{1t})-L(e_{2t}),\ \ L(e)=e^2 && [\text{diferencial de perda}]\\
\text{(13)}\quad & H_0:E(d_t)=0\ \ \text{(mesma acurácia)} && [\text{AU03 p. 50}]\\
\text{(14)}\quad & DM=\frac{\bar d}{\sqrt{\widehat V(\bar d)}}\ \xrightarrow{d}\ N(0,1),\quad \widehat V(\bar d)=\frac{\widehat\sigma_d^2}{n} \text{ se } h=1 && [\text{TLC}]\\
\text{(15)}\quad & \text{rejeita } H_0 \text{ a 5\% se } \lvert DM\rvert\gt1{,}96;\ \text{o sinal de } \bar d \text{ diz quem é melhor} && [\text{AU03 p. 51}]
\end{aligned}
$$

Com $h\gt1$, os $d_t$ são autocorrelacionados até a defasagem $h-1$, porque o erro de $h$ passos é um MA($h-1$) (D5.3). Então $\widehat V(\bar d)$ precisa de um estimador robusto, do tipo Newey-West.

**Exemplo** com dez erros de dois modelos: $\bar d=1{,}46$, $\widehat V(\bar d)=0{,}1581$ e $DM=3{,}67\gt1{,}96$. O modelo 2 prevê significativamente melhor.

### DA5.4 · Intervalos e distribuições: Winkler, CRPS e Christoffersen (AU03, p. 52–60)

Na linha (18), $z=(y_t-\mu)/\sigma$, e $\Phi$ e $\varphi$ são a acumulada e a densidade da normal padrão.

$$
\begin{aligned}
\text{(16)}\quad & W_t=(u-\ell)+\tfrac{2}{\alpha}(\ell-y_t)\,\mathbb 1\{y_t\lt\ell\}+\tfrac{2}{\alpha}(y_t-u)\,\mathbb 1\{y_t\gt u\} && [\text{Winkler, AU03 p. 53–55}]\\
\text{(17)}\quad & CRPS_t=\textstyle\int_{-\infty}^{\infty}\big(F_t(x)-\mathbb 1\{x\ge y_t\}\big)^2dx && [\text{AU03 p. 56–58}]\\
\text{(18)}\quad & CRPS=\sigma\Big(z\big(2\Phi(z)-1\big)+2\varphi(z)-\tfrac{1}{\sqrt\pi}\Big) && [F_t=N(\mu,\sigma^2)]\\
\text{(19)}\quad & I_t=\mathbb 1\{y_t\notin[\ell,u]\},\ \ \widehat\pi=\tfrac{n_1}{n};\ \ H_0:E(I_t)=\alpha && [\text{violações, AU03 p. 59}]\\
\text{(20)}\quad & LR_{uc}=-2\ln\big[(1-\alpha)^{n_0}\alpha^{n_1}\big]+2\ln\big[(1-\widehat\pi)^{n_0}\widehat\pi^{\,n_1}\big]\sim\chi^2_1 && [\text{incondicional}]\\
\text{(21)}\quad & LR_{cc}=LR_{uc}+LR_{ind}\sim\chi^2_2 && [\text{AU03 p. 59–60}]
\end{aligned}
$$

$$
\boxed{\begin{gathered}\text{Winkler: largura} + \tfrac{2}{\alpha}\times\text{distância do ponto fora};\quad \text{CRPS: área entre } F_t \text{ e o degrau em } y_t\\ LR_{cc}=LR_{uc}+LR_{ind}\end{gathered}}
$$

**Exemplos:**
- **Winkler**, com $\alpha=0{,}05$ e o intervalo $[8;12]$: $W=4$ se $y=10$ (dentro); $W=24$ se $y=7{,}5$ (meio ponto abaixo); $W=44$ se $y=13$ (um ponto acima). A cobertura que falha custa caro.
- **CRPS** com $y_t=0$: a distribuição larga, $N(0;9)$, dá 0,7011; a deslocada, $N(2;1)$, dá 1,4528; a calibrada e afiada, $N(0;0{,}25)$, dá 0,1168. A fórmula (18) coincide com a integral numérica (17).
- **Christoffersen**, com 100 intervalos de 90% e 15 violações: $LR_{uc}=2{,}45$, $p=0{,}12$. Não se rejeita a cobertura nominal, mas é preciso ainda o teste de independência: violações **agrupadas** reprovam o modelo mesmo com a frequência certa (AU03, p. 60).

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_c5av_rho1 | 0,9375 |
| ap_c5av_rho5 | 0,3417 |
| ap_c5av_rho1_5 | 0,7242 |
| ap_c5av_eqm_iter | 1,0295 |
| ap_c5av_eqm_dir | 0,8832 |
| ap_c5av_ganho | 0,074 |
| ap_c5av_mad | 2,6 |
| ap_c5av_rmse | 2,7203 |
| ap_c5av_mape | 2,49 |
| ap_c5av_q | 1,8 |
| ap_c5av_mase | 1,44 |
| ap_c5av_dbar | 1,46 |
| ap_c5av_vd | 0,1581 |
| ap_c5av_dm | 3,67 |
| ap_c5av_w_dentro | 4 |
| ap_c5av_w_abaixo | 24 |
| ap_c5av_w_acima | 44 |
| ap_c5av_crps_larga | 0,7011 |
| ap_c5av_crps_desloc | 1,4528 |
| ap_c5av_crps_afiada | 0,1168 |
| ap_c5av_crps_dif | 0 |
| ap_c5av_lruc | 2,45 |
| ap_c5av_lruc_p | 0,12 |
-->

## Cadeia socrática

**P1.** Por que $E(\varepsilon_{T+1}\mid\Omega_T)=0$, mas $E(\varepsilon_T\mid\Omega_T)=\varepsilon_T$?

> [!TIP]
> **Resposta**
> $\varepsilon_{T+1}$ é a notícia de amanhã: é RB e não se correlaciona com nada de hoje, então a melhor aposta é a média, zero. $\varepsilon_T$ já aconteceu e, se o modelo é invertível, pode ser calculado a partir de $y_T,y_{T-1},\dots$: é informação, não incerteza.

**P2.** Num MA(2), qual é $\widehat y_{T+3/T}$?

> [!TIP]
> **Resposta**
> $\mu$. $y_{T+3}=\mu+\varepsilon_{T+3}+\theta_1\varepsilon_{T+2}+\theta_2\varepsilon_{T+1}$: os três choques são futuros. A memória de 2 dias acabou (AU02, p. 55).

**P3.** E a variância do erro desse MA(2) no horizonte 3?

> [!TIP]
> **Resposta**
> $(1+\theta_1^2+\theta_2^2)\sigma^2=\gamma_0$. Depois de $q$ passos, o erro de previsão tem toda a variância do processo: você não sabe nada além da média.

**P4.** No AR(1), por que a variância do erro cresce, mas não passa de $\gamma_0$?

> [!TIP]
> **Resposta**
> Cada passo soma um termo $\phi_1^{2j}\sigma^2$, sempre positivo, e por isso ela cresce. Mas os termos encolhem geometricamente, e a soma converge para $\sigma^2/(1-\phi_1^2)=\gamma_0$. No limite, prever é dar a média incondicional, com a incerteza incondicional.

**P5.** E se $\phi_1=1$?

> [!TIP]
> **Resposta**
> Então $\psi_j=1$ para todo $j$, e $\operatorname{Var}(e_{T+h})=h\sigma^2$ cresce sem limite: o leque abre para sempre. A previsão pontual fica em $y_T$, sem drift, e não volta a média nenhuma. É o barco à deriva do cap. 3.

**P6.** Os erros de previsão de 1 e de 2 passos, feitos na mesma origem, são independentes?

> [!TIP]
> **Resposta**
> Não. $e_{T+1}=\varepsilon_{T+1}$ e $e_{T+2}=\varepsilon_{T+2}+\psi_1\varepsilon_{T+1}$ dividem $\varepsilon_{T+1}$: $\operatorname{Cov}=\psi_1\sigma^2$. Uma surpresa amanhã contamina a previsão de depois de amanhã.

**P7.** Por que o ARIMA(0,1,1) dá previsão plana, se a série não é estacionária?

> [!TIP]
> **Resposta**
> Porque, sem drift, a melhor estimativa do **nível** futuro é o nível atual suavizado: os choques futuros têm média zero e não deslocam a esperança. O que cresce com $h$ é a incerteza, não a previsão. Com drift, a previsão seria uma reta.

**P8.** Na D5.1, se o critério fosse o erro absoluto, a previsão seria outra?

> [!TIP]
> **Resposta**
> Seria a **mediana** condicional. Com erros gaussianos, média e mediana coincidem, e a fórmula não muda. Com distribuições assimétricas, mudam: a Q15(a) é sobre o EQM, e o enunciado define a perda.

## Diálogo

*Sobre o erro de calcular a variância do erro com os coeficientes errados.*

**Aluno:** No ARMA(1,1), a variância do erro de dois passos é $\sigma^2(1+\phi_1^2)$, como no AR(1).

**Professor:** De onde vem esse $\phi_1^2$?

**Aluno:** Do AR(1): $e_{T+2}=\varepsilon_{T+2}+\phi_1\varepsilon_{T+1}$.

**Professor:** E no ARMA(1,1)? Escreva $y_{T+2}$ e tire a previsão.

**Aluno:** $y_{T+2}=\phi_1y_{T+1}+\varepsilon_{T+2}+\theta_1\varepsilon_{T+1}$. E $y_{T+1}=\widehat y_{T+1/T}+\varepsilon_{T+1}$. Substituindo, o erro é $\varepsilon_{T+2}+\phi_1\varepsilon_{T+1}+\theta_1\varepsilon_{T+1}$.

**Professor:** Então o coeficiente de $\varepsilon_{T+1}$ é?

**Aluno:** $\phi_1+\theta_1$, que é o $\psi_1$! A variância é $\sigma^2\big(1+(\phi_1+\theta_1)^2\big)$.

**Professor:** Com $\phi_1=0{,}8$ e $\theta_1=0{,}6$?

**Aluno:** $1+1{,}96=2{,}96$, bem maior que os $1{,}64$ que eu teria dado.

**Professor:** Qual é a regra geral, então?

**Aluno:** Não copiar a fórmula do AR. Usar sempre $\sigma^2\sum_{j=0}^{h-1}\psi_j^2$, com os $\psi$ do modelo que está na questão, e conferir o sinal: na lista, $\psi_1=\phi-\theta$.

## Na prova

**A folha de caderno do bloco** está em [a_mao_cap5.md](a_mao_cap5.md): Q15 (a) a (e) em 40 linhas numeradas, cada uma com a justificativa, mais a versão para a prova e a conferência em R.

| Questão | O que este capítulo dá | Resolução completa |
|---|---|---|
| Q15 (a) | média condicional minimiza o EQM | [Q15](../lista_comentada/q15.md) |
| Q15 (b)–(d) | ARMA(1,1) em $h=1,2$; erro MA($h-1$); intervalo de 95% | [Q15](../lista_comentada/q15.md) |
| Q15 (e) | ARIMA(0,1,1), previsão plana, $\alpha=1-\theta$ | [Q15](../lista_comentada/q15.md) |
| Q12 (c) | previsão do SARIMA trimestral, que usa as mesmas regras | [Q12](../lista_comentada/q12.md) |

**Armadilhas:**
- tratar $\varepsilon_T$ como zero: ele é **conhecido** em $T$;
- usar $\phi_1^j$ como peso do erro num ARMA, quando o certo é $\psi_j$;
- esquecer que o MA "morre" depois de $q$ passos;
- na Q15(e), escrever $\alpha=\theta$ em vez de $1-\theta$ na convenção da lista;
- no caderno de 26/08, a previsão do MA(2) misturou $E(y_t\mid\Omega_{t-1})$ com $E(y_{t+2}\mid\Omega_t)$ (ver [Q15](../lista_comentada/q15.md)).

**Checklist de 30 segundos:**
1. Escrevi o modelo **na data futura** antes de tirar a esperança?
2. Apliquei as três regras: conhecido fica, choque futuro é zero, $y$ futuro vira previsão?
3. A variância do erro usa os $\psi_j$ do modelo certo?
4. O intervalo tem $\pm1{,}96\sqrt{\operatorname{Var}}$, com a raiz?
5. Disse o que acontece no longo prazo (volta à média, ou fica plano)?

## No material do professor

**Roteiro de releitura:**
- AU02, p. 44: modelo condicional × incondicional;
- AU02, p. 54–57: previsão do MA, o intervalo e o EQM;
- AU02, p. 72–76: previsão do AR(1), o erro e a variância;
- AU02, p. 85: previsão do ARMA(1,1);
- AU03, p. 32–41: treino e teste, esquemas de janela, horizonte e origem, iterada × direta.
- AU03, p. 42–49: o exemplo iterada × direta no AR(1) e as métricas MAPE, MAD, RMSE e MASE;
- AU03, p. 50–60: Diebold-Mariano, Winkler, CRPS e os testes de cobertura de Christoffersen.

**Livros:**
- **HAMILTON**, cap. 4: previsão ótima, a projeção linear e a esperança condicional;
- **BJRL**, cap. 5: previsão de ARIMA, pesos $\psi$, intervalos e a "função de previsão eventual";
- **ENDERS**, cap. 2: previsão de ARMA no nível do curso.

**Na lista comentada:** [Q15](../lista_comentada/q15.md) · [Q12](../lista_comentada/q12.md) · ferramenta [F9 (esperança condicional)](../lista_comentada/README.md#2-caixa-de-ferramentas).
