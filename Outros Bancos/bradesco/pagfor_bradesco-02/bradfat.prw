#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

User Function BRADFAT()        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_RETFAT,")

////  PROGRAMA PARA SELECIONAR A CARTEIRA NO CODIGO DE BARRAS QUANDO
////  NAO TIVER TEM QUE SER COLOCADO "00"

   _RetFat := SUBSTR(SE2->E2_CODBAR,34,4)

// Substituido pelo assistente de conversao do AP5 IDE em 14/08/01 ==> __return(_Retcar)
Return(_RetFat)        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01
