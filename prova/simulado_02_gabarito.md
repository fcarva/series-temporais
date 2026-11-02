---
title: "Simulado 02 — gabarito com rubrica"
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
  - Gabarito do Simulado 02 — séries temporais
---

# Simulado 02 — gabarito

Enunciado em [simulado_02.md](simulado_02.md). Todos os números saem de [prova.R](prova.R). Cada questão é uma questão-tipo do [guia "não posso errar"](nao_posso_errar.md): se um item travou, refaça a questão-tipo do guia com o mesmo número, cobrindo a resolução, e depois refaça o item aqui.

> [!TIP]
> **Como se corrigir**
> Some os pontos **por passo**, pelo que você escreveu, não pelo que sabia. A fórmula geral escrita e aplicada com erro de conta ainda vale o passo da fórmula. Número certo sem fórmula nem justificativa vale metade. Frase de fecho ausente perde o ponto dela, mesmo com a conta certa. Cada passo que faltou vira uma linha no [log de erros](log_erros.md), com a causa.

---

## Questão 1 (1,0) — questão-tipo 1

*Origem na lista:* (lista, Q1).

### a) Solução e momentos (0,5)

- Somando $y_s-y_{s-1}=0{,}2+u_s$ de 1 a $t$, a soma telescópica dá $y_t=5+0{,}2t+\sum_{s=1}^{t}u_s$.
- $E(y_t)=5+0{,}2t$ *[F4 na soma finita; RB: $E(u_s)=0$]*.
- $\operatorname{Var}(y_t)=E\big((\sum_su_s)^2\big)=\sum_sE(u_s^2)=2t$ *[RB: só $i=j$ sobra]*.
- $\operatorname{Cov}(y_t,y_{t-k})=E\big(\sum_{i\le t}u_i\sum_{j\le t-k}u_j\big)=2(t-k)$ *[os $t-k$ choques comuns]*.

| Rubrica | Pontos |
|---|---|
| Soma telescópica até $y_t=y_0+ct+\sum u_s$ | 0,1 |
| $E(y_t)$ com o $y_0$ e a hipótese citada | 0,1 |
| $\operatorname{Var}$ **com o $E$** escrito, pela soma dupla | 0,15 |
| $\operatorname{Cov}$ pelos choques comuns | 0,15 |

### b) Os números (0,3)

$E(y_{50})=15$; $\operatorname{Var}(y_{50})=100$; $\operatorname{Cov}(y_{50},y_{40})=80$; $\operatorname{Corr}=\sqrt{40/50}=0{,}8944$.

| Rubrica | Pontos |
|---|---|
| Os três momentos | 0,15 |
| A correlação $\sqrt{(t-k)/t}$ | 0,15 |

### c) Estacionariedade (0,2)

**Não é estacionário:** a variância $2t$ depende de $t$, e a média $5+0{,}2t$ também.

| Rubrica | Pontos |
|---|---|
| Critério das três condições aplicado | 0,1 |
| Frase de fecho | 0,1 |

---

## Questão 2 (1,0) — questão-tipo 2

*Origem na lista:* (lista, Q3).

### a) A fórmula (0,4)

$$
\gamma_3(k)=\operatorname{Cov}(3z_{1t}+z_{2t},\ 3z_{1,t-k}+z_{2,t-k})=9\gamma_1(k)+3C_{12}(k)+3C_{21}(k)+\gamma_2(k)=9\gamma_1(k)+\gamma_2(k),
$$

porque **$z_1$ e $z_2$ não são correlacionados**, o que zera $C_{12}$ e $C_{21}$. A constante 3 sai ao quadrado.

| Rubrica | Pontos |
|---|---|
| Os quatro produtos da covariância | 0,15 |
| Cruzados zerados **citando a hipótese** | 0,15 |
| O fator 9, e não 3 | 0,1 |

### b) Os números (0,3)

$\gamma_3(0)=9(1{,}0)+1{,}5=10{,}5$; $\gamma_3(1)=9(0{,}45)+0{,}6=4{,}65$; $\gamma_3(2)=0+0{,}5=0{,}5$; $\gamma_3(3)=0$.

Logo, $\rho_1=4{,}65/10{,}5=0{,}4429$ e $\rho_2=0{,}5/10{,}5=0{,}0476$.

| Rubrica | Pontos |
|---|---|
| Os quatro $\gamma_3(k)$ | 0,2 |
| $\rho_1$ e $\rho_2$ | 0,1 |

### c) Classificação (0,3)

A média é constante e $\gamma_3(k)$ não depende de $t$: **$z_3$ é estacionário**. A FAC é diferente de zero até a defasagem 2 e **corta** depois: **$z_3$ é um MA(2)**. Um AR faria a FAC decair sem zerar.

| Rubrica | Pontos |
|---|---|
| Estacionário, pelo critério | 0,1 |
| **MA(2)**, pelo corte da FAC (ARMA(1,2) vale zero) | 0,2 |

---

## Questão 3 (1,0) — questão-tipo 3

*Origem na lista:* (lista, Q5).

### a) Forma em $B$ (0,2)

$\tilde z_t=(1-0{,}65B+0{,}1B^2)a_t$: $\phi(B)=1$ e $\theta(B)$ de grau 2, logo ARMA(0,2), um MA(2). **Todo MA finito é estacionário**, para quaisquer coeficientes.

| Rubrica | Pontos |
|---|---|
| Forma em $B$ e classificação | 0,1 |
| Estacionário, com o motivo | 0,1 |

### b) Raízes (0,4)

$\theta(x)=0\iff0{,}1x^2-0{,}65x+1=0$, com a variável $x$ (um número, não a série):
- $\Delta=0{,}4225-0{,}4=0{,}0225$, e $\sqrt\Delta=0{,}15$;
- $x=(0{,}65\pm0{,}15)/0{,}2$, ou seja, $x_1=4$ e $x_2=2{,}5$;
- Vieta confere: soma $6{,}5=0{,}65/0{,}1$ e produto $10=1/0{,}1$.

As duas raízes estão fora do círculo: **(i) é invertível**.

| Rubrica | Pontos |
|---|---|
| Polinômio na variável $x$, forma padrão | 0,1 |
| Bhaskara: $\Delta$ e as duas raízes | 0,2 |
| Conclusão: invertível | 0,1 |

### c) Fator comum (0,4)

Das raízes 4 e 2,5 vêm os fatores $(1-0{,}25B)$ e $(1-0{,}4B)$:

$$
(1-0{,}25B)\tilde z_t=(1-0{,}25B)(1-0{,}4B)\,a_t\ \Rightarrow\ \tilde z_t=(1-0{,}4B)\,a_t.
$$

O fator do AR aparece também no MA e cancela: **(ii) é um MA(1)** com $\theta=0{,}4$, e não um ARMA(1,2). Os pesos são $\pi_j=-0{,}4^j$: $-0{,}4$; $-0{,}16$; $-0{,}064$.

| Rubrica | Pontos |
|---|---|
| Fatoração pelo inverso das raízes | 0,1 |
| Cancelamento e "MA(1)" | 0,2 |
| Os três $\pi_j$ | 0,1 |

---

## Questão 4 (1,5) — questão-tipo 4

*Origem na lista:* (lista, Q6).

### a) Raízes (0,2)

$\phi(x)=1-0{,}5x=0\Rightarrow x=2$; $\theta(x)=1-0{,}2x=0\Rightarrow x=5$. As duas estão fora do círculo: **estacionário e invertível**.

| Rubrica | Pontos |
|---|---|
| As duas raízes e a conclusão | 0,2 |

### b) Momentos auxiliares (0,3)

Com o modelo isolado, $z_t=0{,}5z_{t-1}+a_t-0{,}2a_{t-1}$, e a causalidade, $E(z_{t-k}a_t)=0$ para $k\ge1$:
- multiplicando por $a_t$: $E(z_ta_t)=0+\sigma^2-0=2$;
- multiplicando por $a_{t-1}$: $E(z_ta_{t-1})=0{,}5E(z_{t-1}a_{t-1})-0{,}2\sigma^2=0{,}5(2)-0{,}2(2)=0{,}6$.

| Rubrica | Pontos |
|---|---|
| $E(z_ta_t)=\sigma^2=2$, com a causalidade citada | 0,1 |
| $E(z_ta_{t-1})=(\phi-\theta)\sigma^2=0{,}6$ | 0,2 |

### c) Autocovariâncias (0,5)

- multiplicando por $z_t$: $\gamma_0=0{,}5\gamma_1+2-0{,}2(0{,}6)=0{,}5\gamma_1+1{,}88$;
- multiplicando por $z_{t-1}$: $\gamma_1=0{,}5\gamma_0-0{,}2(2)=0{,}5\gamma_0-0{,}4$;
- substituindo: $\gamma_0=0{,}25\gamma_0-0{,}2+1{,}88$, logo $0{,}75\gamma_0=1{,}68$ e $\gamma_0=2{,}24$;
- $\gamma_1=0{,}5(2{,}24)-0{,}4=0{,}72$ e $\gamma_2=0{,}5\gamma_1=0{,}36$.

Confere com a fórmula: $\frac{1+0{,}04-0{,}2}{0{,}75}\cdot2=2{,}24$.

| Rubrica | Pontos |
|---|---|
| **$\gamma_0=E(z_t^2)$, a variância**, e a equação de $\gamma_0$ | 0,15 |
| A equação de $\gamma_1$ | 0,1 |
| Sistema resolvido: $\gamma_0$ e $\gamma_1$ | 0,15 |
| $\gamma_2$ | 0,1 |

### d) FAC (0,2)

$\rho_1=0{,}72/2{,}24=0{,}3214$. Para $k\ge2$, multiplicando por $z_{t-k}$, os dois choques do modelo, $a_t$ e $a_{t-1}$, são posteriores a $z_{t-k}$ e somem: $\gamma_k=0{,}5\gamma_{k-1}$. Dividindo por $\gamma_0$, **$\rho_k=0{,}5\rho_{k-1}$**.

| Rubrica | Pontos |
|---|---|
| $\rho_1$ | 0,1 |
| O motivo de os choques sumirem para $k\ge2$ | 0,1 |

### e) Pesos (0,3)

$\psi_j=(\phi-\theta)\phi^{j-1}$: 0,3; 0,15; 0,075. $\pi_j=(\phi-\theta)\theta^{j-1}$: 0,3; 0,06; 0,012.

| Rubrica | Pontos |
|---|---|
| Os três $\psi_j$ | 0,15 |
| Os três $\pi_j$ | 0,15 |

---

## Questão 5 (1,0) — questão-tipo 5

*Origem na lista:* (lista, Q7).

### a) Raízes (0,2)

$\phi(x)=1-0{,}3x-0{,}4x^2=0\iff0{,}4x^2+0{,}3x-1=0$. Assim, $\Delta=0{,}09+1{,}6=1{,}69$ e $x=(-0{,}3\pm1{,}3)/0{,}8$, ou seja, $x=1{,}25$ e $x=-2$. Os dois módulos são maiores que 1: **estacionário**. Pelo triângulo: $0{,}3+0{,}4\lt1$, $0{,}4-0{,}3\lt1$ e $\lvert0{,}4\rvert\lt1$.

| Rubrica | Pontos |
|---|---|
| Raízes com sinal certo do $\phi_2$ e a conclusão | 0,2 |

### b) Yule-Walker (0,4)

Multiplicando por $y_{t-1}$ e $y_{t-2}$ e dividindo por $\gamma_0$:

$$
\rho_1=\phi_1+\phi_2\rho_1,\qquad \rho_2=\phi_1\rho_1+\phi_2.
$$

- $\rho_1=0{,}3/0{,}6=0{,}5$;
- $\rho_2=0{,}3(0{,}5)+0{,}4=0{,}55$;
- $\rho_3=0{,}3(0{,}55)+0{,}4(0{,}5)=0{,}365$.

| Rubrica | Pontos |
|---|---|
| As duas equações escritas | 0,2 |
| $\rho_1$, $\rho_2$ e $\rho_3$ | 0,2 |

### c) Variância (0,4)

Multiplicando por $y_t$, o choque sobrevive com $E(\varepsilon_ty_t)=\sigma^2$: $\gamma_0=\phi_1\gamma_1+\phi_2\gamma_2+\sigma^2$. Daí:

$$
\gamma_0=\frac{\sigma^2}{1-\phi_1\rho_1-\phi_2\rho_2}=\frac{1}{1-0{,}15-0{,}22}=\frac{1}{0{,}63}=1{,}5873.
$$

Confere pela fórmula fechada: $\frac{0{,}6}{1{,}4\,(0{,}36-0{,}09)}=1{,}5873$.

| Rubrica | Pontos |
|---|---|
| A equação de $\gamma_0$ com o $\sigma^2$ | 0,2 |
| O valor | 0,2 |

---

## Questão 6 (1,0) — questão-tipo 6

*Origem na lista:* (lista, Q9).

### a) A forma ARMA de $w_t$ (0,4)

- Pela definição: $w_t=(0{,}2y_{t-1}+\varepsilon_t)-y_{t-1}=-0{,}8y_{t-1}+\varepsilon_t$.
- Com o operador: $(1-0{,}2B)y_t=\varepsilon_t$; multiplicando **os dois lados** por $(1-B)$, $(1-B)(1-0{,}2B)y_t=(1-B)\varepsilon_t$, e, como os polinômios comutam, $(1-0{,}2B)w_t=(1-B)\varepsilon_t$.
- A raiz do MA é $1-x=0\Rightarrow x=1$, **sobre** o círculo: **$w_t$ não é invertível e não tem AR($\infty$)**.

| Rubrica | Pontos |
|---|---|
| Derivação pelo operador, sem copiar a forma | 0,2 |
| Raiz 1 e a conclusão "não invertível, sem AR($\infty$)" | 0,2 |

### b) Os números (0,4)

- $\operatorname{Var}(y_t)=1/(1-0{,}04)=1{,}0417$;
- $\operatorname{Var}(w_t)=2\gamma_0(1-\phi)=2/(1+\phi)=1{,}6667$;
- $\rho_1(w)=-(1-\phi)/2=-0{,}4$.

| Rubrica | Pontos |
|---|---|
| As duas variâncias | 0,2 |
| $\rho_1(w)$ | 0,2 |

### c) Consequência (0,2)

Diferenciar **aumentou** a variância, de 1,0417 para 1,6667, e criou $\rho_1=-0{,}4$, perto do $-0{,}5$ do ruído diferenciado. A série já era estacionária: diferenciar foi um erro (sobrediferenciação), que deixa o MA na fronteira e piora a estimação e a previsão.

| Rubrica | Pontos |
|---|---|
| Frase de fecho: sobrediferenciação | 0,2 |

---

## Questão 7 (1,0) — questão-tipo 7

*Origem na lista:* item a): (lista, Q14); item b): (lista, Q13).

### a) AIC e BIC (0,6)

| Modelo | $k$ | $-2\ln L$ | AIC | BIC |
|---|---|---|---|---|
| AR(1) | 2 | 430,0 | 434,0 | **440,02** |
| AR(2) | 3 | 426,2 | **432,2** | 441,23 |
| ARMA(1,1) | 3 | 427,2 | 433,2 | 442,23 |
| ARMA(2,1) | 4 | 424,8 | 432,8 | 444,84 |

**O AIC escolhe o AR(2), e o BIC escolhe o AR(1).** Eles discordam porque a multa por parâmetro do BIC, $\ln150=5{,}01$, é maior que a do AIC, 2. O BIC é consistente; o AIC tende a sobreparametrizar.

| Rubrica | Pontos |
|---|---|
| $k$ com o $\sigma^2$ | 0,1 |
| Os quatro AIC | 0,2 |
| Os quatro BIC | 0,2 |
| As duas escolhas e o motivo | 0,1 |

### b) MV condicional (0,4)

$\widehat\phi=45/90=0{,}5$ e $\widehat\sigma^2=(100-0{,}5\cdot45)/80=77{,}5/80=0{,}96875$. Condicionando em $y_1$, maximizar $\ln L$ em $\phi$ é minimizar a soma de quadrados, isto é, fazer MQO.

| Rubrica | Pontos |
|---|---|
| $\widehat\phi$ com a fórmula | 0,2 |
| $\widehat\sigma^2$ dividindo por $T-1=80$ | 0,2 |

---

## Questão 8 (1,5) — questão-tipo 8

*Origem na lista:* (lista, Q15).

### a) Previsões (0,4)

Escrevendo o modelo em $T+1$, o choque futuro vira zero: $\widehat y_T(1)=50+0{,}6(5)=53$. Em $T+2$, $y_{T+1}$ vira a sua previsão: $\widehat y_T(2)=50+0{,}6(3)=51{,}8$. Em geral, $\widehat y_T(h)=50+0{,}6^h(55-50)$, o que dá $\widehat y_T(3)=51{,}08$.

| Rubrica | Pontos |
|---|---|
| As três previsões | 0,3 |
| A fórmula geral | 0,1 |

### b) Erros (0,3)

$e_T(1)=a_{T+1}$ e $e_T(2)=a_{T+2}+0{,}6a_{T+1}$. Em geral, $e_T(h)=\sum_{j=0}^{h-1}0{,}6^ja_{T+h-j}$: são $h$ choques futuros, um MA($h-1$).

| Rubrica | Pontos |
|---|---|
| Os dois erros | 0,15 |
| A forma MA($h-1$) com $\psi_j=0{,}6^j$ | 0,15 |

### c) Variâncias (0,3)

$\operatorname{Var}(e_T(h))=9\sum_{j\lt h}0{,}36^j$: 9; 12,24; 13,4064.

| Rubrica | Pontos |
|---|---|
| A fórmula, com o $\psi_0=1$ | 0,1 |
| Os três valores | 0,2 |

### d) Intervalos (0,3)

- $h=1$: $53\pm1{,}96(3)=[47{,}12;\ 58{,}88]$;
- $h=2$: $\sqrt{12{,}24}=3{,}4986$, logo $51{,}8\pm6{,}8572=[44{,}94;\ 58{,}66]$.

| Rubrica | Pontos |
|---|---|
| Uso do **desvio-padrão**, não da variância | 0,1 |
| Os dois intervalos | 0,2 |

### e) Longo prazo (0,2)

$0{,}6^h\to0$: a previsão volta à média, 50, e a variância do erro tende a $\gamma_0=9/(1-0{,}36)=14{,}0625$.

| Rubrica | Pontos |
|---|---|
| Os dois limites | 0,2 |

---

## Questão 9 (1,0) — questão-tipo 9

*Origem na lista:* (lista, Q16).

### a) O modelo (0,3)

$$
(1-B)(1-B^4)\,y_t=(1-0{,}5B)(1-0{,}3B^4)\,a_t,\qquad (1-0{,}5B)(1-0{,}3B^4)=1-0{,}5B-0{,}3B^4+0{,}15B^5.
$$

Assim, $w_t=y_t-y_{t-1}-y_{t-4}+y_{t-5}=a_t-0{,}5a_{t-1}-0{,}3a_{t-4}+0{,}15a_{t-5}$. O termo $+0{,}15B^5$ vem do produto $(-0{,}5)(-0{,}3)$.

| Rubrica | Pontos |
|---|---|
| Os quatro polinômios | 0,1 |
| A expansão com o termo cruzado positivo | 0,2 |

### b) Contagens (0,2)

São **3 parâmetros**: $\theta$, $\Theta$ e $\sigma^2$; o 0,15 não conta, porque é imposto. Perdem-se $d+sD=1+4=5$ observações: restam **95**.

| Rubrica | Pontos |
|---|---|
| Parâmetros | 0,1 |
| Observações efetivas | 0,1 |

### c) FAC (0,4)

- $\rho_1=-0{,}5/1{,}25=-0{,}4$;
- $\rho_4=-0{,}3/1{,}09=-0{,}2752$;
- satélites: $\rho_3=\rho_5=\rho_1\rho_4=0{,}1101$;
- $\rho_2=\rho_6=0$, porque nenhum par de choques fica àquela distância.

É a assinatura do multiplicativo com $s=4$: pico em 4 e satélites em $4\pm1$.

| Rubrica | Pontos |
|---|---|
| $\rho_1$ e $\rho_4$ | 0,2 |
| Os satélites | 0,1 |
| Os zeros | 0,1 |

### d) Critério (0,1)

O rival contém o modelo: com $\phi=0$, volta ao original. Compara-se pelo **BIC**, ou pelo **LR** com $\chi^2(1)$ e crítico 3,84, com o mesmo $T$ efetivo.

| Rubrica | Pontos |
|---|---|
| BIC ou LR, com o motivo | 0,1 |

---

## Depois de corrigir

1. Some os pontos por questão e compare com o Simulado 01, questão-tipo por questão-tipo.
2. Para cada item com perda, escreva uma linha no [log](log_erros.md) com a causa (H, A, N, L, R, V, E ou T) e atualize a coluna S2 do placar.
3. **Na mesma noite**, refaça no papel a questão-tipo do [guia](nao_posso_errar.md) correspondente ao item de maior perda, sem olhar, e confira linha a linha.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s2_q1_media | 15 |
| pv_s2_q1_var | 100 |
| pv_s2_q1_cov | 80 |
| pv_s2_q1_corr | 0,8944 |
| pv_s2_q2_g0 | 10,5 |
| pv_s2_q2_g1 | 4,65 |
| pv_s2_q2_g2 | 0,5 |
| pv_s2_q2_g3 | 0 |
| pv_s2_q2_rho1 | 0,4429 |
| pv_s2_q2_rho2 | 0,0476 |
| pv_s2_q3_delta | 0,0225 |
| pv_s2_q3_z1 | 4 |
| pv_s2_q3_z2 | 2,5 |
| pv_s2_q3_soma | 6,5 |
| pv_s2_q3_prod | 10 |
| pv_s2_q3_fator_a | 0,25 |
| pv_s2_q3_fator_b | 0,4 |
| pv_s2_q3_pi1 | -0,4 |
| pv_s2_q3_pi2 | -0,16 |
| pv_s2_q3_pi3 | -0,064 |
| pv_s2_q4_raiz_ar | 2 |
| pv_s2_q4_raiz_ma | 5 |
| pv_s2_q4_aux1 | 2 |
| pv_s2_q4_aux2 | 0,6 |
| pv_s2_q4_g0 | 2,24 |
| pv_s2_q4_g0_formula | 2,24 |
| pv_s2_q4_g1 | 0,72 |
| pv_s2_q4_g2 | 0,36 |
| pv_s2_q4_rho1 | 0,3214 |
| pv_s2_q4_psi1 | 0,3 |
| pv_s2_q4_psi2 | 0,15 |
| pv_s2_q4_psi3 | 0,075 |
| pv_s2_q4_pi1 | 0,3 |
| pv_s2_q4_pi2 | 0,06 |
| pv_s2_q4_pi3 | 0,012 |
| pv_s2_q5_raiz_pos | 1,25 |
| pv_s2_q5_raiz_neg | -2 |
| pv_s2_q5_rho1 | 0,5 |
| pv_s2_q5_rho2 | 0,55 |
| pv_s2_q5_rho3 | 0,365 |
| pv_s2_q5_g0 | 1,5873 |
| pv_s2_q5_g0_formula | 1,5873 |
| pv_s2_q5_g0_r | 1,5873 |
| pv_s2_q6_var_y | 1,0417 |
| pv_s2_q6_var_w | 1,6667 |
| pv_s2_q6_var_w_formula | 1,6667 |
| pv_s2_q6_rho1_w | -0,4 |
| pv_s2_q6_raiz_ma | 1 |
| pv_s2_q7_aic_ar1 | 434,0 |
| pv_s2_q7_aic_ar2 | 432,2 |
| pv_s2_q7_aic_arma11 | 433,2 |
| pv_s2_q7_aic_arma21 | 432,8 |
| pv_s2_q7_bic_ar1 | 440,02 |
| pv_s2_q7_bic_ar2 | 441,23 |
| pv_s2_q7_bic_arma11 | 442,23 |
| pv_s2_q7_bic_arma21 | 444,84 |
| pv_s2_q7_ln150 | 5,0106 |
| pv_s2_q7_phi | 0,5 |
| pv_s2_q7_sqr | 77,5 |
| pv_s2_q7_s2 | 0,96875 |
| pv_s2_q8_f1 | 53 |
| pv_s2_q8_f2 | 51,8 |
| pv_s2_q8_f3 | 51,08 |
| pv_s2_q8_v1 | 9 |
| pv_s2_q8_v2 | 12,24 |
| pv_s2_q8_v3 | 13,4064 |
| pv_s2_q8_dp2 | 3,4986 |
| pv_s2_q8_meia2 | 6,8572 |
| pv_s2_q8_li1 | 47,12 |
| pv_s2_q8_ls1 | 58,88 |
| pv_s2_q8_li2 | 44,94 |
| pv_s2_q8_ls2 | 58,66 |
| pv_s2_q8_vinf | 14,0625 |
| pv_s2_q9_cruzado | 0,15 |
| pv_s2_q9_npar | 3 |
| pv_s2_q9_perda | 5 |
| pv_s2_q9_efetivas | 95 |
| pv_s2_q9_rho1 | -0,4 |
| pv_s2_q9_rho4 | -0,2752 |
| pv_s2_q9_rho3 | 0,1101 |
| pv_s2_q9_rho5 | 0,1101 |
| pv_s2_q9_rho2 | 0 |
| pv_s2_q9_rho6 | 0 |
| ap_c6_lr_crit | 3,84 |
-->
