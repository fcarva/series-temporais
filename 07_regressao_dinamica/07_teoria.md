---
title: "Módulo 07 — Regressão com séries temporais: DL, ARDL, ECM e Granger (teoria)"
modulo: "07"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
aulas: "AU06"
leituras: "Enders, cap. 5 (sec. 2–4) e 6 (sec. 1–5); Pesaran, cap. 6 (6.1–6.5) e 22 (22.1–22.3)"
status: rascunho
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
aliases:
  - Regressão dinâmica — teoria
---

# Módulo 07 — Regressão com séries temporais

> [!NOTE]
> **Mapa do módulo**
> Começa a segunda parte do curso: modelos de **uma equação** que explicam $y_t$ por um regressor $x_t$, com séries estacionárias. O caminho é:
> 1. o que é exogeneidade quando há passado e futuro;
> 2. o DL, com a dinâmica vinda de $x$;
> 3. o ARDL, que acrescenta a dinâmica de $y$;
> 4. o ECM, o mesmo ARDL reescrito em desvios do equilíbrio;
> 5. Granger, que testa nos dados o *feedback* que separa os tipos de exogeneidade.
>
> Os exercícios estão em [07_lista](07_lista.md), conferidos em [07_regressao.R](07_regressao.R). Com séries I(1), o ECM vira cointegração, assunto das próximas aulas.

Notação da AU06: $L$ é o operador de defasagem, e o erro é $\varepsilon_t$. O ARDL aparece de duas formas equivalentes:

$$
\lambda(L)y_t=\phi_0+\beta(L)x_t+\varepsilon_t,\qquad \lambda(L)=1+\lambda_1L+\dots+\lambda_pL^p,\quad \beta(L)=\beta_0+\beta_1L+\dots+\beta_qL^q,
$$

ou, com $\phi_i=-\lambda_i$, $y_t=\phi_0+\sum_i\phi_iy_{t-i}+\sum_j\beta_jx_{t-j}+\varepsilon_t$. Aqui usamos a segunda, com $\phi$, que é a do AR dos módulos anteriores. Assim, $\lambda(1)=1-\phi_1-\dots-\phi_p$.

## 1. Exogeneidade em séries temporais

Em corte transversal, a pergunta é se $x_i$ e $\varepsilon_i$ estão correlacionados. Em séries temporais há uma sequência inteira de regressores, $\dots,x_{t-1},x_t,x_{t+1},\dots$, e cada um pode ou não estar correlacionado com o erro corrente $\varepsilon_t$. Os três conceitos diferem em **quais** dessas correlações proíbem:

| Conceito | Definição | $x_{t-1}$ | $x_t$ | $x_{t+1}$ |
|---|---|---|---|---|
| Exogeneidade contemporânea | $E(\varepsilon_t\mid x_t)=0$ | livre | ortogonal | livre |
| Predeterminação | $E(x_s\varepsilon_t)=0$ para $s\le t$ | ortogonal | ortogonal | livre |
| Exogeneidade estrita | $E(\varepsilon_t\mid x_1,\dots,x_T)=0$ | ortogonal | ortogonal | ortogonal |

- **O que a predeterminação permite e a estrita não** é o *feedback*: um choque em $y$ hoje mudar $x$ amanhã, $\varepsilon_t\to x_{t+1}$. É o caso típico de política econômica, que reage ao que aconteceu: o regressor já estava fixado quando o choque ocorreu, mas o seu valor futuro responde a ele.
- **A exogeneidade contemporânea é a mais fraca.** Ela só fala do mesmo período. Quando nem ela vale, choques do mesmo período movem $y_t$ e $x_t$ juntos, e há endogeneidade no sentido usual.

**O que cada hipótese entrega ao MQO** (AU06):

| Situação | Amostra finita | $T\to\infty$ |
|---|---|---|
| Exogeneidade estrita | não viesado | consistente |
| Só predeterminação, ou só contemporânea | pode ser viesado | consistente (sob estacionariedade e dependência fraca) |
| $y_{t-1}$ entre os regressores e $\varepsilon_t$ autocorrelacionado | viesado | **inconsistente** |
| Endogeneidade contemporânea | viesado | **inconsistente** |

A terceira linha é um caso da quarta. Se $\varepsilon_t$ é autocorrelacionado, $y_{t-1}$ contém $\varepsilon_{t-1}$, que está correlacionado com $\varepsilon_t$. Então $E(y_{t-1}\varepsilon_t)\ne0$: o regressor é endógeno.

> [!IMPORTANT]
> **Violar a exogeneidade estrita não é grave; violar a contemporânea é**
> Sem exogeneidade estrita, o MQO perde o não viés, mas continua consistente. Sem exogeneidade contemporânea, perde a consistência, e mais dados não resolvem.

## 2. O modelo de defasagens distribuídas, DL($q$)

$$
y_t=\phi_0+\beta_0x_t+\beta_1x_{t-1}+\dots+\beta_qx_{t-q}+\varepsilon_t=\phi_0+\beta(L)x_t+\varepsilon_t .
$$

O efeito de $x$ não precisa acontecer todo no mesmo período. Hábitos, prazos de implementação de políticas e atrasos tecnológicos ou institucionais espalham a resposta no tempo. A pergunta passa a ser **como o efeito se distribui ao longo do tempo**.

**Hipóteses** (AU06):

1. linearidade nos parâmetros;
2. $E(\varepsilon_t\mid x_t,\dots,x_{t-q})=0$;
3. sem multicolinearidade perfeita;
4. homocedasticidade condicional;
5. erros sem autocorrelação;
6. normalidade condicional.

A normalidade só dá inferência exata em amostra finita se, além disso, $x$ for estritamente exógeno. Para a inferência assintótica, ela é dispensável.

**Multiplicadores.**

| Choque de uma unidade em $x_t$ | Efeito sobre $y_{t+k}$ |
|---|---|
| **temporário** (só em $t$) | $\partial y_{t+k}/\partial x_t=\beta_k$, e 0 para $k\gt q$ |
| **permanente** (de $t$ em diante) | $\sum_{j=0}^{k}\beta_j$, que chega a $\beta(1)=\sum_j\beta_j$ em $k=q$ |

Os $\beta_j$ formam a trajetória da resposta a um choque temporário. A soma deles é o **multiplicador de longo prazo**, o efeito de uma mudança permanente. Distinguir as duas perguntas, choque temporário ou mudança permanente, é metade de qualquer interpretação.

**A escolha de $q$.** Defasagens demais custam parâmetros e observações, e $x_t,x_{t-1},\dots$ costumam ser muito correlacionados, o que infla os erros-padrão. Defasagens de menos omitem dinâmica. Os instrumentos são os de sempre: AIC e BIC numa amostra comum, e a significância das últimas defasagens.

## 3. O modelo ARDL($p,q$)

O DL põe a dinâmica em $x$, e o AR a põe no passado de $y$. O ARDL junta as duas:

$$
y_t=\phi_0+\sum_{i=1}^{p}\phi_iy_{t-i}+\sum_{j=0}^{q}\beta_jx_{t-j}+\varepsilon_t .
$$

As hipóteses são as do DL, com duas mudanças:

- a média condicional zero passa a condicionar no **passado** de $y$ e no presente e passado de $x$: $E(\varepsilon_t\mid y_{t-1},y_{t-2},\dots,x_t,x_{t-1},\dots)=0$. É uma hipótese de **predeterminação**;
- entra a **estacionariedade**, que faz os choques morrerem.

Tendência e dummies sazonais entram direto na equação, e vários regressores dão o ARDL($p,q_1,\dots,q_k$), cada um com a sua ordem.

### D07.1 · No ARDL, a exogeneidade estrita falha por construção

> [!NOTE]
> **O que se quer provar**
> Num ARDL com $p\ge1$, o regressor $y_{t-1}$ é predeterminado, mas não estritamente exógeno: $E(\varepsilon_t\,y_t)=\sigma^2\ne0$, e $y_t$ é regressor da equação de $t+1$.

**Passo a passo.**

1. $y_{t-1}$ é função de $\varepsilon_{t-1},\varepsilon_{t-2},\dots$ e de $x$. Como $\varepsilon_t$ é ruído branco e não correlacionado com o passado, $E(y_{t-1}\varepsilon_t)=0$: o regressor é predeterminado.
2. Mas $y_t=\phi_0+\phi_1y_{t-1}+\beta_0x_t+\dots+\varepsilon_t$ contém $\varepsilon_t$. Pela hipótese de média condicional zero, os outros termos são ortogonais a $\varepsilon_t$, então $E(y_t\varepsilon_t)=E(\varepsilon_t^2)=\sigma^2$.
3. Na equação de $t+1$, o regressor $y_t$ é o "$x$ futuro" da equação de $t$. A exogeneidade estrita exigiria $E(y_t\varepsilon_t)=0$, o que o passo 2 contradiz.

$$\boxed{E(\varepsilon_t\,y_{t-1})=0\quad\text{mas}\quad E(\varepsilon_t\,y_t)=\sigma^2\ne0\ \Rightarrow\ \text{predeterminado, nunca estritamente exógeno}}$$

Consequência: o MQO de um ARDL é **viesado em amostra finita**. O viés de $\widehat\phi_1$ é negativo e cai com $T$ ([07_lista](07_lista.md), E5). Mas o MQO é **consistente** e assintoticamente normal, se a dinâmica estiver completa.

**Estabilidade.** O ARDL é estável se as raízes de $\lambda(z)=1-\phi_1z-\dots-\phi_pz^p=0$ estão fora do círculo unitário. No ARDL(1,$q$), a raiz é $1/\phi_1$, e a condição é $\lvert\phi_1\rvert\lt1$. Com $\lambda(1)=0$ há raiz unitária: $y$ não volta à média, e a inferência usual não vale.

**O MQO e a inferência na prática.** Com $\mathbf z_t=(1,y_{t-1},\dots,y_{t-p},x_t,\dots,x_{t-q})'$, o MQO é consistente se $E(\mathbf z_t\varepsilon_t)=\mathbf 0$. Isso pede três coisas:

- $x_t$ contemporaneamente exógeno;
- **dinâmica completa**: $\varepsilon_t$ sem autocorrelação, senão $E(y_{t-1}\varepsilon_t)\ne0$;
- estabilidade, com $x_t$ estacionário.

Os testes $t$ e $F$ usuais valem assintoticamente. Com heterocedasticidade, usa-se o erro padrão de White.

> [!WARNING]
> **Autocorrelação no ARDL não se corrige com erro padrão robusto**
> - O Durbin-Watson não serve com $y_{t-1}$ entre os regressores. Use o **Breusch-Godfrey**.
> - Se ele rejeitar, a solução é aumentar $p$ e $q$ até os resíduos ficarem limpos. Um erro padrão HAC corrige a inferência, mas não a **inconsistência** do estimador.

### D07.2 · Multiplicadores do ARDL(1,1) e o efeito de longo prazo

> [!NOTE]
> **O que se quer provar**
> Em $y_t=\phi_0+\phi_1y_{t-1}+\beta_0x_t+\beta_1x_{t-1}+\varepsilon_t$, com $\lvert\phi_1\rvert\lt1$:
> - um choque temporário em $x_t$ gera $m_0=\beta_0$ e $m_k=\phi_1^{k-1}(\phi_1\beta_0+\beta_1)$ para $k\ge1$;
> - um choque permanente acumula até $\theta=(\beta_0+\beta_1)/(1-\phi_1)$.

**Passo a passo.**

1. **Impacto.** Derive a equação de $t$: $\partial y_t/\partial x_t=\beta_0$.
2. **Um período depois**, há dois canais. Escreva a equação de $t+1$, $y_{t+1}=\phi_0+\phi_1y_t+\beta_0x_{t+1}+\beta_1x_t+\varepsilon_{t+1}$:
   - o canal **direto** vem de $\beta_1x_t$;
   - o **indireto** vem de $x_t\to y_t\to y_{t+1}$, com peso $\phi_1\beta_0$.

   Somando, $m_1=\phi_1\beta_0+\beta_1$. Substituir $y_t$ na equação de $t+1$ dá o mesmo coeficiente de $x_t$.
3. **Dali em diante**, $x_t$ não entra mais diretamente. Só sobra o canal autorregressivo: $m_k=\phi_1m_{k-1}$, isto é, $m_k=\phi_1^{k-1}(\phi_1\beta_0+\beta_1)$. Com $\lvert\phi_1\rvert\lt1$, $m_k\to0$, e o choque temporário morre.
4. **Choque permanente.** O efeito acumulado é a soma $\sum_{j=0}^{k}m_j=\beta_0+(\phi_1\beta_0+\beta_1)\frac{1-\phi_1^k}{1-\phi_1}$. Com $k\to\infty$, isso vai a $\beta_0+\frac{\phi_1\beta_0+\beta_1}{1-\phi_1}=\frac{\beta_0+\beta_1}{1-\phi_1}$.
5. **Conferência pelo estado estacionário.** Com $y_t=y_{t-1}=\tilde y$, $x_t=x_{t-1}=\tilde x$ e $\varepsilon=0$, a equação dá $\tilde y=\frac{\phi_0}{1-\phi_1}+\frac{\beta_0+\beta_1}{1-\phi_1}\tilde x$. O coeficiente de $\tilde x$ é o mesmo.

$$\boxed{\theta=\frac{\beta(1)}{\lambda(1)}=\frac{\beta_0+\beta_1+\dots+\beta_q}{1-\phi_1-\dots-\phi_p}}$$

**O papel de $\phi_1$.** Com $\phi_1\approx0$, os efeitos somem rápido, e o ARDL se parece com um DL. Com $\phi_1$ positivo e alto, a resposta é persistente. Com $-1\lt\phi_1\lt0$, ela alterna de sinal. No caso geral, os multiplicadores saem da recursão $m_k=\beta_k+\sum_i\phi_im_{k-i}$ (helper `multiplicadores_ardl` em [R/series.R](../R/series.R)).

**Inferência sobre $\theta$.** $\widehat\theta=\widehat\beta(1)/\widehat\lambda(1)$ é uma função não linear dos coeficientes. Ela tem duas saídas, que dão o mesmo $\widehat\theta$:

- o erro padrão pelo **método delta**, $\operatorname{Var}(\widehat\theta)\approx\nabla\theta'\,\widehat V\,\nabla\theta$;
- a estimativa direta pela forma ECM (seção 4).

> [!TIP]
> **Como o professor pode torcer**
> - Pedir a resposta a um choque **temporário** quando o modelo é dado com $\lambda(L)$, com os sinais trocados: converta antes, $\phi_i=-\lambda_i$.
> - Dar um $\phi_1$ negativo e perguntar o "formato" da resposta: alterna de sinal e amortece.
> - Perguntar quantos períodos levam até 90% do efeito de longo prazo: some os multiplicadores até passar de $0{,}9\,\theta$.

### D07.3 · O viés de omitir $y_{t-1}$

> [!NOTE]
> **O que se quer provar**
> Se o verdadeiro é $y_t=\phi_0+\phi_1y_{t-1}+\beta_0x_t+\varepsilon_t$ e se estima a regressão estática $y_t=\phi_0+\beta_0x_t+u_t$, então
>
> $$\operatorname{plim}\widehat\beta_0=\beta_0+\phi_1\frac{\operatorname{Cov}(x_t,y_{t-1})}{\operatorname{Var}(x_t)},$$
>
> e $\operatorname{Cov}(x_t,y_{t-1})$ tem dois canais: a persistência de $x$ e o *feedback* de $y$ para $x$.

**Passo a passo.**

1. O termo omitido vai para o erro: $u_t=\phi_1y_{t-1}+\varepsilon_t$. Então $\operatorname{plim}\widehat\beta_0=\beta_0+\operatorname{Cov}(x_t,u_t)/\operatorname{Var}(x_t)$, e $\operatorname{Cov}(x_t,u_t)=\phi_1\operatorname{Cov}(x_t,y_{t-1})+\operatorname{Cov}(x_t,\varepsilon_t)$. A última covariância é 0, pela exogeneidade contemporânea do modelo verdadeiro.
2. Escreva $y_{t-1}=\phi_0+\phi_1y_{t-2}+\beta_0x_{t-1}+\varepsilon_{t-1}$. Ele está correlacionado com $x_t$ por dois caminhos:
   - **(A)** via $x_{t-1}$, quando $x$ é persistente e $\beta_0\ne0$;
   - **(B)** via $\varepsilon_{t-1}$, quando $x_t$ reage a choques passados de $y$ (*feedback*).
3. **Caso (A) puro**, com $x_t=\rho x_{t-1}+v_t$ e sem *feedback*. Como $y_{t-1}=\sum_{j\ge0}\phi_1^j(\beta_0x_{t-1-j}+\varepsilon_{t-1-j})$ (mais a média),
   $$\operatorname{Cov}(x_t,y_{t-1})=\beta_0\sum_{j\ge0}\phi_1^j\operatorname{Cov}(x_t,x_{t-1-j})=\beta_0\operatorname{Var}(x)\sum_{j\ge0}\phi_1^j\rho^{j+1}=\beta_0\operatorname{Var}(x)\frac{\rho}{1-\phi_1\rho}.$$

$$\boxed{\operatorname{plim}\widehat\beta_0^{\,\text{estático}}=\beta_0\Big(1+\frac{\phi_1\rho}{1-\phi_1\rho}\Big)=\frac{\beta_0}{1-\phi_1\rho}}$$

No modelo verdadeiro, $x_t$ é predeterminado. No modelo estimado, ele vira **endógeno**, porque o erro carrega $y_{t-1}$. É viés de variável omitida, e incluir $y_{t-1}$ o resolve. O estimador estático não estima nem o impacto $\beta_0$ nem o longo prazo $\beta_0/(1-\phi_1)$: com $0\lt\rho\lt1$, ele fica entre os dois ([07_lista](07_lista.md), E4).

## 4. O modelo de correção de erros (ECM)

Suponha um equilíbrio de longo prazo $y^\ast=\theta x$. Se $y$ ficou acima dele no período anterior, deve cair; se ficou abaixo, deve subir:

$$
\Delta y_t=\beta_0\Delta x_t+\alpha\,(y_{t-1}-\theta x_{t-1})+\varepsilon_t,\qquad \alpha\lt0 .
$$

- $\beta_0\Delta x_t$ é o efeito de curto prazo;
- $y_{t-1}-\theta x_{t-1}$ é o erro de equilíbrio do período anterior;
- $\alpha$ é a **velocidade de ajuste**: com $-1\lt\alpha\lt0$, quanto maior $\lvert\alpha\rvert$, mais rápida a correção, e com $\alpha=0$ o desvio nunca é corrigido.

Com mais dinâmica, entram $\Delta y_{t-i}$ e $\Delta x_{t-i}$ à direita.

### D07.4 · O ECM é o ARDL(1,1) reescrito

> [!NOTE]
> **O que se quer provar**
> $y_t=\phi_0+\phi_1y_{t-1}+\beta_0x_t+\beta_1x_{t-1}+\varepsilon_t$ é idêntico a $\Delta y_t=\phi_0+\beta_0\Delta x_t+(\phi_1-1)\big(y_{t-1}-\theta x_{t-1}\big)+\varepsilon_t$, com $\theta=(\beta_0+\beta_1)/(1-\phi_1)$.

**Passo a passo.**

1. Subtraia $y_{t-1}$ dos dois lados: $\Delta y_t=\phi_0+(\phi_1-1)y_{t-1}+\beta_0x_t+\beta_1x_{t-1}+\varepsilon_t$.
2. Some e subtraia $\beta_0x_{t-1}$: $\beta_0x_t+\beta_1x_{t-1}=\beta_0\Delta x_t+(\beta_0+\beta_1)x_{t-1}$.
3. Ponha $(\phi_1-1)$ em evidência nos termos em nível: $(\phi_1-1)y_{t-1}+(\beta_0+\beta_1)x_{t-1}=(\phi_1-1)\Big(y_{t-1}-\frac{\beta_0+\beta_1}{1-\phi_1}x_{t-1}\Big)$.

$$\boxed{\alpha=\phi_1-1,\qquad\theta=\frac{\beta_0+\beta_1}{1-\phi_1},\qquad\lvert\phi_1\rvert\lt1\Rightarrow\alpha\lt0}$$

É uma reparametrização: o MQO do ECM, com $\Delta y_t$ em $\Delta x_t$, $y_{t-1}$ e $x_{t-1}$, dá **exatamente** os mesmos resíduos do ARDL. Os coeficientes se relacionam por $\widehat\alpha=\widehat\phi_1-1$ e $\widehat\theta=-\widehat\gamma/\widehat\alpha$, em que $\widehat\gamma$ é o coeficiente de $x_{t-1}$. O erro padrão de $\widehat\alpha$ é o de $\widehat\phi_1$. A **meia-vida** de um desvio é $\ln0{,}5/\ln\phi_1$ períodos.

> [!CAUTION]
> **Estacionário ou I(1) muda o que o ECM significa**
> Com séries estacionárias, o ECM é só outra forma de escrever o ARDL: nada de novo. Com séries I(1), o termo $y_{t-1}-\theta x_{t-1}$ só é estacionário se $y$ e $x$ forem **cointegrados**. Aí o ECM representa uma relação de equilíbrio de verdade, e a distribuição dos testes muda (próximas aulas; Enders, cap. 6).

## 5. Causalidade de Granger

O *feedback* $\varepsilon_t\to x_{t+1}$ separa a predeterminação da exogeneidade estrita. A pergunta empírica é se o passado de $y$ ajuda a prever o futuro de $x$.

**Definição.** Seja $\Omega_t$ a informação disponível em $t$, e $\tilde\Omega_t$ a mesma informação sem o presente e o passado de $x$. Dizemos que $x$ **Granger-causa** $y$ se, para algum $h\ge1$,

$$
E\big(y_{t+h}-\widehat y_{t+h}\mid\Omega_t\big)^2\lt E\big(y_{t+h}-\widehat y_{t+h}\mid\tilde\Omega_t\big)^2 .
$$

Ou seja, o passado de $x$ melhora a previsão de $y$ além do que o passado do próprio $y$ já entrega. É um conceito de **previsibilidade**, não de causalidade econômica.

**O teste.** Estime $y_t=c+\sum_{i=1}^{p}\phi_iy_{t-i}+\sum_{j=1}^{p}\beta_jx_{t-j}+\varepsilon_t$, sem $x_t$, porque o teste é sobre o **passado** de $x$. Teste $H_0:\beta_1=\dots=\beta_p=0$ (x não Granger-causa y) com o $F$ de exclusão das $p$ defasagens. O modelo restrito é o AR($p$) de $y$.

**A direção contrária.** A exogeneidade estrita de $x$ na equação de $y$ se investiga invertendo os papéis: em $x_t=c+\sum_ic_ix_{t-i}+\sum_jd_jy_{t-j}+w_t$, teste $H_0:d_1=\dots=d_p=0$.

### D07.5 · *Feedback* de Granger é falta de exogeneidade estrita

> [!NOTE]
> **O que se quer provar**
> Se $x_t=gx_{t-1}+\gamma y_{t-1}+v_t$ e $y_t=\beta x_t+\varepsilon_t$, com $v$ e $\varepsilon$ ruídos brancos independentes, então $E(\varepsilon_tx_{t+1})=\gamma\sigma_\varepsilon^2$.

**Passo a passo.**

1. Avance um período: $x_{t+1}=gx_t+\gamma y_t+v_{t+1}=gx_t+\gamma(\beta x_t+\varepsilon_t)+v_{t+1}$.
2. Multiplique por $\varepsilon_t$ e tome a esperança. Os termos em $x_t$ somem: $x_t$ depende de $v_t$ e do passado, e não de $\varepsilon_t$ (predeterminação). $E(v_{t+1}\varepsilon_t)=0$ pela independência. Sobra $\gamma E(\varepsilon_t^2)$.

$$\boxed{E(\varepsilon_t\,x_{t+1})=\gamma\,\sigma_\varepsilon^2:\quad \gamma\ne0\iff y\text{ Granger-causa }x\iff x\text{ não é estritamente exógeno}}$$

Com $\gamma\ne0$, há *feedback*, e $x$ é no máximo predeterminado. Com $\gamma=0$, não há *feedback*, e a exogeneidade estrita fica plausível. Mas, como mostra o aviso abaixo, ela não fica provada.

**Procedimento** (AU06):

1. Verifique a estacionariedade de $y$ e $x$. Com raiz unitária, o $F$ usual pode não ter a distribuição padrão.
2. Escolha $p$ por AIC ou BIC, numa amostra comum.
3. Verifique se os resíduos são ruído branco.
4. Teste com o $F$ ou com o Wald $\chi^2_p$.
5. Faça o teste **nas duas direções**.

| $H_0$: "$x$ não Granger-causa $y$" | $H_0$: "$y$ não Granger-causa $x$" | O que se conclui |
|---|---|---|
| cai | fica | o passado de $x$ ajuda a prever $y$, e o de $y$ não ajuda a prever $x$: precedência de $x$, sem *feedback* |
| fica | cai | precedência de $y$ sobre $x$ |
| cai | cai | as duas séries se antecipam: *feedback* |
| fica | fica | os dados não mostram precedência em nenhum sentido |

> [!WARNING]
> **O teste de Granger mede precedência, não exogeneidade nem causa**
> - **Passar no teste não prova que $x$ é exógeno.** O teste olha só para o passado. Se um choque move $x$ e $y$ no mesmo período, $y$ pode não Granger-causar $x$, e $x$ ainda assim ser endógeno.
> - **Uma terceira variável** pode mover $x$ antes de mover $y$. As expectativas são o caso clássico: a curva de juros futura Granger-causa a Selic, porque o mercado antecipa o Copom, e não porque a curva decide os juros.
> - **O uso correto** é como diagnóstico de precedência temporal, para detectar *feedback* e para prever. Não serve para provar causalidade.

## 6. Checklist

- [ ] Classifico um regressor como estritamente exógeno, predeterminado ou endógeno, e digo o que isso faz com o MQO.
- [ ] Calculo os multiplicadores de um DL e de um ARDL(1,1), para choque temporário e permanente.
- [ ] Derivo $\theta=\beta(1)/\lambda(1)$ pela soma dos multiplicadores e pelo estado estacionário.
- [ ] Reescrevo um ARDL(1,1) como ECM e interpreto $\alpha$ e $\theta$.
- [ ] Mostro por que omitir $y_{t-1}$ enviesa $\widehat\beta_0$ e por que a exogeneidade estrita falha no ARDL.
- [ ] Monto o teste de Granger nas duas direções e leio a tabela dos quatro casos.
- [ ] Explico por que o Breusch-Godfrey, e não o DW, e por que HAC não salva um ARDL com resíduo autocorrelacionado.
