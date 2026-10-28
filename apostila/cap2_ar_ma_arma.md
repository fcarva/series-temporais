---
title: "Apostila, cap. 2 — AR, MA e ARMA: memória, eco e reconstrução"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: [5, 6, 7, 8]
aulas: "AU02 p. 11–99; EQD"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Apostila cap. 2 — AR, MA e ARMA
---

# Capítulo 2 · AR, MA e ARMA: memória, eco e reconstrução

[← apostila](README.md) · anterior: [cap. 1](cap1_processos_momentos.md) · próximo: [cap. 3](cap3_integrados_sarima.md) · questões da lista: Q5 a Q8

## Pergunta de abertura

O Banco Central sobe os juros hoje, e a inflação reage. **Daqui a dois anos, esse choque ainda está na inflação, ou já se dissolveu?** E a pergunta inversa: nós só vemos a série da inflação, nunca os choques. **Olhando só para a série, dá para descobrir quais choques a produziram?**

O próprio professor abre o tema com essas duas perguntas (AU02, p. 24):
- a primeira é a **estacionariedade**, uma propriedade do lado AR;
- a segunda é a **invertibilidade**, uma propriedade do lado MA.

O capítulo inteiro é a resposta a elas. Guarde as duas: toda condição técnica que aparecer abaixo, "raízes fora do círculo unitário" por exemplo, é só uma forma precisa de responder "sim" a uma delas.

## A imagem

**O MA é um eco numa sala.** Você grita uma vez, que é o choque $\varepsilon_t$. A sala devolve o grito $q$ vezes, cada vez com um volume $\theta_j$, e depois fica em silêncio absoluto. Por isso a FAC de um MA($q$) **corta** depois da defasagem $q$: quem está a mais de $q$ períodos de distância não divide nenhum grito com você.

**O AR é uma mola com atrito.** Puxe a mola, que é o choque, e solte. A cada período, sobra uma fração $\phi_1$ do desvio da posição de equilíbrio:
- com $\phi_1=0{,}5$, metade do desvio sobrevive a cada passo e a mola volta rápido;
- com $\phi_1=0{,}99$, ela quase não perde força;
- com $\phi_1=1$, **a mola quebrou**: o desvio nunca diminui, e você tem um passeio aleatório.

A FAC **decai** geometricamente, mas nunca chega a zero, porque o choque de hoje carrega um pouco de todos os anteriores.

**O AR(2) com raízes complexas é um balanço empurrado.** O balanço vai e volta, com amplitude cada vez menor. O período de ida e volta sai das raízes do polinômio, e o "atrito" é o módulo delas.

**A invertibilidade é reconstruir as notas ouvindo a gravação.** A gravação, $y_t$, mistura cada nota, $\varepsilon_t$, com o eco da nota anterior. Para recuperar a nota de hoje, desconte o eco, mas o eco depende da nota de ontem, que você também precisa recuperar, e assim por diante. Com $\lvert\theta_1\rvert\lt1$, cada correção pesa menos que a anterior e o processo converge. Com $\lvert\theta_1\rvert\gt1$, as gravações antigas pesam **mais** que as recentes, e a reconstrução explode.

**O fator comum é uma fração que se simplifica.** Em $\frac{6}{9}$, o 3 de cima cancela com o 3 de baixo e sobra $\frac{2}{3}$. Em $(1-0{,}5L)\,y_t=(1-0{,}5L)\,\varepsilon_t$, o mesmo fator cancela e sobra $y_t=\varepsilon_t$: o "ARMA(1,1)" era ruído branco disfarçado.

> [!WARNING]
> **Onde a analogia quebra**
> - O eco real decai suavemente. O "eco" do MA pode ser **mais alto na segunda volta que na primeira** ($\theta_2\gt\theta_1$) e para **exatamente** em $q$, sem cauda nenhuma.
> - A mola real com atrito nunca troca de lado a cada período. Um AR(1) com $\phi_1\lt0$ troca: o desvio muda de sinal a cada passo, e a FAC alterna $+,-,+,-$.
> - Na música, um MA não invertível ainda é um processo **legítimo e estacionário**. Ele tem exatamente a mesma FAC que o seu par invertível (AU02, p. 34). A invertibilidade não é uma lei física: é uma **escolha de representação**, a única em que os choques podem ser lidos a partir do passado observado.

## Teoria

Toda a notação é a dos slides. A **tradução para a lista** está na última tabela desta seção.

**Operador de defasagem** (AU02, p. 11–14). $L^jy_t=y_{t-j}$. Os modelos viram polinômios em $L$:

$$
\phi(L)=1-\phi_1L-\cdots-\phi_pL^p,\qquad \theta(L)=1+\theta_1L+\cdots+\theta_qL^q,\qquad \phi(L)\,y_t=c+\theta(L)\,\varepsilon_t .
$$

**Processo linear geral** (AU02, p. 15–20). $y_t=\mu+\Psi(L)\varepsilon_t=\mu+\sum_{j\ge0}\psi_j\varepsilon_{t-j}$, com $\psi_0=1$.
- Se $\sum\psi_j^2\lt\infty$, as autocovariâncias existem e valem $\gamma_k=\sigma^2\sum_{j\ge0}\psi_j\psi_{j+k}$ (AU02, p. 18).
- A forma AR($\infty$) é $\pi(L)\tilde y_t=\varepsilon_t$, com $\pi(L)=1-\pi_1L-\pi_2L^2-\cdots=\Psi(L)^{-1}$ (AU02, p. 19–20).

**MA($q$)** (AU02, p. 29 e 49–52). A soma é finita, então **todo MA($q$) é estacionário**, para quaisquer $\theta$. Com $\theta_0=1$:

$$
\gamma_k=\begin{cases}\sigma^2\sum_{j=0}^{q-k}\theta_j\theta_{j+k}, & k=0,1,\dots,q,\\[2pt] 0, & k\gt q,\end{cases}
$$

e a FAC **trunca** depois de $q$. No MA(1), $\lvert\rho_1\rvert\le\frac12$ (AU02, p. 35).

**Invertibilidade** (AU02, p. 22–23 e 30–36). O MA é invertível quando as raízes de $\theta(z)=1+\theta_1z+\cdots+\theta_qz^q=0$ estão **fora** do círculo unitário. No MA(1), isso é $\lvert\theta_1\rvert\lt1$, e os pesos são $\pi_j=-(-\theta_1)^j$. Os parâmetros $\theta$ e $1/\theta$ geram a mesma FAC (AU02, p. 34). A invertibilidade escolhe, entre os dois, aquele em que $\varepsilon_t$ é recuperável. No MA($q$), a condição também pode ser checada pelos autovalores de uma matriz companheira com $-\theta_1,\dots,-\theta_q$ na primeira linha, como a matriz $F$ do AR (AU02, p. 42).

**AR($p$)** (AU02, p. 25–28 e 37–41). O AR é estacionário quando as raízes de $\phi(z)=1-\phi_1z-\cdots-\phi_pz^p=0$ estão fora do círculo unitário, ou seja, quando $\lvert z_i\rvert\gt1$. Há duas formas equivalentes de escrever a mesma condição (AU02, p. 28):
- as raízes $\lambda_i=1/z_i$ de $\lambda^p-\phi_1\lambda^{p-1}-\cdots-\phi_p=0$ estão **dentro** do círculo, $\lvert\lambda_i\rvert\lt1$;
- os autovalores da matriz $F$ são menores que 1 em módulo.

No AR(2), a condição vira o **triângulo** (AU02, p. 41): $\phi_1+\phi_2\lt1$, $\phi_2-\phi_1\lt1$ e $\lvert\phi_2\rvert\lt1$.

**Yule-Walker e FACP** (AU02, p. 68–70 e 90–95).
- A FAC do AR($p$) obedece $\rho_k=\phi_1\rho_{k-1}+\cdots+\phi_p\rho_{k-p}$ para $k\ge1$.
- A FACP, $\phi_{kk}$, é o último coeficiente de um AR($k$) ajustado. Ela **corta** depois de $p$ no AR($p$) e **decai** no MA, porque um MA invertível é um AR($\infty$).

**ARMA($p,q$)** (AU02, p. 43 e 81–87).
- $\Psi(L)=\theta(L)/\phi(L)$.
- Para $k\ge q+1$, a FAC segue a recursão do AR. As $q$ primeiras são "contaminadas" pelo MA.
- Se $\phi(L)$ e $\theta(L)$ têm uma raiz em comum, ela cancela: é o **fator comum**, e o modelo está superparametrizado.

| | FAC | FACP |
|---|---|---|
| AR($p$) | decai (geométrica ou senoidal amortecida) | **corta** depois de $p$ |
| MA($q$) | **corta** depois de $q$ | decai |
| ARMA($p,q$) | decai a partir de $q$ | decai a partir de $p$ |

**Da lista para os slides.** A lista usa $B$ e o sinal de Box-Jenkins, exceto na Q8. Se o modelo for ARMA, troque $\theta^{\text{lista}}$ por $-\theta_1$ antes de usar qualquer fórmula desta seção.

| | Slides | Lista (Q5–Q7) |
|---|---|---|
| defasagem | $L$ | $B$ |
| MA(1) | $y_t=\varepsilon_t+\theta_1\varepsilon_{t-1}$ | $\tilde z_t=a_t-\theta a_{t-1}$, logo $\theta_1=-\theta$ |
| ARMA(1,1), $\psi_j$ | $(\phi_1+\theta_1)\phi_1^{j-1}$ | $(\phi-\theta)\phi^{j-1}$ |
| MA(1), $\rho_1$ | $\frac{\theta_1}{1+\theta_1^2}$ | $\frac{-\theta}{1+\theta^2}$ |

## Demonstrações

O formato é o da [folha à mão](../lista_comentada/a_mao_q02_q06.md): uma operação por linha e o motivo entre colchetes.
- [RB]: ruído branco;
- [F4]: linearidade da esperança;
- [estac.]: estacionariedade;
- [caus.]: o choque de hoje não se correlaciona com o passado de $y$.

O ARMA(1,1) completo, com $\gamma_0$ de nove termos, já está demonstrado na folha à mão e não se repete aqui.

### D2.1 · MA(1): momentos e a FAC que corta em 1

Modelo: $y_t=c+\varepsilon_t+\theta_1\varepsilon_{t-1}$ (AU02, p. 45–47).

$$
\begin{aligned}
\text{(1)}\quad & E(y_t)=E(c)+E(\varepsilon_t)+\theta_1E(\varepsilon_{t-1}) && [\text{F4}]\\
\text{(2)}\quad & \phantom{E(y_t)}=c+0+0\equiv\mu && [\text{RB}]\\
\text{(3)}\quad & y_t-\mu=\varepsilon_t+\theta_1\varepsilon_{t-1} && [(2)]\\
\text{(4)}\quad & \gamma_0=E\big((\varepsilon_t+\theta_1\varepsilon_{t-1})^2\big)=E(\varepsilon_t^2)+2\theta_1E(\varepsilon_t\varepsilon_{t-1})+\theta_1^2E(\varepsilon_{t-1}^2) && [(3),\ \text{F4}]\\
\text{(5)}\quad & \phantom{\gamma_0}=\sigma^2+0+\theta_1^2\sigma^2=(1+\theta_1^2)\,\sigma^2 && [\text{RB}]\\
\text{(6)}\quad & \gamma_1=E\big((\varepsilon_t+\theta_1\varepsilon_{t-1})(\varepsilon_{t-1}+\theta_1\varepsilon_{t-2})\big) && [(3)\text{ em } t \text{ e } t-1]\\
\text{(7)}\quad & \phantom{\gamma_1}=E(\varepsilon_t\varepsilon_{t-1})+\theta_1E(\varepsilon_t\varepsilon_{t-2})+\theta_1E(\varepsilon_{t-1}^2)+\theta_1^2E(\varepsilon_{t-1}\varepsilon_{t-2}) && [\text{F4}]\\
\text{(8)}\quad & \phantom{\gamma_1}=0+0+\theta_1\sigma^2+0=\theta_1\sigma^2 && [\text{RB}]\\
\text{(9)}\quad & \gamma_k=E\big((\varepsilon_t+\theta_1\varepsilon_{t-1})(\varepsilon_{t-k}+\theta_1\varepsilon_{t-k-1})\big),\quad k\ge2 && [(3)]\\
\text{(10)}\quad & \phantom{\gamma_k}=0 && [\text{RB: datas } t,\,t-1 \text{ contra } t-k,\,t-k-1]
\end{aligned}
$$

Em (10), como $k\ge2$, a data mais recente do segundo parêntese, $t-k$, é anterior à mais antiga do primeiro, $t-1$. Nenhum choque aparece nos dois: todos os produtos têm datas diferentes.

$$
\boxed{\gamma_0=(1+\theta_1^2)\sigma^2,\qquad \rho_1=\frac{\theta_1}{1+\theta_1^2},\qquad \rho_k=0\ (k\ge2)}
$$

**Conclusão:** nada depende de $t$, então o MA(1) é estacionário **para qualquer** $\theta_1$. A FAC corta em 1.

### D2.2 · MA(1) → AR($\infty$): quando os choques são recuperáveis

Em desvios, $y_t=\varepsilon_t+\theta_1\varepsilon_{t-1}$ (AU02, p. 31). Isole o choque de hoje e substitua o de ontem, repetidamente:

$$
\begin{aligned}
\text{(1)}\quad & \varepsilon_t=y_t-\theta_1\varepsilon_{t-1} && [\text{isola } \varepsilon_t]\\
\text{(2)}\quad & \varepsilon_{t-1}=y_{t-1}-\theta_1\varepsilon_{t-2} && [(1)\text{ em } t-1]\\
\text{(3)}\quad & \varepsilon_t=y_t-\theta_1y_{t-1}+\theta_1^2\varepsilon_{t-2} && [(2)\text{ em }(1)]\\
\text{(4)}\quad & \varepsilon_t=y_t-\theta_1y_{t-1}+\theta_1^2y_{t-2}-\theta_1^3\varepsilon_{t-3} && [(1)\text{ em } t-2]\\
\text{(5)}\quad & \varepsilon_t=\sum_{j=0}^{n-1}(-\theta_1)^j\,y_{t-j}+(-\theta_1)^n\varepsilon_{t-n} && [\text{após } n \text{ passos}]\\
\text{(6)}\quad & E\big(((-\theta_1)^n\varepsilon_{t-n})^2\big)=\theta_1^{2n}\sigma^2\ \xrightarrow[n\to\infty]{}\ 0\iff\lvert\theta_1\rvert\lt1 && [\text{RB}]\\
\text{(7)}\quad & y_t=\sum_{j\ge1}\pi_j\,y_{t-j}+\varepsilon_t,\qquad \pi_j=-(-\theta_1)^j && [(5),(6)]
\end{aligned}
$$

Em (7), passe a soma de (5), sem o termo $j=0$, para o outro lado: $y_t=\varepsilon_t-\sum_{j\ge1}(-\theta_1)^jy_{t-j}$. Os sinais alternam: $\pi_1=\theta_1$, $\pi_2=-\theta_1^2$, $\pi_3=\theta_1^3$ (AU02, p. 23).

$$
\boxed{\text{MA(1) invertível}\iff\lvert\theta_1\rvert\lt1\iff\text{a raiz de } 1+\theta_1z=0,\ z=-1/\theta_1,\ \text{está fora do círculo}}
$$

### D2.3 · $\theta_1$ e $1/\theta_1$ têm a mesma FAC, e $\lvert\rho_1\rvert\le\frac12$

Compare o MA(1) com $(\theta_1,\sigma^2)$ e o MA(1) com $(1/\theta_1,\ \theta_1^2\sigma^2)$ (AU02, p. 34–35).

$$
\begin{aligned}
\text{(1)}\quad & \rho_1(1/\theta_1)=\frac{1/\theta_1}{1+1/\theta_1^2} && [\text{D2.1}]\\
\text{(2)}\quad & \phantom{\rho_1(1/\theta_1)}=\frac{(1/\theta_1)\cdot\theta_1^2}{(1+1/\theta_1^2)\cdot\theta_1^2}=\frac{\theta_1}{\theta_1^2+1}=\rho_1(\theta_1) && [\text{multiplica por } \theta_1^2]\\
\text{(3)}\quad & \gamma_0:\ \big(1+1/\theta_1^2\big)\,\theta_1^2\sigma^2=(\theta_1^2+1)\,\sigma^2 && [\text{igual ao do par}]\\
\text{(4)}\quad & \gamma_1:\ (1/\theta_1)\,\theta_1^2\sigma^2=\theta_1\sigma^2 && [\text{igual ao do par}]\\
\text{(5)}\quad & \gamma_k=0 \text{ nos dois, para } k\ge2 && [\text{D2.1}]\\
\text{(6)}\quad & (1-\lvert\theta_1\rvert)^2\ge0 && [\text{quadrado}]\\
\text{(7)}\quad & 1-2\lvert\theta_1\rvert+\theta_1^2\ge0\ \Longrightarrow\ 1+\theta_1^2\ge2\lvert\theta_1\rvert && [\text{expande}]\\
\text{(8)}\quad & \lvert\rho_1\rvert=\frac{\lvert\theta_1\rvert}{1+\theta_1^2}\le\frac{\lvert\theta_1\rvert}{2\lvert\theta_1\rvert}=\frac12 && [(7)]
\end{aligned}
$$

$$
\boxed{(\theta_1,\sigma^2)\ \text{e}\ (1/\theta_1,\theta_1^2\sigma^2)\ \text{são indistinguíveis nos dados};\qquad \lvert\rho_1\rvert\le\tfrac12,\ \text{com igualdade em } \lvert\theta_1\rvert=1}
$$

**Conclusão:** nenhuma amostra, por maior que seja, separa os dois. A invertibilidade é a regra que escolhe um deles. E se a FAC amostral mostra $\widehat\rho_1=0{,}8$ e depois zero, **não** é um MA(1).

### D2.4 · AR(1): média, variância e FAC

Modelo: $y_t=c+\phi_1y_{t-1}+\varepsilon_t$, com $\lvert\phi_1\rvert\lt1$ (AU02, p. 62–64).

$$
\begin{aligned}
\text{(1)}\quad & E(y_t)=c+\phi_1E(y_{t-1})+E(\varepsilon_t) && [\text{F4}]\\
\text{(2)}\quad & \mu=c+\phi_1\mu\ \Longrightarrow\ \mu=\frac{c}{1-\phi_1} && [\text{estac., RB}]\\
\text{(3)}\quad & y_t-\mu=\phi_1(y_{t-1}-\mu)+\varepsilon_t && [c=(1-\phi_1)\mu]\\
\text{(4)}\quad & \gamma_0=\phi_1^2E\big((y_{t-1}-\mu)^2\big)+2\phi_1E\big((y_{t-1}-\mu)\varepsilon_t\big)+E(\varepsilon_t^2) && [(3)^2,\ \text{F4}]\\
\text{(5)}\quad & \gamma_0=\phi_1^2\gamma_0+0+\sigma^2 && [\text{estac., caus., RB}]\\
\text{(6)}\quad & \gamma_0=\frac{\sigma^2}{1-\phi_1^2} && [\text{isola}]\\
\text{(7)}\quad & \gamma_k=\phi_1E\big((y_{t-1}-\mu)(y_{t-k}-\mu)\big)+E\big(\varepsilon_t(y_{t-k}-\mu)\big) && [(3)\times(y_{t-k}-\mu)]\\
\text{(8)}\quad & \gamma_k=\phi_1\gamma_{k-1}+0,\quad k\ge1 && [\text{caus.}]
\end{aligned}
$$

Por indução em (8): $\gamma_1=\phi_1\gamma_0$, $\gamma_2=\phi_1\gamma_1=\phi_1^2\gamma_0$, …

$$
\boxed{\mu=\frac{c}{1-\phi_1},\qquad \gamma_0=\frac{\sigma^2}{1-\phi_1^2},\qquad \rho_k=\phi_1^{\,k}}
$$

Compare com o ARMA(1,1), em que $\rho_k=\phi_1^{k-1}\rho_1$: lá o expoente é $k-1$, porque a recursão só começa em $k=2$.

### D2.5 · AR(2): raízes por Bhaskara, ciclo e Yule-Walker

Modelo: $y_t=\phi_1y_{t-1}+\phi_2y_{t-2}+\varepsilon_t$ (AU02, p. 27 e 68; EQD). O exemplo é o do caderno de 03/09, $\phi_1=1{,}5$ e $\phi_2=-0{,}6$.

**Raízes.** $\phi(z)=1-\phi_1z-\phi_2z^2=0$. Na ordem de Bhaskara, $az^2+bz+c=0$ com $a=-\phi_2$, $b=-\phi_1$ e $c=1$.

$$
\begin{aligned}
\text{(1)}\quad & \Delta=b^2-4ac=\phi_1^2+4\phi_2 && [a=-\phi_2,\ b=-\phi_1,\ c=1]\\
\text{(2)}\quad & \Delta=(1{,}5)^2+4(-0{,}6)=2{,}25-2{,}4=-0{,}15\lt0 && [\text{raízes complexas}]\\
\text{(3)}\quad & z=\frac{-b\pm\sqrt{\Delta}}{2a}=\frac{1{,}5\pm i\sqrt{0{,}15}}{1{,}2}=1{,}25\pm0{,}3227\,i && [\text{Bhaskara}]\\
\text{(4)}\quad & \lvert z\rvert^2=1{,}25^2+0{,}3227^2=1{,}6667=\frac{c}{a}=\frac{1}{0{,}6} && [\text{produto das conjugadas}]\\
\text{(5)}\quad & \lvert z\rvert=1{,}2910\gt1\ \Longrightarrow\ \text{estacionário};\qquad \lvert\lambda\rvert=\frac{1}{\lvert z\rvert}=\sqrt{0{,}6}=0{,}7746 && [\text{AU02, p. 27–28}]
\end{aligned}
$$

Confira pelo triângulo: $\phi_1+\phi_2=0{,}9\lt1$; $\phi_2-\phi_1=-2{,}1\lt1$; $\lvert\phi_2\rvert=0{,}6\lt1$. ✓

**O período do ciclo.** As raízes inversas resolvem $\lambda^2-\phi_1\lambda-\phi_2=0$. Escreva-as como $\lambda=r\,e^{\pm i\omega}$.

$$
\begin{aligned}
\text{(6)}\quad & \lambda_1\lambda_2=-\phi_2\ \Longrightarrow\ r^2=-\phi_2,\quad r=\sqrt{-\phi_2} && [\text{produto das raízes}]\\
\text{(7)}\quad & \lambda_1+\lambda_2=\phi_1\ \Longrightarrow\ 2r\cos\omega=\phi_1 && [\text{soma das raízes}]\\
\text{(8)}\quad & \cos\omega=\frac{\phi_1}{2\sqrt{-\phi_2}}=\frac{1{,}5}{2(0{,}7746)}=0{,}9682 && [(6),(7)]\\
\text{(9)}\quad & \text{período}=\frac{2\pi}{\omega}=\frac{2\pi}{\arccos(0{,}9682)}=24{,}87 \text{ períodos} && [\text{uma volta}=2\pi]
\end{aligned}
$$

**Yule-Walker.** Multiplique o modelo por $y_{t-k}$ e tire a esperança:

$$
\begin{aligned}
\text{(10)}\quad & \gamma_1=\phi_1\gamma_0+\phi_2\gamma_1\ \Longrightarrow\ \rho_1=\phi_1+\phi_2\rho_1 && [k=1,\ \div\gamma_0]\\
\text{(11)}\quad & \rho_1=\frac{\phi_1}{1-\phi_2}=\frac{1{,}5}{1{,}6}=0{,}9375 && [\text{isola}]\\
\text{(12)}\quad & \rho_2=\phi_1\rho_1+\phi_2=1{,}5(0{,}9375)-0{,}6=0{,}80625 && [k=2]
\end{aligned}
$$

$$
\boxed{\lvert z\rvert=\sqrt{1/0{,}6}=1{,}291\gt1,\qquad \rho_1=\frac{\phi_1}{1-\phi_2},\qquad \rho_2=\phi_1\rho_1+\phi_2,\qquad \text{ciclo de }\approx25\text{ períodos}}
$$

> [!CAUTION]
> **O erro do caderno nesta conta**
> No caderno, o polinômio virou $1-1{,}5B-0{,}6B^2$. O sinal de $\phi_2$ entra **trocado**: $-\phi_2B^2=-(-0{,}6)B^2=+0{,}6B^2$. Daí o $\Delta$ saiu com sinal errado e os módulos 0,6 e 0,52 também. O módulo certo das raízes inversas é $\sqrt{0{,}6}=0{,}7746$, igual para as duas conjugadas.

## Exemplo

**Quatro processos, uma tabela.** Todos os números vêm do R. Os dois primeiros são os mesmos da AU02, p. 34. O AR(2) é o do caderno, e o ARMA(1,1) é o da AU02, p. 86.

| Processo (slides) | O que olhar | Resultado |
|---|---|---|
| MA(1), $\theta_1=0{,}5$, $\sigma^2=4$ | $\gamma_0$, $\gamma_1$, $\rho_1$ | 5; 2; 0,4 |
| MA(1), $\theta_1=2$, $\sigma^2=1$ | $\gamma_0$, $\gamma_1$, $\rho_1$ | 5; 2; 0,4: **idênticos** |
| reconstrução de $\varepsilon_t$ | peso de $y_{t-4}$, $(-\theta_1)^4$ | 0,0625 com $\theta_1=0{,}5$; **16** com $\theta_1=2$ |
| AR(1), $\phi_1=0{,}8$, $\sigma^2=1$ | $\gamma_0$; $\rho_5$; meia-vida | 2,7778; 0,3277; 3,11 períodos |
| AR(2), $\phi_1=1{,}5$, $\phi_2=-0{,}6$ | $\Delta$; $\lvert z\rvert$; $\rho_1$; $\rho_2$; ciclo | $-0{,}15$; 1,2910; 0,9375; 0,8063; 24,87 |
| ARMA(1,1), $\phi_1=0{,}8$, $\theta_1=0{,}6$ | $\psi_1,\psi_2,\psi_3$; $\rho_1$ | 1,4; 1,12; 0,896; 0,8931 |

**Como ler a tabela:**
1. **O par MA(1).** As duas linhas têm a mesma FAC, e a diferença máxima calculada pelo `ARMAacf` é zero. Mas a terceira linha mostra a diferença que importa: com $\theta_1=2$, a observação de quatro períodos atrás pesa 16 vezes na reconstrução do choque de hoje. **Só o par invertível é útil.**
2. **O AR(1).** Com $\phi_1=0{,}8$, um choque perde metade da força em pouco mais de 3 períodos, porque $\ln0{,}5/\ln0{,}8=3{,}11$. Depois de 5 períodos, sobra $0{,}8^5=0{,}33$ dele.
3. **O AR(2).** A memória é longa, com $\rho_1=0{,}94$, e oscila: o balanço completa uma volta a cada ~25 períodos e perde amplitude à taxa $\lvert\lambda\rvert=0{,}77$ por período.
4. **O ARMA(1,1).** Os pesos começam em $\psi_1=\phi_1+\theta_1=1{,}4$, maior que 1, porque o MA soma um eco ao primeiro passo. Depois decaem à taxa 0,8 do AR.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_c2_ma_a_g0 | 5 |
| ap_c2_ma_a_g1 | 2 |
| ap_c2_ma_a_rho1 | 0,4 |
| ap_c2_ma_b_g0 | 5 |
| ap_c2_ma_b_g1 | 2 |
| ap_c2_ma_b_rho1 | 0,4 |
| ap_c2_ma_dif_acf | 0 |
| ap_c2_ma_rho1_max | 0,5 |
| ap_c2_ma_pi4_05 | 0,0625 |
| ap_c2_ma_pi4_2 | 16 |
| ap_c2_ar1_g0 | 2,7778 |
| ap_c2_ar1_g0_r | 2,7778 |
| ap_c2_ar1_rho5 | 0,3277 |
| ap_c2_ar1_meiavida | 3,11 |
| ap_c2_ar2_delta | -0,15 |
| ap_c2_ar2_re | 1,25 |
| ap_c2_ar2_im | 0,3227 |
| ap_c2_ar2_mod | 1,2910 |
| ap_c2_ar2_mod_r | 1,2910 |
| ap_c2_ar2_lambda | 0,7746 |
| ap_c2_ar2_soma | 0,9 |
| ap_c2_ar2_dif | -2,1 |
| ap_c2_ar2_rho1 | 0,9375 |
| ap_c2_ar2_rho2 | 0,80625 |
| ap_c2_ar2_rho1_r | 0,9375 |
| ap_c2_ar2_cosw | 0,9682 |
| ap_c2_ar2_periodo | 24,87 |
| ap_c2_arma_psi1 | 1,4 |
| ap_c2_arma_psi2 | 1,12 |
| ap_c2_arma_psi3 | 0,896 |
| ap_c2_arma_rho1 | 0,8931 |
| ap_c2_arma_rho1_r | 0,8931 |
-->

## Cadeia socrática

Tente responder antes de ler a caixa. Cada pergunta prepara a seguinte.

**P1.** Num MA(3), pode haver correlação entre $y_t$ e $y_{t-4}$?

> [!TIP]
> **Resposta**
> Não. $y_t$ contém os choques de $t$ a $t-3$, e $y_{t-4}$ contém os de $t-4$ a $t-7$. Eles não dividem nenhum choque, e o RB zera todos os produtos cruzados: $\gamma_4=0$. É o eco que parou.

**P2.** Então, se a FAC amostral mostra $\widehat\rho_1=0{,}8$ e zero depois, o processo é um MA(1)?

> [!TIP]
> **Resposta**
> Não pode ser. No MA(1), $\lvert\rho_1\rvert\le\frac12$ (D2.3). Um corte em 1 com $\widehat\rho_1=0{,}8$ indica outro modelo, ou um problema na amostra (AU02, p. 35).

**P3.** Por que o MA($q$) é estacionário para quaisquer $\theta$, mas o AR($p$) precisa de condição?

> [!TIP]
> **Resposta**
> O MA($q$) é uma soma **finita** de choques: a variância é $\sigma^2\sum\theta_j^2$, sempre finita. O AR é uma soma **infinita** de choques passados, com pesos $\psi_j$. Ela só converge se os pesos encolhem, e é aí que entram as raízes fora do círculo (AU02, p. 29).

**P4.** E se, no AR(1), $\phi_1=1$?

> [!TIP]
> **Resposta**
> Então $\psi_j=1^j=1$ para todo $j$: todo choque antigo pesa o mesmo que o de hoje e nunca some. $\gamma_0=\sigma^2/(1-1)$ não existe. É o passeio aleatório da [Q2](../lista_comentada/q02.md): **a mola quebrou** (AU02, p. 26).

**P5.** E com $\phi_1=-0{,}8$, como fica a FAC?

> [!TIP]
> **Resposta**
> $\rho_k=(-0{,}8)^k$: $-0{,}8$; $0{,}64$; $-0{,}512$… O sinal alterna e o módulo decai. Um desvio para cima hoje tende a virar um desvio para baixo amanhã.

**P6.** Por que a FACP de um AR(2) é zero a partir da defasagem 3?

> [!TIP]
> **Resposta**
> $\phi_{33}$ é o último coeficiente de um AR(3) ajustado a um processo que é AR(2). Depois de controlar por $y_{t-1}$ e $y_{t-2}$, a defasagem $y_{t-3}$ não traz informação nova, e o coeficiente dela é zero (AU02, p. 93–94).

**P7.** Se $\theta_1=2$ gera um processo estacionário com a mesma FAC de $\theta_1=0{,}5$, por que proibir o 2?

> [!TIP]
> **Resposta**
> Por dois motivos (AU02, p. 30–34):
> - **reconstrução:** com $\theta_1=2$, o peso de $y_{t-j}$ na recuperação de $\varepsilon_t$ é $(-2)^j$ e explode, então não dá para prever, porque a previsão precisa de $\varepsilon_t$;
> - **identificação:** os dois modelos são indistinguíveis nos dados, e sem uma regra a verossimilhança teria dois máximos iguais.

**P8.** No ARMA(1,1), por que $\rho_k=\phi_1^{k-1}\rho_1$ e não $\phi_1^k$?

> [!TIP]
> **Resposta**
> Porque a recursão $\gamma_k=\phi_1\gamma_{k-1}$ só vale a partir de $k=2$. Em $k=1$, o termo $\theta_1E(\varepsilon_{t-1}y_{t-1})=\theta_1\sigma^2$ ainda aparece. O MA "contamina" só o primeiro valor, e o decaimento parte de $\rho_1$, não de $\rho_0=1$.

**P9.** Que modelo é $(1-0{,}5L)\,y_t=(1-0{,}5L)\,\varepsilon_t$?

> [!TIP]
> **Resposta**
> Ruído branco. O fator $(1-0{,}5L)$ aparece dos dois lados e cancela, como o 3 em $6/9$. Pela fórmula, $\psi_1=\phi_1+\theta_1=0{,}5+(-0{,}5)=0$, e todos os outros pesos também são zero. Estimar um ARMA(1,1) aqui dá parâmetros instáveis: é o **fator comum**.

**P10.** No AR(2), o que muda quando $\Delta\lt0$?

> [!TIP]
> **Resposta**
> As raízes ficam complexas, e a FAC vira uma **senoide amortecida**: o balanço. A estacionariedade ainda exige módulo fora do círculo, $\lvert z\rvert=\sqrt{-1/\phi_2}\gt1$, o que equivale a $\lvert\phi_2\rvert\lt1$ no caso complexo. O período do ciclo é $2\pi/\arccos\big(\phi_1/(2\sqrt{-\phi_2})\big)$.

## Diálogo

*Sobre o erro que mais cai nesta parte: misturar o sinal da lista com o dos slides.*

**Aluno:** Na Q5, o modelo é $\tilde z_t=a_t-1{,}3a_{t-1}+0{,}4a_{t-2}$. Pela fórmula dos slides, $\theta_1=1{,}3$, e o MA não é invertível, porque $1{,}3\gt1$.

**Professor:** Que fórmula você usou para concluir que não é invertível?

**Aluno:** $\lvert\theta_1\rvert\lt1$. A que vale no MA(1).

**Professor:** E esse modelo é um MA(1)?

**Aluno:** Não, é MA(2)… Então eu preciso das raízes de $\theta(z)$.

**Professor:** Isso. E qual é o $\theta(z)$, escrito com cuidado?

**Aluno:** Nos slides o sinal é positivo, $\theta(z)=1+\theta_1z+\theta_2z^2$. Como a lista tem $-1{,}3$ e $+0{,}4$, fica $\theta_1=-1{,}3$ e $\theta_2=0{,}4$. Então $\theta(z)=1-1{,}3z+0{,}4z^2$.

**Professor:** Agora as raízes.

**Aluno:** $\Delta=1{,}69-1{,}6=0{,}09$, e $z=\frac{1{,}3\pm0{,}3}{0{,}8}$, que dá 2 e 1,25. As duas estão fora do círculo. É invertível!

**Professor:** Então o "1,3 maior que 1" não provava nada. Num MA(2), um coeficiente maior que 1 é compatível com a invertibilidade. O que decide são as **raízes**. Qual é a regra que você leva para a prova?

**Aluno:** Primeiro, traduzir o sinal: $\theta^{\text{lista}}=-\theta_1$. Segundo, montar o polinômio inteiro. Terceiro, aplicar Bhaskara e olhar o módulo das raízes. O atalho $\lvert\theta_1\rvert\lt1$ só vale no MA(1).

**Professor:** E o mesmo vale para o AR(2) do seu caderno: o erro lá foi o sinal de $\phi_2$, não a conta de Bhaskara.

## Na prova

**A folha de caderno do bloco** está em [a_mao_cap2.md](a_mao_cap2.md): Q5, Q7 e Q8 em 80 linhas numeradas, cada uma com a justificativa, mais o esqueleto da Q6, a versão para a prova e a conferência em R. É o que se copia no papel para treinar.

| Questão | O que este capítulo dá | Resolução completa |
|---|---|---|
| Q5 | escrever em $B$, classificar, estacionariedade e invertibilidade pelas raízes, pesos $\psi_j$ e $\pi_j$ | [Q5](../lista_comentada/q05.md) |
| Q6 | ARMA(1,1): $\gamma_k$, $\rho_k=\phi_1^{k-1}\rho_1$, MA($\infty$) e AR($\infty$) | [Q6](../lista_comentada/q06.md) e a [folha à mão](../lista_comentada/a_mao_q02_q06.md) |
| Q7 | AR(2): Yule-Walker, $\rho_1$, $\rho_2$, $\gamma_0$ | [Q7](../lista_comentada/q07.md) |
| Q8 (I) | ARMA(1,1) no sinal positivo, julgamento V/F | [Q8](../lista_comentada/q08.md) |

**Armadilhas** (do [log de erros](../prova/log_erros.md) e do caderno):
- usar $\lvert\theta_1\rvert\lt1$ num MA(2), em vez das raízes;
- trocar o sinal de $\phi_2$ ao montar $\phi(z)$;
- escrever $\gamma_k=\phi_1^k\gamma_1$ no ARMA(1,1), quando o certo é $\phi_1^{k-1}\gamma_1$;
- perder o quadrado de $\theta_1^2$ em $\gamma_0$;
- concluir "MA(1)" por um corte em 1 com $\widehat\rho_1\gt0{,}5$.

**Checklist de 30 segundos**, antes de entregar:
1. Escrevi qual convenção de sinal estou usando?
2. Montei o polinômio **inteiro** antes de falar de raízes?
3. Estacionariedade pelo $\phi(z)$ e invertibilidade pelo $\theta(z)$, separadamente?
4. Cada esperança tem a justificativa ([RB], [caus.], [estac.])?
5. O resultado final está traduzido para o sinal da lista?

## No material do professor

**Roteiro de releitura**, na ordem deste capítulo:
- AU02, p. 11–14: operador $L$;
- AU02, p. 15–23: processo linear geral, $\Psi$, $\pi$, e os exemplos AR(1) e MA(1);
- AU02, p. 24: as duas perguntas da abertura;
- AU02, p. 25–29: memória do AR e estacionariedade do MA;
- AU02, p. 30–36: invertibilidade, o par $\theta$ e $1/\theta$, e a dualidade AR ↔ MA;
- AU02, p. 37–41: matriz $F$ e triângulo do AR(2);
- AU02, p. 45–53: momentos do MA(1) e do MA($q$);
- AU02, p. 61–71: AR(1), AR($p$) e Yule-Walker;
- AU02, p. 81–87: ARMA(1,1) e ARMA($p,q$);
- AU02, p. 90–97: FACP e identificação.

A EQD dá a base de equações de diferenças de 2ª ordem para o caso complexo.

**Livros:**
- **ENDERS**, cap. 2: ARMA e FAC no nível do curso, com as raízes características bem explicadas;
- **HAMILTON**, cap. 3: o rigor do processo linear e da invertibilidade;
- **BJRL**, cap. 3: a convenção de sinal da lista e a FAC dos modelos mistos.

**Na lista comentada:** [Q5](../lista_comentada/q05.md) · [Q6](../lista_comentada/q06.md) · [Q7](../lista_comentada/q07.md) · [Q8](../lista_comentada/q08.md) · caixa de ferramentas [F1 (Bhaskara), F2 (série geométrica), F7 (igualar coeficientes)](../lista_comentada/README.md#2-caixa-de-ferramentas).
