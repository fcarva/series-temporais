---
title: "Lista 01 — auditoria do PDF da dupla (versão de 33 páginas)"
disciplina: Econometria II (PPGEco/UFES)
periodo: 2026
lista: LST01
status: rascunho
tags:
  - series-temporais
  - mestrado/ppgeco
  - trabalho
aliases:
  - Auditoria do PDF da dupla
---

# Auditoria do PDF da dupla: o que está errado e o que é só discussão

Esta auditoria cobre o PDF `lista_avaliativa_econometria2.pdf`, de 33 páginas, de Patrick e Felipe. Ele modela a **variação mensal do INPC** de jan/2013 a set/2026 (165 meses), com $d=D=0$ e o modelo **M1 = SARIMA(1,0,0)(1,0,0)$_{12}$**. A [revisão anterior](revisao.md) tratava de uma versão sem as Q5 a Q7. Esta versão já traz as três.

Duas restrições valem para tudo o que segue: **o modelo não muda** (o próprio enunciado proíbe, Q7f), e **a análise do índice não entra**. Todos os números abaixo foram reproduzidos em R com `dados/inpc.csv`, e os do PDF batem até a quarta casa ($\tau_3=-5{,}202$, AIC do M1 $=128{,}65$, RMSE do M1 no esquema 1 $=0{,}3877$).

## 1. A pergunta central: "o modelo não previu nada" é um erro?

**Não é um erro. É a teoria funcionando, e é também um resultado conhecido da literatura.** O que falta no PDF é dizer isso com números.

### O que aconteceu

A previsão de origem fixa (esquema 1) fica praticamente plana em torno de $0{,}47\%$ a.m. desde o primeiro mês. No treino (até set/2024), o modelo estimado é $\widehat\phi=0{,}565$, $\widehat\Phi=0{,}109$ e $\widehat\mu=0{,}473$. A previsão é

$$
\widehat y_{T_0+h\mid T_0}-\widehat\mu=\text{(termos que decaem como }0{,}565^h\text{ e }0{,}109^{h/12}\text{)},
$$

e como o último dado do treino ($0{,}48$ em set/2024) já estava colado na média, não havia nada para propagar. **Num processo estacionário, a previsão de muitos passos converge para a média incondicional.** É exatamente isso que a Q7(b) mostra.

### A prova de que o M1 é, na prática, "a média"

Basta acrescentar um benchmark que o enunciado não pede, a **média do treino** ($\widehat y=0{,}470$ para todo $h$):

| Previsor | RMSE | MAE | MASE | Viés (ME) |
|---|---|---|---|---|
| M1, esquema 1 | 0,388 | 0,303 | 0,73 | $-0{,}084$ |
| M1, esquema 2 | 0,410 | 0,298 | 0,72 | $-0{,}027$ |
| Passeio aleatório, esquema 1 | 0,399 | 0,309 | 0,75 | $-0{,}096$ |
| Passeio aleatório, esquema 2 | 0,516 | 0,362 | 0,87 | $+0{,}014$ |
| Sazonal ingênuo, esquema 1 | **0,317** | **0,247** | **0,60** | $+0{,}049$ |
| Sazonal ingênuo, esquema 2 | 0,366 | 0,290 | 0,70 | $+0{,}008$ |
| Média do treino (extra) | 0,397 | 0,308 | 0,74 | $-0{,}086$ |

O MASE usa como escala o erro médio absoluto do sazonal ingênuo dentro do treino (Hyndman e Koehler, 2006). O M1 do esquema 1 erra quase o mesmo que a média histórica ($0{,}388$ contra $0{,}397$). O desvio-padrão da própria série na validação é $0{,}396$. Ou seja, **o conteúdo preditivo do M1 além da média está todo no primeiro ou segundo passo**, e mesmo ali é pequeno.

### Por que isso é um resultado, e não um defeito

1. **É o que a teoria prevê.** Para um ARMA estacionário, o erro de previsão converge para a variância incondicional quando $h$ cresce. Com $\widehat\phi\approx0{,}5$, a memória do AR some em cerca de três meses.
2. **É o que a literatura de inflação encontra.** Atkeson e Ohanian (2001) mostram que, nos EUA, modelos não batem uma regra ingênua para a inflação. Stock e Watson (2007) explicam isso pela queda da parte previsível da inflação. Faust e Wright (2013), no *Handbook of Economic Forecasting*, concluem que os melhores previsores de inflação são as pesquisas de expectativas e benchmarks simples, não modelos univariados. No Brasil, o equivalente é o boletim Focus.
3. **Os erros grandes vêm de choques que nenhum modelo univariado prevê.** O único mês fora do intervalo de 95% é **fev/2025** ($1{,}48\%$), quando a energia elétrica voltou ao normal depois do **bônus de Itaipu** creditado na conta de jan/2025 (mês em que o INPC foi $0{,}00\%$). São preços administrados, decididos fora da dinâmica passada da inflação. Os outros *outliers* da amostra têm a mesma natureza: jun/2018 (greve dos caminhoneiros) e jul–set/2022 (teto do ICMS sobre combustíveis e energia, LC 194/2022).
4. **O esquema 2 piora o M1 por causa desses choques.** Depois de fev/2025, o AR(1) com $\widehat\phi>0$ prevê que a inflação alta continue ($0{,}99$ para mar/2025), mas o choque era transitório e o dado veio $0{,}51$. Um modelo de persistência positiva erra justamente nos choques que se revertem. Por isso o RMSE do M1 no esquema 2 ($0{,}410$) é *maior* que no esquema 1 ($0{,}388$), embora o MAE seja menor ($0{,}298$ contra $0{,}303$): poucos erros grandes dominam o RMSE.

### Uma discussão econômica legítima: a média mudou

O viés (ME, observado menos previsto) é negativo em todos os previsores que puxam para a média do treino ($-0{,}084$ no M1): eles **superestimaram** a inflação. A média da validação foi $0{,}384\%$ a.m., contra $0{,}470\%$ no treino. As médias anuais da amostra vão de $0{,}17$ (2017) a $0{,}90$ (2015). Isso conversa com uma questão aberta na economia: **a inflação tem média constante ou uma "tendência" que se move?** Stock e Watson (2007) modelam a inflação dos EUA com uma tendência de passeio aleatório. No Brasil, o argumento a favor da média que se move é institucional: a meta caiu de 4,5% a.a. (até 2018) para 3% a.a. (desde 2024). Com meta crível, a média para onde a previsão converge deveria ser a da meta, não a média histórica da amostra.

Isso **não** obriga a mudar o modelo, e o enunciado proíbe mudá-lo. Mas é a discussão que transforma "perdemos para o ingênuo" em uma resposta de pós-graduação. Os testes de raiz unitária rejeitam com folga e o DF-GLS bem especificado também rejeita (ver Q2d abaixo), então $d=0$ continua defensável. O ponto é que, numa janela de 24 meses, a média amostral de 2013–2024 não é a média do regime de 2025–2026.

### As diferenças nem são significativas

Com 24 observações, o teste de Diebold e Mariano (perda quadrática) **não rejeita a igualdade de acurácia** em nenhuma comparação a 5%:

| Comparação | p-valor do DM |
|---|---|
| M1 × sazonal ingênuo, esquema 1 | 0,24 |
| M1 × sazonal ingênuo, esquema 2 | 0,62 |
| M1 × passeio aleatório, esquema 1 | 0,07 |
| M1 × passeio aleatório, esquema 2 | 0,06 |

Um cuidado: o `dm.test()` usa `h = 1` por padrão. Isso está certo para o esquema 2, mas não para o esquema 1. Lá, os erros vêm todos da mesma origem e são autocorrelacionados entre horizontes, o que pede uma variância robusta (`varestimator = "bartlett"`). Refeito assim, M1 × sazonal ingênuo dá $ppprox0{,}30$ e M1 × passeio aleatório fica entre $0{,}08$ ($h=3$) e $0{,}18$ ($h=12$). Vale citar no texto qual `h` foi usado.

A conclusão correta para a Q7(f) é então: **o M1 bate o passeio aleatório nos dois esquemas e perde para o sazonal ingênuo nos dois, mas nenhuma diferença é significativa a 5%.** A vantagem sobre o passeio aleatório é frágil: chega a 10% só no esquema 2.

## 2. Erros que precisam ser corrigidos (Q5 a Q7, novos nesta versão)

| Onde | O que o PDF diz | O problema | Correção |
|---|---|---|---|
| Q5(a) | legenda "Verificação da estabilidade e invertibilidade dos modelos candidatos" | a figura é dos **resíduos** do M1, e a legenda é de outra figura | "Diagnóstico dos resíduos do M1" |
| Q5(a) | mostra a FAC dos resíduos, mas **não a FACP** | o enunciado pede as duas | acrescentar `Pacf(res, lag.max = 24)`. Só o lag 20 sai da banda, o que é esperado por acaso em 24 lags |
| Q5(e) | "os novos coeficientes não são estatisticamente significativos" | o PDF mostra só `coef()`, sem erro-padrão; a afirmação fica sem prova | mostrar `lmtest::coeftest()`: $\widehat\phi_2=0{,}127$ ($t=1{,}61$, $p=0{,}11$) e $\widehat\theta_1=-0{,}175$ ($t=-1{,}40$, $p=0{,}16$). A conclusão se mantém, agora com números. Vale notar que o AIC do vizinho AR(2) ($128{,}08$) é ligeiramente menor que o do M1 ($128{,}65$), mas a diferença é menor que 2 e o BIC prefere o M1 |
| Q6(a) | "a raiz do polinômio MA resultou em $z=-1+0i$" | **erro de sinal**. No R, o MA é $1+\theta B$. Com $\widehat\theta=-1$, o polinômio é $1-z$ e a raiz é $z=+1$. O código `polyroot(c(1, -theta_est))` usa a convenção Box-Jenkins com um coeficiente impresso na convenção do R. A raiz em $+1$ é justamente o fator $(1-B)$ da diferença em excesso | `polyroot(c(1, theta_est))`, raiz $z=+1$: o MA "desfaz" a diferença. O módulo 1 (não invertível) já estava certo |
| Q6(a) | erro-padrão de $\widehat\theta$ igual a $0{,}025$ | com $\widehat\theta$ na fronteira $-1$, a teoria assintótica usual não vale, e esse erro-padrão não tem a interpretação de sempre | uma frase dizendo isso |
| Q6(b) | compara $0{,}1234$ (M1) com $0{,}1241$ e diz "+0,61%", sem interpretar | (i) o $0{,}1234$ não é o $0{,}1211$ da tabela da Q4: o `forecast::Arima` corrige $\widehat\sigma^2$ por graus de liberdade e o `stats::arima` não. Precisa avisar ou usar uma só função. (ii) Falta dizer **por que** a variância quase não sobe: o MA com $\widehat\theta=-1$ absorve a diferença extra | estimar também o SARIMA(1,1,0)(1,0,0) **sem** MA: $\widehat\sigma^2=0{,}144$, cerca de 17% acima do M1 estimado com a mesma função ($0{,}123$), e $\widehat\phi$ troca de sinal ($-0{,}35$). Esse é o custo visível da sobrediferenciação |
| Q6(c) | compara a FAC **dos resíduos** e diz que o pico negativo não aparece | a pergunta é se a **série sobrediferenciada** tem autocorrelação negativa no lag 1. Nos resíduos ela não aparece justamente porque o MA a absorveu | mostrar a FAC de $\Delta y_t$: $\widehat\rho_1=-0{,}34$, fora da banda de $\pm0{,}153$. Esse é o sinal clássico |
| Q6(d) | "aumento expressivo da variância residual" | contradiz o próprio resultado (+0,6%). Também não é verdade em geral: $\operatorname{Var}(\Delta y)=2\gamma_0(1-\rho_1)$, que só supera $\gamma_0$ se $\rho_1<0{,}5$. Aqui $\widehat\rho_1=0{,}52$ e $\operatorname{Var}(\Delta y)=0{,}166<\operatorname{Var}(y)=0{,}172$ | "aumento da variância residual **quando o modelo não inclui o MA que compensa**"; citar o $0{,}144$. Corrigir também o "\*\*" que sobrou no último item |
| Q7(a) | tabelas com `Jan … Dec` e anos 1 a 12 | o `ts()` foi criado sem `start`. O que está rotulado como "Jan" na validação é **out/2024**, e o "Apr 0.00" é jan/2025 | `ts(..., start = c(2013, 1), frequency = 12)` uma vez e `window()` depois. Isso também corrige os eixos "5, 10, 15" e "13, 14" de todos os gráficos |
| Q7(d) | MAPE $=\text{Inf}$, sem comentário | o MAPE divide pelo valor observado, e jan/2025 é $0{,}00$. Com vários meses perto de zero e negativos, ele não serve para esta série mesmo sem o zero | dizer isso e reportar o **MASE** (tabela da seção 1) |
| Q7(e) | tabela só com RMSE | o enunciado pede "as métricas" | RMSE, MAE e MASE na mesma tabela, modelos nas linhas e esquemas nas colunas |
| Q7(e) | `snaive(treino, h = 141)` | o horizonte é 24. O resultado sai certo só porque o `accuracy()` recorta pela interseção das datas | `h = 24` |
| Q7(f) | "**Caso** o modelo paramétrico não tenha superado…" | a resposta fala no condicional, como se não soubesse o resultado da própria tabela | afirmar: bate o RW nos dois esquemas, perde para o SN nos dois, nenhuma diferença significativa (DM) |
| Q7(f) | "no Esquema 2, o Passeio Aleatório impõe uma barreira competitiva elevada" | **contradiz a tabela**: no esquema 2 o RW é o **pior** previsor (0,516) | trocar pelo argumento dos choques transitórios (seção 1, item 4) |
| Q7(f) | "o Sazonal Ingênuo aproveita a forte persistência dos padrões sazonais" | contradiz a Q1, que diz não haver sazonalidade | corrigir a Q1 (ver seção 3). A sazonalidade existe, mas é fraca |
| Q7(g) | só imprime "23 de 24, 95,83%" | falta a resposta: corresponde à nominal? | sim, é compatível. Com 24 observações, o IC de 95% (binomial exato) da cobertura vai de 79% a quase 100%, então o teste tem pouco poder. O único mês fora é fev/2025 (Itaipu). Notar também que os intervalos são largos (cerca de $\pm0{,}8$ p.p.) porque convergem para a variância incondicional, e que o JB rejeitou a normalidade em que eles se apoiam. Para mostrar que isso não muda a conclusão: com `forecast(..., bootstrap = TRUE)` (e `set.seed`), a cobertura continua 23/24 e a largura média sobe pouco (1,65 contra 1,61) |

## 3. Pendências da revisão anterior que continuam no PDF

| Onde | Problema | Correção |
|---|---|---|
| Q1 | "não é possível identificar um padrão sazonal" | a FAC no lag 12 é $0{,}217$, acima da banda de $0{,}153$, e o SAR é significativo ($t=2{,}31$). Sazonalidade fraca, mas presente. Isso precisa casar com a Q3 e a Q7 |
| Q1 | "não há evidência de mudança permanente de nível" | correto quanto a mudança *permanente*, mas a média anual vai de $0{,}17$ a $0{,}90$. Dizer que há **mudanças temporárias de patamar** e ligar com a seção 1 |
| Q2(a) | "($p<0{,}01$)" e nenhum p-valor | o `urca` não dá p-valor do $\tau$. Escrever "rejeita a 1% pelo valor crítico", ou tirar p-valores de MacKinnon (`tseries::adf.test` ou `fUnitRoots::punitroot`) |
| Q2(a) | DF-I (sem constante) usado como evidência | essa especificação está errada para uma série de média $0{,}46$. Deve ser citado só como especificação descartada |
| Q2(a) e (b) | "confirma de forma definitiva", "com total segurança" | teste não confirma $H_0$ nem dá certeza. "Os testes convergem para…" |
| Q2(b) | as estatísticas $\phi_1,\phi_2,\phi_3$ aparecem e não são lidas | aqui o PDF está, na essência, certo: pelo procedimento sequencial de Enders (2015, cap. 4), quando o $\tau$ rejeita a raiz unitária, os termos determinísticos podem ser testados com o $t$ usual, e é isso que o texto faz. Os $\phi$ só são indispensáveis quando o $\tau$ não rejeita. Basta uma frase dizendo isso e citando os valores ($\phi_3=13{,}54>8{,}43$; $\phi_1=13{,}30>6{,}52$), em vez de deixá-los soltos |
| Q2(c) | "estritamente estacionária" | os testes falam de estacionariedade **fraca** |
| Q2(c) | não repete os testes na série diferenciada | o enunciado pede. Rodar ADF/PP/KPSS em $\Delta y$ (rejeitam com folga). Isso também prepara a Q6 |
| Q2(d) | "o DF-GLS pode confundir a alta persistência… por isso divergiu" | **é o contrário**: o DF-GLS tem *mais* poder. O problema é `lag.max = 12`, que no `urca` **fixa** 12 defasagens, sem seleção. Com 1 defasagem (a que o BIC escolheu no ADF): $-3{,}65$; com 2: $-3{,}49$; com 4: $-2{,}93$. Todos rejeitam (crítico $-1{,}94$). Só com 12 dá $-1{,}21$ |
| Q2(d) | não diz se é DS ou TS | dizer explicitamente: a variação **não é nem DS nem TS**. É estacionária em torno de uma média constante (tendência não significativa: $t=-0{,}745$ no ADF, $Z_{\tau\beta}=-0{,}68$ no PP) |
| Q3(b) | não responde sobre $2s$, $3s$ e $s\pm1$ | FAC: lag 11 $=0{,}190$, lag 12 $=0{,}217$, lag 13 $=0{,}095$, lag 24 $=-0{,}015$, lag 36 $=0{,}035$. Pico em 11–12, nada em 24 e 36: o padrão é de **SMA(1) ou SAR(1) fraco**, não de raiz sazonal |
| Q4(a) | "Intercepto" | no `arima()`, é a **média** $\mu=0{,}461$. A constante é $c=\mu(1-\phi)(1-\Phi)=0{,}187$ |
| Q4(a) | tabela digitada à mão | gerar a tabela no código (como já é feito com `metricas`) |
| Q4(d) | "a variância dos resíduos não é contada" | **errado**: $k=(AIC+2\ln L)/2=(128{,}65-120{,}66)/2=4$, ou seja, 3 coeficientes mais $\widehat\sigma^2$. O `logLik(modelo1)` mostra `df = 4`. O enunciado pede para "verificar na documentação". O `?arima` só diz que o AIC corresponde à log-verossimilhança e não explicita o $k$. A verificação está no código-fonte (`stats::arima` calcula `aic <- value + 2 * sum(mask) + 2`, com `value` $=-2\ln L$ e o `+ 2` sendo a variância) e no `logLik()`, que reporta `df = 4`. Vale contrastar com a aula 02 (slides 98–99), que define $AIC=(-2\ln L+2k)/T$ e $BIC=(-2\ln L+k\ln T)/T$ com $k=p+q+1$, **sem** a variância. A ordenação dos modelos não muda, porque o termo extra é igual para todos |
| Q4(e) | "não se verifica qualquer divergência" | certo, mas $\Delta\text{AIC}=0{,}46$ entre M1 e M2: são praticamente equivalentes. E o M3 tem SAR e SMA não significativos com erros-padrão enormes (0,57 e 0,61), sintoma de **fatores quase comuns** |
| Q4(f) | títulos "AR Roots" repetidos, gráfico do M1 chamado de "MA Roots", e **nenhuma conclusão** | cada `plot()` do `forecast` já desenha AR e MA. São **raízes inversas**: dentro do círculo significa raiz fora, logo estacionário e invertível. Uma chamada por modelo e uma frase de conclusão |

## 4. Forma e reprodutibilidade

- **Código cortado na margem** (p. 13, 14, 22, 23, 27, 31). O corretor não consegue ler a linha. No Quarto, `format: pdf` com `include-in-header` contendo `\usepackage{fvextra}` e `\DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,commandchars=\\\{\}}`, ou quebrar as linhas à mão.
- **Numeração duplicada** nos títulos ("1 1. Preparação…"). Ou se tira o número do texto, ou se desliga `number-sections`.
- **Caminho e pacotes**: `read_excel("inpc_13_a_26.xlsx")` precisa do arquivo junto; o `library(forecast)` está duplicado; o `library(seasonal)` não é usado e exige o X-13.
- **Mistura de `arima()` e `Arima()`**: elas dão $\widehat\sigma^2$ diferentes (0,1211 e 0,1234). Usar uma só.
- **Entrega**: o `sessionInfo()` continua faltando.

### Boas práticas que evitam boa parte dos erros acima

- **Um só objeto `ts`, criado uma vez.** `y <- ts(inpc$Variação, start = c(2013, 1), frequency = 12)`, e depois `treino <- window(y, end = c(2024, 9))` e `validacao <- window(y, start = c(2024, 10))`. Sem números mágicos (`141`, `165`, `130:153`): usar `length(y)`, `H <- 24` e `T0 <- length(y) - H`. As datas certas nas tabelas e nos eixos saem de graça.
- **Uma só função de estimação** (`Arima()`), para que $\widehat\sigma^2$, AIC e resíduos sejam comparáveis entre as questões.
- **Números do texto vindos do código.** No Quarto, `` `r round(AIC(modelo1), 2)` `` no meio da frase em vez de digitar o valor. Isso impede que texto e tabela se contradigam, como aconteceu na Q7(f).
- **Tabelas pelo código** (`kable()` sobre um `data.frame`), nunca com valores colados em `c("0.5065 (0.0673) [7.52]", ...)`.
- **`set.seed()`** antes de qualquer coisa aleatória (bootstrap).
- **Escrever qual convenção de sinal do MA se usa** antes de calcular raízes. O erro da Q6(a) vem daí.
- **Uma pergunta, uma resposta direta.** Abrir cada item com a resposta ("Sim, a cobertura é compatível com a nominal: 23 de 24.") e só depois justificar.

### Redação: cortar o tom de texto gerado

Algumas frases do PDF soam genéricas e prometem mais do que os testes entregam. O corretor percebe. A regra é simples: frase sem número ou sem referência a um resultado do próprio trabalho pode sair.

| No PDF | Problema | Melhor |
|---|---|---|
| "confirma de forma definitiva", "com total segurança", "comprova empiricamente" | teste não confirma nem comprova | "os testes rejeitam a raiz unitária a 1%" |
| "revela nuances importantes sobre a dinâmica" | não diz nada | dizer o resultado: "bate o RW, perde para o SN" |
| "unificando perfeitamente a parcimônia e a qualidade de ajuste" | adjetivo no lugar de número | "AIC e BIC escolhem o M1; a diferença para o M2 é 0,46 no AIC" |
| "pela máxima parcimônia e rigor estatístico" | idem | cortar |
| "esse resultado é teoricamente consistente com a literatura" | sem citar quem | citar (Atkeson e Ohanian, 2001; Faust e Wright, 2013) |

Também ajuda padronizar a língua (o PDF mistura "parcimónia" e "parcimônia", "grelha" e "grade") e usar vírgula decimal no texto, já que as saídas do R usam ponto.

## 5. Confronto com o material do professor

Esta seção compara o PDF com o enunciado da Lista 01, com a aula 03 (diagnóstico e previsão, lida inteira) e com o texto de Mattos (2019), que o curso usa para raiz unitária (seções 2.2.5, 2.4 e 2.6). A aula 02 só foi consultada nos slides de AIC e BIC. As aulas 04 e 05 não estavam no Drive.

O PDF responde as questões, mas quase nunca usa o vocabulário e as ferramentas que o professor apresentou. Esse é o ganho mais barato: as ferramentas já estão nos slides e mudam pouco o código.

### Raiz unitária (Mattos, seção 2.2.5)

- **Escolha da versão pelo gráfico.** O passo 1 de Mattos é olhar o gráfico: série que oscila em torno de uma constante pede a opção 2 (só intercepto). O PDF chega à opção 2 pela significância do $t$ da tendência. Basta abrir a Q2(b) com o argumento do gráfico e usar o $t$ como confirmação.
- **Defasagens a partir de zero.** No procedimento de Mattos, o Schwarz é comparado a partir de **zero** defasagens. O `ur.df(..., selectlags = "BIC")` só testa de 1 a `lags`, então o "BIC escolheu 1" é o piso da função. Na mesma amostra, o BIC mínimo é com **0** defasagens (138,7 contra 140,4 com uma), e aí $\tau_2=-7{,}19$. A conclusão não muda, mas o texto deve dizer como as defasagens foram escolhidas.
- **Valor crítico de MacKinnon (1996).** Mattos indica essa tabela, e ela é a base dos p-valores que o enunciado pede na Q2(a).
- **Sazonalidade (Mattos, seção 2.6).** Para o $D$ da Q2(c), o material do curso não usa o OCSB (`nsdiffs`), e sim o ADF com dummies sazonais **centradas**, que não altera a distribuição do $\tau$ (Dickey e Miller, 1986). A [revisão anterior](revisao.md) já fez isso: $\tau=-4{,}87$, e 4 das 11 dummies são significativas. Isso responde ao mesmo tempo o $D=0$ e a sazonalidade "fraca e determinística" da Q1.

### Diagnóstico (aula 03, slides 9 a 31)

- **Graus de liberdade do Ljung-Box.** A aula usa $\nu=k-p-q$. No M1, os coeficientes ARMA são $\phi_1$ e $\Phi_1$, então `fitdf = 2` está certo. Vale escrever a conta no texto ("$\nu=12-2=10$").
- **Normalidade.** O slide 11 diz exatamente o argumento que falta na Q5(d): a normalidade não é necessária para a estrutura ARMA, mas importa para a inferência e para os intervalos. Os três resíduos padronizados acima de 3 em módulo são jun/2018, jul/2022 e fev/2025, os choques já citados na seção 1.
- **Heterocedasticidade.** Além do ARCH-LM, os slides 21 e 22 mostram a FAC dos **resíduos ao quadrado**. Nenhum lag sai da banda, e o Ljung-Box dos quadrados com 12 lags dá $p=0{,}88$.
- **Estabilidade** (slides 24 a 31). O PDF não testa, e o slide 24 explica por que importa aqui: "um modelo pode passar em todos os testes de resíduos e ainda assim descrever mal cada subperíodo". É o complemento natural da discussão sobre a média (seção 1). Rodando o CUSUM e o CUSUM-OLS (`strucchange::efp`) numa regressão com $y_{t-1}$ e $y_{t-12}$, nenhum rejeita a estabilidade ($p=0{,}46$ e $0{,}50$). Isso reforça o texto: dentro da amostra o modelo é estável, e o que mudou foi o período de validação. Cuidado com o Chow: o slide 26 lembra que a data da quebra precisa ser escolhida *a priori* (por exemplo, mar/2020 ou a mudança de meta), e não olhando o gráfico.

### Previsão (aula 03, slides 33 a 60)

- **Vocabulário.** Nos termos da aula, o esquema 1 é **janela fixa com previsão iterada** de 1 a 24 passos, e o esquema 2 é **janela fixa com previsão de um passo** (slides 36 e 40). O slide 40 alerta para a confusão comum: as 24 previsões de um passo do esquema 2 não são previsões de 24 passos. Usar esses termos na Q7(b) e (c) mostra que a dupla entendeu a diferença.
- **MAPE e MASE.** O slide 46 diz que o MAPE "exige $y_t\neq0$ e fica instável quando $y_t$ se aproxima de zero". É a frase para citar na Q7(d). O slide 49 define o MASE com $m=12$ para séries sazonais e escala calculada no treino, exatamente como na tabela da seção 1. Pela definição da aula, MASE < 1 significa melhor que o ingênuo **dentro do treino**.
- **MAE e MAD.** A aula chama o MAE de MAD. O enunciado usa MAE. Basta uma nota dizendo que são a mesma medida.
- **Diebold-Mariano** (slides 50 e 51). A aula apresenta o teste exatamente para a pergunta da Q7(f) ("RMSE de 3,1 contra 3,4: isso é uma diferença?"). Sem ele, a Q7(f) fica abaixo do nível da aula. O slide 51 cita Giacomini e White (2006) como alternativa. Com coeficientes fixos estimados no treino, que é o caso dos dois esquemas, essa alternativa é inclusive a mais adequada. Basta citá-la.
- **Previsão intervalar** (slides 52 a 60). É aqui que o trabalho mais ganha, porque o resultado **muda de sinal**:

| Previsor, esquema 1 | Cobertura de 95% | Largura média | Winkler | CRPS |
|---|---|---|---|---|
| M1 | 23/24 | 1,61 | **1,87** | 0,217 |
| Sazonal ingênuo | 24/24 | 2,58 | 2,58 | **0,213** |
| Passeio aleatório | 24/24 | 5,06 | 5,06 | 0,353 |

  Os intervalos dos benchmarks vêm de `naive()` e `snaive()`, e o CRPS supõe distribuição preditiva normal. O sazonal ingênuo ganha na previsão pontual, mas **o M1 dá o melhor intervalo**: cobre o que precisa com um intervalo bem mais estreito. No CRPS, M1 e sazonal ingênuo empatam. Isso responde melhor à queixa "o modelo não previu nada": o M1 não acerta o ponto melhor que a média, mas descreve bem a **incerteza**, e isso também é previsão.
- **Calibração** (slide 59). A Q7(g) pede "a cobertura empírica corresponde à nominal?". A aula responde com o teste de cobertura incondicional de Christoffersen (1998): com 1 violação em 24, $LR_{uc}=0{,}04$, $p=0{,}85$, e não se rejeita a cobertura nominal. O teste de independência não se aplica com uma violação só, e o texto deve dizer isso.

## 6. Ordem sugerida de trabalho

1. **Q7(f) e Q7(g)**: reescrever com os números (seção 1). É onde está a pergunta de vocês e onde o texto atual contradiz a própria tabela.
2. **Q4(d) e Q6(a)**: são erros factuais, um de conceito e um de sinal. A correção é de uma linha cada.
3. **Q2(d)**: o argumento do DF-GLS está invertido, e a correção (`lag.max` menor) reforça a conclusão $d=0$.
4. **Q1 × Q3 × Q7**: tornar a sazonalidade coerente nas três questões.
5. **Q5(e), Q6(b), Q6(c), Q7(d), Q7(e)**: acrescentar os números que faltam.
6. Forma: `start` no `ts()`, quebra de linha no código, legendas e a revisão de redação da seção 4.
7. Material do professor (seção 5): vocabulário da aula 03, FACP dos resíduos, Winkler, CRPS e Christoffersen na Q7(g), CUSUM como complemento da Q5.

## Referências

- Atkeson, A.; Ohanian, L. E. (2001). Are Phillips curves useful for forecasting inflation? *Federal Reserve Bank of Minneapolis Quarterly Review*, 25(1), 2–11.
- Christoffersen, P. F. (1998). Evaluating interval forecasts. *International Economic Review*, 39(4), 841–862.
- Dickey, D. A.; Miller, R. J. (1986). Unit root tests in seasonal time series. Citado por Mattos (2019, seção 2.6).
- Diebold, F. X.; Mariano, R. S. (1995). Comparing predictive accuracy. *Journal of Business & Economic Statistics*, 13(3), 253–263.
- Enders, W. (2015). *Applied Econometric Time Series*. 4. ed. Wiley, cap. 4 (procedimento sequencial para os testes de raiz unitária).
- Faust, J.; Wright, J. H. (2013). Forecasting inflation. In: Elliott, G.; Timmermann, A. (orgs.). *Handbook of Economic Forecasting*, v. 2A. Elsevier, p. 2–56.
- Giacomini, R.; White, H. (2006). Tests of conditional predictive ability. *Econometrica*, 74(6), 1545–1578.
- Hyndman, R. J.; Koehler, A. B. (2006). Another look at measures of forecast accuracy. *International Journal of Forecasting*, 22(4), 679–688.
- Mattos, R. S. (2019). *Tendências e raízes unitárias*. UFJF. Texto do curso, seções 2.2.5, 2.4 e 2.6.
- Stock, J. H.; Watson, M. W. (2007). Why has U.S. inflation become harder to forecast? *Journal of Money, Credit and Banking*, 39(s1), 3–33.
- Para a discussão de $d$ (inflação I(0) ou I(1)), ver [referencias_inpc.md](../referencias_inpc.md).
