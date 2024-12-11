User Function CNPJ_REAL()
_cRet:=" "

If empty(SA1->A1_CGC)    // Cliente não tem CNPJ
	MSGSTOP("Cliente sem CNPJ ou CPF ==> "+TRIM(SA1->A1_COD)+SA1->A1_LOJA)
	_cRet = "000000000"
ElseIf LEN(SA1->A1_CGC)==14  // CNPJ
	_cRet := SUBS(SA1->A1_CGC,1,8)+SUBS(SA1->A1_CGC,9,1)
Else // só pode ser CPF
	_cRet := SUBS(SA1->A1_CGC,1,9)
Endif

                         
RETURN(_cRet)


