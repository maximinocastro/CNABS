#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

User Function BRADMOD()        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_AMODEL,")

/////  PROGRAMA PARA INDICAR A MODALIDADE DO PAGAMENTO POS.264-265

IF SUBSTR(SE2->E2_CODBAR,1,3) =='237'
   _aModel := "30" 
ELse               
  _aModel := "31" 
endif

// Substituido pelo assistente de conversao do AP5 IDE em 14/08/01 ==> __Return(_aModel)
Return(_aModel)        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01
