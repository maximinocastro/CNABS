#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

User Function BRADBAN()        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_BANCO,")

/////  PROGRAMA PARA SEPARAR O BANCO DO FORNECEDOR
//// PAGFOR - POSICOES ( 96 - 98 )

_BANCO  :=  SUBSTR(SE2->E2_CODBAR,1,3)

IF SUBSTR(SE2->E2_CODBAR,1,3) # "237"
   _BANCO  :=   "000" //SE2->E2_RUBCOF
Else
   _BANCO := SUBSTR(SE2->E2_CODBAR,1,3)
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 14/08/01 ==> __return(_BANCO)
Return(_BANCO)        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01
