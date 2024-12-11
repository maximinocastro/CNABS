#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/09/00

User Function Pagcodbar(_Ccodbar,_Ctiporet)        // incluido pelo assistente de conversao do AP5 IDE em 26/09/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//* DENISE VIU - 24/01/2001
//* LEITOR DE CODIGO DE BARRA DE VARIOS BANCOS
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CTACED,_RETDIG,_DIG1,_DIG2,_DIG3,_DIG4")
SetPrvt("_DIG5,_DIG6,_DIG7,_MULT,_RESUL,_RESTO")
SetPrvt("_DIGITO,_CAGCED,_CDIGCTA,_CDIGAG,_CRET")

/////  PROGRAMA PARA SEPARAR COM BASE NO CODIGO DE BARRA
/////  OS CAMPOS BANCO DO CEDENTE
/////            AGENCIA DO CEDENTE
/////			 CONTA CORRENTE DO CEDENTE
/////            DIGITO DA CONTA CORRENTE DO CEDENTE
/////            DIGITO DA AGENCIA DO CEDENTE
/////  DE VARIOS BANCOS

_Cret   := SPACE(10)
_Cagced := SPACE(4)
_Cdigag := SPACE(3)
_Ctaced := SPACE(12)
_Cdigcta:= SPACE(4)
_cBanco := SUBSTR(_Ccodbar,1,3)
Do Case
   Case _cBanco == "237" 	// BRADESCO               
   	// Agencia-Digito do cedente
    _Cagced  := SUBSTR(_Ccodbar,20,4)

    _RETDIG := " "
    _DIG1   := SUBSTR(_Ccodbar,20,1)
    _DIG2   := SUBSTR(_Ccodbar,21,1)
    _DIG3   := SUBSTR(_Ccodbar,22,1)
    _DIG4   := SUBSTR(_Ccodbar,23,1)
    
    _MULT   := (VAL(_DIG1)*5) +  (VAL(_DIG2)*4) +  (VAL(_DIG3)*3) +   (VAL(_DIG4)*2)
    _RESUL  := INT(_MULT /11 )
    _RESTO  := INT(_MULT % 11)
    _DIGITO := STRZERO((11 - _RESTO),1,0)

    _RETDIG := IF( _resto == 0,"0",IF(_resto == 1,"P",_DIGITO))
    _Cdigag := _RETDIG

    // Conta-Digito do cedente
    _Ctaced  := SUBSTR(_Ccodbar,37,7)
    
    _RETDIG := " "
    _DIG1   := SUBSTR(_Ccodbar,37,1)
    _DIG2   := SUBSTR(_Ccodbar,38,1)
    _DIG3   := SUBSTR(_Ccodbar,39,1)
    _DIG4   := SUBSTR(_Ccodbar,40,1)
    _DIG5   := SUBSTR(_Ccodbar,41,1)
    _DIG6   := SUBSTR(_Ccodbar,42,1)
    _DIG7   := SUBSTR(_Ccodbar,43,1)
    
    _MULT   := (VAL(_DIG1)*2) +  (VAL(_DIG2)*7) +  (VAL(_DIG3)*6) +   (VAL(_DIG4)*5) +  (VAL(_DIG5)*4) +  (VAL(_DIG6)*3)  + (VAL(_DIG7)*2)
    _RESUL  := INT(_MULT /11 )
    _RESTO  := INT(_MULT % 11)
    _DIGITO := STRZERO((11 - _RESTO),1,0)

    _RETDIG := IF( _resto == 0,"0",IF(_resto == 1,"P",_DIGITO))
    _Cdigcta:= _RETDIG
                                            
  Case _cBanco == "341"		// ITAU
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,32,4)

    // Conta-Digito do cedente
    _Ctaced  :=  SUBSTR(_Ccodbar,36,5)
    _Cdigcta :=  SUBSTR(_Ccodbar,41,1)    

  Case _cBanco == "275"		// REAL
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,20,4)

    // Conta-Digito do cedente
    _Ctaced  :=  SUBSTR(_Ccodbar,24,7)
    _Cdigcta :=  SUBSTR(_Ccodbar,31,1)
                                   
  Case _cBanco == "641"		// BBVA
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,35,4)

    // Conta do cedente
    _Ctaced  := SUBSTR(_Ccodbar,39,5)

  Case _cBanco == "409"		// UNIBANCO
   	// Agencia-Digito do cedente
    _Cagced  := SUBSTR(_Ccodbar,28,4)
    _Cdigag  := SUBSTR(_Ccodbar,32,1)

  Case _cBanco == "001"		// BRASIL
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,31,4)

    // Conta do cedente
    _Ctaced  :=  SUBSTR(_Ccodbar,38,5)

  Case _cBanco == "392"		// FINASA  ???????????????
    // Conta-Digito do cedente
    _Ctaced  :=  SUBSTR(_Ccodbar,20,7)
    _Cdigcta :=  SUBSTR(_Ccodbar,27,1)

  Case _cBanco == "399"		// HSBC
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,31,4)

    // Conta do cedente
    _Ctaced  := SUBSTR(_Ccodbar,31,11)

  Case _cBanco == "320"		// BICBANCO
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,20,3)

    // Conta-Digito do cedente
    _Ctaced  := SUBSTR(_Ccodbar,23,8)
    _Cdigcta := SUBSTR(_Ccodbar,31,1)

  Case _cBanco == "291"		// BCN
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,19,4)

    // Conta-Digito do cedente
    _Ctaced  := SUBSTR(_Ccodbar,23,6)
    _Cdigcta := SUBSTR(_Ccodbar,29,1)

  Case _cBanco == "347"		// SUDAMERIS
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,20,3)

    // Conta-Digito do cedente
    _Ctaced  := SUBSTR(_Ccodbar,23,7)
    _Cdigcta := SUBSTR(_Ccodbar,30,1)

  Case _cBanco == "422"		// SAFRA
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,21,5)

    // Conta-Digito do cedente
    _Ctaced  := SUBSTR(_Ccodbar,26,8)
    _Cdigcta := SUBSTR(_Ccodbar,34,1)

  Case _cBanco == "453"		// BANCO RURAL   ??????????
   	// Agencia-Digito do cedente
    _Cagced  := SUBSTR(_Ccodbar,20,4)
    _Cdigag  := SUBSTR(_Ccodbar,24,2)

    // Conta-Digito do cedente
    _Ctaced  :=  SUBSTR(_Ccodbar,26,7)
    _Cdigcta :=  SUBSTR(_Ccodbar,33,1)

  Case _cBanco == "244"		// BANCO CIDADE
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,20,3)

    // Conta-Digito do cedente
    _Ctaced  := SUBSTR(_Ccodbar,23,6)
    _Cdigcta := SUBSTR(_Ccodbar,29,1)

  Case _cBanco == "151"		// NOSSA CAIXA NOSSO BANCO
   	// Agencia-Digito do cedente
    _Cagced  := SUBSTR(_Ccodbar,29,4)
    _Cdigag  := SUBSTR(_Ccodbar,33,1)

    // Conta do cedente
    _Ctaced  :=  SUBSTR(_Ccodbar,34,6)

  Case _cBanco == "033"		// BANESPA
   	// Agencia-Digito do cedente
    _Cagced  := SUBSTR(_Ccodbar,20,3)
    _Cdigag  := SUBSTR(_Ccodbar,23,2)

    // Conta-Digito do cedente
    _Ctaced  :=  SUBSTR(_Ccodbar,25,5)
    _Cdigcta :=  SUBSTR(_Ccodbar,30,1)

  Case _cBanco == "104"		// CAIXA ECONOMICA FEDERAL
   	// Agencia-Digito do cedente
    _Cagced  := SUBSTR(_Ccodbar,30,4)
    _Cdigag  := SUBSTR(_Ccodbar,34,3)

    // Conta do cedente
    _Ctaced  :=  SUBSTR(_Ccodbar,37,8)

  Case _cBanco == "611"		// BANCO PAULISTA
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,20,4)

    // Conta-Digito do cedente
    _Ctaced  :=  SUBSTR(_Ccodbar,24,9)
    _Cdigcta :=  SUBSTR(_Ccodbar,33,1)

  Case _cBanco == "389"		// MERCANTIL DO BRASIL
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,20,4)

    // Conta do cedente
    _Ctaced  := SUBSTR(_Ccodbar,35,9)

  Case _cBanco == "041"		// BANRISUL
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,22,3)

    // Conta do cedente
    _Ctaced  := SUBSTR(_Ccodbar,25,7)

  Case _cBanco == "353"		// BANCO SANTANDER
    // Conta-Digito do cedente
    _Ctaced  := SUBSTR(_Ccodbar,22,5)
    _Cdigcta := SUBSTR(_Ccodbar,27,1)

  Case _cBanco == "231"		// BANCO BOAVISTA
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,21,4)

    // Conta do cedente
    _Ctaced  := SUBSTR(_Ccodbar,25,8)

  Case _cBanco == "230"		// BANCO BANDEIRANTES
   	// Agencia do cedente
    _Cagced  := SUBSTR(_Ccodbar,23,3)

    // Conta-Digito do cedente
    _Ctaced  :=  SUBSTR(_Ccodbar,26,4)
    _Cdigcta :=  SUBSTR(_Ccodbar,30,1)

EndCase
if _ctiporet == "AGE"			// agencia do cedente
	_cret := _Cagced
elseif _ctiporet == "DAG"       // digito da agencia
	_cret := _Cdigag
elseif _ctiporet == "CTA"       // conta corrente do cedente
	_cret := _Ctaced
elseif _ctiporet == "DCT"       // digito da conta corrente
	_cret := _Cdigcta 
endif	
	         
// Substituido pelo assistente de conversao do AP5 IDE em 26/09/00 ==> __return(_Ctaced)
Return(_cret)        // incluido pelo assistente de conversao do AP5 IDE em 26/09/00
