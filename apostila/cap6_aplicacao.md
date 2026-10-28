---
title: "Apostila, cap. 6 — Aplicação: Box-Jenkins de ponta a ponta num SARIMA mensal"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: [16]
aulas: "AU02 p. 87, 90–99; AU03 p. 4–22; AU05"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Apostila cap. 6 — Aplicação SARIMA
---

# Capítulo 6 · Aplicação: Box-Jenkins de ponta a ponta num SARIMA mensal

[← apostila](README.md) · anterior: [cap. 5](cap5_previsao.md) · questão da lista: Q16

## Pergunta de abertura

Você tem 240 meses de uma variável macroeconômica, com tendência e sazonalidade. Alguém sugere um SARIMA$(1,1,1)(0,1,1)_{12}$. **Como você sabe se a sugestão é boa?** Não basta estimar: é preciso saber o que a FAC **deveria** mostrar se o modelo estivesse certo, o que os resíduos **deveriam** parecer, e como decidir contra um rival com um parâmetro a mais.

A Q16 é a questão-síntese da lista. Ela usa:
- a notação e a contagem do cap. 3;
- a FAC do cap. 2;
- os critérios do cap. 4;
- o diagnóstico da AU03.

Este capítulo junta as peças no **ciclo de Box-Jenkins** (AU03, p. 4–7).

## A imagem

**Box-Jenkins é um ciclo de diagnóstico médico.** Os passos:
1. **Anamnese:** olhe o gráfico e a FAC.
2. **Hipótese diagnóstica:** identifique um modelo candidato.
3. **Tratamento:** estime.
4. **Exames de controle:** analise os resíduos.

Se os exames acusam algo, como uma autocorrelação que sobrou ou uma variância que muda, **volte ao passo 2**. O ciclo só termina quando os resíduos parecem ruído branco (AU03, p. 4–5).

**Os resíduos são o que o modelo não conseguiu explicar.** Se ainda há padrão neles, há informação na mesa. O Ljung-Box é o exame que pergunta se sobrou alguma correlação, em conjunto, até a defasagem $K$.

**A FAC do SARIMA multiplicativo tem "satélites".** Pense em duas engrenagens acopladas (cap. 3). O MA não sazonal deixa uma marca na defasagem 1, e o sazonal na 12. O produto dos dois cria marcas em 11 e 13, os satélites, em volta do pico sazonal: a assinatura do modelo multiplicativo.

**Um quase fator comum é uma dupla de atores que se anulam em cena.** Quando o AR e o MA têm raízes próximas, um desfaz o que o outro faz. O modelo ainda ajusta bem, mas fica impossível dizer quanto do efeito é de cada um: os erros-padrão explodem.

> [!WARNING]
> **Onde a analogia quebra**
> - **"Resíduo branco" não prova que o modelo é o verdadeiro.** Vários modelos diferentes podem deixar resíduos limpos, e o ciclo seleciona um modelo **adequado**, não o único certo. É por isso que se usa um critério (BIC, LR) para escolher entre os adequados.
> - **O médico examina a pessoa; nós examinamos uma única amostra.** Com 227 observações efetivas, um pico isolado na FAC dos resíduos, num de 24 lags, pode ser acaso: com 5% de nível, espera-se 1,2 rejeição "falsa" em 24. O teste conjunto existe para isso.
> - **Os satélites só aparecem com os dois MA presentes.** Sem o MA não sazonal ($\theta_1=0$), não há satélite em 11 e 13.

## Teoria

**O modelo da Q16**, nos slides:

$$
(1-\phi L)(1-L)(1-L^{12})\,y_t=(1+\theta_1L)(1+\Theta_1L^{12})\,\varepsilon_t,\qquad \theta_1=-\theta^{\text{lista}},\ \ \Theta_1=-\Theta^{\text{lista}} .
$$

Com $w_t=(1-L)(1-L^{12})y_t$, $w_t$ é um ARMA(1,13) **restrito**, com MA só nas defasagens 1, 12 e 13, e o coeficiente da 13 igual a $\theta_1\Theta_1$.

**Ciclo de Box-Jenkins** (AU03, p. 4–7; AU02, p. 96–97):
1. **Identificação:** gráfico, diferenças para estacionarizar, FAC e FACP de $w_t$.
2. **Estimação:** MV, exata ou condicional (cap. 4).
3. **Diagnóstico** (*model checking*): resíduos, estabilidade e previsão.
4. **Uso:** previsão (cap. 5).

**FAC do ARMA com MA de ordem $q$** (AU02, p. 87): para $k\gt q$, vale a recursão do AR. No airline model ($\phi=0$), a FAC de $w_t$ é **zero fora de 1, 11, 12 e 13** (D6.1).

**Diagnóstico dos resíduos** (AU03, p. 9–22):
- **gráficos:** resíduos padronizados no tempo, histograma, QQ-plot e FAC dos resíduos (p. 10);
- **Jarque-Bera:** $JB=\frac{n}{6}\widehat S^2+\frac{n}{24}(\widehat K-3)^2\sim\chi^2_2$, com $H_0$: normalidade (p. 11–14);
- **Ljung-Box:** $LB(K)=T(T+2)\sum_{i=1}^{K}\frac{\widehat\rho_i^2}{T-i}\sim\chi^2_{K-p-q-P-Q}$, com $H_0:\rho_1=\cdots=\rho_K=0$ nos erros (p. 15–17);
- **Breusch-Godfrey:** a versão LM, por regressão auxiliar dos resíduos (p. 18);
- **ARCH-LM:** $\widehat\varepsilon_t^2$ regredido nas próprias defasagens, para detectar heterocedasticidade condicional (p. 19–22).

**Escolha entre rivais** (AU02, p. 98–99): mesmo $T$; BIC para identificar e AIC para prever; LR para modelos aninhados (cap. 4).

## Demonstrações

### D6.1 · A FAC do modelo das companhias aéreas: o pico e os satélites

Com $\phi=0$: $w_t=(1+\theta_1L)(1+\Theta_1L^{12})\varepsilon_t=\varepsilon_t+\theta_1\varepsilon_{t-1}+\Theta_1\varepsilon_{t-12}+\theta_1\Theta_1\varepsilon_{t-13}$. Os coeficientes são $\psi_0=1$, $\psi_1=\theta_1$, $\psi_{12}=\Theta_1$, $\psi_{13}=\theta_1\Theta_1$ e zero nos demais.

$$
\begin{aligned}
\text{(1)}\quad & \gamma_k=\sigma^2\sum_j\psi_j\psi_{j+k} && [\text{cap. 1, D1.3}]\\
\text{(2)}\quad & \gamma_0=\sigma^2\big(1+\theta_1^2+\Theta_1^2+\theta_1^2\Theta_1^2\big)=\sigma^2(1+\theta_1^2)(1+\Theta_1^2) && [k=0;\ \text{fatora}]\\
\text{(3)}\quad & \gamma_1=\sigma^2(\psi_0\psi_1+\psi_{12}\psi_{13})=\sigma^2\theta_1(1+\Theta_1^2) && [k=1]\\
\text{(4)}\quad & \gamma_{11}=\sigma^2\psi_1\psi_{12}=\sigma^2\theta_1\Theta_1 && [k=11:\ \text{só o par } (1,12)]\\
\text{(5)}\quad & \gamma_{12}=\sigma^2(\psi_0\psi_{12}+\psi_1\psi_{13})=\sigma^2\Theta_1(1+\theta_1^2) && [k=12]\\
\text{(6)}\quad & \gamma_{13}=\sigma^2\psi_0\psi_{13}=\sigma^2\theta_1\Theta_1 && [k=13]\\
\text{(7)}\quad & \gamma_k=0 \text{ para } k\notin\{0,1,11,12,13\} && [\text{nenhum par à distância } k]
\end{aligned}
$$

Dividindo por $\gamma_0$:

$$
\boxed{\rho_1=\frac{\theta_1}{1+\theta_1^2},\qquad \rho_{12}=\frac{\Theta_1}{1+\Theta_1^2},\qquad \rho_{11}=\rho_{13}=\rho_1\,\rho_{12}}
$$

Os satélites são o **produto** dos dois picos. É a forma mais rápida de reconhecer um MA multiplicativo na FAC. Com o AR ($\phi\ne0$), as defasagens baixas passam a decair à taxa $\phi$ a partir de $\rho_1$, como no ARMA(1,1) do cap. 2.

### D6.2 · Parâmetros, observações e a equação de $w_t$ (Q16a e Q16b)

$$
\begin{aligned}
\text{(1)}\quad & (1+\theta_1L)(1+\Theta_1L^{12})=1+\theta_1L+\Theta_1L^{12}+\theta_1\Theta_1L^{13} && [\text{F8: quatro produtos}]\\
\text{(2)}\quad & w_t=(1-L)(1-L^{12})y_t=y_t-y_{t-1}-y_{t-12}+y_{t-13} && [\text{F8}]\\
\text{(3)}\quad & w_t=\phi w_{t-1}+\varepsilon_t+\theta_1\varepsilon_{t-1}+\Theta_1\varepsilon_{t-12}+\theta_1\Theta_1\varepsilon_{t-13} && [(1),(2)]\\
\text{(4)}\quad & \text{livres: } \phi,\ \theta_1,\ \Theta_1,\ \sigma^2;\ \ \text{o coeficiente de } \varepsilon_{t-13} \text{ é imposto} && [\text{forma multiplicativa}]\\
\text{(5)}\quad & \text{sem constante: com } d=D=1,\ c\ne0 \text{ geraria tendência quadrática em } y_t && [\text{cap. 3}]\\
\text{(6)}\quad & \text{perdas: } d+sD=1+12=13;\ \ T_{ef}=240-13=227 && [(2) \text{ precisa de } y_{t-13}]
\end{aligned}
$$

$$
\boxed{4 \text{ parâmetros } (\phi,\theta_1,\Theta_1,\sigma^2),\qquad 227 \text{ observações efetivas}}
$$

Na lista: $(1-\phi B)(1-B)(1-B^{12})y_t=(1-\theta B)(1-\Theta B^{12})a_t$, e o termo cruzado do MA é $+\theta\Theta B^{13}$, porque $(-\theta)(-\Theta)=+\theta\Theta$.

### D6.3 · Ljung-Box e LR: as contas que decidem (Q16d e diagnóstico)

$$
\begin{aligned}
\text{(1)}\quad & LB(K)=T(T+2)\sum_{i=1}^{K}\frac{\widehat\rho_i^2}{T-i} && [\text{AU03, p. 15}]\\
\text{(2)}\quad & \nu=K-p-q-P-Q=24-1-1-0-1=21 && [\text{graus de liberdade com } K=24]\\
\text{(3)}\quad & \text{rejeita } H_0 \text{ a 5\% se } LB(24)\gt\chi^2_{21;\,0{,}95}=32{,}67 && [\text{tabela}]\\
\text{(4)}\quad & LR=2\big(\ln L_{(2,1,1)}-\ln L_{(1,1,1)}\big)\ \xrightarrow{d}\ \chi^2(1) && [H_0:\phi_2=0;\ \text{aninhados}]\\
\text{(5)}\quad & \text{rejeita } H_0 \text{ se } LR\gt3{,}84 && [\chi^2_{1;\,0{,}95}]\\
\text{(6)}\quad & \text{BIC: multa } \ln227=5{,}42 \text{ por parâmetro} && [\text{cap. 4}]
\end{aligned}
$$

$$
\boxed{\nu_{LB}=K-p-q-P-Q,\qquad LR\sim\chi^2(1) \text{ com crítico } 3{,}84,\qquad \text{BIC exige } LR\gt\ln T_{ef}=5{,}42}
$$

Ligando (5) e (6): o BIC prefere o modelo maior só se $LR\gt5{,}42$, mais exigente que o teste a 5%, que pede $LR\gt3{,}84$. É a D4.4 do cap. 4 aplicada.

## Exemplo

**1. A FAC teórica.** Com $\theta^{\text{lista}}=0{,}4$ e $\Theta^{\text{lista}}=0{,}6$, ou seja, $\theta_1=-0{,}4$ e $\Theta_1=-0{,}6$ nos slides:

| | $\rho_1$ | $\rho_2$ | $\rho_{11}$ | $\rho_{12}$ | $\rho_{13}$ |
|---|---|---|---|---|---|
| airline ($\phi=0$), pela D6.1 | $-0{,}3448$ | 0 | 0,1521 | $-0{,}4412$ | 0,1521 |
| idem, pelo `ARMAacf` | $-0{,}3448$ | 0 | 0,1521 | $-0{,}4412$ | 0,1521 |
| Q16 ($\phi=0{,}5$) | 0,1052 | | | $-0{,}4411$ | |

O pico sazonal quase não muda com o AR. Já $\rho_1$ muda até de sinal, porque o AR soma memória positiva às defasagens baixas.

**2. Box-Jenkins de ponta a ponta.** Simulei 240 meses do modelo verdadeiro ($\phi=0{,}5$, $\theta_1=-0{,}4$, $\Theta_1=-0{,}6$, $\sigma^2=1$) e estimei o SARIMA$(1,1,1)(0,1,1)_{12}$ no R:

| Parâmetro | verdadeiro | estimado | erro-padrão |
|---|---|---|---|
| $\phi$ | 0,5 | 0,402 | 0,253 |
| $\theta_1$ | $-0{,}4$ | $-0{,}218$ | 0,266 |
| $\Theta_1$ | $-0{,}6$ | $-0{,}705$ | 0,058 |
| $\sigma^2$ | 1 | 0,905 | |

**Como ler:**
- **observações:** o R usou 227, as 240 menos as 13 da D6.2;
- **diagnóstico:** $LB(24)=15{,}39$ com 21 graus de liberdade, $p=0{,}80$. Os resíduos parecem ruído branco, e o modelo é adequado;
- **rival:** contra o SARIMA$(2,1,1)(0,1,1)_{12}$, $LR=0{,}47\lt3{,}84$, e o BIC do menor é 651,42 contra 656,38 do maior. Os dois apontam o modelo da Q16;
- **o alerta:** $\widehat\phi$ e $\widehat\theta_1$ têm erros-padrão de ~0,25, enormes perto dos valores. O motivo é um **quase fator comum**: $(1-0{,}5L)$ no AR e $(1-0{,}4L)$ no MA, com raízes 2 e 2,5, quase se cancelam. O par se anula em cena, e os dados não separam um do outro. Já o $\Theta_1$, sem rival, é estimado com precisão.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_c6_air_rho1 | -0,3448 |
| ap_c6_air_rho12 | -0,4412 |
| ap_c6_air_rho11 | 0,1521 |
| ap_c6_air_rho1_r | -0,3448 |
| ap_c6_air_rho2_r | 0 |
| ap_c6_air_rho11_r | 0,1521 |
| ap_c6_air_rho12_r | -0,4412 |
| ap_c6_air_rho13_r | 0,1521 |
| ap_c6_q16_rho1 | 0,1052 |
| ap_c6_q16_rho12 | -0,4411 |
| ap_c6_npar | 4 |
| ap_c6_efetivas | 227 |
| ap_c6_ln227 | 5,42 |
| ap_c6_lb_gl | 21 |
| ap_c6_lb_crit | 32,67 |
| ap_c6_lr_crit | 3,84 |
| ap_c6_est_phi | 0,402 |
| ap_c6_est_th | -0,218 |
| ap_c6_est_TH | -0,705 |
| ap_c6_est_s2 | 0,905 |
| ap_c6_se_phi | 0,253 |
| ap_c6_se_th | 0,266 |
| ap_c6_se_TH | 0,058 |
| ap_c6_est_nobs | 227 |
| ap_c6_lb_stat | 15,39 |
| ap_c6_lb_p | 0,80 |
| ap_c6_lr | 0,47 |
| ap_c6_bic1 | 651,42 |
| ap_c6_bic2 | 656,38 |
-->

## Cadeia socrática

**P1.** Por que o coeficiente de $\varepsilon_{t-13}$ não conta como parâmetro?

> [!TIP]
> **Resposta**
> Porque ele é o produto $\theta_1\Theta_1$, imposto pela forma multiplicativa. Não há um quinto número livre: conhecidos $\theta_1$ e $\Theta_1$, ele está determinado (D6.2).

**P2.** Por que não colocar uma constante, se a série cresce?

> [!TIP]
> **Resposta**
> Porque o crescimento já está nas duas raízes unitárias. Com $d=D=1$, uma constante em $w_t$ vira uma tendência **quadrática** em $y_t$, o que raramente faz sentido. É a regra 5 das notas de identificação de Duke e o argumento do cap. 3.

**P3.** Se o airline model tem FAC zero fora de 1, 11, 12 e 13, o que indica um pico em 24?

> [!TIP]
> **Resposta**
> Que falta algo sazonal: um AR sazonal, que geraria picos decaindo em 12, 24, 36…, ou um MA sazonal de ordem 2. O MA(1)$_{12}$ sozinho não gera nada em 24.

**P4.** Por que o Ljung-Box tem $K-p-q-P-Q$ graus de liberdade, e não $K$?

> [!TIP]
> **Resposta**
> Porque os resíduos vêm de um modelo **estimado**: cada parâmetro de AR e MA ajustado "consome" um grau de liberdade das autocorrelações, que ficam menores do que seriam com os choques verdadeiros. A variância $\sigma^2$ não entra na conta (AU03, p. 15).

**P5.** Os resíduos passaram no Ljung-Box. Acabou o diagnóstico?

> [!TIP]
> **Resposta**
> Não. Faltam:
> - a **normalidade** (JB), que importa para os intervalos;
> - a **heterocedasticidade condicional** (ARCH-LM, FAC de $\widehat\varepsilon_t^2$);
> - a **estabilidade** (Chow e CUSUM).
>
> O Ljung-Box só olha a dependência **linear** nos resíduos (AU03, p. 7 e 19–30).

**P6.** No exemplo, por que $\widehat\phi$ e $\widehat\theta_1$ saíram tão imprecisos?

> [!TIP]
> **Resposta**
> Porque $(1-0{,}5L)$ e $(1+\theta_1L)=(1-0{,}4L)$ quase se cancelam: é um quase fator comum (cap. 2, P9). Os dados identificam bem o **efeito líquido**, mas não a divisão entre AR e MA. A regra de Duke manda testar o modelo com um AR e um MA a menos.

**P7.** Por que comparar com o SARIMA$(2,1,1)(0,1,1)_{12}$ pelo BIC, e não pelo $R^2$?

> [!TIP]
> **Resposta**
> Porque o $R^2$, ou a verossimilhança pura, sempre melhora com o parâmetro a mais: o maior contém o menor. O BIC desconta $\ln227=5{,}42$ por parâmetro. E, como são aninhados, o LR dá uma confirmação com nível conhecido (D6.3).

**P8.** E se um modelo usasse $d=0$ e o outro $d=1$? Ainda posso comparar pelo BIC?

> [!TIP]
> **Resposta**
> Não diretamente. As variáveis modeladas são diferentes, $y_t$ e $\Delta y_t$, e o número de observações efetivas também. A regra é mesmo $T$ e mesma série (AU02, p. 99). A escolha de $d$ e $D$ vem antes, pela identificação e pelos testes de raiz unitária.

## Diálogo

*Sobre "os resíduos passaram, então o modelo está certo".*

**Aluno:** Estimei o SARIMA da Q16, e o Ljung-Box deu $p=0{,}80$. O modelo está certo.

**Professor:** Certo em que sentido?

**Aluno:** Os resíduos são ruído branco.

**Professor:** O teste mostrou que eles **são** ruído branco?

**Aluno:** … Mostrou que eu não rejeito que sejam, até a defasagem 24.

**Professor:** E um SARIMA$(2,1,1)(0,1,1)_{12}$ também deixaria resíduos brancos?

**Aluno:** Provavelmente sim: ele contém o meu como caso particular.

**Professor:** Então o Ljung-Box escolhe entre os dois?

**Aluno:** Não. Ele separa os modelos adequados dos inadequados. Para escolher **entre** os adequados, preciso de outro critério: o BIC ou o LR. No exemplo, os dois ficaram com o menor.

**Professor:** E olhando as estimativas, nada incomoda?

**Aluno:** Os erros-padrão de $\phi$ e $\theta_1$ são enormes… e as raízes do AR e do MA estão perto, 2 e 2,5. Pode ser um quase fator comum. Eu testaria também um modelo sem os dois, só com o MA sazonal.

**Professor:** Esse é o ciclo de Box-Jenkins: o diagnóstico manda de volta para a identificação.

## Na prova

| Questão | O que este capítulo dá | Resolução completa |
|---|---|---|
| Q16 (a) | o modelo em $B$, com o termo cruzado $+\theta\Theta B^{13}$ | [Q16](../lista_comentada/q16.md) |
| Q16 (b) | 4 parâmetros e 227 observações efetivas | [Q16](../lista_comentada/q16.md) |
| Q16 (c) | FAC de $w_t$: pico em 12, satélites em 11 e 13, decaimento à taxa $\phi$ | [Q16](../lista_comentada/q16.md) |
| Q16 (d) | BIC (identificação) com o LR como confirmação, mesmo $T$ | [Q16](../lista_comentada/q16.md) |
| Q12 (d) | o roteiro de diagnóstico de resíduos | [Q12](../lista_comentada/q12.md) |

**Armadilhas:**
- contar 5 parâmetros, tratando $\theta\Theta$ como livre, ou 3, esquecendo $\sigma^2$;
- errar o sinal do termo cruzado na lista: $(-\theta)(-\Theta)=+\theta\Theta$;
- usar $K$ graus de liberdade no Ljung-Box, em vez de $K-p-q-P-Q$;
- esperar um pico em 24 com um MA sazonal de ordem 1;
- dizer que "resíduo branco" prova que o modelo é o verdadeiro.

**Checklist de 30 segundos:**
1. Escrevi o modelo com os quatro polinômios e expandi o MA?
2. Contei os parâmetros, incluindo $\sigma^2$, e as observações perdidas, $d+sD$?
3. Descrevi a FAC com o pico, os satélites e o decaimento?
4. Listei o diagnóstico completo: gráficos, JB, LB com os graus de liberdade certos, ARCH e estabilidade?
5. Recomendei um critério **e** disse por quê (aninhados, mesmo $T$, objetivo)?

## No material do professor

**Roteiro de releitura:**
- AU03, p. 4–7: o ciclo de Box-Jenkins e as duas dimensões da avaliação;
- AU03, p. 9–22: diagnóstico dos resíduos (gráficos, JB, Ljung-Box, Breusch-Godfrey, ARCH);
- AU03, p. 23–31: estabilidade, com Chow e análise recursiva/CUSUM;
- AU02, p. 87 e 90–97: FAC do ARMA($p,q$), FACP e identificação;
- AU02, p. 98–99: AIC, BIC e a regra do mesmo $T$;
- AU05: SARIMA.

**Livros:**
- **BJRL**, cap. 9: o modelo das companhias aéreas, a FAC dos multiplicativos e a estratégia de partir dele;
- **ENDERS**, cap. 2: Box-Jenkins e diagnóstico no nível do curso;
- **HAMILTON**, cap. 5: a verossimilhança e os testes LR.

**Na lista comentada:** [Q16](../lista_comentada/q16.md) · [Q12](../lista_comentada/q12.md) · [Q14](../lista_comentada/q14.md).
