#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

User Function BRADCAR()        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_RETCAR,")

////  PROGRAMA PARA SELECIONAR A CARTEIRA NO CODIGO DE BARRAS QUANDO
////  NAO TIVER TEM QUE SER COLOCADO "00"

IF SUBS(SE2->E2_CODBAR,01,3) != "237"
   _Retcar := "000"
Else
   _Retcar := "00" + SUBS(SE2->E2_CODBAR,11,1)
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 14/08/01 ==> __return(_Retcar)
Return(_Retcar)        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01
