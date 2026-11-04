---
title: "Não posso errar — as questões básicas, linha a linha, com o sentido de cada passo"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
prova: "05/11/2026"
lista: [1, 3, 5, 6, 7, 9, 13, 14, 15, 16]
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Não posso errar
---

# Não posso errar: as questões básicas, linha a linha

> [!NOTE]
> **Depois do quadro de 04/11**
> A prova terá **4 questões de 2,5**. Yule-Walker foi riscado: a **questão-tipo 5 não cai**. O que o quadro pede além deste guia (montar e desenhar a FAC, o SMA sazonal, a equação de previsão, o ciclo de modelagem e a interpretação de AIC, BIC, RMSE e MAPE) está na folha [o que cai](o_que_cai.md).

Este guia pega as **nove questões-tipo** que mais caem e que dão os pontos mais seguros. Cada uma vem resolvida como no caderno: cada linha numerada, com o motivo entre colchetes. Logo abaixo vem **o sentido de cada linha**: o que ela faz, por que é necessária e o que prepara. É o que falta para não travar: saber **por que** se escreve aquela linha.

**Como usar:**
1. Leia o enunciado-tipo e a seção "Antes de escrever".
2. **Cubra o resto e tente sozinho**, no papel.
3. Confira linha a linha. Na primeira linha diferente, leia o sentido dela.
4. Refaça sem olhar no dia seguinte, e depois faça a variação do banco indicada no "Treino".

**Ordem até quinta**, pelos pontos que o Simulado 01 deixou na mesa: **4, 7, 8 e 9** primeiro, depois 6, 2, 3, 5 e 1. Na prova, a ordem é outra: contas curtas (7, 8, 9 e os pesos da 4) antes das derivações.

**Notação:** a da lista, que é a da prova: $B$, $a_t$ e o MA de Box-Jenkins, $1-\theta B$. Nos slides, o mesmo modelo usa $L$, $\varepsilon_t$ e $1+\theta_1L$, com $\theta_1=-\theta$. As justificativas entre colchetes:
- [RB]: ruído branco;
- [F4]: linearidade da esperança;
- [caus.]: o choque de hoje não se correlaciona com o passado;
- [estac.]: os momentos não dependem da data;
- [(n)]: usando a linha (n).

O que saber de cor está no [básico](basico.md).

---

## 1 · Passeio com drift: momentos e estacionariedade

**Enunciado-tipo** (lista, Q1). Seja $y_t=c+y_{t-1}+u_t$, com $y_0=10$ fixo e $u_t\sim RB(0,\sigma^2)$. Calcule $E(y_t)$, $\operatorname{Var}(y_t)$ e $\operatorname{Cov}(y_t,y_{t-k})$. O processo é estacionário?

### O que a questão quer

- **"Calcule"**: a fórmula geral, em função de $t$ e $k$, com a hipótese que justifica cada passo.
- **"É estacionário?"**: testar as **três** condições e responder com uma frase.

### Antes de escrever

O molde é a **soma telescópica**: escrever $y_t$ como o valor inicial mais a soma dos choques, e depois tirar os momentos da soma. $y_0$ é um número, sem variância.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & y_s-y_{s-1}=c+u_s && [\text{modelo}]\\
\text{(2)}\quad & \textstyle\sum_{s=1}^{t}(y_s-y_{s-1})=y_t-y_0 && [\text{telescópica}]\\
\text{(3)}\quad & y_t=y_0+ct+\textstyle\sum_{s=1}^{t}u_s && [(1),(2)]\\
\text{(4)}\quad & E(y_t)=y_0+ct+\textstyle\sum_{s=1}^{t}E(u_s)=10+ct && [\text{F4, soma finita; RB}]\\
\text{(5)}\quad & y_t-E(y_t)=\textstyle\sum_{s=1}^{t}u_s && [(3)-(4)]\\
\text{(6)}\quad & \operatorname{Var}(y_t)=E\big((\textstyle\sum_iu_i)^2\big)=\textstyle\sum_i\sum_jE(u_iu_j) && [(5),\ \text{F4}]\\
\text{(7)}\quad & \phantom{\operatorname{Var}(y_t)}=\textstyle\sum_{i=1}^{t}E(u_i^2)=t\sigma^2 && [\text{RB: só } i=j]\\
\text{(8)}\quad & \operatorname{Cov}(y_t,y_{t-k})=E\big(\textstyle\sum_{i=1}^{t}u_i\sum_{j=1}^{t-k}u_j\big) && [(5) \text{ em } t \text{ e } t-k]\\
\text{(9)}\quad & \phantom{\operatorname{Cov}(y_t,y_{t-k})}=\textstyle\sum_{j=1}^{t-k}E(u_j^2)=(t-k)\sigma^2 && [\text{RB: pares comuns}]\\
\text{(10)}\quad & \operatorname{Corr}(y_t,y_{t-k})=\frac{(t-k)\sigma^2}{\sqrt{t\sigma^2(t-k)\sigma^2}}=\sqrt{\tfrac{t-k}{t}} && [(7),(9)]\\
\text{(11)}\quad & \operatorname{Var}(y_t)=t\sigma^2 \text{ depende de } t && [\text{testa a 2ª condição}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** Escrevo o modelo como "variação = drift + choque". É a forma que se soma bem.
- **(2)** Somar as variações de 1 a $t$ cancela tudo no meio: sobra o fim menos o começo. Essa é a ideia da telescópica.
- **(3)** Aqui está a solução: o ponto de partida, mais o drift acumulado, mais **todos** os choques acumulados. Toda a aleatoriedade está na soma.
- **(4)** A média: $y_0$ e $ct$ são números e saem como estão; a esperança entra na soma **porque ela é finita**; cada $E(u_s)$ é zero pelo RB. Não esquecer o $y_0=10$.
- **(5)** Tiro a média para isolar a parte aleatória. Variância e covariância são esperanças **desse desvio**.
- **(6)** A variância é $E$ do desvio ao quadrado, **com o $E$**. O quadrado de uma soma é a soma dupla de todos os produtos.
- **(7)** Pelo RB, só os produtos de um choque com ele mesmo sobram, e são $t$ deles, cada um valendo $\sigma^2$.
- **(8)** Na covariância, multiplico o desvio de hoje pelo de $k$ períodos atrás. O segundo tem só $t-k$ choques.
- **(9)** Só os choques que aparecem nas duas somas, os $t-k$ primeiros, dão $\sigma^2$. Os outros pares têm datas diferentes e dão zero.
- **(10)** A correlação divide pela raiz das duas variâncias. O $\sigma^2$ cancela. Para $k$ fixo e $t$ grande, vai a 1: a memória não se apaga.
- **(11)** Estacionariedade pede média, variância e covariância sem depender de $t$. A variância já falha, e isso basta para responder.

**Frase de fecho:** "Como $\operatorname{Var}(y_t)=t\sigma^2$ depende de $t$ (e a média também, se $c\ne0$), **o processo não é estacionário**. A correlação $\sqrt{(t-k)/t}$ fica perto de 1: a FAC de um passeio decai devagar, que é o sinal de raiz unitária."

### Erro que não pode

- **Escrever $\operatorname{Var}(y_t)=(y_t-\mu)^2$ sem o $E$** e **esquecer a frase de fecho**: foram os dois pontos perdidos na Q1 do Simulado 01 ([log](log_erros.md)).
- Esquecer o $y_0$ na média.
- Achar que "média constante" basta: com $c=0$, a média é constante e mesmo assim não é estacionário.

### Confira com números

Com $y_0=10$, $c=0{,}5$, $\sigma^2=1$, $t=20$ e $k=5$:
- $E(y_{20})=20$;
- $\operatorname{Var}(y_{20})=20$;
- $\operatorname{Cov}(y_{20},y_{15})=15$;
- $\operatorname{Corr}=\sqrt{15/20}=0{,}866$.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_c1_rw_media | 20 |
| ap_c1_rw_var | 20 |
| ap_c1_rw_cov | 15 |
| ap_c1_rw_corr | 0,866 |
-->

### Treino

- Em modo prova: [Simulado 02, Q1](simulado_02.md), com a correção no [gabarito](simulado_02_gabarito.md).
- Variação: [banco, Q1](banco.md#q1--momentos-do-passeio-com-drift).
- Folha à mão: [cap. 1](../apostila/a_mao_cap1.md).
- Nota comentada: [Q1](../lista_comentada/q01.md). A Q2, com tendência, é a mesma conta mais $\delta\frac{t(t+1)}{2}$.

---

## 2 · Soma de processos: autocovariância e classificação pela FAC

**Enunciado-tipo** (lista, Q3). $z_1$ tem $\gamma_0=0{,}5$, $\gamma_1=0{,}2$ e zero depois. $z_2$ tem $\gamma_0=2{,}30$, $\gamma_1=-1{,}43$, $\gamma_2=0{,}30$ e zero depois. Os dois são estacionários e não correlacionados. Para $z_3=z_1+2z_2$: a autocovariância, se é estacionário e a classe ARMA.

### O que a questão quer

- Uma **fórmula** de $\gamma_3(k)$ em função de $\gamma_1$ e $\gamma_2$, com o motivo de os termos cruzados sumirem.
- Os **números** para cada $k$.
- A **classe**, justificada pelo formato da FAC.

### Antes de escrever

O molde é a **covariância bilinear**: $\operatorname{Cov}(A+bC,\ D+bE)$ abre em quatro produtos. A hipótese-chave é "não correlacionados".

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & E(z_{3t})=E(z_{1t})+2E(z_{2t})=\text{constante} && [\text{F4}]\\
\text{(2)}\quad & \gamma_3(k)=\operatorname{Cov}(z_{1t}+2z_{2t},\ z_{1,t-k}+2z_{2,t-k}) && [\text{definição}]\\
\text{(3)}\quad & \phantom{\gamma_3(k)}=\gamma_1(k)+2C_{12}(k)+2C_{21}(k)+4\gamma_2(k) && [\text{quatro produtos}]\\
\text{(4)}\quad & C_{12}(k)=C_{21}(k)=0 && [\text{não correlacionados}]\\
\text{(5)}\quad & \gamma_3(k)=\gamma_1(k)+4\gamma_2(k) && [(3),(4)]\\
\text{(6)}\quad & \gamma_3(0)=0{,}5+4(2{,}30)=9{,}7 && [(5),\ k=0]\\
\text{(7)}\quad & \gamma_3(1)=0{,}2+4(-1{,}43)=-5{,}52 && [(5),\ k=1]\\
\text{(8)}\quad & \gamma_3(2)=0+4(0{,}30)=1{,}2 && [(5),\ k=2]\\
\text{(9)}\quad & \gamma_3(k)=0+0=0,\ k\ge3 && [(5)]\\
\text{(10)}\quad & \rho_1=-5{,}52/9{,}7=-0{,}5691;\quad \rho_2=1{,}2/9{,}7=0{,}1237 && [\div\gamma_3(0)]\\
\text{(11)}\quad & \text{nada depende de } t\ \Rightarrow\ \text{estacionário} && [\text{as três condições}]\\
\text{(12)}\quad & \text{FAC} \ne0 \text{ até } 2 \text{ e } =0 \text{ depois}\ \Rightarrow\ \text{MA(2)} && [\text{FAC que corta}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** A média é soma de constantes, então é constante: primeira condição de estacionariedade conferida.
- **(2)** Escrevo a definição antes de qualquer número. É ela que manda abrir os produtos.
- **(3)** Abro como $(A+2C)(D+2E)$: quatro termos. O 2 multiplica duas vezes no último, e por isso vira **4**. $C_{12}$ e $C_{21}$ são as covariâncias cruzadas.
- **(4)** A hipótese do enunciado, "não correlacionados", serve exatamente para zerar os cruzados. **Cite a hipótese.**
- **(5)** A fórmula final é uma regra de bolso: a constante sai **ao quadrado** na covariância.
- **(6)** Em $k=0$, as duas variâncias: a de $z_2$ entra multiplicada por 4.
- **(7)** Em $k=1$, as duas autocovariâncias de ordem 1. O sinal negativo vem de $z_2$ e domina.
- **(8)** Em $k=2$, só $z_2$ ainda tem memória, porque a FAC de $z_1$ já cortou em 1.
- **(9)** Daí em diante, as duas são zero, e a soma também: é o corte que decide a classe.
- **(10)** Normalizo para ter a FAC, que é o que se usa para classificar.
- **(11)** Fecho a pergunta "é estacionário?" com o critério, não com a intuição.
- **(12)** A classificação sai do **formato**: a FAC corta depois de 2. Um MA($q$) tem FAC que zera depois de $q$, porque os choques deixam de se sobrepor. Um AR nunca zera a FAC: ela decai sem chegar a zero. Logo, **MA(2)**, sem nenhum AR.

**Frase de fecho:** "$\gamma_3(k)=\gamma_1(k)+4\gamma_2(k)$ não depende de $t$, logo $z_3$ é estacionário. A FAC corta depois da defasagem 2, logo **$z_3$ é um MA(2)**."

### Erro que não pode

- **Classificar como "ARMA(1,2)":** foi o erro do Simulado 01, Q1 c) ([log](log_erros.md); [correção](correcao_simulado_01.md)). FAC que **corta** não tem AR.
- Usar $2\gamma_2$ em vez de $4\gamma_2$.
- Zerar os termos cruzados sem citar a hipótese.

### Confira com números

$\gamma_3=(9{,}7;\ -5{,}52;\ 1{,}2;\ 0)$, com $\rho_1=-0{,}5691$ e $\rho_2=0{,}1237$.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_c1_z3_g0 | 9,7 |
| ap_c1_z3_g1 | -5,52 |
| ap_c1_z3_g2 | 1,2 |
| ap_c1_z3_g3 | 0 |
| ap_c1_z3_rho1 | -0,5691 |
| ap_c1_z3_rho2 | 0,1237 |
-->

### Treino

- Em modo prova: [Simulado 02, Q2](simulado_02.md), com a correção no [gabarito](simulado_02_gabarito.md).
- Variação: [banco, Q3](banco.md#q3--soma-de-processos-estacionários).
- Folha à mão: [cap. 1](../apostila/a_mao_cap1.md).
- Nota comentada: [Q3](../lista_comentada/q03.md).

---

## 3 · Raízes: estacionariedade, invertibilidade e fator comum

**Enunciado-tipo** (lista, Q5). Para (2) $\tilde z_t=a_t-1{,}3a_{t-1}+0{,}4a_{t-2}$ e (3) $\tilde z_t-0{,}5\tilde z_{t-1}=a_t-1{,}3a_{t-1}+0{,}4a_{t-2}$: escreva em $B$, classifique e verifique estacionariedade e invertibilidade.

### O que a questão quer

- **Escrever em $B$** e dizer os graus de $\phi(B)$ e $\theta(B)$.
- **Verificar:** as raízes, a comparação com 1 e a frase.
- No modelo (3), perceber o **fator comum**.

### Antes de escrever

A variável da raiz é um **número**: uso $x$, nunca a série. Estacionariedade se olha em $\phi(x)$, e invertibilidade em $\theta(x)$.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & \tilde z_t=(1-1{,}3B+0{,}4B^2)\,a_t && [B^ja_t=a_{t-j}]\\
\text{(2)}\quad & \phi(B)=1,\ \theta(B) \text{ de grau 2}\ \Rightarrow\ \text{ARMA}(0,2) && [\text{classifica}]\\
\text{(3)}\quad & \text{MA finito}\ \Rightarrow\ \text{estacionário para quaisquer } \theta && [\text{AU02 p. 29}]\\
\text{(4)}\quad & \theta(x)=0\iff0{,}4x^2-1{,}3x+1=0:\ a=0{,}4,\ b=-1{,}3,\ c=1 && [\text{forma padrão}]\\
\text{(5)}\quad & \Delta=1{,}69-1{,}60=0{,}09 && [\text{Bhaskara}]\\
\text{(6)}\quad & x=\frac{1{,}3\pm0{,}3}{0{,}8}\ \Rightarrow\ x_1=2,\ x_2=1{,}25 && [\text{Bhaskara}]\\
\text{(7)}\quad & x_1+x_2=3{,}25=-b/a;\quad x_1x_2=2{,}5=c/a && [\text{Vieta: confere}]\\
\text{(8)}\quad & \lvert2\rvert\gt1,\ \lvert1{,}25\rvert\gt1\ \Rightarrow\ \text{invertível} && [\text{fora do círculo}]\\
\text{(9)}\quad & 1-1{,}3B+0{,}4B^2=(1-0{,}5B)(1-0{,}8B) && [\text{raízes } 2 \text{ e } 1{,}25]\\
\text{(10)}\quad & \text{(3)}:\ (1-0{,}5B)\tilde z_t=(1-0{,}5B)(1-0{,}8B)\,a_t && [(9)]\\
\text{(11)}\quad & \tilde z_t=(1-0{,}8B)\,a_t:\ \text{MA(1), não ARMA(1,2)} && [\text{fator comum cancela}]\\
\text{(12)}\quad & \pi_j=-0{,}8^{\,j}:\ -0{,}8;\ -0{,}64;\ -0{,}512 && [\text{MA(1) invertível}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** Trocar as defasagens por potências de $B$ transforma o modelo em polinômio, e um polinômio tem raízes.
- **(2)** A classificação é só ler os graus: $p$ do lado de $\tilde z$ e $q$ do lado de $a$.
- **(3)** Uma soma finita de choques tem variância finita e constante. Por isso todo MA é estacionário, e **não é preciso conta**.
- **(4)** Ponho o polinômio na forma $ax^2+bx+c$, para não errar sinal no Bhaskara.
- **(5)** O discriminante vem primeiro: positivo, então são duas raízes reais.
- **(6)** As duas raízes, $(-b\pm\sqrt\Delta)/2a$, com $\sqrt{0{,}09}=0{,}3$.
- **(7)** Vieta confere em dez segundos e pega erro de sinal.
- **(8)** A regra é raiz fora do círculo, $\lvert x\rvert\gt1$. Para um polinômio MA, isso significa que os choques podem ser recuperados do passado de $\tilde z$: invertível.
- **(9)** Cada raiz $r$ dá um fator $(1-B/r)$. Fatorar mostra o que está "dentro" do MA.
- **(10)** No modelo (3), o fator do AR, $(1-0{,}5B)$, **aparece também** no MA.
- **(11)** Fatores iguais nos dois lados se cancelam, como em uma fração: o "ARMA(1,2)" é, na verdade, um MA(1). Classifique **depois** de cancelar.
- **(12)** Os pesos $\pi$ existem e encolhem, confirmando a invertibilidade.

**Frase de fecho:** "As raízes de $\theta(x)$ são 2 e 1,25, ambas fora do círculo: o MA(2) é invertível, e, como todo MA, estacionário. No modelo (3), o fator $(1-0{,}5B)$ é comum aos dois lados e cancela: **o modelo é um MA(1)**."

### Erro que não pode

- **Escrever a raiz com a série**, como $\phi(z_t)=0$: foi o erro do Simulado 01, Q2 a) e Q3 a) ([log](log_erros.md)).
- Usar $\lvert\theta_1\rvert\lt1$ num MA(2): a regra do MA(1) não vale para grau 2.
- Classificar o modelo (3) como ARMA(1,2) sem procurar fator comum.

### Confira com números

- $\Delta=0{,}09$ e raízes 2 e 1,25, com a menor confirmada pelo `polyroot`;
- pesos do modelo (2): $\pi_1=-1{,}3$, $\pi_2=-1{,}29$;
- pesos do modelo (3): $\pi_1=-0{,}8$, $\pi_2=-0{,}64$.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_am2_q5m2_delta | 0,09 |
| ap_am2_q5m2_z1 | 2 |
| ap_am2_q5m2_z2 | 1,25 |
| ap_am2_q5m2_zmin_r | 1,25 |
| ap_am2_q5m2_pi1 | -1,3 |
| ap_am2_q5m2_pi2 | -1,29 |
| ap_am2_q5m3_pi1 | -0,8 |
| ap_am2_q5m3_pi2 | -0,64 |
| ap_am2_q5m3_pi3 | -0,512 |
-->

### Treino

- Em modo prova: [Simulado 02, Q3](simulado_02.md), com a correção no [gabarito](simulado_02_gabarito.md).
- Variação: [banco, Q5](banco.md#q5--classificar-raízes-e-pesos).
- Folha à mão: [cap. 2](../apostila/a_mao_cap2.md).
- Nota comentada: [Q5](../lista_comentada/q05.md).

---

## 4 · ARMA(1,1): $\gamma_0$, $\gamma_1$, FAC e pesos

**Enunciado-tipo** (lista, Q6; números do Simulado 01, Q2). Para $z_t-0{,}6z_{t-1}=a_t-0{,}3a_{t-1}$, com $\sigma_a^2=1$: calcule $\gamma_0$, $\gamma_1$ e $\gamma_2$; obtenha $\rho_1$ e mostre que $\rho_k=\phi\rho_{k-1}$; ache os três primeiros $\psi_j$ e $\pi_j$.

### O que a questão quer

- **$\gamma_0$ e $\gamma_1$** por um caminho que se possa justificar linha a linha: o dos momentos auxiliares.
- **"Mostre que $\rho_k=\phi\rho_{k-1}$"**: a conta para $k\ge2$ com o motivo de os choques sumirem.
- **Os pesos**, pelas fórmulas.

### Antes de escrever

1. **Definições:** $\gamma_0=E(z_t^2)$ é a **variância**, e $\gamma_1=E(z_tz_{t-1})$. Média zero.
2. **Convenção:** a da lista, $\phi=0{,}6$ e $\theta=0{,}3$. Nos slides, seria $\theta_1=-0{,}3$.
3. **Molde dos quatro movimentos:** multiplicar o modelo por $a_t$, por $a_{t-1}$, por $z_t$ e por $z_{t-1}$, tirando a esperança a cada vez.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & z_t=0{,}6z_{t-1}+a_t-0{,}3a_{t-1} && [\text{modelo isolado}]\\
\text{(2)}\quad & E(z_{t-k}a_t)=0 \text{ para } k\ge1 && [\text{caus.}]\\
\text{(3)}\quad & E(z_ta_t)=0{,}6\cdot0+E(a_t^2)-0{,}3\cdot0=1 && [(1)\times a_t;\ (2),\ \text{RB}]\\
\text{(4)}\quad & E(z_ta_{t-1})=0{,}6E(z_{t-1}a_{t-1})+0-0{,}3E(a_{t-1}^2)=0{,}6-0{,}3=0{,}3 && [(1)\times a_{t-1};\ (3)]\\
\text{(5)}\quad & \gamma_0=0{,}6E(z_{t-1}z_t)+E(a_tz_t)-0{,}3E(a_{t-1}z_t) && [(1)\times z_t]\\
\text{(6)}\quad & \gamma_0=0{,}6\gamma_1+\underbrace{1}_{(3)}-0{,}3\cdot\underbrace{0{,}3}_{(4)}=0{,}6\gamma_1+0{,}91 && [(3),(4);\ \text{estac.}]\\
\text{(7)}\quad & \gamma_1=0{,}6\gamma_0+E(a_tz_{t-1})-0{,}3E(a_{t-1}z_{t-1})=0{,}6\gamma_0-0{,}3 && [(1)\times z_{t-1};\ (2),(3)]\\
\text{(8)}\quad & \gamma_0=0{,}6(0{,}6\gamma_0-0{,}3)+0{,}91=0{,}36\gamma_0+0{,}73 && [(7)\text{ em }(6)]\\
\text{(9)}\quad & \gamma_0=0{,}73/0{,}64=1{,}1406 && [\text{isola}]\\
\text{(10)}\quad & \gamma_1=0{,}6(1{,}1406)-0{,}3=0{,}3844 && [(7)]\\
\text{(11)}\quad & \gamma_k=0{,}6\gamma_{k-1},\ k\ge2:\ \gamma_2=0{,}2306 && [(1)\times z_{t-k};\ (2)]\\
\text{(12)}\quad & \rho_1=\gamma_1/\gamma_0=0{,}337;\quad \rho_k=0{,}6\,\rho_{k-1} && [\div\gamma_0]\\
\text{(13)}\quad & \psi_j=(\phi-\theta)\phi^{j-1}:\ 0{,}3;\ 0{,}18;\ 0{,}108 && [\psi(B)=\theta(B)/\phi(B)]\\
\text{(14)}\quad & \pi_j=(\phi-\theta)\theta^{j-1}:\ 0{,}3;\ 0{,}09;\ 0{,}027 && [\pi(B)=\phi(B)/\theta(B)]\\
\text{(15)}\quad & \text{confere: } \tfrac{1+\theta^2-2\phi\theta}{1-\phi^2}=\tfrac{1+0{,}09-0{,}36}{0{,}64}=1{,}1406 && [\text{fórmula geral}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** Deixo $z_t$ sozinho, porque vou multiplicar essa equação por várias coisas e tirar a esperança.
- **(2)** É o fato que gera quase todos os zeros: $z$ do passado só tem choques do passado, que não se correlacionam com o choque de hoje.
- **(3)** **Primeiro momento auxiliar.** Multiplico por $a_t$ para saber quanto do choque de hoje está em $z_t$: exatamente uma unidade, que dá $\sigma^2=1$.
- **(4)** **Segundo momento auxiliar.** Multiplico por $a_{t-1}$: o choque de ontem entra em $z_t$ por dois caminhos, via $0{,}6z_{t-1}$, que vale $0{,}6\cdot1$, e via o MA, $-0{,}3$. Daí $\phi-\theta=0{,}3$. É o termo que se esquece.
- **(5)** Agora multiplico por $z_t$, **porque $\gamma_0=E(z_t^2)$**: quero $z_t\cdot z_t$ do lado esquerdo.
- **(6)** Substituo os três termos de (5):
  - $E(z_{t-1}z_t)$ é $\gamma_1$ **por estacionariedade**: a covariância só depende da distância entre as datas, que é 1;
  - $E(a_tz_t)=1$ vem de (3);
  - no último termo, o 0,3 **de fora** é o $\theta$ do modelo, e o 0,3 **de dentro** é o auxiliar (4), $\phi-\theta=0{,}6-0{,}3$. Com estes números, os dois coincidem **por acaso**: não decore como $\theta^2$.

  Em geral, $\gamma_0=\phi\gamma_1+\sigma^2-\theta(\phi-\theta)\sigma^2$. No [Simulado 02, Q4](simulado_02.md), com $\theta=0{,}2$, $\phi-\theta=0{,}3$ e $\sigma^2=2$, o último termo vale $0{,}2\cdot0{,}3\cdot2=0{,}12$, e não $\theta^2\sigma^2=0{,}08$. Sai uma equação com $\gamma_0$ e $\gamma_1$.
- **(7)** Multiplico por $z_{t-1}$, porque $\gamma_1=E(z_tz_{t-1})$. O choque $a_t$ some por (2), e o $a_{t-1}$ dá $-0{,}3\cdot1$ por (3) em $t-1$.
- **(8)** Tenho duas equações e duas incógnitas: substituo (7) em (6).
- **(9)** Resolvo $\gamma_0$, que é a variância de $z_t$.
- **(10)** Volto em (7) para $\gamma_1$.
- **(11)** Para $k\ge2$, os dois choques do modelo, $a_t$ e $a_{t-1}$, são **posteriores** a $z_{t-k}$, então os dois termos zeram. Sobra só a parte AR: é por isso que a FAC vira geométrica.
- **(12)** Divido por $\gamma_0$. A FAC decai à taxa $\phi$, mas **a partir de $\rho_1$**, não de 1: o MA só altera o primeiro valor.
- **(13)** Os $\psi$ dizem quanto um choque de $j$ períodos atrás pesa hoje. Saem de $\theta(B)/\phi(B)$, igualando os coeficientes.
- **(14)** Os $\pi$ dizem quanto o $z$ de $j$ períodos atrás pesa na reconstrução do choque. É o inverso, $\phi(B)/\theta(B)$.
- **(15)** Confiro com a fórmula geral. Se der diferente, o erro está nos auxiliares.

**Frase de fecho:** "$\gamma_0=1{,}1406$, $\gamma_1=0{,}3844$ e, para $k\ge2$, $\gamma_k=\phi\gamma_{k-1}$ porque os choques do modelo são posteriores a $z_{t-k}$; **logo $\rho_k=\phi\rho_{k-1}=\phi^{k-1}\rho_1$**. Os $\psi$ convergem porque $\lvert\phi\rvert\lt1$, e os $\pi$, porque $\lvert\theta\rvert\lt1$."

### Erro que não pode

- **"$\gamma_0=\operatorname{Cov}(z_t,z_{t-1})$"**: foi aqui que o Simulado 01 travou ([correção](correcao_simulado_01.md); [log](log_erros.md)). $\gamma_0$ é a variância.
- **Esquecer o termo $-2\phi\theta$**, que vem do segundo auxiliar (4), e perder o quadrado de $\theta$, como no caderno de 02/09.
- **Ler o $0{,}3(0{,}3)$ da linha (6) como $\theta^2$:** o segundo fator é o auxiliar $\phi-\theta$, que aqui vale 0,3 por coincidência.
- Escrever $\rho_k=\phi^k\rho_1$: o expoente é $k-1$.

### Confira com números

$\gamma_0=1{,}1406$; $\gamma_1=0{,}3844$; $\gamma_2=0{,}2306$; $\rho_1=0{,}337$; $\psi$: 0,3; 0,18; 0,108; $\pi$: 0,3; 0,09; 0,027.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s1_q2_g0 | 1,1406 |
| pv_s1_q2_g1 | 0,3844 |
| pv_s1_q2_g2 | 0,2306 |
| pv_s1_q2_rho1 | 0,337 |
| pv_s1_q2_psi1 | 0,3 |
| pv_s1_q2_psi2 | 0,18 |
| pv_s1_q2_psi3 | 0,108 |
| pv_s1_q2_pi1 | 0,3 |
| pv_s1_q2_pi2 | 0,09 |
| pv_s1_q2_pi3 | 0,027 |
-->

### Treino

- Em modo prova: [Simulado 02, Q4](simulado_02.md), com a correção no [gabarito](simulado_02_gabarito.md).
- Variação: [banco, Q6](banco.md#q6--arma11): refaça com $\phi=0{,}9$ e $\theta=0{,}5$, que dá $\rho_1=0{,}6286$.
- Folha à mão: [cap. 2](../apostila/a_mao_cap2.md) e a [Q6 completa](../lista_comentada/a_mao_q02_q06.md).
- Nota comentada: [Q6](../lista_comentada/q06.md).

---

## 5 · AR(2): Yule-Walker e a variância

> [!WARNING]
> **Não cai:** Yule-Walker foi riscado no quadro de 04/11. Pule esta questão-tipo.

**Enunciado-tipo** (lista, Q7; o exemplo do caderno). Para $y_t=1{,}5y_{t-1}-0{,}6y_{t-2}+\varepsilon_t$, com $\sigma^2=1$: escreva as equações de Yule-Walker, obtenha $\rho_1$ e $\rho_2$ e calcule $\gamma_0$.

### O que a questão quer

- **As equações de Yule-Walker** escritas, e só depois resolvidas.
- **A variância** pela equação de $\gamma_0$.

### Antes de escrever

É o mesmo molde do ARMA, mais simples: não há MA, então basta **um** auxiliar, $E(\varepsilon_ty_t)=\sigma^2$. O lado AR é igual na lista e nos slides.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & E(\varepsilon_ty_{t-k})=0,\ k\ge1;\qquad E(\varepsilon_ty_t)=\sigma^2 && [\text{caus.; RB}]\\
\text{(2)}\quad & \times y_{t-1}:\ \gamma_1=\phi_1\gamma_0+\phi_2\gamma_1 && [(1)]\\
\text{(3)}\quad & \times y_{t-2}:\ \gamma_2=\phi_1\gamma_1+\phi_2\gamma_0 && [(1)]\\
\text{(4)}\quad & \rho_1=\phi_1+\phi_2\rho_1;\qquad \rho_2=\phi_1\rho_1+\phi_2 && [\div\gamma_0:\ \text{Yule-Walker}]\\
\text{(5)}\quad & \rho_1=\frac{\phi_1}{1-\phi_2}=\frac{1{,}5}{1{,}6}=0{,}9375 && [\text{isola na 1ª}]\\
\text{(6)}\quad & \rho_2=1{,}5(0{,}9375)-0{,}6=0{,}80625 && [\text{2ª}]\\
\text{(7)}\quad & \times y_t:\ \gamma_0=\phi_1\gamma_1+\phi_2\gamma_2+\sigma^2 && [(1)]\\
\text{(8)}\quad & \gamma_0=\frac{\sigma^2}{1-\phi_1\rho_1-\phi_2\rho_2} && [\div\gamma_0 \text{ e isola}]\\
\text{(9)}\quad & \gamma_0=\frac{1}{1-1{,}40625+0{,}48375}=\frac{1}{0{,}0775}=12{,}90 && [(5),(6)]\\
\text{(10)}\quad & \gamma_0=\frac{(1-\phi_2)\sigma^2}{(1+\phi_2)\big[(1-\phi_2)^2-\phi_1^2\big]}=\frac{1{,}6}{0{,}4(0{,}31)}=12{,}90 && [\text{fórmula fechada}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** São os únicos fatos sobre o choque que se usam: ele não conversa com o passado de $y$ e, com $y_t$ de hoje, vale $\sigma^2$.
- **(2)** Multiplico por $y_{t-1}$ para fazer $\gamma_1$ aparecer à esquerda. Como $y_{t-2}\cdot y_{t-1}$ também está a uma defasagem, dá $\gamma_1$.
- **(3)** O mesmo com $y_{t-2}$, para ter uma segunda equação.
- **(4)** Dividindo por $\gamma_0$, viram as equações de Yule-Walker, em correlações. É isso que a questão chama de "escrever as equações".
- **(5)** A primeira equação só tem $\rho_1$ como incógnita: isolo.
- **(6)** Com $\rho_1$, a segunda dá $\rho_2$ direto.
- **(7)** Para a variância, multiplico por $y_t$: é a única vez em que o choque sobrevive, com $E(\varepsilon_ty_t)=\sigma^2$.
- **(8)** Divido por $\gamma_0$ e isolo: a variância é $\sigma^2$ dividido pelo que "sobra" depois da parte explicada pelo passado.
- **(9)** Substituo os números.
- **(10)** Confiro pela fórmula fechada. Os três fatores do denominador são as três desigualdades do triângulo de estacionariedade.

**Frase de fecho:** "As equações de Yule-Walker são $\rho_1=\phi_1+\phi_2\rho_1$ e $\rho_2=\phi_1\rho_1+\phi_2$, que dão $\rho_1=0{,}9375$ e $\rho_2=0{,}80625$. **A variância é $\gamma_0=\sigma^2/(1-\phi_1\rho_1-\phi_2\rho_2)=12{,}90$**, finita porque o processo está dentro do triângulo."

### Erro que não pode

- **Trocar o sinal de $\phi_2$** ao montar o polinômio: o certo é $1-1{,}5B+0{,}6B^2$ (o erro do caderno de 03/09).
- Esquecer o $\sigma^2$ em (7): é o único lugar onde o choque aparece.

### Confira com números

$\rho_1=0{,}9375$; $\rho_2=0{,}80625$; $\gamma_0=12{,}9032$, pelos três caminhos.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_am2_q7_rho1 | 0,9375 |
| ap_am2_q7_rho2 | 0,80625 |
| ap_am2_q7_g0_rho | 12,90 |
| ap_am2_q7_g0_formula | 12,90 |
| ap_am2_q7_g0_r | 12,90 |
-->

### Treino

- Em modo prova: [Simulado 02, Q5](simulado_02.md), com a correção no [gabarito](simulado_02_gabarito.md).
- Variação: [banco, Q7](banco.md#q7--ar2-e-yule-walker).
- Folha à mão: [cap. 2](../apostila/a_mao_cap2.md).
- Nota comentada: [Q7](../lista_comentada/q07.md).

---

## 6 · Sobrediferenciação: a forma ARMA de $\Delta y_t$ e a raiz 1

**Enunciado-tipo** (lista, Q9; números do Simulado 01, Q3). Para $y_t=0{,}5y_{t-1}+\varepsilon_t$, com $\sigma^2=1$, e $w_t=\Delta y_t$:
- mostre que $(1-0{,}5B)w_t=(1-B)\varepsilon_t$ e que $w_t$ não é invertível;
- calcule $\operatorname{Var}(w_t)$ e $\rho_1(w)$;
- diga as consequências de diferenciar.

### O que a questão quer

- **"Mostre"**: derivar a forma pedida; ela não pode ser copiada.
- **"Por que não é invertível"**: a raiz do MA e a consequência, sem AR($\infty$).
- **Números** e duas consequências, uma de estimação e outra de previsão.

### Antes de escrever

O molde é o do **polinômio em $B$**: aplicar o mesmo operador **aos dois lados** de uma equação verdadeira.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & w_t=y_t-y_{t-1}=(0{,}5y_{t-1}+\varepsilon_t)-y_{t-1} && [\text{definição; modelo}]\\
\text{(2)}\quad & w_t=-0{,}5\,y_{t-1}+\varepsilon_t && [\text{agrupa}]\\
\text{(3)}\quad & (1-0{,}5B)\,y_t=\varepsilon_t && [\text{modelo em } B]\\
\text{(4)}\quad & (1-B)(1-0{,}5B)\,y_t=(1-B)\,\varepsilon_t && [\times(1-B) \text{ dos dois lados}]\\
\text{(5)}\quad & (1-0{,}5B)\,w_t=(1-B)\,\varepsilon_t && [\text{comuta}; (1-B)y_t=w_t]\\
\text{(6)}\quad & \theta(x)=1-x=0\ \Rightarrow\ x=1,\ \lvert x\rvert=1 && [\text{raiz no círculo}]\\
\text{(7)}\quad & \pi(B)=\tfrac{1-0{,}5B}{1-B}=1-0{,}5(B+B^2+\cdots) && [\text{pesos não encolhem}]\\
\text{(8)}\quad & \operatorname{Var}(w_t)=2\gamma_0-2\gamma_1=2\gamma_0(1-\phi)=\tfrac{2\sigma^2}{1+\phi}=1{,}3333 && [\gamma_1=\phi\gamma_0]\\
\text{(9)}\quad & \operatorname{Var}(y_t)=\sigma^2/(1-\phi^2)=1/0{,}75=1{,}3333 && [\text{AR(1)}]\\
\text{(10)}\quad & \rho_1(w)=-\tfrac{1-\phi}{2}=-0{,}25 && [\text{assinatura}]\\
\text{(11)}\quad & \text{estimação: } \widehat\theta \text{ encosta em } 1;\ \text{previsão: variância que cresce} && [\text{consequências}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** Começo pela **definição** de $w_t$ e substituo o modelo **deste** problema, não o do passeio.
- **(2)** Sai a primeira forma pedida: a diferença depende de $y_{t-1}$, porque o processo volta para a média.
- **(3)** Escrevo o modelo com o operador: é o ponto de partida do segundo caminho.
- **(4)** Uma igualdade continua valendo se aplico o mesmo operador aos dois lados. Escolho $(1-B)$ porque é ele que cria $w_t$.
- **(5)** Polinômios em $B$ comutam, e $(1-B)y_t$ é $w_t$. Chego à forma pedida **derivando**: um ARMA(1,1) com $\theta=1$.
- **(6)** A raiz do MA é exatamente 1, **sobre** o círculo, não fora dele.
- **(7)** O sentido da não invertibilidade: os pesos para reconstruir o choque a partir do passado de $w$ não diminuem, e a soma não converge. **Não existe AR($\infty$).**
- **(8)** Uso $\operatorname{Var}(a-b)=\operatorname{Var}(a)+\operatorname{Var}(b)-2\operatorname{Cov}(a,b)$, com $\gamma_1=\phi\gamma_0$ do AR(1).
- **(9)** Comparo com a variância do nível: diferenciar **não reduziu** a variância, e com $\phi\lt0{,}5$ ela até aumentaria.
- **(10)** O $\rho_1$ negativo é a assinatura da sobrediferenciação. No limite $\phi=0$, vale exatamente $-0{,}5$.
- **(11)** O que se perde na prática: a estimação do MA fica na fronteira, e a previsão trata o choque como permanente, quando a série original volta para a média.

**Frase de fecho:** "$(1-0{,}5B)w_t=(1-B)\varepsilon_t$ tem a raiz do MA em $x=1$, sobre o círculo: **$w_t$ não é invertível e não tem AR($\infty$) convergente**. Diferenciar uma série estacionária não reduz a variância, cria $\rho_1=-0{,}25$ e piora a estimação e a previsão."

### Erro que não pode

- **"$y_t-y_{t-1}=\varepsilon_t$"**, que é a conta do passeio, e **copiar a forma do enunciado** sem derivar: foi o Simulado 01, Q3 a) ([log](log_erros.md)).
- Parar em "$\theta=1$" sem a conclusão "não invertível, sem AR($\infty$)": a conclusão vale 0,3.

### Confira com números

$\operatorname{Var}(w)=1{,}3333=\operatorname{Var}(y)$; $\rho_1(w)=-0{,}25$; raiz do MA $=1$.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s1_q3_var_w | 1,3333 |
| pv_s1_q3_var_y | 1,3333 |
| pv_s1_q3_rho1_w | -0,25 |
| pv_s1_q3_raiz_ma | 1 |
-->

### Treino

- Em modo prova: [Simulado 02, Q6](simulado_02.md), com a correção no [gabarito](simulado_02_gabarito.md).
- Variação: [banco, Q9](banco.md#q9--sobrediferenciação).
- Folha à mão: [cap. 3](../apostila/a_mao_cap3.md).
- Nota comentada: [Q9](../lista_comentada/q09.md).

---

## 7 · AIC, BIC e o MQO do AR(1)

**Enunciado-tipo** (lista, Q13 e Q14; números do Simulado 01, Q4). Com $T=200$ e média zero, as log-verossimilhanças são:
- AR(1): $-301{,}2$;
- ARMA(1,1): $-299{,}8$;
- AR(2): $-298{,}9$;
- AR(3): $-297{,}0$.

Use $\ln200=5{,}2983$, com $k$ incluindo $\sigma^2$, e escolha um modelo por cada critério. Depois, num AR(1) com $T=101$ e as somas de $t=2$ a $T$ ($\sum y_ty_{t-1}=84$, $\sum y_{t-1}^2=120$, $\sum y_t^2=130$), obtenha $\widehat\phi$ e $\widehat\sigma^2$.

### O que a questão quer

- **Oito números**, quatro AIC e quatro BIC, e **qual vence em cada um**, com a razão de discordarem.
- **Duas divisões** para o MQO.

### Antes de escrever

São **contas curtas, para fazer primeiro**. O menor critério vence. $k=p+q+1$, porque o $+1$ é o $\sigma^2$.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & k:\ \text{AR(1) } 2;\ \text{ARMA(1,1) } 3;\ \text{AR(2) } 3;\ \text{AR(3) } 4 && [p+q+1]\\
\text{(2)}\quad & -2\ln L:\ 602{,}4;\ 599{,}6;\ 597{,}8;\ 594{,}0 && [\times(-2)]\\
\text{(3)}\quad & AIC=-2\ln L+2k:\ 606{,}4;\ 605{,}6;\ 603{,}8;\ 602{,}0 && [(1),(2)]\\
\text{(4)}\quad & BIC=-2\ln L+k\ln T:\ 613{,}0;\ 615{,}5;\ 613{,}7;\ 615{,}2 && [\ln200=5{,}2983]\\
\text{(5)}\quad & \min AIC:\ \text{AR(3)};\qquad \min BIC:\ \text{AR(1)} && [\text{o menor vence}]\\
\text{(6)}\quad & \text{multa por parâmetro: } 2 \text{ (AIC)} \times 5{,}30 \text{ (BIC)} && [\text{por que discordam}]\\
\text{(7)}\quad & \ln L(\phi,\sigma^2\mid y_1)=-\tfrac{T-1}{2}\ln(2\pi\sigma^2)-\tfrac{1}{2\sigma^2}\textstyle\sum_{t=2}^{T}(y_t-\phi y_{t-1})^2 && [\text{condicional em } y_1]\\
\text{(8)}\quad & \widehat\phi=\frac{\sum y_ty_{t-1}}{\sum y_{t-1}^2}=\frac{84}{120}=0{,}7 && [\text{CPO: } \max\ln L=\min\text{SQR}]\\
\text{(9)}\quad & \widehat\sigma^2=\frac{\sum y_t^2-\widehat\phi\sum y_ty_{t-1}}{T-1}=\frac{130-58{,}8}{100}=0{,}712 && [\text{SQR}/(T-1)]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** Conto os parâmetros que o modelo estimou: os coeficientes AR e MA **e** a variância do erro. Errar $k$ muda os números.
- **(2)** Os critérios usam $-2\ln L$: quanto **menor**, melhor o ajuste. O maior $\ln L$ é o **menos negativo**.
- **(3)** O AIC soma ao ajuste uma multa de 2 por parâmetro.
- **(4)** O BIC soma uma multa de $\ln T$ por parâmetro, que aqui é 5,30, mais pesada.
- **(5)** Em cada critério, o menor vence. Os dois discordam: o AIC aceita o AR(3), e o BIC prefere o AR(1).
- **(6)** A explicação pedida: o BIC pune mais e é **consistente**, porque acha o modelo verdadeiro quando ele está na lista. O AIC é **eficiente** para prever, mas tende a sobreparametrizar.
- **(7)** Condicionando em $y_1$, cada $y_t$ é normal com média $\phi y_{t-1}$. A log-verossimilhança tem $T-1$ termos.
- **(8)** Maximizar $\ln L$ em $\phi$ é minimizar a soma de quadrados, que é exatamente o MQO. São duas somas e uma divisão.
- **(9)** A variância é a soma dos quadrados dos resíduos dividida por $T-1$. O atalho $\sum y_t^2-\widehat\phi\sum y_ty_{t-1}$ evita calcular resíduo por resíduo.

**Frase de fecho:** "**O AIC escolhe o AR(3) (602,0) e o BIC escolhe o AR(1) (613,0).** Eles discordam porque a multa do BIC, $\ln200=5{,}30$, é maior que a do AIC, 2. O BIC é consistente; o AIC, eficiente para previsão. No AR(1), a MV condicional coincide com o MQO: $\widehat\phi=0{,}7$ e $\widehat\sigma^2=0{,}712$."

### Erro que não pode

- **Escolher pelo $\ln L$ sem calcular AIC e BIC**, e deixar o MQO em branco: os dois aconteceram no Simulado 01, Q4 ([log](log_erros.md)).
- Esquecer o $\sigma^2$ em $k$.
- Esquecer o sinal de $-2\ln L$.

### Confira com números

| Modelo | AIC | BIC |
|---|---|---|
| AR(1) | 606,4 | **613,0** |
| ARMA(1,1) | 605,6 | 615,5 |
| AR(2) | 603,8 | 613,7 |
| AR(3) | **602,0** | 615,2 |

Os critérios do R são 606,4 e 613,0 para o AR(1); $\widehat\phi=0{,}7$ e $\widehat\sigma^2=0{,}712$.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s1_q4_aic_ar1 | 606,4 |
| pv_s1_q4_aic_arma11 | 605,6 |
| pv_s1_q4_aic_ar2 | 603,8 |
| pv_s1_q4_aic_ar3 | 602,0 |
| pv_s1_q4_bic_ar1 | 613,0 |
| pv_s1_q4_bic_arma11 | 615,5 |
| pv_s1_q4_bic_ar2 | 613,7 |
| pv_s1_q4_bic_ar3 | 615,2 |
| pv_s1_q4_ln200 | 5,2983 |
| pv_s1_q4_phi | 0,7 |
| pv_s1_q4_s2 | 0,712 |
-->

### Treino

- Em modo prova: [Simulado 02, Q7](simulado_02.md), com a correção no [gabarito](simulado_02_gabarito.md).
- Variações: [banco, Q14](banco.md#q14--aic-e-bic) e [banco, Q13](banco.md#q13--mv-condicional-do-ar1).
- Folha à mão: [cap. 4](../apostila/a_mao_cap4.md).
- Notas comentadas: [Q13](../lista_comentada/q13.md) e [Q14](../lista_comentada/q14.md).

---

## 8 · Previsão: AR(1), erro, variância e intervalo

**Enunciado-tipo** (lista, Q15; números do Simulado 01, Q5). Seja $y_t-10=0{,}8(y_{t-1}-10)+a_t$, com $\sigma_a^2=4$ e $y_T=12$. Calcule:
- as previsões para $h=1,2,3$;
- o erro e a sua variância;
- os intervalos de 95%;
- o limite quando $h\to\infty$.

### O que a questão quer

- As **previsões**, uma de cada vez e depois a fórmula geral.
- O **erro como MA($h-1$)** e a variância.
- Os **intervalos**.
- O **limite**: a previsão volta à média, e a variância tende a $\gamma_0$.

### Antes de escrever

Escreva **o modelo na data futura** e aplique as três regras:
1. o que já é conhecido em $T$ fica;
2. choque futuro vira zero;
3. $y$ futuro vira a sua previsão.

Aqui, $\mu=10$, $\phi=0{,}8$ e $\psi_j=\phi^j$.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & y_{T+1}-10=0{,}8(y_T-10)+a_{T+1} && [\text{modelo em } T+1]\\
\text{(2)}\quad & \widehat y(1)=10+0{,}8(12-10)=11{,}6 && [a_{T+1}\to0]\\
\text{(3)}\quad & \widehat y(2)=10+0{,}8\big(\widehat y(1)-10\big)=11{,}28 && [y_{T+1}\to\widehat y(1)]\\
\text{(4)}\quad & \widehat y(h)=10+0{,}8^h(y_T-10):\ \widehat y(3)=11{,}024 && [\text{fórmula geral}]\\
\text{(5)}\quad & e(1)=a_{T+1};\qquad e(2)=a_{T+2}+0{,}8\,a_{T+1} && [y-\widehat y]\\
\text{(6)}\quad & e(h)=\textstyle\sum_{j=0}^{h-1}\psi_j\,a_{T+h-j}:\ \text{MA}(h-1) && [\psi_j=0{,}8^j]\\
\text{(7)}\quad & \operatorname{Var}(e(h))=\sigma^2\textstyle\sum_{j=0}^{h-1}\psi_j^2:\ 4;\ 6{,}56;\ 8{,}1984 && [\text{RB}]\\
\text{(8)}\quad & h=1:\ 11{,}6\pm1{,}96(2)=[7{,}68;\ 15{,}52] && [\pm1{,}96\sqrt{\operatorname{Var}}]\\
\text{(9)}\quad & h=2:\ 11{,}28\pm1{,}96\sqrt{6{,}56}=[6{,}26;\ 16{,}30] && [\text{idem}]\\
\text{(10)}\quad & h\to\infty:\ \widehat y\to10,\quad \operatorname{Var}\to\tfrac{\sigma^2}{1-\phi^2}=11{,}11 && [0{,}8^h\to0]\\
\text{(11)}\quad & E_T\big((y-g)^2\big)=\operatorname{Var}_T(y)+(m-g)^2\ge\operatorname{Var}_T(y) && [\text{EQM mínimo em } g=m]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** Começo escrevendo o modelo **na data que quero prever**. É a regra que impede de misturar horizontes, o erro do caderno de 26/08.
- **(2)** $y_T$ é conhecido e fica; $a_{T+1}$ é futuro, e a melhor aposta é zero. Sai a previsão de um passo.
- **(3)** Para $T+2$, $y_{T+1}$ ainda não aconteceu, então uso a previsão dele: a recursão.
- **(4)** Repetindo, o desvio da média é multiplicado por 0,8 a cada passo: o "elástico" que puxa para 10.
- **(5)** O erro é o real menos o previsto. Em dois passos, entram os dois choques futuros, e o de $T+1$ chega pesado por 0,8.
- **(6)** Em geral, o erro de $h$ passos tem $h$ choques futuros, com os pesos $\psi$: é um MA($h-1$). É o que o item pede para "mostrar".
- **(7)** Pelo RB, a variância é $\sigma^2$ vezes a soma dos $\psi^2$: $4(1)$, $4(1+0{,}64)$, $4(1+0{,}64+0{,}4096)$. O leque abre.
- **(8)** Intervalo de 95% com erro normal: previsão mais ou menos 1,96 **desvios-padrão**, a **raiz** da variância.
- **(9)** O mesmo em $h=2$: o intervalo alarga.
- **(10)** No longo prazo, a previsão volta à média, e a variância para de crescer em $\gamma_0$: não se sabe nada além da média.
- **(11)** Por que a esperança condicional é o previsor ótimo: qualquer outro $g$ paga $(m-g)^2$ a mais.

**Frase de fecho:** "As previsões são 11,6; 11,28; 11,024, e $\widehat y(h)=10+0{,}8^h(12-10)\to10$. O erro de $h$ passos é um MA($h-1$), com variância $\sigma^2\sum_{j\lt h}0{,}8^{2j}$, que tende a $\gamma_0=11{,}11$. **Os intervalos de 95% são [7,68; 15,52] e [6,26; 16,30].**"

### Erro que não pode

- **Deixar em branco:** a questão inteira ficou em branco no Simulado 01 ([correção](correcao_simulado_01.md)), e são contas de uma linha.
- Usar a variância, e não o desvio-padrão, no intervalo.
- Esquecer o $\psi_0=1$ na soma.

### Confira com números

| | $h=1$ | $h=2$ | $h=3$ |
|---|---|---|---|
| previsão | 11,6 | 11,28 | 11,024 |
| variância do erro | 4 | 6,56 | 8,1984 |

O intervalo de 95% é [7,68; 15,52] em $h=1$ e [6,26; 16,30] em $h=2$; a variância tende a 11,11.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s1_q5_f1 | 11,6 |
| pv_s1_q5_f2 | 11,28 |
| pv_s1_q5_f3 | 11,024 |
| pv_s1_q5_v1 | 4 |
| pv_s1_q5_v2 | 6,56 |
| pv_s1_q5_v3 | 8,1984 |
| pv_s1_q5_li1 | 7,68 |
| pv_s1_q5_ls1 | 15,52 |
| pv_s1_q5_li2 | 6,26 |
| pv_s1_q5_ls2 | 16,30 |
| pv_s1_q5_vinf | 11,11 |
-->

### Treino

- Em modo prova: [Simulado 02, Q8](simulado_02.md), com a correção no [gabarito](simulado_02_gabarito.md).
- Variação: [banco, Q15](banco.md#q15--previsão-em-arma).
- Folha à mão: [cap. 5](../apostila/a_mao_cap5.md).
- Nota comentada: [Q15](../lista_comentada/q15.md).

---

## 9 · SARIMA: escrever, contar e reconhecer pela FAC

**Enunciado-tipo** (lista, Q16; números do Simulado 01, Q6). Uma série mensal com $T=180$ foi identificada como SARIMA$(0,1,1)(0,1,1)_{12}$, com $\theta=0{,}4$ e $\Theta=0{,}6$. Pede-se:
- escrever o modelo e expandir o MA;
- contar os parâmetros e as observações;
- a FAC de $w_t$ em 1, 11, 12 e 13;
- o critério de comparação.

### O que a questão quer

- **O modelo** com os quatro polinômios e o MA expandido.
- **Duas contagens.**
- **Quatro números da FAC** e o padrão, com a descrição da FACP.
- **Um critério** e o motivo.

### Antes de escrever

$s=12$ e $d=D=1$. As contagens são as primeiras contas a fazer: perdas $d+sD$ e parâmetros $p+q+P+Q+1$.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & (1-B)(1-B^{12})\,y_t=(1-\theta B)(1-\Theta B^{12})\,a_t && [\text{SARIMA}]\\
\text{(2)}\quad & (1-0{,}4B)(1-0{,}6B^{12})=1-0{,}4B-0{,}6B^{12}+0{,}24B^{13} && [\text{quatro produtos}]\\
\text{(3)}\quad & w_t=(1-B)(1-B^{12})y_t=y_t-y_{t-1}-y_{t-12}+y_{t-13} && [\text{expande}]\\
\text{(4)}\quad & w_t=a_t-0{,}4a_{t-1}-0{,}6a_{t-12}+0{,}24a_{t-13} && [(1),(2),(3)]\\
\text{(5)}\quad & \text{parâmetros: } \theta,\ \Theta,\ \sigma^2=3 && [p+q+P+Q+1]\\
\text{(6)}\quad & \text{perdas: } d+sD=1+12=13;\ \text{sobram } 167 && [w_t \text{ usa } y_{t-13}]\\
\text{(7)}\quad & \gamma_0=\sigma^2(1+\theta^2)(1+\Theta^2) && [\text{soma dos } \psi^2]\\
\text{(8)}\quad & \rho_1=\frac{-\theta}{1+\theta^2}=-0{,}3448 && [\text{par } (0,1)\ (12,13)]\\
\text{(9)}\quad & \rho_{12}=\frac{-\Theta}{1+\Theta^2}=-0{,}4412 && [\text{par } (0,12)\ (1,13)]\\
\text{(10)}\quad & \rho_{11}=\rho_{13}=\rho_1\rho_{12}=0{,}1521 && [\text{satélites}]\\
\text{(11)}\quad & \rho_k=0 \text{ fora de } 1,11,12,13 && [\text{nenhum par}]\\
\text{(12)}\quad & \text{FACP: decai perto de 1 e de 12, 24} && [\text{MA nas duas escalas}]\\
\text{(13)}\quad & \text{rival aninhado: BIC e } LR\sim\chi^2(1),\ \text{crítico } 3{,}84;\ \text{mesmo } T && [\text{critério}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** O modelo junta duas diferenças, a comum e a sazonal, e dois MA, o comum e o sazonal. Na lista, o sinal do MA é negativo.
- **(2)** Multiplico os dois MA termo a termo. O produto $(-0{,}4)(-0{,}6)=+0{,}24$ aparece na defasagem 13: **ninguém escolheu esse termo**, ele é imposto.
- **(3)** Chamo de $w_t$ a série depois das duas diferenças. É nela que se lê a FAC.
- **(4)** $w_t$ é um MA com choques só em 1, 12 e 13.
- **(5)** Conto o que é **estimado**: $\theta$, $\Theta$ e $\sigma^2$. O 0,24 não conta, porque é o produto dos dois.
- **(6)** Para calcular $w_t$ é preciso $y_{t-13}$: as 13 primeiras observações não têm $w$.
- **(7)** A variância de $w$ é $\sigma^2$ vezes a soma dos quadrados dos pesos, que fatora como produto.
- **(8)** $\rho_1$ vem dos pares de choques a uma defasagem de distância. O fator sazonal aparece em cima e embaixo e cancela.
- **(9)** O mesmo para a defasagem 12: é o pico sazonal.
- **(10)** As defasagens 11 e 13 recebem o **produto** dos dois picos: são os satélites, a assinatura do multiplicativo.
- **(11)** Em qualquer outra defasagem, nenhum par de choques coincide: a FAC é zero.
- **(12)** Como há MA nas duas escalas, a FACP não corta: decai perto de 1 e em torno de 12, 24.
- **(13)** O rival contém o modelo, porque fazer $\phi=0$ volta ao original. O BIC pune o parâmetro a mais, e o LR testa com crítico 3,84. A comparação só vale com o mesmo $T$, que aqui é o mesmo, porque $d$ e $D$ são iguais.

**Frase de fecho:** "São **3 parâmetros**, $\theta$, $\Theta$ e $\sigma^2$, e **167 observações efetivas**. A FAC de $w_t$ tem $\rho_1=-0{,}3448$, o pico $\rho_{12}=-0{,}4412$ e os satélites $\rho_{11}=\rho_{13}=0{,}1521$, com zero no resto: a assinatura do SARIMA$(0,1,1)(0,1,1)_{12}$. Para comparar com o rival aninhado, uso o BIC, com o LR como confirmação."

### Erro que não pode

- **Deixar a questão em branco:** aconteceu no Simulado 01, Q6 ([correção](correcao_simulado_01.md)), e as contagens (5)–(6) são de uma linha.
- Contar o 0,24 como parâmetro.
- Esquecer o $\sigma^2$.
- Errar o sinal do termo cruzado: $(-\theta)(-\Theta)=+\theta\Theta$.

### Confira com números

| Item | Valor |
|---|---|
| perdas | 13 |
| observações efetivas | 167 |
| $\rho_1$ | $-0{,}3448$ |
| $\rho_{12}$ | $-0{,}4412$ |
| $\rho_{11}=\rho_{13}$ | 0,1521 |
| $\rho_2$ | 0 |
| crítico do LR | 3,84 |

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s1_q6_perda | 13 |
| pv_s1_q6_efetivas | 167 |
| pv_s1_q6_rho1 | -0,3448 |
| pv_s1_q6_rho12 | -0,4412 |
| pv_s1_q6_rho11 | 0,1521 |
| pv_s1_q6_rho13 | 0,1521 |
| pv_s1_q6_rho2 | 0 |
| ap_c6_lr_crit | 3,84 |
-->

### Treino

- Em modo prova: [Simulado 02, Q9](simulado_02.md), com a correção no [gabarito](simulado_02_gabarito.md).
- Variação: [banco, Q16](banco.md#q16--sarima-mensal).
- Folha à mão: [cap. 6](../apostila/a_mao_cap6.md).
- Nota comentada: [Q16](../lista_comentada/q16.md).
