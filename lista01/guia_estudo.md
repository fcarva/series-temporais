---
title: "Lista 01 — guia de estudo: o que estou fazendo e por quê"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: LST01
status: rascunho
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Guia de estudo da Lista 01
---

# Guia de estudo da Lista 01: o que estou fazendo e por quê

Este guia acompanha o script [lista01_inpc.R](lista01_inpc.R) passo a passo. Para cada etapa da Lista 01, ele diz:
- **o que** estou tentando descobrir;
- **por que** este teste, e não outro;
- **como** o teste funciona por dentro;
- **o que** o INPC respondeu;
- **o que** costuma cair na prova.

O guia foi feito para ler antes de rodar o código e para revisar antes da prova. Cada número citado sai do R (`lista01/guia_numeros.R`) e é conferido pelo build. As demonstrações completas estão nos módulos da lista teórica, indicados em cada seção.

> [!TIP]
> **Como usar**
> 1. Leia a seção 0 inteira: ela dá o mapa.
> 2. Para cada questão, leia a seção aqui, rode o bloco correspondente no RStudio e confira se o número na tela bate com o do texto.
> 3. Termine com as [perguntas de prova](#11-perguntas-de-prova-com-resposta) e tente responder sem olhar.

## 0. O mapa: o que a Lista 01 inteira está fazendo

**O objetivo** é construir um modelo para o INPC mensal que sirva para **prever**, e provar que ele é bom. A ferramenta é o ciclo de **Box-Jenkins**, que tem quatro fases:

1. **Transformar e tornar a série estacionária** (Q1 e Q2). Os modelos ARMA só valem para séries estacionárias. Primeiro se descobre o que é preciso fazer com a série (log? diferença? diferença sazonal?) para chegar lá.
2. **Identificar** (Q3). Olhando a FAC e a FACP da série estacionária, propõem-se alguns modelos candidatos.
3. **Estimar e escolher** (Q4). Os candidatos são estimados por máxima verossimilhança e comparados por AIC e BIC.
4. **Diagnosticar** (Q5 e Q6). Se o modelo está certo, o que sobra (os resíduos) é ruído branco. Se não for, volta-se à fase 2.

Depois do ciclo vem a **prova final** (Q7): o modelo prevê melhor, fora da amostra, do que regras ingênuas que não exigem econometria nenhuma?

| Questão | Pergunta que estou respondendo | Ferramenta | O INPC respondeu |
|---|---|---|---|
| Q1 | Como é a série? Preciso transformá-la? | gráficos, Box-Cox | tendência exponencial, sazonalidade, outliers; usar log |
| Q2 | Quantas diferenças ($d$) e diferenças sazonais ($D$)? | ADF, PP, KPSS, OCSB | $d=1$, $D=0$ (com uma discordância entre testes que precisa ser defendida) |
| Q3 | Que estrutura ARMA tem a série diferenciada? | FAC e FACP | AR(1) regular e algo sazonal em 12; três candidatos |
| Q4 | Qual candidato é o melhor? | MV exata, AIC, BIC, raízes | AIC escolhe C3, BIC escolhe C1; fica C3 |
| Q5 | O que sobrou é ruído branco? | Ljung-Box, Jarque-Bera, ARCH-LM, sobreajuste | sim, exceto a normalidade |
| Q6 | O que acontece se eu diferenciar demais? | o modelo com $d=2$ | o MA vai para a raiz unitária |
| Q7 | O modelo prevê bem? | 24 meses fora da amostra, RMSE/MAE/MAPE | bate o passeio aleatório e o sazonal ingênuo |
| Q8 | Teoria, à mão | lista teórica | ver [02_lista](../02_arma/02_lista.md) e [03_lista](../03_arima_sarima/03_lista.md) |

### Os quatro conceitos que sustentam tudo

Quase toda pergunta de prova volta a um destes quatro conceitos.

**1. Estacionariedade (fraca).** Uma série é estacionária quando a média, a variância e as autocovariâncias não dependem do tempo:

$$
E(y_t)=\mu,\qquad \operatorname{Var}(y_t)=\gamma_0,\qquad \operatorname{Cov}(y_t,y_{t-k})=\gamma_k\quad\text{para todo } t.
$$

*Por que importa.* Para estimar $\mu$ ou $\gamma_k$ com uma única trajetória, é preciso que a série "se repita" ao longo do tempo. Se a média muda com $t$, cada observação vem de uma distribuição diferente, e a média amostral não estima nada.

**2. Ruído branco.** Uma sequência $a_t\sim RB(0,\sigma^2)$ tem média zero, variância constante e **nenhuma** autocorrelação. É o "imprevisível puro": o que um bom modelo deixa como resíduo.

**3. O operador defasagem $B$.** Por definição, $By_t=y_{t-1}$ e $B^ky_t=y_{t-k}$. Com ele, um AR(1) $y_t=\phi y_{t-1}+a_t$ vira $(1-\phi B)y_t=a_t$. A diferença é $\Delta=1-B$, e a diferença sazonal é $\Delta_{12}=1-B^{12}$.

**4. Raiz unitária.** No AR(1), a raiz do polinômio $1-\phi z=0$ é $z=1/\phi$:
- se $\lvert\phi\rvert\lt 1$, a raiz fica fora do círculo unitário e a série é estacionária: um choque morre como $\phi^k$;
- se $\phi=1$, a raiz é $z=1$, a **raiz unitária**: $y_t=y_{t-1}+a_t$ é o passeio aleatório, e um choque **nunca morre**.

O passeio aleatório tem $\operatorname{Var}(y_t)=t\sigma^2$, que cresce com o tempo: não é estacionário. Mas sua diferença $\Delta y_t=a_t$ é. Uma série que fica estacionária depois de $d$ diferenças é **integrada de ordem $d$**, $I(d)$.

> [!IMPORTANT]
> **A frase-resumo da Lista 01**
> O INPC é $I(1)$: o log do índice tem raiz unitária, e a inflação mensal $\Delta y_t$ é estacionária. Por isso o modelo é um ARIMA com $d=1$ para o log, o que é o mesmo que um ARMA para a inflação.

## 1. Q1: olhar a série antes de testar qualquer coisa

### O que estou fazendo

Antes de qualquer teste, faço gráficos da série em três formas: o índice $P_t$, o log $y_t=100\ln P_t$ e a diferença $\Delta y_t$.

### Por quê

Os testes respondem perguntas estreitas ("há raiz unitária?"), mas é o gráfico que diz **quais perguntas fazer**. Ele mostra:
- se há tendência, e se ela é linear ou exponencial;
- se há sazonalidade;
- se há quebras ou outliers, que podem enganar os testes depois;
- se a variabilidade cresce com o nível, o que pede uma transformação.

### Por que $100\ln P_t$

São três motivos, e vale saber os três.

1. **O log estabiliza a variância.** Um índice de preços cresce de forma exponencial: um choque de 1% move o índice em 16 pontos quando ele vale 1.600 e em 70 pontos quando vale 7.000. Em log, os dois choques têm o mesmo tamanho.
2. **O log lineariza a tendência.** Se $P_t=P_0(1+\pi)^t$, então $\ln P_t=\ln P_0+t\ln(1+\pi)$, que é uma reta.
3. **A diferença do log é a taxa de inflação.** Como $\ln(1+x)\approx x$ para $x$ pequeno:

$$
\Delta y_t=100(\ln P_t-\ln P_{t-1})=100\ln\frac{P_t}{P_{t-1}}\approx 100\,\frac{P_t-P_{t-1}}{P_{t-1}}.
$$

Logo $\Delta y_t$ é a inflação mensal em pontos percentuais. O fator 100 só muda a escala, para os números ficarem legíveis.

### Box-Cox: a justificativa formal do log

A família de Box-Cox é $y(\lambda)=(P^\lambda-1)/\lambda$ para $\lambda\neq0$, com $y(0)=\ln P$. Assim, $\lambda=1$ é "não transformar" e $\lambda=0$ é o log. O método de Guerrero escolhe o $\lambda$ que deixa constante o coeficiente de variação entre subperíodos. Para o INPC, $\widehat\lambda=0{,}30$, mais perto de 0 do que de 1. Isso, junto com o sentido econômico da diferença do log, justifica o log.

![Série em nível e em log](saidas/figuras/q1_serie_nivel.png)

### O que o INPC mostrou

- **Tendência** forte e exponencial no índice; em log, quase uma reta. A inclinação do log é a inflação: maior em 2000–2003 (crise cambial) do que depois.
- **Sazonalidade** invisível no índice, mas clara na inflação mensal: janeiro e dezembro altos, agosto baixo.
- **Outliers** na inflação: nov/2002 (crise), jun/2018 (greve dos caminhoneiros), jul/2022 (corte de impostos sobre combustíveis), fev/2025 (fim do bônus de Itaipu na conta de luz).

![Inflação mensal e sazonalidade](saidas/figuras/q1_variacao.png)

A figura, da versão completa do código, marca também os outliers detectados automaticamente e a média da inflação por regime: ela cai de patamar no início de 2004, depois da crise de 2002–2003.

> [!TIP]
> **Na prova**
> Se perguntarem "por que usar log", não basta "para estabilizar a variância". Diga também que a diferença do log é a taxa de crescimento, o que dá ao modelo uma interpretação econômica direta.

## 2. Q2: quantas diferenças? (raiz unitária)

### O que estou fazendo

Estou decidindo $d$ (o número de diferenças regulares) e $D$ (o número de diferenças sazonais) para tornar a série estacionária.

### Por quê: a pergunta de fundo é DS ou TS

Uma série que sobe ao longo do tempo pode ter dois tipos de tendência, e eles pedem tratamentos opostos:

| | Tendência determinística (TS) | Tendência estocástica (DS) |
|---|---|---|
| Modelo | $y_t=\alpha+\beta t+u_t$, $u_t$ estacionário | $y_t=\beta+y_{t-1}+u_t$ (passeio com drift) |
| Um choque hoje | passa: a série volta para a reta | é permanente: muda o nível para sempre |
| Variância de $y_t$ | constante | cresce com $t$ |
| Como estacionarizar | tirar a tendência (regredir em $t$) | diferenciar |
| Errar para o outro lado | diferenciar uma TS cria um MA não invertível | tirar a tendência de uma DS deixa uma raiz unitária no resíduo |

Os dois erros têm custo. A Q6 mostra o custo de diferenciar demais. O custo de não diferenciar uma série I(1) é pior: a inferência usual deixa de valer, e aparecem regressões espúrias. Os testes de raiz unitária servem para escolher entre as duas colunas da tabela.

### O teste ADF, por dentro

**A ideia.** Escreva um AR(1) para $y$: $y_t=\rho y_{t-1}+a_t$. Há raiz unitária se $\rho=1$. Subtraindo $y_{t-1}$ dos dois lados:

$$
\Delta y_t=(\rho-1)y_{t-1}+a_t=\gamma\, y_{t-1}+a_t,\qquad \gamma=\rho-1.
$$

Testar $\rho=1$ é testar $\gamma=0$, um teste $t$ comum numa regressão de $\Delta y_t$ em $y_{t-1}$.

**Por que "aumentado".** Se a série tiver mais dinâmica do que um AR(1), o erro dessa regressão fica autocorrelacionado, e o teste erra o tamanho. A solução de Said e Dickey é acrescentar defasagens de $\Delta y_t$ até o erro ficar branco:

$$
\Delta y_t=\alpha+\beta t+\gamma\, y_{t-1}+\sum_{i=1}^{k}\delta_i\,\Delta y_{t-i}+e_t.
$$

- $H_0$: $\gamma=0$ (raiz unitária, DS).
- $H_1$: $\gamma\lt 0$ (estacionária em torno de $\alpha+\beta t$, TS).

O teste é **unilateral à esquerda**: rejeita-se $H_0$ quando $\tau=\widehat\gamma/\operatorname{ep}(\widehat\gamma)$ é muito negativo.

**Por que a estatística não segue a $t$ de Student.** Sob $H_0$, o regressor $y_{t-1}$ é um passeio aleatório, não estacionário. A variância amostral de $y_{t-1}$ não converge para uma constante, e o teorema central do limite usual não se aplica. A distribuição limite de $\tau$ é um funcional do movimento browniano (a distribuição de Dickey-Fuller). Ela é assimétrica e deslocada para a esquerda, e os valores críticos são mais negativos do que $-1{,}645$.

**Os três casos e seus valores críticos.** Os termos determinísticos mudam a distribuição, e por isso há três tabelas:

| Regressão | Estatística | Crítico de 5% | Testes conjuntos |
|---|---|---|---|
| sem constante e sem tendência | $\tau_1$ | $-1{,}95$ | — |
| com constante | $\tau_2$ | $-2{,}86$ | $\phi_1$: $\alpha=\gamma=0$ |
| com constante e tendência | $\tau_3$ | $-3{,}41$ | $\phi_2$: $\alpha=\beta=\gamma=0$; $\phi_3$: $\beta=\gamma=0$ |

(O `urca` imprime $-3{,}42$ e $-2{,}87$, os valores ajustados ao tamanho da amostra.)

**Qual caso usar.** A regra é: a hipótese alternativa precisa descrever a série de forma plausível. O log do INPC sobe por 26 anos. Se ele for estacionário, só pode ser estacionário **em torno de uma tendência**. Um teste sem $\beta t$ compararia "passeio aleatório" com "série estacionária em torno de uma média fixa", e essa alternativa é absurda para um índice de preços. Então o caso correto é o com constante e tendência, e o $\phi_3$ confirma que a tendência importa.

**Como escolher $k$.** Defasagens de menos deixam autocorrelação no erro, e o teste erra o tamanho. Defasagens demais custam poder. A prática é partir de um máximo, $k_{\max}=12\,(T/100)^{1/4}=16$ para $T=321$ (regra de Schwert), e escolher por AIC ou BIC.

### Phillips-Perron: a mesma pergunta, outra correção

O PP estima a regressão **sem** as defasagens $\Delta y_{t-i}$ e corrige a estatística depois, com uma variância de longo prazo de Newey-West. A vantagem é não depender da escolha de $k$. As hipóteses e os valores críticos são os mesmos do ADF.

### KPSS: inverter as hipóteses

O ADF e o PP têm **pouco poder** quando $\rho$ está perto de 1: um AR(1) com $\rho=0{,}97$ e um passeio aleatório produzem amostras quase iguais. Por isso o teste "não rejeita" com frequência, e "não rejeitar" não prova a raiz unitária.

O KPSS inverte o papel das hipóteses. Ele escreve $y_t=\beta t+r_t+\varepsilon_t$, com $r_t=r_{t-1}+u_t$ um passeio aleatório:
- $H_0$: $\operatorname{Var}(u_t)=0$, isto é, o passeio é constante e $y$ é **estacionária** (em torno da tendência);
- $H_1$: há raiz unitária.

A estatística é $\mathrm{KPSS}=\sum_t S_t^2/(T^2\widehat\sigma^2_{LP})$, em que $S_t$ é a soma acumulada dos resíduos da regressão de $y$ em $(1,t)$. Se a série tem raiz unitária, as somas acumuladas vagueiam e a estatística fica grande. Rejeita-se $H_0$ quando ela passa do crítico.

**Por que usar os dois.** O uso conjunto é chamado de análise confirmatória:

| ADF/PP | KPSS | Conclusão |
|---|---|---|
| rejeita $H_0$ (estacionária) | não rejeita $H_0$ (estacionária) | estacionária: os dois concordam |
| não rejeita (raiz unitária) | rejeita (raiz unitária) | $I(1)$: os dois concordam |
| não rejeita | não rejeita | dados pouco informativos |
| rejeita | rejeita | conflito: olhar quebras, especificação, teoria |

### O que o INPC respondeu (no nível $y_t$)

| Teste | Estatística | Crítico de 5% | Decisão |
|---|---|---|---|
| ADF, tendência, $k=13$ (AIC) | $\tau_3=-3{,}985$ | $-3{,}42$ | rejeita a raiz unitária |
| ADF, tendência, $k=1$ (BIC) | $\tau_3=-3{,}61$ | $-3{,}42$ | rejeita a 5%; não a 1% ($-3{,}98$) |
| PP, tendência | $Z_\tau=-2{,}38$ | $-3{,}43$ | não rejeita |
| KPSS, tendência | $0{,}170$ | $0{,}146$ | rejeita a estacionariedade |

Estamos na última linha da tabela confirmatória: **conflito**. É o caso mais interessante para a prova, porque não há resposta mecânica.

O $\widehat\rho$ da regressão ADF é $1+\widehat\gamma=0{,}975$. É exatamente a zona em que é difícil distinguir uma série muito persistente de uma raiz unitária.

**Como a especificação muda a conclusão (Q2b).** Com o mesmo ADF:
- só com constante: $\tau_2=-1{,}82$, que não rejeita;
- sem nada: $\tau_1=+5{,}99$, **positivo**. O teste interpreta a tendência omitida como explosividade.

Os testes conjuntos dizem quais termos importam: $\phi_3=8{,}82>6{,}30$ (a tendência importa) e $\phi_1=20{,}7>4{,}61$ (a constante importa). A lição: um teste de raiz unitária com termos determinísticos errados dá a resposta errada.

### A decisão: $d=1$, e como defendê-la

Adota-se tendência estocástica, $d=1$, por cinco argumentos. Na prova, cite pelo menos três.

1. **A rejeição do ADF é frágil.** Ela vale a 5%, mas a 1% depende do número de defasagens.
2. **O PP não rejeita, e o KPSS rejeita a estacionariedade.** Dois de três testes apontam raiz unitária.
3. **O argumento econômico.** Sob metas de inflação, o Banco Central mira a inflação, não o nível de preços. Um choque que eleva o índice não é revertido: o nível nunca volta para uma trajetória fixa. Isso é a definição de tendência estocástica.
4. **O teste na diferença.** Na inflação $\Delta y_t$, o ADF com constante dá $\tau_2=-6{,}93$, muito abaixo de $-2{,}87$, e o KPSS de nível dá $0{,}238$, abaixo do crítico de $0{,}463$. Os dois concordam: $\Delta y$ é estacionária, então $d=1$ basta. O `ndiffs` (KPSS em sequência) também devolve $d=1$.
5. **O diagnóstico de sobrediferenciação.** Se $y$ fosse TS, diferenciar criaria um MA com raiz unitária em $\Delta y$. Na Q5, o MA(1) acrescentado ao modelo de $\Delta y$ sai $-0{,}058$, longe de $-1$.

> [!NOTE]
> **Por que o argumento 5 é forte**
> Se $y_t=\alpha+\beta t+u_t$ com $u_t$ estacionário, então $\Delta y_t=\beta+(1-B)u_t$. O fator $(1-B)$ no lado do erro é um MA com raiz exatamente unitária. Se o modelo estimado para $\Delta y$ não mostra esse MA, a série não era TS. É a mesma álgebra da Q10 da lista teórica ([03_lista](../03_arima_sarima/03_lista.md)).

### A diferença sazonal: $D=0$

**A pergunta.** A sazonalidade é **determinística** (cada mês tem uma média própria e fixa) ou **estocástica** (o padrão sazonal vagueia como um passeio aleatório, $y_t=y_{t-12}+a_t$)? Só a segunda pede a diferença sazonal $1-B^{12}$.

**O teste.** O OCSB (Osborn, Chui, Smith e Birchenhall) testa a raiz unitária sazonal. O `nsdiffs(y, test = "ocsb")` devolve $D=0$. A sazonalidade do INPC é estável: janeiro é alto todo ano por razões fixas (reajustes de início de ano, material escolar).

> [!CAUTION]
> **Armadilha**
> Diferenciar sazonalmente sem precisar é o análogo sazonal da Q6: cria um MA sazonal com raiz unitária. Se o padrão é fixo, ele se modela com termos SAR/SMA ou com dummies, não com $1-B^{12}$.

## 3. Q3: identificar a estrutura pela FAC e pela FACP

### O que estou fazendo

Estou olhando as "impressões digitais" da inflação $\Delta y_t$ para propor modelos.

### As duas ferramentas

**A FAC** mede a correlação total entre $\Delta y_t$ e $\Delta y_{t-k}$:

$$
\rho_k=\frac{\operatorname{Cov}(\Delta y_t,\Delta y_{t-k})}{\operatorname{Var}(\Delta y_t)}.
$$

**A FACP** mede a correlação **líquida** em $k$: a que sobra depois de descontar o efeito das defasagens $1,\dots,k-1$. Na prática, $\phi_{kk}$ é o último coeficiente de um AR($k$) ajustado à série.

**A banda.** Se a série fosse ruído branco, $\widehat\rho_k$ teria desvio-padrão aproximado de $1/\sqrt T$. A banda de 95% é $\pm1{,}96/\sqrt T=\pm0{,}110$ para o INPC. Uma barra fora da banda é uma autocorrelação estatisticamente diferente de zero.

### Por que FAC e FACP juntas identificam o modelo

| Processo | FAC | FACP | Por quê |
|---|---|---|---|
| AR($p$) | decai (geométrica ou senoidal) | **corta** depois de $p$ | $y_t$ depende só de $p$ defasagens diretamente; o resto é efeito indireto |
| MA($q$) | **corta** depois de $q$ | decai | $y_t$ e $y_{t-k}$ não compartilham choque nenhum para $k>q$ |
| ARMA($p,q$) | decai depois de $q$ | decai depois de $p$ | mistura dos dois |
| SAR(1)$_{12}$ | picos em 12, 24, 36 decaindo | pico só em 12 | o mesmo, em múltiplos de 12 |
| SMA(1)$_{12}$ | pico só em 12 | picos em 12, 24, 36 decaindo | o mesmo, em múltiplos de 12 |

**Os picos vizinhos de 12.** Num modelo multiplicativo como $(1-\phi B)(1-\Phi B^{12})$, o produto gera um termo em $B^{13}$ com coeficiente $\phi\Phi$. Isso cria correlação nas defasagens 11 e 13, ao lado do pico em 12. Ver esses picos vizinhos é um sinal de estrutura multiplicativa (Q11 e Q16 da lista teórica).

![FAC e FACP da inflação](saidas/figuras/q3_fac_facp.png)

Os dois painéis de cima são a FAC e a FACP do **nível** $y_t$, e valem como revisão da Q2. A FAC decai muito devagar, quase em linha reta, e a FACP tem um único pico perto de 1. É a assinatura visual de uma raiz unitária: num processo estacionário, a FAC cairia geometricamente. Os painéis de baixo são os da inflação $\Delta y_t$, que são os que se leem para identificar o modelo.

### O que o INPC mostrou

- **FACP**: $\phi_{11}=0{,}628$, e logo depois $\phi_{22}=0{,}038$, dentro da banda. **Corta em 1**: AR(1) na parte regular.
- **FAC**: $0{,}628$, $0{,}417$, $0{,}252$... Decai mais ou menos como $0{,}63^k$, que é a FAC de um AR(1).
- **Defasagem 12**: a FAC vale $0{,}212$ e a FACP vale $0{,}114$. Em 24 a FAC já caiu para $0{,}049$. Há algo sazonal, mas não fica claro se é SAR (decaimento) ou SMA (corte). A FACP em 13 é $-0{,}131$, negativa: o sinal de estrutura multiplicativa.

Como a parte sazonal é ambígua, entram três candidatos, todos com AR(1) regular, $d=1$, $D=0$ e drift:

| Candidato | Modelo para $y_t$ | Parte sazonal |
|---|---|---|
| C1 | SARIMA(1,1,0)(1,0,0)$_{12}$ | SAR(1) |
| C2 | SARIMA(1,1,0)(0,0,1)$_{12}$ | SMA(1) |
| C3 | SARIMA(1,1,0)(1,0,1)$_{12}$ | os dois |

**Por que o drift.** Num modelo com $d=1$, a constante do modelo de $\Delta y$ vira uma tendência linear em $y$. Aqui, ela é a inflação média mensal. Sem drift, o modelo diria que a inflação média é zero.

> [!TIP]
> **Na prova**
> A identificação é uma **proposta**, não uma conclusão. Quem decide entre os candidatos é a estimação (Q4) e o diagnóstico (Q5). Por isso a Lista pede três candidatos, e não um.

## 4. Q4: estimar e escolher

### O que estou fazendo

Estou estimando os três candidatos por máxima verossimilhança e escolhendo um.

### O modelo, escrito por extenso

O C3 é:

$$
(1-\phi B)(1-\Phi B^{12})(\Delta y_t-\mu)=(1+\Theta B^{12})a_t,\qquad a_t\sim RB(0,\sigma^2).
$$

| Parâmetro | Significado | Estimativa |
|---|---|---|
| $\phi$ | persistência da inflação de um mês para o outro | $0{,}633$ |
| $\Phi$ | persistência do padrão sazonal de um ano para o outro | $0{,}822$ |
| $\Theta$ | correção sazonal pelo choque de 12 meses antes | $-0{,}677$ |
| $\mu$ | inflação média mensal (o drift), em % | $0{,}502$ |
| $\sigma^2$ | variância do choque | $0{,}1141$ |

> [!CAUTION]
> **O sinal do MA**
> O R escreve o MA com sinal **positivo**, $1+\Theta B^{12}$. A lista (convenção de Box-Jenkins) escreve $1-\Theta B^{12}$. O $\Theta=-0{,}677$ do R é $\Theta=+0{,}677$ na notação da lista. Diga sempre qual convenção está usando. Ver [CONVENCOES.md](../CONVENCOES.md) §2.

### Por que máxima verossimilhança exata

Há dois jeitos de estimar um ARMA:
- **Mínimos quadrados condicionais (CSS):** fixam-se os valores iniciais, por exemplo os choques anteriores à amostra iguais a zero, e minimiza-se a soma dos quadrados dos erros. É rápido, mas descarta informação das primeiras observações. Com um termo sazonal, isso significa perder ao menos 12 meses.
- **MV exata:** escreve-se a verossimilhança de toda a amostra, incluindo as primeiras observações. O filtro de Kalman decompõe a verossimilhança nos erros de previsão um passo à frente $v_t$ e nas suas variâncias $F_t$:

$$
\ln L=-\frac12\sum_{t=1}^{T}\left[\ln(2\pi F_t)+\frac{v_t^2}{F_t}\right].
$$

A MV exata usa toda a informação e impõe estacionariedade e invertibilidade. Para o AR(1) puro, a MV condicional coincide com o MQO (Q13 da lista teórica).

### AIC e BIC: o que eles medem

Quanto mais parâmetros, maior a verossimilhança: um modelo grande sempre "ajusta" melhor. Os critérios cobram um preço por parâmetro:

$$
AIC=-2\ln L+2k,\qquad BIC=-2\ln L+k\ln n.
$$

Menor é melhor. $k$ conta **todos** os parâmetros estimados, **incluindo $\sigma^2$** (o script confere à mão que o R faz isso). Com $n=320$, $\ln n\approx5{,}8$: o BIC cobra quase três vezes mais por parâmetro do que o AIC.

> [!NOTE]
> **A versão das aulas**
> A AU02 divide os critérios por $T$: $AIC=(-2\ln L+2k)/T$. Com o mesmo $T$ para todos os modelos, a ordenação é idêntica.

**Quando a comparação é válida.** Só se compara AIC entre modelos com a **mesma variável dependente** e a **mesma amostra efetiva**. Um modelo com $d=1$ e outro com $d=2$ têm verossimilhanças de séries diferentes ($\Delta y$ e $\Delta^2y$), e seus AIC não se comparam. Aqui os três têm $d=1$, $D=0$ e $n=T-d-sD=321-1-0=320$. A comparação vale.

### O que o INPC respondeu

| Modelo | AIC | BIC |
|---|---|---|
| C1: SAR | $217{,}899$ | $\mathbf{232{,}972}$ |
| C2: SMA | $220{,}034$ | $235{,}107$ |
| C3: SAR + SMA | $\mathbf{216{,}537}$ | $235{,}378$ |

**O AIC escolhe C3, e o BIC escolhe C1.** Os dois critérios discordam, e isso tem explicação teórica:
- o **BIC é consistente**: se o modelo verdadeiro está entre os candidatos, o BIC o escolhe com probabilidade que tende a 1;
- o **AIC é eficiente**: ele minimiza o erro de previsão esperado, mesmo que nenhum candidato seja o modelo verdadeiro.

Como o objetivo da Lista é **prever** (Q7), fica o C3.

**O teste LR confirma a ambiguidade.** O C1 é o C3 com $\Theta=0$. A estatística é $LR=2(\ln L_{C3}-\ln L_{C1})=3{,}36$, com p-valor $0{,}067$ numa $\chi^2(1)$. Não rejeita $\Theta=0$ a 5%, mas rejeitaria a 10%. Já o teste $z$ individual de $\Theta$ dá p-valor $0{,}0005$. Wald e LR discordam porque $\Phi$ e $\Theta$ estão correlacionados (a seção seguinte explica por quê). Quando isso acontece, o LR é o mais confiável.

### As raízes: o modelo é estacionário e invertível?

- **Estacionariedade:** as raízes de $(1-\phi z)(1-\Phi z^{12})=0$ precisam estar fora do círculo unitário, $\lvert z\rvert>1$.
- **Invertibilidade:** as raízes de $1+\Theta z^{12}=0$ também precisam estar fora.

O gráfico do R mostra as **raízes inversas** $1/z$, que precisam ficar **dentro** do círculo. No C3, todas estão dentro.

![Raízes inversas do modelo](saidas/figuras/q4_raizes.png)

**O quase cancelamento.** O fator AR sazonal $(1-0{,}82B^{12})$ e o fator MA sazonal $(1-0{,}68B^{12})$ (na convenção do R, $1+\Theta B^{12}$ com $\Theta=-0{,}68$) são parecidos. Se fossem iguais, se cancelariam, e o modelo seria o mesmo sem os dois termos (como o terceiro modelo da Q5 da lista teórica). Quando $\Phi$ e $\Theta$ vão juntos para 1, o par imita uma sazonalidade determinística, com médias mensais fixas. Isso é coerente com o $D=0$ da Q2. É também o que explica a correlação entre $\widehat\Phi$ e $\widehat\Theta$, e a discordância entre o teste $z$ e o LR.

## 5. Q5: diagnosticar os resíduos

### O que estou fazendo

Estou verificando se os resíduos $\widehat a_t$ do C3 se comportam como o modelo supõe: ruído branco, com variância constante e, de preferência, normal.

### Por quê

O modelo diz que $a_t$ é imprevisível. Se os resíduos tiverem autocorrelação, sobrou estrutura que o modelo não captou, e as previsões podem melhorar. Cada teste checa uma suposição diferente:

| Suposição | Teste | Se falhar, o que se perde |
|---|---|---|
| sem autocorrelação | Ljung-Box | o modelo está mal especificado; volta à Q3 |
| variância condicional constante | ARCH-LM | os intervalos de previsão ficam errados em períodos turbulentos |
| normalidade | Jarque-Bera | os intervalos ficam errados nas caudas; os estimadores continuam consistentes |

### Ljung-Box

A estatística junta as autocorrelações dos resíduos até a defasagem $K$:

$$
Q(K)=T(T+2)\sum_{j=1}^{K}\frac{\widehat\rho_j^2}{T-j}.
$$

- $H_0$: $\rho_1=\dots=\rho_K=0$ nos resíduos.
- Sob $H_0$, $Q\sim\chi^2(K-p-q-P-Q)$.

**Por que descontar os graus de liberdade.** Os parâmetros ARMA foram escolhidos justamente para zerar as primeiras autocorrelações dos resíduos. Cada parâmetro estimado "gasta" um grau de liberdade. No C3, $p+q+P+Q=1+0+1+1=3$; o drift não conta, porque não mexe na autocorrelação. Com $K=24$, são $24-3=21$ graus.

**Resultado:** $Q=14{,}05$, p-valor $0{,}868$. Não rejeita: os resíduos não têm autocorrelação.

**O contraste com um modelo ruim (Q5d).** O modelo sem o AR(1), SARIMA(0,1,0)(1,0,1)$_{12}$, tem p-valor de Ljung-Box $0{,}000$: os resíduos herdam a autocorrelação de 0,63 da inflação. É por isso que todos os candidatos têm o AR(1).

### Jarque-Bera

O teste compara a assimetria $S$ e a curtose $K$ dos resíduos com as da normal ($S=0$, $K=3$):

$$
JB=\frac{T}{6}\left[S^2+\frac{(K-3)^2}{4}\right]\sim\chi^2(2)\ \text{sob } H_0.
$$

**Resultado:** $JB=402{,}5$, e a normalidade é rejeitada. A curtose dos resíduos é $8{,}2$, bem acima de 3: as caudas são pesadas. A causa são os quatro choques identificados na Q1.

**Isso invalida o modelo?** Não. A MV gaussiana continua consistente sem normalidade (é quase-MV), e as previsões pontuais continuam válidas. O que fica comprometido são os intervalos de previsão, que supõem caudas normais. A solução, se fosse necessária, seria modelar os outliers com dummies de intervenção.

### ARCH-LM

O teste verifica se a **variância** dos choques depende do passado. A regressão auxiliar é:

$$
\widehat a_t^2=\alpha_0+\alpha_1\widehat a_{t-1}^2+\dots+\alpha_{12}\widehat a_{t-12}^2+u_t.
$$

$H_0$: $\alpha_1=\dots=\alpha_{12}=0$. A estatística é $T R^2\sim\chi^2(12)$.

**Resultado:** $LM=11{,}00$, p-valor $0{,}529$. Não há efeito ARCH.

![Painel de resíduos](saidas/figuras/q5_residuos.png)

### Sobreajuste

**A lógica.** Se o C3 está correto, acrescentar um parâmetro não deve ajudar: ele deve sair não significativo. Acrescenta-se um termo em cada direção:
- um AR(2) a mais: p-valor $0{,}490$;
- um MA(1) a mais: p-valor $0{,}508$, com $\widehat\theta=-0{,}058$.

Nenhum é significativo. Não falta dinâmica no C3. E o MA(1) extra, longe de $-1$, é o argumento 5 da Q2: $\Delta y$ não está sobrediferenciada.

## 6. Q6: o que acontece quando se diferencia demais

### O que estou fazendo

Estou estimando, de propósito, o modelo errado, com $d=2$, para ver como ele denuncia o erro.

### A teoria (Q9 da lista teórica)

Suponha que $y$ é $I(1)$ e que a inflação segue $\phi(B)\Delta y_t=\theta(B)a_t$. Diferenciar mais uma vez multiplica os dois lados por $(1-B)$:

$$
\phi(B)\,\Delta^2y_t=(1-B)\,\theta(B)\,a_t.
$$

O fator $(1-B)$ entra no **MA**. Sua raiz é $z=1$, exatamente sobre o círculo unitário. O modelo deixa de ser invertível: não é possível recuperar os choques $a_t$ a partir do passado da série.

### Os sintomas

| Sintoma | Por quê | O INPC com $d=2$ |
|---|---|---|
| $\widehat\theta\approx-1$ (convenção do R) | é o fator $(1-B)$ estimado | $\widehat\theta=-1{,}0000$ |
| variância residual maior | diferenciar ruído soma variância: $\operatorname{Var}(a_t-a_{t-1})=2\sigma^2$ | $\widehat\sigma^2$ sobe $17{,}5\%$ sem o MA extra ($0{,}1341$ contra $0{,}1141$) |
| $\rho_1$ negativo na série diferenciada | a diferença de uma série estacionária induz correlação negativa | $\widehat\rho_1(\Delta^2y)=-0{,}210$ |
| AR que troca de sinal | o AR tenta absorver a correlação negativa | $\widehat\phi=-0{,}218$, contra $+0{,}633$ com $d=1$ |

**De onde vem o $\rho_1$ teórico.** Se $x_t=\Delta y_t$ é um AR(1) com parâmetro $\phi$, então $w_t=x_t-x_{t-1}$ tem:

$$
\gamma_0^w=2(\gamma_0-\gamma_1)=2\gamma_0(1-\phi),\qquad \gamma_1^w=2\gamma_1-\gamma_0-\gamma_2=-\gamma_0(1-\phi)^2,
$$

$$
\rho_1^w=\frac{\gamma_1^w}{\gamma_0^w}=-\frac{1-\phi}{2}.
$$

Com $\widehat\phi=0{,}633$, o valor teórico é $-0{,}183$; o observado é $-0{,}210$. Se $x_t$ fosse ruído branco ($\phi=0$), daria $-0{,}5$: é o valor de referência do "teste de olho" para sobrediferenciação.

![Sobrediferenciação](saidas/figuras/q6_sobrediferenciacao.png)

> [!TIP]
> **Na prova**
> A pergunta clássica é "como saber se diferenciei demais?". A resposta tem três partes: um MA estimado perto de $-1$ (ou $+1$ na convenção de Box-Jenkins), uma variância residual que aumenta em vez de diminuir e um $\rho_1$ perto de $-0{,}5$ na série diferenciada.

## 7. Q7: o modelo prevê bem?

### O que estou fazendo

Estou separando os últimos 24 meses, estimando o modelo só com os dados anteriores e vendo como ele prevê os meses que não viu.

### Por que fora da amostra

Dentro da amostra, um modelo maior sempre se ajusta melhor, porque ele se adapta ao ruído. A previsão fora da amostra é o único teste em que o modelo não pode "trapacear". É também a forma honesta de responder à pergunta prática: este modelo vale o trabalho?

### Os dois esquemas

| | Esquema 1: origem fixa | Esquema 2: origem móvel, um passo |
|---|---|---|
| O que se prevê | $h=1,\dots,24$, todos a partir de $T_0$ | só o mês seguinte, a cada mês |
| Informação usada | só até $T_0$ | os dados observados até o mês anterior |
| Coeficientes | estimados até $T_0$ | os mesmos, sem reestimar |
| Simula | um plano de dois anos feito hoje | um analista que atualiza a previsão todo mês |

O esquema 2 é bem mais fácil, porque a cada passo o modelo conhece o último dado. Por isso seus erros são muito menores.

### A previsão e o intervalo

A previsão ótima, no sentido de menor erro quadrático médio, é a esperança condicional: $y_{T+h\mid T}=E(y_{T+h}\mid\mathcal F_T)$. Escrevendo o modelo como MA($\infty$), $y_t=\sum_j\psi_ja_{t-j}$, o erro de previsão em $h$ passos é:

$$
e_T(h)=a_{T+h}+\psi_1a_{T+h-1}+\dots+\psi_{h-1}a_{T+1},\qquad \operatorname{Var}(e_T(h))=\sigma^2\sum_{j=0}^{h-1}\psi_j^2.
$$

Num modelo integrado, os $\psi_j$ não vão a zero, e a variância cresce sem limite com $h$. O intervalo de 95% é a previsão $\pm1{,}96\sqrt{\operatorname{Var}(e_T(h))}$ e se abre como um funil.

**De volta ao índice.** O modelo prevê $y=100\ln P$. Para chegar ao índice, aplica-se $\exp(y/100)$. A rigor, isso dá a **mediana** da previsão do índice, não a média; a correção para a média seria multiplicar por $\exp(\sigma_h^2/2)$, desprezível aqui.

### Por que comparar com regras ingênuas

Um RMSE sozinho não diz nada: 120 pontos é muito ou pouco? O que dá sentido ao número é a comparação com regras que qualquer um aplicaria sem econometria:
- **passeio aleatório**: o próximo valor é igual ao último, $\widehat P_{t+h}=P_t$;
- **sazonal ingênuo**: o próximo valor é igual ao do mesmo mês do ano anterior, $\widehat P_{t+h}=P_{t+h-12}$.

Se o modelo não bate essas regras, ele não vale o trabalho.

### As métricas

Com $e_t=P_t-\widehat P_t$:

$$
RMSE=\sqrt{\tfrac1H\textstyle\sum e_t^2},\qquad MAE=\tfrac1H\textstyle\sum\lvert e_t\rvert,\qquad MAPE=\tfrac{100}{H}\textstyle\sum\lvert e_t/P_t\rvert.
$$

O RMSE pune mais os erros grandes. O MAE trata todos os erros igualmente. O MAPE é em %, o que permite comparar séries de escalas diferentes.

### O que o INPC respondeu

| Previsor | RMSE, esquema 1 | MAPE, esquema 1 | RMSE, esquema 2 | MAPE, esquema 2 |
|---|---|---|---|---|
| SARIMA C3 | $120{,}1$ | $1{,}22\%$ | $30{,}8$ | $0{,}29\%$ |
| passeio aleatório | $425{,}1$ | $4{,}96\%$ | $40{,}9$ | $0{,}43\%$ |
| sazonal ingênuo | $525{,}3$ | $6{,}59\%$ | $328{,}7$ | $4{,}33\%$ |

**O SARIMA vence nos dois esquemas.** As razões:
- **passeio aleatório, esquema 1**: ele prevê o índice parado por dois anos, ignorando a inflação. Erra cada vez mais com $h$;
- **sazonal ingênuo**: no **índice**, ele repete o nível de 12 meses antes. Erra sempre por um ano inteiro de inflação, cerca de 5%;
- **SARIMA**: o drift carrega a inflação média, e o AR e a parte sazonal ajustam o perfil.

> [!WARNING]
> **Cuidado com a comparação**
> Na **inflação** $\Delta y$, o sazonal ingênuo é um competidor muito mais duro, porque não carrega o erro de nível. O trabalho em [trabalho_inpc/](../trabalho_inpc/README.md), que prevê a variação mensal, encontra o modelo perdendo para ele. O resultado de uma comparação depende da variável em que o erro é medido. E o enunciado proíbe mudar o modelo depois de ver o resultado (Q7f).

**A cobertura.** Dos 24 valores observados, $100\%$ caíram dentro do intervalo de 95% do esquema 1. Isso está acima do nominal, mas não prova que o intervalo está errado:
- o intervalo de um modelo integrado se abre muito com $h$;
- os 24 erros de uma única origem estão fortemente correlacionados entre si; na prática, são quase uma única observação.

![Previsão, esquema 1](saidas/figuras/q7_esquema1.png)

## 8. A Q8 (teoria, manuscrita)

A Q8 pede dois exercícios da lista teórica resolvidos à mão. Os mais ligados ao que a parte empírica fez são:

| Exercício | Ligação com a parte empírica | Resolução |
|---|---|---|
| Q6 (ARMA(1,1): FAC e pesos) | a forma da FAC que se lê na Q3 | [02_lista](../02_arma/02_lista.md) |
| Q9 (sobrediferenciação) | é a Q6 empírica no papel | [03_lista](../03_arima_sarima/03_lista.md) |
| Q10 (DS × TS) | o argumento 5 da Q2 | [03_lista](../03_arima_sarima/03_lista.md) |
| Q12 (SARIMA e previsão) | a estrutura multiplicativa e a Q7 | [03_lista](../03_arima_sarima/03_lista.md) |
| Q14 (AIC e BIC) | a escolha da Q4 | [04_lista](../04_estimacao_selecao/04_lista.md) |

## 9. As armadilhas que mais caem

1. **"Não rejeitar a raiz unitária prova que ela existe."** Falso. O ADF tem pouco poder perto de $\rho=1$. Por isso se usa o KPSS junto.
2. **Usar o crítico da $t$ de Student no ADF.** Sob $H_0$, a distribuição é a de Dickey-Fuller, com críticos mais negativos.
3. **Esquecer a tendência no ADF de uma série que cresce.** A alternativa fica absurda, e o teste perde poder; no INPC, o $\tau_1$ sai até positivo.
4. **Comparar AIC entre modelos com $d$ diferentes.** São verossimilhanças de séries diferentes.
5. **Contar o drift nos graus de liberdade do Ljung-Box.** Só $p+q+P+Q$ entram.
6. **Achar que rejeitar a normalidade invalida o modelo.** Afeta os intervalos, não a consistência.
7. **Trocar o sinal do MA.** O R usa $1+\theta B$; a lista usa $1-\theta B$.
8. **Diferenciar sazonalmente uma sazonalidade fixa.** Cria um MA sazonal com raiz unitária.
9. **Ler as raízes inversas como se fossem as raízes.** No gráfico do R, ficar **dentro** do círculo é o bom.
10. **Mudar o modelo depois de ver o resultado da previsão.** A validação fora da amostra deixa de ser fora da amostra.

## 10. A ordem de raciocínio, numa página

Se na prova vier uma série nova, siga esta ordem:

1. **Gráfico.** Tendência? Sazonalidade? Variância crescente? Outliers?
2. **Transformação.** Se a variância cresce com o nível, log (Box-Cox com $\lambda$ perto de 0).
3. **$d$.** ADF com os termos determinísticos certos (tendência se a série cresce), PP e KPSS. Se discordarem, decidir com argumentos, e testar de novo na diferença.
4. **$D$.** OCSB ou Canova-Hansen. Sazonalidade estável pede $D=0$.
5. **FAC e FACP** da série estacionária. Parte regular nas primeiras defasagens; parte sazonal em 12, 24, 36; picos em 11 e 13 indicam estrutura multiplicativa.
6. **Candidatos.** Dois ou três, cobrindo as leituras possíveis.
7. **MV exata.** Comparar AIC e BIC com a mesma amostra. Conferir as raízes.
8. **Resíduos.** Ljung-Box com os graus de liberdade certos, ARCH-LM, Jarque-Bera. Sobreajuste.
9. **Previsão fora da amostra** contra o passeio aleatório e o sazonal ingênuo.

## 11. Perguntas de prova, com resposta

Tente responder antes de ler a resposta.

**1. Por que modelar $100\ln P_t$ e não $P_t$?**
Porque o log estabiliza a variância de uma série que cresce exponencialmente e lineariza a tendência. Além disso, a diferença do log é a taxa de inflação mensal em %.

**2. Qual a diferença entre uma série TS e uma DS? Por que importa?**
Na TS, choques são temporários, e a série volta para uma tendência determinística; estacionariza-se tirando a tendência. Na DS, choques são permanentes; estacionariza-se diferenciando. Tratar uma como a outra gera, respectivamente, um MA não invertível ou um resíduo com raiz unitária.

**3. Por que o teste ADF não usa os valores críticos da normal?**
Porque, sob $H_0$, o regressor $y_{t-1}$ é não estacionário, e a estatística $\tau$ converge para um funcional do movimento browniano, não para uma normal. A distribuição é deslocada para a esquerda.

**4. Para que servem as defasagens $\Delta y_{t-i}$ no ADF?**
Para tornar o erro da regressão um ruído branco. Sem elas, a autocorrelação do erro distorce o tamanho do teste.

**5. Por que o ADF do INPC deve ter constante e tendência?**
Porque a série cresce. Sob a alternativa, ela só pode ser estacionária em torno de uma tendência. Sem a tendência, o teste compara a raiz unitária com uma alternativa absurda e perde poder; o $\phi_3=8{,}82$ confirma que a tendência é significativa.

**6. O ADF e o KPSS do INPC discordam. O que fazer?**
Não há regra mecânica. Pesam a fragilidade da rejeição do ADF (depende de $k$ a 1%), o PP e o KPSS apontando raiz unitária, o argumento econômico (metas de inflação) e a ausência de um MA unitário no modelo da diferença. Conclui-se $d=1$.

**7. O que indica um pico na FACP em 1 e nada depois?**
Um AR(1). A FACP de um AR($p$) corta depois de $p$.

**8. O que indicam picos na FAC em 11, 12 e 13?**
Uma estrutura multiplicativa regular × sazonal, que gera termos cruzados em $12\pm1$.

**9. Por que o $k$ do AIC inclui $\sigma^2$?**
Porque $\sigma^2$ também é estimado por MV. Ele conta como parâmetro na verossimilhança.

**10. AIC escolhe um modelo e BIC escolhe outro. Qual usar?**
Depende do objetivo. O BIC é consistente: escolhe o modelo verdadeiro se ele está entre os candidatos. O AIC é eficiente para previsão. Para prever, usa-se o AIC.

**11. Quantos graus de liberdade tem o Ljung-Box com $K=24$ para um SARIMA(1,1,0)(1,0,1)$_{12}$ com drift?**
$24-(1+0+1+1)=21$. O drift não entra.

**12. O Jarque-Bera rejeitou. O modelo é inválido?**
Não. Os estimadores de MV gaussiana continuam consistentes, e a previsão pontual vale. O que fica errado são os intervalos de previsão nas caudas.

**13. Como reconhecer sobrediferenciação no output?**
Um MA estimado perto de $-1$ (convenção do R), variância residual maior do que com uma diferença a menos e $\rho_1$ perto de $-0{,}5$ na série diferenciada.

**14. Por que o modelo com $d=2$ não é invertível?**
Porque diferenciar uma série estacionária introduz o fator $(1-B)$ no MA, com raiz em $z=1$, sobre o círculo unitário.

**15. Qual a diferença entre o esquema 1 e o esquema 2 da Q7?**
O esquema 1 prevê 24 meses de uma vez, só com a informação até $T_0$. O esquema 2 prevê um mês por vez, usando os dados observados até ali, com os mesmos coeficientes. O esquema 2 é mais fácil e erra menos.

**16. Por que o intervalo de previsão de um ARIMA se abre com o horizonte?**
Porque a variância do erro é $\sigma^2\sum_{j=0}^{h-1}\psi_j^2$. Num modelo integrado, os $\psi_j$ não vão a zero, e a soma cresce sem limite.

**17. Por que o sazonal ingênuo vai tão mal no índice?**
Porque ele repete o nível de 12 meses antes. No índice, isso significa errar sistematicamente por um ano inteiro de inflação.

**18. Uma cobertura de 100% num intervalo de 95% indica um problema?**
Não necessariamente. São só 24 pontos, de uma única origem, com erros fortemente correlacionados. A amostra é pequena demais para concluir.

**19. O que significa o drift num modelo com $d=1$?**
É a média da série diferenciada. Aqui, é a inflação média mensal, $\widehat\mu=0{,}502\%$. No nível, vira uma tendência linear do log.

**20. Por que se escolhem três candidatos, e não um?**
Porque a FAC e a FACP raramente apontam um único modelo. A identificação propõe; a estimação, os critérios e o diagnóstico decidem.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| l01_T | 321 |
| l01_lambda | 0,30 |
| l01_adf_tau3 | -3,985 |
| l01_adf_k | 13 |
| l01_adf_bic_tau3 | -3,61 |
| l01_adf_bic_k | 1 |
| l01_adf_rho | 0,975 |
| l01_pp | -2,38 |
| l01_kpss | 0,170 |
| l01_adf_tau2 | -1,82 |
| l01_adf_tau1 | 5,99 |
| l01_adf_phi3 | 8,82 |
| l01_adf_phi1 | 20,7 |
| l01_adf_dy | -6,93 |
| l01_kpss_dy | 0,238 |
| l01_ndiffs | 1 |
| l01_nsdiffs | 0 |
| l01_sobre_ma1 | -0,058 |
| l01_banda | 0,110 |
| l01_facp1 | 0,628 |
| l01_facp2 | 0,038 |
| l01_fac1 | 0,628 |
| l01_fac2 | 0,417 |
| l01_fac3 | 0,252 |
| l01_fac12 | 0,212 |
| l01_facp12 | 0,114 |
| l01_fac24 | 0,049 |
| l01_facp13 | -0,131 |
| l01_c3_ar1 | 0,633 |
| l01_c3_sar1 | 0,822 |
| l01_c3_sma1 | -0,677 |
| l01_c3_drift | 0,502 |
| l01_c3_sigma2 | 0,1141 |
| l01_c3_n | 320 |
| l01_c1_aic | 217,899 |
| l01_c2_aic | 220,034 |
| l01_c3_aic | 216,537 |
| l01_c1_bic | 232,972 |
| l01_c2_bic | 235,107 |
| l01_c3_bic | 235,378 |
| l01_lr | 3,36 |
| l01_lr_p | 0,067 |
| l01_c3_sma1_p | 0,0005 |
| l01_lb_q | 14,05 |
| l01_lb_p | 0,868 |
| l01_semar_lb_p | 0,000 |
| l01_jb | 402,5 |
| l01_curtose | 8,2 |
| l01_arch | 11,00 |
| l01_arch_p | 0,529 |
| l01_sobre_ar2_p | 0,490 |
| l01_sobre_ma1_p | 0,508 |
| l01_d2m_ma1 | -1,0000 |
| l01_d2_aumento | 17,5 |
| l01_d2_sigma2 | 0,1341 |
| l01_d2_rho1 | -0,210 |
| l01_d2_ar1 | -0,218 |
| l01_d2_rho1_teo | -0,183 |
| l01_q7_rmse_s1 | 120,1 |
| l01_q7_mape_s1 | 1,22 |
| l01_q7_rmse_s2 | 30,8 |
| l01_q7_mape_s2 | 0,29 |
| l01_q7_rmse_rw1 | 425,1 |
| l01_q7_mape_rw1 | 4,96 |
| l01_q7_rmse_rw2 | 40,9 |
| l01_q7_mape_rw2 | 0,43 |
| l01_q7_rmse_sn1 | 525,3 |
| l01_q7_mape_sn1 | 6,59 |
| l01_q7_rmse_sn2 | 328,7 |
| l01_q7_mape_sn2 | 4,33 |
| l01_q7_cobertura | 100 |
-->
