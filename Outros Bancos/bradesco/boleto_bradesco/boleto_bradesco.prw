#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBOLBAR    บAutor  ณ     Rdmake         บ Data ณ  22/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBoleto Grafico  - Bradesco                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BOLBAR()

Local oDlg
Local aCA:={OemToAnsi("Confirma"),OemToAnsi("Abandona")} // "Confirma", "Abandona"
Local cCadastro := OemToAnsi("Impressao de Boleto Bradesco")
Local aSays:={}, aButtons:={}
Local nOpca := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis tipo Private padrao de todos os relatorios         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aReturn    := {OemToAnsi('Zebrado'), 1,OemToAnsi('Administracao'), 2, 2, 1, '',1 } // ###
Private nLastKey   := 0
Private cPerg      := "BRADBO"

ValidPerg()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01            // Prefixo                               ณ
//ณ mv_par02            // Do numero                             ณ
//ณ mv_par03            // Ateh o numero                         ณ
//ณ mv_par04            // Taxa de Juros                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Pergunte(cPerg,.F.)

AADD(aSays,OemToAnsi( "  Este programa ira imprimir o Boleto Bancario do Bradesco "))
AADD(aSays,OemToAnsi( "obedecendo os parametros escolhidos pelo cliente.          "))

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| nOpca := 0,FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )
	If nOpca == 1
		Processa( { |lEnd| ImpBol() })
	EndIf
	
	Return .T.
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณIMPBOL    บAutor  ณRdmake         บ Data ณ  22/10/01   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณImpressao do Boleto Bancario Bradesco                       บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP5                                                        บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	
	Static Function ImpBol()
	
	Local nHeight:=15
	Local lBold:= .F.
	Local lUnderLine:= .F.
	Local lPixel:= .T.
	Local lPrint:=.F.
	Local oFont1:= TFont():New( "Courier New",,08,,.F.,,,,,.f. )
	Local oFont2:= TFont():New( "Courier New",,12,,.t.,,,,,.f. )
	Local oFont3:= TFont():New( "Times New Roman",,18,,.t.,,,,.T.,.f. )
	Local oFont4:= TFont():New( "Courier New",,20,,.t.,,,,,.f. )
	Local oPrn:=TAvPrinter():New()
	Local nPag:=1
	Local nTPag:= SE1->(FCount())
	Local nLin:= 0
	Local cPeriodo
	Local nI , nHoras , dData
	Private lContinua:= .T.
	oPrn:EndPage() //finaliza pagina
	oPrn:StartPage() //inicializa pagina por problemas duplica็ใo registro - Renato/Michel
	dbSelectArea( "SE1" )
	cBanco   := "237"
	cMoeda   := "9"
	cAgencia := "1193"
	cCart    := "09"
	cAno     := "00"
	cConta   := Iif (mv_par01 == "ESP","0483338","0373222")
	Modulo   := 11
	
	DbSelectArea("SE1")
	DbSetOrder(1)
	DbSeek(xFilial()+mv_par01+mv_par02)
	
	nCont := 0
	
	Do While !Eof() .and. xFilial("SE1") == SE1->E1_FILIAL .and. lContinua ;
		.and. SE1->E1_PREFIXO == mv_par01 .and. E1_NUM <= mv_par03
		
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial()+SE1->E1_CLIENTE)
		
		nCont := nCont + 1
		
		cEnd1 := SA1->A1_END
		cEnd2 := SA1->A1_MUN+" - "+SA1->A1_EST
		cCep  := SA1->A1_CEP
		
		
		If lEnd
			@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			EXIT
		Endif
		
		// Calculo do numero bancario + digito e valor do juros
		
		nParcela := StrZero(At(SE1->E1_PARCELA,"ABCDEFGHIJKLMN"),3)
		cNumBco  := "00"+ SE1->E1_NUM + nParcela
		strmult  := "2765432765432"
		nban     := Left(cNumBco, 11)
		BaseDac  := cCart + nban
		VarDac   := 0
		
		For idac := 1 To 13
			VarDac := VarDac + Val(Subs(BaseDac, idac, 1)) * Val (Subs (strmult, idac, 1))
		Next idac
		
		VarDac  := Modulo - VarDac % Modulo
		VarDac  := Iif (VarDac == 10, "P", Iif (VarDac == 11, "0", Str (VarDac, 1)))
		
		nJuros  := Round(SE1->E1_SALDO * (mv_par04 / 3000),2)
		
		RecLock("SE1",.F.)
		Replace E1_NUMBCO  with cNumBco + VarDac
		Replace E1_VALJUR  with nJuros
		Replace E1_PORCJUR with Round((mv_par04/30),2)
		MsUnLock()
		
		// Calculo do codigo de barras + digito
		
		strmult := "4329876543298765432987654329876543298765432"
		
		cValor  := StrZero (100 * (SE1->E1_VALOR), 14)
		cNumero := Subs(SE1->E1_NUMBCO,3,9)
		
		
		livre   := cAgencia + cCart + cAno + cNumero + cConta + "0"
		sBarra  := cBanco + cMoeda + cValor + livre
		BaseDiv := 0
		
		For xx := 1 To 43
			BaseDiv := BaseDiv + Val (Subs (sBarra, xx, 1)) * Val (Subs (strmult, xx, 1))
		Next xx
		
		resto  := BaseDiv % modulo
		resto  := modulo - resto
		resto  := Str (Iif (resto > 9 .or. resto == 0 .or. resto == 1, 1,resto),1)
		sBarra := cBanco + cMoeda + resto + cValor + livre
		
		Barra  := "<" + sBarra + ">"
		
		// Calculo da linha digit vel
		
		sDigit := cBanco + cMoeda + cAgencia + cCart + cAno + cNumero + cConta
		sDigi1 := cBanco + cMoeda + Subs(livre, 1, 5)
		sDigi2 := Subs (livre,  6, 10)
		sDigi3 := Subs (livre, 16, 10)
		
		V_Base := sDigi1
		cDigi()
		sDigi1 := V_Base
		V_Base := sDigi2
		cDigi()
		sDigi2 := V_Base
		V_Base := sDigi3
		cDigi()
		sDigi3 := V_Base
		
		sDigi1 := Subs (sDigi1, 1, 5) + "." + Subs (sdigi1, 6, 5) + " "
		sDigi2 := Subs (sDigi2, 1, 5) + "." + Subs (sdigi2, 6, 6) + " "
		sDigi3 := Subs (sDigi3, 1, 5) + "." + Subs (sdigi3, 6, 6) + " "
		sDigit := sDigi1 + sDigi2 + sDigi3 + " " + resto + Str (100 * (SE1->E1_VALOR),14,0)
		
		DbSelectArea("SE1")
		
		if nPag<>1	&& Fim de Pagina
			oPrn:EndPage()
			oPrn:StartPage()
		endif
		
		oPrn:Say(100,0000,"BRADESCO ",oFont3,100)
		oPrn:Say(103,0470,"237-2",oFont2,100)
		oPrn:Say(100,0620,"Recibo do ",oFont2,100)
		oPrn:Say(135,0620,"Sacado",oFont2,100)
		oPrn:Box(100,0428,220,0431) // divisao entre Bradesco e no. banco
		oPrn:Box(100,0610,220,0613) // divisao entre no. banco e sacado
		oPrn:Box(100,0899,220,0901)	 // fim do sacado
		oPrn:Say(100,0940,"BRADESCO ",oFont3,100)
		oPrn:Box(100,1330,220,1333)	 // divisao entre banco e no. II parte
		oPrn:Say(103,1400,"237-2",oFont2,100)
		
		
		oPrn:Box(180,0000,260,0518) // Parc.Plano Sacado
		oPrn:Box(180,0518,260,0900) // Vencimento Sacado
		oPrn:Box(180,0930,260,2400) // Local Pagamento
		oPrn:Box(180,2400,260,2900) // Vencimento
		oPrn:Say(180,0020,"Parc.Plano",oFont1,100)
		oPrn:Say(180,0528,"Vencimento",oFont1,100)
		oPrn:Say(180,0940,"Local de Pagamento: BANCO BRADESCO S/A",oFont1,100)
		oPrn:Say(180,2410,"Vencimento",oFont1,100)
		
		oPrn:Say(210,0550,Dtoc(SE1->E1_VENCTO),oFont1,100)
		oPrn:Say(210,0940,"                    PAGAR PREFERENCIALMENTE EM QUALQUER AGสNCIA BRADESCO",oFont1,100)
		oPrn:Say(210,2510,Dtoc(SE1->E1_VENCTO),oFont1,100)
		
		oPrn:Box(260,0000,340,0900) // Agencia / Codigo Cedente
		oPrn:Box(260,0930,340,2400) // Cedente
		oPrn:Box(260,2400,340,2900) // Agencia / Codigo Cedente
		
		oPrn:Say(260,0020,"Ag๊ncia/C๓digo Cedente",oFont1,100)
		oPrn:Say(260,0940,"Cedente",oFont1,100)
		oPrn:Say(260,2410,"Ag๊ncia/C๓digo Cedente",oFont1,100)
		
		oPrn:Say(300,0110,"02962-9/0000580-0",oFont1,100)
		oPrn:Say(300,0990,SM0->M0_NOMECOM,oFont1,100)
		oPrn:Say(300,2420,"02962-9/0000580-0",oFont1,100)
		
		oPrn:Box(340,0000,420,0900) // E.Moeda
		oPrn:Box(340,0518,420,0900) // Quantidade
		oPrn:Box(340,0930,420,1330) // Data do Documento
		oPrn:Box(340,1330,420,1600) // Numero do Documento
		oPrn:Box(340,1600,420,1850) // Especie Doc.
		oPrn:Box(340,1850,420,2000) // Aceite
		oPrn:Box(340,2000,420,2400) // Dia Processamento
		oPrn:Box(340,2400,420,2900) // Cart./Nosso numero
		
		oPrn:Say(340,0020,"E.Moeda",oFont1,100) // E.Moeda
		oPrn:Say(340,0528,"Quantidade",oFont1,100) // Quantidade
		oPrn:Say(340,0935,"Data do Documento",oFont1,100) // Data do Documento
		oPrn:Say(340,1335,"No.Documento",oFont1,100) // Numero do Documento
		oPrn:Say(340,1605,"Esp้cie Doc.",oFont1,100) // Especie Doc.
		oPrn:Say(340,1855,"Aceite",oFont1,100) // Aceite
		oPrn:Say(340,2005,"Data Processamento",oFont1,100) // Dia Processamento
		oPrn:Say(340,2405,"Cart./Nosso N๚mero",oFont1,100) // Cart./Nosso numero
		
		oPrn:Say(380,0030,"R$",oFont1,100) // E.Moeda
		oPrn:Say(380,0940,Dtoc(SE1->E1_EMISSAO),oFont1,100) // Data do Documento
		oPrn:Say(380,1340,DTOC(SE1->E1_EMISSAO),oFont1,100) // Numero do Documento
		oPrn:Say(380,1610,"DM",oFont1,100) // Especie Doc.
		oPrn:Say(380,1860,"Nใo",oFont1,100) // Aceite
		oPrn:Say(380,2010,Dtoc(dDataBase),oFont1,100) // Dia Processamento
		oPrn:Say(380,2410,"",oFont1,100) // Cart./Nosso numero
		
		oPrn:Box(420,0000,500,0900) // Valor Documento
		oPrn:Box(420,0930,500,1180) // Uso do Banco
		oPrn:Box(420,1180,500,1280) // Cip
		oPrn:Box(420,1280,500,1480) // Carteira
		oPrn:Box(420,1480,500,1780) // Especie Moeda
		oPrn:Box(420,2020,440,2022) // Quantidade
		oPrn:Box(470,2020,500,2022) // Valor
		oPrn:Box(499,1780,501,2400) // Linha para fechar
		oPrn:Say(440,2014,"X",oFont1,100) // Sinal de X
		oPrn:Box(420,2400,500,2900) // Valor do Documento
		
		oPrn:Say(420,0020,"Valor Documento",oFont1,100) // Valor Documento
		oPrn:Say(420,0935,"Uso Banco",oFont1,100) // Uso do Banco
		oPrn:Say(420,1185,"Cip",oFont1,100) // Cip
		oPrn:Say(420,1285,"Carteira",oFont1,100) // Carteira
		oPrn:Say(420,1485,"Esp้cie Moeda",oFont1,100) // Especie Moeda
		oPrn:Say(420,1785,"Quantidade",oFont1,100) // Quantidade
		oPrn:Say(420,2205,"Valor",oFont1,100) // Valor
		oPrn:Say(420,2420,"1 (=) Valor do Documento",oFont1,100) // Valor do documento
		
		oPrn:Say(460,0100,Transform(SE1->E1_VALOR,PesqPict("SE1","E1_VALOR")),oFont1,100) // Valor Documento
		oPrn:Say(460,0955,"08650",oFont1,100) // Uso do Banco
		oPrn:Say(460,1305,"09",oFont1,100) // Carteira
		oPrn:Say(460,1520,"R$",oFont1,100) // Especie Moeda
		oPrn:Say(460,2460,Transform(SE1->E1_VALOR,PesqPict("SE1","E1_VALOR")),oFont1,100) // Valor do documento
		
		oPrn:Box(500,0000,580,0900) // (-)Desconto/Abatimento
		oPrn:Box(500,2400,580,2900) // (-)Desconto/Abatimento
		oPrn:Box(500,0930,900,2400) // Instrucoes para o banco
		
		oPrn:Say(500,0020,"(-) Desconto/Abatimento",oFont1,100) // (-)Desconto/Abatimento
		oPrn:Say(500,2420,"2 (-) Desconto/Abatimento",oFont1,100) // (-)Desconto/Abatimento
		oPrn:Say(500,0960,"Instru็๕es de Responsabilidade do Cedente",oFont1,100) // Instrucoes para o banco
		
		oPrn:Box(580,0000,660,0900) // (-)Outras Dedu็๕es
		oPrn:Box(580,2400,660,2900) // (-)Outras Dedu็๕es
		
		oPrn:Say(580,0020,"(-) Outras Dedu็๕es",oFont1,100) // (-)Outras Dedu็๕es
		oPrn:Say(580,2420,"3 (-) Outras Dedu็๕es",oFont1,100) // (-)Outras Dedu็๕es
		oPrn:Say(570,0960,"** Valores Expressos em R$",oFont1,100)
		
		oPrn:Box(660,0000,740,0900) // (-)Mora/Multa
		oPrn:Box(660,2400,740,2900) // (-)Mora/Multa
		
		oPrn:Say(660,0020,"(+) Mora/Multa",oFont1,100) // (-)Mora/Multa
		oPrn:Say(660,2420,"4 (+) Mora/Multa",oFont1,100) // (-)Mora/Multa
		
		oPrn:Box(740,0000,820,0900) // (-)Outrss Acrescimos
		oPrn:Box(740,2400,820,2900) // (-)Outros Acrescimos
		
		oPrn:Say(740,0020,"(+)Outros Acr้scimos",oFont1,100) // (-)Outros Acrescimos
		oPrn:Say(740,2420,"5 (+)Outros Acr้scimos",oFont1,100) // (-)Outros Acrescimos
		
		oPrn:Box(820,0000,900,0900) // (=)Valor Cobrado
		oPrn:Box(820,2400,900,2900) // (=)Valor Cobrado
		
		oPrn:Say(820,0020,"(=) Valor Cobrado",oFont1,100) // (=)Valor Cobrado
		oPrn:Say(820,2420,"6 (=) Valor Cobrado",oFont1,100) // (=)Valor Cobrado
		
		oPrn:Box(900,0000,980,0900) // Cart./Nosso Numero
		oPrn:Say(900,0020,"Cart./Nosso N๚mero",oFont1,100)
		
		oPrn:Box(980,0000,1060,0900) // No.Documento
		oPrn:Say(980,0020,"No.Documento",oFont1,100)
		
		oPrn:Box(900,0930,1060,2900) // Sacado
		oPrn:Say(930,0940,"Sacado "+SA1->A1_NOME,oFont1,100)
		If Len(Alltrim(SA1->A1_CGC))==11
			oPrn:Say(940,2100,"CGC "+Transform(SA1->A1_CGC,"@R 999.999.999-99"),oFont1,100)
		Else
			oPrn:Say(940,2100,"CGC "+Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont1,100)
		EndIf
		oPrn:Say(960,0940,AllTrim(SA1->A1_END)+" - "+Alltrim(SA1->A1_BAIRRO),oFont1,100)
		oPrn:Say(0990,0940,Transform(SA1->A1_CEP,"@R 99999-999")+"   "+Alltrim(SA1->A1_MUN)+" - "+SA1->A1_EST,oFont1,100)
		oPrn:Say(1060,0940,"Sacador/Avalista",oFont1,100)
		
		MsBar("INT25"  ,7,9,Barra  ,oPrn,.F.,,.T.,0.025,0.75)
		
		oPrn:Say(1240,2100,"Autentica็ใo Mecโnica      Ficha de Compensa็ใo",oFont1,100)
		
		
		oPrn:Box(1060,0000,1200,0900) // Cart./Nosso Numero
		
		oPrn:Say(1060,0020,"Sac ",oFont1,100)
		oPrn:Say(1060,0100,SA1->A1_NOME,oFont1,100)
		oPrn:Say(1100,0020,SM0->M0_NOMECOM,oFont1,100)
		If Len(Alltrim(SA1->A1_CGC))==11
			oPrn:Say(1140,0450,"CGC "+Transform(SA1->A1_CGC,"@R 999.999.999-99"),oFont1,100)
		Else
			oPrn:Say(1140,0450,"CGC "+Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont1,100)
		EndIf
		oPrn:Say(1210,0020,"Autenticar no Verso",oFont1,100)
		
		nPag ++
		
		DbSkip()
		
	Enddo
	oPrn:Preview()
	oPrn:Print() // descomentar esta linha para imprimir
	MS_FLUSH()
	Return .T.
	
	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบFuno    ณVALIDPERG บ Autor ณ Rdmake        บ Data ณ  21/08/01   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
	ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ Programa principal                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	/*/
	
	Static Function ValidPerg
	
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,6)
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variaveis utilizadas para parametros                         ณ
	//ณ mv_par01            // Prefixo                               ณ
	//ณ mv_par02            // Do numero                             ณ
	//ณ mv_par03            // Ateh o numero                         ณ
	//ณ mv_par04            // Taxa de Juros                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,6)
	If ALLTRIM(cVersao) == "5.07"
		// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
		aAdd(aRegs,{cPerg,"01","Prefixo       ?","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{cPerg,"02","Numero de     ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{cPerg,"03","Numero ate    ?","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{cPerg,"04","Tx. Juros     ?","mv_ch4","N",06,2,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
	Else
		aAdd(aRegs,{cPerg,"01","Prefixo       ?","Prefixo       ?","Prefixo       ?","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{cPerg,"02","Numero de     ?","Numero de     ?","Numero de     ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{cPerg,"03","Numero ate    ?","Numero ate    ?","Numero ate    ?","mv_ch3","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
		aAdd(aRegs,{cPerg,"04","Tx. Juros     ?","Tx. Juros     ?","Tx. Juros     ?","mv_ch4","N",06,2,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Endif
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(_sAlias)
	Return
	
	
	
	
	
	Static Function cDigi()
	
	lBase  := Len(V_Base)
	umdois := 2
	sumdig := 0
	auxi   := 0
	
	iDig := lBase
	
	Do While iDig >= 1
		auxi   := Val (Subs(V_base, idig, 1)) * umdois
		sumdig := SumDig + Iif (auxi < 10, auxi, INT (auxi / 10) + auxi % 10)
		umdois := 3 - umdois
		iDig   := iDig - 1
	Enddo
	
	auxi   := Str (Round (sumdig / 10 + 0.49, 0) * 10 - sumdig, 1)
	V_Base := V_Base + auxi
	
	Return
