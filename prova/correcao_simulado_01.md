---
title: "Simulado 01 — correção da minha tentativa (01/11)"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: LST
status: verificado
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
  - simulado
aliases:
  - Correção do Simulado 01
---

# Simulado 01: a correção da minha tentativa

Esta é a correção da tentativa de 01/11, feita à mão e corrigida pela rubrica do [gabarito](simulado_01_gabarito.md). Cada erro foi lançado no [log](log_erros.md). O objetivo não é a nota: é achar **a primeira linha** em que cada item desandou e a regra que impede o erro de voltar.

## 1. A nota pela rubrica: cerca de 1,6 de 10

| Questão | O que foi feito | Pontos |
|---|---|---|
| Q1 (1,5) | a) e b) quase completos; c) com as contas certas e a classificação errada | **≈ 1,15** |
| Q2 (2,0) | a) raízes certas; b) travou na definição de $\gamma_0$; c) e d) em branco | ≈ 0,3 |
| Q3 (1,5) | a) chegou à forma pedida, mas sem derivar e sem a conclusão; b) e c) em branco | ≈ 0,15 |
| Q4 (1,5) | escolheu o modelo pelo $\ln L$, sem AIC nem BIC; b) em branco | 0 |
| Q5 (2,0) e Q6 (1,5) | em branco | 0 |

**A leitura que importa:** mais da metade dos pontos perdidos era **conta curta que nem foi tentada**: AIC/BIC, $\widehat\phi=84/120$, previsões de um AR(1), contagem de parâmetros. É o mesmo padrão da P1 de Econometria I. O bloco 1, ao contrário, está seguro.

## 2. O que já está certo

- **Q1 a):**
  - a recursão até $y_t=y_0+\sum_{i=1}^{t}u_i$;
  - $E(y_t)=y_0=2$, com a hipótese de RB citada;
  - $\operatorname{Var}(y_t)=t\sigma^2$ pela soma dupla, separando $i=j$ de $i\ne j$;
  - $\operatorname{Cov}(y_t,y_{t-k})=(t-k)\sigma^2$ pelos choques comuns.
- **Q1 b):** a correlação $\sqrt{(t-k)/t}$ derivada passo a passo, e os valores $0{,}995$ e $0{,}949$.
- **Q1 c):** $\gamma_y(k)=4\gamma_x(k)+\gamma_w(k)$ com os quatro termos da covariância, e os números $5{,}5$; $1{,}0$; $0{,}1$; $0$.
- **Q2 a):** as raízes $1{,}667$ (AR) e $3{,}33$ (MA), as duas fora do círculo: estacionário e invertível.

## 3. Os oito pontos de perda

1. **Q1 c): "ARMA(1,2)" no lugar de MA(2).** A FAC zera a partir da defasagem 3. Uma FAC que **corta** em $q$ é de um MA($q$); a parte AR faria a FAC decair, nunca zerar. *(conceito, T)*
2. **Q1 a) e b): faltou a frase de fecho.**
   - Em a): "a variância depende de $t$, logo **não é estacionário**" vale 0,1.
   - Em b): "a FAC amostral de um passeio **decai devagar, quase em linha reta**: sinal de raiz unitária" vale 0,2.

   A conta estava pronta. *(V)*
3. **Q1: o $E$ desapareceu.** Escreveu-se $\operatorname{Var}(y_t)=(y_t-\mu)^2$ e $\sum_{i\ne j}u_iu_j$. O certo é $\operatorname{Var}(y_t)=E\big((y_t-\mu)^2\big)$ e $\sum_{i\ne j}E(u_iu_j)=0$. Sem o $E$, a linha afirma algo falso. *(N)*
4. **Q2 b): "$\gamma_0=\operatorname{Cov}(z_t,z_{t-1})$". Foi aqui que travou.**
   - $\gamma_0=\operatorname{Var}(z_t)=E(z_t^2)$;
   - $\gamma_1=\operatorname{Cov}(z_t,z_{t-1})=E(z_tz_{t-1})$.

   Com a definição trocada, o roteiro do ARMA não tem por onde começar. *(N, E)*
5. **A variável do polinômio.** Escreveu-se $\phi(z_t)=1-0{,}6z_t$ e $\theta(a_t)=1-0{,}3\tilde a_t$. A raiz é de um **número**, não da série. Quando a série se chama $z_t$, use outra letra: $\phi(x)=1-0{,}6x=0\Rightarrow x=1{,}667$. *(N)*
6. **Q3 a): a passagem certa foi trocada pela do passeio.** "$y_t-y_{t-1}=\varepsilon_t$" vale para o passeio, não para $y_t=0{,}5y_{t-1}+\varepsilon_t$. O certo:
   - $w_t=0{,}5y_{t-1}+\varepsilon_t-y_{t-1}=-0{,}5y_{t-1}+\varepsilon_t$;
   - para chegar a $(1-0{,}5B)w_t=(1-B)\varepsilon_t$, **multiplica-se $(1-0{,}5B)y_t=\varepsilon_t$ por $(1-B)$**; a forma não deve ser copiada do enunciado;
   - "$\theta=1$, em cima do círculo" estava no caminho, mas a conclusão que vale 0,3 é: "raiz $z=1$ ⇒ **não invertível** ⇒ **sem AR($\infty$)**". *(A, V)*
7. **Q4: o modelo escolhido pelo $\ln L$.** O maior $\ln L$ é o **menos negativo**, $-297{,}0$ do AR(3), e mesmo assim não basta: é preciso penalizar. Com $k$ contando $\sigma^2$:
   - o **AIC** escolhe o AR(3), com 602,0;
   - o **BIC** escolhe o **AR(1)**, com 613,0.

   O "AR(1)" escrito coincidiu com o BIC, mas pelo motivo errado. *(R, E)*
8. **Tempo e ordem.** Com uns 25 minutos de contas curtas no início, entravam:
   - Q4 b): $\widehat\phi=84/120=0{,}7$ e $\widehat\sigma^2=0{,}712$;
   - Q5 b): as previsões do AR(1);
   - Q6 a)–b): o modelo e a contagem.

   São uns 3 pontos sem nenhuma demonstração nova. *(T)*

## 4. A destrava do ARMA: o roteiro de quatro movimentos

Serve para **qualquer** ARMA(1,1). No simulado, $z_t=0{,}6z_{t-1}+a_t-0{,}3a_{t-1}$, com $\sigma^2=1$, na convenção da lista.

$$
\begin{aligned}
\text{(1)}\quad & E(z_ta_t)=0{,}6E(z_{t-1}a_t)+E(a_t^2)-0{,}3E(a_{t-1}a_t)=1 && [\text{modelo}\times a_t;\ \text{caus., RB}]\\
\text{(2)}\quad & E(z_ta_{t-1})=0{,}6E(z_{t-1}a_{t-1})+0-0{,}3E(a_{t-1}^2)=0{,}6-0{,}3=0{,}3 && [\text{modelo}\times a_{t-1};\ (1)]\\
\text{(3)}\quad & \gamma_0=E(z_tz_t)=0{,}6\gamma_1+E(a_tz_t)-0{,}3E(a_{t-1}z_t)=0{,}6\gamma_1+1-0{,}09 && [\text{modelo}\times z_t;\ (1),(2)]\\
\text{(4)}\quad & \gamma_1=E(z_tz_{t-1})=0{,}6\gamma_0+0-0{,}3\cdot1=0{,}6\gamma_0-0{,}3 && [\text{modelo}\times z_{t-1};\ \text{caus.}]\\
\text{(5)}\quad & \gamma_0=0{,}6(0{,}6\gamma_0-0{,}3)+0{,}91=0{,}36\gamma_0+0{,}73 && [(4)\text{ em }(3)]\\
\text{(6)}\quad & \gamma_0=\frac{0{,}73}{0{,}64}=1{,}1406;\quad \gamma_1=0{,}3844;\quad \gamma_2=0{,}6\gamma_1=0{,}2306 && [\text{isola};\ (4)]
\end{aligned}
$$

Na linha (3), o $0{,}09$ é $\theta\cdot(\phi-\theta)=0{,}3\cdot0{,}3$: o primeiro fator é o $\theta$ do modelo, e o segundo é o auxiliar (2). Os dois valem 0,3 só por coincidência. **Não é $\theta^2$.**

Depois do sistema:
- $\rho_1=\gamma_1/\gamma_0=0{,}337$ e $\rho_k=0{,}6\,\rho_{k-1}$ para $k\ge2$;
- $\psi_j=(\phi-\theta)\phi^{j-1}$: 0,3; 0,18; 0,108;
- $\pi_j=(\phi-\theta)\theta^{j-1}$: 0,3; 0,09; 0,027.

É a Q6 da lista com números. A [folha à mão da Q6](../lista_comentada/a_mao_q02_q06.md) é o mesmo roteiro, linha a linha, no sinal dos slides.

> [!TIP]
> **Para não travar de novo**
> Antes de qualquer conta de ARMA, escreva as três primeiras linhas no automático:
> 1. "$\gamma_0=E(z_t^2)$, $\gamma_1=E(z_tz_{t-1})$";
> 2. "momentos auxiliares: $\times a_t$ e $\times a_{t-1}$";
> 3. "$\times z_t$ e $\times z_{t-1}$".
>
> O resto é álgebra de um sistema 2×2.
>
> O mesmo roteiro, com o sentido de cada linha, está na questão-tipo 4 do [guia "não posso errar"](nao_posso_errar.md).

## 5. A regra de prova que muda a nota

1. **Leitura de 3 minutos**, marcando a convenção do MA, o $T$ e o $s$.
2. **Contas curtas primeiro**, em uns 25 minutos:
   - AIC e BIC;
   - $\widehat\phi$ e $\widehat\sigma^2$;
   - raízes;
   - $\psi$ e $\pi$ por fórmula;
   - previsões de 1 a 3 passos;
   - observações perdidas e parâmetros.
3. **Derivações**, da mais curta para a mais longa.
4. **Fechar cada item** com a frase que o verbo pede: "logo, não é estacionário"; "logo, MA(2)"; "logo, não invertível, sem AR($\infty$)".

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s1_q1_corr_t100_k1 | 0,995 |
| pv_s1_q1_corr_t100_k10 | 0,949 |
| pv_s1_q1_g0 | 5,5 |
| pv_s1_q1_g1 | 1,0 |
| pv_s1_q1_g2 | 0,1 |
| pv_s1_q2_raiz_ar | 1,667 |
| pv_s1_q2_raiz_ma | 3,33 |
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
| pv_s1_q4_aic_ar3 | 602,0 |
| pv_s1_q4_bic_ar1 | 613,0 |
| pv_s1_q4_phi | 0,7 |
| pv_s1_q4_s2 | 0,712 |
-->
