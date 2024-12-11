#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/06/01

User Function BRADDCT()

   _nAux:=AT("-",SA2->A2_CTAFOR)
   _nAux:= _nAux +1
   _cRet:="0"+ SUBSTR(SA2->A2_CTAFOR,_nAux,1)
Return(_cRet)