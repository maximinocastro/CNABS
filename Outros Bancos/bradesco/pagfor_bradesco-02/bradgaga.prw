#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

user function bradgaga()
local _bco:= substr(SE2->E2_CODBAR,1,3)
If _bco =='237'
	cDigito     := ' '
else
	cDigito:=0
Endif
return(cDigito)
