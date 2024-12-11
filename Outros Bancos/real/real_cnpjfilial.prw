User Function CNPJFILIAL_REAL()
_cRet:=" "

IF(EMPTY(SA1->A1_CGC) .OR. LEN(SA1->A1_CGC)<>14)  // CPF ou sem cadastro CNPJ
	_cRet:="000"
Else // CNPJ
	_cRet:=SUBS(SA1->A1_CGC,10,3)
Endif

                         
RETURN(_cRet)


