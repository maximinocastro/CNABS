#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

User Function BRADDIG()        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_AMODEL,")

/////  PROGRAMA PARA INDICAR A MODALIDADE DO PAGAMENTO POS.264-265
_DigVerif:=' '

_DigVerif:=  SUBSTR(SE2->E2_CODBAR,33,1)

// Substituido pelo assistente de conversao do AP5 IDE em 14/08/01 ==> __Return(_aModel)
Return(_DigVerif)        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01
