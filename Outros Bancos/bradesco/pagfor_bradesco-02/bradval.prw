#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

User Function BRADVAL()        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_VALOR,")

/// VALOR DO DOCUMENTO  DO CODIGO DE BARRA DA POSICAO 06 - 19, NO ARQUIVO E
/// DA POSICAO 190 - 204, QUANDO NAO FOR CODIGO DE BARRA VAI O VALOR DO SE2

_VALOR :=0

    _VALOR   :=  STRZERO(SUBSTR(SE2->CODBAR,38,10),10,0)


// Substituido pelo assistente de conversao do AP5 IDE em 14/08/01 ==> __return(_VALOR)
Return(_VALOR)        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01
