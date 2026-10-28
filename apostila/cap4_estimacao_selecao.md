---
title: "Apostila, cap. 4 — Estimação e seleção: o detetive e os dois juízes"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: [13, 14]
aulas: "AU02 p. 58–60, 68–71, 77–80, 88–89, 98–99"
status: verificado
verificacao:
  derivacao: ok
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Apostila cap. 4 — Estimação e seleção
---

# Capítulo 4 · Estimação e seleção: o detetive e os dois juízes

[← apostila](README.md) · anterior: [cap. 3](cap3_integrados_sarima.md) · próximo: [cap. 5](cap5_previsao.md) · questões da lista: Q13 e Q14

## Pergunta de abertura

Você ajustou três modelos à mesma série de 150 observações, e um deles tem a maior log-verossimilhança. **Ele é o melhor?** Agora acrescente parâmetros: um AR(20) sempre terá verossimilhança maior ou igual à de um AR(1), porque contém o AR(1) como caso particular. **Então "maior verossimilhança" não pode ser o critério sozinho. O que falta?**

E, antes disso, uma pergunta sobre como se chega aos números: **por que o MQO de $y_t$ contra $y_{t-1}$ dá exatamente o estimador de máxima verossimilhança do AR(1)?** E por que, para um MA(1), não existe fórmula fechada (AU02, p. 60 e 80)?

## A imagem

**A máxima verossimilhança é um detetive.** A cena do crime são os dados, e os suspeitos são os valores possíveis dos parâmetros. O detetive pergunta, para cada suspeito: "se tivesse sido você, quão provável seria esta cena?". E escolhe aquele sob o qual a cena é **menos surpreendente**. É isso que maximizar $L(\Theta)=f(y_1,\dots,y_T;\Theta)$ quer dizer.

**Condicional × exata é por onde começar a contar a história.**
- A versão **condicional** começa no segundo capítulo: trata $y_1$ como dado e explica só como cada observação nasceu da anterior.
- A versão **exata** também explica o primeiro capítulo, perguntando quão provável era $y_1$ sob o processo estacionário (AU02, p. 78–80).

Com muitos capítulos, o primeiro pesa pouco, e as duas concordam.

**Yule-Walker é copiar as correlações.** Em vez de perguntar qual parâmetro torna os dados mais prováveis, ele pergunta: qual parâmetro faz o modelo **reproduzir as correlações que eu medi**? No AR(1), isso é $\widehat\phi=\widehat\rho_1$, um método de momentos.

**AIC e BIC são dois juízes de um concurso que cobram multa por parâmetro.** Os dois dão nota pelo ajuste, $-2\ln L$, e descontam uma multa por parâmetro:
- **o AIC cobra multa fixa, 2 por parâmetro**. Ele quer o modelo que vai **prever melhor** a próxima observação;
- **o BIC cobra $\ln T$ por parâmetro**, uma multa que cresce com o tamanho da amostra. Ele quer **acertar qual é o modelo verdadeiro**.

Com $T=150$, a multa do BIC já é $\ln150=5{,}01$, duas vezes e meia a do AIC.

> [!WARNING]
> **Onde a analogia quebra**
> - **O detetive não dá a probabilidade de o suspeito ser culpado.** $L(\Theta)$ é a probabilidade dos **dados** dado o parâmetro, não a do parâmetro dado os dados. Dizer "o modelo A tem 70% de chance de ser o certo" não sai da verossimilhança.
> - **O juiz BIC só é infalível se o culpado está na fila.** A consistência do BIC supõe que o modelo verdadeiro está entre os candidatos. Se nenhum está, o que importa é prever bem, e aí o AIC é o que tem a propriedade ótima, a eficiência.
> - **A multa não é uma regra de rejeição com nível fixo.** Entre dois modelos aninhados que diferem por um parâmetro, o AIC equivale a um teste da razão de verossimilhança com valor crítico 2. Isso dá um "nível" de 15,7%, que **não cai** com $T$. É por isso que o AIC superajusta para sempre (D4.4).

## Teoria

**Verossimilhança e fatoração** (AU02, p. 77). A densidade conjunta se fatora em condicionais sucessivas:

$$
f(y_T,\dots,y_1;\Phi)=f(y_1;\Phi)\prod_{t=2}^{T}f(y_t\mid y_{t-1},\dots,y_1;\Phi),\qquad \widehat\Phi=\arg\max_\Phi\ \ln L(\Phi).
$$

**AR(1), exata e condicional** (AU02, p. 78–80).
- Na **exata**, $y_1\sim N\big(\frac{\phi_0}{1-\phi_1},\frac{\sigma^2}{1-\phi_1^2}\big)$, a distribuição incondicional, entra na conta.
- Na **condicional**, $y_1$ é tratado como fixo.
- As duas são consistentes e assintoticamente equivalentes. A exata é melhor em amostras pequenas e perto da fronteira $\lvert\phi_1\rvert\to1$.
- No AR, a condicional normal **coincide com o MQO** (D4.1).

**MA(1) e ARMA** (AU02, p. 58–60 e 88–89). A condicional fixa $\varepsilon_0=0$ e reconstrói os choques pela recursão $\varepsilon_t=y_t-\theta_0-\theta_1\varepsilon_{t-1}$. A log-verossimilhança é

$$
\ln L(\Theta)=-\frac{T}{2}\ln(2\pi)-\frac{T}{2}\ln\sigma^2-\frac{1}{2\sigma^2}\sum_{t=1}^{T}\varepsilon_t^2 .
$$

Como cada $\varepsilon_t$ depende de $\theta_1$ de forma **não linear**, através de toda a recursão, **não há solução analítica**, e a maximização é numérica. A exata usa o filtro de Kalman (AU02, p. 60).

**Yule-Walker** (AU02, p. 68–71). O estimador troca as $\rho_k$ teóricas pelas amostrais e resolve $\widehat R\,\widehat\Phi=\widehat r$. No AR(1), $\widehat\phi_{YW}=\widehat\rho_1$.

**Critérios de informação** (AU02, p. 98–99). Com $k$ parâmetros, **incluindo a variância** (como pede a Q14), e $T$ fixo:

$$
AIC=\frac{-2\ln L(\widehat\Theta)+2k}{T},\qquad BIC=\frac{-2\ln L(\widehat\Theta)+k\ln T}{T},\qquad \text{escolhe-se o menor.}
$$

- O R reporta as versões **sem** a divisão por $T$. Com o mesmo $T$, a ordenação é a mesma.
- **Nunca** compare modelos estimados com $T$ diferentes (AU02, p. 99).

**Consistência × eficiência.**
- **BIC: consistente.** Se o modelo verdadeiro está entre os candidatos, $P(\text{BIC escolhe o verdadeiro})\to1$, porque a multa $\ln T\to\infty$ elimina os modelos grandes demais.
- **AIC: eficiente.** Não é consistente, porque superajusta com probabilidade que não vai a zero. Mas minimiza o erro de previsão quando o verdadeiro é complexo demais para estar na lista.

## Demonstrações

### D4.1 · AR(1): log-verossimilhança condicional e o MQO (Q13)

$y_t=\phi y_{t-1}+\varepsilon_t$, com $\varepsilon_t\sim N(0,\sigma^2)$, condicionando em $y_1$.

$$
\begin{aligned}
\text{(1)}\quad & y_t\mid y_{t-1}\sim N(\phi y_{t-1},\sigma^2) && [\varepsilon_t \text{ normal}]\\
\text{(2)}\quad & f(y_t\mid y_{t-1})=\frac{1}{\sqrt{2\pi\sigma^2}}\exp\Big(-\frac{(y_t-\phi y_{t-1})^2}{2\sigma^2}\Big) && [\text{densidade normal}]\\
\text{(3)}\quad & \ln L(\phi,\sigma^2\mid y_1)=\sum_{t=2}^{T}\ln f(y_t\mid y_{t-1}) && [\text{fatoração, AU02 p. 80}]\\
\text{(4)}\quad & \phantom{\ln L}=-\frac{T-1}{2}\ln(2\pi)-\frac{T-1}{2}\ln\sigma^2-\frac{1}{2\sigma^2}\sum_{t=2}^{T}(y_t-\phi y_{t-1})^2 && [(2) \text{ em } (3)]\\
\text{(5)}\quad & \frac{\partial\ln L}{\partial\phi}=\frac{1}{\sigma^2}\sum_{t=2}^{T}(y_t-\phi y_{t-1})\,y_{t-1}=0 && [\text{CPO em } \phi]\\
\text{(6)}\quad & \sum_{t=2}^{T}y_ty_{t-1}=\widehat\phi\sum_{t=2}^{T}y_{t-1}^2 && [\text{distributiva}]\\
\text{(7)}\quad & \widehat\phi=\frac{\sum_{t=2}^{T}y_ty_{t-1}}{\sum_{t=2}^{T}y_{t-1}^2} && [\text{isola}]\\
\text{(8)}\quad & \frac{\partial\ln L}{\partial\sigma^2}=-\frac{T-1}{2\sigma^2}+\frac{1}{2\sigma^4}\sum_{t=2}^{T}\widehat\varepsilon_t^{\,2}=0 && [\text{CPO em } \sigma^2]\\
\text{(9)}\quad & \widehat\sigma^2=\frac{1}{T-1}\sum_{t=2}^{T}\widehat\varepsilon_t^{\,2} && [\text{multiplica por } 2\sigma^4]
\end{aligned}
$$

$$
\boxed{\widehat\phi_{MV\,cond}=\frac{\sum_{t=2}^{T}y_ty_{t-1}}{\sum_{t=2}^{T}y_{t-1}^2}=\widehat\phi_{MQO}}
$$

Em (5), só o último termo de (4) depende de $\phi$. Por que coincidem: em (4), para qualquer $\sigma^2$ fixo, maximizar $\ln L$ em $\phi$ é **minimizar** $\sum(y_t-\phi y_{t-1})^2$, que é exatamente o problema do MQO.

### D4.2 · A verossimilhança exata acrescenta o primeiro capítulo

Com média zero, $y_1\sim N\big(0,\sigma^2/(1-\phi^2)\big)$ (AU02, p. 78–79).

$$
\begin{aligned}
\text{(1)}\quad & \ln f(y_1)=-\frac12\ln(2\pi)-\frac12\ln\frac{\sigma^2}{1-\phi^2}-\frac{(1-\phi^2)\,y_1^2}{2\sigma^2} && [\text{densidade de } y_1]\\
\text{(2)}\quad & \ln L_{exata}=\ln f(y_1)+\ln L_{cond} && [\text{fatoração completa}]\\
\text{(3)}\quad & \frac{\partial\ln f(y_1)}{\partial\phi}=-\frac{\phi}{1-\phi^2}+\frac{\phi\,y_1^2}{\sigma^2} && [\text{derivada; } \partial\ln(1-\phi^2)/\partial\phi=-2\phi/(1-\phi^2)]\\
\text{(4)}\quad & \text{CPO: } \frac{1}{\sigma^2}\sum_{t=2}^{T}(y_t-\phi y_{t-1})y_{t-1}-\frac{\phi}{1-\phi^2}+\frac{\phi\,y_1^2}{\sigma^2}=0 && [(2),(3), \text{D4.1(5)}]\\
\text{(5)}\quad & \text{o termo } \frac{\phi}{1-\phi^2} \text{ torna (4) não linear em } \phi && [\text{sem fórmula fechada}]\\
\text{(6)}\quad & \text{(1) é um termo só, contra } T-1 \text{ termos em } \ln L_{cond} && [\text{peso } O(1/T)]
\end{aligned}
$$

$$
\boxed{\ln L_{exata}=\ln f(y_1)+\ln L_{cond}:\ \text{solução numérica, assintoticamente igual à condicional}}
$$

Em (1), $-\frac12\ln\frac{\sigma^2}{1-\phi^2}=-\frac12\ln\sigma^2+\frac12\ln(1-\phi^2)$, e o último termo vai a $-\infty$ quando $\lvert\phi\rvert\to1$. A verossimilhança exata **pune** estimativas na fronteira, e o termo $-\frac{\phi}{1-\phi^2}$ em (4) empurra $\widehat\phi$ para dentro da região estacionária. É por isso que a exata se comporta melhor perto da fronteira (AU02, p. 80).

### D4.3 · Yule-Walker no AR(1) e a diferença para o MQO

$$
\begin{aligned}
\text{(1)}\quad & \rho_1=\phi && [\text{cap. 2, D2.4}]\\
\text{(2)}\quad & \widehat\rho_1=\frac{\widehat\gamma_1}{\widehat\gamma_0}=\frac{\frac1T\sum_{t=2}^{T}y_ty_{t-1}}{\frac1T\sum_{t=1}^{T}y_t^2} && [\text{AU02, p. 71, média zero}]\\
\text{(3)}\quad & \widehat\phi_{YW}=\widehat\rho_1=\frac{\sum_{t=2}^{T}y_ty_{t-1}}{\sum_{t=1}^{T}y_t^2} && [\text{troca teórico por amostral}]\\
\text{(4)}\quad & \text{MQO: denominador } \sum_{t=2}^{T}y_{t-1}^2=\sum_{t=1}^{T-1}y_t^2 && [\text{D4.1(7)}]\\
\text{(5)}\quad & \text{YW: denominador } \sum_{t=1}^{T}y_t^2=\sum_{t=1}^{T-1}y_t^2+y_T^2 && [\text{um termo a mais}]\\
\text{(6)}\quad & \lvert\widehat\phi_{YW}\rvert\le\lvert\widehat\phi_{MQO}\rvert && [\text{denominador maior}]
\end{aligned}
$$

$$
\boxed{\widehat\phi_{YW}=\widehat\rho_1:\ \text{mesmo numerador do MQO, denominador com } y_T^2 \text{ a mais; diferença } O(1/T)}
$$

### D4.4 · Por que o BIC é consistente e o AIC não

Compare o modelo pequeno, verdadeiro e com $k$ parâmetros, com um grande, que tem $k+1$ e contém o pequeno. Seja $LR=2(\ln L_{grande}-\ln L_{pequeno})\ge0$.

$$
\begin{aligned}
\text{(1)}\quad & AIC_{grande}\lt AIC_{pequeno}\iff -2\ln L_g+2(k+1)\lt-2\ln L_p+2k && [\text{definição, sem }\div T]\\
\text{(2)}\quad & \phantom{AIC_{grande}\lt AIC_{pequeno}}\iff LR\gt2 && [\text{rearranja}]\\
\text{(3)}\quad & BIC_{grande}\lt BIC_{pequeno}\iff LR\gt\ln T && [\text{mesma conta, multa } \ln T]\\
\text{(4)}\quad & \text{sob o modelo pequeno verdadeiro: } LR\ \xrightarrow{d}\ \chi^2(1) && [\text{teste LR, 1 restrição}]\\
\text{(5)}\quad & P(\text{AIC superajusta})\to P\big(\chi^2(1)\gt2\big)=0{,}157\gt0 && [(2),(4)]\\
\text{(6)}\quad & P(\text{BIC superajusta})=P(LR\gt\ln T)\to0 && [\ln T\to\infty,\ LR=O_p(1)]
\end{aligned}
$$

$$
\boxed{\text{AIC} \equiv \text{teste LR com crítico fixo 2 (nível} \approx15{,}7\%\text{)};\qquad \text{BIC} \equiv \text{crítico } \ln T\to\infty:\ \text{consistente}}
$$

Escolher um modelo pequeno demais, ao contrário, é punido pelos **dois**: o $LR$ cresce como $T$ quando o parâmetro omitido é diferente de zero, e vence qualquer multa.

## Exemplo

**1. Os três estimadores do AR(1)**, numa série simulada com $\phi=0{,}6$ e $T=200$:

| Estimador | Fórmula | $\widehat\phi$ |
|---|---|---|
| MQO (= MV condicional) | D4.1(7) | 0,6537 (o `lm` dá o mesmo) |
| Yule-Walker | D4.3(3) | 0,6487 (o `ar.yw` dá o mesmo) |
| MV exata | numérica | 0,6620 |

Os três diferem só na terceira casa: são assintoticamente equivalentes. O YW fica abaixo do MQO, como previsto em D4.3(6). A variância estimada pelo MQO é $\widehat\sigma^2=1{,}0491$.

**2. A Q14**, com $T=150$, $k=3$ nos três modelos e $\ln150=5{,}0106$:

| Modelo | $\ln L$ | AIC (slides) | BIC (slides) | AIC (R) | BIC (R) |
|---|---|---|---|---|---|
| ARMA(1,1) | $-210{,}3$ | **2,8440** | **2,9042** | 426,6 | 435,63 |
| ARMA(2,0) | $-212{,}8$ | 2,8773 | 2,9375 | 431,6 | 440,63 |
| ARMA(0,2) | $-214{,}1$ | 2,8947 | 2,9549 | 434,2 | 443,23 |

**Os dois escolhem o ARMA(1,1).** Com o **mesmo $k$**, a multa é igual para os três, e decide só a verossimilhança. A diferença entre AIC e BIC só pesaria se os modelos tivessem números diferentes de parâmetros.

**3. Os dois juízes em ação**, em mil simulações de um AR(1) verdadeiro com $\phi=0{,}5$, comparado com um AR(2):

| $T$ | AIC escolhe o AR(2) | BIC escolhe o AR(2) |
|---|---|---|
| 150 | 15,7% | 3,2% |
| 2000 | 12,4% | 0,6% |

A teoria da D4.4 prevê, para o AIC, $P(\chi^2(1)\gt2)=0{,}1573$ **em qualquer** $T$, e a simulação confirma: o AIC não melhora com mais dados. O BIC vai a zero.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| ap_c4_phi_mqo | 0,6537 |
| ap_c4_phi_mqo_lm | 0,6537 |
| ap_c4_phi_yw | 0,6487 |
| ap_c4_phi_yw_r | 0,6487 |
| ap_c4_phi_exata | 0,6620 |
| ap_c4_s2_mqo | 1,0491 |
| ap_c4_q14_aic1 | 2,8440 |
| ap_c4_q14_bic1 | 2,9042 |
| ap_c4_q14_aicR1 | 426,6 |
| ap_c4_q14_bicR1 | 435,63 |
| ap_c4_q14_aic2 | 2,8773 |
| ap_c4_q14_bic2 | 2,9375 |
| ap_c4_q14_aicR2 | 431,6 |
| ap_c4_q14_bicR2 | 440,63 |
| ap_c4_q14_aic3 | 2,8947 |
| ap_c4_q14_bic3 | 2,9549 |
| ap_c4_q14_aicR3 | 434,2 |
| ap_c4_q14_bicR3 | 443,23 |
| ap_c4_lnT | 5,0106 |
| ap_c4_sob_aic_150 | 0,157 |
| ap_c4_sob_bic_150 | 0,032 |
| ap_c4_sob_aic_2000 | 0,124 |
| ap_c4_sob_bic_2000 | 0,006 |
| ap_c4_sob_aic_teorico | 0,1573 |
-->

## Cadeia socrática

**P1.** Na D4.1, por que a CPO em $\phi$ não depende de $\sigma^2$?

> [!TIP]
> **Resposta**
> Porque $\sigma^2$ só multiplica a soma de quadrados, e a CPO iguala essa derivada a zero: o fator $1/\sigma^2$ sai. É por isso que $\widehat\phi$ sai antes, pelo MQO, e $\widehat\sigma^2$ vem depois, dos resíduos.

**P2.** No MA(1), por que a mesma conta não tem fórmula fechada?

> [!TIP]
> **Resposta**
> Porque $\varepsilon_t=y_t-\theta_0-\theta_1\varepsilon_{t-1}$ depende de $\theta_1$ através de **toda** a recursão: $\varepsilon_t$ é um polinômio de grau $t-1$ em $\theta_1$. A soma de quadrados não é quadrática em $\theta_1$, e a CPO não se resolve à mão (AU02, p. 60).

**P3.** Por que o MA precisa ser invertível para a verossimilhança condicional funcionar bem?

> [!TIP]
> **Resposta**
> Porque a recursão parte de um chute, $\varepsilon_0=0$. O erro desse chute se propaga com peso $(-\theta_1)^t$: some se $\lvert\theta_1\rvert\lt1$ e explode se não. Além disso, sem a restrição, $\theta$ e $1/\theta$ dão verossimilhanças iguais, e o máximo não é único (cap. 2, D2.3).

**P4.** Se a exata e a condicional são assintoticamente equivalentes, quando a diferença importa?

> [!TIP]
> **Resposta**
> Em amostras pequenas e com $\lvert\phi\rvert$ perto de 1. Aí $y_1$ carrega muita informação, porque a variância incondicional $\sigma^2/(1-\phi^2)$ é enorme, e a exata a aproveita (D4.2).

**P5.** Na Q14, AIC e BIC concordaram. Isso sempre acontece?

> [!TIP]
> **Resposta**
> Não. Concordaram porque os três modelos têm o mesmo $k=3$, e as multas se cancelam. Com $k$ diferentes, o BIC, de multa $\ln150\approx5$, tende a escolher o menor modelo, e o AIC, de multa 2, o maior.

**P6.** Se o AIC superajusta para sempre, por que alguém o usaria?

> [!TIP]
> **Resposta**
> Porque superajustar com **um parâmetro a mais, de valor perto de zero** custa pouco na previsão, e subajustar custa muito. Quando o processo verdadeiro é um ARMA de ordem infinita, ou não está na lista, não há "modelo verdadeiro" a acertar, e o AIC é o que minimiza o erro de previsão: a eficiência.

**P7.** Posso comparar o AIC de um ARMA(1,1) em $y_t$ com o de um ARMA(1,1) em $\Delta y_t$?

> [!TIP]
> **Resposta**
> Não. As séries são diferentes, e o $T$ efetivo também, porque se perde uma observação. A verossimilhança de uma série não é comparável com a de outra. A regra da AU02, p. 99, é: mesmo $T$, mesma variável dependente.

**P8.** O $k$ da Q14 inclui $\sigma^2$. E se eu esquecer de incluí-lo?

> [!TIP]
> **Resposta**
> Todos os modelos perdem 1 em $k$, e a **ordenação não muda**: a multa cai igual para todos. Mas o valor numérico do AIC e do BIC muda, e numa prova de conta isso é erro. Siga o enunciado: $k=p+q+1$ com média zero e $p+q+2$ com média (AU02, p. 99).

## Diálogo

*Sobre "o BIC é melhor porque é consistente".*

**Aluno:** O BIC é consistente, e o AIC não. Então o BIC é sempre melhor.

**Professor:** Consistente para quê, exatamente?

**Aluno:** Para escolher o modelo verdadeiro quando $T$ cresce.

**Professor:** E qual é a hipótese escondida nessa frase?

**Aluno:** … Que o modelo verdadeiro está entre os candidatos.

**Professor:** A inflação brasileira é exatamente um ARMA(1,1)?

**Aluno:** Provavelmente não. É algo mais complicado, e o ARMA é uma aproximação.

**Professor:** Então o que significa "acertar o modelo verdadeiro" nesse caso?

**Aluno:** Nada: não tem verdadeiro na lista. Aí a pergunta útil é qual aproxima melhor para prever.

**Professor:** E qual critério tem a propriedade ótima para isso?

**Aluno:** O AIC, a eficiência. Então a regra não é "um é melhor". É: se o objetivo é **identificar** a estrutura, uso o BIC; se é **prever**, o AIC. E, se os dois concordam, como na Q14, a escolha é robusta.

**Professor:** E na prova, se o enunciado só pede "qual cada um seleciona"?

**Aluno:** Calculo os dois com o mesmo $T$, digo o vencedor de cada um e, na discussão, explico as multas, $2$ contra $\ln T$, e as propriedades assintóticas.

## Na prova

**A folha de caderno do bloco** está em [a_mao_cap4.md](a_mao_cap4.md): Q13 e Q14 em 43 linhas numeradas, cada uma com a justificativa, mais a versão para a prova e a conferência em R.

| Questão | O que este capítulo dá | Resolução completa |
|---|---|---|
| Q13 | log-verossimilhança condicional do AR(1) e o MQO de $\phi$ | [Q13](../lista_comentada/q13.md) |
| Q14 | AIC e BIC de três modelos com $T=150$; consistência × eficiência | [Q14](../lista_comentada/q14.md) |

**Armadilhas:**
- na Q13, somar de $t=1$, quando a condicional começa em $t=2$ e tem $T-1$ termos;
- esquecer de derivar $\widehat\sigma^2$ ou dividir por $T$ em vez de $T-1$, quando se condiciona em $y_1$;
- na Q14, usar $k=2$ em vez de 3, ignorando a variância, ou trocar o sinal de $\ln L$: o menor critério vence;
- dizer que "o BIC sempre escolhe o modelo menor": ele **tende** a escolher, e só quando os $k$ diferem.

**Checklist de 30 segundos:**
1. A condicional começa em $t=2$?
2. Escrevi as duas CPOs, para $\phi$ e para $\sigma^2$?
3. Calculei AIC e BIC com o mesmo $T$ e o mesmo $k$ do enunciado?
4. Disse "menor vence" e qual foi o escolhido por **cada** critério?
5. Expliquei 2 × $\ln T$ e consistência × eficiência, com a hipótese de o verdadeiro estar na lista?

## No material do professor

**Roteiro de releitura:**
- AU02, p. 58–60: verossimilhança condicional do MA(1) e o método exato;
- AU02, p. 68–71: Yule-Walker e a FAC amostral;
- AU02, p. 77–80: MV exata e condicional do AR(1);
- AU02, p. 88–89: verossimilhança condicional do ARMA(1,1);
- AU02, p. 96–99: identificação e critérios de informação.

**Livros:**
- **HAMILTON**, cap. 5: a verossimilhança exata e condicional do AR e do MA, com todas as contas;
- **ENDERS**, cap. 2: critérios de informação no nível do curso;
- **BJRL**, cap. 7: estimação e a convenção de sinal da lista.

**Na lista comentada:** [Q13](../lista_comentada/q13.md) · [Q14](../lista_comentada/q14.md).
