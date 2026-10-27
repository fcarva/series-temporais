---
title: "Banco de variações — as 16 questões da lista como podem cair na prova"
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
aliases:
  - Banco de variações da lista
---

# Banco de variações da lista

A prova sai da lista: **5 ou 6 questões, uma por bloco**. O professor raramente repete o número, mas costuma repetir a **estrutura**: troca o período sazonal, a convenção de sinal, o $T$ do AIC, ou um AR por um MA. Para cada questão da lista, este banco traz:
- a ideia central em uma linha;
- duas ou três **variações** com resposta curta;
- onde está a resolução completa no repositório;
- o capítulo dos livros que cobre o tema.

Nenhuma variação repete os números dos [simulados](README.md#os-três-simulados), que ficam para o treino cronometrado. Todos os números saem de [prova.R](prova.R).

> [!TIP]
> **Como usar**
> Tampe a resposta, resolva a variação em até 5 minutos e só então confira. Toda variação errada vira uma linha no [log de erros](log_erros.md).

**Livros, por id** ([MATERIAIS_INDEX](../MATERIAIS_INDEX.md)):
- ENDERS: cap. 1 (equações de diferenças), cap. 2 (ARMA, Box-Jenkins, previsão, sazonalidade) e cap. 4 (tendências e raiz unitária).
- HAMILTON: cap. 2 (operadores), cap. 3 (ARMA estacionário), cap. 4 (previsão e Wold) e cap. 5 (máxima verossimilhança).
- BJRL: cap. 3 e 4 (modelos estacionários e não estacionários), cap. 5 (previsão), cap. 6 a 8 (identificação, estimação, diagnóstico) e cap. 9 (sazonais).
- TSAY: cap. 2.
- MAT: Mattos (2019), tendências e raízes unitárias.

---

## Bloco 1 — Processos, estacionariedade e momentos

### Q1 · Momentos do passeio com drift

**Ideia:** escrever $y_t$ como soma dos choques e tirar os momentos termo a termo. Resolução em [01_lista](../01_processos_estacionariedade/01_lista.md), D01.1 · ENDERS cap. 4 · AU01.

**Variação A.** Mesmo processo, $y_t=c+y_{t-1}+u_t$, mas com $y_0$ **aleatório**, de variância $\sigma_0^2$ e não correlacionado com os $u$.
**Resposta.** $\operatorname{Var}(y_t)=\sigma_0^2+t\sigma^2$ e $\operatorname{Cov}(y_t,y_{t-k})=\sigma_0^2+(t-k)\sigma^2$. Continua não estacionário: a variância ainda cresce com $t$.

**Variação B.** Calcule os momentos de $\Delta y_t$.
**Resposta.** $\Delta y_t=c+u_t$: $E=c$, $\operatorname{Var}=\sigma^2$ e $\operatorname{Cov}=0$ para $k\ge1$. Estacionário, porque uma diferença basta: $y\sim I(1)$.

### Q2 · Drift e tendência determinística

**Ideia:** a tendência $\delta t$ dentro da equação vira uma tendência **quadrática** no nível. Resolução em [01_lista](../01_processos_estacionariedade/01_lista.md) · MAT · ENDERS cap. 4.

**Variação A.** Com $c=1$, $\delta=0{,}2$ e $y_0=0$, quanto vale $E(y_{10})$?
**Resposta.** $E(y_t)=ct+\delta\,t(t+1)/2$, logo $E(y_{10})=10+0{,}2\cdot55=21$. **Escreva a soma $\sum_{s=1}^{t}s=t(t+1)/2$ antes do número.**

**Variação B.** Qual operação torna o processo estacionário?
**Resposta.** $\Delta y_t=c+\delta t+u_t$ ainda tem tendência linear. Ou se tira a tendência de $\Delta y_t$ por regressão, ou se diferencia de novo: $\Delta^2y_t=\delta+u_t-u_{t-1}$, que é estacionário, mas tem MA não invertível. A primeira opção é a preferível (lista, Q2d).

### Q3 · Soma de processos estacionários

**Ideia:** $\gamma_{az_1+bz_2}(k)=a^2\gamma_1(k)+b^2\gamma_2(k)$ quando não há correlação cruzada. A FAC que corta em $q$ indica um MA($q$). Resolução em [01_lista](../01_processos_estacionariedade/01_lista.md).

**Variação A.** Com as FAC da lista, calcule a de $z_1-z_2$.
**Resposta.** O sinal some ao quadrado: $\gamma_0=0{,}5+2{,}30=2{,}8$, $\gamma_1=0{,}2-1{,}43=-1{,}23$, $\gamma_2=0{,}3$ e zero depois. É um MA(2).

**Variação B.** E de $3z_1+z_2$?
**Resposta.** $\gamma_0=9(0{,}5)+2{,}30=6{,}8$, $\gamma_1=9(0{,}2)-1{,}43=0{,}37$, $\gamma_2=0{,}30$. Também é um MA(2).

**Variação C.** E se $z_1$ e $z_2$ fossem correlacionados?
**Resposta.** Entram as covariâncias cruzadas $ab[\gamma_{12}(k)+\gamma_{21}(k)]$. Sem elas, a conta não fecha: por isso o enunciado sempre diz "não correlacionados". **Cite essa hipótese na primeira linha.**

### Q4 · Teorema de Wold

**Ideia:** todo processo estacionário é a soma de uma parte linear nos choques, com $\psi_0=1$ e $\sum\psi_j^2\lt\infty$, e uma parte determinística. Resolução em [01_lista](../01_processos_estacionariedade/01_lista.md) e D01.3 · HAMILTON cap. 4.

**Variação A.** Escreva o MA(1) $y_t=(1-\theta B)a_t$ como AR($\infty$), com $\theta=0{,}5$.
**Resposta.** $(1-\theta B)^{-1}=\sum_j\theta^jB^j$, logo $y_t=-\sum_{j\ge1}\theta^jy_{t-j}+a_t$, isto é, $\pi_j=-\theta^j$: $-0{,}5$; $-0{,}25$; $-0{,}125$. Com $\theta=2$, a série diverge: sem invertibilidade, não há AR($\infty$).

**Variação B.** Por que exigir $\sum\psi_j^2\lt\infty$?
**Resposta.** Porque $\operatorname{Var}(y_t)=\sigma^2\sum\psi_j^2$ precisa ser finita. É a condição de estacionariedade fraca escrita nos pesos.

**Variação C.** Dê um exemplo de componente determinístico.
**Resposta.** $A\cos(\omega t)+B\sin(\omega t)$, com $A$ e $B$ aleatórios fixados no início: é estacionário e perfeitamente previsível. Ver o Simulado 02, Q1.

---

## Bloco 2 — AR, MA e ARMA

### Q5 · Classificar, raízes e pesos

**Ideia:** fatorar os polinômios, olhar as raízes e **procurar fator comum**. Resolução em [02_lista](../02_arma/02_lista.md) · ENDERS cap. 2 · BJRL cap. 3.

**Variação A.** $(1-0{,}8B+0{,}15B^2)z_t=(1-0{,}3B)a_t$.
**Resposta.** $1-0{,}8B+0{,}15B^2=(1-0{,}5B)(1-0{,}3B)$, com raízes 2 e 3,3333. O fator $(1-0{,}3B)$ cancela: é um **AR(1)** com $\phi=0{,}5$, disfarçado de ARMA(2,1).

**Variação B.** $z_t=(1-2{,}5B+B^2)a_t$.
**Resposta.** $(1-0{,}5B)(1-2B)$, com raízes 2 e 0,5. A raiz 0,5 está **dentro** do círculo: o MA(2) é estacionário, mas **não invertível**.

**Variação C.** $(1-1{,}2B+0{,}2B^2)z_t=a_t$.
**Resposta.** $(1-B)(1-0{,}2B)$, com raízes 1 e 5. Há **raiz unitária**: não é estacionário. É um ARIMA(1,1,0), com $(1-0{,}2B)\Delta z_t=a_t$.

### Q6 · ARMA(1,1)

**Ideia:** dois momentos auxiliares, $E(z_ta_t)$ e $E(z_ta_{t-1})$, e um sistema 2×2 para $\gamma_0$ e $\gamma_1$. Resolução em [02_lista](../02_arma/02_lista.md) · HAMILTON cap. 3.

**Variação A.** BJ, com $\phi=0{,}9$ e $\theta=0{,}5$.
**Resposta.** $\rho_1=\frac{(1-\phi\theta)(\phi-\theta)}{1+\theta^2-2\phi\theta}=\frac{0{,}55\cdot0{,}4}{0{,}35}=0{,}6286$ e $\rho_2=0{,}5657$. A FAC decai devagar porque $\phi$ está perto de 1.

**Variação B.** E se $\phi=\theta$?
**Resposta.** Os fatores cancelam: $z_t=a_t$, e $\rho_1=0$. É ruído branco. Na estimação, isso aparece como $\widehat\phi\approx\widehat\theta$ com erros-padrão enormes.

**Variação C.** Mesmas fórmulas na convenção de sinal positivo?
**Resposta.** Troque $\theta\to-\theta$: $\gamma_0=\frac{1+2\phi\theta+\theta^2}{1-\phi^2}\sigma^2$ e $\psi_j=(\phi+\theta)\phi^{j-1}$. Ver o Simulado 03, Q2.

### Q7 · AR(2) e Yule-Walker

**Ideia:** $\rho_k=\phi_1\rho_{k-1}+\phi_2\rho_{k-2}$ e $\gamma_0=\sigma^2/(1-\phi_1\rho_1-\phi_2\rho_2)$. Resolução em [02_lista](../02_arma/02_lista.md) e D02.3 · ENDERS cap. 2.

**Variação A.** $\phi_1=1$ e $\phi_2=-0{,}5$.
**Resposta.**
- $\rho_1=1/1{,}5=0{,}6667$ e $\rho_2=0{,}6667-0{,}5=0{,}1667$.
- $\gamma_0=\frac{1{,}5}{0{,}5\,(2{,}25-1)}=2{,}4$.
- As raízes são complexas, com módulo $1{,}4142\gt1$: o processo é estacionário, e a FAC é uma **senoide amortecida**.
- $\cos\omega=\phi_1/(2\sqrt{-\phi_2})=0{,}7071$, logo $\omega=\pi/4$, e o ciclo tem período de **8** períodos (D02.4).

**Variação B.** Como se reconhece um AR(2) na FACP?
**Resposta.** $\phi_{11}=\rho_1$, $\phi_{22}=(\rho_2-\rho_1^2)/(1-\rho_1^2)=\phi_2$, e $\phi_{kk}=0$ para $k\ge3$.

### Q8 · Verdadeiro ou falso

**Ideia:** cada afirmativa pede a conta. **A Q8 usa sinal positivo.** Resolução em [02_lista](../02_arma/02_lista.md).

**Variação A.** No modelo (II), com $c=1$, $\theta=0{,}5$ e $Z_0=0$, quanto vale $E(Z_4)$? Confira a afirmativa 4 da lista.
**Resposta.** $Z_t=Z_0+ct+\theta\sum_{s=1}^ts+\sum\varepsilon_j$, logo $E(Z_4)=4+0{,}5\cdot10=9$. A fórmula da afirmativa, com $\frac\theta2t^2$, dá 8: **falsa**, porque $\sum s=t(t+1)/2$, e não $t^2/2$.

**Variação B.** A variância do modelo (II) depende de $c$ ou de $\theta$?
**Resposta.** Não: $\operatorname{Var}(Z_t)=t\sigma^2$. Constantes e tendências determinísticas não têm variância (afirmativa 5: falsa).

---

## Bloco 3 — Integrados, ARIMA e SARIMA

### Q9 · Sobrediferenciação

**Ideia:** $\phi(B)\Delta y_t=(1-B)\theta(B)\varepsilon_t$. O MA ganha raiz unitária. Resolução em [03_lista](../03_arima_sarima/03_lista.md) e D03.2 · BJRL cap. 4.

**Variação A.** Diferencie um ruído branco.
**Resposta.** $\Delta y_t=\varepsilon_t-\varepsilon_{t-1}$, com $\rho_1=-0{,}5$, o valor-limite de um MA(1), e $\operatorname{Var}=2\sigma^2$: a variância **dobra**.

**Variação B.** AR(1) com $\phi=0{,}9$.
**Resposta.** $\rho_1(\Delta y)=-(1-\phi)/2=-0{,}05$. Quase não aparece na FAC: com $\phi$ perto de 1, a sobrediferenciação é difícil de ver, e o teste de raiz unitária tem pouco poder (D03.3).

### Q10 · ARIMA × tendência determinística

**Ideia:** DS se diferencia; TS se regride em $t$. Resolução em [03_lista](../03_arima_sarima/03_lista.md) · MAT · ENDERS cap. 4.

**Variação A.** $y_t=\alpha+\beta t+u_t$, com $u_t$ ruído branco, foi diferenciado.
**Resposta.** $\Delta y_t=\beta+u_t-u_{t-1}$: um MA(1) com $\theta=1$, não invertível, com $\rho_1=-0{,}5$. O procedimento não é adequado.

**Variação B.** Expanda o ARIMA(2,1,0) $(1-\phi_1B-\phi_2B^2)(1-B)y_t=a_t$.
**Resposta.** $y_t=(1+\phi_1)y_{t-1}+(\phi_2-\phi_1)y_{t-2}-\phi_2y_{t-3}+a_t$. Os coeficientes somam 1: é a raiz unitária.

### Q11 · SAR e o AR restrito

**Ideia:** o SAR(1)$_s$ é um AR(1) "em anos". O multiplicativo gera termos cruzados. Resolução em [03_lista](../03_arima_sarima/03_lista.md) · BJRL cap. 9.

**Variação A.** SAR(1)$_{12}$ com $\Phi=0{,}5$ e $\sigma^2=1$.
**Resposta.** $\gamma_0=1/(1-0{,}25)=1{,}3333$, $\rho_{12}=0{,}5$, $\rho_{24}=0{,}25$, e zero fora dos múltiplos de 12. A FACP tem um pico só, em 12.

**Variação B.** Escreva SARIMA$(0,0,1)(0,0,1)_{12}$ como MA restrito.
**Resposta.** $(1-\theta B)(1-\Theta B^{12})=1-\theta B-\Theta B^{12}+\theta\Theta B^{13}$. É um MA(13) com restrições: dez coeficientes nulos e $\theta_{13}=-\theta\Theta$ na convenção BJ.

### Q12 · Previsão do SARIMA trimestral

**Ideia:** expandir, tirar $E(\cdot\mid\mathcal F_T)$ termo a termo e ver em que $h$ o MA some. Resolução em [03_lista](../03_arima_sarima/03_lista.md) · BJRL cap. 5 e 9.

**Variação A.** SARIMA$(0,1,1)(0,1,1)_4$: equações de previsão.
**Resposta.**
- $y_t=y_{t-1}+y_{t-4}-y_{t-5}+a_t-\theta a_{t-1}-\Theta a_{t-4}+\theta\Theta a_{t-5}$.
- $\widehat y(1)=y_T+y_{T-3}-y_{T-4}-\theta\widehat a_T-\Theta\widehat a_{T-3}+\theta\Theta\widehat a_{T-4}$.
- O MA some a partir de $h=6$.
- Perdem-se 5 observações.

**Variação B.** E com $s=12$, $d=1$ e $D=1$?
**Resposta.** Perdem-se 13 observações. No modelo com MA$(1)\times$SMA$(1)$, os resíduos entram até $h=13$.

---

## Bloco 4 — Identificação, estimação e diagnóstico

### Q13 · MV condicional do AR(1)

**Ideia:** condicionar em $y_1$ transforma a MV em MQO. Resolução em [04_lista](../04_estimacao_selecao/04_lista.md), D04.1 · HAMILTON cap. 5.

**Variação A.** Com constante, $y_t=c+\phi y_{t-1}+\varepsilon_t$.
**Resposta.** $(\widehat c,\widehat\phi)$ saem do MQO de $y_t$ em $(1,y_{t-1})$, e $\widehat\sigma^2=SQR/(T-1)$. A média estimada é $\widehat\mu=\widehat c/(1-\widehat\phi)$.

**Variação B.** O estimador é não viesado?
**Resposta.** Não: $y_{t-1}$ não é estritamente exógeno, e há o viés de Hurwicz, de cerca de $-2\phi/T$ sem constante e $-(1+3\phi)/T$ com constante. Mas o estimador é **consistente** e assintoticamente normal.

### Q14 · AIC e BIC

**Ideia:** $k$ inclui $\sigma^2$. O BIC pune com $\ln T$, o AIC com 2. Resolução em [04_lista](../04_estimacao_selecao/04_lista.md) · AU02.

**Variação A.** $T=100$: AR(1) com $\ln L=-140{,}2$; ARMA(1,1) com $-138{,}9$; AR(2) com $-138{,}7$.
**Resposta.**

| Modelo | $k$ | AIC | BIC |
|---|---|---|---|
| AR(1) | 2 | 284,4 | **289,610** |
| ARMA(1,1) | 3 | 283,8 | 291,616 |
| AR(2) | 3 | **283,4** | 291,216 |

O AIC escolhe o AR(2), e o BIC escolhe o AR(1).

**Variação B.** Esqueci de contar $\sigma^2$: muda a escolha?
**Resposta.** Não, se todos os modelos estimam $\sigma^2$: somar 1 a todos os $k$ desloca todos os critérios igualmente. **Mas o valor pedido fica errado e perde ponto.**

---

## Bloco 5 — Previsão

### Q15 · Previsão em ARMA

**Ideia:** $y_{T+h\mid T}=E(y_{T+h}\mid\mathcal F_T)$; o erro é um MA($h-1$); a variância é $\sigma^2\sum_{j\lt h}\psi_j^2$. Resolução em [05_lista](../05_previsao/05_lista.md), D05.1 · HAMILTON cap. 4 · BJRL cap. 5.

**Variação A.** AR(2) com $\phi=(0{,}6;\ 0{,}2)$, $y_T=2$, $y_{T-1}=1$ e $\sigma^2=1$.
**Resposta.** $y_{T+1\mid T}=0{,}6\cdot2+0{,}2\cdot1=1{,}4$ e $y_{T+2\mid T}=0{,}6\cdot1{,}4+0{,}2\cdot2=1{,}24$. Com $\psi_1=0{,}6$, $\operatorname{Var}(e_T(2))=1+0{,}36=1{,}36$.

**Variação B.** Por que a variância do erro nunca diminui com $h$?
**Resposta.** Cada passo acrescenta $\sigma^2\psi_{h-1}^2\ge0$. No limite, ela converge para $\gamma_0$ num processo estacionário e diverge num processo I(1).

**Variação C.** ARIMA(0,1,1): qual a constante da suavização exponencial?
**Resposta.** $\alpha=1-\theta$, na convenção BJ.

---

## Bloco 6 — Aplicação

### Q16 · SARIMA mensal

**Ideia:** escrever o modelo, contar os parâmetros, prever a FAC de $w_t$ e escolher entre modelos aninhados. Resolução em [06_lista](../06_aplicacao_sarima/06_lista.md) · BJRL cap. 9 · AU03.

**Variação A.** SARIMA$(2,1,1)(1,1,1)_{12}$ com $T=240$.
**Resposta.** São $\phi_1$, $\phi_2$, $\theta$, $\Phi$, $\Theta$ e $\sigma^2$: **6** parâmetros. Perdem-se 13 observações, e sobram 227.

**Variação B.** Que padrão na FAC de $w_t$ indicaria SAR em vez de SMA?
**Resposta.** Com SMA(1), a FAC corta em 12. Com SAR(1), ela **decai** em 12, 24, 36… e a FACP corta em 12.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_b02_e_y10 | 21 |
| pv_b03_dif_g0 | 2,8 |
| pv_b03_dif_g1 | -1,23 |
| pv_b03_dif_g2 | 0,3 |
| pv_b03_tri_g0 | 6,8 |
| pv_b03_tri_g1 | 0,37 |
| pv_b03_tri_g2 | 0,30 |
| pv_b04_pi1 | -0,5 |
| pv_b04_pi2 | -0,25 |
| pv_b04_pi3 | -0,125 |
| pv_b05_v1_raiz_a | 3,3333 |
| pv_b05_v1_raiz_b | 2 |
| pv_b05_v2_raiz_a | 2 |
| pv_b05_v2_raiz_b | 0,5 |
| pv_b05_v3_raiz_a | 5 |
| pv_b05_v3_raiz_b | 1 |
| pv_b06_rho1 | 0,6286 |
| pv_b06_rho2 | 0,5657 |
| pv_b06_rho1_igual | 0 |
| pv_b07_rho1 | 0,6667 |
| pv_b07_rho2 | 0,1667 |
| pv_b07_g0 | 2,4 |
| pv_b07_modulo | 1,4142 |
| pv_b07_periodo | 8 |
| pv_b08_e_z4 | 9 |
| pv_b08_e_z4_errado | 8 |
| pv_b09_rho1_rb | -0,5 |
| pv_b09_rho1_ar09 | -0,05 |
| pv_b11_g0 | 1,3333 |
| pv_b11_rho12 | 0,5 |
| pv_b11_rho24 | 0,25 |
| pv_b14_aic_ar1 | 284,4 |
| pv_b14_aic_arma11 | 283,8 |
| pv_b14_aic_ar2 | 283,4 |
| pv_b14_bic_ar1 | 289,610 |
| pv_b14_bic_arma11 | 291,616 |
| pv_b14_bic_ar2 | 291,216 |
| pv_b15_f1 | 1,4 |
| pv_b15_f2 | 1,24 |
| pv_b15_v2 | 1,36 |
| pv_b16_npar | 6 |
| pv_b16_efetivas | 227 |
-->
