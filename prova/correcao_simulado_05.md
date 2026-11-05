---
title: "Simulado 05 — correção da minha tentativa (04/11) e o resgate de SARIMA e Box-Jenkins"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
lista: LST
status: verificado
tags:
  - series-temporais
  - mestrado/ppgeco
  - prova
  - simulado
aliases:
  - Correção do Simulado 05
---

# Simulado 05: a correção da minha tentativa

Esta é a correção da tentativa de 04/11, das 21h22 às 22h37, feita à mão e corrigida pela rubrica do [gabarito](simulado_05_gabarito.md). Cada erro foi lançado no [log](log_erros.md). Como no Simulado 01, o objetivo é achar **a primeira linha** em que cada item desandou e a regra que impede o erro de voltar. No fim estão as duas lacunas que mais pesam: **SARIMA** e o **ciclo de Box-Jenkins**, refeitos do zero a partir do que você já faz certo.

## 1. A nota pela rubrica: cerca de 2,8 de 10

| Questão | O que foi feito | Pontos |
|---|---|---|
| Q1 a) (1,0) | soma telescópica, $E$, $V$ e $\operatorname{Cov}$ certos; faltaram os números com $t=36$ | ≈ 0,7 |
| Q1 b) (1,5) | os quatro termos, o fator 4 e os $\gamma$ perfeitos; $\rho_1$ errado; justificativa da classe fraca | ≈ 1,15 |
| Q2 (2,5) | a) a raiz com o sinal trocado; b) um auxiliar errado contaminou tudo; d) AR no lugar de MA | ≈ 0,8 |
| Q3 (2,5) | "não sei" | 0 |
| Q4 (2,5) | a) o ciclo confundido com o Dickey-Fuller; b) e c) em branco | ≈ 0,1 |
| Extra (DF) | a regra do $\tau$ invertida | fora da nota |

**A leitura que importa:**
- **Subiu de 1,6 para 2,8**, e o bloco 1 (Q1) está quase inteiro: 1,85 de 2,5.
- **Os 5 pontos da Q3 e da Q4 ficaram quase em branco**, e não por falta de técnica: a Q3 a) é a mesma força bruta de quatro produtos que você acertou na Q1 b) (seção 4 abaixo).
- **O tempo foi para a Q1**, com 35 minutos, contra os 15 previstos. A Q3 e a Q4 tiveram 7 minutos juntas.

## 2. O que já está certo

- **Q1 a):**
  - a recursão até $y_t=\sum_{i=1}^{t}u_i$;
  - $E(y_t)=\sum E(u_i)=0$;
  - $V(y_t)=t\sigma^2=1{,}5t$;
  - $\operatorname{Cov}(y_t,y_{t-k})=1{,}5(t-k)$ pela soma dupla;
  - a frase "a variância cresce com $t$: não estacionário";
  - e ainda, de bônus, a raiz unitária, $1-x=0\Rightarrow x=1$.
- **Q1 b):** os quatro termos da covariância listados um por um; os cruzados zerados; o **4** de $2^2$; e $\gamma_3=(5{,}6;\ -1{,}7;\ 0{,}8;\ 0)$, todos certos.
- **Q2 b):**
  - a causalidade escrita;
  - o auxiliar $E(y_t\varepsilon_t)=\sigma^2=3$ certo;
  - a equação $\gamma_0=-0{,}5\gamma_1+3$ certa;
  - a recursão $\rho_k=\phi\rho_{k-1}$ lembrada.
- **Q2 c):** a ideia de uma FAC que alterna de sinal.

## 3. Os pontos de perda, linha a linha

1. **Q2 b): a primeira linha que desandou foi $E(\varepsilon_ty_{t-1})=-1{,}5$.** *(H)*
   - O certo é $E(\varepsilon_ty_{t-1})=0$, pela causalidade: o choque de **hoje** não aparece no $y$ de **ontem**.
   - O $-1{,}5$ que você calculou é outro momento, $E(y_t\varepsilon_{t-1})=\phi\sigma^2$, que **o AR(1) nem usa**.
   - **A regra:** se o choque é **mais novo** que o $y$, a esperança é zero.
   - Com a linha certa: $\gamma_1=-0{,}5\gamma_0$, então $\gamma_0=0{,}25\gamma_0+3$, ou seja, $\gamma_0=4$; e $\gamma_1=-2$, $\rho_1=-0{,}5$, $\rho_2=0{,}25$, $\rho_3=-0{,}125$.
   - **A conferência que pegaria o erro:** num AR(1), $\rho_1=\phi$ sempre. Você achou $-0{,}8$ com $\phi=-0{,}5$: era o sinal de que uma linha estava errada.
2. **Q1 b): $\rho_1=-1{,}7/0{,}8=-2{,}125$.** *(A)*
   - O denominador é o $\gamma_0$ **do mesmo processo**, 5,6, e não o 0,8, que é o $\gamma_0$ de $z_1$.
   - O certo é $\rho_1=-1{,}7/5{,}6=-0{,}3036$.
   - **A conferência:** $\lvert\rho\rvert\le1$ sempre. Um $-2{,}125$ é impossível.
3. **Q2 a): $\phi(\widehat y_t)=1+0{,}5\widehat y_t=0\Rightarrow y_t=2$.** *(N, A)*
   - Dois erros numa linha: a variável virou a série, que é o mesmo erro do Simulado 01, e o sinal sumiu.
   - O certo é $1+0{,}5x=0\Rightarrow x=-2$, com $\lvert-2\rvert=2\gt1$. A conclusão, estacionário, estava certa por sorte.
4. **Q2 d): "AR(1), corta na primeira defasagem".** *(R)*
   - A FAC que corta é a de um **MA**. O certo é **MA(1)**.
   - **A regra de bolso:** *AR corta na FACP; MA corta na FAC.*
   - A mesma confusão aparece na Q1 b) ("corta no $\rho_1$, $\rho_2$ vai a 0"). A FAC de $z_3$ tem $\rho_2=0{,}1429\ne0$ e só zera em 3: ela corta **depois de 2**, e por isso é MA(2).
5. **Questão extra: a regra do $\tau$ invertida.** *(R)*
   - Você escreveu "$-2{,}80\gt-3{,}45\Rightarrow$ rejeita". É o contrário: **rejeita-se quando $\tau$ é menor (mais negativo) que o crítico**. A região de rejeição fica **à esquerda** do crítico, na reta.
   - O $\phi_3$ foi comparado com $-3{,}45$, que é o crítico do $\tau$. Ele se compara com o **crítico do $\phi_3$**, 6,49, e rejeita quando é **maior**.
   - O resultado certo:
     - não rejeita, não rejeita, não rejeita, não rejeita;
     - no modelo 1, $-2{,}30\lt-1{,}95$ **rejeita**;
     - a série **não tem raiz unitária** e **não se diferencia**.
   - No b), $\tau_\tau=-3{,}90$ rejeita no passo 1, e a série é estacionária em torno de tendência, não um passeio.
6. **Q3: "não sei".** *(E)* Ver a seção 4: é a sua própria conta da Q1 b), com $B^4$.
7. **Q4 a): o ciclo virou o Dickey-Fuller.** *(E)*
   - O Dickey-Fuller é **uma ferramenta dentro da etapa 1**, a identificação, para achar o $d$.
   - O ciclo tem quatro etapas e uma seta de volta: ver a seção 5.
8. **Tempo: 35 minutos na Q1, e a Q4 b) e c) em branco.** *(T)*
   - A Q4 b) é só ler a tabela: 1,1 ponto em 5 minutos (seção 5).
   - A Q1 a) perdeu 0,2 por não fazer as três contas finais: $1{,}5\cdot36=54$, $1{,}5\cdot25=37{,}5$ e $\sqrt{25/36}=0{,}8333$.

## 4. SARIMA do zero, a partir do que você já faz

**A ponte.** Na Q1 b), você abriu $\operatorname{Cov}(z_{1t}+2z_{2t},\ z_{1,t-k}+2z_{2,t-k})$ em **quatro termos** e perguntou, em cada um, se o par se correlaciona. O SMA(1)$_4$ é **exatamente isso**, com choques no lugar de processos e com 4 no lugar de 1.

**Q3 a), refeita**, com $y_t=(1-0{,}8B^4)a_t$ e $\sigma^2=1$:

$$
\begin{aligned}
\text{(1)}\quad & y_t=a_t-0{,}8\,a_{t-4} && [B^4a_t=a_{t-4}]\\
\text{(2)}\quad & \gamma_k=E\big((a_t-0{,}8a_{t-4})(a_{t-k}-0{,}8a_{t-4-k})\big) && [\text{definição}]\\
\text{(3)}\quad & \phantom{\gamma_k}=E(a_ta_{t-k})-0{,}8E(a_ta_{t-4-k})-0{,}8E(a_{t-4}a_{t-k})+0{,}64E(a_{t-4}a_{t-4-k}) && [\text{4 termos}]\\
\text{(4)}\quad & k=0:\ 1+0{,}64=1{,}64 && [\text{1º e 4º casam}]\\
\text{(5)}\quad & k=4:\ -0{,}8 && [\text{só o 3º casa}]\\
\text{(6)}\quad & k\ne0,4:\ 0;\qquad \rho_4=-0{,}8/1{,}64=-0{,}4878 && [\div\gamma_0]\\
\text{(7)}\quad & \text{FACP: } -0{,}4878;\ -0{,}3123;\ -0{,}2215 \text{ em } 4,8,12 && [\text{decaindo}]
\end{aligned}
$$

**O desenho:** na FAC, **uma barra só, em 4**, de $-0{,}49$. Na FACP, barras em 4, 8 e 12, todas negativas e cada vez menores. É o desenho do quadro.

**Q3 b), a previsão**, em três regras:
1. **Expandir os dois produtos.**
   - $(1-B)(1-B^4)=1-B-B^4+B^5$.
   - $(1-0{,}4B)(1-0{,}6B^4)=1-0{,}4B-0{,}6B^4+0{,}24B^5$.
   - Então $y_t=y_{t-1}+y_{t-4}-y_{t-5}+a_t-0{,}4a_{t-1}-0{,}6a_{t-4}+0{,}24a_{t-5}$.
2. **Escrever em $T+1$, zerar o choque futuro e manter o resto:** $\widehat y_T(1)=y_T+y_{T-3}-y_{T-4}-0{,}4\widehat a_T-0{,}6\widehat a_{T-3}+0{,}24\widehat a_{T-4}$.
3. **Em $T+2$, trocar $y_{T+1}$ pela previsão:** $\widehat y_T(2)=\widehat y_T(1)+y_{T-2}-y_{T-3}-0{,}6\widehat a_{T-2}+0{,}24\widehat a_{T-3}$.

Os resíduos aparecem **até $h=5$**, a maior defasagem do MA.

**O que decorar sobre SARIMA, em quatro linhas:**
1. $(p,d,q)(P,D,Q)_s$: os polinômios são multiplicados; o termo cruzado é **imposto**, não estimado.
2. Perdas: $d+sD$. Parâmetros: $p+q+P+Q+1$, porque o $+1$ é o $\sigma^2$.
3. **SMA**: a FAC tem um pico só em $s$. **SAR**: a FAC decai em $s,2s$, e a FACP tem um pico em $s$.
4. Previsão: as três regras. Os resíduos vão até a maior defasagem do MA.

Tudo isso, linha a linha, está na [folha, §4 e §5](o_que_cai.md), com o SAR da Q11 e o $(1,1,0)(0,1,1)_4$ da Q12.

## 5. O ciclo de Box-Jenkins do zero: **I, E, D, P**

| Etapa | O que se faz | A ferramenta |
|---|---|---|
| **I**dentificação | olhar o gráfico, achar o $d$ e o $D$, propor $p,q,P,Q$ | **Dickey-Fuller** para o $d$; **FAC e FACP** para as ordens |
| **E**stimação | estimar os candidatos por MV | **AIC e BIC** para escolher |
| **D**iagnóstico | checar se os resíduos são ruído branco | FAC dos resíduos e **Ljung-Box** |
| **P**revisão | prever e avaliar fora da amostra | **RMSE e MAPE**; intervalos |

**Se o diagnóstico falha, volta-se à identificação.** Repare onde fica o Dickey-Fuller: na primeira etapa, como uma das ferramentas. Ele não é o ciclo.

**A Q4 a), como se escreve na prova:** "O ciclo de Box-Jenkins tem quatro etapas. (1) Identificação: pelo gráfico e pelo teste de Dickey-Fuller, escolhe-se o número de diferenças; pela FAC e pela FACP, as ordens. (2) Estimação: os candidatos são estimados por máxima verossimilhança e comparados por AIC e BIC. (3) Diagnóstico: os resíduos precisam ser ruído branco, o que se verifica pela FAC dos resíduos e pelo Ljung-Box. (4) Previsão: o modelo é avaliado fora da amostra por RMSE e MAPE. Se o diagnóstico falha, volta-se à identificação."

**A Q4 b), que era só ler a tabela:**
1. **AIC:** B, por 0,6. Menos de 2 é empate.
2. **BIC:** A, por 2,2.
3. **RMSE e MAPE:** A.
4. **Por que discordam:** a multa por parâmetro é 2 no AIC e $\ln T$ no BIC.
5. **Decisão:** A, que é menor e prevê melhor.

**A Q4 c):** o erro de $h$ passos soma $h$ choques futuros, então a variância $\sigma^2\sum_{j\lt h}\psi_j^2$ cresce com $h$.

## 6. O cartão do Dickey-Fuller (a regra que inverteu)

$$
\underbrace{\ \cdots\ -4\quad\ \ }_{\textbf{rejeita}}\ \Big|_{\ \text{crítico } -3{,}45}\ \underbrace{\quad -2{,}8\quad -1\quad 0\ \cdots}_{\text{não rejeita}}
$$

- **$\tau$:** rejeita se for **menor**, ou seja, mais à esquerda. Um $-2{,}80$ fica à direita de $-3{,}45$: **não rejeita**.
- **$\phi$:** rejeita se for **maior** que o **crítico do próprio $\phi$** (6,49 para o $\phi_3$; 4,71 para o $\phi_1$).
- **Ordem:** modelo 3, $\phi_3$, modelo 2, $\phi_1$, modelo 1. Para no primeiro "rejeita".

## 7. O que fazer com o tempo até a prova

1. **10 minutos:** refazer a **Q2 b)** do Simulado 05 em folha branca, com $E(\varepsilon_ty_{t-1})=0$, e conferir $\rho_1=\phi=-0{,}5$.
2. **10 minutos:** refazer a **Q3 a)** pelas linhas (1)–(7) acima, sem olhar. É a sua conta dos quatro termos.
3. **5 minutos:** escrever de memória **I, E, D, P**, com a ferramenta de cada etapa.
4. **5 minutos:** o cartão do Dickey-Fuller, refazendo a questão extra com a regra certa.
5. **Na prova:**
   - **15 minutos por questão**;
   - comece pelos itens curtos (raízes, contas de previsão, leitura da tabela);
   - em cada $\rho$, confira que $\lvert\rho\rvert\le1$ e, num AR(1), que $\rho_1=\phi$.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| pv_s5_q1_var | 54 |
| pv_s5_q1_cov | 37,5 |
| pv_s5_q1_corr | 0,8333 |
| pv_s5_q1_g0 | 5,6 |
| pv_s5_q1_rho1 | -0,3036 |
| pv_s5_q1_rho2 | 0,1429 |
| pv_s5_q2_raiz | -2 |
| pv_s5_q2_g0 | 4 |
| pv_s5_q2_g1 | -2 |
| pv_s5_q2_rho1 | -0,5 |
| pv_s5_q2_rho2 | 0,25 |
| pv_s5_q2_rho3 | -0,125 |
| pv_s5_q3_g0 | 1,64 |
| pv_s5_q3_g4 | -0,8 |
| pv_s5_q3_rho4 | -0,4878 |
| pv_s5_q3_facp4 | -0,4878 |
| pv_s5_q3_facp8 | -0,3123 |
| pv_s5_q3_facp12 | -0,2215 |
| pv_s5_q3_cruzado | 0,24 |
| pv_s5_q3_h_max_res | 5 |
| pv_s5_q4_daic | 0,6 |
| pv_s5_q4_dbic | 2,2 |
| pv_s5_extra_a | 1 |
| pv_s5_extra_b | 1 |
-->
