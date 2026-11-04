---
title: "O básico da P1 — o que precisa sair sem pensar"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
prova: "05/11/2026"
lista: LST
status: verificado
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - O básico da P1
---

# O básico da P1: o que precisa sair sem pensar

Esta é a folha para levar consolidada. São três camadas, em ordem de prioridade: **definições, contas de uma linha e três derivações-molde**. Se elas saem sem pensar, a maior parte da prova sai. Os exemplos numéricos são os do [Simulado 01](simulado_01_gabarito.md), para conferir. Esta folha diz **o que** saber; o passo a passo de **como fazer**, linha a linha e com o sentido de cada passo, está no [guia "não posso errar"](nao_posso_errar.md).

## Camada 1: seis definições

| O que | Como escrever |
|---|---|
| momentos (média zero; com média, use $y-\mu$) | $\gamma_0=\operatorname{Var}(y_t)=E(y_t^2)$; $\gamma_k=E(y_ty_{t-k})$; $\rho_k=\gamma_k/\gamma_0$ |
| estacionário | $\mu$ e $\gamma_0$ constantes **e** $\gamma_k$ dependendo só de $k$: as três condições |
| ruído branco | $E(\varepsilon_t)=0$, $E(\varepsilon_t^2)=\sigma^2$, $E(\varepsilon_t\varepsilon_s)=0$ se $s\ne t$ |
| causalidade | $E(\varepsilon_ty_{t-k})=0$ para $k\ge1$; $E(\varepsilon_ty_t)=\sigma^2$ |
| raiz de um polinômio | $\phi(x)=0$, com $x$ um **número**, não a série; fora do círculo: $\lvert x\rvert\gt1$ |
| convenção do MA | lista: $1-\theta B$; slides: $1+\theta_1L$; logo $\theta_1=-\theta$. **Escrever na 1ª linha** |

## Camada 2: as contas de uma linha, os pontos mais baratos

| Conta | Fórmula | Exemplo (S1) |
|---|---|---|
| raízes de AR(1) e MA(1) | $1-\phi x=0\Rightarrow x=1/\phi$ | $\phi=0{,}6$: $x=1{,}667$; $\theta=0{,}3$: $x=3{,}33$ |
| raízes de grau 2 | Bhaskara; conferir com Vieta: soma $-b/a$, produto $c/a$ | (lista, Q5 e Q7) |
| ARMA(1,1), pesos (lista) | $\psi_j=(\phi-\theta)\phi^{j-1}$; $\pi_j=(\phi-\theta)\theta^{j-1}$ | $\psi$: 0,3; 0,18; 0,108. $\pi$: 0,3; 0,09; 0,027 |
| ARMA(1,1), momentos (lista) | $\gamma_0=\frac{1+\theta^2-2\phi\theta}{1-\phi^2}\sigma^2$; $\gamma_1=\phi\gamma_0-\theta\sigma^2$; $\rho_k=\phi\rho_{k-1}$ | $\gamma_0=1{,}1406$; $\gamma_1=0{,}3844$; $\rho_1=0{,}337$ |
| AIC e BIC | $-2\ln L+2k$; $-2\ln L+k\ln T$; $k$ **com $\sigma^2$**; o menor vence | AIC: AR(3), 602,0; BIC: AR(1), 613,0 |
| MQO do AR(1) | $\widehat\phi=\frac{\sum y_ty_{t-1}}{\sum y_{t-1}^2}$; $\widehat\sigma^2=\frac{\sum y_t^2-\widehat\phi\sum y_ty_{t-1}}{T-1}$ | $\widehat\phi=0{,}7$; $\widehat\sigma^2=0{,}712$ |
| SARIMA | perdas $d+sD$; parâmetros $p+q+P+Q+1$ (o $+1$ é o $\sigma^2$); termo cruzado $+\theta\Theta B^{s+1}$ | mensal com $d=D=1$, $T=180$: perde 13, sobram 167 |
| previsão do AR(1) | $\widehat y_{T+h}=\mu+\phi^h(y_T-\mu)$; $\operatorname{Var}(e)=\sigma^2\sum_{j\lt h}\psi_j^2$ | 11,6; 11,28; 11,024; variâncias 4; 6,56; 8,1984 |
| intervalo de 95% | $\widehat y\pm1{,}96\sqrt{\operatorname{Var}(e)}$ | $h=1$: [7,68; 15,52] |
| previsão do MA($q$) | para $h\gt q$: $\widehat y=\mu$ e $\operatorname{Var}(e)=\gamma_0$ | (lista, Q15) |

## Camada 3: três derivações-molde

**1. Telescópica** (lista, Q1, Q2 e Q8-II). Some o modelo de 1 a $t$, para obter $y_t=y_0+(\text{parte fixa})+\sum_{s=1}^{t}\varepsilon_s$. Depois:
- $E(\cdot)$, com a esperança entrando na soma finita;
- $\operatorname{Var}=t\sigma^2$, porque só $i=j$ sobra;
- $\operatorname{Cov}=(t-k)\sigma^2$, pelos choques comuns;
- **fechar com "não estacionário"**.

**2. ARMA em quatro movimentos** (lista, Q6, Q7, Q8-I e Q11). Multiplique o modelo e tire a esperança:
1. por $\varepsilon_t$ e por $\varepsilon_{t-1}$, que dão os momentos auxiliares;
2. por $y_t$, que dá a equação de $\gamma_0$;
3. por $y_{t-1}$, que dá a equação de $\gamma_1$;
4. resolva o sistema 2×2.

No AR(2), os passos 2 e 3 são o Yule-Walker. O roteiro com números está na [correção do S1](correcao_simulado_01.md#4-a-destrava-do-arma-o-roteiro-de-quatro-movimentos).

**3. Polinômios em $B$** (lista, Q9, Q10b, Q11c, Q12a e Q16a). Multiplique os polinômios termo a termo, sempre aplicando o operador **aos dois lados**: $(1-0{,}5B)y_t=\varepsilon_t$ vira $(1-0{,}5B)(1-B)y_t=(1-B)\varepsilon_t$. Se aparecer $(1-B)$ no MA, a raiz é $1$: **não invertível, sem AR($\infty$)**.

## Reconhecer pela FAC e pela FACP

- **A FAC corta** em $q$: **MA($q$)**. **A FACP corta** em $p$: **AR($p$)**. As duas decaem: ARMA.
- FAC **perto de 1, caindo devagar**: raiz unitária; diferenciar.
- $\rho_1\approx-0{,}5$ depois de diferenciar: **sobrediferenciação**.
- Picos em $s,2s,\dots$, decaindo: SAR. Pico **só** em $s$, com **satélites** em $s\pm1$: SMA multiplicativo. No S1, $\rho_{12}=-0{,}4412$ e $\rho_{11}=\rho_{13}=0{,}1521$.
- O **AIC** prevê melhor; o **BIC** é consistente e acha o modelo verdadeiro, se ele está na lista.

## Na prova

1. **3 minutos** de leitura: convenção do MA, $T$ e $s$.
2. **Cerca de 25 minutos**: só as contas da camada 2, de todas as questões.
3. **Derivações** da camada 3, da mais curta para a mais longa.
4. **Fechar com a frase do verbo:** "logo, não é estacionário"; "logo, MA(2)"; "logo, não invertível, sem AR($\infty$)".

**Pode ficar de fora:**
- a verossimilhança exata;
- Phillips-Perron, DF-GLS e KPSS. **O Dickey-Fuller entra**, com a cadeia de decisão: ver [o que cai](o_que_cai.md#8-teste-de-raiz-unitária-a-cadeia-de-decisão-do-dickey-fuller);
- Beveridge-Nelson;
- Yule-Walker (riscado no quadro de 04/11);
- MASE, DM, Winkler e CRPS. **RMSE e MAPE entram**, para interpretar: ver [o que cai](o_que_cai.md#6-interpretar-aic-bic-rmse-e-mape-sem-conta).
- a matriz $F$.

De Wold, basta o enunciado em uma linha e o AR(1) como exemplo.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s1_q2_raiz_ar | 1,667 |
| pv_s1_q2_raiz_ma | 3,33 |
| pv_s1_q2_psi1 | 0,3 |
| pv_s1_q2_psi2 | 0,18 |
| pv_s1_q2_psi3 | 0,108 |
| pv_s1_q2_pi1 | 0,3 |
| pv_s1_q2_pi2 | 0,09 |
| pv_s1_q2_pi3 | 0,027 |
| pv_s1_q2_g0 | 1,1406 |
| pv_s1_q2_g1 | 0,3844 |
| pv_s1_q2_rho1 | 0,337 |
| pv_s1_q4_aic_ar3 | 602,0 |
| pv_s1_q4_bic_ar1 | 613,0 |
| pv_s1_q4_phi | 0,7 |
| pv_s1_q4_s2 | 0,712 |
| pv_s1_q6_perda | 13 |
| pv_s1_q6_efetivas | 167 |
| pv_s1_q5_f1 | 11,6 |
| pv_s1_q5_f2 | 11,28 |
| pv_s1_q5_f3 | 11,024 |
| pv_s1_q5_v1 | 4 |
| pv_s1_q5_v2 | 6,56 |
| pv_s1_q5_v3 | 8,1984 |
| pv_s1_q5_li1 | 7,68 |
| pv_s1_q5_ls1 | 15,52 |
| pv_s1_q6_rho12 | -0,4412 |
| pv_s1_q6_rho11 | 0,1521 |
-->
