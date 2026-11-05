---
title: "O que cai na P1 — o quadro do professor (04/11), linha a linha"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
prova: "05/11/2026"
lista: [1, 3, 5, 6, 10, 11, 12, 14, 15, 16]
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

# O que cai na P1: o quadro de 04/11, linha a linha

Na aula de quarta, o professor anunciou o formato e listou os tópicos no quadro. Esta folha organiza o quadro em **quatro questões prováveis** e destrincha, **à força bruta**, cada processo que o quadro pede e que o guia ainda não cobria: cada produto aberto, cada esperança calculada, cada comparação com o crítico escrita.

**Como usar.** Cada processo vem como exercício. Leia o enunciado e o "Antes de escrever", **cubra a partir de "Linha a linha" e tente no papel**. Depois confira linha a linha; na primeira linha diferente, leia o sentido dela. As respostas só aparecem no fim da conta, nunca antes.

> [!IMPORTANT]
> **O que foi anunciado**
> - **4 questões de 2,5 pontos.**
> - AIC e BIC caem para **interpretar**, não necessariamente para calcular. RMSE e MAPE entram junto.
> - Cai uma questão de **previsão**.
> - **Yule-Walker foi riscado: não cai.** A questão-tipo 5 do guia fica com prioridade zero.
>
> **Anotado também em aula:** usar BIC, RMSE e MAPE; **identificar a ordem pela FAC** (seção 8); e o **teste de raiz unitária de Dickey-Fuller**, com a cadeia de decisão que começa pelo modelo 3 (seções 9 e 10).

## 1. As quatro questões prováveis

| Questão provável | O que o quadro pede | Onde treinar |
|---|---|---|
| A. Processos | passeio aleatório; $z_3=z_1+2z_2$ (circulado no quadro); $E$, $V$, $\operatorname{Cov}$; estacionário? | questões-tipo 1 e 2 do [guia](nao_posso_errar.md) |
| B. ARMA | estacionário pelas raízes de $(1-\phi B)$; **montar a FAC**, com conta e desenho; FAC e FACP | seções 2 e 3; questões-tipo 3 e 4 |
| C. SARIMA | o SMA(1) sazonal desenhado; a equação de previsão; o $d$ pelo Dickey-Fuller | seções 4, 5, 9 e 10; questão-tipo 9 |
| D. Ciclo e análise | o ciclo de modelagem; identificar a ordem; interpretar AIC, BIC, RMSE e MAPE; previsão | seções 6, 7 e 8; questão-tipo 8 |

O treino no formato anunciado é o [Simulado 05](simulado_05.md): 4 questões de 2,5, em 1 hora.

## 2. AR(1): estacionário e a FAC montada à mão

**Enunciado.** Seja $(1-0{,}7B)y_t=u_t$, com $u_t\sim RB(0,1)$. Verifique se é estacionário, calcule $\gamma_0,\gamma_1,\gamma_2,\gamma_3$ e $\rho_1,\rho_2,\rho_3$, e desenhe a FAC e a FACP.

### Antes de escrever

Três fatos e nada mais:
- a **causalidade**, $E(u_ty_{t-k})=0$ para $k\ge1$;
- o **ruído branco**, $E(u_t^2)=1$;
- a **estacionariedade**, $E(y_{t-1}y_{t-1})=\gamma_0$ e $E(y_ty_{t-1})=E(y_{t-1}y_{t-2})=\gamma_1$.

O molde é o dos quatro movimentos do guia, com um auxiliar só.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & y_t-0{,}7y_{t-1}=u_t\ \Rightarrow\ y_t=0{,}7y_{t-1}+u_t && [B\,y_t=y_{t-1};\ \text{isola}]\\
\text{(2)}\quad & \phi(x)=1-0{,}7x=0\ \Rightarrow\ x=1/0{,}7=1{,}4286 && [x \text{ é um número}]\\
\text{(3)}\quad & \lvert1{,}4286\rvert\gt1\ \Rightarrow\ \text{estacionário} && [\text{fora do círculo}]\\
\text{(4)}\quad & E(y_t)=0{,}7E(y_{t-1})+E(u_t)\Rightarrow\mu=0{,}7\mu\Rightarrow\mu=0 && [\text{F4; estac.; RB}]\\
\text{(5)}\quad & E(u_ty_t)=0{,}7E(u_ty_{t-1})+E(u_t^2)=0{,}7\cdot0+1=1 && [(1)\times u_t;\ \text{caus.; RB}]\\
\text{(6)}\quad & \gamma_0=E(y_ty_t)=0{,}7E(y_{t-1}y_t)+E(u_ty_t)=0{,}7\gamma_1+1 && [(1)\times y_t;\ \text{estac.};\ (5)]\\
\text{(7)}\quad & \gamma_1=E(y_ty_{t-1})=0{,}7E(y_{t-1}^2)+E(u_ty_{t-1})=0{,}7\gamma_0+0 && [(1)\times y_{t-1};\ \text{caus.}]\\
\text{(8)}\quad & \gamma_0=0{,}7(0{,}7\gamma_0)+1=0{,}49\gamma_0+1 && [(7)\text{ em }(6)]\\
\text{(9)}\quad & \gamma_0(1-0{,}49)=1\ \Rightarrow\ \gamma_0=1/0{,}51=1{,}9608 && [\text{isola}]\\
\text{(10)}\quad & \gamma_1=0{,}7\cdot1{,}9608=1{,}3725 && [(7)]\\
\text{(11)}\quad & \gamma_2=E(y_ty_{t-2})=0{,}7E(y_{t-1}y_{t-2})+E(u_ty_{t-2})=0{,}7\gamma_1=0{,}9608 && [(1)\times y_{t-2};\ \text{caus.}]\\
\text{(12)}\quad & \gamma_3=0{,}7\gamma_2=0{,}6725 && [\text{idem, }\times y_{t-3}]\\
\text{(13)}\quad & \rho_1=\tfrac{1{,}3725}{1{,}9608}=0{,}7;\ \ \rho_2=\tfrac{0{,}9608}{1{,}9608}=0{,}49;\ \ \rho_3=0{,}343 && [\div\gamma_0]\\
\text{(14)}\quad & \rho_k=0{,}7^k:\ \text{positivas, cada uma } 70\% \text{ da anterior} && [\text{padrão da FAC}]\\
\text{(15)}\quad & \phi_{11}=\rho_1=0{,}7;\ \ \phi_{kk}=0 \text{ para } k\ge2 && [\text{FACP do AR(1)}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** O operador $B$ só atrasa: $(1-0{,}7B)y_t$ é $y_t-0{,}7y_{t-1}$. Isolo $y_t$ porque é essa equação que vou multiplicar e tirar a esperança.
- **(2)** A raiz é de um número $x$, não da série. É a linha que o Simulado 01 errou.
- **(3)** Raiz fora do círculo: os choques antigos perdem peso, e a variância é finita.
- **(4)** A média: com estacionariedade, $E(y_t)=E(y_{t-1})=\mu$. Sobra $\mu=0{,}7\mu$, e o único número que satisfaz isso é zero.
- **(5)** O auxiliar: quanto do choque de hoje está em $y_t$. O termo com $y_{t-1}$ zera pela causalidade, porque o passado não conhece o choque de hoje.
- **(6)** Multiplico por $y_t$ **porque $\gamma_0=E(y_t^2)$**. Cada termo vira um momento conhecido: $\gamma_1$ pela estacionariedade e 1 por (5).
- **(7)** Multiplico por $y_{t-1}$ porque quero $\gamma_1$. O choque $u_t$ é posterior a $y_{t-1}$ e some.
- **(8)** Duas equações e duas incógnitas: substituo (7) em (6), e sobra só $\gamma_0$.
- **(9)** Isolo. O 0,51 é $1-\phi^2$: a fórmula $\sigma^2/(1-\phi^2)$ sai da conta, não da memória.
- **(10)** Volto em (7) com o $\gamma_0$.
- **(11)** Para $\gamma_2$, multiplico por $y_{t-2}$. De novo o choque some, e sobra $0{,}7$ vezes a defasagem anterior.
- **(12)** O mesmo vale para toda defasagem: $\gamma_k=0{,}7\gamma_{k-1}$.
- **(13)** Divido por $\gamma_0$. São os números que vão **ao lado** das barras do desenho.
- **(14)** O padrão em palavras: decai geometricamente, sem trocar de sinal porque $\phi\gt0$. Com $\phi\lt0$, alternaria.
- **(15)** A FACP mede o que $y_{t-k}$ acrescenta **depois** de $y_{t-1}$. Num AR(1), nada: corta em 1.

**O desenho**, em quatro passos:
1. Eixo horizontal com $k=1,2,3,\dots$; eixo vertical de $-1$ a 1, com a linha do zero.
2. Barras na altura de cada $\rho_k$: 0,7; 0,49; 0,343; …
3. Os números escritos nas três primeiras barras.
4. O padrão em uma frase.

Na FACP, uma barra só, de 0,7, em $k=1$. Numa FAC **amostral**, desenhe também as bandas $\pm2/\sqrt T$.

**Frase de fecho:** "A raiz é 1,43, fora do círculo: o AR(1) é estacionário. $\gamma_0=1{,}9608$ e $\rho_k=0{,}7^k$ (0,7; 0,49; 0,343): **a FAC decai geometricamente e a FACP corta em 1**, a assinatura de um AR(1)."

O ARMA(1,1), com os dois auxiliares, está linha a linha na questão-tipo 4 do [guia](nao_posso_errar.md). Lá, $\rho_1=0{,}337$, e depois $\rho_2=0{,}2022$ e $\rho_3=0{,}1213$.

**Do meu caderno (26/08 e 02/09):**
- Em 26/08, a variância do AR(1) saiu por outro caminho. Abre-se $E\big((\phi(y_{t-1}-\mu)+\varepsilon_t)^2\big)$ em A + B + C, com $A=\phi^2\gamma_0$ e $C=\sigma^2$. O termo B, $2\phi E\big((y_{t-1}-\mu)\varepsilon_t\big)$, ficou sem conclusão: **ele é zero pela causalidade**, a mesma razão da linha (5). Daí $\gamma_0=\phi^2\gamma_0+\sigma^2$, que é a conta de (8).
- Em 02/09, $\gamma_k=\phi\gamma_{k-1}$ para $k=1,2,3$ está certo.
- Não repita o erro do mesmo dia no ARMA(1,1): "$\gamma_k=\phi^k\gamma_1$". O certo é $\phi^{k-1}\gamma_1$.

**Fonte:** AU02, p. 67–68: o AR($p$), multiplicando por $y_{t-k}-\mu$ e tirando a esperança. AU02, p. 90–92: a FACP.

### Tente

$(1-0{,}8B)y_t=u_t$, com $\sigma^2=0{,}36$. Ache a raiz, $\gamma_0$, $\gamma_1$, os três primeiros $\rho_k$ e a FACP.

**Resposta.**
- A raiz é $1/0{,}8=1{,}25$, fora do círculo.
- $\gamma_0=0{,}36/(1-0{,}64)=1$ e $\gamma_1=0{,}8$.
- $\rho_k$: 0,8; 0,64; 0,512.
- A FACP tem 0,8 em $k=1$ e zero depois.

**Na lista:** Q6 ([nota comentada](../lista_comentada/q06.md)), para a FAC do ARMA, e Q9 ([nota comentada](../lista_comentada/q09.md)), para o AR(1).

## 3. A tabela de consulta: reconhecer pela FAC e pela FACP

| Modelo | FAC | FACP |
|---|---|---|
| AR($p$) | decai (geométrica; alterna se $\phi\lt0$) | **corta** depois de $p$ |
| MA($q$) | **corta** depois de $q$ | decai |
| ARMA($p,q$) | decai | decai |
| passeio (raiz unitária) | decai **muito devagar**, quase em linha reta | um pico perto de 1 em $k=1$ |
| SMA(1)$_s$ | **um pico só, em $s$** | picos em $s,2s,3s$, **decaindo** |
| SAR(1)$_s$ | picos em $s,2s,3s$, **decaindo** | **um pico só, em $s$** |
| multiplicativo $(0,1,1)(0,1,1)_s$ | picos em 1 e $s$, com satélites em $s\pm1$ | decai perto de 1 e de $s$ |

A regra de bolso: **AR corta na FACP; MA corta na FAC**. No sazonal, vale a mesma regra nas defasagens $s,2s,\dots$.

![Os seis padrões de FAC e FACP para desenhar à mão](figuras/fac_facp_padroes.png)

## 4. O SMA(1)$_4$ do quadro, à força bruta

**Enunciado.** Seja a série trimestral $y_t=(1-0{,}5B^4)a_t$, com $a_t\sim RB(0,1)$. Calcule $\gamma_k$ para $k=0,\dots,8$, a FAC, e a FACP nas defasagens 4, 8 e 12. Desenhe as duas.

### Antes de escrever

A força bruta é esta: para cada $k$, abrir o produto em **quatro termos** e perguntar, em cada um, **se as duas datas coincidem**. Pelo ruído branco, $E(a_ra_s)=1$ se $r=s$ e 0 se $r\ne s$. Não há nada a decorar.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & y_t=a_t-0{,}5a_{t-4} && [B^4a_t=a_{t-4}]\\
\text{(2)}\quad & \gamma_k=E\big((a_t-0{,}5a_{t-4})(a_{t-k}-0{,}5a_{t-4-k})\big) && [\text{definição; média zero}]\\
\text{(3)}\quad & \phantom{\gamma_k}=E(a_ta_{t-k})-0{,}5E(a_ta_{t-4-k})-0{,}5E(a_{t-4}a_{t-k})+0{,}25E(a_{t-4}a_{t-4-k}) && [\text{4 produtos}]\\
\text{(4)}\quad & k=0:\ 1-0-0+0{,}25=1{,}25 && [\text{1º e 4º casam}]\\
\text{(5)}\quad & k=1,2,3:\ 0-0-0+0=0 && [\text{nada casa}]\\
\text{(6)}\quad & k=4:\ 0-0-0{,}5\cdot1+0=-0{,}5 && [\text{só o 3º casa}]\\
\text{(7)}\quad & k=5,\dots,8:\ 0 && [\text{nada casa}]\\
\text{(8)}\quad & \rho_4=-0{,}5/1{,}25=-0{,}4;\quad \rho_k=0 \text{ para } k\ne4 && [\div\gamma_0]\\
\text{(9)}\quad & \text{na escala de 4, é um MA(1) com } \rho=-0{,}4:\ \phi_{44}=\rho_4=-0{,}4 && [\text{FACP, passo 1}]\\
\text{(10)}\quad & \phi_{88}=\frac{\rho_8-\phi_{44}\rho_4}{1-\phi_{44}\rho_4}=\frac{0-0{,}16}{1-0{,}16}=-0{,}1905 && [\text{D-L}]\\
\text{(11)}\quad & \phi_{8,4}=\phi_{44}-\phi_{88}\phi_{44}=-0{,}4-(-0{,}1905)(-0{,}4)=-0{,}4762 && [\text{atualiza}]\\
\text{(12)}\quad & \phi_{12,12}=\frac{0-0-\phi_{88}\rho_4}{1-\phi_{8,4}\rho_4-0}=\frac{-0{,}0762}{0{,}8095}=-0{,}0941 && [\text{D-L}]\\
\text{(13)}\quad & \text{confere: } \frac{\rho^3}{1-2\rho^2}=\frac{-0{,}064}{0{,}68}=-0{,}0941 && [\text{fórmula do MA(1)}]\\
\text{(14)}\quad & \text{FACP} = 0 \text{ fora de } 4,8,12,\dots && [\text{só múltiplos de 4}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** Tiro o operador: o choque de hoje e o de 4 trimestres atrás, este com peso $-0{,}5$.
- **(2)** A definição da autocovariância, escrita com as duas datas, $t$ e $t-k$. Com média zero, não há o que subtrair.
- **(3)** Abro o produto $(A-0{,}5B)(C-0{,}5D)$ em quatro termos. O $0{,}25$ é $(-0{,}5)(-0{,}5)$. Agora cada termo é uma pergunta: as datas coincidem?
- **(4)** Em $k=0$, o 1º termo é $E(a_t^2)=1$ e o 4º é $0{,}25E(a_{t-4}^2)=0{,}25$. Os cruzados ligam datas distantes 4 e zeram. Sai a variância, $1+\Theta^2$.
- **(5)** Em $k=1,2,3$, as datas dos dois lados ficam sempre a uma distância que não é zero. Todos os termos zeram.
- **(6)** Em $k=4$, só o 3º termo casa: $a_{t-4}$ de um lado e $a_{t-k}=a_{t-4}$ do outro. Vale $-0{,}5$: é $-\Theta\sigma^2$.
- **(7)** De 5 em diante, nenhuma data casa. É a memória finita do MA: depois de 4, acabou.
- **(8)** Divido por $\gamma_0$. É o desenho do quadro: **uma barra só, em 4**.
- **(9)** Só as defasagens múltiplas de 4 têm correlação, então, olhando de 4 em 4, a série é um MA(1). A primeira FACP é a própria correlação.
- **(10)** A FACP em 8 pergunta o que $y_{t-8}$ acrescenta depois de $y_{t-4}$. A fórmula de Durbin-Levinson (D-L) desconta a parte já explicada por $\rho_4$. Como $\rho_8=0$, sobra só o desconto.
- **(11)** O coeficiente de $y_{t-4}$ muda quando $y_{t-8}$ entra na regressão. Esse valor alimenta o passo seguinte.
- **(12)** O mesmo para 12: o numerador e o denominador descontam o que 4 e 8 já explicaram. Como $\rho_8=\rho_{12}=0$, dois termos zeram, e sobra $-\phi_{88}\rho_4=-0{,}0762$ em cima e $1-\phi_{8,4}\rho_4=0{,}8095$ embaixo.
- **(13)** Confiro pela fórmula fechada da FACP do MA(1). Na prova, os números de (10)–(12) só são pedidos se o enunciado pedir; o que vale sempre é o **formato**.
- **(14)** Nas defasagens que não são múltiplas de 4, nada se correlaciona, e a FACP é zero.

**Frase de fecho:** "$\gamma_0=1{,}25$, $\gamma_4=-0{,}5$ e zero no resto, logo $\rho_4=-0{,}4$: **a FAC tem um pico só, em 4**. A FACP tem picos em 4, 8 e 12, de $-0{,}4$, $-0{,}1905$ e $-0{,}0941$, **decaindo**: é a assinatura de um SMA(1)$_4$, o MA(1) na escala sazonal."

**Do meu caderno (20/08):** o $\gamma_1$ do MA(1) foi feito exatamente assim. $E\big((\varepsilon_t+\theta\varepsilon_{t-1})(\varepsilon_{t-1}+\theta\varepsilon_{t-2})\big)$ foi aberto em quatro produtos, sobrou $\theta\sigma^2$, e $\gamma_k=0$ para $k\ge2$. O SMA(1)$_4$ é a mesma força bruta, com 4 no lugar de 1. Lá, o MA estava com o sinal positivo dos slides; aqui está com o da lista.

**Fonte:** AU02, p. 52: o $\gamma_k$ do MA($q$), que zera depois de $q$. AU02, p. 90–92: a FACP como o último coeficiente das equações de Yule-Walker de ordem $k$.

### Tente

Série mensal: $y_t=(1-0{,}4B^{12})a_t$, com $\sigma^2=1$. Ache $\gamma_0$, $\gamma_{12}$, $\rho_{12}$ e a FACP em 12 e 24.

**Resposta.**
- $\gamma_0=1{,}16$ e $\gamma_{12}=-0{,}4$.
- $\rho_{12}=-0{,}3448$, e zero no resto.
- A FACP vale $-0{,}3448$ em 12 e $-\rho^2/(1-\rho^2)=-0{,}135$ em 24, decaindo nos múltiplos de 12.

### Da lista (Q11): o SAR(1)$_4$, o espelho do SMA

O quadro desenhou o SMA(1)$_4$, mas a lista pede o **SAR(1)$_4$**, $y_t=\Phi y_{t-4}+\varepsilon_t$. É o AR(1) com 4 no lugar de 1. Com $\Phi=0{,}7$ e $\sigma^2=1$:

$$
\begin{aligned}
\text{(a)}\quad & \gamma_0=E\big((\Phi y_{t-4}+\varepsilon_t)^2\big)=\Phi^2\gamma_0+\sigma^2 && [\text{caus.: o cruzado zera}]\\
\text{(b)}\quad & \gamma_0=\sigma^2/(1-\Phi^2)=1/0{,}51=1{,}9608 && [\text{isola}]\\
\text{(c)}\quad & \gamma_k=\Phi\,\gamma_{k-4},\ k\ge1 && [\times y_{t-k};\ \text{caus.}]\\
\text{(d)}\quad & \gamma_4=\Phi\gamma_0,\ \gamma_8=\Phi^2\gamma_0\ \Rightarrow\ \rho_4=0{,}7,\ \rho_8=0{,}49 && [\rho_{4m}=\Phi^m]\\
\text{(e)}\quad & \gamma_1=\Phi\gamma_3,\ \gamma_3=\Phi\gamma_1\Rightarrow\gamma_1(1-\Phi^2)=0\Rightarrow\gamma_1=\gamma_3=0 && [\gamma_{-j}=\gamma_j]\\
\text{(f)}\quad & \gamma_2=\Phi\gamma_2\Rightarrow\gamma_2=0;\ \ \text{FACP: } \phi_{44}=0{,}7,\ \phi_{88}=0 && [\text{fora dos múltiplos}]
\end{aligned}
$$

- **(a)–(b)** É a conta da seção 2, com $y_{t-4}$ no lugar de $y_{t-1}$.
- **(c)–(d)** A recursão pula de 4 em 4: a FAC só existe nos múltiplos de 4 e decai geometricamente.
- **(e)–(f)** Fora dos múltiplos, a recursão força zero. A FACP tem um pico só, em 4.

É o **espelho do SMA**. No SAR, a FAC decai em 4, 8, 12 e a FACP tem um pico só, em 4. No SMA, é o contrário. O AR(5) restrito do multiplicativo e a demonstração completa estão em [Q11 comentada](../lista_comentada/q11.md).

**Na lista:** Q11 ([nota comentada](../lista_comentada/q11.md)) e Q16 (c) ([nota comentada](../lista_comentada/q16.md)).

## 5. A equação de previsão do SARIMA$(0,1,1)(0,1,1)_4$, à força bruta

**Enunciado.** Uma série trimestral segue SARIMA$(0,1,1)(0,1,1)_4$, com $\theta=0{,}3$ e $\Theta=0{,}5$. Escreva $y_t$ em função do passado e as equações de $\widehat y_T(1)$ até $\widehat y_T(6)$. Diga até que horizonte os resíduos aparecem.

### Antes de escrever

Expandir **cada** produto de polinômios termo a termo. Depois, para cada horizonte, escrever o modelo na data futura e aplicar as três regras:
1. o que é conhecido em $T$ fica;
2. o choque futuro vira 0;
3. o $y$ futuro vira a sua previsão.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & (1-B)(1-B^4)=1-B^4-B+B^5 && [\text{distributiva}]\\
\text{(2)}\quad & (1-B)(1-B^4)y_t=y_t-y_{t-1}-y_{t-4}+y_{t-5} && [\text{aplica a } y_t]\\
\text{(3)}\quad & (1-0{,}3B)(1-0{,}5B^4)=1-0{,}3B-0{,}5B^4+0{,}15B^5 && [\text{distributiva}]\\
\text{(4)}\quad & y_t=y_{t-1}+y_{t-4}-y_{t-5}+a_t-0{,}3a_{t-1}-0{,}5a_{t-4}+0{,}15a_{t-5} && [\text{isola}]\\
\text{(5)}\quad & y_{T+1}=y_T+y_{T-3}-y_{T-4}+a_{T+1}-0{,}3a_T-0{,}5a_{T-3}+0{,}15a_{T-4} && [t=T+1]\\
\text{(6)}\quad & \widehat y_T(1)=y_T+y_{T-3}-y_{T-4}-0{,}3\widehat a_T-0{,}5\widehat a_{T-3}+0{,}15\widehat a_{T-4} && [a_{T+1}\to0]\\
\text{(7)}\quad & y_{T+2}=y_{T+1}+y_{T-2}-y_{T-3}+a_{T+2}-0{,}3a_{T+1}-0{,}5a_{T-2}+0{,}15a_{T-3} && [t=T+2]\\
\text{(8)}\quad & \widehat y_T(2)=\widehat y_T(1)+y_{T-2}-y_{T-3}-0{,}5\widehat a_{T-2}+0{,}15\widehat a_{T-3} && [y_{T+1}\to\widehat y(1)]\\
\text{(9)}\quad & \widehat y_T(3)=\widehat y_T(2)+y_{T-1}-y_{T-2}-0{,}5\widehat a_{T-1}+0{,}15\widehat a_{T-2} && [t=T+3]\\
\text{(10)}\quad & \widehat y_T(4)=\widehat y_T(3)+y_T-y_{T-1}-0{,}5\widehat a_T+0{,}15\widehat a_{T-1} && [t=T+4]\\
\text{(11)}\quad & \widehat y_T(5)=\widehat y_T(4)+\widehat y_T(1)-y_T+0{,}15\widehat a_T && [t=T+5]\\
\text{(12)}\quad & \widehat y_T(6)=\widehat y_T(5)+\widehat y_T(2)-\widehat y_T(1) && [t=T+6]\\
\text{(13)}\quad & \text{resíduos até } h=5=s+1 && [\text{maior lag do MA}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** Os quatro produtos da distributiva. O $+B^5$ vem de $(-B)(-B^4)$.
- **(2)** Aplicar o polinômio é trocar cada $B^j$ por "atrasar $j$". O lado esquerdo é $w_t$, a série duas vezes diferenciada.
- **(3)** O mesmo no MA: $(-0{,}3)(-0{,}5)=+0{,}15$. O termo cruzado $+0{,}15B^5$ **ninguém escolheu**: é imposto pelo produto.
- **(4)** Igualo os dois lados e passo os $y$ do passado para a direita, trocando o sinal. É a equação que se escreve na prova.
- **(5)** Troco $t$ por $T+1$ em **todos** os índices. Só depois decido o que é conhecido.
- **(6)** Em $T$, conheço $y_T$, $y_{T-3}$, $y_{T-4}$ e os resíduos estimados $\widehat a_T$, $\widehat a_{T-3}$, $\widehat a_{T-4}$. Só $a_{T+1}$ é futuro, e vira 0.
- **(7)** Agora $T+2$. Aparecem dois futuros: $y_{T+1}$ e os choques $a_{T+2}$ e $a_{T+1}$.
- **(8)** O $y_{T+1}$ vira a previsão de (6), e os dois choques futuros viram 0. Saem os termos $-0{,}3a_{T+1}$ e $a_{T+2}$.
- **(9)** A mesma operação em $T+3$: $y_{T+2}$ vira $\widehat y_T(2)$, e sobram os resíduos que ainda são **passado**, $\widehat a_{T-1}$ e $\widehat a_{T-2}$.
- **(10)** Em $T+4$, o $y_T$ volta a aparecer como dado, e sobram $\widehat a_T$ e $\widehat a_{T-1}$.
- **(11)** Em $T+5$, entram $y_{T+4}$ e $y_{T+1}$, que viram previsões, e $y_T$, que é conhecido. Dos choques, só $a_T$ é passado: sobra $+0{,}15\widehat a_T$.
- **(12)** Em $T+6$, o choque mais antigo do modelo é $a_{T+1}$, que é futuro. Não sobra resíduo nenhum: a previsão só recicla previsões.
- **(13)** A regra que se escreve: os resíduos aparecem até a maior defasagem do MA, que é $1+s=5$.

**Frase de fecho:** "Com $w_t=(1-B)(1-B^4)y_t$, $y_t=y_{t-1}+y_{t-4}-y_{t-5}+a_t-0{,}3a_{t-1}-0{,}5a_{t-4}+0{,}15a_{t-5}$. **$\widehat y_T(1)=y_T+y_{T-3}-y_{T-4}-0{,}3\widehat a_T-0{,}5\widehat a_{T-3}+0{,}15\widehat a_{T-4}$**, e os resíduos entram até $h=5$. A variância do erro, $\sigma^2\sum_{j\lt h}\psi_j^2$, cresce com $h$."

O AR(1) com números, com variâncias e intervalos, está na questão-tipo 8 do [guia](nao_posso_errar.md); a variação no [banco, Q12](banco.md#q12--previsão-do-sarima-trimestral).

**Do meu caderno (26/08):**
- A previsão do MA(2) começa certa: $E(y_{t+1}\mid T)=c+\theta_1\varepsilon_t+\theta_2\varepsilon_{t-1}$.
- Estão anotados "origem, informação, horizonte" e o intervalo $\widehat y\pm z_{\alpha/2}\sqrt{MSE}$.
- O erro a não repetir: na linha de $y_{t+3}$ apareceu um $\theta_3$ num MA(2), misturando horizontes. **Escrever o modelo na data futura primeiro**, como em (5) e (7), impede isso.

**Fonte:** AU02, p. 54–57: origem, informação e horizonte; a previsão do MA; o intervalo e o MSE.

### Tente

SARIMA$(0,1,1)(0,1,1)_{12}$ com $\theta=0{,}2$ e $\Theta=0{,}7$. Escreva $\widehat y_T(1)$ e diga até que horizonte os resíduos aparecem.

**Resposta.**
- $(1-B)(1-B^{12})=1-B-B^{12}+B^{13}$ e $(1-0{,}2B)(1-0{,}7B^{12})=1-0{,}2B-0{,}7B^{12}+0{,}14B^{13}$.
- $\widehat y_T(1)=y_T+y_{T-11}-y_{T-12}-0{,}2\widehat a_T-0{,}7\widehat a_{T-11}+0{,}14\widehat a_{T-12}$.
- Os resíduos aparecem até $h=13$.

### Da lista (Q12): SARIMA$(1,1,0)(0,1,1)_4$

A Q12 da lista troca o MA comum por um **AR comum**: $(1-\phi B)(1-B)(1-B^4)y_t=(1-\Theta B^4)a_t$. O molde é o mesmo da seção; muda o que sobra em cada horizonte.

$$
\begin{aligned}
\text{(a)}\quad & (1-\phi B)(1-B)=1-(1+\phi)B+\phi B^2 && [\text{distributiva}]\\
\text{(b)}\quad & (\dots)(1-B^4)=1-(1+\phi)B+\phi B^2-B^4+(1+\phi)B^5-\phi B^6 && [\times1 \text{ e } \times(-B^4)]\\
\text{(c)}\quad & y_t=(1+\phi)y_{t-1}-\phi y_{t-2}+y_{t-4}-(1+\phi)y_{t-5}+\phi y_{t-6} && [\text{isola}]\\
& \phantom{y_t=}+a_t-\Theta a_{t-4} && [\text{MA sazonal}]\\
\text{(d)}\quad & \widehat y(1)=(1+\phi)y_T-\phi y_{T-1}+y_{T-3}-(1+\phi)y_{T-4}+\phi y_{T-5}-\Theta\widehat a_{T-3} && [a_{T+1}\to0]\\
\text{(e)}\quad & \widehat y(2)=(1+\phi)\widehat y(1)-\phi y_T+y_{T-2}-(1+\phi)y_{T-3}+\phi y_{T-4}-\Theta\widehat a_{T-2} && [y_{T+1}\to\widehat y(1)]\\
\text{(f)}\quad & \widehat y(4)=(1+\phi)\widehat y(3)-\phi\widehat y(2)+y_T-(1+\phi)y_{T-1}+\phi y_{T-2}-\Theta\widehat a_T && [\text{último resíduo}]\\
\text{(g)}\quad & \widehat y(5)=(1+\phi)\widehat y(4)-\phi\widehat y(3)+\widehat y(1)-(1+\phi)y_T+\phi y_{T-1} && [\text{sem resíduo}]
\end{aligned}
$$

- **(a)–(c)** Três polinômios no lado AR. Com $\phi=0{,}4$, os coeficientes de $y_{t-1}$ a $y_{t-6}$ são 1,4; $-0{,}4$; 0; 1; $-1{,}4$; 0,4.
- **(d)–(f)** O MA só tem $B^4$, então o resíduo que entra em $h$ é $\widehat a_{T+h-4}$: $\widehat a_{T-3}$ em $h=1$, até $\widehat a_T$ em $h=4$.
- **(g)** Em $h=5$, o termo seria $a_{T+1}$, futuro: **os resíduos param em $h=4=s$**. No $(0,1,1)(0,1,1)_4$ desta seção, iam até $h=5=s+1$, por causa do termo cruzado.
- As perdas são as mesmas: $d+sD=1+4=5$.

O diagnóstico de resíduos da Q12 (d), com Ljung-Box, Jarque-Bera, ARCH e estabilidade, e a propagação da sazonalidade estão em [Q12 comentada](../lista_comentada/q12.md).

**Na lista:** Q12 ([nota comentada](../lista_comentada/q12.md)) e Q15 ([nota comentada](../lista_comentada/q15.md)).

## 6. O ciclo de modelagem de Box-Jenkins

| Etapa | O que se faz | O que se olha |
|---|---|---|
| 1. Identificação | gráfico da série; diferenciar até ficar estacionária ($d$ e $D$, pelo Dickey-Fuller); propor $p,q,P,Q$ | FAC e FACP (seções 3 e 8) |
| 2. Estimação | estimar os candidatos por MV | coeficientes significativos; **AIC e BIC** para escolher |
| 3. Diagnóstico | checar se os resíduos são ruído branco | FAC dos resíduos dentro das bandas; **Ljung-Box** não rejeita |
| 4. Previsão | prever e avaliar fora da amostra | **RMSE e MAPE**; intervalos |

**Se o diagnóstico falha, volta-se à etapa 1**: é um ciclo, não uma linha reta. Na prova, escreva as quatro etapas, uma frase cada, e a seta de volta. O ciclo completo, com a Q16, está no [cap. 6 da apostila](../apostila/cap6_aplicacao.md).

**Na lista:** Q12 (d) e Q16 ([Q12](../lista_comentada/q12.md), [Q16](../lista_comentada/q16.md)).

## 7. Interpretar AIC, BIC, RMSE e MAPE, linha a linha

**Enunciado.** Dois modelos para uma série mensal. AIC e BIC vêm da estimação; RMSE e MAPE, de previsões fora da amostra. Interprete, sem calcular nenhum critério.

| Modelo | AIC | BIC | RMSE | MAPE |
|---|---|---|---|---|
| AR(1) | 512,3 | 519,8 | 0,84 | 3,2% |
| ARMA(2,1) | 509,1 | 524,0 | 0,91 | 3,5% |

### Antes de escrever

- **Menor é melhor nos quatro.**
- AIC e BIC são ajuste $-2\ln L$ mais uma multa por parâmetro: **2** no AIC e **$\ln T$** no BIC.
- RMSE e MAPE medem o erro **fora** da amostra.
- Uma diferença de AIC ou BIC menor que 2 é empate prático.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & AIC:\ 509{,}1\lt512{,}3\ \Rightarrow\ \text{ARMA(2,1)};\quad \Delta=3{,}2 && [\text{menor vence}]\\
\text{(2)}\quad & 3{,}2\gt2\ \Rightarrow\ \text{preferência real, não empate} && [\text{regra do 2}]\\
\text{(3)}\quad & BIC:\ 519{,}8\lt524{,}0\ \Rightarrow\ \text{AR(1)};\quad \Delta=4{,}2 && [\text{menor vence}]\\
\text{(4)}\quad & \text{ganho de ajuste do ARMA(2,1)}=3{,}2+2\cdot2=7{,}2 && [\text{2 parâm. a mais}]\\
\text{(5)}\quad & \text{multa do BIC pelos 2}=7{,}2+4{,}2=11{,}4\Rightarrow\ln T=5{,}7 && [T\approx299]\\
\text{(6)}\quad & RMSE:\ 0{,}84\lt0{,}91\ \Rightarrow\ \text{AR(1)};\ \ \Delta=0{,}07 && [\text{fora}]\\
\text{(7)}\quad & MAPE:\ 3{,}2\%\lt3{,}5\%\ \Rightarrow\ \text{AR(1)};\ \ \Delta=0{,}3 && [\text{fora}]\\
\text{(8)}\quad & \text{placar: BIC, RMSE e MAPE} \to \text{AR(1)};\ \text{AIC} \to \text{ARMA(2,1)} && [3\times1]\\
\text{(9)}\quad & \text{melhor dentro, pior fora}\Rightarrow\text{sobreajuste} && [\text{diagnóstico}]\\
\text{(10)}\quad & \text{escolha: AR(1)} && [\text{parcimônia e previsão}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** Leio o AIC e digo quem vence e **por quanto**. A diferença é o que permite julgar.
- **(2)** Com mais de 2 pontos, a preferência do AIC é real: não dá para chamar de empate.
- **(3)** O BIC escolhe o outro. Essa discordância é o que a questão quer que se explique.
- **(4)** A explicação, à força bruta: o ARMA(2,1) tem 2 parâmetros a mais. Se o AIC dele é 3,2 menor mesmo pagando $2\times2=4$ de multa, o ajuste melhorou 7,2.
- **(5)** No BIC, ele fica 4,2 pior. Então a multa dos 2 parâmetros foi $7{,}2+4{,}2=11{,}4$, ou seja, $\ln T=5{,}7$ por parâmetro, contra 2 do AIC. É por isso que o BIC recusa: a multa por parâmetro é quase três vezes maior.
- **(6)** O RMSE está na escala da série e pune os erros grandes. O AR(1) erra menos nos dados que **não viu**.
- **(7)** O MAPE, em %, confirma: 3,2% contra 3,5%.
- **(8)** Faço o placar. Três critérios contra um.
- **(9)** O único critério a favor do ARMA(2,1) olha **dentro** da amostra. Ajustar melhor o que já viu e prever pior o que não viu é a definição de sobreajuste.
- **(10)** A decisão, com os dois motivos: o modelo é menor e prevê melhor.

**Frase de fecho:** "O AIC prefere o ARMA(2,1), por 3,2 pontos, mas o BIC prefere o AR(1), por 4,2: o ganho de ajuste de 7,2 não paga os dois parâmetros extras quando a multa é $\ln T\approx5{,}7$ por parâmetro. Fora da amostra, o AR(1) tem RMSE e MAPE menores, o que mostra que o ganho do ARMA(2,1) era sobreajuste. **Escolho o AR(1)**: mais parcimonioso, preferido pelo BIC e melhor na previsão."

**Do meu caderno (10/09):**
- Está anotado: "Métricas: $\widehat e_{t+h\mid t}=y_{t+h}-\widehat y_{t+h\mid t}$; treino e validação; MAPE, percentual do erro; MAD, na unidade da medida; RMSE; MASE".
- A definição do erro de previsão é o ponto de partida do RMSE e do MAPE.
- O par treino e validação é o "fora da amostra" das linhas (6) e (7).

**Fonte:** AU02, p. 98–99: AIC e BIC, com a multa por parâmetro. AU03, p. 45–49: as métricas de previsão pontual.

### Tente

| Modelo | AIC | BIC | RMSE | MAPE |
|---|---|---|---|---|
| A | 300,5 | 310,4 | 1,12 | 2,9% |
| B, com um parâmetro a menos | 301,2 | 306,9 | 1,10 | 2,8% |

Qual modelo cada critério escolhe, e qual você usa?

**Resposta.**
- O AIC escolhe A, por 0,7: abaixo de 2, é empate.
- O BIC escolhe B, por 3,5.
- O RMSE e o MAPE escolhem B.
- **Fica com B**: empata no AIC, é menor e prevê melhor.

**Na lista:** Q14 ([nota comentada](../lista_comentada/q14.md)) e Q16 (d) ([nota comentada](../lista_comentada/q16.md)).

## 8. Identificar a ordem pela FAC e pela FACP amostrais, linha a linha

**Enunciado.** Com $T=100$, a FAC e a FACP amostrais de uma série estacionária foram:

| $k$ | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|
| FAC | 0,48 | 0,25 | 0,07 | $-0{,}05$ | 0,03 |
| FACP | 0,48 | $-0{,}26$ | 0,15 | $-0{,}09$ | 0,04 |

Identifique o modelo e a ordem.

### Antes de escrever

A banda é $\pm2/\sqrt T$. Cada barra é comparada com ela, uma por uma. A ordem é a **última defasagem fora da banda antes do corte**.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & \text{banda}=2/\sqrt{100}=0{,}2 && [\pm2/\sqrt T]\\
\text{(2)}\quad & \text{FAC: } \lvert0{,}48\rvert\gt0{,}2;\ \lvert0{,}25\rvert\gt0{,}2 && [k=1,2 \text{ fora da banda}]\\
\text{(3)}\quad & \text{FAC: } \lvert0{,}07\rvert,\ \lvert-0{,}05\rvert,\ \lvert0{,}03\rvert\lt0{,}2 && [k=3,4,5 \text{ dentro}]\\
\text{(4)}\quad & \text{a FAC corta depois de } k=2 && [(2),(3)]\\
\text{(5)}\quad & \text{FACP: } 0{,}48;\ -0{,}26;\ 0{,}15;\ -0{,}09;\ 0{,}04 && [\text{alterna o sinal}]\\
\text{(6)}\quad & \lvert\phi_{kk}\rvert:\ 0{,}48\gt0{,}26\gt0{,}15\gt0{,}09\gt0{,}04 && [\text{decai, sem corte}]\\
\text{(7)}\quad & \text{FAC corta em 2 e FACP decai}\ \Rightarrow\ \text{MA(2)} && [\text{MA corta na FAC}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** A banda é o tamanho de uma barra que pode ser só ruído. Sem ela, não há como dizer o que é zero.
- **(2)** Comparo **o valor absoluto** de cada barra com a banda: as duas primeiras passam.
- **(3)** Da terceira em diante, todas ficam dentro: são zero, estatisticamente.
- **(4)** Isso é um **corte**: a FAC é diferente de zero até 2 e zero depois.
- **(5)** Na FACP, os sinais alternam. Barras fora da banda em 1 e 2 não bastam: a pergunta é o **formato**.
- **(6)** Em valor absoluto, cada barra é menor que a anterior, sem um ponto em que despenca para zero: a FACP decai.
- **(7)** A regra de bolso: o lado que corta dá a ordem e o tipo. A FAC corta em 2, logo é um MA(2).

**Frase de fecho:** "Com a banda $\pm0{,}2$, a FAC tem só as defasagens 1 e 2 fora da banda e **corta depois de 2**, enquanto a FACP decai alternando o sinal: **o modelo é um MA(2)**."

Cuidados que valem ponto:
- uma barra isolada fora da banda numa defasagem alta, sem padrão, é ruído: com 20 defasagens, espera-se uma fora por acaso a 5%;
- barras fora da banda em $s$ e $2s$ são sazonais: leia como na seção 3;
- uma FAC que fica alta e cai devagar **não tem ordem**: é raiz unitária, e antes é preciso diferenciar (seção 9).

**Do meu caderno (13/08 e 09/09):**
- Em 13/08, a FAC e a FACP entram como as ferramentas de identificação.
- Em 09/09 estão os desenhos. No AR(2), a FAC decai e a FACP tem duas barras. No MA(2), a FAC tem duas barras e a FACP decai: é o espelho exato do exemplo desta seção.

**Fonte:** AU02, p. 90: a FACP serve para identificar a ordem $p$ de um AR. AU03, p. 4: com séries reais, as FAC e FACP estimadas nem sempre mostram um padrão claro, e por isso o ciclo é iterativo.

### Tente

Com $T=64$:

| $k$ | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|
| FAC | 0,61 | 0,40 | 0,22 | 0,15 | 0,08 |
| FACP | 0,61 | 0,05 | $-0{,}10$ | 0,03 | 0,02 |

Qual é o modelo?

**Resposta.**
- A banda é $2/\sqrt{64}=0{,}25$.
- A FAC decai devagar: 0,61 e 0,40 estão fora da banda, e o resto decresce.
- A FACP tem só 0,61 fora da banda e **corta em 1**.
- Logo, **AR(1)**.

**Na lista:** Q16 (c) ([nota comentada](../lista_comentada/q16.md)) e Q3 ([nota comentada](../lista_comentada/q03.md)), para o corte da FAC.

## 9. Teste de raiz unitária: Dickey-Fuller, linha a linha

**Enunciado.** Parta de $y_t=a_0+\rho\,y_{t-1}+a_2t+u_t$. Escreva a regressão do teste de Dickey-Fuller na notação do Mattos e na do Enders, diga as hipóteses e explique por que a estatística não segue a $t$ de Student.

### Antes de escrever

- O Mattos (MAT, p. 21–23), a leitura do curso, escreve $\Delta Y_t=a+bt+\lambda Y_{t-1}+u_t$ e chama as três especificações de **opções 1, 2 e 3**. A opção 3 é a que tem intercepto e tendência.
- O Enders chama de $\gamma$ o mesmo coeficiente e numera os mesmos três **modelos**.
- Nos dois, o coeficiente é $\rho-1$: $\lambda$ e $\gamma$ são a mesma coisa.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & y_t=a_0+\rho\,y_{t-1}+a_2t+u_t && [\text{modelo geral}]\\
\text{(2)}\quad & y_t-y_{t-1}=a_0+(\rho-1)\,y_{t-1}+a_2t+u_t && [-y_{t-1} \text{ dos dois lados}]\\
\text{(3)}\quad & \Delta y_t=a_0+\gamma\,y_{t-1}+a_2t+u_t,\quad \gamma=\rho-1 && [\text{Enders: modelo 3}]\\
\text{(4)}\quad & \Delta Y_t=a+bt+\lambda Y_{t-1}+u_t,\quad \lambda=\rho-1 && [\text{MAT, p. 23: opção 3}]\\
\text{(5)}\quad & 1-\rho x=0\Rightarrow x=1/\rho;\ \ \rho=1\iff x=1\iff\gamma=\lambda=0 && [\text{raiz unitária}]\\
\text{(6)}\quad & -1\lt\rho\lt1\iff-2\lt\rho-1\lt0\iff-2\lt\lambda\lt0 && [\text{subtrai 1}]\\
\text{(7)}\quad & H_0:\gamma=0 \ (\text{raiz unitária});\quad H_1:\gamma\lt0 && [\text{unilateral}]\\
\text{(8)}\quad & \tau=\widehat\gamma/ep(\widehat\gamma):\ \text{sob } H_0, \text{ distribuição de Dickey-Fuller} && [\text{críticos próprios}]\\
\text{(9)}\quad & \text{modelo 2: } a_2=0;\quad \text{modelo 1: } a_0=a_2=0 && [\text{restrições}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** O modelo mais geral: constante, um AR(1) e tendência.
- **(2)** Subtraio $y_{t-1}$ dos dois lados. À direita, $\rho y_{t-1}-y_{t-1}$ vira $(\rho-1)y_{t-1}$.
- **(3)** Dou nome ao coeficiente, $\gamma=\rho-1$. Esta é a regressão que se estima por MQO.
- **(4)** É a mesma regressão na notação do Mattos, com $\lambda$, $a$ e $b$. Se a prova escrever $\lambda$, nada muda.
- **(5)** A raiz do polinômio AR é $1/\rho$. "Raiz unitária" é $\rho=1$, que é o mesmo que $\gamma=0$. É por isso que se testa $\gamma$, e não $\rho$.
- **(6)** A alternativa do Mattos, $-2\lt\lambda\lt0$, é só a estacionariedade $\lvert\rho\rvert\lt1$ com 1 subtraído de cada lado.
- **(7)** A nula é a raiz unitária. A alternativa olha só para a esquerda: um $\gamma\gt0$ seria explosivo e não interessa.
- **(8)** A estatística é o $t$ de sempre, mas, sob $H_0$, $y_{t-1}$ é um passeio, e a distribuição muda. Os críticos são da tabela de Dickey-Fuller, mais negativos que os da $t$.
- **(9)** Os modelos 2 e 1 são o modelo 3 com a tendência, ou com a tendência e a constante, zeradas.

**Frase de fecho:** "Subtraindo $y_{t-1}$ dos dois lados, o teste vira a regressão de $\Delta y_t$ em $y_{t-1}$. Testar a raiz unitária $\rho=1$ é testar $\gamma=0$ ($\lambda=0$ no Mattos) contra $\gamma\lt0$, com $\tau$ comparado aos críticos de Dickey-Fuller, não aos da $t$."

**Do meu caderno (19/08):** está escrito "$y_t=\alpha+y_{t-1}+\alpha_2t+\varepsilon_t$", com $\alpha_2t$ marcado como "tendência determinística" e, logo abaixo, "teste de raiz unitária". É a linha (1) com $\rho=1$: o modelo 3 **sob $H_0$**. Para testar, é preciso deixar $\rho$ livre e reescrever como em (3).

**Fonte:** MAT, p. 19–25: o teste DF; as opções 1, 2 e 3 nas p. 21–23; o ADF na p. 24; os passos de implementação na p. 25. Os críticos são os tabulados por Dickey e Fuller (1981) e MacKinnon (1996).

**Valores críticos a 5%, para $T=100$** (no ADF, acrescentam-se defasagens de $\Delta y$ e os críticos não mudam):

| Estatística | $\tau_\tau$ (modelo 3) | $\phi_3$: $\gamma=a_2=0$ | $\tau_\mu$ (modelo 2) | $\phi_1$: $a_0=\gamma=0$ | $\tau$ (modelo 1) | normal |
|---|---|---|---|---|---|---|
| crítico | $-3{,}45$ | 6,49 | $-2{,}89$ | 4,71 | $-1{,}95$ | $-1{,}65$ |
| rejeita se | menor | maior | menor | maior | menor | menor |

**Os críticos dependem de $T$.** No INPC, com amostra maior, eles são $-3{,}42$, $-2{,}87$ e $-1{,}95$, com $\phi_3=6{,}30$ e $\phi_1=4{,}61$. Na prova, use os do enunciado.

**A cadeia, começando pelo modelo 3**, ao lado dos passos do Mattos (MAT, p. 25):

| Passo | Cadeia (Enders) | Passos do MAT |
|---|---|---|
| 1 | Modelo 3: se $\tau_\tau\lt-3{,}45$, rejeita e pare | escolher a opção pelo gráfico; na dúvida, a **opção 3**, a mais geral |
| 2 | $\phi_3\gt6{,}49$? Se sim, a tendência fica: teste $\gamma$ com a normal e pare. Se não, tire a tendência | defasagens de $\Delta y$: acrescentar uma a uma enquanto o Schwarz cai |
| 3 | Modelo 2: se $\tau_\mu\lt-2{,}89$, rejeita e pare | calcular $\tau$ na equação final |
| 4 | $\phi_1\gt4{,}71$? Se sim, há drift: teste $\gamma$ com a normal e pare | comparar $\tau$ com o crítico: menor rejeita; maior ou igual não rejeita |
| 5 | Modelo 1: se $\tau\lt-1{,}95$, rejeita; senão, há raiz unitária | se não rejeitou, diferenciar e repetir tudo em $\Delta y$, até rejeitar |

**Por que começar pelo 3.** É o mais geral. Se a série tem tendência e o modelo a omite, o teste quase nunca rejeita, e uma série estacionária em torno de tendência parece ter raiz unitária. O mesmo vale para a constante: é o que acontece no INPC, na seção 10.

**Depois da cadeia:**
- se ficou raiz unitária, diferencie e repita em $\Delta y_t$; o número de diferenças até rejeitar é o $d$;
- se rejeitou no modelo 3, a série é estacionária em torno de tendência (TS): tira-se a tendência, **não se diferencia**, para não sobrediferenciar (questão-tipo 6).

### Tente

Num modelo 2, com $T=100$, o MQO deu $\widehat\rho=0{,}93$ e $ep(\widehat\gamma)=0{,}025$. Ache $\widehat\gamma$ e $\tau_\mu$ e decida a 5%.

**Resposta.**
- $\widehat\gamma=0{,}93-1=-0{,}07$, e $\tau_\mu=-0{,}07/0{,}025=-2{,}8$.
- $-2{,}8\gt-2{,}89$: **não rejeita**, por pouco. Segue para o passo 4.
- Com o crítico da $t$, de $-1{,}65$, teria rejeitado. É por isso que a tabela de Dickey-Fuller importa.

## 10. Dickey-Fuller: os casos e o INPC, linha a linha

**Enunciado.** Percorra a cadeia, a 5%, em cada caso abaixo, e diga se há raiz unitária e o que fazer com a série. Nos casos 1 a 4, $T=100$. O último é a série do seu trabalho do INPC, com os críticos do enunciado.

| Caso | Modelo 3 | Modelo 2 | Modelo 1 |
|---|---|---|---|
| 1 | $\tau_\tau=-2{,}10$; $\phi_3=2{,}9$ | $\tau_\mu=-1{,}70$; $\phi_1=3{,}1$ | $\tau=-0{,}80$; e, em $\Delta y$, $\tau_\tau=-6{,}20$ |
| 2 | $\tau_\tau=-4{,}30$ | — | — |
| 3 | $\tau_\tau=-2{,}40$; $\phi_3=3{,}2$ | $\tau_\mu=-3{,}30$ | — |
| 4 | $\tau_\tau=-1{,}90$; $\phi_3=2{,}5$ | $\tau_\mu=-1{,}20$; $\phi_1=6{,}10$; $t=-1{,}20$ | — |
| INPC | $\tau_\tau=-7{,}15$ (crítico $-3{,}42$); $t$ da tendência $=-1{,}44$; $\phi_3=25{,}60$ (crítico 6,30) | $\tau_\mu=-7{,}00$ (crítico $-2{,}87$); $t$ da constante $=5{,}46$; $\phi_1=24{,}48$ (crítico 4,61) | $\tau=-1{,}61$ (crítico $-1{,}95$) |

No INPC, diga também o que aconteceria se o teste começasse pelo modelo 1.

### Antes de escrever

- Para os $\tau$, rejeita-se a raiz unitária quando a estatística é **menor** que o crítico.
- Para os $\phi$, rejeita-se quando é **maior**.
- Cada linha é uma comparação e a decisão que sai dela. Nunca pule do modelo 3 para o 1 sem passar pelo $\phi_3$ e pelo modelo 2.

### Linha a linha

**Caso 1**

$$
\begin{aligned}
\text{(1)}\quad & -2{,}10\gt-3{,}45\ \Rightarrow\ \text{não rejeita } \gamma=0 && [\text{passo 1}]\\
\text{(2)}\quad & 2{,}9\lt6{,}49\ \Rightarrow\ \text{tira a tendência} && [\text{passo 2}]\\
\text{(3)}\quad & -1{,}70\gt-2{,}89\ \Rightarrow\ \text{não rejeita} && [\text{passo 3}]\\
\text{(4)}\quad & 3{,}1\lt4{,}71\ \Rightarrow\ \text{tira a constante} && [\text{passo 4}]\\
\text{(5)}\quad & -0{,}80\gt-1{,}95\ \Rightarrow\ \text{raiz unitária, sem drift} && [\text{passo 5}]\\
\text{(6)}\quad & \Delta y:\ -6{,}20\lt-3{,}45\ \Rightarrow\ \Delta y \text{ estacionária} && [\text{repete em } \Delta y]\\
\text{(7)}\quad & y\sim I(1),\ d=1:\ \text{passeio aleatório} && [(5),(6)]
\end{aligned}
$$

**Casos 2 a 4**

$$
\begin{aligned}
\text{(8)}\quad & \text{caso 2: } -4{,}30\lt-3{,}45\ \Rightarrow\ \text{rejeita no passo 1} && [\text{passo 1}]\\
\text{(9)}\quad & \text{sem raiz unitária, com tendência: TS; não diferenciar} && [\text{conclusão}]\\
\text{(10)}\quad & \text{caso 3: } -2{,}40\gt-3{,}45;\ \ 3{,}2\lt6{,}49\ \Rightarrow\ \text{modelo 2} && [\text{passos 1 e 2}]\\
\text{(11)}\quad & -3{,}30\lt-2{,}89\ \Rightarrow\ \text{rejeita: estacionária, média}\ne0 && [\text{passo 3}]\\
\text{(12)}\quad & \text{caso 4: } -1{,}90\gt-3{,}45;\ \ 2{,}5\lt6{,}49;\ \ -1{,}20\gt-2{,}89 && [\text{passos 1 a 3}]\\
\text{(13)}\quad & 6{,}10\gt4{,}71\ \Rightarrow\ \text{o drift fica} && [\text{passo 4}]\\
\text{(14)}\quad & t=-1{,}20\gt-1{,}65\ \Rightarrow\ \text{raiz unitária com drift; diferenciar} && [\text{normal}]
\end{aligned}
$$

**INPC**

$$
\begin{aligned}
\text{(15)}\quad & -7{,}15\lt-3{,}42\ \Rightarrow\ \text{rejeita no passo 1: sem raiz unitária} && [\text{modelo 3}]\\
\text{(16)}\quad & t_{\text{tend}}=-1{,}44\ (p=0{,}15)\ \Rightarrow\ \text{a tendência não é significativa} && [\text{normal}]\\
\text{(17)}\quad & \phi_3=25{,}60\gt6{,}30:\ \text{cai porque } \gamma\ne0, \text{ não porque } a_2\ne0 && [\text{leitura do } \phi_3]\\
\text{(18)}\quad & \text{modelo 2: } -7{,}00\lt-2{,}87;\ \ t_{\text{const}}=5{,}46 && [\text{a constante fica}]\\
\text{(19)}\quad & \phi_1=24{,}48\gt4{,}61 && [\text{confirma}]\\
\text{(20)}\quad & \text{modelo 1 sozinho: } -1{,}61\gt-1{,}95\ \Rightarrow\ \text{não rejeitaria} && [\text{armadilha}]\\
\text{(21)}\quad & y\sim I(0) \text{ com média}\ne0:\ d=0 && [\text{conclusão}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** O modelo mais geral não rejeita. Ainda não dá para concluir nada: pode ser falta de poder por excesso de termos.
- **(2)** O $\phi_3$ testa, junto, raiz unitária e tendência nula. Não rejeitar diz que a tendência pode sair.
- **(3)** Sem a tendência, o modelo 2 também não rejeita.
- **(4)** O $\phi_1$ diz que a constante também pode sair.
- **(5)** No modelo 1, sem nenhum termo determinístico, ainda não rejeita: há raiz unitária, e é um passeio sem drift.
- **(6)** Repito a cadeia na série diferenciada. Agora rejeita: uma diferença basta.
- **(7)** O número de diferenças até rejeitar é o $d$. Aqui, $d=1$.
- **(8)** O caso 2 rejeita já no modelo 3. A cadeia para no primeiro passo.
- **(9)** Rejeitou com tendência no modelo: a série é estacionária em torno de uma tendência. Diferenciar seria sobrediferenciar; o certo é tirar a tendência.
- **(10)** No caso 3, o modelo 3 não rejeita e o $\phi_3$ manda tirar a tendência.
- **(11)** No modelo 2, rejeita. A série é estacionária, e a constante ficou: a média não é zero.
- **(12)** No caso 4, os três primeiros passos não rejeitam.
- **(13)** O $\phi_1$ rejeita: a constante pertence ao modelo, isto é, há drift.
- **(14)** Com drift, o $\gamma$ se testa com a normal. Não rejeita: é um passeio com drift, que se diferencia.
- **(15)** No INPC, o modelo 3 rejeita com folga. A cadeia já poderia parar aqui.
- **(16)** Mesmo assim, olho a tendência: com $p=0{,}15$, ela não pertence ao modelo, e o modelo final é o 2.
- **(17)** A armadilha do $\phi_3$: ele testa as duas coisas juntas. Rejeitar quer dizer que **pelo menos uma** é falsa; aqui, é a raiz unitária que cai, como mostra (16).
- **(18)** No modelo 2, a rejeição se repete, e a constante é fortemente significativa.
- **(19)** O $\phi_1$ confirma: a raiz unitária e a constante nula não se sustentam juntas.
- **(20)** Se tivesse começado pelo modelo 1, que força a regressão a passar pela origem, o teste leria o desvio da média 0,5 como persistência e não rejeitaria. É exatamente o erro que começar pelo modelo 3 evita.
- **(21)** O INPC é estacionário em torno de uma média positiva. Não se diferencia: $d=0$.

**Frase de fecho:** "Partindo do modelo 3, $\tau_\tau=-7{,}15\lt-3{,}42$: rejeito a raiz unitária. A tendência não é significativa, e no modelo 2, $\tau_\mu=-7{,}00\lt-2{,}87$, com constante significativa. **O INPC é estacionário em torno de uma média positiva, $d=0$.** O modelo 1, sozinho, não rejeitaria ($-1{,}61\gt-1{,}95$), porque omite a constante."

**Do meu caderno (19/08):** "teste de raiz unitária" aparece logo abaixo de "termo de tendência determinística". É essa a pergunta do passo 2: o $\phi_3$ decide se a tendência determinística fica na regressão.

**Fonte:** MAT, p. 25: começar pela opção 3 em caso de dúvida e reaplicar o teste na série diferenciada. O caso real é a questão 2 do relatório do INPC (`trabalho_inpc/relatorio.md`).

### Tente

$T=100$, a 5%. O modelo 3 deu $\tau_\tau=-3{,}10$ e $\phi_3=7{,}20$, e o $t$ de $\widehat\gamma$, lido na normal, é $-3{,}10$. Há raiz unitária?

**Resposta.**
- $-3{,}10\gt-3{,}45$: não rejeita no passo 1.
- $7{,}20\gt6{,}49$: a tendência fica, e o $\gamma$ se testa com a normal.
- $-3{,}10\lt-1{,}65$: rejeita.
- **Não há raiz unitária**: a série é estacionária em torno de tendência, e não se diferencia.

**Na lista:** Q10 ([nota comentada](../lista_comentada/q10.md)), sobre TS × DS, e Q9 ([nota comentada](../lista_comentada/q09.md)), sobre sobrediferenciação.

## 11. A noite de quarta e a manhã de quinta

| Hora | O quê |
|---|---|
| 18h–19h | chegar, comer, descansar; nada de matéria |
| 19h–19h20 | ler esta folha, **cobrindo as resoluções** |
| 19h20–20h20 | **[Simulado 05](simulado_05.md)**, 4 × 2,5, em 1 hora, sem consulta |
| 20h20–20h40 | correção pelo [gabarito](simulado_05_gabarito.md) |
| 20h40–21h10 | refazer cada item com perda, pelo guia e por esta folha |
| 21h10–21h35 | **a cadeia do Dickey-Fuller** (seções 9 e 10): os cinco passos de memória; os casos e o INPC, cobrindo as resoluções |
| 21h35–22h | o SMA(1)$_4$ da seção 4, à força bruta, em folha branca; os seis desenhos da seção 3 de memória |
| **até 22h30** | **parar e dormir** |

**Quinta, antes da prova:** 15 minutos com esta folha e com o [básico](basico.md). Na prova: leitura de 3 minutos, contas curtas primeiro, derivações depois e a frase de fecho em cada item.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_ob_ar1_raiz | 1,4286 |
| pv_ob_ar1_1mphi2 | 0,51 |
| pv_oc_ar1_g0 | 1,9608 |
| pv_ob_ar1_g1 | 1,3725 |
| pv_ob_ar1_g2 | 0,9608 |
| pv_ob_ar1_g3 | 0,6725 |
| pv_oc_ar1_rho1 | 0,7 |
| pv_oc_ar1_rho2 | 0,49 |
| pv_oc_ar1_rho3 | 0,343 |
| pv_oc_arma_rho1 | 0,337 |
| pv_oc_arma_rho2 | 0,2022 |
| pv_oc_arma_rho3 | 0,1213 |
| pv_oc_sma_g0 | 1,25 |
| pv_ob_sma_g4 | -0,5 |
| pv_ob_sma_g_resto | 0 |
| pv_oc_sma_rho4 | -0,4 |
| pv_oc_sma_facp4 | -0,4 |
| pv_ob_sma_rho2 | 0,16 |
| pv_ob_sma_1mrho2 | 0,84 |
| pv_ob_sma_f22 | -0,1905 |
| pv_oc_sma_facp8 | -0,1905 |
| pv_ob_sma_f21 | -0,4762 |
| pv_ob_sma_num33 | -0,0762 |
| pv_ob_sma_den33 | 0,8095 |
| pv_ob_sma_f33 | -0,0941 |
| pv_ob_sma_f33_formula | -0,0941 |
| pv_oc_sma_facp12 | -0,0941 |
| pv_ob_sma_rho3 | -0,064 |
| pv_ob_sma_1m2rho2 | 0,68 |
| pv_ob_sar_cruzado | 0,15 |
| pv_s5_q3_h_max_res | 5 |
| pv_oc_daic | 3,2 |
| pv_oc_dbic | 4,2 |
| pv_ob_ganho | 7,2 |
| pv_ob_multa_bic | 11,4 |
| pv_ob_lnT | 5,7 |
| pv_ob_T | 299 |
| pv_ob_drmse | 0,07 |
| pv_ob_dmape | 0,3 |
| pv_oc_banda100 | 0,2 |
| pv_df_tau3_5 | -3,45 |
| pv_df_phi3_5 | 6,49 |
| pv_df_tau2_5 | -2,89 |
| pv_df_phi1_5 | 4,71 |
| pv_df_tau1_5 | -1,95 |
| pv_df_normal_5 | -1,645 |
| pv_df_caso1 | 2 |
| pv_df_caso1_dif | 1 |
| pv_df_caso2 | 1 |
| pv_df_caso3 | 1 |
| pv_df_caso4 | 2 |
| pv_ot_ar1_raiz | 1,25 |
| pv_ot_ar1_g0 | 1 |
| pv_ot_ar1_g1 | 0,8 |
| pv_ot_ar1_rho2 | 0,64 |
| pv_ot_ar1_rho3 | 0,512 |
| pv_ot_sma_g0 | 1,16 |
| pv_ot_sma_g12 | -0,4 |
| pv_ot_sma_rho12 | -0,3448 |
| pv_ot_sma_facp12 | -0,3448 |
| pv_ot_sma_facp24 | -0,135 |
| pv_ot_sar_cruzado | 0,14 |
| pv_ot_sar_hmax | 13 |
| pv_ot_daic | 0,7 |
| pv_ot_dbic | 3,5 |
| pv_ot_banda64 | 0,25 |
| pv_ot_df_gamma | -0,07 |
| pv_ot_df_tau | -2,8 |
| pv_ot_df_caso | 1 |
| inpc_adf_y_t_tau | -7,15 |
| inpc_adf_y_t_c5 | -3,42 |
| inpc_adf_y_t_tend_t | -1,44 |
| inpc_adf_y_t_tend_p | 0,15 |
| inpc_adf_y_t_phi3 | 25,60 |
| inpc_adf_c5_phi3 | 6,30 |
| inpc_adf_y_c_tau | -7,00 |
| inpc_adf_y_c_c5 | -2,87 |
| inpc_adf_y_c_const_t | 5,46 |
| inpc_adf_y_c_phi1 | 24,48 |
| inpc_adf_c5_phi1 | 4,61 |
| inpc_adf_y_n_tau | -1,61 |
| inpc_adf_y_n_c5 | -1,95 |
| lc_q11_g0 | 1,9608 |
| lc_q11_rho4 | 0,7 |
| lc_q11_rho8 | 0,49 |
| lc_q11_rho1 | 0 |
| lc_q11_phi44 | 0,7 |
| lc_q11_phi88 | 0 |
| lc_q12_c1 | 1,4 |
| lc_q12_c2 | -0,4 |
| lc_q12_c4 | 1 |
| lc_q12_c5 | -1,4 |
| lc_q12_c6 | 0,4 |
| lc_q12_perda | 5 |
-->
