---
title: "O que cai na P1 — o quadro do professor (04/11)"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
prova: "05/11/2026"
lista: [1, 3, 5, 6, 12, 14, 15, 16]
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - O que cai na P1
---

# O que cai na P1: o quadro de 04/11

Na aula de quarta, o professor anunciou o formato e listou os tópicos no quadro. Esta folha organiza o que ele disse em **quatro questões prováveis** e aponta, para cada uma, onde treinar. Onde o material ainda não cobria o que o quadro pede, a seção está aqui mesmo: montar e desenhar a FAC, o SMA sazonal, a equação de previsão, o ciclo de modelagem e a interpretação de AIC, BIC, RMSE e MAPE.

> [!IMPORTANT]
> **O que foi anunciado**
> - **4 questões de 2,5 pontos.**
> - AIC e BIC caem para **interpretar**, não necessariamente para calcular. RMSE e MAPE entram junto.
> - Cai uma questão de **previsão**.
> - **Yule-Walker foi riscado: não cai.** A questão-tipo 5 do guia fica com prioridade zero.
>
> **Anotado também em aula:** usar BIC, RMSE e MAPE; **identificar a ordem pela FAC** (seção 7); e o **teste de raiz unitária de Dickey-Fuller**, com a cadeia de decisão que começa pelo modelo 3 (seção 8).

## 1. As quatro questões prováveis

| Questão provável | O que o quadro pede | Onde treinar |
|---|---|---|
| A. Processos | passeio aleatório; $z_3=z_1+2z_2$ (circulado no quadro); $E$, $V$, $\operatorname{Cov}$; estacionário? | questões-tipo 1 e 2 do [guia](nao_posso_errar.md) |
| B. ARMA | estacionário pelas raízes de $(1-\phi B)$; **montar a FAC**, com conta e desenho; FAC e FACP | questões-tipo 3 e 4; seções 2 e 3 abaixo |
| C. SARIMA | o SMA(1) sazonal desenhado; a equação de previsão; o $d$ pelo Dickey-Fuller | questão-tipo 9; seções 3, 4 e 8 abaixo |
| D. Ciclo e análise | o ciclo de modelagem; identificar a ordem; raiz unitária; interpretar AIC, BIC, RMSE e MAPE; previsão | questão-tipo 8; seções 5 a 8 abaixo |

O treino no formato anunciado é o [Simulado 05](simulado_05.md): 4 questões de 2,5, em 1 hora.

## 2. Montar a FAC: a conta e o desenho

O quadro diz "montar a FAC" com duas coisas: **a conta**, que são os $\gamma_k$ e os $\rho_k$, e **o desenho**. As duas vão juntas na resposta.

**A conta, no AR(1)** $(1-\phi B)y_t=u_t$, com $\phi=0{,}7$ e $\sigma^2=1$:

$$
\begin{aligned}
\text{(1)}\quad & 1-0{,}7x=0\Rightarrow x=1/0{,}7=1{,}43,\ \lvert x\rvert\gt1 && [\text{estacionário}]\\
\text{(2)}\quad & \gamma_0=\frac{\sigma^2}{1-\phi^2}=\frac{1}{0{,}51}=1{,}9608 && [\times y_t,\ E]\\
\text{(3)}\quad & \gamma_k=\phi\,\gamma_{k-1},\ k\ge1 && [\times y_{t-k};\ \text{caus.}]\\
\text{(4)}\quad & \rho_k=\phi^k:\ \rho_1=0{,}7;\ \rho_2=0{,}49;\ \rho_3=0{,}343 && [\div\gamma_0]
\end{aligned}
$$

**A conta, no ARMA(1,1)** da questão-tipo 4 ($\phi=0{,}6$ e $\theta=0{,}3$): $\rho_1=0{,}337$ e, depois, $\rho_k=0{,}6\rho_{k-1}$. Isso dá $\rho_2=0{,}2022$ e $\rho_3=0{,}1213$. A FAC decai como a do AR(1), mas **a partir de $\rho_1$**.

**O desenho**, em quatro passos:
1. Eixo horizontal com as defasagens $k=1,2,3,\dots$ e eixo vertical de $-1$ a $1$, com a linha do zero.
2. Uma barra vertical em cada $k$, com a altura de $\rho_k$. A barra de $k=0$ vale sempre 1; pode ser omitida, como no R.
3. Marque os **números** das três primeiras barras: o desenho vale mais com a conta ao lado.
4. Escreva o **padrão** em uma frase: "decai geometricamente", "corta depois de $q$", "alterna de sinal" (quando $\phi\lt0$) ou "picos só nas sazonais".

Numa FAC **amostral**, desenhe também as bandas $\pm2/\sqrt T$: as barras dentro delas não são diferentes de zero.

## 3. Reconhecer pela FAC e pela FACP

| Modelo | FAC | FACP |
|---|---|---|
| AR($p$) | decai (geométrica; alterna se $\phi\lt0$) | **corta** depois de $p$ |
| MA($q$) | **corta** depois de $q$ | decai |
| ARMA($p,q$) | decai | decai |
| passeio (raiz unitária) | decai **muito devagar**, quase em linha reta | um pico perto de 1 em $k=1$ |
| SMA(1)$_s$ | **um pico só, em $s$** | picos em $s,2s,3s$, **decaindo** |
| SAR(1)$_s$ | picos em $s,2s,3s$, **decaindo** | **um pico só, em $s$** |
| multiplicativo $(0,1,1)(0,1,1)_s$ | picos em 1 e $s$, com satélites em $s\pm1$ | decai perto de 1 e de $s$ |

A regra de bolso: **AR corta na FACP; MA corta na FAC**. No sazonal, vale a mesma regra, só que nas defasagens $s,2s,\dots$.

![Os seis padrões de FAC e FACP para desenhar à mão](figuras/fac_facp_padroes.png)

**O SMA(1)$_4$ do quadro**, com $y_t=(1-0{,}5B^4)a_t$ e $\sigma^2=1$:
- $\gamma_0=(1+\Theta^2)\sigma^2=1{,}25$ e $\gamma_4=-\Theta\sigma^2$;
- $\rho_4=-\Theta/(1+\Theta^2)=-0{,}4$, e **todas as outras são zero**: os choques só se sobrepõem a 4 períodos de distância;
- a FACP tem picos em 4, 8 e 12, que valem $-0{,}4$, $-0{,}1905$ e $-0{,}0941$, decaindo, e zero no resto.

É exatamente o desenho do quadro: na FAC, uma barra em 4; na FACP, barras em 4, 8 e 12, cada vez menores.

## 4. A equação de previsão

São três regras, sempre a partir do **modelo escrito na data futura**:
1. o que já é conhecido em $T$ fica como está;
2. o choque futuro vira 0;
3. o $y$ futuro vira a sua previsão.

| Modelo | Equação de previsão |
|---|---|
| AR(1) com média $\mu$ | $\widehat y_T(h)=\mu+\phi^h(y_T-\mu)$ |
| ARMA(1,1), lista | $\widehat y_T(1)=\phi y_T-\theta\widehat a_T$; $\widehat y_T(h)=\phi\,\widehat y_T(h-1)$ para $h\ge2$ |
| MA($q$) | para $h\gt q$, $\widehat y_T(h)=\mu$ |

**O SARIMA$(0,1,1)(0,1,1)_4$**, que é o caso sazonal típico, em quatro passos:
1. Expanda $(1-B)(1-B^4)y_t=(1-\theta B)(1-\Theta B^4)a_t$:
   $$y_t=y_{t-1}+y_{t-4}-y_{t-5}+a_t-\theta a_{t-1}-\Theta a_{t-4}+\theta\Theta a_{t-5}.$$
2. Escreva em $T+1$ e aplique as regras:
   $$\widehat y_T(1)=y_T+y_{T-3}-y_{T-4}-\theta\widehat a_T-\Theta\widehat a_{T-3}+\theta\Theta\widehat a_{T-4}.$$
3. Em $T+2$, o $y_{T+1}$ vira $\widehat y_T(1)$, e o $a_{T+1}$ vira 0:
   $$\widehat y_T(2)=\widehat y_T(1)+y_{T-2}-y_{T-3}-\Theta\widehat a_{T-2}+\theta\Theta\widehat a_{T-3}.$$
4. Os resíduos $\widehat a$ aparecem **até $h=5=s+1$**, a maior defasagem do MA. Daí em diante, $\widehat y_T(h)=\widehat y_T(h-1)+\widehat y_T(h-4)-\widehat y_T(h-5)$.

A variância do erro é $\sigma^2\sum_{j\lt h}\psi_j^2$ e cresce com $h$, porque cada passo acrescenta um choque futuro; o intervalo é $\widehat y\pm1{,}96\sqrt{\operatorname{Var}}$. O AR(1) com números está na questão-tipo 8 do [guia](nao_posso_errar.md); a variação no [banco, Q12](banco.md#q12--previsão-do-sarima-trimestral).

## 5. O ciclo de modelagem de Box-Jenkins

| Etapa | O que se faz | O que se olha |
|---|---|---|
| 1. Identificação | gráfico da série; diferenciar até ficar estacionária ($d$ e $D$); propor $p,q,P,Q$ | FAC e FACP; FAC que decai devagar pede diferença |
| 2. Estimação | estimar os candidatos por MV | coeficientes significativos; **AIC e BIC** para escolher |
| 3. Diagnóstico | checar se os resíduos são ruído branco | FAC dos resíduos dentro das bandas; **Ljung-Box** não rejeita |
| 4. Previsão | prever e avaliar fora da amostra | **RMSE e MAPE**; intervalos |

**Se o diagnóstico falha, volta-se à etapa 1**: é um ciclo, não uma linha reta. Na prova, escreva as quatro etapas, uma frase cada, e a seta de volta. O ciclo completo, com a Q16, está no [cap. 6 da apostila](../apostila/cap6_aplicacao.md).

## 6. Interpretar AIC, BIC, RMSE e MAPE, sem conta

| Critério | O que mede | Onde | Como ler |
|---|---|---|---|
| AIC | ajuste $-2\ln L$ mais multa de 2 por parâmetro | dentro da amostra | menor é melhor; tende a aceitar parâmetros a mais |
| BIC | ajuste mais multa de $\ln T$ por parâmetro | dentro da amostra | menor é melhor; multa maior, escolhe modelos menores; **consistente** |
| RMSE | raiz do erro quadrático médio | **fora** da amostra | menor é melhor; na escala da série; pune erros grandes |
| MAPE | erro percentual absoluto médio | **fora** da amostra | menor é melhor; em %, compara séries diferentes; falha com $y$ perto de 0 |

**As quatro regras de leitura:**
1. **Menor é melhor nos quatro.**
2. **Diferença de AIC ou BIC menor que 2 é empate prático**; acima de uns 4, já é preferência clara.
3. AIC e BIC olham o **passado** que o modelo já viu; RMSE e MAPE olham dados que ele **não viu**. Quando discordam, para prever, pesa mais o erro fora da amostra.
4. Entre modelos quase empatados, fica o **mais parcimonioso**.

**Exemplo com a resposta escrita.** Dois modelos para uma série mensal:

| Modelo | AIC | BIC | RMSE | MAPE |
|---|---|---|---|---|
| AR(1) | 512,3 | **519,8** | **0,84** | **3,2%** |
| ARMA(2,1) | **509,1** | 524,0 | 0,91 | 3,5% |

> "O AIC prefere o ARMA(2,1), por 3,2 pontos, mas o BIC prefere o AR(1), por 4,2: a melhora do ajuste não paga os dois parâmetros extras quando a multa é $\ln T$. Fora da amostra, o AR(1) tem RMSE e MAPE menores, o que indica que o ganho do ARMA(2,1) dentro da amostra era sobreajuste. **Escolho o AR(1)**: mais parcimonioso, preferido pelo BIC e melhor na previsão."

É esse o formato: **o que cada critério escolhe, por quanto, por que discordam e a decisão**.

## 7. Identificar a ordem pela FAC e pela FACP amostrais

Na prova, a FAC e a FACP vêm **estimadas**, com ruído. A ordem sai de quatro passos:
1. Calcule a banda: $\pm2/\sqrt T$. Com $T=100$, é $\pm0{,}2$.
2. Na FAC, conte as defasagens **fora da banda** até a primeira que entra e fica dentro: esse é o candidato a $q$.
3. Na FACP, faça o mesmo: é o candidato a $p$.
4. Decida pelo formato: a que **corta** dá a ordem; a que **decai** diz qual é o outro lado. Se as duas decaem, proponha um ARMA(1,1) e compare candidatos pelo BIC.

**Exemplo**, com $T=100$ e banda $\pm0{,}2$:

| $k$ | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|
| FAC | 0,48 | 0,25 | 0,07 | $-0{,}05$ | 0,03 |
| FACP | 0,48 | $-0{,}26$ | 0,15 | $-0{,}09$ | 0,04 |

A FAC tem duas barras fora da banda (0,48 e 0,25) e depois **corta**. A FACP **decai**, alternando o sinal. Logo, **MA(2)**.

Cuidados que valem ponto:
- uma barra isolada fora da banda numa defasagem alta, como 9, sem padrão, é ruído: com 20 defasagens, espera-se uma fora por acaso a 5%;
- uma barra fora da banda em $s$, $2s$ é sazonal: leia como na seção 3;
- uma FAC que fica alta e cai devagar **não tem ordem**: é raiz unitária. Antes de identificar, diferencie (seção 8).

## 8. Teste de raiz unitária: a cadeia de decisão do Dickey-Fuller

**A ideia.** Escreva $y_t=\rho\,y_{t-1}+u_t$ como $\Delta y_t=\gamma\,y_{t-1}+u_t$, com $\gamma=\rho-1$.
- **$H_0$: $\gamma=0$**, raiz unitária: a série é não estacionária e precisa de diferença.
- **$H_1$: $\gamma\lt0$**, sem raiz unitária.

A estatística é o $t$ de $\widehat\gamma$, que aqui se chama $\tau$. Sob $H_0$, ela **não segue a $t$ de Student**: os valores críticos são os de Dickey-Fuller, mais negativos.

**Os três modelos** (no ADF, acrescente $\sum_i\beta_i\Delta y_{t-i}$ a cada um, para os resíduos ficarem ruído branco):

| Modelo | Regressão | Teste de $\gamma=0$ | Teste conjunto |
|---|---|---|---|
| 3: constante e tendência | $\Delta y_t=a_0+\gamma y_{t-1}+a_2t+u_t$ | $\tau_\tau$ | $\phi_3$: $\gamma=a_2=0$ |
| 2: só constante | $\Delta y_t=a_0+\gamma y_{t-1}+u_t$ | $\tau_\mu$ | $\phi_1$: $a_0=\gamma=0$ |
| 1: nada | $\Delta y_t=\gamma y_{t-1}+u_t$ | $\tau$ | — |

**Valores críticos a 5%**, para $T=100$:

| $\tau_\tau$ (modelo 3) | $\tau_\mu$ (modelo 2) | $\tau$ (modelo 1) | $\phi_3$ | $\phi_1$ |
|---|---|---|---|---|
| $-3{,}45$ | $-2{,}89$ | $-1{,}95$ | 6,49 | 4,71 |

**A regra de decisão:**
- para os $\tau$: **rejeita $H_0$ se a estatística for menor (mais negativa) que o crítico**;
- para os $\phi$: rejeita se a estatística for **maior** que o crítico.

Rejeitar $H_0$ quer dizer **não há raiz unitária**.

**Por que começar pelo modelo 3.** É o mais geral. Se a série tem tendência e o modelo a omite, o teste quase nunca rejeita, e uma série estacionária em torno de tendência parece ter raiz unitária. Por isso, começa-se com tudo e só se tira um termo determinístico depois de testar que ele não pertence ao modelo.

**A cadeia, passo a passo:**
1. **Estime o modelo 3 e compare $\tau_\tau$ com $-3{,}45$.**
   - Se $\tau_\tau\lt-3{,}45$: **rejeita**, não há raiz unitária. Pare.
   - Se não: passo 2.
2. **A tendência pertence ao modelo? Use $\phi_3$**, com $H_0$: $\gamma=a_2=0$.
   - Se $\phi_3\gt6{,}49$: a tendência está lá. Teste $\gamma=0$ de novo, agora com a **normal** (crítico $-1{,}65$). Se rejeitar, não há raiz unitária; se não, há raiz unitária, com tendência. Pare.
   - Se não: tire a tendência e vá ao passo 3.
3. **Estime o modelo 2 e compare $\tau_\mu$ com $-2{,}89$.**
   - Se $\tau_\mu\lt-2{,}89$: **rejeita**. Pare.
   - Se não: passo 4.
4. **A constante pertence ao modelo? Use $\phi_1$**, com $H_0$: $a_0=\gamma=0$.
   - Se $\phi_1\gt4{,}71$: há drift. Teste $\gamma=0$ com a **normal** e decida. Pare.
   - Se não: passo 5.
5. **Estime o modelo 1 e compare $\tau$ com $-1{,}95$.**
   - Se $\tau\lt-1{,}95$: rejeita, e a série é estacionária com média zero.
   - Se não: **raiz unitária**, um passeio sem drift.

**Depois da cadeia:**
- **Se ficou raiz unitária:** diferencie e repita a cadeia em $\Delta y_t$. O número de diferenças até rejeitar é o $d$ do ARIMA.
- **Se rejeitou no modelo 3:** a série é estacionária em torno de tendência (TS). Tira-se a tendência por regressão, **não se diferencia**: diferenciar seria a sobrediferenciação da questão-tipo 6.
- **No ADF:** o número de defasagens de $\Delta y$ é escolhido pelo BIC, ou até os resíduos virarem ruído branco. Os valores críticos são os mesmos.

**Quatro casos para treinar**, com $T=100$ e 5%:

| Caso | Estatísticas | Caminho | Conclusão |
|---|---|---|---|
| 1 | $\tau_\tau=-2{,}10$; $\phi_3=2{,}9$; $\tau_\mu=-1{,}70$; $\phi_1=3{,}1$; $\tau=-0{,}80$ | passos 1, 2, 3, 4 e 5, sem rejeitar nenhum | **raiz unitária**, passeio sem drift. Em $\Delta y$, $\tau_\tau=-6{,}20$ rejeita: $y\sim I(1)$, $d=1$ |
| 2 | $\tau_\tau=-4{,}30$ | rejeita no passo 1 | **sem raiz unitária**: estacionária em torno de tendência; não diferenciar |
| 3 | $\tau_\tau=-2{,}40$; $\phi_3=3{,}2$; $\tau_\mu=-3{,}30$ | passo 2 tira a tendência; passo 3 rejeita | **sem raiz unitária**: estacionária com média diferente de zero |
| 4 | $\tau_\tau=-1{,}90$; $\phi_3=2{,}5$; $\tau_\mu=-1{,}20$; $\phi_1=6{,}10$; $t=-1{,}20$ | passo 4: drift presente; com a normal, $-1{,}20\gt-1{,}65$ | **raiz unitária com drift**: passeio com drift; diferenciar |

**A frase de fecho:** "Como $\tau=\dots$ é maior que o crítico $\dots$, não rejeito $H_0$: a série tem raiz unitária e deve ser diferenciada" (ou: "é menor, rejeito $H_0$: a série não tem raiz unitária").

## 9. A noite de quarta e a manhã de quinta

| Hora | O quê |
|---|---|
| 18h–19h | chegar, comer, descansar; nada de matéria |
| 19h–19h20 | ler esta folha inteira |
| 19h20–20h20 | **[Simulado 05](simulado_05.md)**, 4 × 2,5, em 1 hora, sem consulta |
| 20h20–20h40 | correção pelo [gabarito](simulado_05_gabarito.md) |
| 20h40–21h10 | refazer cada item com perda, pelo guia e por esta folha |
| 21h10–21h35 | **a cadeia do Dickey-Fuller** (seção 8): escrever os cinco passos de memória e resolver os quatro casos cobrindo a coluna da conclusão |
| 21h35–22h | desenhar de memória FAC e FACP dos seis padrões da seção 3; as frases de fecho |
| **até 22h30** | **parar e dormir** |

**Quinta, antes da prova:** 15 minutos com esta folha e com o [básico](basico.md). Na prova: leitura de 3 minutos, contas curtas primeiro, derivações depois e a frase de fecho em cada item.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_oc_ar1_g0 | 1,9608 |
| pv_oc_ar1_rho1 | 0,7 |
| pv_oc_ar1_rho2 | 0,49 |
| pv_oc_ar1_rho3 | 0,343 |
| pv_oc_arma_rho1 | 0,337 |
| pv_oc_arma_rho2 | 0,2022 |
| pv_oc_arma_rho3 | 0,1213 |
| pv_oc_sma_g0 | 1,25 |
| pv_oc_sma_rho4 | -0,4 |
| pv_oc_sma_facp4 | -0,4 |
| pv_oc_sma_facp8 | -0,1905 |
| pv_oc_sma_facp12 | -0,0941 |
| pv_oc_daic | 3,2 |
| pv_oc_dbic | 4,2 |
| pv_s5_q3_h_max_res | 5 |
| pv_oc_banda100 | 0,2 |
| pv_df_tau3_5 | -3,45 |
| pv_df_tau2_5 | -2,89 |
| pv_df_tau1_5 | -1,95 |
| pv_df_phi3_5 | 6,49 |
| pv_df_phi1_5 | 4,71 |
| pv_df_normal_5 | -1,645 |
| pv_df_caso1 | 2 |
| pv_df_caso2 | 1 |
| pv_df_caso3 | 1 |
| pv_df_caso4 | 2 |
| pv_df_caso1_dif | 1 |
-->
