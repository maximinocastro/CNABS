#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

User Function BRADNOS()        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_RETNOS,")

//// RETORNA O NOSSO NUMERO QUANDO COM VALOR NO E2_CODBAR, E ZEROS QUANDO NAO
//// TEM VALOR POSICAO ( 142 - 150 )

IF SUBS(SE2->E2_CODBAR,01,3) != "237"
    _RETNOS := "000000000000"
Else
    _RETNOS := SUBSTR(SE2->E2_CODBAR,12,11)
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 14/08/01 ==> __return(_RETNOS)
Return(_RETNOS)        // incluido pelo assistente de conversao do AP5 IDE em 14/08/01
