#include "rwmake.ch"

/*/

funcao    bolaser_bd
autor     Salvador
data      Ago/2002
descricao imprime boleto em impressora laser com codigo de barras
cliente   total

/*/

User Function Bolaser_bd

/*/ izaias, incluido para evitar que, se filtrarmos todos os titulos para nao imprimir,
nao mostrar a tela de impressao/*/

dbSelectArea("SE1")
dbSetOrder(1)
dbSeek( xFilial("SE1") + "1  " + notaini + Space(01) + "NF")

nBoleto := 0

While !Eof() .and. e1_num >= notaini .and. e1_num <= notafim
	
	dbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5") + "ZX")
	
	If se1->e1_vend1 $ sx5->x5_descri .and. !Empty(se1->e1_vend1)
		dbSelectArea("SE1")
		dbSkip()
		Loop
	EndIf
	
	If empty(se1->e1_saldo) .or. se1->e1_emissao == se1->e1_vencto
		dbSelectArea("SE1")
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SE1")
	dbSkip()
	
	nBoleto += 1
	
EndDo

dbSelectArea("SE1")
dbGoTop()

If nBoleto == 0
	Return
EndIf

//Pergunte("FINA01",.F.) retirado por solitacao de fred, ago/2001
nImprime := .T.    //Pergunte("FINA01",.T.)

wnRel    := "RFINA01"

If !nImprime //.or. mv_par01 == 2
	Return
EndIf

tamanho   := "P"
Ctitulo   := "Impressao de Boleto"
cDesc1    := ""
cDesc2    := ""
cDesc3    := ""
nRegistro := 0
aReturn   := { "Branco", 1,"Administracao", 1, 2, 2, "",0 }
nomeprog  := "BOLASER_BD"
cString   := "SE1"       // TITULOS A RECEBER
nLastKey  := 0
aLinha    := { }
li        := 1
limite    := 80
lRodape   := .F.
m_pag     := 1
nTotal    := 0
nTotge    := 0
nAjuste   := 0

cString := "SE1"

nTotalTot := 0
nTotRegs  := 1
nPrcVen   := nCusto1 := 0

wnrel    := SetPrint(cString,wnrel,,CTitulo,cDesc1,cDesc2,cDesc3,.F.)

If nlastKey == 27
	Return(Nil)
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Relturn(Nil)
EndIf

RptStatus({|lEnd| LASERImp(@lEnd,wnRel,cString)},cTitulo)

Return

*-------------------------------------------*
Static FUNCTION LASERImp(lEnd,wnRel,cString)
*-------------------------------------------*

LOCAL lContinua := .T.
LOCAL aBol      :={}
LOCAL aRet      :=array(2)
LOCAL i
LOCAL j
LOCAL cMuni
LOCAL cCgc
LOCAL nNumVias := 1
LOCAL nNumpas  := 60
LOCAL lFirst   := .T.
LOCAL lFirst1  := .T.
LOCAL lEqual   := .F.
LOCAL cSimb    := ""
LOCAL cInd     := ""
LOCAL cEnd1    := ""
LOCAL cEnd2    := ""
LOCAL cEst     := ""
LOCAL cBoleto  := CriaVar("SA6->A6_BOLETO")
LOCAL cCarteira
LOCAL cDataProc
Local nTamCGC := 0

li      := 00
I       := 0
J 		  := 0

dbSelectArea("SA6")
dbSetOrder(1)
dbSeek(xFilial() + "237")   //mv_par02)

//Set Device To Printer
//Set Printer to LPT2

dbSelectArea("SE1")
dbSetOrder(1)
dbSeek( xFilial("SE1") + "1  " + notaini + Space(01) + "NF")

esc := CHR(27)
null := ""
PRINTER   := "L"
height    := 3.0 && 2

small_bar := 3.7                              && number of points per bar  3
wide_bar := ROUND(small_bar * 2.29,0)          && 2.25 x small_bar
dpl := 50                                      && dots per line 300dpi/6lpi = 50dpl

nb := esc+"*c"+TRANSFORM(small_bar,'99')+"a"+Alltrim(STR(height*dpl))+"b0P"+esc+"*p+"+TRANSFORM(small_bar,'99')+"X"
// Barra estreita
wb := esc+"*c"+TRANSFORM(wide_bar,'99')+"a"+Alltrim(STR(height*dpl))+"b0P"+esc+"*p+"+TRANSFORM(wide_bar,'99')+"X"
// Barra larga
ns := esc+"*p+"+TRANSFORM(small_bar,'99')+"X"
// Espaco estreito
ws := esc+"*p+"+TRANSFORM(wide_bar,'99')+"X"
// Espaco largo

_TpBar := "25"
If _TpBar == "25"
	// Representacao binaria dos numeros 1-Barras/Espacos largas (os)
	// 0-Barras/Espacos estreitas (os)
	char25 := {}
	AADD(char25,"10001")       && "1"
	AADD(char25,"01001")       && "2"
	AADD(char25,"11000")       && "3"
	AADD(char25,"00101")       && "4"
	AADD(char25,"10100")       && "5"
	AADD(char25,"01100")       && "6"
	AADD(char25,"00011")       && "7"
	AADD(char25,"10010")       && "8"
	AADD(char25,"01010")       && "9"
	AADD(char25,"00110")       && "0"
EndIf
If _TpBar == "39"
	// O Codigo tipo 39 NAO pode ser usados para boleto - deixo aqui como
	// se faz para referencia futura.
	
	*** adjust cusor position to start at top of line and return to bottom of line
	start := esc+"*p-50Y"
	_Fim := esc+"*p+50Y"
	chars := "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *$/+%"
	char := {}
	AADD(char,wb+ns+nb+ws+nb+ns+nb+ns+wb)       && "1"
	AADD(char,nb+ns+wb+ws+nb+ns+nb+ns+wb)       && "2"
	AADD(char,wb+ns+wb+ws+nb+ns+nb+ns+nb)       && "3"
	AADD(char,nb+ns+nb+ws+wb+ns+nb+ns+wb)       && "4"
	AADD(char,wb+ns+nb+ws+wb+ns+nb+ns+nb)       && "5"
	AADD(char,nb+ns+wb+ws+wb+ns+nb+ns+nb)       && "6"
	AADD(char,nb+ns+nb+ws+nb+ns+wb+ns+wb)       && "7"
	AADD(char,wb+ns+nb+ws+nb+ns+wb+ns+nb)       && "8"
	AADD(char,nb+ns+wb+ws+nb+ns+wb+ns+nb)       && "9"
	AADD(char,nb+ns+nb+ws+wb+ns+wb+ns+nb)       && "0"
	AADD(char,wb+ns+nb+ns+nb+ws+nb+ns+wb)       && "A"
	AADD(char,nb+ns+wb+ns+nb+ws+nb+ns+wb)       && "B"
	AADD(char,wb+ns+wb+ns+nb+ws+nb+ns+nb)       && "C"
	AADD(char,nb+ns+nb+ns+wb+ws+nb+ns+wb)       && "D"
	AADD(char,wb+ns+nb+ns+wb+ws+nb+ns+nb)       && "E"
	AADD(char,nb+ns+wb+ns+wb+ws+nb+ns+nb)       && "F"
	AADD(char,nb+ns+nb+ns+nb+ws+wb+ns+wb)       && "G"
	AADD(char,wb+ns+nb+ns+nb+ws+wb+ns+nb)       && "H"
	AADD(char,nb+ns+wb+ns+nb+ws+wb+ns+nb)       && "I"
	AADD(char,nb+ns+nb+ns+wb+ws+wb+ns+nb)       && "J"
	AADD(char,wb+ns+nb+ns+nb+ns+nb+ws+wb)       && "K"
	AADD(char,nb+ns+wb+ns+nb+ns+nb+ws+wb)       && "L"
	AADD(char,wb+ns+wb+ns+nb+ns+nb+ws+nb)       && "M"
	AADD(char,nb+ns+nb+ns+wb+ns+nb+ws+wb)       && "N"
	AADD(char,wb+ns+nb+ns+wb+ns+nb+ws+nb)       && "O"
	AADD(char,nb+ns+wb+ns+wb+ns+nb+ws+nb)       && "P"
	AADD(char,nb+ns+nb+ns+nb+ns+wb+ws+wb)       && "Q"
	AADD(char,wb+ns+nb+ns+nb+ns+wb+ws+nb)       && "R"
	AADD(char,nb+ns+wb+ns+nb+ns+wb+ws+nb)       && "S"
	AADD(char,nb+ns+nb+ns+wb+ns+wb+ws+nb)       && "T"
	AADD(char,wb+ws+nb+ns+nb+ns+nb+ns+wb)       && "U"
	AADD(char,nb+ws+wb+ns+nb+ns+nb+ns+wb)       && "V"
	AADD(char,wb+ws+wb+ns+nb+ns+nb+ns+nb)       && "W"
	AADD(char,nb+ws+nb+ns+wb+ns+nb+ns+wb)       && "X"
	AADD(char,wb+ws+nb+ns+wb+ns+nb+ns+nb)       && "Y"
	AADD(char,nb+ws+wb+ns+wb+ns+nb+ns+nb)       && "Z"
	AADD(char,nb+ws+nb+ns+nb+ns+wb+ns+wb)       && "-"
	AADD(char,wb+ws+nb+ns+nb+ns+wb+ns+nb)       && "."
	AADD(char,nb+ws+wb+ns+nb+ns+wb+ns+nb)       && " "
	AADD(char,nb+ws+nb+ns+wb+ns+wb+ns+nb)       && "*"
	AADD(char,nb+ws+nb+ws+nb+ws+nb+ns+nb)       && "$"
	AADD(char,nb+ws+nb+ws+nb+ns+nb+ws+nb)       && "/"
	AADD(char,nb+ws+nb+ns+nb+ws+nb+ws+nb)       && "+"
	AADD(char,nb+ns+nb+ws+nb+ws+nb+ws+nb)       && "%"
EndIf

_cFixo1   := "4329876543298765432987654329876543298765432"
_cFixo2   := "21212121212121212121212121212"
_cFixo3   := "3298765432"
_cFixo4   := "19731973197319731973"
_cFixo5   := "2765432765432"

nDif := (Val(notaini) - Val(notafim)) +1
SetRegua(nDif)

SetPrc(000,000)
Set Century On

lFirst := .T.

While !Eof() .and. e1_num >= notaini .and. e1_num <= notafim
	
	IncRegua()
	
	_dDataLimite := e1_vencto + 4

   If SM0->M0_CODFIL = "03" .OR. SM0->M0_CODFIL = "05" .OR. SM0->M0_CODFIL = "06"
   	   cMens01 := "ESTE T¡TULO PODER SER RECEBIDO PELOS BANCOS PARTICIPANTES"
	   cMens02 := "DO SISTEMA DE COMPENSA€O."
   EndIf
	
	If se1->e1_tipo <> "NF " .or. se1->e1_emissao == se1->e1_vencto
		dbSelectArea("SE1")
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5") + "ZX")
	
	If se1->e1_vend1 $ sx5->x5_descri .and. !Empty(se1->e1_vend1)
		dbSelectArea("SE1")
		dbSkip()
		Loop
	EndIf
	
	dbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5") + "ZD" + xFilial("SX5"))
	cBanco    := Substr(sx5->x5_descri,16,3)
	cAgencia  := Substr(sx5->x5_descri,19,5)
	cConta    := Substr(sx5->x5_descri,24,10)
	cSubConta := Substr(sx5->x5_descri,34,3)
	
	If Empty(se1->e1_numbco) //se nosso numero estiver em branco
		dbSelectArea("SEE")
		dbSetOrder(1)
		If !dbSeek(xFilial("SEE") + cBanco + cAgencia + cConta + cSubConta)
			Alert("Banco não cadastrado nos Parâmetros CNAB")
			Return
		EndIf
		RecLock("SEE",.F.)
		cNumbco := StrZero(Val(ee_faxatu)+1,11)
		dbSelectArea("SE1")
		nRecSE1 := Recno()
		dbSetOrder(14)
		If dbSeek(xFilial("SE1") + cNumBco)
			While .T.
				cNumBco := StrZero(Val(cNumBco)+1,11)
				If !dbSeek(xFilial("SE1") + cNumBco)
					Exit
				EndIf
				dbSkip()
			EndDo
		EndIf
		dbSelectArea("SEE")
		Replace ee_faxatu with  cNumBco
		msUnLock()
		
		dbSelectArea("SE1")
		Go nRecSE1
	Else
        cNumbco := Alltrim(se1->e1_numbco)
	EndIf
	
	** Montagem do Codigo de Barras
	_ValBol := SE1->E1_SALDO
	_Mes1 := Month(SE1->E1_VENCTO)
	_Ano1 := Year(SE1->E1_VENCTO)
	_Quant := Val(SE1->E1_PARCELA) - 1
	
	_Desc1 := 0
	_Desc2 := 0
	
	dbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5") + "ZD" + xFilial("SX5"))
	cContrato := Substr(sx5->x5_descri, 4,10)
	
	//nao incluí o digito na quinta posicao pois sera calculado depois
	
   _BarCod := "237"                                              // Banco
   _BarCod += "9"                                                // Moeda (no banco)
   _BarCod += StrZero(((se1->e1_vencto)-ctod("07/10/1997")),4)   // Fator de Vencimento
   _BarCod += StrZero((se1->e1_saldo*100),10)                    //valor do titulo
   _Barcod += Left(cAgencia,4)                                   //agencia 
   _Barcod += "09"                                               //carteira    
    	
   lEntra := .T.
	
	//Calcula o DAC do Nosso N£mero
	If Empty(se1->e1_numbco)   //se nosso numero em branco calcula
		nSomaNN := 0		
		aMult :={}
		AADD(aMult, {2,7,6,5,4,3,2,7,6,5,4,3,2})
		cNumero := "09" + StrZero(Val(Substr(cNumbco,1,11)),11)
		For _i := 1 to 13
		   nSomaNN += (aMult[1][_i]*Val(Substr(cNumero,_i,1)))		
		Next _i   
		
		nMod := Mod(nSomaNN,11)
		
		If (11-nMod) == 10
			cCalcDvNN := "P"
        ElseIf (11-nMod) == 11
            cCalcDvNN := "0"		
		Else
			cCalcDvNN := StrZero((11-nMod),1)    // Str(11-(nSomaNN%11),1)
		Endif
		
		//grava digito do NN no titulo
		
		dbSelectArea("SE1")
		RecLock("SE1",.F.)
		Replace e1_numbco with cNumBco + cCalcDvNN
		msUnLock()
	Else                                       // se ja existe nosso numero, pega o que já existe
		cNumBco   := Left(se1->e1_numbco,11)
		cCalcDvNN := Substr(se1->e1_numbco,12,1)
	EndIf	
	
   _Barcod += Left(cNumBco,11)                                   //ano do nosso numero ***

   cConta1 := StrZero(Val(Left(cConta,(Len(AllTrim(StrTran(cConta,"-","")))-1))),7)

   _Barcod += cConta1                                            //Conta do cedente
   _Barcod += "0"                                                //zero	
	
	//Calculo do DV do nosso numero
	
	nSomaGer := 0
	For nI := 1 to 43
	   nSomaGer := nSomaGer + ;
	   (Val(Substr(_BarCod,nI,1))*Val(Substr(_cFixo1,nI,1)))
	Next
	If (11-(nSomaGer%11)) > 9
		cCalcDv := "1"
	ElseIf (11-(nSomaGer%11)) = 0
		cCalcDv := "1"
	Else
		cCalcDv := Str(11-(nSomaGer%11),1)
	Endif
	_BarCod := Left(_BarCod ,4) + cCalcDv + Right(_BarCod,39)	
	
	//Monta sequencia de codigos para o topo do boleto
	
	_cBloco := Left(_BarCod,4) + Substr(_BarCod,20,5) +;
	Substr(_BarCod,25,10) + Substr(_BarCod,35,10)
	
	nSoma1 := 0
	nSoma2 := 0
	nSoma3 := 0
	
	//Calcula o DV do primeiro Bloco
	_FixVar := Right(_cFixo2,9)
	For nI := 1 to 9
		_nRes := Val(Substr(_cBloco,nI,1))*Val(Substr(_cFixo2,nI,1))
		If _nRes > 9
			_nRes := 1 + (_nRes-10)
		Endif
		nSoma1 := nSoma1 + _nRes
	Next
	
	//Calcula o DV do segundo bloco
	_FixVar := Right(_cFixo2,10)
	For nI := 10 to 19
		_nRes := Val(Substr(_cBloco,nI,1))*Val(Substr(_cFixo2,nI,1))
		If _nRes > 9
			_nRes := 1 + (_nRes-10)
		Endif
		nSoma2 := nSoma2 + _nRes
	Next
	
	//Calcula o DV do terceiro Bloco
	_FixVar := Right(_cFixo2,10)
	For nI := 20 to 29
		_nRes := Val(Substr(_cBloco,nI,1))*Val(Substr(_cFixo2,nI,1))
		If _nRes > 9
			_nRes := 1 + (_nRes-10)
		Endif
		nSoma3 := nSoma3 + _nRes
	Next
	cSoma1 := Right(StrZero(10-(nSoma1%10),2),1)
	cSoma2 := Right(StrZero(10-(nSoma2%10),2),1)
	cSoma3 := Right(StrZero(10-(nSoma3%10),2),1)
	
	//Uso as funcoes StrZero e Right para pegar o nro correto quando o resto
	//de nSoma/10 for 0
	
	//Monta sequencia de codigos para o topo do boleto com os dvs e o valor
	
	_cBloco := Left(_BarCod,4) + Substr(_BarCod,20,5) + cSoma1 +;
	Substr(_BarCod,25,10) + cSoma2+ Substr(_BarCod,35,10)+ cSoma3 +;
	cCalcDv + Substr(_BarCod,6,4) + AllTrim(StrZero((_ValBol*100),10)) //Alterado por Risaldo

	// Monta String do codigo de barras propriamente dito
	_code := ""
	
	If _TpBar == "25"
		// Intercala a referencia binaria dos numeros aos pares, pois nesse tipo
		// os numeros das posicoes impares serao escritos em barras largas e barras
		// estreitas e os numeros das posicoes pares serao escritos com espacos largos
		// e espacos estreitos.
		_cBar := _BarCod
		For _nX := 1 to 43 Step 2    //44 porque o meu cod.possue 44 numeros
			_nNro := VAl(Substr(_cBar,_nx,1))
			If _nNro == 0
				_nNro := 10
			EndIf
			_cBarx := char25[_nNro]
			_nNro := VAl(Substr(_cBar,_nx+1,1))
			If _nNro == 0
				_nNro := 10
			EndIf
			_cBarx := _cBarx + char25[_nNro]
			
			For _nY := 1 to 5
				If Substr(_cBarx,_nY,1) == "0"
					// Uso Barra estreita
					_code := _code + nb
				Else
					// Uso Barra larga
					_code := _code + wb
				EndIf
				If Substr(_cBarx,_nY+5,1) == "0"
					// Uso Espaco estreito
					_code := _code + ns
				Else
					// Uso Espaco Largo
					_code := _code + ws
				EndIf
			Next
		Next
		_code := nb+ns+nb+ns+_code+wb+ns+nb
		// Guarda de inicio == Barra Estr+Esp.Estr+Barra Estr+Esp.Estr
		// Guarda de Fim    == Barra Larga +Esp.Estr+Barra Estr
		// Estes devem ser colocados antes e depois do codigo montado
	ElseIf _TpBar == "39"
		_code := ""
		_BarCod := "*"+_BarCod+"*"
		FOR I := 1 TO LEN(m->_BarCod)
			letter := SUBSTR(m->_BarCod,I,1)
			_code := _code + IF(AT(letter,chars)=0,letter,char[at(letter,chars)]) + ns
		NEXT
	EndIf
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.)
	
	dbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5") + "ZD" + xFilial("SX5"))
	cNomeEmp := AllTrim(sm0->m0_nomecom) + "-" + Left(sx5->X5_descri,3)
	If Len(cNomeEmp) < 40
		cNomeEmp += Space(40-Len(cNomeEmp))
	EndIf
	cContrato := Substr(sx5->x5_descri, 4,10)
	cCarteira := Substr(sx5->x5_descri, 14,2)
	
	SetPrc(0,0)
	nlin := 1
	nHeight    := 15
	lBold      := .F.
	lItalic    := .F.
	lUnderLine := .F.
	lPixel     := .T.
	lPrint     := .F.
	//	If lFirst
	@nLin,000 PSAY aValImp(Limite)
	lFirst := .F.
	//	EndIf
	
	If xFilial("SE1") == "03"
		cFilName := "Total Base Jequie - BA"
		cFilEnd  := "Av. Governador Aurelio Viana, 224 - Cidade Nova - Jequie - BA"
		cFilcont := "Fone/Fax: 0xx73 252.9988 - e-mail: totalj@sst.com.br"
	ElseIf xFilial("SE1") == "05"
		cFilName := "Total Base Sao Francisco do Conde - BA"
		cFilEnd  := "Via Madre de Deus, s/n - KM 42,5 - Caipe - S. Francisco do Conde - BA"
		cFilCont := "Fone/Fax: 0xx71 604.3031 - e-mail: totalba@terra.com.br"
	ElseIf xFilial("SE1") == "06"
		cFilName := "Total Base Goiania - GO"
		cFilEnd  := "Av.Niteroi c/ Copacabana, Q-R1 a 19, Setor Comercial - Senador Canedo"
		cFilCont := "Goiania - GO Fone/Fax: 0xx62 512.6191 - e-mail: totalgyn@ih.com.br"
	EndIf
	
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,005 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin+=1
	@ nlin,042 PSAY "(s0p20h20v0s3b3T"+Chr(38)+"l12D" + "Total Escritorio Recife - PE
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,062 PSAY "Rua Antonio Pedro Figueiredo, 56 - 51011-510 - Boa Viagem Recife - PE"
	@ nlin,100 PSAY "(12U(s1p10v0s3b3168T"
	@ nlin,143 PSAY "Vencimento " + DtoC(se1->e1_vencto)
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,062 PSAY "Fone/Fax: 0xx81 3465.8012 - e-mail: vendas@totalplus.com.br"
	nlin+=2
	@ nlin,005 PSAY "(12U(s1p35v0s3b3168T" + "TOTAL"
	@ nlin,029 PSAY "(s0p20h20v0s3b3T"+Chr(38)+"l12D"
	@ nlin,043 PSay cFilName
	nlin+=1
	@ nlin,042 PSAY "(s0p20h20v0s0b3T"+Chr(38)+"l12D" + cFilEnd
	@ nlin,005 PSAY "(12U(s1p10v0s3b3168T"
	nlin+=1
	@ nlin,009 PSAY "Distribuidora de Petroleo"
	@ nlin,029 PSAY "(s0p20h20v0s0b3T"+Chr(38)+"l12D"
	@ nlin,043 PSay cFilCont
	@ nlin,005 PSAY "(12U(s1p10v0s3b3168T"
	@ nlin,167 PSAY "Nota Fiscal No. " + se1->e1_num
	nlin+=2
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,005 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	
	/*/@ nlin,000 PSAY "(s0p20h20v0s3b3T"+Chr(38)+"l12D"
	@ nlin,076 PSAY AllTrim(sm0->m0_nomecom)
	@ nlin,005 PSAY "(12U(s1p10v0s3b4168T" +  "                                                                                                                            NOTA FISCAL  " + se1->e1_num
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,075 PSAY sm0->m0_endent +"-"+sm0->m0_bairent
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,075 PSAY "CEP " + sm0->m0_cepent + "  " + AllTrim(sm0->m0_cident) +"-"+sm0->m0_estent
	@ nlin,005 PSAY "(s0p20h20v0s3b3T"+Chr(38)+"l12D" +  "                                                                                                                    VENCIMENTO "
	@ nlin,005 PSAY "(12U(s1p10v1s3b4168T" +  "                                                                                                                                                                   " + DtoC(se1->e1_vencto)
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,075 PSAY "TELEFONE: " + sm0->m0_tel
	/*/
	
	nlin := 43
	@ nlin,005 PSAY "(12U(s1p20v1s3b4168T" + " BRADESCO "
	@ nlin,005 PSAY "(12U(s1p18v1s3b4168T" +  "                         |237-2|"
	@ nlin,005 PSAY "(12U(s1p10v1s3b4168T" +  "                                                                                                                                       RECIBO DO SACADO"
	@ nlin,120 PSAY ""
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	nlin++
	@ nlin,005 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,005 PSAY "LOCAL DE PAGAMENTO                                                                                             ³ VENCIMENTO                    "
	nlin++
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,005 PSAY "     PAGµVEL EM QUALQUER BANCO ATE O VENCIMENTO"
	@ nlin,050 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,050 PSAY "                                                                   ³"
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,215 PSAY SE1->E1_VENCTO
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,006 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,005 PSAY "CEDENTE                                                                                                        ³ AGENCIA/CODIGO CEDENTE        "
	nlin++
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,010 PSAY cNomeEmp
	@ nlin,050 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,050 PSAY "                                                                   ³"
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,215 PSAY Substr(cAgencia,1,4) + "-" + Substr(cAgencia,5,1) + '  /  ' + Substr(cConta,1,5) + "." + Substr(cConta,7,1)  //Engessamento 06-000
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,006 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,005 PSAY "DATA DO DOCUMENTO  ³NO DO DOCUMENTO            ³ESPECIE DOC³ACEITE      ³DATA DE PROCESSAMENTO                 ³ NOSSO NUMERO                  "
	nlin++
	@ nlin,005 PSAY "                   ³                           ³           ³            ³                                      ³                               "
	@ nlin,005 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,010 PSAY SE1->E1_EMISSAO
	@ nlin,041 PSAY SE1->E1_NUM+If(!Empty(SE1->E1_PARCELA),"-"+SE1->E1_PARCELA,"")
	@ nlin,084 PSAY "DM"
	@ nlin,098 PSAY "N"
	@ nlin,118 PSAY dtoc(dDataBase)
	@ nlin,178 PSAY "09 " + Left(SE1->E1_NUMBCO,11)+"-"+cCalcDvNN
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,006 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,005 PSAY "USO DO BANCO       ³CARTEIRA ³ESPECIE          ³QUANTIDADE              ³VALOR                                 ³ (" + CHR(61) + ") VALOR DO DOCUMENTO      "
	nlin++
	@ nlin,005 PSAY "                   ³         ³   "
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,010 PSAY ""//cContrato
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,066 PSAY "09"
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,082 PSAY "R$"
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,072 PSAY "³                        ³                                      ³"
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,235 PSAY _ValBol PICTURE "@E 9,999,999.99"
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,006 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,005 PSAY "INSTRUCOES                                                                                                     ³ (" + CHR(61) + ") DESCONTO                  "
	nlin++
	@ nlin,116 PSAY "³                               "
	nlin++
	_Jrs := Round((_ValBol*SE1->E1_PORCJUR) / 100,2)
	@ nlin,116 PSAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,011 PSAY "AP¢S VENCIDO COBRAR R$ "+Transform(_Jrs,"@E 999.99") + " POR DIA DE ATRASO."
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,136 PSAY "³ (" + CHR(61) + ") OUTRAS DEDUCOES/ABATIMENTO"
	nlin++
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,011 PSAY cMens01
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,136 PSAY "³                               "
	nlin++
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,011 PSAY cMens02
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,136 PSAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
//	@ nlin,011 PSAY cMens03
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,136 PSAY "³ (+) MORA/MULTA/JUROS          "
	nlin++
	@ nlin,116 PSAY "³                               "
	nlin++
	@ nlin,116 PSAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,116 PSAY "³ (+) OUTROS ACRESCIMOS         "
	nlin++
	@ nlin,116 PSAY "³                               "
	nlin++
	@ nlin,116 PSAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,116 PSAY "³ (" + CHR(61) + ") VALOR COBRADO             "
	nlin++
	@ nlin,116 PSAY "³                               "
	nlin++
	@ nlin,005 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,005 PSAY "SACADO:   " + "(12U(s1p6v0s4b4113T" + SA1->A1_COD + Space(01) + SA1->A1_LOJA + " - " + SA1->A1_NOME
	@ nlin,152 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D" + "CPF/CNPJ: " + "(12U(s1p6v0s4b4113T" + Transform(Trim(SA1->A1_CGC),If(" "$SA1->A1_CGC,"@R 999.999.999-99","@R 99.999.999/9999-99"))
	nlin += 2
	@ nlin,025 PSAY Trim(SA1->A1_END) + " - "+AllTrim(SA1->A1_BAIRRO)+" - "+AllTrim(SA1->A1_MUN)+" - "+AllTrim(SA1->A1_EST)+" - "+ Transform(SA1->A1_CEP,"@R 99999-999")
	nlin++
	@ nlin,082 PSAY ""
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,006 PSAY "SACADOR/AVALISTA"
	nlin++
	@ nlin,005 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,0   PSAY "(12U(s1p5v1s3b4113T"
	@ nlin,270 PSAY "Autentica‡Æo Mecanica"
	nlin += 6
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,003 PSAY " .....................................................................................................................Recortar Aqui..............."
	nlin += 4
	@ nlin,005 PSAY "(12U(s1p20v1s3b4168T" +  "  BRADESCO "
	@ nlin,005 PSAY "(12U(s1p18v1s3b4168T" +  "                         |237-2|"
	@ nlin,000 PSAY "(12U(s1p10v1s3b4113T"
	@ nlin,109 PSAY _cBloco Picture "@R 99999.99999 99999.999999 99999.999999 9 99999999999999"
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	nlin++
	@ nlin,005 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,005 PSAY "LOCAL DE PAGAMENTO                                                                                             ³ VENCIMENTO                    "
	nlin++
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,005 PSAY "     PAGµVEL EM QUALQUER BANCO ATE O VENCIMENTO"
	@ nlin,050 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,050 PSAY "                                                                   ³"
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,215 PSAY SE1->E1_VENCTO
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,006 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,005 PSAY "CEDENTE                                                                                                        ³ AGENCIA/CODIGO CEDENTE        "
	nlin++
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,010 PSAY cNomeEmp
	@ nlin,050 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,050 PSAY "                                                                   ³"
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,215 PSAY Substr(cAgencia,1,4) + "-" + Substr(cAgencia,5,1) + '  /  ' + Substr(cConta,1,5) + "." + Substr(cConta,7,1)  //Engessamento 06-000
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,006 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,005 PSAY "DATA DO DOCUMENTO  ³NO DO DOCUMENTO            ³ESPECIE DOC³ACEITE      ³DATA DE PROCESSAMENTO                 ³ NOSSO NUMERO                  "
	nlin++
	@ nlin,005 PSAY "                   ³                           ³           ³            ³                                      ³                               "
	@ nlin,005 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,010 PSAY SE1->E1_EMISSAO
	@ nlin,041 PSAY SE1->E1_NUM+If(!Empty(SE1->E1_PARCELA),"-"+SE1->E1_PARCELA,"")
	@ nlin,084 PSAY "DM"
	@ nlin,098 PSAY "N"
	@ nlin,118 PSAY dtoc(dDataBase)
	@ nlin,178 PSAY "09 " + Left(SE1->E1_NUMBCO,11)+"-"+cCalcDvNN
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,006 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	
	@ nlin,005 PSAY "USO DO BANCO       ³CARTEIRA ³ESPECIE          ³QUANTIDADE              ³VALOR                                 ³ (" + CHR(61) + ") VALOR DO DOCUMENTO      "
	nlin++
	@ nlin,005 PSAY "                   ³         ³   "
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,010 PSAY ""//cContrato
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,066 PSAY "09"
	
	
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,082 PSAY "R$"
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,072 PSAY "³                        ³                                      ³"
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,235 PSAY _ValBol PICTURE "@E 9,999,999.99"
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,006 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,005 PSAY "INSTRUCOES                                                                                                     ³ (" + CHR(61) + ") DESCONTO                  "
	nlin++
	@ nlin,116 PSAY "³                               "
	nlin++
	_Jrs := Round((_ValBol*SE1->E1_PORCJUR) / 100,2)
	@ nlin,116 PSAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,011 PSAY "AP¢S VENCIDO COBRAR R$ "+Transform(_Jrs,"@E 999.99") + " POR DIA DE ATRASO."
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,136 PSAY "³ (" + CHR(61) + ") OUTRAS DEDUCOES/ABATIMENTO"
	nlin++
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,011 PSAY cMens01
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,136 PSAY "³                               "
	nlin++
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
	@ nlin,011 PSAY cMens02
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,136 PSAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,000 PSAY "(12U(s1p6v0s4b4113T"
//	@ nlin,011 PSAY cMens03
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,136 PSAY "³ (+) MORA/MULTA/JUROS          "
	nlin++
	@ nlin,116 PSAY "³                               "
	nlin++
	@ nlin,116 PSAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,116 PSAY "³ (+) OUTROS ACRESCIMOS         "
	nlin++
	@ nlin,116 PSAY "³                               "
	nlin++
	@ nlin,116 PSAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,116 PSAY "³ (" + CHR(61) + ") VALOR COBRADO             "
	nlin++
	@ nlin,116 PSAY "³                               "
	nlin++
	@ nlin,005 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	@ nlin,005 PSAY "SACADO:   " + "(12U(s1p6v0s4b4113T" + SA1->A1_COD + Space(01) + SA1->A1_LOJA + " - " + SA1->A1_NOME
	@ nlin,152 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D" + "CPF/CNPJ: " + "(12U(s1p6v0s4b4113T" + Transform(Trim(SA1->A1_CGC),If(" "$SA1->A1_CGC,"@R 999.999.999-99","@R 99.999.999/9999-99"))
	nlin += 2
	@ nlin,025 PSAY Trim(SA1->A1_END) + " - "+AllTrim(SA1->A1_BAIRRO)+" - "+AllTrim(SA1->A1_MUN)+" - "+AllTrim(SA1->A1_EST)+" - "+ Transform(SA1->A1_CEP,"@R 99999-999")
	nlin++
	@ nlin,082 PSAY ""
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,006 PSAY "SACADOR/AVALISTA"
	nlin++
	@ nlin,005 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	nlin += 1
	@ nlin,169 PSAY "(12U(s1p9v1s3b4168T"
	@ nlin,160 PSAY "FICHA DE COMPENSACAO"
	@ nlin,000 PSAY "(s0p20h8v4s0b3T"+Chr(38)+"l12D"
	@ nlin,010 PSAY _code
	@ nlin+1,295 PSAY "(12U(s1p5v1s3b4168T"
	@ nlin+1,300 PSAY "       AUTENTICACAO NO VERSO"
	Eject
	@ prow(),00 PSay " "
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSkip()
	
EndDo

Set Device To Screen
Set Printer TO

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
End

MS_FLUSH()

Return
.999-99","@R 99.999.999/9999-99"))
	nlin += 2
	@ nlin,025 PSAY Trim(SA1->A1_END) + " - "+AllTrim(SA1->A1_BAIRRO)+" - "+AllTrim(SA1->A1_MUN)+" - "+AllTrim(SA1->A1_EST)+" - "+ Transform(SA1->A1_CEP,"@R 99999-999")
	nlin++
	@ nlin,082 PSAY ""
	nlin++
	@ nlin,000 PSAY "(s0p20h6v0s0b3T"+Chr(38)+"l12D"
	@ nlin,006 PSAY "SACADOR/AVALISTA"
	nlin++
	@ nlin,005 PSAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
	nlin++
	nlin += 1
	@ nlin,169 PSAY "(12U(s1p9v1s3b4168T"
	@ nlin,160 PSAY "FICHA DE COMPENSACAO"
	@ nlin,000 PSAY "(s0p20h8v4s0b3T"+Chr(38)+"l12D"
	@ nlin,010 PSAY _code
	@ nlin+1,295 PSAY "(12U(s1p5v1s3b4168T"
	@ nlin+1,300 PSAY "       AUTENTICACAO NO VERSO"
	Eject
	@ prow(),00 PSay " "
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbSkip()
	
EndDo

Set Device To Scre