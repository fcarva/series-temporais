---
title: "Lista comentada — Q1 a Q16 passo a passo na notação dos slides"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: LST
aulas: "AU01, AU02, AU03, MAT, EQD"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Lista comentada — notação dos slides
---

# Lista comentada: as 16 questões, passo a passo, na notação dos slides

Cada questão da lista "Processos ARMA, ARIMA e SARIMA" tem aqui uma nota própria, com **todas as passagens**, inclusive as de álgebra elementar: Bhaskara, soma de série geométrica, quadrado de uma soma, multiplicação de polinômios termo a termo. A notação é **a dos slides do professor** (AU01–AU03). Cada nota junta quatro fontes:
- a lista;
- o slide que sustenta cada passo, com a página;
- o livro que aprofunda;
- o que está no **meu caderno**, com as correções onde ele errou.

Todos os números estão em [lista_comentada.R](lista_comentada.R) (id `lc`) e são conferidos pelo build.

| Bloco | Questões |
|---|---|
| 1. Processos e momentos | [Q1](q01.md) · [Q2](q02.md) · [Q3](q03.md) · [Q4](q04.md) |
| 2. AR, MA e ARMA | [Q5](q05.md) · [Q6](q06.md) · [Q7](q07.md) · [Q8](q08.md) |
| 3. Integrados, ARIMA e SARIMA | [Q9](q09.md) · [Q10](q10.md) · [Q11](q11.md) · [Q12](q12.md) |
| 4. Estimação e seleção | [Q13](q13.md) · [Q14](q14.md) |
| 5. Previsão | [Q15](q15.md) |
| 6. Aplicação | [Q16](q16.md) |

**Antes de cada bloco:** o capítulo correspondente da [apostila](../apostila/README.md) dá a teoria geral, com perguntas em cadeia, diálogo e imagens; as notas daqui resolvem as questões.

**Para fazer à mão:** a Q2 e a Q6 estão também em [versão de caderno](a_mao_q02_q06.md), linha a linha, sem comentário, na notação dos slides e do caderno (PDF: `caderno/pdf/caderno_a_mao_q02_q06.pdf`).

Para treinar com outros números, use o [banco de variações](../prova/banco.md) e os [simulados](../prova/README.md).

## 1. Da lista para os slides

A lista e os slides usam convenções diferentes para o MA. **A prova sai da lista**, então cada nota começa traduzindo o enunciado e termina escrevendo o resultado também no sinal da lista.

| Objeto | Slides (AU01–AU03) | Lista |
|---|---|---|
| Operador de defasagem | $L$, com $L^iy_t=y_{t-i}$ (AU02, p. 11) | $B$ |
| Ruído branco | $\varepsilon_t\sim RB(0,\sigma^2)$ | $a_t$, $\varepsilon_t$ ou $u_t$ |
| Polinômio AR | $\phi_p(L)=1-\phi_1L-\cdots-\phi_pL^p$ (AU02, p. 12) | igual, com $B$ |
| Polinômio MA | $\theta_q(L)=1+\theta_1L+\cdots+\theta_qL^q$, **sinal positivo** (AU02, p. 13) | $\theta(B)=1-\theta_1B-\cdots$, **sinal negativo** (exceto Q8) |
| Pesos MA($\infty$) | $y_t=\mu+\Psi(L)\varepsilon_t$, com $\psi_0=1$ (AU02, p. 16) | $\psi_j$ |
| Pesos AR($\infty$) | $\pi(L)\tilde y_t=\varepsilon_t$, com $\pi(L)=1-\pi_1L-\pi_2L^2-\cdots$ (AU02, p. 19) | igual |
| Passeio com drift e tendência | $Y_t=\alpha_1+Y_{t-1}+\alpha_2t+\varepsilon_t$ (AU01, p. 30) | $y_t=c+\delta t+y_{t-1}+u_t$ |
| Informação até $t$ | $\Omega_t$ | $\mathcal F_T$ |
| Previsão e erro | $\widehat y_{t+k/t}=E(y_{t+k}\mid\Omega_t)$; $e_{t+k/t}=y_{t+k}-\widehat y_{t+k/t}$ (AU02, p. 72–75) | $y_{T+h\mid T}$; $e_T(h)$ |
| Variância | $V(\cdot)$ | $\operatorname{Var}(\cdot)$ |

> [!CAUTION]
> **A regra de tradução do MA**
> Se a lista escreve $a_t-\theta a_{t-1}$, nos slides isso é $\varepsilon_t+\theta^{s}\varepsilon_{t-1}$ com
>
> $$\theta^{s}=-\theta^{\text{lista}}.$$
>
> Toda fórmula dos slides vira a da lista trocando $\theta\to-\theta$. Exemplo: $\rho_1=\frac{\theta}{1+\theta^2}$ (slides, AU02, p. 47) vira $\rho_1=\frac{-\theta}{1+\theta^2}$ (lista).

## 2. Caixa de ferramentas

Ferramentas que aparecem em quase toda questão, demonstradas **uma vez** aqui. Nas notas, cada passo cita a ferramenta pelo id: [F1], [F2]…

### F1 · Bhaskara, as raízes e o módulo

**Enunciado.** As raízes de $az^2+bz+c=0$, com $a\ne0$, são

$$
z=\frac{-b\pm\sqrt{\Delta}}{2a},\qquad \Delta=b^2-4ac .
$$

**Demonstração (completar o quadrado).**
1. Divida tudo por $a$: $z^2+\frac{b}{a}z+\frac{c}{a}=0$.
2. Some e subtraia $\left(\frac{b}{2a}\right)^2$: $\left(z+\frac{b}{2a}\right)^2-\frac{b^2}{4a^2}+\frac{c}{a}=0$.
3. Isole o quadrado: $\left(z+\frac{b}{2a}\right)^2=\frac{b^2-4ac}{4a^2}=\frac{\Delta}{4a^2}$.
4. Tire a raiz dos dois lados: $z+\frac{b}{2a}=\pm\frac{\sqrt\Delta}{2a}$, logo $z=\frac{-b\pm\sqrt\Delta}{2a}$.

**Três casos.**
- $\Delta\gt0$: duas raízes reais distintas.
- $\Delta=0$: uma raiz real dupla, $z=-b/(2a)$.
- $\Delta\lt0$: duas raízes complexas conjugadas, $z=\frac{-b}{2a}\pm i\frac{\sqrt{-\Delta}}{2a}$, com $i=\sqrt{-1}$.

**Módulo de um complexo.** Para $z=h+vi$, $\lvert z\rvert=\sqrt{h^2+v^2}$. As duas conjugadas $h\pm vi$ têm **o mesmo módulo**.

**Atalho (Vieta).** O produto das raízes é $z_1z_2=c/a$. Para conjugadas, $z_1z_2=\lvert z\rvert^2$, logo $\lvert z\rvert=\sqrt{c/a}$.

**Para que serve.** Estacionariedade (raízes de $\phi(z)$) e invertibilidade (raízes de $\theta(z)$) exigem $\lvert z\rvert\gt1$ (AU02, p. 27 e 33). Na revisão de equações a diferenças (EQD, p. 24–26), a mesma fórmula aparece para a equação característica $b^2+a_1b+a_2=0$.

> [!WARNING]
> **Raízes $z$ ou autovalores $\lambda$? Fora ou dentro?**
> AU02, p. 28: as raízes de $\phi(z)=1-\phi_1z-\phi_2z^2$ devem ficar **fora** do círculo, $\lvert z\rvert\gt1$. As raízes de $\lambda^2-\phi_1\lambda-\phi_2=0$, que são os autovalores da matriz $F$ (p. 40), devem ficar **dentro**, $\lvert\lambda\rvert\lt1$. São a mesma condição, porque $\lambda=1/z$. Escreva sempre qual das duas você está usando.

### F2 · Série geométrica

Para $r\ne1$, $S_n=\sum_{j=0}^{n-1}r^j=\frac{1-r^n}{1-r}$.

**Demonstração.**
1. $S_n=1+r+\cdots+r^{n-1}$.
2. $rS_n=r+r^2+\cdots+r^n$.
3. Subtraindo, os termos do meio cancelam: $S_n-rS_n=1-r^n$, logo $S_n=\frac{1-r^n}{1-r}$.
4. Se $\lvert r\rvert\lt1$, então $r^n\to0$ e $\sum_{j\ge0}r^j=\frac{1}{1-r}$. Se $\lvert r\rvert\ge1$, a série não converge.

É o que permite escrever $(1-\phi L)^{-1}=1+\phi L+\phi^2L^2+\cdots$ quando $\lvert\phi\rvert\lt1$ (AU02, p. 11 e 21) e $\sum\phi^{2j}=\frac{1}{1-\phi^2}$.

### F3 · Soma dos primeiros inteiros

$\sum_{s=1}^{t}s=\frac{t(t+1)}{2}$.

**Demonstração (Gauss).** Escreva a soma duas vezes, uma em ordem crescente e outra em decrescente, e some coluna a coluna. Cada coluna dá $t+1$, e são $t$ colunas: $2S=t(t+1)$. Aparece na tendência do passeio com drift e tendência (Q2 e Q8). Exemplo: $\sum_{s=1}^{10}s=55$.

### F4 · Linearidade da esperança

$E(a+bX+cY)=a+bE(X)+cE(Y)$ para constantes $a$, $b$ e $c$. Constantes saem da esperança: $E(c)=c$. Para uma soma **finita**, $E\big(\sum_{s=1}^{t}X_s\big)=\sum_{s=1}^{t}E(X_s)$: é a F4 aplicada $t-1$ vezes, com a prova por indução na [folha à mão da Q2](a_mao_q02_q06.md). **Não** vale $E(XY)=E(X)E(Y)$ em geral. Isso só vale quando $X$ e $Y$ são não correlacionados.

### F5 · Variância e covariância de combinações lineares

- $V(aX+bY)=a^2V(X)+b^2V(Y)+2ab\operatorname{Cov}(X,Y)$.
- $\operatorname{Cov}\left(\sum_ia_iX_i,\sum_jb_jY_j\right)=\sum_i\sum_ja_ib_j\operatorname{Cov}(X_i,Y_j)$.

Com ruído branco, $E(\varepsilon_i\varepsilon_j)=\sigma^2$ se $i=j$ e $0$ se $i\ne j$. Num produto de duas somas de choques, **só sobrevivem os termos com o mesmo índice**. A constante sai **ao quadrado** da variância.

### F6 · Causalidade: o choque de hoje não conversa com o passado

Num processo estacionário escrito como $y_t=\mu+\sum_{j\ge0}\psi_j\varepsilon_{t-j}$, o valor $y_{t-k}$ só depende de $\varepsilon_{t-k},\varepsilon_{t-k-1},\dots$ Logo:

$$
E\big(\varepsilon_t(y_{t-k}-\mu)\big)=0\ \ (k\ge1),\qquad E\big(\varepsilon_t(y_t-\mu)\big)=\psi_0\sigma^2=\sigma^2,\qquad E\big(\varepsilon_{t-1}(y_t-\mu)\big)=\psi_1\sigma^2 .
$$

No ARMA(1,1) dos slides, $\psi_1=\phi_1+\theta_1$. É o "momento auxiliar" da AU02, p. 83, e do meu caderno de 02/09.

### F7 · Igualar coeficientes (inverter um polinômio em $L$)

Se $\Psi(L)\phi(L)=\theta(L)$, os coeficientes de cada potência $L^j$ são iguais dos dois lados. Isso dá os $\psi_j$ por recursão:

$$
\psi_j=\phi_1\psi_{j-1}+\cdots+\phi_p\psi_{j-p}+\theta_j\qquad(\psi_0=1;\ \psi_{\text{negativo}}=0;\ \theta_j=0\text{ se }j\gt q).
$$

Os $\pi_j$ saem do mesmo jeito, de $\pi(L)\theta(L)=\phi(L)$.

### F8 · Multiplicar polinômios em $L$

Distributiva termo a termo, somando expoentes: $L^a\cdot L^b=L^{a+b}$. Exemplo:

$$
(1-\phi L)(1-L)=1-L-\phi L+\phi L^2=1-(1+\phi)L+\phi L^2 .
$$

### F9 · Esperança condicional na previsão

Com a informação $\Omega_t$ (AU02, p. 54 e 72):
- o que é conhecido em $t$ sai como está: $E(y_{t-j}\mid\Omega_t)=y_{t-j}$ e $E(\varepsilon_{t-j}\mid\Omega_t)=\varepsilon_{t-j}$ para $j\ge0$;
- choque futuro tem esperança zero: $E(\varepsilon_{t+j}\mid\Omega_t)=0$ para $j\ge1$;
- $y$ futuro vira a própria previsão: $E(y_{t+j}\mid\Omega_t)=\widehat y_{t+j/t}$.

A **lei das expectativas iteradas** (LEI), $E\big(E(X\mid\Omega_t)\big)=E(X)$, fecha a prova do previsor ótimo (Q15).

## 3. O meu caderno e onde ele entra

As fotos do caderno (aulas de 13/08 a 10/09) ficam em `materiais/caderno/`, fora do git: o repositório é público. Cada nota transcreve o trecho que importa na seção "Do meu caderno". Quando o caderno tem erro, a nota mostra a correção.

| Aula | Conteúdo no caderno | Questão |
|---|---|---|
| 13/08 | introdução, o que é série temporal, FAC e FACP, Spanos (1999) | [Q3](q03.md), [Q4](q04.md) |
| 19/08 | momentos do passeio aleatório (média, variância, covariância) | [Q1](q01.md) |
| 19/08 | passeio com drift e tendência; solução recursiva do AR(1); estável × instável | [Q2](q02.md), [Q4](q04.md) |
| 19/08 | multiplicador dinâmico (demanda por moeda de Goldfeld) | [Q4](q04.md), [Q6](q06.md) |
| 20/08 | notação em $L$; processo linear geral; pesos $\pi$; momentos condicionais × incondicionais | [Q4](q04.md), [Q5](q05.md) |
| 20/08 | MA(1): média, variância e covariâncias condicionais e incondicionais | [Q3](q03.md), [Q5](q05.md) |
| 26/08 | MA(2) e MA($q$); previsão do MA; intervalo e EQM; verossimilhança do MA(1) | [Q3](q03.md), [Q13](q13.md), [Q15](q15.md) |
| 26/08 | AR(1): média, variância com a decomposição A + B + C | [Q4](q04.md), [Q9](q09.md) |
| 02/09 | ARMA(1,1): momentos auxiliares, $\gamma_0$, $\gamma_k$ | [Q6](q06.md) |
| 02/09 | AR(1) e AR(2): Yule-Walker; previsão do AR(1) e erro | [Q7](q07.md), [Q15](q15.md) |
| 03/09 | condição de estacionariedade do AR(2); exemplo com Bhaskara e raízes complexas | [Q7](q07.md) |
| 03/09 | MA(1) → AR($\infty$); ARMA(1,2); par $\theta=0{,}5$ e $\theta=2$; forma $F$ do AR($p$) | [Q4](q04.md), [Q5](q05.md), [Q7](q07.md) |
| 09/09 | desenho da FAC e da FACP do AR(2) e do MA(2); estabilidade e quebra estrutural | [Q12](q12.md), [Q16](q16.md) |
| 10/09 | previsão iterada × direta; métricas (MAPE, MAD, RMSE, MASE) | [Q15](q15.md) |

> [!IMPORTANT]
> **Os erros do caderno que precisam ser desaprendidos**
> 1. **19/08, AR(1) recursivo:** $y_2=\phi^2+\phi\varepsilon_1+\varepsilon_2$. Falta o $y_0$; o certo é $\phi^2y_0$. Na linha seguinte aparece $y_0^2$ no lugar de $y_0$. A fórmula final $y_t=\phi^ty_0+\sum\phi^{t-i}\varepsilon_i$ está certa. Ver [Q4](q04.md).
> 2. **19/08:** "$E(XY)=E(X)E(Y)$" e "$\sigma^2=E(X^2)$" valem só com $X$ e $Y$ não correlacionados e com média zero, respectivamente [F4]. Ver [Q1](q01.md).
> 3. **26/08, MA(2):** a esperança condicional mistura $E(y_t\mid\Omega_{t-1})$ com $E(y_{t+2}\mid\Omega_t)$, e há $\theta_3$ no lugar de $\theta_2$. Ver [Q15](q15.md).
> 4. **02/09, ARMA(1,1):** $\gamma_0=\frac{\sigma^2(\theta_1+1+2\theta_1\phi_1)}{1-\phi_1^2}$ perdeu o quadrado, porque o certo é $\theta_1^2$. Também $\gamma_k=\phi_1^k\gamma_1$ está errado; o certo é $\phi_1^{k-1}\gamma_1$. Ver [Q6](q06.md).
> 5. **03/09, AR(2) $y_t=1{,}5y_{t-1}-0{,}6y_{t-2}+a_t$:** o polinômio virou $1-1{,}5B-0{,}6B^2$, quando o certo é $1-1{,}5B+0{,}6B^2$. Daí $\Delta$ saiu com o sinal trocado, e os "módulos" 0,6 e 0,52 estão errados. As duas raízes conjugadas têm o mesmo módulo, $\sqrt{0{,}6}=0{,}7746$. Ver [Q7](q07.md).
> 6. **03/09, MA(1) → AR($\infty$):** apareceu $+\theta_1^2\varepsilon_{t-2}$; o certo é $-\theta_1^2\varepsilon_{t-2}$, e os sinais alternam (AU02, p. 31). Ver [Q4](q04.md).
>
> As referências "(32/83)" e "(35/83)" do caderno são da versão antiga dos slides. Na versão atual da AU02 (99 páginas), o EQM do MA(1) está na p. 57 e a verossimilhança condicional do MA(1) nas p. 58–59.

## 4. Livros

Os PDFs estão na pasta "Econometria II" do Drive; as citações são por capítulo.

| Livro | Onde ajuda nesta lista |
|---|---|
| ENDERS (2014) | cap. 1: equações a diferenças, solução homogênea e particular, estabilidade (Q4, Q7); cap. 2: ARMA, FAC e FACP, Box-Jenkins, previsão, sazonalidade (Q5–Q16); cap. 4: tendências e raiz unitária (Q1, Q2, Q9, Q10) |
| HAMILTON (1994) | cap. 2: operador de defasagem e inversão de polinômios (Q4, Q5); cap. 3: momentos do ARMA, invertibilidade e o par $\theta\leftrightarrow1/\theta$ (Q3–Q8); cap. 4: previsão ótima e Wold (Q4, Q15); cap. 5: MV exata e condicional do AR(1) (Q13) |
| BJRL (2016) | convenção de sinal da lista; cap. 3–4: modelos estacionários e não estacionários (Q5–Q10); cap. 5: previsão, com os pesos $\psi$ (Q12, Q15); cap. 6–8: identificação, estimação e diagnóstico (Q13, Q14, Q16); cap. 9: modelos sazonais e o modelo das companhias aéreas (Q11, Q12, Q16) |
| TSAY (2010) | cap. 2: AR, MA, ARMA, previsão e critérios de informação em linguagem aplicada (Q6, Q7, Q14, Q15) |
| MAT (Mattos, 2019) | tendência determinística × estocástica, processo DS × TS, decomposição de Beveridge-Nelson (Q1, Q2, Q10) |
