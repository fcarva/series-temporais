---
title: "P1 (05/11) — resolução completa, passo a passo, com rubrica para se corrigir"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
prova: "05/11/2026"
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
  - Resolução da P1
---

# P1 de 05/11: a resolução completa, passo a passo

Esta é a resolução da prova inteira, linha a linha, no mesmo formato do guia e da folha do que cai. Os enunciados estão **parafraseados**. Em cada questão há uma **rubrica por passo**, com uma coluna "Escrevi?": marque ✓ (completo), ½ (parcial) ou ✗ (faltou) para estimar a sua nota. A rubrica é a mesma lógica dos gabaritos dos simulados; a do professor pode pesar os passos de outro jeito.

A prova tinha **quatro questões**, valendo 2,5, 3, 3 e 2,5. Tudo o que caiu estava no [quadro de 04/11](o_que_cai.md).

---

## Questão 1 (2,5) — Box-Jenkins para consumo mensal

**Enunciado, em resumo.** Uma série mensal de consumo tem tendência estocástica, isto é, **raiz unitária na parte regular**, e um **padrão sazonal estacionário**. O objetivo é acompanhar e prever. Pede-se:
- a) as etapas do ciclo;
- b) os testes, com $H_0$, $H_1$ e o objetivo de cada um;
- c) a escolha entre quatro SARIMA, dados os AIC: $(1,0,1)(1,0,0)_{12}$ com $-50$; $(1,1,1)(1,0,0)_{12}$ com $-45$; $(0,0,1)(1,0,0)_{12}$ com $-60$; $(0,1,1)(0,0,0)_{12}$ com $-40$;
- d) a equação do modelo escolhido.

### O que a questão quer

- **a)** As quatro etapas, com a volta à primeira, e **ligadas ao objetivo**, que é prever.
- **b)** Para cada teste, as três coisas: $H_0$, $H_1$ e para que serve.
- **c)** Usar **as informações do enunciado antes do AIC**. É aqui que está a armadilha.
- **d)** Os polinômios do modelo do item c), na notação de $B$.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & \text{I: gráfico, ADF para o } d,\ \text{FAC e FACP para } p,q,P,Q && [\text{identificação}]\\
\text{(2)}\quad & \text{E: MV dos candidatos; AIC e BIC} && [\text{estimação}]\\
\text{(3)}\quad & \text{D: resíduos RB (Ljung-Box, JB); se falha, volta a (1)} && [\text{diagnóstico}]\\
\text{(4)}\quad & \text{P: prever os próximos meses e avaliar} && [\text{previsão: o objetivo}]\\
\text{(5)}\quad & \text{ADF: } H_0:\gamma=0 \text{ (raiz unitária)};\ H_1:\gamma\lt0;\ \text{achar o } d && [\text{teste 1}]\\
\text{(6)}\quad & \text{Ljung-Box: } H_0:\rho_1=\dots=\rho_K=0;\ H_1:\text{algum}\ne0 && [\text{teste 2}]\\
\text{(7)}\quad & \text{Jarque-Bera: } H_0:\text{normal};\ H_1:\text{não normal} && [\text{teste 3}]\\
\text{(8)}\quad & \text{raiz unitária regular}\Rightarrow d=1:\ \text{saem os dois de } d=0 && [\text{enunciado antes do AIC}]\\
\text{(9)}\quad & \text{sazonal estacionário}\Rightarrow D=0,\ \text{com parte sazonal} && [\text{sai o } (0,1,1)(0,0,0)_{12}]\\
\text{(10)}\quad & \text{escolha: SARIMA}(1,1,1)(1,0,0)_{12} && [\text{AIC } -45]\\
\text{(11)}\quad & (1-\phi_1B)(1-\Phi_1B^{12})(1-B)\,y_t=(1+\theta_1B)\,\varepsilon_t && [\text{modelo}]\\
\text{(12)}\quad & y_t=(1+\phi_1)y_{t-1}-\phi_1y_{t-2}+\Phi_1y_{t-12} && [\text{expande e isola}]\\
& \phantom{y_t=}-\Phi_1(1+\phi_1)y_{t-13}+\phi_1\Phi_1y_{t-14}+\varepsilon_t+\theta_1\varepsilon_{t-1} && [\text{sinal troca ao isolar}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** Na identificação, o enunciado já deu o resultado do ADF, que é a raiz unitária regular. A etapa continua sendo onde se escolhe o $d$.
- **(2)** A estimação produz o AIC da tabela do item c).
- **(3)** O diagnóstico é o que transforma a lista de etapas num **ciclo**: se os resíduos não são ruído branco, volta-se a identificar.
- **(4)** A previsão é o objetivo declarado. Uma resposta sem ela fica incompleta justamente no que o enunciado pede.
- **(5)** O ADF é o teste que decide o $d$. A nula é a raiz unitária.
- **(6)** O Ljung-Box testa, de uma vez, as $K$ primeiras autocorrelações dos resíduos.
- **(7)** A normalidade importa para os intervalos de previsão. O ARCH-LM, para a variância condicional, conta como extra.
- **(8)** **A armadilha.** O menor AIC, $-60$, é de um modelo com $d=0$. Com raiz unitária, ele está mal especificado. Além disso, **não se compara AIC entre modelos com $d$ diferente**, porque a série modelada não é a mesma: o nível num caso, a diferença no outro.
- **(9)** "Sazonal estacionário" quer dizer $D=0$, mas **com** a parte sazonal, $P=1$. O $(0,1,1)(0,0,0)_{12}$ ignora a sazonalidade.
- **(10)** Sobra um único candidato coerente com as duas informações. O AIC só decide entre modelos que já passaram por esse filtro.
- **(11)** São três polinômios do lado de $y$: o AR comum, o AR sazonal e a diferença. Do lado do choque, um MA(1). O sinal $1+\theta_1B$ é o dos slides; na lista, seria $1-\theta B$.
- **(12)** Os produtos expandidos: $(1-\phi_1B)(1-B)=1-(1+\phi_1)B+\phi_1B^2$; vezes $(1-\Phi_1B^{12})$, aparecem os termos em 12, 13 e 14. Com $\phi_1=0{,}5$ e $\Phi_1=0{,}4$, os coeficientes de $y_{t-1}$, $y_{t-2}$, $y_{t-12}$, $y_{t-13}$ e $y_{t-14}$ são 1,5; $-0{,}5$; 0,4; $-0{,}6$; 0,2, e zero nas defasagens 3 a 11.

**Frase de fecho:** "Como o enunciado indica raiz unitária na parte regular e sazonalidade estacionária, só são coerentes os modelos com $d=1$, $D=0$ e parte sazonal. Entre eles, escolho o SARIMA$(1,1,1)(1,0,0)_{12}$. O de AIC $-60$ tem $d=0$ e não pode ser comparado com os de $d=1$."

### Rubrica

| Passo | Pontos | Escrevi? |
|---|---|---|
| a) as quatro etapas, com a previsão | 0,35 | |
| a) a volta ao início (ciclo iterativo) | 0,15 | |
| b) ADF com $H_0$, $H_1$ e objetivo | 0,35 | |
| b) Ljung-Box com $H_0$, $H_1$ e objetivo | 0,25 | |
| b) Jarque-Bera ou ARCH com $H_0$ e $H_1$ | 0,15 | |
| c) eliminar os de $d=0$ pela raiz unitária | 0,35 | |
| c) exigir a parte sazonal e escolher o $(1,1,1)(1,0,0)_{12}$ | 0,25 | |
| c) não comparar AIC com $d$ diferente | 0,15 | |
| d) os polinômios certos do modelo escolhido | 0,35 | |
| d) a expansão ou a forma com $\Delta y_t$ | 0,15 | |

**Onde se costuma perder:**
- escolher o modelo de $-60$ só pelo AIC: é a armadilha da questão;
- esquecer a previsão no ciclo;
- citar o teste sem $H_1$ ou sem o objetivo.

---

## Questão 2 (3,0) — o ARMA(1,2)

**Enunciado, em resumo.** Para $y_t=0{,}8y_{t-1}+\varepsilon_t-0{,}3\varepsilon_{t-1}-0{,}1\varepsilon_{t-2}$, com $\varepsilon_t\sim RB(0,\sigma^2)$:
- a) os polinômios AR e MA, as raízes, a estacionariedade e a invertibilidade;
- b) as autocovariâncias.

### O que a questão quer

- **a)** Escrever $\phi(z)$ e $\theta(z)$, achar **todas** as raízes e concluir com o critério.
- **b)** Derivar os $\gamma_k$, **com o $\sigma^2$**, porque ele não tem valor no enunciado.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & \phi(z)=1-0{,}8z=0\Rightarrow z=1{,}25,\ \lvert z\rvert\gt1 && [\text{estacionário}]\\
\text{(2)}\quad & \theta(z)=1-0{,}3z-0{,}1z^2=0\iff0{,}1z^2+0{,}3z-1=0 && [\text{forma padrão}]\\
\text{(3)}\quad & \Delta=0{,}09+0{,}4=0{,}49;\ \ z=\tfrac{-0{,}3\pm0{,}7}{0{,}2}\Rightarrow z=2,\ z=-5 && [\text{Bhaskara}]\\
\text{(4)}\quad & \lvert2\rvert\gt1,\ \lvert-5\rvert\gt1\Rightarrow\text{invertível};\ (1-0{,}5z)(1+0{,}2z)=\theta(z) && [\text{confere}]\\
\text{(5)}\quad & E(y_t\varepsilon_t)=\sigma^2 && [\times\varepsilon_t;\ \text{caus.}]\\
\text{(6)}\quad & E(y_t\varepsilon_{t-1})=0{,}8\sigma^2-0{,}3\sigma^2=0{,}5\sigma^2 && [\times\varepsilon_{t-1}]\\
\text{(7)}\quad & E(y_t\varepsilon_{t-2})=0{,}8(0{,}5\sigma^2)-0{,}1\sigma^2=0{,}3\sigma^2 && [\times\varepsilon_{t-2}]\\
\text{(8)}\quad & \gamma_0=0{,}8\gamma_1+\sigma^2-0{,}3(0{,}5\sigma^2)-0{,}1(0{,}3\sigma^2)=0{,}8\gamma_1+0{,}82\sigma^2 && [\times y_t]\\
\text{(9)}\quad & \gamma_1=0{,}8\gamma_0+0-0{,}3\sigma^2-0{,}1(0{,}5\sigma^2)=0{,}8\gamma_0-0{,}35\sigma^2 && [\times y_{t-1}]\\
\text{(10)}\quad & \gamma_0=0{,}64\gamma_0-0{,}28\sigma^2+0{,}82\sigma^2\Rightarrow\gamma_0=1{,}5\sigma^2 && [(9)\text{ em }(8)]\\
\text{(11)}\quad & \gamma_1=1{,}2\sigma^2-0{,}35\sigma^2=0{,}85\sigma^2 && [(9)]\\
\text{(12)}\quad & \gamma_2=0{,}8\gamma_1-0{,}1\sigma^2=0{,}58\sigma^2 && [\times y_{t-2}]\\
\text{(13)}\quad & \gamma_k=0{,}8\gamma_{k-1},\ k\ge3:\ \gamma_3=0{,}464\sigma^2 && [\text{só o AR sobra}]\\
\text{(14)}\quad & \rho_1=0{,}5667;\ \ \rho_2=0{,}3867;\ \ \rho_3=0{,}3093 && [\div\gamma_0:\ \sigma^2 \text{ cancela}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** A raiz do AR é a de um número $z$. Fora do círculo, o processo é estacionário.
- **(2)** Escrevo o MA como polinômio e passo para a forma $az^2+bz+c=0$, para não errar sinal no Bhaskara.
- **(3)** O discriminante e as duas raízes. Uma é negativa: o módulo é o que conta.
- **(4)** As duas raízes estão fora do círculo, então o processo é invertível. A fatoração confere a conta em dez segundos.
- **(5)** Primeiro auxiliar: o choque de hoje entra em $y_t$ com peso 1. Os termos com $y_{t-1}$ e com choques passados zeram.
- **(6)** O choque de ontem entra por dois caminhos: via $0{,}8y_{t-1}$, que vale $0{,}8\sigma^2$, e diretamente, com $-0{,}3\sigma^2$.
- **(7)** O choque de anteontem chega via $0{,}8y_{t-1}$, que carrega o auxiliar (6) uma data atrás, e diretamente, com $-0{,}1\sigma^2$.
- **(8)** Multiplico por $y_t$, porque $\gamma_0=E(y_t^2)$. Cada termo do MA puxa o auxiliar do seu choque. **É aqui que o $\sigma^2$ precisa aparecer em todos os termos.**
- **(9)** Multiplico por $y_{t-1}$. O $\varepsilon_t$ é posterior a $y_{t-1}$ e zera; o $\varepsilon_{t-1}$ vale $\sigma^2$ por (5) uma data atrás; o $\varepsilon_{t-2}$ vale $0{,}5\sigma^2$ por (6) uma data atrás.
- **(10)** Substituo (9) em (8) e isolo: $0{,}36\gamma_0=0{,}54\sigma^2$.
- **(11)** Volto em (9).
- **(12)** Para $\gamma_2$, multiplico por $y_{t-2}$. Só o $\varepsilon_{t-2}$ ainda alcança $y_{t-2}$, valendo $\sigma^2$.
- **(13)** A partir de 3, nenhum choque do MA alcança $y_{t-k}$, e sobra o AR: a FAC decai à taxa 0,8.
- **(14)** As autocorrelações não dependem do $\sigma^2$, que cancela.

**Frase de fecho:** "As raízes são 1,25 (AR), 2 e $-5$ (MA), todas fora do círculo: o processo é estacionário e invertível. $\gamma_0=1{,}5\sigma^2$, $\gamma_1=0{,}85\sigma^2$, $\gamma_2=0{,}58\sigma^2$ e $\gamma_k=0{,}8\gamma_{k-1}$ para $k\ge3$."

### Rubrica

| Passo | Pontos | Escrevi? |
|---|---|---|
| a) $\phi(z)$, a raiz 1,25 e "estacionário" | 0,5 | |
| a) $\theta(z)$ na forma padrão e o Bhaskara | 0,5 | |
| a) as raízes 2 e $-5$ e "invertível" | 0,5 | |
| b) os três auxiliares (5)–(7) | 0,4 | |
| b) as equações de $\gamma_0$ e de $\gamma_1$ | 0,4 | |
| b) o sistema resolvido, $\gamma_0$ e $\gamma_1$ | 0,3 | |
| b) $\gamma_2$ e a recursão para $k\ge3$ | 0,25 | |
| b) o $\sigma^2$ em todas as linhas | 0,15 | |

**O seu caso, o $\sigma^2$:**

| O que aconteceu | Perda provável em b) |
|---|---|
| fez tudo com $\sigma^2=1$, mas o método está certo | 0,1 a 0,3 (talvez só a última linha da rubrica) |
| o $\sigma^2$ ficou em algumas linhas e saiu de outras | 0,3 a 0,5 |
| um auxiliar ficou sem o $\sigma^2$ e contaminou os números | cerca de metade de b), se o método estiver certo |

Os $\rho$ e todo o item a) não dependem do $\sigma^2$.

---

## Questão 3 (3,0) — a soma $z_t=x_t+2v_t$

**Enunciado, em resumo.** $x_t=0{,}5x_{t-1}+\varepsilon_t$ é um AR(1) estacionário, com $\varepsilon_t\sim RB(0,1)$, e $v_t\sim RB(0,1)$ não se correlaciona com $\varepsilon$ em nenhuma data. Observa-se só $z_t=x_t+2v_t$. Pede-se:
- a) a autocovariância de $z$;
- b) se $z$ é estacionário.

### O que a questão quer

- **a)** A fórmula de $\gamma_z(k)$ com os quatro termos e os números.
- **b)** O critério das três condições, com a justificativa.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & \gamma_x(k)=0{,}5^k\gamma_x(0),\quad \gamma_x(0)=\tfrac{1}{1-0{,}25}=\tfrac43 && [\text{AR(1)}]\\
\text{(2)}\quad & \gamma_v(0)=1;\ \ \gamma_v(k)=0,\ k\ge1 && [\text{RB}]\\
\text{(3)}\quad & \gamma_z(k)=\operatorname{Cov}(x_t+2v_t,\ x_{t-k}+2v_{t-k}) && [\text{definição}]\\
\text{(4)}\quad & \phantom{\gamma_z(k)}=\gamma_x(k)+2C_{xv}(k)+2C_{vx}(k)+4\gamma_v(k) && [\text{quatro termos}]\\
\text{(5)}\quad & C_{xv}=C_{vx}=0\Rightarrow\gamma_z(k)=\gamma_x(k)+4\gamma_v(k) && [\text{não correlacionados}]\\
\text{(6)}\quad & \gamma_z(0)=\tfrac43+4=\tfrac{16}{3}=5{,}3333 && [k=0]\\
\text{(7)}\quad & \gamma_z(k)=\tfrac43\,0{,}5^k:\ 0{,}6667;\ 0{,}3333;\ 0{,}1667 && [k\ge1]\\
\text{(8)}\quad & \rho_1=0{,}6667/5{,}3333=0{,}125;\ \ \rho_k=0{,}125\cdot0{,}5^{k-1} && [\div\gamma_z(0)]\\
\text{(9)}\quad & E(z_t)=0;\ \ \gamma_z(k) \text{ só depende de } k\Rightarrow\text{estacionário} && [\text{três condições}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** A autocovariância do AR(1) é conta conhecida: a variância $\sigma^2/(1-\phi^2)$ e a FAC $\phi^k$.
- **(2)** O ruído branco só tem variância. Nas outras defasagens, zero.
- **(3)** Escrevo a definição com as duas datas.
- **(4)** São os quatro produtos de $(A+2C)(D+2E)$. O 2 multiplica duas vezes no último termo: daí o **4**.
- **(5)** A hipótese de que $\varepsilon$ e $v$ não se correlacionam é o que zera os cruzados. **Cite-a.** É o $z_3=z_1+2z_2$ do quadro.
- **(6)** Em $k=0$, as duas variâncias somam.
- **(7)** Em $k\ge1$, o ruído branco não contribui. Sobra o AR(1).
- **(8)** A FAC de $z$ é a do AR(1), achatada pela variância extra do ruído.
- **(9)** A média é constante, a variância é finita e a covariância depende só de $k$. Uma soma de processos estacionários não correlacionados é estacionária. **Extra:** multiplicando por $(1-0{,}5B)$, $z$ vira um ARMA(1,1).

**Frase de fecho:** "$\gamma_z(0)=16/3$ e $\gamma_z(k)=\frac43\,0{,}5^k$ para $k\ge1$: nada depende de $t$, logo $z_t$ é estacionário."

### Rubrica

| Passo | Pontos | Escrevi? |
|---|---|---|
| a) o $\gamma_x(k)$ do AR(1) | 0,4 | |
| a) os quatro termos, com os cruzados zerados citando a hipótese | 0,5 | |
| a) o fator 4 e $\gamma_z(0)=16/3$ | 0,35 | |
| a) $\gamma_z(k)$ para $k\ge1$ | 0,25 | |
| b) as três condições verificadas | 0,9 | |
| b) a justificativa: soma de estacionários não correlacionados | 0,6 | |

**Onde se costuma perder:** usar 2 no lugar de 4; esquecer que $\gamma_v(k)=0$ para $k\ge1$; responder "sim" sem as três condições.

---

## Questão 4 (2,5) — Dickey-Fuller no log do consumo trimestral

**Enunciado, em resumo.** Com $T=100$ e o ADF com $p=2$ defasagens (escolhidas pelo AIC, com o Ljung-Box sem rejeitar), a tabela traz:

| Modelo | Estatística | Valor | Crítico |
|---|---|---|---|
| III, constante e tendência | $\tau_3$; $\phi_3$ | $-2{,}10$; 2,40 | $-3{,}45$; 6,49 |
| II, só constante | $\tau_2$; $\phi_1$ | $-1{,}20$; 5,80 | $-2{,}89$; 4,71 |
| I, nada | $\tau_1$ | 0,85 | $-1{,}95$ |

Pede-se:
- a) por que entram as defasagens, e o que acontece se forem omitidas;
- b) a cadeia sequencial: se há raiz unitária e que termos determinísticos ficam.

### O que a questão quer

- **a)** O papel das defasagens e a consequência de omiti-las.
- **b)** Cada passo da cadeia com a comparação e a decisão, mais a conclusão sobre raiz unitária **e** sobre os termos determinísticos.

### Linha a linha

$$
\begin{aligned}
\text{(1)}\quad & \text{as defasagens } \Delta y_{t-i} \text{ deixam o erro ruído branco} && [\text{ADF}]\\
\text{(2)}\quad & \text{sem elas: erro autocorrelacionado; o } \tau \text{ perde a distribuição tabulada} && [\text{tamanho distorcido}]\\
\text{(3)}\quad & \tau_3=-2{,}10\gt-3{,}45\Rightarrow\text{não rejeita } \gamma=0 && [\text{passo 1}]\\
\text{(4)}\quad & \phi_3=2{,}40\lt6{,}49\Rightarrow\text{não rejeita } \gamma=a_2=0:\ \text{tira a tendência} && [\text{passo 2}]\\
\text{(5)}\quad & \tau_2=-1{,}20\gt-2{,}89\Rightarrow\text{não rejeita } \gamma=0 && [\text{passo 3}]\\
\text{(6)}\quad & \phi_1=5{,}80\gt4{,}71\Rightarrow\text{rejeita } a_0=\gamma=0:\ \text{o drift fica} && [\text{passo 4}]\\
\text{(7)}\quad & \text{com drift, } \gamma \text{ na normal: } -1{,}20\gt-1{,}645\Rightarrow\text{não rejeita} && [\text{passo 5}]\\
\text{(8)}\quad & \text{raiz unitária com drift, sem tendência: diferenciar uma vez} && [\text{conclusão}]
\end{aligned}
$$

### O sentido de cada linha

- **(1)** Os valores críticos de Dickey-Fuller supõem um erro sem autocorrelação. As defasagens de $\Delta y$ absorvem a dinâmica que sobraria no erro.
- **(2)** Com autocorrelação no erro, a estatística não segue a tabela. O teste rejeita, ou deixa de rejeitar, com a probabilidade errada. O Ljung-Box sem rejeitar, com $p=2$, mostra que duas defasagens bastaram.
- **(3)** O modelo mais geral não rejeita. Ainda não se conclui nada: pode ser falta de poder por excesso de termos.
- **(4)** O $\phi_3$ é um teste F: rejeita quando é **maior** que o crítico. Não rejeitar diz que a tendência pode sair.
- **(5)** No modelo II, de novo não rejeita.
- **(6)** O $\phi_1$ rejeita: a constante e a raiz unitária nula não se sustentam juntas. **A constante fica**: há drift.
- **(7)** Com o drift presente, o $\gamma$ se testa pela normal. $-1{,}20$ fica à direita de $-1{,}645$: não rejeita. Não é preciso descer ao modelo I. De todo modo, $0{,}85\gt-1{,}95$ também não rejeitaria.
- **(8)** O log do consumo é um passeio com drift: diferencia-se uma vez. O drift é o crescimento médio do consumo.

**Frase de fecho:** "O $\tau$ não rejeita a raiz unitária nos modelos III e II. O $\phi_3$ tira a tendência, e o $\phi_1$ mantém a constante. Testado na normal, o $\gamma$ continua sem rejeitar: o log do consumo tem **raiz unitária com drift**, sem tendência determinística, e deve ser diferenciado uma vez."

### Rubrica

| Passo | Pontos | Escrevi? |
|---|---|---|
| a) as defasagens branqueiam o erro | 0,4 | |
| a) a consequência: distribuição errada, tamanho distorcido | 0,35 | |
| b) o passo 1, com a regra do $\tau$ | 0,3 | |
| b) o passo 2, $\phi_3$ contra o seu crítico, e a tendência sai | 0,35 | |
| b) o passo 3 | 0,25 | |
| b) o passo 4, $\phi_1$ rejeita, e o drift fica | 0,35 | |
| b) a conclusão: raiz unitária com drift; diferenciar | 0,5 | |

Pelas marcas no enunciado, as comparações da tabela estão **todas certas**.

---

## A sua nota

Some os pontos das rubricas que você marcou:

| Questão | Máximo | O seu |
|---|---|---|
| Q1 | 2,5 | |
| Q2 | 3,0 | |
| Q3 | 3,0 | |
| Q4 | 2,5 | |
| **Total** | **10,0** | |

**O que já se sabe pelas marcas e pelo que você contou:**
- **Q4:** a leitura da tabela está certa.
- **Q1 c):** é provável que a escolha tenha sido o modelo de $-60$, a armadilha. Isso custa a maior parte de 0,75, e talvez parte do d).
- **Q2 b):** o $\sigma^2$, entre 0,1 e cerca de 0,75, conforme o cenário da tabela da Q2.

Mande as fotos das folhas de resposta para a correção definitiva, com o lançamento no [log de erros](log_erros.md).

**Para revisar o que caiu:**
- a folha [o que cai](o_que_cai.md): seções 2, 6, 7, 9 e 10;
- [Q12 comentada](../lista_comentada/q12.md), para o diagnóstico de resíduos;
- [Q16 comentada](../lista_comentada/q16.md), para a escolha de modelo.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_p1_q1_c1 | 1,5 |
| pv_p1_q1_c2 | -0,5 |
| pv_p1_q1_c12 | 0,4 |
| pv_p1_q1_c13 | -0,6 |
| pv_p1_q1_c14 | 0,2 |
| pv_p1_q1_resto | 0 |
| pv_p1_q2_raiz_ar | 1,25 |
| pv_p1_q2_raiz_ma_pos | 2 |
| pv_p1_q2_raiz_ma_neg | -5 |
| pv_p1_q2_delta | 0,49 |
| pv_p1_q2_aux1 | 0,5 |
| pv_p1_q2_aux2 | 0,3 |
| pv_p1_q2_c0 | 0,82 |
| pv_p1_q2_c1 | -0,35 |
| pv_p1_q2_g0 | 1,5 |
| pv_p1_q2_g1 | 0,85 |
| pv_p1_q2_g2 | 0,58 |
| pv_p1_q2_g3 | 0,464 |
| pv_p1_q2_rho1 | 0,5667 |
| pv_p1_q2_rho2 | 0,3867 |
| pv_p1_q2_rho3 | 0,3093 |
| pv_p1_q3_gx0 | 1,3333 |
| pv_p1_q3_gz0 | 5,3333 |
| pv_p1_q3_gz1 | 0,6667 |
| pv_p1_q3_gz2 | 0,3333 |
| pv_p1_q3_gz3 | 0,1667 |
| pv_p1_q3_rho1 | 0,125 |
| pv_p1_q4_decisao | 2 |
| pv_p1_q4_normal | -1,645 |
-->
