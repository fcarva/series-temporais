---
title: "Cap. 4 à mão — Q13 e Q14 linha a linha"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: [13, 14]
aulas: "AU02 p. 68–71, 77–80, 98–99"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Cap. 4 à mão — Q13 e Q14
---

# Cap. 4 à mão: Q13 e Q14, linha a linha

[← capítulo 4](cap4_estimacao_selecao.md) · [← apostila](README.md) · [cap. 3 à mão](a_mao_cap3.md)

Versão de **caderno** do bloco 4 da lista: cada passagem numerada, uma operação por linha e o motivo entre colchetes. A numeração é contínua. Os símbolos são os dos slides: $\phi_1$, $\varepsilon_t$, $\ln L$, $T$ observações.

**Legenda:**
- [RB]: ruído branco;
- [F4]: linearidade da esperança;
- [CPO]: condição de primeira ordem, a derivada igual a zero;
- [(n)]: usando a linha (n).

---

# Q13 · AR(1): log-verossimilhança condicional e MQO

**Enunciado (lista, Q13).** Para $y_t=\phi y_{t-1}+\varepsilon_t$, com $\varepsilon_t\sim N(0,\sigma^2)$: escrever a log-verossimilhança condicional em $y_1$ e obter o estimador de MQO de $\phi$.

**Nos slides:** AU02, p. 77–80, com $\phi=\phi_1$ e sem constante.

$$
\begin{aligned}
\text{(1)}\quad & y_t\mid y_{t-1}\sim N(\phi y_{t-1},\ \sigma^2) && [\varepsilon_t \text{ normal}]\\
\text{(2)}\quad & f(y_t\mid y_{t-1})=(2\pi\sigma^2)^{-1/2}\exp\Big(-\frac{(y_t-\phi y_{t-1})^2}{2\sigma^2}\Big) && [\text{densidade normal}]\\
\text{(3)}\quad & f(y_2,\dots,y_T\mid y_1)=\textstyle\prod_{t=2}^{T}f(y_t\mid y_{t-1}) && [\text{fatoração, AU02 p. 80}]\\
\text{(4)}\quad & \ln L=\textstyle\sum_{t=2}^{T}\ln f(y_t\mid y_{t-1}) && [\ln \text{ do produto}]\\
\text{(5)}\quad & \ln f(y_t\mid y_{t-1})=-\tfrac12\ln(2\pi)-\tfrac12\ln\sigma^2-\frac{(y_t-\phi y_{t-1})^2}{2\sigma^2} && [\ln \text{ de } (2)]\\
\text{(6)}\quad & \ln L(\phi,\sigma^2\mid y_1)=-\tfrac{T-1}{2}\ln(2\pi)-\tfrac{T-1}{2}\ln\sigma^2-\frac{S(\phi)}{2\sigma^2} && [T-1 \text{ termos}]\\
\text{(7)}\quad & S(\phi)\equiv\textstyle\sum_{t=2}^{T}(y_t-\phi y_{t-1})^2 && [\text{soma de quadrados}]\\
\text{(8)}\quad & \frac{\partial\ln L}{\partial\phi}=-\frac{1}{2\sigma^2}\,S'(\phi) && [\text{só } S \text{ depende de } \phi]\\
\text{(9)}\quad & S'(\phi)=\textstyle\sum_{t=2}^{T}2(y_t-\phi y_{t-1})(-y_{t-1}) && [\text{regra da cadeia}]\\
\text{(10)}\quad & \frac{\partial\ln L}{\partial\phi}=\frac{1}{\sigma^2}\textstyle\sum_{t=2}^{T}(y_t-\phi y_{t-1})\,y_{t-1}=0 && [\text{CPO}]\\
\text{(11)}\quad & \textstyle\sum_{t=2}^{T}y_ty_{t-1}-\phi\sum_{t=2}^{T}y_{t-1}^2=0 && [\text{distributiva}]\\
\text{(12)}\quad & \widehat\phi=\frac{\sum_{t=2}^{T}y_ty_{t-1}}{\sum_{t=2}^{T}y_{t-1}^2} && [\text{isola}]\\
\text{(13)}\quad & \text{é o MQO de } y_t \text{ em } y_{t-1}:\ \min_\phi S(\phi) && [(6):\ \max\ln L\iff\min S]\\
\text{(14)}\quad & \frac{\partial^2\ln L}{\partial\phi^2}=-\frac{1}{\sigma^2}\textstyle\sum_{t=2}^{T}y_{t-1}^2\lt0 && [\text{é máximo}]\\
\text{(15)}\quad & \frac{\partial\ln L}{\partial\sigma^2}=-\frac{T-1}{2\sigma^2}+\frac{S(\widehat\phi)}{2\sigma^4}=0 && [\text{CPO em } \sigma^2]\\
\text{(16)}\quad & \widehat\sigma^2=\frac{S(\widehat\phi)}{T-1}=\frac{1}{T-1}\textstyle\sum_{t=2}^{T}\widehat\varepsilon_t^{\,2} && [\times2\sigma^4,\ \text{isola}]\\
\text{(17)}\quad & \ln L_{\max}=-\tfrac{T-1}{2}\big(\ln(2\pi)+\ln\widehat\sigma^2+1\big) && [(16) \text{ em } (6)]
\end{aligned}
$$

$$
\boxed{\ln L(\phi,\sigma^2\mid y_1)=-\tfrac{T-1}{2}\ln(2\pi\sigma^2)-\tfrac{1}{2\sigma^2}\textstyle\sum_{t=2}^{T}(y_t-\phi y_{t-1})^2;\qquad \widehat\phi=\frac{\sum y_ty_{t-1}}{\sum y_{t-1}^2}=\widehat\phi_{MQO}}
$$

A linha (17) é o elo com a Q14: o $\ln L$ maximizado depende dos dados só pela variância dos resíduos, e é ele que entra no AIC e no BIC.

**Além do que se pede: a exata e o Yule-Walker.**

$$
\begin{aligned}
\text{(18)}\quad & \ln L_{ex}=\ln f(y_1)+\ln L_{cond},\quad y_1\sim N\big(0,\ \sigma^2/(1-\phi^2)\big) && [\text{AU02 p. 78}]\\
\text{(19)}\quad & \ln f(y_1)=-\tfrac12\ln(2\pi)-\tfrac12\ln\sigma^2+\tfrac12\ln(1-\phi^2)-\frac{(1-\phi^2)y_1^2}{2\sigma^2} && [\text{densidade de } y_1]\\
\text{(20)}\quad & \text{a CPO ganha } -\frac{\phi}{1-\phi^2}+\frac{\phi\,y_1^2}{\sigma^2}:\ \text{não linear em } \phi && [\text{solução numérica}]\\
\text{(21)}\quad & \widehat\phi_{YW}=\widehat\rho_1=\frac{\sum_{t=2}^{T}y_ty_{t-1}}{\sum_{t=1}^{T}y_t^2} && [\text{AU02 p. 70–71}]\\
\text{(22)}\quad & \text{os três diferem em } O(1/T) \text{ e são assintoticamente equivalentes} && [\text{AU02 p. 80}]
\end{aligned}
$$

---

# Q14 · AIC e BIC de três modelos

**Enunciado (lista, Q14).** Ajustaram-se um ARMA(1,1), um ARMA(2,0) e um ARMA(0,2) a $T=150$ observações. As log-verossimilhanças maximizadas são $-210{,}3$, $-212{,}8$ e $-214{,}1$; os modelos têm média zero, e $k$ inclui a variância. Pede-se:
- (a) o AIC e o BIC de cada modelo e o escolhido por cada critério;
- (b) a diferença de penalidade e as implicações assintóticas.

**(a) As contas**, com as fórmulas da AU02, p. 98–99:

$$
\begin{aligned}
\text{(23)}\quad & k=p+q+1=3 \text{ nos três modelos} && [\text{AR/MA} + \sigma^2]\\
\text{(24)}\quad & -2\ln L:\ \ 420{,}6;\ \ 425{,}6;\ \ 428{,}2 && [-2\times\ln L]\\
\text{(25)}\quad & AIC=\frac{-2\ln L+2k}{T},\qquad 2k=6 && [\text{AU02 p. 98}]\\
\text{(26)}\quad & AIC_{(1,1)}=\frac{420{,}6+6}{150}=\frac{426{,}6}{150}=2{,}8440 && [(24),(25)]\\
\text{(27)}\quad & AIC_{(2,0)}=\frac{425{,}6+6}{150}=\frac{431{,}6}{150}=2{,}8773 && [(24),(25)]\\
\text{(28)}\quad & AIC_{(0,2)}=\frac{428{,}2+6}{150}=\frac{434{,}2}{150}=2{,}8947 && [(24),(25)]\\
\text{(29)}\quad & BIC=\frac{-2\ln L+k\ln T}{T},\qquad k\ln T=3(5{,}0106)=15{,}0319 && [\text{AU02 p. 99}]\\
\text{(30)}\quad & BIC_{(1,1)}=\frac{420{,}6+15{,}0319}{150}=\frac{435{,}632}{150}=2{,}9042 && [(24),(29)]\\
\text{(31)}\quad & BIC_{(2,0)}=\frac{440{,}632}{150}=2{,}9375 && [(24),(29)]\\
\text{(32)}\quad & BIC_{(0,2)}=\frac{443{,}232}{150}=2{,}9549 && [(24),(29)]\\
\text{(33)}\quad & \text{menor AIC e menor BIC: ARMA(1,1)} && [\text{regra: o menor vence}]\\
\text{(34)}\quad & k \text{ igual}\Rightarrow\text{multa igual}\Rightarrow\text{a ordem é a de } -2\ln L && [(23)]
\end{aligned}
$$

$$
\boxed{AIC=(2{,}8440;\ 2{,}8773;\ 2{,}8947),\quad BIC=(2{,}9042;\ 2{,}9375;\ 2{,}9549):\ \text{os dois escolhem o ARMA(1,1)}}
$$

No R, sem dividir por $T$, os valores são $AIC=426{,}6$, $431{,}6$ e $434{,}2$, e $BIC=435{,}63$, $440{,}63$ e $443{,}23$, com a mesma ordem.

**(b) Penalidade e propriedades assintóticas**, comparando um modelo com $k$ parâmetros com outro de $k+1$ que o contém, com $LR=2(\ln L_{k+1}-\ln L_k)$:

$$
\begin{aligned}
\text{(35)}\quad & \text{multa por parâmetro: AIC } 2;\ \ \text{BIC } \ln T=5{,}01 \text{ com } T=150 && [(25),(29)]\\
\text{(36)}\quad & \ln T\gt2\iff T\gt e^2\approx7{,}4 && [\text{BIC mais duro}]\\
\text{(37)}\quad & AIC_{k+1}\lt AIC_k\iff -2\ln L_{k+1}+2\lt-2\ln L_k\iff LR\gt2 && [\text{rearranja}]\\
\text{(38)}\quad & BIC_{k+1}\lt BIC_k\iff LR\gt\ln T && [\text{idem, multa } \ln T]\\
\text{(39)}\quad & \text{se o menor é o verdadeiro: } LR\xrightarrow{d}\chi^2(1) && [\text{teste LR}]\\
\text{(40)}\quad & P(\text{AIC superajusta})\to P\big(\chi^2(1)\gt2\big)=0{,}157 && [\text{não vai a zero}]\\
\text{(41)}\quad & P(\text{BIC superajusta})=P(LR\gt\ln T)\to0 && [\ln T\to\infty:\ \text{consistente}]\\
\text{(42)}\quad & \text{falta parâmetro não nulo: } LR\sim T \text{ vence as multas} && [\text{nenhum subajusta}]\\
\text{(43)}\quad & \text{verdadeiro fora da lista: o AIC minimiza o EQM de previsão} && [\text{eficiência}]
\end{aligned}
$$

$$
\boxed{\text{AIC: multa 2, eficiente, superajusta com prob. } 0{,}157;\qquad \text{BIC: multa } \ln T,\ \text{consistente}}
$$

A conclusão para escrever na prova: **BIC para identificar** a estrutura, quando se supõe que o modelo verdadeiro está entre os candidatos, e **AIC para prever**. Na Q14 os dois concordam, porque os modelos têm o mesmo $k$.

---

## Versão para a prova

**Q13:**
1. Escreva $y_t\mid y_{t-1}\sim N(\phi y_{t-1},\sigma^2)$ e a densidade.
2. Some os logs de $t=2$ a $T$, linha (6).
3. A CPO em $\phi$ dá $\widehat\phi=\sum y_ty_{t-1}/\sum y_{t-1}^2$, que é o MQO, porque maximizar $\ln L$ é minimizar $S(\phi)$.
4. A CPO em $\sigma^2$ dá $\widehat\sigma^2=S/(T-1)$.

**Q14:**
1. $k=3$ e $-2\ln L=420{,}6$; $425{,}6$; $428{,}2$.
2. AIC: some 6 e divida por 150.
3. BIC: some $15{,}03$ e divida por 150.
4. O menor vence: ARMA(1,1) nos dois.
5. Explique as multas, 2 contra $\ln T$, e as linhas (37)–(41).

## Conferência

**Q13**, numa série simulada com $\phi=0{,}6$ e $T=200$:
- a fórmula (12) dá 0,6537, igual ao `lm`;
- o Yule-Walker (21) dá 0,6487, igual ao `ar.yw`;
- a exata dá 0,6620;
- $\widehat\sigma^2=1{,}0491$.

**Q14:**
- as parcelas são 420,6, 425,6, 428,2 e $3\ln150=15{,}0319$;
- a diferença de AIC entre o segundo e o primeiro modelo, sem dividir por $T$, é 5;
- numa simulação de mil séries, o AIC superajusta 15,7% das vezes com $T=150$ e 12,4% com $T=2000$, perto dos 0,157 teóricos; o BIC, 3,2% e 0,6%.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_c4_phi_mqo | 0,6537 |
| ap_c4_phi_mqo_lm | 0,6537 |
| ap_c4_phi_yw | 0,6487 |
| ap_c4_phi_yw_r | 0,6487 |
| ap_c4_phi_exata | 0,6620 |
| ap_c4_s2_mqo | 1,0491 |
| ap_am4_m2ll1 | 420,6 |
| ap_am4_m2ll2 | 425,6 |
| ap_am4_m2ll3 | 428,2 |
| ap_am4_klnT | 15,0319 |
| ap_am4_dif_aic12 | 5 |
| ap_c4_lnT | 5,0106 |
| ap_c4_q14_aic1 | 2,8440 |
| ap_c4_q14_aic2 | 2,8773 |
| ap_c4_q14_aic3 | 2,8947 |
| ap_c4_q14_bic1 | 2,9042 |
| ap_c4_q14_bic2 | 2,9375 |
| ap_c4_q14_bic3 | 2,9549 |
| ap_c4_q14_aicR1 | 426,6 |
| ap_c4_q14_aicR2 | 431,6 |
| ap_c4_q14_aicR3 | 434,2 |
| ap_c4_q14_bicR1 | 435,63 |
| ap_c4_q14_bicR2 | 440,63 |
| ap_c4_q14_bicR3 | 443,23 |
| ap_c4_sob_aic_150 | 0,157 |
| ap_c4_sob_aic_2000 | 0,124 |
| ap_c4_sob_bic_150 | 0,032 |
| ap_c4_sob_bic_2000 | 0,006 |
| ap_c4_sob_aic_teorico | 0,1573 |
-->
