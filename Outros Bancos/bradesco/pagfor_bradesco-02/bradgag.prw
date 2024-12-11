#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

user function bradgag()
local cNossoNum  := SUBSTR(SE2->E2_CODBAR,5,4)
local nDigSoma   := 0
local nModulo    := 11               // Variaveis conseguidas atraves do
local nBase      := 7                // Manual do banco
local cDigito1   := 0
local cDigito    := 0                // Determina o metodo do Calculo
local nBaseAtual := 2
local _bco:= substr(SE2->E2_CODBAR,1,3)
If _bco =='237'
	
	For nCont := Len(cNossoNum) To 1 Step -1
		nDigSoma := nDigSoma + (Val(SubStr(cNossoNum, nCont, 1)) * nBaseAtual)
		
		nBaseAtual := IIf(nBaseAtual < 7, nBaseAtual + 1, 2)
	Next
	
	cDigito1    := VAL(Str(Mod(nDigSoma, nModulo), 0))
	cDigito     :=  nModulo - cDigito1
	if (cDigito)=0
		cDigito:=0
	elseif (cDigito)=1
		cDigito:=0
	endif
Endif
return(cDigito)
