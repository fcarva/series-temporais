---
title: "Apostila, cap. 1 — Processos e momentos: o que é estável numa série"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: [1, 2, 3, 4]
aulas: "AU01 p. 21–35; AU02 p. 15–23"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Apostila cap. 1 — Processos e momentos
---

# Capítulo 1 · Processos e momentos: o que é estável numa série

[← apostila](README.md) · próximo: [cap. 2](cap2_ar_ma_arma.md) · questões da lista: Q1 a Q4

## Pergunta de abertura

Só existe **um** PIB brasileiro de 1996 a 2026: uma única história, que não se repete. Mesmo assim, falamos da "média" e da "variância" do crescimento, como se tivéssemos visto muitas histórias. **Com que direito se calcula a média de algo que aconteceu uma vez só?** E, se a resposta envolve "supor que o futuro se parece com o passado", **em que sentido exatamente ele se parece?**

A AU01 responde com dois conceitos, um para cada metade da pergunta (p. 23–27):
- **estacionariedade:** o futuro se parece com o passado nos momentos;
- **ergodicidade:** uma única história basta para aprender esses momentos.

O resto do capítulo é o que acontece quando eles falham, no passeio aleatório, e o que se ganha quando valem, com o Teorema de Wold.

## A imagem

**O processo é uma máquina de histórias; a série é uma história que saiu dela** (AU01, p. 22–23). Imagine universos paralelos. Em cada um, a mesma máquina gera uma trajetória diferente do PIB. Nós moramos em um só deles e vemos uma só trajetória. $E(y_t)$ é a média **entre universos** numa data fixa, não a média ao longo do tempo.

**Estacionariedade é um rio de nível estável.** A água que passa muda o tempo todo: cada gota é nova, como cada choque. Mas, em qualquer trecho que você olhe:
- o nível médio é o mesmo;
- a agitação é a mesma;
- a semelhança entre dois pontos depende só da **distância** entre eles, não de onde estão.

São exatamente as três condições da AU01, p. 25: $\mu$ constante, $\gamma_0$ constante e $\gamma_k$ dependendo só de $k$.

**Ergodicidade é poder trocar o "entre universos" pelo "ao longo do tempo".** Caminhar rio abaixo e anotar o nível equivale a fotografar mil rios paralelos no mesmo instante. Com ergodicidade, a média temporal da nossa única série converge para a média entre universos (AU01, p. 27).

**O passeio aleatório é um barquinho sem correnteza que o traga de volta.** Cada onda, que é o choque, empurra o barquinho e o deixa onde parou. Não há força que o puxe para um ponto fixo, e a "sorte" passada fica **grudada** na posição. Com drift, o rio está inclinado: o barquinho desce, em média, $\alpha_1$ por período, mas continua sendo empurrado sem volta.

**Wold diz que toda série estacionária é uma soma de notícias passadas.** Tire de $y_t$ tudo o que o passado de $y$ permitia prever. O que sobra é a **notícia** de hoje, $\varepsilon_t$, o erro de previsão um passo à frente. Wold garante que a série inteira é uma soma ponderada das notícias de hoje e de antes, $\sum\psi_j\varepsilon_{t-j}$, mais uma parte que o passado prevê **sem erro nenhum**.

> [!WARNING]
> **Onde a analogia quebra**
> - **O rio estável pode não ser ergódico.** Suponha que, ao nascer, cada rio recebeu um nível sorteado uma única vez, e depois só oscila em torno dele: $y_t=Z+\varepsilon_t$. Cada rio é perfeitamente estacionário, mas caminhar ao longo do **seu** rio ensina o seu $Z$, nunca a média entre rios. O exemplo deste capítulo mostra os números.
> - **As "notícias" de Wold não são independentes, só não correlacionadas.** Wold é uma afirmação sobre previsão **linear**. O processo pode ter estrutura não linear, por exemplo na variância, que o $\varepsilon_t$ de Wold não captura.
> - **O barquinho sugere um objeto físico com inércia**, mas o passeio não "acelera": a variância cresce linearmente, $t\sigma^2$, e o desvio padrão só com $\sqrt t$.

## Teoria

**Processo estocástico** (AU01, p. 21–23): uma coleção $\{y_t\}$ de variáveis aleatórias indexadas pelo tempo. A série observada é **uma** realização dele.

**Estacionariedade de 2ª ordem, ou fraca** (AU01, p. 25). Para todo $t$:

$$
E(y_t)=\mu,\qquad \operatorname{Var}(y_t)=\gamma_0\lt\infty,\qquad E\big((y_t-\mu)(y_{t-k}-\mu)\big)=\gamma_k\ \text{(só depende de } k\text{)} .
$$

**Estacionariedade estrita** (AU01, p. 26): a distribuição conjunta de $(y_{t_1},\dots,y_{t_k})$ não muda com um deslocamento $h$ das datas.
- Estrita com variância finita implica fraca.
- A volta só vale sob normalidade.

**Ergodicidade** (AU01, p. 27): $\bar y=\frac1T\sum y_t\to\mu$ (na média) e a autocovariância amostral converge para $\gamma_k$ (no 2º momento).

**Ruído branco** (AU01, p. 31): $E(\varepsilon_t)=0$, $\operatorname{Var}(\varepsilon_t)=\sigma^2$, $E(\varepsilon_t\varepsilon_{t-k})=0$ para $k\ne0$.

**Passeio aleatório e variações** (AU01, p. 28–30). Com valor inicial fixo $y_0$:

| Modelo | $E(Y_t)$ | $\operatorname{Var}(Y_t)$ | $\operatorname{Cov}(Y_t,Y_{t-k})$ |
|---|---|---|---|
| $Y_t=Y_{t-1}+\varepsilon_t$ | $y_0$ | $t\sigma^2$ | $(t-k)\sigma^2$ |
| $Y_t=\alpha_1+Y_{t-1}+\varepsilon_t$ (drift) | $y_0+\alpha_1t$ | $t\sigma^2$ | $(t-k)\sigma^2$ |
| $Y_t=\alpha_1+Y_{t-1}+\alpha_2t+\varepsilon_t$ | $y_0+\alpha_1t+\alpha_2\frac{t(t+1)}{2}$ | $t\sigma^2$ | $(t-k)\sigma^2$ |

Os três **não são estacionários**: a variância cresce com $t$. Os dois últimos têm também a média dependendo de $t$, uma **tendência determinística**, linear ou quadrática, somada à **tendência estocástica** $\sum\varepsilon_s$.

**FAC** (AU01, p. 35): sob estacionariedade, $\rho_k=\gamma_k/\gamma_0$, com $\gamma_k=\gamma_{-k}$.

**Combinação de processos** (lista, Q3). Se $x_t$ e $w_t$ são estacionários e não correlacionados em todas as defasagens, então $z_t=ax_t+bw_t$ é estacionário e $\gamma_z(k)=a^2\gamma_x(k)+b^2\gamma_w(k)$.

**Processo linear geral** (AU02, p. 15–18):

$$
y_t=\mu+\sum_{j\ge0}\psi_j\varepsilon_{t-j},\quad \psi_0=1,\quad \sum_{j\ge0}\psi_j^2\lt\infty\ \Longrightarrow\ \gamma_k=\sigma^2\sum_{j\ge0}\psi_j\psi_{j+k}.
$$

**Teorema de Wold** (HAMILTON, cap. 4; lista, Q4). Todo processo estacionário de 2ª ordem, com média zero, escreve-se como

$$
y_t=\sum_{j\ge0}\psi_j\varepsilon_{t-j}+\kappa_t,\qquad \psi_0=1,\ \ \sum_{j\ge0}\psi_j^2\lt\infty,
$$

em que:
- $\varepsilon_t=y_t-\widehat E(y_t\mid y_{t-1},y_{t-2},\dots)$ é o erro da **melhor previsão linear** um passo à frente, e por isso é ruído branco;
- $\kappa_t$ é o componente **determinístico**, previsto sem erro pelo passado de $y$, como uma senoide de amplitude sorteada uma vez;
- $\kappa_t$ não se correlaciona com nenhum $\varepsilon_s$.

O processo é **puramente não determinístico** quando $\kappa_t=0$. É o caso dos ARMA estacionários, e a lista supõe isso.

## Demonstrações

O formato é o da [folha à mão](../lista_comentada/a_mao_q02_q06.md). A Q2 (drift e tendência) está demonstrada lá por inteiro, inclusive a esperança do somatório.

### D1.1 · Passeio com drift: os momentos dependem de $t$ (Q1)

Modelo: $y_t=c+y_{t-1}+u_t$, com $y_0$ fixo e $u_t\sim RB(0,\sigma^2)$ (AU01, p. 29).

$$
\begin{aligned}
\text{(1)}\quad & y_t-y_{t-1}=c+u_t && [\text{modelo}]\\
\text{(2)}\quad & \sum_{s=1}^{t}(y_s-y_{s-1})=y_t-y_0 && [\text{telescópica}]\\
\text{(3)}\quad & y_t=y_0+ct+\sum_{s=1}^{t}u_s && [(1),(2)]\\
\text{(4)}\quad & E(y_t)=y_0+ct+\sum_{s=1}^{t}E(u_s)=y_0+ct && [\text{F4, soma finita; RB}]\\
\text{(5)}\quad & \operatorname{Var}(y_t)=E\Big(\Big(\sum_{s=1}^{t}u_s\Big)^2\Big)=\sum_{s=1}^{t}E(u_s^2)=t\sigma^2 && [\text{RB: só } i=j]\\
\text{(6)}\quad & \operatorname{Cov}(y_t,y_{t-k})=E\Big(\sum_{i=1}^{t}u_i\sum_{j=1}^{t-k}u_j\Big)=\sum_{j=1}^{t-k}E(u_j^2)=(t-k)\sigma^2 && [\text{RB}]\\
\text{(7)}\quad & \operatorname{Corr}(y_t,y_{t-k})=\frac{(t-k)\sigma^2}{\sqrt{t\sigma^2(t-k)\sigma^2}}=\sqrt{\frac{t-k}{t}} && [(5),(6)]
\end{aligned}
$$

$$
\boxed{E(y_t)=y_0+ct,\qquad \operatorname{Var}(y_t)=t\sigma^2,\qquad \operatorname{Cov}(y_t,y_{t-k})=(t-k)\sigma^2\ \Longrightarrow\ \text{não estacionário}}
$$

Em (7), para $k$ fixo e $t$ grande, a correlação vai a 1: **a FAC de um passeio decai devagar, quase linearmente**. É a assinatura visual da raiz unitária, retomada no cap. 3.

### D1.2 · Soma de processos não correlacionados (Q3)

$z_t=x_t+b\,w_t$, com $x$ e $w$ estacionários, médias $\mu_x$ e $\mu_w$, e $\operatorname{Cov}(x_t,w_s)=0$ para todos $t,s$.

$$
\begin{aligned}
\text{(1)}\quad & E(z_t)=\mu_x+b\,\mu_w && [\text{F4: constante}]\\
\text{(2)}\quad & z_t-E(z_t)=(x_t-\mu_x)+b\,(w_t-\mu_w) && [(1)]\\
\text{(3)}\quad & \gamma_z(k)=E\Big(\big((x_t-\mu_x)+b(w_t-\mu_w)\big)\big((x_{t-k}-\mu_x)+b(w_{t-k}-\mu_w)\big)\Big) && [(2)]\\
\text{(4)}\quad & \phantom{\gamma_z(k)}=\gamma_x(k)+b\operatorname{Cov}(x_t,w_{t-k})+b\operatorname{Cov}(w_t,x_{t-k})+b^2\gamma_w(k) && [\text{F4: quatro produtos}]\\
\text{(5)}\quad & \phantom{\gamma_z(k)}=\gamma_x(k)+0+0+b^2\gamma_w(k) && [\text{não correlacionados}]\\
\text{(6)}\quad & \text{com } b=2:\ \gamma_{z_3}(k)=\gamma_{z_1}(k)+4\,\gamma_{z_2}(k) && [\text{Q3}]
\end{aligned}
$$

$$
\boxed{\gamma_z(k)=\gamma_x(k)+b^2\gamma_w(k):\ \text{a constante sai ao quadrado; a FAC de } z \text{ corta onde corta a mais longa}}
$$

Como $\gamma_{z_1}$ corta depois de 1 e $\gamma_{z_2}$ depois de 2, $\gamma_{z_3}$ corta depois de 2. Um processo cuja FAC zera a partir de 3 é um **MA(2)**.

### D1.3 · Processo linear: $\gamma_k=\sigma^2\sum\psi_j\psi_{j+k}$

Com $y_t-\mu=\sum_{i\ge0}\psi_i\varepsilon_{t-i}$ (AU02, p. 18):

$$
\begin{aligned}
\text{(1)}\quad & \gamma_k=E\Big(\sum_{i\ge0}\psi_i\varepsilon_{t-i}\sum_{l\ge0}\psi_l\varepsilon_{t-k-l}\Big) && [\text{definição}]\\
\text{(2)}\quad & \phantom{\gamma_k}=\sum_{i\ge0}\sum_{l\ge0}\psi_i\psi_l\,E(\varepsilon_{t-i}\varepsilon_{t-k-l}) && [\text{F4; troca vale com } \textstyle\sum\psi^2\lt\infty]\\
\text{(3)}\quad & E(\varepsilon_{t-i}\varepsilon_{t-k-l})=\sigma^2 \text{ se } i=k+l,\ \text{e } 0 \text{ se não} && [\text{RB}]\\
\text{(4)}\quad & \gamma_k=\sigma^2\sum_{l\ge0}\psi_{k+l}\,\psi_l && [\text{só } i=k+l]\\
\text{(5)}\quad & \gamma_0=\sigma^2\sum_{l\ge0}\psi_l^2 && [k=0]\\
\text{(6)}\quad & \text{MA(2) com } \psi=(1;\,0{,}7;\,0{,}6):\ \gamma_1=\sigma^2(1\cdot0{,}7+0{,}7\cdot0{,}6)=1{,}12\,\sigma^2 && [(4)]
\end{aligned}
$$

$$
\boxed{\gamma_k=\sigma^2\sum_{j\ge0}\psi_j\psi_{j+k}}
$$

A condição $\sum\psi_j^2\lt\infty$ é exatamente o que faz (5) ser finito: é a "somabilidade" da AU02, p. 17.

### D1.4 · Wold do AR(1): os $\psi_j$ explícitos (Q4b)

$y_t=\phi y_{t-1}+\varepsilon_t$, com $\lvert\phi\rvert\lt1$ (AU02, p. 21 e 25).

$$
\begin{aligned}
\text{(1)}\quad & y_t=\phi(\phi y_{t-2}+\varepsilon_{t-1})+\varepsilon_t=\phi^2y_{t-2}+\phi\varepsilon_{t-1}+\varepsilon_t && [\text{modelo em } t-1]\\
\text{(2)}\quad & y_t=\phi^ny_{t-n}+\sum_{j=0}^{n-1}\phi^j\varepsilon_{t-j} && [n \text{ substituições}]\\
\text{(3)}\quad & E\Big(\Big(y_t-\sum_{j=0}^{n-1}\phi^j\varepsilon_{t-j}\Big)^2\Big)=\phi^{2n}E(y_{t-n}^2)=\phi^{2n}\gamma_0 && [(2),\ \text{estac.}]\\
\text{(4)}\quad & \phi^{2n}\gamma_0\to0 \text{ quando } n\to\infty && [\lvert\phi\rvert\lt1]\\
\text{(5)}\quad & y_t=\sum_{j\ge0}\phi^j\varepsilon_{t-j} && [\text{limite em média quadrática}]\\
\text{(6)}\quad & \sum_{j\ge0}\psi_j^2=\sum_{j\ge0}\phi^{2j}=\frac{1}{1-\phi^2}\lt\infty && [\text{F2: geométrica, razão } \phi^2]
\end{aligned}
$$

$$
\boxed{\psi_j=\phi^j,\quad \psi_0=1,\quad \sum\psi_j^2=\frac{1}{1-\phi^2}\lt\infty:\ \text{o AR(1) é um Wold com } \kappa_t=0}
$$

Os $\varepsilon_t$ são mesmo as inovações de Wold: como $y_{t-1},y_{t-2},\dots$ só contêm choques até $t-1$, a melhor previsão linear de $y_t$ é $\phi y_{t-1}$, e o erro é $\varepsilon_t$. A parte determinística é nula, porque nada em $y_t$ é previsível sem erro.

### D1.5 · Estacionário, mas não ergódico

$y_t=Z+\varepsilon_t$, com $Z\sim(0,\sigma_Z^2)$ sorteado **uma vez**, independente de $\{\varepsilon_t\}$.

$$
\begin{aligned}
\text{(1)}\quad & E(y_t)=E(Z)+E(\varepsilon_t)=0 && [\text{F4}]\\
\text{(2)}\quad & \gamma_0=E\big((Z+\varepsilon_t)^2\big)=\sigma_Z^2+2E(Z\varepsilon_t)+\sigma^2=\sigma_Z^2+\sigma^2 && [\text{independência}]\\
\text{(3)}\quad & \gamma_k=E\big((Z+\varepsilon_t)(Z+\varepsilon_{t-k})\big)=\sigma_Z^2,\quad k\ge1 && [\text{RB, independência}]\\
\text{(4)}\quad & \text{(1)–(3) não dependem de } t\ \Longrightarrow\ \text{estacionário} && [\text{AU01, p. 25}]\\
\text{(5)}\quad & \bar y=\frac1T\sum_{t=1}^{T}(Z+\varepsilon_t)=Z+\frac1T\sum_{t=1}^{T}\varepsilon_t && [\text{numa trajetória}]\\
\text{(6)}\quad & \bar y\to Z\ne0=\mu && [\text{lei dos grandes números em } \varepsilon]
\end{aligned}
$$

$$
\boxed{\text{estacionário, mas } \bar y\to Z\text{, não } \mu:\ \text{não é ergódico na média}}
$$

A pista está em (3): $\gamma_k=\sigma_Z^2$ **não vai a zero**. Uma condição suficiente para a ergodicidade na média é $\gamma_k\to0$, ou, mais precisamente, $\sum\lvert\gamma_k\rvert\lt\infty$. Os ARMA estacionários a cumprem.

## Exemplo

**Três experimentos numéricos**, todos do R.

**1. O passeio da Q1**, com $y_0=10$, $c=0{,}5$ e $\sigma^2=1$, em $t=20$ e $k=5$:

| Momento | Fórmula (D1.1) | 40 mil trajetórias simuladas |
|---|---|---|
| $E(y_{20})$ | $10+0{,}5\cdot20=20$ | 20,01 |
| $\operatorname{Var}(y_{20})$ | $20\sigma^2=20$ | 19,98 |
| $\operatorname{Cov}(y_{20},y_{15})$ | $15\sigma^2=15$ | 14,99 |
| $\operatorname{Corr}(y_{20},y_{15})$ | $\sqrt{15/20}=0{,}866$ | |

**2. A soma da Q3.** Com $\gamma_{z_1}=(0{,}5;\ 0{,}2;\ 0)$ e $\gamma_{z_2}=(2{,}30;\ -1{,}43;\ 0{,}30;\ 0)$, a D1.2 dá:
- $\gamma_0=0{,}5+4(2{,}30)=9{,}7$;
- $\gamma_1=0{,}2+4(-1{,}43)=-5{,}52$;
- $\gamma_2=0+4(0{,}30)=1{,}2$;
- $\gamma_3=0$.

Daí $\rho_1=-0{,}5691$ e $\rho_2=0{,}1237$: a FAC corta depois de 2, então $z_3$ é **MA(2)**.

**3. Wold e o processo linear.**
- AR(1) com $\phi=0{,}5$: os pesos são $\psi_1=0{,}5$, …, $\psi_4=0{,}0625$, e $\sum\psi_j^2=1/(1-0{,}25)=1{,}3333$. A soma de 200 termos no R dá o mesmo valor.
- MA(2) com $\psi=(1;\ 0{,}7;\ 0{,}6)$: a D1.3 dá $\gamma_1=1{,}12\,\sigma^2$, $\gamma_2=0{,}6\,\sigma^2$ e $\rho_1=0{,}6054$, igual ao `ARMAacf`.

**4. O rio sorteado da D1.5.** Três trajetórias de $y_t=Z+\varepsilon_t$, cada uma com 5 000 períodos:

| Trajetória | $Z$ sorteado | média temporal $\bar y$ |
|---|---|---|
| 1 | 2,287 | 2,290 |
| 2 | −1,197 | −1,197 |
| 3 | −0,694 | −0,668 |

Cada média temporal acerta o **seu** $Z$, não o $\mu=0$ do processo. Já a média **entre** 20 mil trajetórias numa data fixa dá $-0{,}007$, perto de zero. É a diferença entre "ao longo do tempo" e "entre universos".

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_c1_rw_media | 20 |
| ap_c1_rw_var | 20 |
| ap_c1_rw_cov | 15 |
| ap_c1_rw_corr | 0,866 |
| ap_c1_rw_media_sim | 20,01 |
| ap_c1_rw_var_sim | 19,98 |
| ap_c1_rw_cov_sim | 14,99 |
| ap_c1_z3_g0 | 9,7 |
| ap_c1_z3_g1 | -5,52 |
| ap_c1_z3_g2 | 1,2 |
| ap_c1_z3_g3 | 0 |
| ap_c1_z3_rho1 | -0,5691 |
| ap_c1_z3_rho2 | 0,1237 |
| ap_c1_pl_g1 | 1,12 |
| ap_c1_pl_g2 | 0,6 |
| ap_c1_pl_rho1 | 0,6054 |
| ap_c1_pl_rho1_r | 0,6054 |
| ap_c1_wold_psi1 | 0,5 |
| ap_c1_wold_psi4 | 0,0625 |
| ap_c1_wold_soma2 | 1,3333 |
| ap_c1_wold_soma2_r | 1,3333 |
| ap_c1_erg_z1 | 2,287 |
| ap_c1_erg_m1 | 2,290 |
| ap_c1_erg_z2 | -1,197 |
| ap_c1_erg_m2 | -1,197 |
| ap_c1_erg_z3 | -0,694 |
| ap_c1_erg_m3 | -0,668 |
| ap_c1_erg_ensemble | -0,007 |
-->

## Cadeia socrática

**P1.** O ruído branco é estacionário? E é ergódico?

> [!TIP]
> **Resposta**
> Sim aos dois. Média 0, variância $\sigma^2$ e $\gamma_k=0$ para $k\ne0$: nada depende de $t$. E, como $\gamma_k$ é zero fora da origem, a média temporal converge para 0 (AU01, p. 31).

**P2.** Se uma série tem média constante, ela é estacionária?

> [!TIP]
> **Resposta**
> Não necessariamente. O passeio sem drift tem $E(Y_t)=y_0$, constante, mas $\operatorname{Var}(Y_t)=t\sigma^2$ cresce. Estacionariedade de 2ª ordem exige as **três** condições (AU01, p. 25 e 28).

**P3.** Por que, no passeio, $\operatorname{Cov}(Y_t,Y_{t-k})$ depende de $t$, e não só de $k$?

> [!TIP]
> **Resposta**
> Porque a covariância conta os choques que as duas datas têm em comum, que são $t-k$. Duas datas com a mesma distância $k$, mas mais tarde na amostra, compartilham mais choques. No rio estável, isso não acontece: só a distância importa.

**P4.** Um ciclo forte e irregular, como a população de linces que sobe e desce a cada ~10 anos, é estacionário?

> [!TIP]
> **Resposta**
> Pode ser. Um ciclo **aperiódico**, sem data fixa para os picos, é compatível com momentos constantes: um AR(2) com raízes complexas faz isso (cap. 2, D2.5). Não estacionário é o que tem tendência na média ou variância que cresce, não o que oscila.

**P5.** O que é exatamente o $\varepsilon_t$ do Teorema de Wold?

> [!TIP]
> **Resposta**
> O erro da melhor previsão **linear** de $y_t$ feita com $y_{t-1},y_{t-2},\dots$, a "notícia" de hoje. Por construção, ele não se correlaciona com nada do passado, inclusive com os $\varepsilon$ anteriores, e por isso é RB.

**P6.** Wold diz que todo processo estacionário **é** um MA($\infty$). Então para que servem o AR e o ARMA?

> [!TIP]
> **Resposta**
> Para resumir com poucos parâmetros. Um MA($\infty$) tem infinitos $\psi_j$. O AR(1) os gera todos com um único número, $\psi_j=\phi^j$, e o ARMA($p,q$) com $p+q$. Wold justifica a classe; o ARMA a torna estimável (AU02, p. 43).

**P7.** Por que a Q4(c) diz que, sem invertibilidade, não há AR($\infty$) convergente?

> [!TIP]
> **Resposta**
> Porque os pesos da forma AR($\infty$) de um MA(1) são $\pi_j=-(-\theta_1)^j$. Com $\lvert\theta_1\rvert\ge1$, eles não diminuem, e a soma $\sum\pi_jy_{t-j}$ não converge (cap. 2, D2.2).

**P8.** Um processo pode ser estritamente estacionário e **não** fracamente estacionário?

> [!TIP]
> **Resposta**
> Sim, se a variância for infinita. Uma sequência i.i.d. de Cauchy tem a mesma distribuição em todas as datas, o que a torna estritamente estacionária, mas não tem média nem variância. A estacionariedade estrita só implica a fraca quando os momentos existem (AU01, p. 26).

## Diálogo

*Sobre o erro de achar que "estacionário" quer dizer "sem tendência visível".*

**Aluno:** O passeio sem drift não tem tendência, $E(Y_t)=y_0$. Então ele é estacionário.

**Professor:** O que a definição da AU01, p. 25, pede?

**Aluno:** Média constante, variância constante e covariância dependendo só da distância.

**Professor:** E a variância do passeio?

**Aluno:** $t\sigma^2$… Cresce com o tempo. Então não é estacionário. Mas no gráfico ele não "sobe".

**Professor:** Simule mil trajetórias e sobreponha. O que acontece com o leque?

**Aluno:** Ele abre: em $t=100$, as trajetórias estão muito mais espalhadas que em $t=10$. Cada trajetória sozinha não sobe, mas o conjunto se espalha.

**Professor:** Então "tendência" não é a única forma de não estacionariedade. E a recíproca: uma série que oscila muito, em ciclos largos, é necessariamente não estacionária?

**Aluno:** Pelo exemplo dos linces, não. Se os ciclos não têm data marcada e a amplitude não cresce, os momentos podem ser constantes.

**Professor:** Qual é a regra, então?

**Aluno:** Não julgar pelo "formato" do gráfico. Calcular os três momentos e ver se algum depende de $t$. No passeio, quem denuncia é a variância.

## Na prova

| Questão | O que este capítulo dá | Resolução completa |
|---|---|---|
| Q1 | momentos do passeio com drift e $y_0=10$; não estacionário | [Q1](../lista_comentada/q01.md) |
| Q2 | drift e tendência: solução, momentos, natureza da tendência | [Q2](../lista_comentada/q02.md) e a [folha à mão](../lista_comentada/a_mao_q02_q06.md) |
| Q3 | autocovariância de $z_1+2z_2$, estacionariedade e classe MA(2) | [Q3](../lista_comentada/q03.md) |
| Q4 | enunciado de Wold, componente determinístico, AR(1) e invertibilidade | [Q4](../lista_comentada/q04.md) |

**Armadilhas:**
- na Q1, esquecer o $y_0=10$ na média;
- na Q3, usar $2\gamma_{z_2}$ em vez de $4\gamma_{z_2}$: a constante sai **ao quadrado**;
- confundir "não depende de $t$" com "não depende de $k$";
- dizer que o componente determinístico de Wold é uma "tendência linear". Ele é o que o passado prevê sem erro, e uma tendência faria a média depender de $t$;
- no caderno, $y_2$ do AR(1) recursivo saiu sem o $y_0$ (ver [Q4](../lista_comentada/q04.md)).

**Checklist de 30 segundos:**
1. Testei as **três** condições de estacionariedade, não só a média?
2. Usei $y_0$ do enunciado?
3. Cada esperança com a justificativa: [F4], [RB]?
4. Na soma de processos, constantes ao quadrado e produtos cruzados zerados **com** o motivo?
5. Fechei com a frase pedida ("logo, não é estacionário")?

## No material do professor

**Roteiro de releitura:**
- AU01, p. 21–23: processo estocástico × série observada;
- AU01, p. 24–27: estacionariedade fraca e estrita, ergodicidade;
- AU01, p. 28–31: passeio, drift, drift e tendência, ruído branco;
- AU01, p. 32–35: AR, MA e as definições de FAC;
- AU02, p. 15–23: processo linear geral e os pesos $\psi$ e $\pi$;
- MAT, §1: tendência determinística × estocástica, que liga com o cap. 3.

**Livros:**
- **HAMILTON**, cap. 3 (estacionariedade, ergodicidade, processo linear) e cap. 4.8 (Teorema de Wold);
- **ENDERS**, cap. 2: estacionariedade e FAC no nível do curso;
- **BJRL**, cap. 2: autocovariância e FAC.

**Na lista comentada:** [Q1](../lista_comentada/q01.md) · [Q2](../lista_comentada/q02.md) · [Q3](../lista_comentada/q03.md) · [Q4](../lista_comentada/q04.md) · ferramentas [F2, F3, F4 e F5](../lista_comentada/README.md#2-caixa-de-ferramentas).
