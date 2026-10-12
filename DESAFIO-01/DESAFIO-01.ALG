Algoritmo "DESAFIO-01"
// Disciplina  : Algoritmo e Lógica de Programação
// Professor   : André Olímpio
// Descrição   : Desafio 1 - UniLibrary, sistema de gerenciamento de biblioteca
// Autor(a)    : Vinicius de Paulo Garcia
// Data atual  : 11/10/2026

const
   // capacidades
   MAX_LIVROS = 40
   MAX_CATEGORIAS = 5
   // categorias
   TECNOLOGIA = 1
   EXATAS = 2
   HUMANAS = 3
   NEGOCIOS = 4
   LITERATURA = 5
   // status do livro
   DISPONIVEL = 1
   INDISPONIVEL = 0
   // colunas da matriz de movimentacoes
   EMPRESTIMO = 1
   DEVOLUCAO = 2
   // limites de validacao
   ANO_MIN = 1750
   ANO_MAX = 2026
   QTD_MAX = 100

tipo
   Livro = registro
      codigo: inteiro
      titulo: caractere
      autor: caractere
      ano: inteiro
      categoria: inteiro
      qtdTotal: inteiro
      qtdDisponivel: inteiro
      qtdEmprestimos: inteiro
      status: inteiro
   fimregistro

Var
   // variaveis globais: usadas por varias sub-rotinas
   acervo: vetor[1..MAX_LIVROS] de Livro
   movimentacoes: vetor[1..MAX_CATEGORIAS, 1..2] de inteiro
   qtdLivros: inteiro
   // vetores auxiliares da busca recursiva (copia ordenada dos codigos)
   ordCod: vetor[1..MAX_LIVROS] de inteiro
   ordPos: vetor[1..MAX_LIVROS] de inteiro

// ---------------------------------------------------------------
// Pausa para o usuario ler a tela antes de voltar ao menu
// ---------------------------------------------------------------
procedimento pauso
var
   tecla: caractere
inicio
   escreval("")
   escreva("Digite qualquer tecla e ENTER para continuar... ")
   leia(tecla)
fimprocedimento

// ---------------------------------------------------------------
// Inicializa as estruturas (contador e matriz zerada)
// ---------------------------------------------------------------
procedimento inicializar
var
   l, c: inteiro
inicio
   qtdLivros <- 0
   para l de 1 ate MAX_CATEGORIAS faca
      para c de 1 ate 2 faca
         movimentacoes[l, c] <- 0
      fimpara
   fimpara
fimprocedimento

// ---------------------------------------------------------------
// Converte o numero da categoria em texto
// ---------------------------------------------------------------
funcao nomeCategoria(cat: inteiro): caractere
var
   nome: caractere
inicio
   nome <- "Invalida"
   se cat = TECNOLOGIA entao
      nome <- "Tecnologia"
   fimse
   se cat = EXATAS entao
      nome <- "Ciencias Exatas"
   fimse
   se cat = HUMANAS entao
      nome <- "Ciencias Humanas"
   fimse
   se cat = NEGOCIOS entao
      nome <- "Administracao e Negocios"
   fimse
   se cat = LITERATURA entao
      nome <- "Literatura"
   fimse
   retorne nome
fimfuncao

// ---------------------------------------------------------------
// Converte o status numerico em texto
// ---------------------------------------------------------------
funcao nomeStatus(s: inteiro): caractere
var
   nome: caractere
inicio
   se s = DISPONIVEL entao
      nome <- "DISPONIVEL"
   senao
      nome <- "INDISPONIVEL"
   fimse
   retorne nome
fimfuncao

// ---------------------------------------------------------------
// Quantidade de exemplares atualmente emprestados do livro na posicao p
// ---------------------------------------------------------------
funcao qtdEmprestada(p: inteiro): inteiro
inicio
   retorne acervo[p].qtdTotal - acervo[p].qtdDisponivel
fimfuncao

// ---------------------------------------------------------------
// Busca linear pelo codigo. Retorna a posicao ou 0 se nao achar.
// ---------------------------------------------------------------
funcao buscar(cod: inteiro; qtd: inteiro): inteiro
var
   k, achou: inteiro
inicio
   achou <- 0
   para k de 1 ate qtd faca
      se acervo[k].codigo = cod entao
         achou <- k
      fimse
   fimpara
   retorne achou
fimfuncao

// ---------------------------------------------------------------
// Mostra todas as informacoes do livro na posicao p
// ---------------------------------------------------------------
procedimento exibirLivro(p: inteiro)
inicio
   escreval("Codigo: ", acervo[p].codigo)
   escreval("Titulo: ", acervo[p].titulo)
   escreval("Autor: ", acervo[p].autor)
   escreval("Ano: ", acervo[p].ano)
   escreval("Categoria: ", nomeCategoria(acervo[p].categoria))
   escreval("Exemplares (total): ", acervo[p].qtdTotal)
   escreval("Disponiveis: ", acervo[p].qtdDisponivel)
   escreval("Emprestimos realizados: ", acervo[p].qtdEmprestimos)
   escreval("Status: ", nomeStatus(acervo[p].status))
fimprocedimento

// ---------------------------------------------------------------
// 1. Cadastro de livro (com validacao de todos os campos)
// ---------------------------------------------------------------
procedimento cadastrar
var
   i, j, cod, anoLido, catLida, qtdLida: inteiro
   repetido: logico
inicio
   limpatela
   se qtdLivros >= MAX_LIVROS entao
      escreval("Capacidade maxima atingida! Nao e possivel cadastrar mais livros.")
   senao
      i <- qtdLivros + 1

      // codigo: positivo e unico
      repita
         escreva("Codigo do livro: ")
         leia(cod)
         repetido <- falso
         para j de 1 ate qtdLivros faca
            se acervo[j].codigo = cod entao
               repetido <- verdadeiro
            fimse
         fimpara
         se repetido = verdadeiro entao
            escreval("Codigo duplicado! Digite outro.")
         fimse
         se cod <= 0 entao
            escreval("Codigo invalido! Use um numero maior que zero.")
         fimse
      ate (repetido = falso) e (cod > 0)

      escreva("Titulo: ")
      leia(acervo[i].titulo)
      escreva("Autor: ")
      leia(acervo[i].autor)

      // ano: entre ANO_MIN e ANO_MAX
      repita
         escreva("Ano de publicacao (", ANO_MIN, " a ", ANO_MAX, "): ")
         leia(anoLido)
         se (anoLido < ANO_MIN) ou (anoLido > ANO_MAX) entao
            escreval("Ano invalido!")
         fimse
      ate (anoLido >= ANO_MIN) e (anoLido <= ANO_MAX)

      // categoria: entre 1 e MAX_CATEGORIAS
      escreval("Categorias:")
      escreval(TECNOLOGIA, " - Tecnologia")
      escreval(EXATAS, " - Ciencias Exatas")
      escreval(HUMANAS, " - Ciencias Humanas")
      escreval(NEGOCIOS, " - Administracao e Negocios")
      escreval(LITERATURA, " - Literatura")
      repita
         escreva("Categoria: ")
         leia(catLida)
         se (catLida < TECNOLOGIA) ou (catLida > MAX_CATEGORIAS) entao
            escreval("Categoria inexistente!")
         fimse
      ate (catLida >= TECNOLOGIA) e (catLida <= MAX_CATEGORIAS)

      // quantidade: de 1 ate QTD_MAX
      repita
         escreva("Quantidade de exemplares: ")
         leia(qtdLida)
         se (qtdLida <= 0) ou (qtdLida > QTD_MAX) entao
            escreval("Quantidade invalida! Use de 1 a ", QTD_MAX, ".")
         fimse
      ate (qtdLida >= 1) e (qtdLida <= QTD_MAX)

      // so grava no vetor depois de tudo validado
      acervo[i].codigo <- cod
      acervo[i].ano <- anoLido
      acervo[i].categoria <- catLida
      acervo[i].qtdTotal <- qtdLida
      acervo[i].qtdDisponivel <- qtdLida
      acervo[i].qtdEmprestimos <- 0
      acervo[i].status <- DISPONIVEL
      qtdLivros <- i
      escreval("")
      escreval("Livro cadastrado com sucesso!")
   fimse
   pauso
fimprocedimento

// ---------------------------------------------------------------
// 2. Listar acervo
// ---------------------------------------------------------------
procedimento listarAcervo
var
   k: inteiro
inicio
   limpatela
   se qtdLivros = 0 entao
      escreval("Catalogo vazio.")
   senao
      para k de 1 ate qtdLivros faca
         exibirLivro(k)
         escreval("------------------------------")
      fimpara
   fimse
   pauso
fimprocedimento

// ---------------------------------------------------------------
// 3. Consultar livro (usa a funcao buscar)
// ---------------------------------------------------------------
procedimento consultar
var
   cod, p: inteiro
inicio
   limpatela
   se qtdLivros = 0 entao
      escreval("Catalogo vazio. Cadastre um livro primeiro.")
   senao
      escreva("Codigo do livro: ")
      leia(cod)
      p <- buscar(cod, qtdLivros)
      se p = 0 entao
         escreval("Livro nao encontrado!")
      senao
         escreval("")
         exibirLivro(p)
      fimse
   fimse
   pauso
fimprocedimento

// ---------------------------------------------------------------
// 4. Emprestimo
// ---------------------------------------------------------------
procedimento realizarEmprestimo
var
   cod, p: inteiro
   existe: logico
   resp: caractere
inicio
   limpatela
   se qtdLivros = 0 entao
      escreval("Catalogo vazio.")
   senao
      escreva("Codigo do livro para emprestimo: ")
      leia(cod)
      p <- buscar(cod, qtdLivros)
      se p > 0 entao
         existe <- verdadeiro
      senao
         existe <- falso
      fimse
      se nao existe entao
         escreval("Livro nao encontrado!")
      senao
         // existe E ha exemplar E status permite
         se (acervo[p].qtdDisponivel > 0) e (acervo[p].status = DISPONIVEL) entao
            escreval("Livro: ", acervo[p].titulo)
            escreval("Disponiveis: ", acervo[p].qtdDisponivel)
            repita
               escreva("Confirmar emprestimo? (s/n): ")
               leia(resp)
               resp <- minusc(resp)
            ate (resp = "s") ou (resp = "n")
            se resp = "s" entao
               acervo[p].qtdDisponivel <- acervo[p].qtdDisponivel - 1
               acervo[p].qtdEmprestimos <- acervo[p].qtdEmprestimos + 1
               movimentacoes[acervo[p].categoria, EMPRESTIMO] <- movimentacoes[acervo[p].categoria, EMPRESTIMO] + 1
               se acervo[p].qtdDisponivel = 0 entao
                  acervo[p].status <- INDISPONIVEL
               fimse
               escreval("Emprestimo realizado! Restam ", acervo[p].qtdDisponivel, " exemplar(es).")
            senao
               escreval("Emprestimo cancelado.")
            fimse
         senao
            escreval("Emprestimo sem disponibilidade: nao ha exemplares para emprestar.")
         fimse
      fimse
   fimse
   pauso
fimprocedimento

// ---------------------------------------------------------------
// 5. Devolucao
// ---------------------------------------------------------------
procedimento realizarDevolucao
var
   cod, p, emprestada: inteiro
inicio
   limpatela
   se qtdLivros = 0 entao
      escreval("Catalogo vazio.")
   senao
      escreva("Codigo do livro a devolver: ")
      leia(cod)
      p <- buscar(cod, qtdLivros)
      se p = 0 entao
         escreval("Livro nao encontrado!")
      senao
         emprestada <- qtdEmprestada(p)
         // precisa haver exemplar emprestado E a devolucao nao pode passar do total
         se (emprestada > 0) e (acervo[p].qtdDisponivel < acervo[p].qtdTotal) entao
            acervo[p].qtdDisponivel <- acervo[p].qtdDisponivel + 1
            acervo[p].status <- DISPONIVEL
            movimentacoes[acervo[p].categoria, DEVOLUCAO] <- movimentacoes[acervo[p].categoria, DEVOLUCAO] + 1
            escreval("Devolucao realizada! Disponiveis: ", acervo[p].qtdDisponivel, " de ", acervo[p].qtdTotal)
         senao
            escreval("Devolucao invalida: todos os exemplares ja estao na biblioteca.")
         fimse
      fimse
   fimse
   pauso
fimprocedimento

// ---------------------------------------------------------------
// 6. Livros disponiveis
// ---------------------------------------------------------------
procedimento listarDisponiveis
var
   k, cont: inteiro
inicio
   limpatela
   cont <- 0
   para k de 1 ate qtdLivros faca
      se (acervo[k].qtdDisponivel > 0) e (acervo[k].status = DISPONIVEL) entao
         escreval(acervo[k].codigo, " | ", acervo[k].titulo, " | ", acervo[k].autor, " | Disponiveis: ", acervo[k].qtdDisponivel)
         cont <- cont + 1
      fimse
   fimpara
   se cont = 0 entao
      escreval("Nenhum livro disponivel (ou catalogo vazio).")
   senao
      escreval("")
      escreval("Total de titulos disponiveis: ", cont)
   fimse
   pauso
fimprocedimento

// ---------------------------------------------------------------
// Troca dois livros de posicao (registro completo, campo a campo)
// ---------------------------------------------------------------
procedimento trocarLivros(a: inteiro; b: inteiro)
var
   auxInt: inteiro
   auxTxt: caractere
inicio
   auxInt <- acervo[a].codigo
   acervo[a].codigo <- acervo[b].codigo
   acervo[b].codigo <- auxInt

   auxTxt <- acervo[a].titulo
   acervo[a].titulo <- acervo[b].titulo
   acervo[b].titulo <- auxTxt

   auxTxt <- acervo[a].autor
   acervo[a].autor <- acervo[b].autor
   acervo[b].autor <- auxTxt

   auxInt <- acervo[a].ano
   acervo[a].ano <- acervo[b].ano
   acervo[b].ano <- auxInt

   auxInt <- acervo[a].categoria
   acervo[a].categoria <- acervo[b].categoria
   acervo[b].categoria <- auxInt

   auxInt <- acervo[a].qtdTotal
   acervo[a].qtdTotal <- acervo[b].qtdTotal
   acervo[b].qtdTotal <- auxInt

   auxInt <- acervo[a].qtdDisponivel
   acervo[a].qtdDisponivel <- acervo[b].qtdDisponivel
   acervo[b].qtdDisponivel <- auxInt

   auxInt <- acervo[a].qtdEmprestimos
   acervo[a].qtdEmprestimos <- acervo[b].qtdEmprestimos
   acervo[b].qtdEmprestimos <- auxInt

   auxInt <- acervo[a].status
   acervo[a].status <- acervo[b].status
   acervo[b].status <- auxInt
fimprocedimento

// ---------------------------------------------------------------
// 7. Ranking do acervo (Bubble Sort com 3 criterios)
//    1) mais emprestimos  2) menos disponiveis  3) titulo (A-Z)
// ---------------------------------------------------------------
procedimento ranking
var
   r, h, l: inteiro
   troca: logico
inicio
   limpatela
   se qtdLivros = 0 entao
      escreval("Catalogo vazio.")
   senao
      para r de qtdLivros ate 2 passo -1 faca
         para h de 1 ate r - 1 faca
            troca <- falso
            se acervo[h].qtdEmprestimos < acervo[h + 1].qtdEmprestimos entao
               troca <- verdadeiro
            senao
               se acervo[h].qtdEmprestimos = acervo[h + 1].qtdEmprestimos entao
                  se acervo[h].qtdDisponivel > acervo[h + 1].qtdDisponivel entao
                     troca <- verdadeiro
                  senao
                     se acervo[h].qtdDisponivel = acervo[h + 1].qtdDisponivel entao
                        se minusc(acervo[h].titulo) > minusc(acervo[h + 1].titulo) entao
                           troca <- verdadeiro
                        fimse
                     fimse
                  fimse
               fimse
            fimse
            se troca = verdadeiro entao
               trocarLivros(h, h + 1)
            fimse
         fimpara
      fimpara
      escreval("POSICAO | LIVRO | AUTOR | EMPRESTIMOS | DISPONIVEIS")
      para l de 1 ate qtdLivros faca
         escreval(l, " | ", acervo[l].titulo, " | ", acervo[l].autor, " | ", acervo[l].qtdEmprestimos, " | ", acervo[l].qtdDisponivel)
      fimpara
   fimse
   pauso
fimprocedimento

// ---------------------------------------------------------------
// Processamento da matriz (repeticoes aninhadas) + total de movimentacoes
// ---------------------------------------------------------------
procedimento processarMatriz
var
   l, c, totalMov: inteiro
inicio
   totalMov <- 0
   escreval("CATEGORIA | EMPRESTIMOS | DEVOLUCOES")
   para l de 1 ate MAX_CATEGORIAS faca
      escreva(nomeCategoria(l), " | ")
      para c de 1 ate 2 faca
         escreva(movimentacoes[l, c], " | ")
         totalMov <- totalMov + movimentacoes[l, c]
      fimpara
      escreval("")
   fimpara
   escreval("Total de movimentacoes na matriz: ", totalMov)
fimprocedimento

// ---------------------------------------------------------------
// 8. Estatisticas gerais (contadores e acumuladores)
// ---------------------------------------------------------------
procedimento estatisticas
var
   k, c: inteiro
   totEx, disp, emprestados, totEmp, totDev: inteiro
   iMaxEmp, iMaxDisp, catMax: inteiro
   livrosCat: vetor[1..MAX_CATEGORIAS] de inteiro
   pctDisp, pctEmpr, media: real
inicio
   limpatela
   se qtdLivros = 0 entao
      escreval("Catalogo vazio. Nao ha estatisticas.")
   senao
      totEx <- 0
      disp <- 0
      iMaxEmp <- 1
      iMaxDisp <- 1
      para c de 1 ate MAX_CATEGORIAS faca
         livrosCat[c] <- 0
      fimpara

      // percorre o acervo acumulando totais
      para k de 1 ate qtdLivros faca
         totEx <- totEx + acervo[k].qtdTotal
         disp <- disp + acervo[k].qtdDisponivel
         livrosCat[acervo[k].categoria] <- livrosCat[acervo[k].categoria] + 1
         se acervo[k].qtdEmprestimos > acervo[iMaxEmp].qtdEmprestimos entao
            iMaxEmp <- k
         fimse
         se acervo[k].qtdDisponivel > acervo[iMaxDisp].qtdDisponivel entao
            iMaxDisp <- k
         fimse
      fimpara
      emprestados <- totEx - disp

      // percorre a matriz acumulando movimentacoes
      totEmp <- 0
      totDev <- 0
      catMax <- 1
      para c de 1 ate MAX_CATEGORIAS faca
         totEmp <- totEmp + movimentacoes[c, EMPRESTIMO]
         totDev <- totDev + movimentacoes[c, DEVOLUCAO]
         se movimentacoes[c, EMPRESTIMO] > movimentacoes[catMax, EMPRESTIMO] entao
            catMax <- c
         fimse
      fimpara

      pctDisp <- (disp / totEx) * 100
      pctEmpr <- (emprestados / totEx) * 100
      media <- totEx / qtdLivros

      escreval("===== ESTATISTICAS GERAIS =====")
      escreval("Livros cadastrados: ", qtdLivros)
      escreval("Total de exemplares: ", totEx)
      escreval("Exemplares disponiveis: ", disp)
      escreval("Exemplares emprestados agora: ", emprestados)
      escreval("Total de emprestimos realizados: ", totEmp)
      escreval("Total de devolucoes: ", totDev)
      escreval("Percentual disponiveis: ", pctDisp:6:2, "%")
      escreval("Percentual emprestados: ", pctEmpr:6:2, "%")
      escreval("Media de exemplares por livro: ", media:6:2)
      se acervo[iMaxEmp].qtdEmprestimos = 0 entao
         escreval("Livro com mais emprestimos: nenhum emprestimo ainda")
      senao
         escreval("Livro com mais emprestimos: ", acervo[iMaxEmp].titulo, " (", acervo[iMaxEmp].qtdEmprestimos, ")")
      fimse
      escreval("Livro com mais disponiveis: ", acervo[iMaxDisp].titulo, " (", acervo[iMaxDisp].qtdDisponivel, ")")
      se totEmp = 0 entao
         escreval("Categoria com mais emprestimos: nenhuma ainda")
      senao
         escreval("Categoria com mais emprestimos: ", nomeCategoria(catMax))
      fimse
      escreval("")
      escreval("Livros por categoria:")
      para c de 1 ate MAX_CATEGORIAS faca
         escreval(nomeCategoria(c), ": ", livrosCat[c])
      fimpara
      escreval("")
      escreval("Movimentacoes por categoria:")
      processarMatriz
   fimse
   pauso
fimprocedimento

// ---------------------------------------------------------------
// Busca binaria RECURSIVA em um vetor ordenado de codigos
//   caso-base 1: achou (retorna a posicao)
//   caso-base 2: esq > dir (intervalo vazio, retorna 0)
//   caso recursivo: repete na metade inferior ou superior
// ---------------------------------------------------------------
funcao buscaBinaria(cod: inteiro; esq: inteiro; dir: inteiro): inteiro
var
   mid: inteiro
inicio
   se esq > dir entao
      retorne 0
   senao
      mid <- (esq + dir) \ 2
      se ordCod[mid] = cod entao
         retorne mid
      senao
         se cod < ordCod[mid] entao
            retorne buscaBinaria(cod, esq, mid - 1)
         senao
            retorne buscaBinaria(cod, mid + 1, dir)
         fimse
      fimse
   fimse
fimfuncao

// ---------------------------------------------------------------
// 9. Busca recursiva no catalogo
//    Copia os codigos, ordena a copia (Selection Sort) e busca.
// ---------------------------------------------------------------
procedimento buscaRecursiva
var
   k, j, menor, cod, p, posOrd, auxCod, auxPos: inteiro
inicio
   limpatela
   se qtdLivros = 0 entao
      escreval("Catalogo vazio.")
   senao
      para k de 1 ate qtdLivros faca
         ordCod[k] <- acervo[k].codigo
         ordPos[k] <- k
      fimpara

      // Selection Sort pelos codigos (carrega a posicao original junto)
      para k de 1 ate qtdLivros - 1 faca
         menor <- k
         para j de k + 1 ate qtdLivros faca
            se ordCod[j] < ordCod[menor] entao
               menor <- j
            fimse
         fimpara
         se menor <> k entao
            auxCod <- ordCod[k]
            ordCod[k] <- ordCod[menor]
            ordCod[menor] <- auxCod
            auxPos <- ordPos[k]
            ordPos[k] <- ordPos[menor]
            ordPos[menor] <- auxPos
         fimse
      fimpara

      escreva("Codigos ordenados: ")
      para k de 1 ate qtdLivros faca
         escreva(ordCod[k], " ")
      fimpara
      escreval("")
      escreva("Codigo a buscar: ")
      leia(cod)
      posOrd <- buscaBinaria(cod, 1, qtdLivros)
      se posOrd = 0 entao
         escreval("Busca recursiva: livro nao encontrado.")
      senao
         p <- ordPos[posOrd]
         escreval("Busca recursiva: encontrado na posicao ", posOrd, " do vetor ordenado.")
         escreval("")
         exibirLivro(p)
      fimse
   fimse
   pauso
fimprocedimento

// ---------------------------------------------------------------
// Menu principal (multipla escolha)
// ---------------------------------------------------------------
procedimento menu
var
   opcao: inteiro
   sair: logico
inicio
   sair <- falso
   repita
      limpatela
      escreval("UNILIBRARY - SISTEMA DE GERENCIAMENTO DE BIBLIOTECA")
      escreval("")
      escreval("1. Cadastrar livro")
      escreval("2. Listar acervo")
      escreval("3. Consultar livro")
      escreval("4. Realizar emprestimo")
      escreval("5. Realizar devolucao")
      escreval("6. Exibir livros disponiveis")
      escreval("7. Exibir ranking do acervo")
      escreval("8. Exibir estatisticas")
      escreval("9. Realizar busca recursiva")
      escreval("10. Encerrar sistema")
      escreval("")
      escreva("Escolha uma opcao: ")
      leia(opcao)
      escolha opcao
         caso  1
            cadastrar
         caso 2
            listarAcervo
         caso 3
            consultar
         caso 4
            realizarEmprestimo
         caso 5
            realizarDevolucao
         caso 6
            listarDisponiveis
         caso 7
            ranking
         caso 8
            estatisticas
         caso 9
            buscaRecursiva
         caso 10
            sair <- verdadeiro
            escreval("Encerrando o sistema. Ate logo!")
         outrocaso
            escreval("Opcao invalida! Digite um numero de 1 a 10.")
            pauso
      fimescolha
   ate sair = verdadeiro
fimprocedimento

// ---------------------------------------------------------------
// Algoritmo principal: so inicializa e chama o menu
// ---------------------------------------------------------------
Inicio
   inicializar
   menu
Fimalgoritmo