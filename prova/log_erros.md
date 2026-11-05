---
title: "Log de erros — treino para a prova de 05/11"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
prova: "05/11/2026"
status: rascunho
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
aliases:
  - Log de erros — séries temporais
---

# Log de erros

Toda questão errada, incompleta ou resolvida acima do tempo-alvo entra aqui **no mesmo dia**, venha ela de um [simulado](README.md), do [banco](banco.md) ou da lista. A revisão segue o espaçamento +1, +3 e +7 dias: refaça a questão do zero, sem olhar a resolução, e anote a data em que acertou.

> [!TIP]
> **Como preencher**
> Uma linha por erro, não por questão: se uma derivação teve dois erros (esqueceu a hipótese e trocou o sinal), são duas linhas. A coluna "ação" diz o que muda no próximo treino. "Estudar mais" não vale.

## Códigos

Os mesmos do log de Econometria I, para comparar as duas disciplinas.

| Coluna | Valores |
|---|---|
| tipo (T) | **D** derivação · **C** cálculo · **T** conceitual · **V/F** julgamento |
| causa (C) | **H** hipótese não citada · **A** álgebra ou sinal · **N** notação ou convenção do MA · **L** leitura do enunciado ($s$, $T$, convenção) · **R** regra de decisão invertida · **V** conclusão sem interpretação · **E** esquecimento do resultado · **T** tempo |
| revisão | data da revisão; `ok` quando acertou sem consulta; `x` quando errou de novo (volta para +1) |

## Herança da P1 de Econometria I (09/10/2026)

Os seis erros da P1 de Econometria I, com a ação traduzida para séries temporais. Eles **não** se refazem como questões de Econometria I: a coluna "treino aqui" diz qual item desta prova exercita o mesmo músculo.

| questão (Econ. I) | erro | C | treino aqui | ação |
|---|---|---|---|---|
| P1, Q1 | $\mathbf X'\mathbf X$, inversa e $\widehat\beta$ em branco | T | S1 Q4b; banco Q14 | fazer os itens de conta antes das demonstrações; cronometrar 5 min |
| P1, Q2d | efeito marginal sem o termo $2\beta_3EXP$ | A | S1 Q1c ($4\gamma_x$); S4 Q5a ($\psi_1=\phi+\theta$) | escrever a fórmula geral e a convenção antes dos números |
| P1, Q3c | rejeitou $H_0$ sem calcular $F$ | E | S4 Q4b (LR); S4 Q6d (Ljung-Box) | teste em quatro linhas, com a estatística calculada |
| P1, Q4a | plim em branco | E | S1 Q2b (momentos auxiliares do ARMA) | refazer D02.2 de cabeça até sair em 8 min |
| P1, Q5 | Gauss-Markov sem a conclusão "semidefinida positiva" | E | S1 Q3a (raiz ⇒ não invertível ⇒ sem AR($\infty$)); S1 Q5a | reler o verbo e fechar com a frase pedida |
| P1, Q6 | FWL incompleto | E | S3 Q3 (previsão em cadeia) | escrever a equação expandida uma vez e só substituir |

## Registro

| data | questão | T/C | erro | ação | revisões (+1 · +3 · +7) |
|---|---|---|---|---|---|
| 01/11 | S1 Q1c | T/E | classificou como ARMA(1,2) uma FAC que corta em 2 | FAC que corta em $q$ ⇒ MA($q$); AR nunca zera a FAC | 03/11 · 04/11 |
| 01/11 | S1 Q1a, b | T/V | sem a frase de fecho (não estacionário; FAC que decai devagar) | fechar todo item com a frase do verbo | 03/11 · 04/11 |
| 01/11 | S1 Q1a | D/N | $\operatorname{Var}=(y_t-\mu)^2$ sem o $E$ | escrever $E(\cdot)$ em toda linha de momento | 03/11 · 04/11 |
| 01/11 | S1 Q2b | D/N | $\gamma_0=\operatorname{Cov}(z_t,z_{t-1})$: definição trocada, e travou | $\gamma_0=E(z_t^2)$, $\gamma_1=E(z_tz_{t-1})$; roteiro de quatro movimentos | 03/11 · 04/11 |
| 01/11 | S1 Q2a, Q3a | C/N | raiz do polinômio escrita com a série ($\phi(z_t)$) | variável do polinômio é um número: $\phi(x)=0$ | 03/11 · 04/11 |
| 01/11 | S1 Q3a | D/A | $y_t-y_{t-1}=\varepsilon_t$ (do passeio) e forma copiada do enunciado | derivar: multiplicar $(1-0{,}5B)y_t=\varepsilon_t$ por $(1-B)$ | 03/11 · 04/11 |
| 01/11 | S1 Q4a | C/R | modelo escolhido pelo $\ln L$, sem AIC nem BIC | AIC e BIC com $k$ incluindo $\sigma^2$; menor vence | 03/11 · 04/11 |
| 01/11 | S1 Q4b, Q5, Q6 | C/T | contas curtas em branco (cerca de 3 pontos) | 25 minutos de contas curtas antes das derivações | 03/11 · 04/11 |
| 04/11 | S5 Q2b | D/H | $E(\varepsilon_ty_{t-1})=-1{,}5$; o certo é 0 (causalidade) | choque mais novo que o $y$ ⇒ zero; conferir $\rho_1=\phi$ no AR(1) | 05/11 |
| 04/11 | S5 Q1b | C/A | $\rho_1$ dividido pelo $\gamma_0$ de $z_1$, dando $-2{,}125$ | $\rho_k=\gamma_k/\gamma_0$ do **mesmo** processo; $\lvert\rho\rvert\le1$ | 05/11 |
| 04/11 | S5 Q2a | C/N | raiz com a série e sinal trocado ($x=2$ no lugar de $-2$) | $1+0{,}5x=0\Rightarrow x=-2$ | 05/11 |
| 04/11 | S5 Q2d | C/R | FAC que corta em 1 lida como AR(1) | AR corta na FACP; MA corta na FAC | 05/11 |
| 04/11 | S5 extra | C/R | $\tau$ maior que o crítico lido como rejeição; $\phi_3$ contra o crítico do $\tau$ | $\tau$ menor rejeita; $\phi$ maior que o próprio crítico rejeita | 05/11 |
| 04/11 | S5 Q3 | D/E | SMA(1)$_4$ em branco | os quatro termos da Q1b com $B^4$ | 05/11 |
| 04/11 | S5 Q4a | C/E | ciclo de Box-Jenkins confundido com o Dickey-Fuller | I, E, D, P; o DF fica dentro da I | 05/11 |
| 04/11 | S5 Q4b, c | C/T | interpretação da tabela em branco; 35 min na Q1 | 15 min por questão; itens curtos primeiro | 05/11 |
|  |  |  |  |  |  |

## Placar por causa

Atualize depois de cada simulado. A causa com mais linhas vira o foco do treino seguinte.

| causa | S1 (01/11) | S2 (03/11) | S5 (04/11) |
|---|---|---|---|
| H hipótese | 0 |  | 1 |
| A álgebra ou sinal | 1 |  | 1 |
| N notação ou convenção | 3 |  | 1 |
| L leitura | 0 |  | 0 |
| R regra de decisão | 1 |  | 2 |
| V conclusão | 1 |  | 0 |
| E esquecimento | 1 |  | 2 |
| T tempo | 1 |  | 1 |
