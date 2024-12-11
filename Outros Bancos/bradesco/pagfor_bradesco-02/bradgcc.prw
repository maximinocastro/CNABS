#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

user function bradgcc()
  local cNossoNum  := SUBSTR(SE2->E2_CODBAR,24,7)
//local cNossoNum  := '0008800'

  Local nDigSoma   := 0

  local nModulo    := 11               // Variaveis conseguidas atraves do
  local nBase      := 7                // Manual do banco
  local cDigito1   := 0
  local cDigito    := 0                // Determina o metodo do Calculo
                                  // No caso Modulo 11 com base 7 (Pag. 15)
   
  local nBaseAtual := 2
   
   For nCont := Len(cNossoNum) To 1 Step -1
       nDigSoma := nDigSoma + (Val(SubStr(cNossoNum, nCont, 1)) * nBaseAtual)

       nBaseAtual := IIf(nBaseAtual < 7, nBaseAtual + 1, 2)
   Next
   
   cDigito1    := val(Str(Mod(nDigSoma, nModulo), 0))
   cDigito     :=  nModulo - cDigito1
   cDigito3    := str(cDigito,0)
    if (cDigito)=0 
       cDigito:=0
    elseif (cDigito)=1
       cDigito:=0
    endif 
  return(cDigito)