---
title: "Auditoria final — o quadro, as quatro questões e a lista, ligados pelo fio"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
prova: "05/11/2026"
lista: LST
status: verificado
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Auditoria final da P1
---

# Auditoria final: o quadro, as quatro questões e a lista

Esta é a última conferência antes da prova. Ela cruza três coisas:
- **o quadro do professor** (04/11);
- **as quatro questões prováveis** da [folha do que cai](o_que_cai.md);
- **a lista** "Processos ARMA, ARIMA e SARIMA", Q1 a Q16.

Para cada questão provável, o **fio** é a ordem exata de leitura entre os materiais, sempre por resoluções linha a linha. A auditoria também achou duas divergências entre o quadro e a lista, e elas já estão corrigidas na folha.

## 1. A lista inteira contra o quadro

| Lista | O que pede | No quadro | Questão provável | Onde está linha a linha |
|---|---|---|---|---|
| Q1 | passeio com drift: $E$, $V$, $\operatorname{Cov}$, estacionário? | passeio; $E$, $V$, $\operatorname{Cov}$ | A | guia, QT1; [Q1 comentada](../lista_comentada/q01.md) |
| Q2 | drift e tendência determinística | passeio | A | [Q2 comentada](../lista_comentada/q02.md) |
| Q3 | $z_3=z_1+2z_2$: autocovariância e classe | **circulado** | A | guia, QT2; [Q3 comentada](../lista_comentada/q03.md) |
| Q4 | Wold | não | — | [Q4 comentada](../lista_comentada/q04.md), em 1 minuto |
| Q5 | operador $B$, raízes, invertibilidade, fator comum | "verificar se é estacionário" | B | guia, QT3; [Q5 comentada](../lista_comentada/q05.md) |
| Q6 | ARMA(1,1): $\gamma_0$, $\gamma_1$, FAC, pesos | "montar a FAC" | B | guia, QT4; [Q6 comentada](../lista_comentada/q06.md) |
| Q7 | AR(2) e Yule-Walker | **riscado** | — | não cai |
| Q8 | afirmativas sobre dois modelos com tendência | passeio | A | [Q8 comentada](../lista_comentada/q08.md) |
| Q9 | AR(1) diferenciado (sobrediferenciação) | — | B ou D | guia, QT6; [Q9 comentada](../lista_comentada/q09.md) |
| Q10 | ARIMA, TS × DS | Dickey-Fuller (falado) | D | folha, §9–10; [Q10 comentada](../lista_comentada/q10.md) |
| Q11 | SAR(1)$_4$: $\gamma_k$, FAC, FACP, AR(5) restrito | **SMA(1)$_4$ desenhado** | C | folha, §4; [Q11 comentada](../lista_comentada/q11.md) |
| Q12 | SARIMA$(1,1,0)(0,1,1)_4$: modelo, perdas, previsão, diagnóstico | equação de previsão; ciclo | C | folha, §5; [Q12 comentada](../lista_comentada/q12.md) |
| Q13 | MV condicional do AR(1) | não | — | guia, QT7; [Q13 comentada](../lista_comentada/q13.md) |
| Q14 | AIC e BIC | **interpretar** | D | folha, §7; [Q14 comentada](../lista_comentada/q14.md) |
| Q15 | previsão em ARMA | **previsão** (anunciada) | C | guia, QT8; [Q15 comentada](../lista_comentada/q15.md) |
| Q16 | SARIMA mensal: modelo, parâmetros, FAC, critério | ARIMA, SARIMA; ordem pela FAC | C e D | guia, QT9; folha, §8; [Q16 comentada](../lista_comentada/q16.md) |

**A leitura da matriz:**
- **12 das 16 questões estão no quadro.**
- Fora dele ficam Q4 (Wold), Q7 (riscada), Q13 (MV condicional) e, em parte, Q8.
- As duas divergências da auditoria estão nas linhas Q11 e Q12.

## 2. As duas divergências, já corrigidas na folha

1. **O SMA do quadro contra o SAR da lista (Q11).**
   - O quadro desenhou o SMA(1)$_4$: a FAC com um pico em 4, a FACP decaindo em 4, 8 e 12.
   - A Q11 da lista pede o SAR(1)$_4$, que é o espelho: a FAC decai em 4, 8 e 12, e a FACP tem um pico em 4.
   - A folha agora tem os dois, linha a linha: o SMA na §4 e o "Da lista (Q11)" logo depois.
   - **Na prova, leia o modelo antes de desenhar.** $\Phi y_{t-4}$ do lado de $y$ é SAR; $\Theta a_{t-4}$ do lado do choque é SMA.
2. **O $(0,1,1)(0,1,1)_4$ da folha contra o $(1,1,0)(0,1,1)_4$ da lista (Q12).**
   - A folha fazia a previsão do modelo com MA comum. A Q12 tem AR comum.
   - Muda o lado AR: são três polinômios, $1-(1+\phi)B+\phi B^2-B^4+(1+\phi)B^5-\phi B^6$.
   - Muda também até onde vão os resíduos: até $h=4=s$, e não até $h=5=s+1$.
   - A folha agora tem o "Da lista (Q12)" com $\widehat y(1)$, $\widehat y(2)$, $\widehat y(4)$ e $\widehat y(5)$, ligado à nota comentada, que traz o diagnóstico de resíduos da Q12 (d).

Também foram conferidos todos os links de `prova/` e de `lista_comentada/`, inclusive as âncoras. Havia um quebrado, no banco, e ele foi corrigido.

## 3. As quatro questões prováveis e o fio de cada uma

### Questão provável A: processos (Q1, Q2, Q3 e Q8)

**O fio:**
1. [Guia, QT1](nao_posso_errar.md): as linhas (1) a (11) do passeio com drift, cobrindo e tentando.
2. [Q1 comentada](../lista_comentada/q01.md): a mesma conta no sinal dos slides, com o seu caderno de 19/08.
3. [Q2 comentada](../lista_comentada/q02.md): a tendência $\delta t$ entra como $\delta\,t(t+1)/2$ na média.
4. [Guia, QT2](nao_posso_errar.md): o $z_3=z_1+2z_2$, com os números da lista.
5. [Q3 comentada](../lista_comentada/q03.md): os quatro produtos da covariância.
6. [Simulado 05, Q1](simulado_05_gabarito.md): o formato anunciado, com $z_3=z_1+2z_2$ e números novos.

**As linhas que não podem faltar:**
- a soma telescópica até $y_t=y_0+ct+\sum u_s$;
- $E$ entrando na soma **finita**;
- $V(y_t)=E\big((\sum u_s)^2\big)$, **com o $E$**;
- a covariância pelos choques comuns, que dá $(t-k)\sigma^2$;
- em $z_3$: os quatro produtos, os cruzados zerados **citando "não correlacionados"**, e o **4** que vem de $2^2$.

**A torção provável:** a constante pode multiplicar $z_1$ em vez de $z_2$, e então quem sai ao quadrado muda. A classificação é pela FAC que **corta**: MA(2), nunca ARMA(1,2).

**Frase de fecho:** "a variância depende de $t$: não estacionário"; e "$\gamma_3(k)$ não depende de $t$ e corta depois de 2: estacionário, MA(2)".

### Questão provável B: ARMA (Q5, Q6 e Q9)

**O fio:**
1. [Folha, §2](o_que_cai.md): o AR(1) $(1-\phi B)Y_t=u_t$ do quadro, nas linhas (1) a (15), com a raiz, a média, o auxiliar, $\gamma_0$ a $\gamma_3$, $\rho_k$ e a FACP.
2. [Guia, QT3](nao_posso_errar.md): as raízes por Bhaskara e o fator comum.
3. [Guia, QT4](nao_posso_errar.md): o ARMA(1,1) nos quatro movimentos, com a linha (6) auditada (os dois 0,3).
4. [Q6 comentada](../lista_comentada/q06.md): a mesma conta no sinal dos slides.
5. [Q5 comentada](../lista_comentada/q05.md): os modelos da lista em $B$.
6. [Simulado 05, Q2](simulado_05_gabarito.md): $\phi=-0{,}5$, com a FAC alternada.

**As linhas que não podem faltar:**
- a raiz de **um número** $x$, fora do círculo;
- $\gamma_0=E(y_t^2)$, que é **a variância**;
- a multiplicação por $y_t$ e por $y_{t-1}$, com a causalidade citada;
- o sistema resolvido;
- $\rho_k$ com os três primeiros números escritos;
- **o desenho**, com as barras numeradas e o padrão em palavras;
- a FACP.

**A torção provável:** o sinal de $\phi$ negativo, que faz a FAC alternar; ou um ARMA(1,1) com $\sigma^2\ne1$, em que o $\sigma^2$ entra nos auxiliares.

**Frase de fecho:** "raiz fora do círculo: estacionário. $\rho_k=\phi^k$: a FAC decai e a FACP corta em 1".

### Questão provável C: SARIMA e previsão (Q11, Q12, Q15 e Q16)

**O fio:**
1. [Folha, §4](o_que_cai.md): o SMA(1)$_4$ do quadro à força bruta, nas linhas (1) a (14), seguido do "Da lista (Q11)", o SAR(1)$_4$.
2. [Q11 comentada](../lista_comentada/q11.md): o SAR completo e o AR(5) restrito.
3. [Folha, §5](o_que_cai.md): a previsão do $(0,1,1)(0,1,1)_4$ nas linhas (1) a (13), seguida do "Da lista (Q12)", o $(1,1,0)(0,1,1)_4$.
4. [Q12 comentada](../lista_comentada/q12.md): as previsões conferidas no R e o diagnóstico de resíduos.
5. [Guia, QT8](nao_posso_errar.md): a previsão do AR(1), com erro, variância e intervalo de 95%.
6. [Guia, QT9](nao_posso_errar.md) e [Q16 comentada](../lista_comentada/q16.md): as perdas $d+sD$, os parâmetros $p+q+P+Q+1$, a FAC com satélites.

**As linhas que não podem faltar:**
- cada produto de polinômios expandido;
- o modelo escrito **na data futura** antes de prever;
- as três regras: o que é conhecido fica, o choque futuro vira 0, o $y$ futuro vira a sua previsão;
- até que $h$ vão os resíduos;
- o intervalo $\widehat y\pm1{,}96\sqrt{\operatorname{Var}}$, com a **raiz** da variância.

**A torção provável:** SMA no lugar de SAR, ou o contrário; o MA comum trocado por AR comum; $s=4$ em vez de 12.

**Frase de fecho:** "FAC com um pico só em $s$ e FACP decaindo em $s,2s,3s$: SMA(1)$_s$"; e "os resíduos entram até a maior defasagem do MA".

### Questão provável D: ciclo, análise e raiz unitária (Q10, Q12 (d), Q14 e Q16 (d))

**O fio:**
1. [Folha, §6](o_que_cai.md): o ciclo de Box-Jenkins em quatro etapas e a seta de volta.
2. [Folha, §7](o_que_cai.md): AIC, BIC, RMSE e MAPE nas linhas (1) a (10), sem conta.
3. [Q14 comentada](../lista_comentada/q14.md): AIC e BIC calculados, mais consistência e eficiência.
4. [Folha, §8](o_que_cai.md): a ordem pela FAC amostral, barra contra banda.
5. [Folha, §9 e §10](o_que_cai.md): a regressão do Dickey-Fuller, nas linhas (1) a (9), e a cadeia nos casos e no INPC, nas linhas (1) a (21).
6. [Q10 comentada](../lista_comentada/q10.md): TS × DS, ou seja, quando diferenciar e quando tirar a tendência.
7. [Simulado 05, Q4 e questão extra](simulado_05_gabarito.md): a tabela de critérios e a cadeia do Dickey-Fuller.

**As linhas que não podem faltar:**
- em cada critério, **quem vence e por quanto**;
- a regra do 2 (diferença menor que 2 é empate);
- por que AIC e BIC discordam: a multa de 2 contra a de $\ln T$;
- dentro × fora da amostra, e a decisão pela parcimônia e pela previsão;
- no Dickey-Fuller: **começar pelo modelo 3**; a regra de $\tau$ (menor rejeita) e de $\phi$ (maior rejeita); diferenciar até rejeitar para achar o $d$.

**A torção provável:** a tabela vem sem $T$, ou só com AIC; o Dickey-Fuller vem com críticos de outro $T$ (use os do enunciado); ou a série é TS, e não se diferencia.

**Frase de fecho:** "escolho o modelo X: o BIC o prefere, o AIC empata e ele tem o menor erro fora da amostra"; e "como $\tau$ é maior que o crítico, não rejeito: a série tem raiz unitária e deve ser diferenciada".

## 4. Os 30 minutos antes da prova

1. **5 minutos:** as camadas 1 e 2 do [básico](basico.md), as definições e as contas de uma linha.
2. **10 minutos:** só as **frases de fecho** da [folha](o_que_cai.md), seções 2, 4, 5, 7, 8 e 10, e as duas divergências da seção 2 acima.
3. **5 minutos:** de cabeça, as linhas (1) a (7) da QT4 do [guia](nao_posso_errar.md), os quatro movimentos do ARMA(1,1).
4. **5 minutos:** a cadeia do Dickey-Fuller da [folha, §9](o_que_cai.md), os cinco passos e os críticos.
5. **Na prova:**
   1. 3 minutos de leitura, marcando o sinal do MA, o $T$ e o $s$, e lendo **SAR ou SMA**;
   2. as contas curtas primeiro;
   3. as derivações depois;
   4. a frase de fecho em cada item.
