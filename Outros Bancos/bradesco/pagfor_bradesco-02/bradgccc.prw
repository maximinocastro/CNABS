#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

user function bradgccc()
local _bco:= substr(SE2->E2_CODBAR,1,3)
If _bco =='237'
	cCorrente := "000000"+SUBST(SE2->E2_CODBAR,24,7)   
else
	cCorrente:="00000000000"
Endif
return(cCorrente)
