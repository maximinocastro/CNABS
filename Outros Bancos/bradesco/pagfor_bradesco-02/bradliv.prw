#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

User Function BRADLIV()        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_AMODEL,")

/////  PROGRAMA PARA INDICAR A MODALIDADE DO PAGAMENTO POS.264-265
_Campo1:=' '
_Campo2:=' '
_Campo3:=' '
_cLivre:= ''          
_agencia:= ' '
_digitoAg:= ' '
_carteira:=' '
_nossoNum:=' '
_contaCor:=' '
_zero:= ' '



IF SUBSTR(SE2->E2_CODBAR,1,3) # '237'
_Campo1:= substr(SE2->E2_CODBAR,5,5)
_Campo2:= substr(SE2->E2_CODBAR,11,10)
_Campo3:= substr(SE2->E2_CODBAR,22,10)
_cLivre := _Campo1 + _Campo2 + _Campo3
ELse               
_agencia:= SUBSTR(SE2->E2_CODBAR,5,4)
_digitoAg:= SUBSTR(SE2->E2_CODBAR,10,1)
_carteira:= "0" + SUBS(SE2->E2_CODBAR,11,1)
_nossoNum:=SUBSTR(SE2->E2_CODBAR,12,09) 
_contaCor:=SUBSTR(SE2->E2_CODBAR,24,7)
_nossoNum1:=SUBSTR(SE2->E2_CODBAR,22,2)
_zero:= "0"

  _cLivre := _agencia + _carteira +_nossoNum + _nossoNum1 +_contaCor + _zero 
endif

// Substituido pelo assistente de conversao do AP5 IDE em 14/08/01 ==> __Return(_aModel)
Return(_cLivre)        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01
