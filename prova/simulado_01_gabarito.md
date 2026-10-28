---
title: "Simulado 01 — gabarito com rubrica"
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
  - simulado
aliases:
  - Gabarito do Simulado 01 — séries temporais
---

# Simulado 01 — gabarito

Enunciado em [simulado_01.md](simulado_01.md). Todos os números saem de [prova.R](prova.R).

> [!TIP]
> **Como se corrigir**
> Some os pontos **por passo**, pelo que você escreveu, não pelo que sabia. Fórmula geral escrita e aplicada com erro de conta ainda vale o passo da fórmula. Número certo sem fórmula nem justificativa vale metade. Cada passo que faltou vira uma linha no [log de erros](log_erros.md).

---

## Questão 1 (1,5)

*Origem na lista:* itens a) e b): (lista, Q1); item c): (lista, Q3).

### a) Momentos do passeio sem drift (0,5)

Por substituição recursiva, $y_t=y_0+\sum_{j=1}^{t}u_j$. Então:
- $E(y_t)=y_0+\sum_j E(u_j)=2$ *[RB: $E(u_j)=0$]*;
- $\operatorname{Var}(y_t)=\sum_{j=1}^t\operatorname{Var}(u_j)=t\sigma^2$ *[RB: choques não correlacionados; $y_0$ fixo]*;
- $\operatorname{Cov}(y_t,y_{t-k})=\operatorname{Cov}\big(\sum_{j=1}^t u_j,\sum_{i=1}^{t-k}u_i\big)=(t-k)\sigma^2$ *[só os $t-k$ choques comuns contam]*.

**Conclusão:** a média é constante, mas variância e covariância dependem de $t$. **O processo não é estacionário.**

| Rubrica | Pontos |
|---|---|
| Solução recursiva $y_0+\sum u_j$ | 0,1 |
| $E$, $\operatorname{Var}$ e $\operatorname{Cov}$ com a hipótese de RB citada | 0,3 |
| Frase-conclusão "não estacionário, porque $\operatorname{Var}$ depende de $t$" | 0,1 |

### b) A correlação e a FAC amostral (0,5)

$$
\operatorname{Corr}(y_t,y_{t-k})=\frac{(t-k)\sigma^2}{\sqrt{t\sigma^2\,(t-k)\sigma^2}}=\sqrt{\frac{t-k}{t}}.
$$

Com $t=100$: $k=1$ dá $\sqrt{0{,}99}=0{,}9950$; $k=10$ dá $\sqrt{0{,}90}=0{,}9487$.

**Interpretação:** a correlação fica perto de 1 por muitas defasagens e cai quase em linha reta. A FAC amostral de um passeio aleatório **decai muito devagar**, e esse é o sinal visual de raiz unitária (AU01; Enders, cap. 4). Num AR(1) estacionário, ao contrário, a queda é geométrica.

| Rubrica | Pontos |
|---|---|
| Fórmula da correlação a partir de a) | 0,2 |
| Os dois valores | 0,1 |
| Ligação com a FAC amostral que decai devagar | 0,2 |

### c) Soma de processos (0,5)

Como $x$ e $w$ não são correlacionados, os termos cruzados somem:

$$
\gamma_y(k)=\operatorname{Cov}(2x_t+w_t,\,2x_{t-k}+w_{t-k})=4\gamma_x(k)+\gamma_w(k).
$$

$\gamma_0=4(1{,}0)+1{,}5=5{,}5$, $\gamma_1=4(0{,}4)-0{,}6=1{,}0$, $\gamma_2=0+0{,}1=0{,}1$ e $\gamma_k=0$ para $k\ge3$. Logo $\rho_1=0{,}1818$ e $\rho_2=0{,}0182$.

**Conclusão:** os momentos não dependem de $t$, então $y_t$ é estacionário, e a FAC **corta depois da defasagem 2**: $y_t$ é um **MA(2)** (lista, Q3).

| Rubrica | Pontos |
|---|---|
| $\gamma_y=4\gamma_x+\gamma_w$ citando a não correlação | 0,2 |
| $\gamma_0,\gamma_1,\gamma_2$ | 0,2 |
| MA(2) pela FAC que corta em 2 | 0,1 |

> [!WARNING]
> **Erro que custa ponto aqui**
> Escrever $2\gamma_x$ em vez de $4\gamma_x$: a constante sai **ao quadrado** da covariância. É o mesmo tipo de erro do efeito marginal na P1 de Econometria I: o número sem a fórmula escrita antes.

---

## Questão 2 (2,0)

*Origem na lista:* itens a) e d): (lista, Q5); itens b) e c): (lista, Q6).

**Convenção:** Box-Jenkins, $\phi=0{,}6$, $\theta=0{,}3$.

### a) Operador e raízes (0,4)

$(1-0{,}6B)z_t=(1-0{,}3B)a_t$.
- AR: $1-0{,}6z=0\Rightarrow z=1{,}6667$, fora do círculo unitário: **estacionário**.
- MA: $1-0{,}3z=0\Rightarrow z=3{,}3333$, fora do círculo unitário: **invertível**.
- Não há fator comum, então é um ARMA(1,1) de verdade.

### b) Autocovariâncias (0,6)

Dois momentos auxiliares, multiplicando o modelo por $a_t$ e $a_{t-1}$:
- $E(z_ta_t)=\sigma^2$;
- $E(z_ta_{t-1})=\phi\sigma^2-\theta\sigma^2=(\phi-\theta)\sigma^2$.

Multiplicando por $z_t$ e por $z_{t-1}$ e tirando a esperança:

$$
\gamma_0=\phi\gamma_1+\sigma^2-\theta(\phi-\theta)\sigma^2,\qquad \gamma_1=\phi\gamma_0-\theta\sigma^2 .
$$

Substituindo a segunda na primeira:

$$
\gamma_0=\frac{1+\theta^2-2\phi\theta}{1-\phi^2}\sigma^2=\frac{1+0{,}09-0{,}36}{1-0{,}36}=\frac{0{,}73}{0{,}64}=1{,}140625 .
$$

Então $\gamma_1=0{,}6(1{,}140625)-0{,}3=0{,}384375$ e, para $k\ge2$, $\gamma_k=\phi\gamma_{k-1}$: $\gamma_2=0{,}230625$.

| Rubrica | Pontos |
|---|---|
| $E(z_ta_t)$ e $E(z_ta_{t-1})$ | 0,2 |
| Sistema de $\gamma_0$ e $\gamma_1$ | 0,2 |
| Os três valores | 0,2 |

### c) FAC (0,4)

$\rho_1=\gamma_1/\gamma_0=\frac{(1-\phi\theta)(\phi-\theta)}{1+\theta^2-2\phi\theta}=\frac{0{,}82\cdot0{,}3}{0{,}73}=0{,}3370$ e $\rho_2=0{,}2022$.

Para $k\ge2$, multiplicar o modelo por $z_{t-k}$ dá $\gamma_k=\phi\gamma_{k-1}$, porque $E(a_tz_{t-k})=E(a_{t-1}z_{t-k})=0$ *[$z$ só depende de choques passados: causalidade]*. Dividindo por $\gamma_0$: $\rho_k=\phi\rho_{k-1}=\phi^{k-1}\rho_1$. **A FAC decai geometricamente a partir de $\rho_1$, não de 1.**

### d) Pesos (0,6)

$\psi(B)=\frac{1-\theta B}{1-\phi B}$ dá $\psi_j=(\phi-\theta)\phi^{j-1}$: $\psi_1=0{,}3$, $\psi_2=0{,}18$, $\psi_3=0{,}108$.

$\pi(B)=\frac{1-\phi B}{1-\theta B}=1-\sum_{j\ge1}\pi_jB^j$ dá $\pi_j=(\phi-\theta)\theta^{j-1}$: $\pi_1=0{,}3$, $\pi_2=0{,}09$, $\pi_3=0{,}027$.

Os $\psi$ convergem porque $\lvert\phi\rvert\lt1$; os $\pi$, porque $\lvert\theta\rvert\lt1$ (lista, Q6c).

| Rubrica | Pontos |
|---|---|
| $\psi(B)=\theta(B)/\phi(B)$ e os três $\psi_j$ | 0,3 |
| $\pi(B)=\phi(B)/\theta(B)$ e os três $\pi_j$ | 0,3 |

---

## Questão 3 (1,5)

*Origem na lista:* (lista, Q9).

### a) A forma ARMA de $w_t$ (0,5)

Aplique $(1-B)$ dos dois lados de $(1-0{,}5B)y_t=\varepsilon_t$. Os operadores comutam:

$$
(1-0{,}5B)(1-B)y_t=(1-B)\varepsilon_t\ \Longrightarrow\ \boxed{(1-0{,}5B)w_t=(1-B)\varepsilon_t}
$$

É um ARMA(1,1) com $\phi=0{,}5$ e $\theta=1$. O polinômio MA $1-z$ tem raiz $z=1$, **sobre** o círculo unitário. Os pesos de $\pi(B)=\frac{1-0{,}5B}{1-B}=1-0{,}5(B+B^2+\cdots)$ são todos iguais a $0{,}5$ e não decaem: **não existe AR($\infty$) convergente**, então $w_t$ não é invertível (D03.2).

### b) Variância e FAC (0,6)

$$
\operatorname{Var}(w_t)=2(\gamma_0-\gamma_1)=2\gamma_0(1-\phi)=\frac{2\sigma^2}{1+\phi}=\frac{2}{1{,}5}=1{,}3333 .
$$

$$
\rho_1(w)=\frac{2\gamma_1-\gamma_0-\gamma_2}{2(\gamma_0-\gamma_1)}=-\frac{1-\phi}{2}=-0{,}25 .
$$

$\operatorname{Var}(y_t)=\sigma^2/(1-\phi^2)=1{,}3333$: com $\phi=0{,}5$, **diferenciar não reduziu a variância**. Para $\phi\lt0{,}5$ ela até aumenta. Variância que não cai e $\rho_1$ negativo são os dois sintomas clássicos de sobrediferenciação.

### c) Consequências (0,4)

- **Estimação:** a MV do MA fica na fronteira $\theta=1$, e a inferência sobre $\theta$ deixa de ser padrão (D03.2 e o *pile-up* do módulo 03).
- **Previsão:** o modelo diferenciado trata $y$ como I(1). A previsão não volta à média, e a variância do erro cresce sem limite, quando a verdadeira converge para $\gamma_0$.
- **Princípio:** só diferenciar com evidência de raiz unitária (ADF e KPSS juntos).

| Rubrica | Pontos |
|---|---|
| a) equação em $B$ com os operadores comutando | 0,2 |
| a) raiz $z=1$ ⇒ não invertível ⇒ sem AR($\infty$) (**a conclusão vale ponto**) | 0,3 |
| b) $\operatorname{Var}(w)$ e $\rho_1(w)$ | 0,4 |
| b) comparação com $\operatorname{Var}(y)$ | 0,2 |
| c) estimação e previsão | 0,4 |

---

## Questão 4 (1,5)

*Origem na lista:* item a): (lista, Q14); item b): (lista, Q13).

### a) AIC e BIC (0,9)

$AIC=-2\ln L+2k$ e $BIC=-2\ln L+k\ln T$, com $k$ contando os coeficientes **e** $\sigma^2$.

| Modelo | $k$ | $-2\ln L$ | AIC | BIC | AIC$/T$ (AU02) |
|---|---|---|---|---|---|
| AR(1) | 2 | 602,4 | 606,4 | **612,997** | 3,032 |
| ARMA(1,1) | 3 | 599,6 | 605,6 | 615,495 | 3,028 |
| AR(2) | 3 | 597,8 | 603,8 | 613,695 | 3,019 |
| AR(3) | 4 | 594,0 | **602,0** | 615,193 | 3,010 |

**O AIC escolhe o AR(3) e o BIC escolhe o AR(1).** A divisão por $T$ da AU02 não muda a ordem.

**Por que discordam:** cada parâmetro custa 2 no AIC e $\ln200=5{,}30$ no BIC. O BIC pune mais e é **consistente**: se o modelo verdadeiro está entre os candidatos, ele o escolhe com probabilidade que vai a 1. O AIC é **eficiente** para previsão, mas tende a sobreparametrizar (lista, Q14).

| Rubrica | Pontos |
|---|---|
| Fórmulas com $k$ incluindo $\sigma^2$ | 0,2 |
| Oito números | 0,4 |
| Escolhas e a explicação (penalidade, consistência × eficiência) | 0,3 |

### b) MV condicional = MQO (0,6)

Condicionando em $y_1$, com $\varepsilon_t$ normal:

$$
\ell(\phi,\sigma^2)=-\frac{T-1}{2}\ln(2\pi)-\frac{T-1}{2}\ln\sigma^2-\frac{1}{2\sigma^2}\sum_{t=2}^{T}(y_t-\phi y_{t-1})^2 .
$$

Para $\phi$, maximizar $\ell$ é minimizar a soma dos quadrados, isto é, **MQO**:

$$
\widehat\phi=\frac{\sum y_ty_{t-1}}{\sum y_{t-1}^2}=\frac{84}{120}=0{,}7,\qquad
\widehat\sigma^2=\frac{1}{T-1}\Big(\sum y_t^2-\widehat\phi\sum y_ty_{t-1}\Big)=\frac{130-58{,}8}{100}=0{,}712 .
$$

| Rubrica | Pontos |
|---|---|
| $\ell$ condicional com $T-1$ termos | 0,2 |
| Condição de primeira ordem e $\widehat\phi=0{,}7$ | 0,2 |
| $\widehat\sigma^2=0{,}712$ | 0,2 |

> [!WARNING]
> **Erro que custa ponto aqui**
> Este é o item de conta curta que ficou em branco na P1 de Econometria I (Q4b: $340/85$). São duas divisões. Faça este item **antes** das demonstrações.

---

## Questão 5 (2,0)

*Origem na lista:* (lista, Q15).

### a) O previsor ótimo (0,6)

Seja $g$ qualquer função de $\mathcal F_T$ e $m=E(y_{T+h}\mid\mathcal F_T)$. Somando e subtraindo $m$:

$$
E\big((y_{T+h}-g)^2\big)=E\big((y_{T+h}-m)^2\big)+E\big((m-g)^2\big)+2E\big((y_{T+h}-m)(m-g)\big).
$$

O termo cruzado é zero pela **lei das expectativas iteradas**: $(m-g)$ é conhecido em $T$, e $E(y_{T+h}-m\mid\mathcal F_T)=0$. Como $E\big((m-g)^2\big)\ge0$, o EQM é mínimo com $g=m$. **Conclusão: $y_{T+h\mid T}=E(y_{T+h}\mid\mathcal F_T)$** (D05.1).

### b) Previsões (0,4)

$y_{T+h\mid T}-10=0{,}8^h(y_T-10)$, logo $11{,}6$, $11{,}28$ e $11{,}024$ para $h=1,2,3$.

### c) Erro de previsão (0,5)

Com $\psi_j=0{,}8^j$: $e_T(h)=\sum_{j=0}^{h-1}\psi_ja_{T+h-j}$, um MA($h-1$) nos choques futuros, e

$$
\operatorname{Var}\big(e_T(h)\big)=\sigma^2\sum_{j=0}^{h-1}\psi_j^2:\quad 4;\ \ 4(1+0{,}64)=6{,}56;\ \ 6{,}56+4(0{,}4096)=8{,}1984 .
$$

### d) Intervalos e longo prazo (0,5)

- $h=1$: $11{,}6\pm1{,}96\sqrt4$, isto é, $[7{,}68;\ 15{,}52]$.
- $h=2$: $11{,}28\pm1{,}96\sqrt{6{,}56}=11{,}28\pm5{,}0200$, isto é, $[6{,}2600;\ 16{,}3000]$.
- $h\to\infty$: a previsão vai à média $\mu=10$, e a variância vai a $\sigma^2/(1-\phi^2)=11{,}111=\gamma_0$. A incerteza da previsão de longo prazo é a variância incondicional.

| Rubrica | Pontos |
|---|---|
| a) decomposição e termo cruzado zero pela LEI | 0,4 |
| a) **frase-conclusão** do mínimo | 0,2 |
| b) fórmula geral e três valores | 0,4 |
| c) MA($h-1$) com $\psi_0=1$ e as variâncias | 0,5 |
| d) dois intervalos e limites | 0,5 |

> [!WARNING]
> **Erro que custa ponto aqui**
> Esquecer $\psi_0=1$ e escrever $\operatorname{Var}(e_T(1))=0$, ou somar $\psi_j^2$ até $h$ em vez de $h-1$. Escreva o MA($h-1$) do erro antes da variância.

---

## Questão 6 (1,5)

*Origem na lista:* (lista, Q16).

### a) Modelo (0,3)

$$
(1-B)(1-B^{12})y_t=(1-0{,}4B)(1-0{,}6B^{12})a_t=(1-0{,}4B-0{,}6B^{12}+0{,}24B^{13})a_t .
$$

O produto cria o termo em $B^{13}$ com coeficiente $\theta\Theta$: é o "modelo das companhias aéreas".

### b) Parâmetros e observações (0,3)

Três parâmetros: $\theta$, $\Theta$ e $\sigma^2$. Sem constante, porque $D=1$. Perdem-se $d+sD=1+12=13$ observações, e sobram $180-13=167$.

### c) FAC e FACP (0,6)

$w_t$ é um MA(13) com coeficientes só em 1, 12 e 13, e $\gamma_0=(1+\theta^2)(1+\Theta^2)\sigma^2$:

| Defasagem | Fórmula | Valor |
|---|---|---|
| 1 | $-\theta/(1+\theta^2)$ | $-0{,}3448$ |
| 11 e 13 | $\theta\Theta/[(1+\theta^2)(1+\Theta^2)]$ | $0{,}1521$ |
| 12 | $-\Theta/(1+\Theta^2)$ | $-0{,}4412$ |
| as demais | — | 0 |

A FACP **decai** nas defasagens baixas, a partir da 1, e em torno de 12 e 24, como em todo MA. O "grupo" 11-12-13 na FAC é a assinatura do produto (lista, Q16c).

### d) Comparação (0,3)

Os modelos são **aninhados**: $\phi=0$ volta ao primeiro. Use o **BIC**, que é consistente, junto com o **teste LR**, $2(\ell_1-\ell_0)\sim\chi^2(1)$. Confira também se $\widehat\phi$ e $\widehat\theta$ não ficaram quase iguais, porque isso indica fator comum. Se o objetivo for prever, complemente com o RMSE fora da amostra (AU03).

| Rubrica | Pontos |
|---|---|
| a) | 0,3 |
| b) 3 parâmetros com $\sigma^2$ e 13 perdidas | 0,3 |
| c) os quatro valores | 0,4 |
| c) FACP | 0,2 |
| d) | 0,3 |

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s1_q1_corr_t100_k1 | 0,9950 |
| pv_s1_q1_corr_t100_k10 | 0,9487 |
| pv_s1_q1_g0 | 5,5 |
| pv_s1_q1_g1 | 1,0 |
| pv_s1_q1_g2 | 0,1 |
| pv_s1_q1_rho1 | 0,1818 |
| pv_s1_q1_rho2 | 0,0182 |
| pv_s1_q2_raiz_ar | 1,6667 |
| pv_s1_q2_raiz_ma | 3,3333 |
| pv_s1_q2_g0 | 1,140625 |
| pv_s1_q2_g1 | 0,384375 |
| pv_s1_q2_g2 | 0,230625 |
| pv_s1_q2_rho1 | 0,3370 |
| pv_s1_q2_rho2 | 0,2022 |
| pv_s1_q2_psi1 | 0,3 |
| pv_s1_q2_psi2 | 0,18 |
| pv_s1_q2_psi3 | 0,108 |
| pv_s1_q2_pi1 | 0,3 |
| pv_s1_q2_pi2 | 0,09 |
| pv_s1_q2_pi3 | 0,027 |
| pv_s1_q3_var_w | 1,3333 |
| pv_s1_q3_var_y | 1,3333 |
| pv_s1_q3_rho1_w | -0,25 |
| pv_s1_q4_aic_ar1 | 606,4 |
| pv_s1_q4_aic_arma11 | 605,6 |
| pv_s1_q4_aic_ar2 | 603,8 |
| pv_s1_q4_aic_ar3 | 602,0 |
| pv_s1_q4_bic_ar1 | 612,997 |
| pv_s1_q4_bic_arma11 | 615,495 |
| pv_s1_q4_bic_ar2 | 613,695 |
| pv_s1_q4_bic_ar3 | 615,193 |
| pv_s1_q4_aict_ar1 | 3,032 |
| pv_s1_q4_aict_arma11 | 3,028 |
| pv_s1_q4_aict_ar2 | 3,019 |
| pv_s1_q4_aict_ar3 | 3,010 |
| pv_s1_q4_ln200 | 5,2983 |
| pv_s1_q4_phi | 0,7 |
| pv_s1_q4_s2 | 0,712 |
| pv_s1_q5_f1 | 11,6 |
| pv_s1_q5_f2 | 11,28 |
| pv_s1_q5_f3 | 11,024 |
| pv_s1_q5_v1 | 4 |
| pv_s1_q5_v2 | 6,56 |
| pv_s1_q5_v3 | 8,1984 |
| pv_s1_q5_li1 | 7,68 |
| pv_s1_q5_ls1 | 15,52 |
| pv_s1_q5_meia2 | 5,0200 |
| pv_s1_q5_li2 | 6,2600 |
| pv_s1_q5_ls2 | 16,3000 |
| pv_s1_q5_vinf | 11,111 |
| pv_s1_q6_rho1 | -0,3448 |
| pv_s1_q6_rho11 | 0,1521 |
| pv_s1_q6_rho12 | -0,4412 |
| pv_s1_q6_rho13 | 0,1521 |
| pv_s1_q6_perda | 13 |
| pv_s1_q6_efetivas | 167 |
-->
