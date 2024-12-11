#include "rwmake.ch"
//#include "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ CISFT07	³ Autor ³                       ³ Data ³ 28/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do Boleto                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ CIS Eletronica                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CISFT07(_cNumBorde)

SetPrvt("NDIGBOL,NDIGBAR,CALIAS")
SetPrvt("NFI,NFF,SERIE,_CLINHA,FATOR,ARQ,CGRUPO,PERG")
SetPrvt("I,NVAL,FILTIMP,ARETURN,AINFO,NLASTKEY,CSTRING")
SetPrvt("WNREL,NCONT,XI,_cCampo,NDIGITO,Nnumero")

//GRAVA O NOME DA FUNCAO NA Z03
U_CFGRD001(FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de Variaveis                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private _nCont    := 1
Private cPerg
Private _aTitulos := {}
Private _nDigbar  := "1"
Private _cNum     := ""
Private _cFiltro  := ""

// _aTitulos => array que contem as informacoes
// que serao impressas no boleto
// [n,01] = Prefixo+Numero+Parcela do Titulo
// [n,02] = Vencimento
// [n,03] = Valor do Titulo
// [n,04] = Nosso Numero
// [n,05] = Agencia
// [n,06] = Codigo do Cedente
// [n,07] = Carteira
// [n,08] = Nome do CLiente
// [n,09] = Emissao do titulo
// [n,10] = Endereco do Cliente
// [n,11] = Cidade do Cliente
// [n,12] = Estado do Cliente
// [n,13] = CEP do Cliente
// [n,14] = CNPJ do Cliente
// [n,15] = Data do Processamento
// [n,16] = Conta do Cedente

cPerg := "CSFT07"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Nota                              ³
//³ mv_par02             // Ate a Nota                           ³
//³ mv_par03             // Serie                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()

// Retira filtro
dbSelectArea("SE1")
_cFiltro := DbFilter()
Set Filter to

// Inicializa array de titulos

If Valtype(_cNumBorde) == "U" .or. Len(_cNumBorde) == 0
	_nCont    := 1
	If Pergunte(cPerg,.T.)
		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+mv_par03+mv_par01)
		While !Eof() .and. SE1->E1_NUM >= mv_par01 .and. SE1->E1_NUM <= mv_par02 .and. ;
			SE1->E1_PREFIXO == mv_par03
			If SE1->E1_PORTADO $ "237" .and. SE1->E1_NUMBCO <> "" .and. ;
				SE1->E1_AGEDEP <> "" .and. SE1->E1_CONTA <> "" .and. ;
				SE1->E1_CONTA <> "" .AND. SE1->E1_TIPO="NF"
				
				
				Aadd(_aTitulos,{"","",0,"","","","","","","","","","","","",""})
				_cNum := SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA
				_aTitulos[_nCont][01] := _cNum            // Prexifo+Numero+Parcela do Titulo
				_aTitulos[_nCont][02] := SE1->E1_VENCTO   // Vencimento
				_aTitulos[_nCont][03] := U_FATRD006() // saldo
				_aTitulos[_nCont][04] := SE1->E1_NUMBCO   // Nosso Numero
				cDigAgen := Posicione("SA6",1,xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,"A6_DIGAGEN")
				_aTitulos[_nCont][05] := SE1->E1_AGEDEP+cDigAgen   // Agencia
				_aTitulos[_nCont][08] := StrZero(Day(SE1->E1_EMISSAO),2)+"/"+StrZero(Month(SE1->E1_EMISSAO),2)+"/"+StrZero(Year(SE1->E1_EMISSAO),4)
				_aTitulos[_nCont][16] := SE1->E1_CONTA 	  // Numero da Conta Corrente
				
				// Obtem Carteira e Codigo do Cedente
				// Posiciona no SEA que e o arquivo que tem a subconta
				// que sera utilizado na chave de pesquisa do SEE
				// que e o arquivo que tem a informacao da carteira
				// e o codigo do cedente
				
				DbSelectArea("SEA")
				DbSetOrder(1)
				If DbSeek(xFilial("SEA")+SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
					DbSelectArea("SEE")
					DbSetOrder(1)
					If DbSeek(xFilial("SEE")+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON+SEA->EA_SUBCTA)
						_aTitulos[_nCont][06] := Right(Alltrim(SEE->EE_CODEMP),9)   // Codigo do Cedente
						_aTitulos[_nCont][07] := SEE->EE_CART      // Carteira
					Else
						MsgAlert("Nao encontrou Parametros Banco !")
					Endif
				Else
					MsgAlert("Nao encontrou Parametros Banco !")
				Endif
				// Obtem dados do cliente
				DbSelectArea("SA1")
				DbSetOrder(1)
				If DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
					_aTitulos[_nCont][09] := SA1->A1_NOME
					_aTitulos[_nCont][10] := SA1->A1_END
					_aTitulos[_nCont][11] := SA1->A1_MUN
					_aTitulos[_nCont][12] := SA1->A1_EST
					_aTitulos[_nCont][13] := SA1->A1_CEP
					_aTitulos[_nCont][14] := SA1->A1_CGC
					_aTitulos[_nCont][15] := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2)+"/"+StrZero(Year(dDatabase),4)
				Endif
				_nCont += 1
			Endif
			DbSelectArea("SE1")
			DbSkip()
		End
	EndIf
Else
	_nCont := 1
	DbSelectArea("SEA")
	DbSetOrder(1)
	If DbSeek(xFilial("SEA")+_cNumBorde)
		While !Eof() .and. SEA->EA_NUMBOR == _cNumBorde
			DbSelectArea("SE1")
			DbSetOrder(1)
			If DbSeek(xFilial("SE1")+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO)
				If SE1->E1_PORTADO $ "237" .and. SE1->E1_NUMBCO <> "" .and. ;
					SE1->E1_AGEDEP <> "" .and. SE1->E1_CONTA <> "" .and. ;
					SE1->E1_CONTA <> ""
					
					Aadd(_aTitulos,{"","",0,"","","","","","","","","","","","",""})
					
					_cNum := SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA
					_aTitulos[_nCont][01] := _cNum            // Prexifo+Numero+Parcela do Titulo
					_aTitulos[_nCont][02] := SE1->E1_VENCTO   // Vencimento
					_aTitulos[_nCont][03] := U_FATRD006() // saldo
					_aTitulos[_nCont][04] := SE1->E1_NUMBCO   // Nosso Numero
					cDigAgen := Posicione("SA6",1,xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,"A6_DIGAGEN")
					_aTitulos[_nCont][05] := SE1->E1_AGEDEP+cDigAgen   // Agencia
					_aTitulos[_nCont][08] :=StrZero(Day(SE1->E1_EMISSAO),2)+"/"+StrZero(Month(SE1->E1_EMISSAO),2)+"/"+StrZero(Year(SE1->E1_EMISSAO),4)
					_aTitulos[_nCont][16] := SE1->E1_CONTA 	  // Numero da Conta Corrente
					
					// Obtem Carteira e Codigo do Cedente
					// Posiciona no SEE que e o arquivo que tem
					// a informacao da carteira e o codigo do cedente
					
					DbSelectArea("SEE")
					DbSetOrder(1)
					If DbSeek(xFilial("SEE")+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON+SEA->EA_SUBCTA)
						_aTitulos[_nCont][06] := Right(Alltrim(SEE->EE_CODEMP),9)   // Codigo do Cedente
						_aTitulos[_nCont][07] := SEE->EE_CART      // Carteira
					Else
						MsgAlert("Nao encontrou Parametros Banco !")
					Endif
					
					// Obtem dados do cliente
					DbSelectArea("SA1")
					DbSetOrder(1)
					If DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
						_aTitulos[_nCont][09] := SA1->A1_NOME
						_aTitulos[_nCont][10] := SA1->A1_END
						_aTitulos[_nCont][11] := SA1->A1_MUN
						_aTitulos[_nCont][12] := SA1->A1_EST
						_aTitulos[_nCont][13] := SA1->A1_CEP
						_aTitulos[_nCont][14] := SA1->A1_CGC
						_aTitulos[_nCont][15] := StrZero(Day(dDatabase),2)+"/"+StrZero(Month(dDatabase),2)+"/"+StrZero(Year(dDatabase),4)
					Endif
					_nCont += 1
				Endif
			Endif
			DbSelectArea("SEA")
			DbSkip()
		EndDo
	Else
		MsgAlert("Nao Localizou Bordero, entre em contato com a Informatica !")
		Return
	Endif
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializacao de Variaveis                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private _cBarra  := SPACE(44)
Private _nPosHor := 0
Private _nLinha  := 0
Private _nEspLin := 0
Private _nTxtBox := 0
Private _nPosVer := 0


nDigbol    := SPACE(1)
nDigbar    := SPACE(1)
NFi        := Space(6)
NFf        := Space(6)
Serie      := Space(3)
Nnumero    := Space(11)
_cLinha     := ""
Fator      := CTOD("07/10/1997")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela de Entrada de Dados                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

FiltImp    := ""
aInfo      := {}
nHeight    := 15
lBold      := .F.
lUnderLine := .F.
lPixel     := .T.
lPrint     := .F.
//                              Font              W  H  Bold  - Italic - Underline - Device
//oFont1 := oSend(TFont(),"New","Arial"          ,0,14,,.F.,,,,.F.,.F.,,,,,,oPrn)

oFont06  := TFont():New( "Arial",,06,,.F.,,,,,.F. )
oFont06B := TFont():New( "Arial",,06,,.T.,,,,,.F. )
oFont07  := TFont():New( "Arial",,07,,.F.,,,,,.F. )
oFont07B := TFont():New( "Arial",,07,,.T.,,,,,.F. )
oFont08  := TFont():New( "Arial",,08,,.F.,,,,,.F. )
oFont08B := TFont():New( "Arial",,08,,.T.,,,,,.F. )
oFont09  := TFont():New( "Arial",,09,,.F.,,,,,.F. )
oFont09B := TFont():New( "Arial",,09,,.T.,,,,,.F. )
oFont10  := TFont():New( "Arial",,10,,.F.,,,,,.F. )
oFont10B := TFont():New( "Arial",,10,,.T.,,,,,.F. )
oFont11  := TFont():New( "Arial",,11,,.F.,,,,,.F. )
oFont11B := TFont():New( "Arial",,11,,.T.,,,,,.F. )
oFont12  := TFont():New( "Arial",,12,,.F.,,,,,.F. )
oFont12B := TFont():New( "Arial",,12,,.T.,,,,,.F. )
oFont13  := TFont():New( "Arial",,13,,.F.,,,,,.F. )
oFont13B := TFont():New( "Arial",,13,,.T.,,,,,.F. )
oFont14  := TFont():New( "Arial",,14,,.F.,,,,,.F. )
oFont14B := TFont():New( "Arial",,14,,.T.,,,,,.F. )
oFont15  := TFont():New( "Arial",,15,,.F.,,,,,.F. )
oFont15B := TFont():New( "Arial",,15,,.T.,,,,,.F. )
oFont16  := TFont():New( "Arial",,16,,.F.,,,,,.F. )
oFont16B := TFont():New( "Arial",,16,,.T.,,,,,.F. )
oFont17  := TFont():New( "Arial",,17,,.F.,,,,,.F. )
oFont17B := TFont():New( "Arial",,17,,.T.,,,,,.F. )
oFont18  := TFont():New( "Arial",,18,,.F.,,,,,.F. )
oFont18B := TFont():New( "Arial",,18,,.T.,,,,,.F. )
oFont19  := TFont():New( "Arial",,19,,.F.,,,,,.F. )
oFont19B := TFont():New( "Arial",,19,,.T.,,,,,.F. )
oFont20  := TFont():New( "Arial",,20,,.F.,,,,,.F. )
oFont20B := TFont():New( "Arial",,20,,.T.,,,,,.F. )
oFont21  := TFont():New( "Arial",,21,,.F.,,,,,.F. )
oFont21B := TFont():New( "Arial",,21,,.T.,,,,,.F. )
oFont22  := TFont():New( "Arial",,22,,.F.,,,,,.F. )
oFont22B := TFont():New( "Arial",,22,,.T.,,,,,.F. )
oFont23  := TFont():New( "Arial",,23,,.F.,,,,,.F. )
oFont23B := TFont():New( "Arial",,23,,.T.,,,,,.F. )
oFont24  := TFont():New( "Arial",,24,,.F.,,,,,.F. )
oFont24B := TFont():New( "Arial",,24,,.T.,,,,,.F. )
oFont25  := TFont():New( "Arial",,25,,.F.,,,,,.F. )
oFont25B := TFont():New( "Arial",,25,,.T.,,,,,.F. )
oFont26  := TFont():New( "Arial",,26,,.F.,,,,,.F. )
oFont26B := TFont():New( "Arial",,26,,.T.,,,,,.F. )
oFont27  := TFont():New( "Arial",,27,,.F.,,,,,.F. )
oFont27B := TFont():New( "Arial",,27,,.T.,,,,,.F. )
oFont28  := TFont():New( "Arial",,28,,.F.,,,,,.F. )
oFont28B := TFont():New( "Arial",,28,,.T.,,,,,.F. )
oFont29  := TFont():New( "Arial",,29,,.F.,,,,,.F. )
oFont29B := TFont():New( "Arial",,29,,.T.,,,,,.F. )
oFont30  := TFont():New( "Arial",,30,,.F.,,,,,.F. )
oFont30B := TFont():New( "Arial",,30,,.T.,,,,,.F. )

oprn     := TMSPrinter():New()

oprn:setup()

npag  :=1
serie := ""
nfi   := ""
nff   := ""

For _nCont := 1 to len(_aTitulos)
	// Posicionamento Horizontal
	_nPosHor := 01
	_nLinha  := 01
	_nEspLin := 84
	
	// Posicionamento Vertical
	_nPosVer := 10
	
	// Posicionamento do Texto Dentro do Box
	_nTxtBox := 05
	
	//	oPRINTER(SETPAPERSIZE(9)) // <==== ajuste para papel A4
	oprn:SETPAPERSIZE(9) // <==== ajuste para papel A4
	
	oprn:StartPage()
	
	CISFT07A()
	oprn:EndPage()
	npag:= npag + 1
	
Next _nCont
//oprn:setup()
oprn:Preview()
//oPrn:Print() // descomentar esta linha para imprimir

ms_flush()


// Restaura filtro
DbSelectArea("SE1")
Set Filter To &_cFiltro

Return (.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ CISFT07A	³ Autor ³                       ³ Data ³ 05/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do Boleto                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ CIS Eletronica                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CISFT07A()

// Monta codigo de barras do titulo
CISFT07B()
// Monta Linha digitavel
CISFT07D()

//oprn:StartPage()

// Recibo do Sacado
// Box Cedente



oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+25,_nTxtBox+0140,"Bradesco",ofont14B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nTxtBox+0366,"|237-2|",ofont22B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+10,_nPosVer+1650,"Comprovante de Entrega",ofont14B,100)
_nLinha  := _nLinha + 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0830)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Cedente",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin+30)+_nTxtBox,_nPosVer+0010,"CIS ELETRONICA INDUSTRIA E COM",ofont08,100)

// Box Agencia/Codigo Cedente
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0830,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1180)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0840,"Agência/Código Cedente",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin+30)+_nTxtBox,_nPosVer+0850,transform(_aTitulos[_nCont][05],"@R 9999-9")+"/"+transform(_aTitulos[_nCont][06],"@R 99999999-9"),ofont08B,100)

// Box Motivos nao entrega
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1180,_nPosHor+(_nLinha*_nEspLin)+(2*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1290,"Motivos de não entrega(para uso da empresa entregadora)",ofont08,100)

oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0050)+_nTxtBox,_nPosVer+1210,"( )Mudou-se",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0050)+_nTxtBox,_nPosVer+1490,"( )Ausente",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0050)+_nTxtBox,_nPosVer+1820,"( )Não existe n. indicado",ofont08,100)

oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0100)+_nTxtBox+0025,_nPosVer+1210,"( )Recusado",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0100)+_nTxtBox+0025,_nPosVer+1490,"( )Não Procurado",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0100)+_nTxtBox+0025,_nPosVer+1820,"( )Falecido",ofont08,100)

oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0150)+_nTxtBox+0050,_nPosVer+1210,"( )Desconhecido",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0150)+_nTxtBox+0050,_nPosVer+1490,"( )Endereço Insuficiente",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin+0150)+_nTxtBox+0050,_nPosVer+1820,"( )Outros (anotar no verso)",ofont08,100)

// Box Sacado
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0830)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Sacado",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0010,_aTitulos[_nCont][09],ofont08,100)

// Box Nosso Numero
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0830,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1180)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0840,"Nosso Número",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0860,_aTitulos[_nCont][07]+"/"+transform(_aTitulos[_nCont][04],"@R 99999999999-X"),ofont08B,100)

// Box Vencimento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0200)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Vencimento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0030,StrZero(Day(_aTitulos[_nCont][02]),2)+"/"+StrZero(Month(_aTitulos[_nCont][02]),2)+"/"+StrZero(Year(_aTitulos[_nCont][02]),4),ofont08B,100)

// Box Numero do Documento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0200,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0520)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0210,"N. do Documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0300,_aTitulos[_nCont][01],ofont08,100)

// Box Especie Moeda
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0520,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0830)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0530,"Espécie Moeda",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0650,"R$",ofont08,100)

// Box Valor do Documento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0830,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1180)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0840,"Valor do Documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0940,transform(_aTitulos[_nCont][03],"@E 999,999,999.99"),ofont08B,100)

// Box Recebimento bloqueto
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0340)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Recebi(emos) o bloqueto",ofont08,100)

// Box Data
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0340,_nPosHor+(_nLinha*_nEspLin),_nPosVer+560)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0350,"Data",ofont08,100)

// Box Assinatura
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0560,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1180)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0570,"Assinatura",ofont08,100)

// Box Data
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1180,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1520)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1190,"Data",ofont08,100)

// Box Entregador
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1520,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1530,"Entregador",ofont08,100)

// Box Local de Pagamento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer    ,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1910)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox    ,_nPosVer+0010,"Local de Pagamento",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox    ,_nPosVer+0275,"BANCO BRADESCO S.A.",ofont09B,150)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+33 ,_nPosVer+0275,"PAGAR PREFERENCIALMENTE EM QUALQUER AGENCIA BRADESCO.",ofont09B,150)

// Box Data de Processamento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1910,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1920,"Data de Processamento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1980,_aTitulos[_nCont][15],ofont08,100)

// Box Recibo do Sacado
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+25,_nTxtBox+0140,"Bradesco",ofont14B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nTxtBox+0366,"|237-2|",ofont22B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1720,"Recibo do Sacado",ofont14B,100)

// Box Local de Pagamento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer    ,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox    ,_nPosVer+0010,"Local de Pagamento",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox    ,_nPosVer+0275,"BANCO BRADESCO S.A.",ofont09B,150)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+33 ,_nPosVer+0275,"PAGAR PREFERENCIALMENTE EM QUALQUER AGENCIA BRADESCO.",ofont09B,150)

// Box Logotipo
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin)+4*_nEspLin,_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*(_nEspLin-2)),_nPosVer+1695,"|          |",ofont14B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1725,"237-2",ofont12B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1870,"Recibo do Sacado",ofont10B,100)

// Box Cedente
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Cedente",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin+30)+_nTxtBox,_nPosVer+0010,"CIS ELETRONICA INDUSTRIA E COM",ofont08,100)

// Box Data do documento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0420)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Data do documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0100,_aTitulos[_nCont][08],ofont08,100)

// Box Numero do Documento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0420,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0790)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0430,"N° do documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0530,_aTitulos[_nCont][01],ofont08,100)

// Box Especie Doc
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0790,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1050)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0800,"Espécie Doc",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0900,"DM",ofont08,100)

// Box Aceite
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1050,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1170)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1060,"Aceite",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1080,"Não",ofont08,100)

// Box Data do Processamento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1170,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1180,"Data do Processamento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1280,_aTitulos[_nCont][15],ofont08,100)

// Box Uso do Banco
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0300)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Uso do Banco",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0050,"08650",ofont08,100)

// Box Cip
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0300,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0420)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0310,"Cip",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0315,"000",ofont08,100)

// Box Carteira
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0420,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0552)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0430,"Carteira",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0480,_aTitulos[_nCont][07],ofont08,100)

// Box Especie Moeda
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0552,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0790)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0562,"Espécie moeda",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0652,"R$",ofont08,100)

// Box Quantidade
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0790,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1170)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0800,"Quantidade",ofont08,100)

// Box Valor
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1170,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1180,"Valor",ofont08,100)

// Box Logotipo
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1700,"Bradesco",ofont30B,100)

// Box Instrucoes
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin)+9*_nEspLin,_nPosVer+1650)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1680,"Pagável nas agências Bradesco",ofont10B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+10,_nPosVer+0010,"Instruções de responsabilidade do cedente.",ofont09B,100)

// Box Vencimento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"Vencimento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+2060,StrZero(Day(_aTitulos[_nCont][02]),2)+"/"+StrZero(Month(_aTitulos[_nCont][02]),2)+"/"+StrZero(Year(_aTitulos[_nCont][02]),4),ofont08B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"*** Valores Expressos em R$ ***",ofont09B,100)

// Box Agencia/Codigo Cedente
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"Agência/Código Cedente",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin+30)+_nTxtBox,_nPosVer+1940,transform(_aTitulos[_nCont][05],"@R 9999-9")+"/"+transform(_aTitulos[_nCont][06],"@R 99999999-9"),ofont08B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"APOS O VENCIMENTO, MULTA DE 2,00 %",ofont09B,100)

// Box Cart./nosso numero
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"Cart./nosso número",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1960,_aTitulos[_nCont][07]+"/"+transform(_aTitulos[_nCont][04],"@R 99999999999-X"),ofont08B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"Apos o Vencimento Mora dia R$ "+transform(_aTitulos[_nCont][03]*0.003333,"@E 999,999,999.99"),ofont08,100)
// Box Valor do documento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"1(=) Valor do documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+2000,transform(_aTitulos[_nCont][03],"@E 999,999,999.99"),ofont08B,100)

// Box Desconto / Abatimento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"2(-) Desconto/abatimento",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"-Pague este título nas Agências Bradesco (ou através do Sistema Integrado de Compensação)",ofont09B,100)

// Box Outras deducoes
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"3(-) Outras deduções",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"-Após o 3o dia útil do venvimento, pagável somente na Agência Depositária Oficial, se houver indicação no",ofont09,100)

// Box Mora / Multa
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"4(+) Mora/Multa",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"-'Local de Pagamento' desta papeleta e desde que não haja instruções contrárias do Cedente no espaço acima",ofont09,100)

// Box Outros acrescimos
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"5(+) Outros Acréscimos",ofont08,100)

// Box Valor cobrado
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"6(=) Valor cobrado",ofont08,100)

// Box Sacado
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin)+_nEspLin,_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Sacado:",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0150,_aTitulos[_nCont][09],ofont08,100) // Nome Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1400,Transform(_aTitulos[_nCont][14],"@R 99.999.999/9999-99"),ofont08,100) // CNPJ Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0030,_nPosVer+0150,_aTitulos[_nCont][10],ofont08,100) // End. Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0060,_nPosVer+0150,Transform(_aTitulos[_nCont][13],"@R 99999-999"),ofont08,100) // CEP Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0060,_nPosVer+0550,_aTitulos[_nCont][11],ofont08,100) // Cidade Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0060,_nPosVer+1000,_aTitulos[_nCont][12],ofont08,100) // Estado Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0120,_nPosVer+0010,"Sacador/Avalista:",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0170,_nPosVer+1750,"Autenticação Mecânica",ofont08,100)

// Ficha de compensacao
_nLinha  += 4
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,Replicate("-",160),ofont12,100)
// Linha Digitavel
_nLinha  += 1
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+25,_nTxtBox+0140,"Bradesco",ofont14B,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nTxtBox+0366,"|237-2|",ofont22B,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+0010,_nTxtBox+0700,_clinha,oFont14,100)

// Box Local de Pagto
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer    ,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox    ,_nPosVer+0010,"Local de Pagamento",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox    ,_nPosVer+0275,"BANCO BRADESCO S.A.",ofont09B,150)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+33 ,_nPosVer+0275,"PAGAR PREFERENCIALMENTE EM QUALQUER AGENCIA BRADESCO.",ofont09B,150)

// Box Vencimento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"Vencimento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+2060,StrZero(Day(_aTitulos[_nCont][02]),2)+"/"+StrZero(Month(_aTitulos[_nCont][02]),2)+"/"+StrZero(Year(_aTitulos[_nCont][02]),4),ofont08B,100)

// Box Cedente
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Cedente",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin+30)+_nTxtBox,_nPosVer+0010,"CIS ELETRONICA INDUSTRIA E COM",ofont08,100)

// Box Agencia/Codigo Cedente
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"Agência/Código Cedente",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin+30)+_nTxtBox,_nPosVer+1940,transform(_aTitulos[_nCont][05],"@R 9999-9")+"/"+transform(_aTitulos[_nCont][06],"@R 99999999-9"),ofont08B,100)

// Box Data do documento
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0420)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Data do documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0100,_aTitulos[_nCont][08],ofont08,100)

// Box Numero do Documento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0420,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0790)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0430,"N° do documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0530,_aTitulos[_nCont][01],ofont08,100)

// Box Especie Doc
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0790,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1050)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0800,"Espécie Doc",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0900,"DM",ofont08,100)

// Box Aceite
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1050,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1170)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1060,"Aceite",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1080,"Não",ofont08,100)


// Box Data do Processamento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1170,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1180,"Data do Processamento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1280,_aTitulos[_nCont][15],ofont08,100)

// Box Cart./nosso numero
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"Cart./nosso número",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+1960,_aTitulos[_nCont][07]+"/"+transform(_aTitulos[_nCont][04],"@R 99999999999-X"),ofont08B,100)

// Box Uso do Banco
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0300)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Uso do Banco",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0050,"08650",ofont08,100)

// Box Cip
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0300,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0420)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0310,"Cip",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0315,"000",ofont08,100)

// Box Carteira
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0420,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0552)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0430,"Carteira",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0480,_aTitulos[_nCont][07],ofont08,100)

// Box Espécie Moeda
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0552,_nPosHor+(_nLinha*_nEspLin),_nPosVer+0790)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0562,"Espécie moeda",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+0662,"R$",ofont08,100)

// Box Quantidade
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0790,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1170)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0800,"Quantidade",ofont08,100)

// Box Valor
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1170,_nPosHor+(_nLinha*_nEspLin),_nPosVer+1650)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1180,"Valor",ofont08,100)

// Box Valor do documento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"1(=) Valor do documento",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+30,_nPosVer+2000,transform(_aTitulos[_nCont][03],"@E 999,999,999.99"),ofont08B,100)

_nLinha  += 1

// Box Desconto / Abatimento
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"2(-) Desconto/abatimento",ofont08,100)

// Box Instrucoes
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin)+4*_nEspLin,_nPosVer+1650)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+20,_nPosVer+0010,"Instruções de responsabilidade do cedente.",ofont09B,100)

// Box Outras deducoes
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"3(-) Outras deduções",ofont08,100)

oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"*** Valores Expressos em R$ ***",ofont09B,100)

// Box Mora / Multa
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"4(+) Mora/Multa",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+0010,"Apos o Vencimento Mora dia R$ "+transform(_aTitulos[_nCont][03]*0.003333,"@E 999,999,999.99"),ofont08,100)
// Box Outros acrescimos
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"5(+) Outros Acréscimos",ofont08,100)
oprn:say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+10,_nPosVer+0010,"APOS O VENCIMENTO, MULTA DE 2,00 %",ofont09B,100)

// Box Valor cobrado
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer+1650,_nPosHor+(_nLinha*_nEspLin),_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1660,"6(=) Valor cobrado",ofont08,100)

// Box Sacado
_nLinha  += 1
oPrn:Box(_nPosHor+((_nLinha-1)*_nEspLin),_nPosVer,_nPosHor+(_nLinha*_nEspLin)+_nEspLin,_nPosVer+2230)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0010,"Sacado:",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+0150,_aTitulos[_nCont][09],ofont08,100) // Nome Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox,_nPosVer+1400,Transform(_aTitulos[_nCont][14],"@R 99.999.999/9999-99"),ofont08,100) // CNPJ Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0030,_nPosVer+0150,_aTitulos[_nCont][10],ofont08,100) // End. Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0060,_nPosVer+0150,Transform(_aTitulos[_nCont][13],"@R 99999-999"),ofont08,100) // CEP Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0060,_nPosVer+0550,_aTitulos[_nCont][11],ofont08,100) // Cidade Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0060,_nPosVer+1000,_aTitulos[_nCont][12],ofont08,100) // Estado Sacado
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0120,_nPosVer+0010,"Sacador/Avalista:",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0170,_nPosVer+1530,"Autenticação Mecânica",ofont08,100)
oPrn:Say(_nPosHor+((_nLinha-1)*_nEspLin)+_nTxtBox+0170,_nPosVer+1860,"Ficha de Compensação",ofont09,100)

// Imprime Logotipo do Banco
oPrn:Saybitmap(0015,0060,"BRADESCO2.BMP",0080,0070)

// Imprime Logotipo do Banco
oPrn:Saybitmap(0515,0060,"BRADESCO2.BMP",0080,0070)

// Imprime Logotipo do Banco
oPrn:Saybitmap(0690,1850,"BRADESCO2.BMP",0180,0180)

// Imprime Logotipo do Banco
oPrn:Saybitmap(2195,0060,"BRADESCO2.BMP",0080,0070)

// Imprime codigo de barras
MSBAR("INT25",14.35,0.7,_cbarra,oprn,.F.,,.T.,0.0135,0.65,NIL,NIL,NIL,.F.)

Return (.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ CISTF07B º Autor ³                    º Data ³  11/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta codigo de barras que sera impresso.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CISFT07B()

Local _nAgen   := ""
Local _nCntCor := ""
Local _nI      := 0

/*
- Posicoes fixas padrao Banco Central
Posicao  Tam       Descricao
01 a 03   03   Codigo de Compensacao do Banco (237)
04 a 04   01   Codigo da Moeda (Real => 9, Outras => 0)
05 a 05   01   Digito verificador do codigo de barras
06 a 19   14   Valor Nominal do Documento sem ponto

- Campo Livre Padrao Bradesco
Posicao  Tam       Descricao
20 a 23   03   Agencia Cedente sem digito verificador
24 a 25   02   Carteira
25 A 36   11   Nosso Numero sem digito verificador
37 A 43   07   Conta Cedente sem digiro verificador
44 A 44   01   Zero
*/

// Monta numero da Agencia sem dv e com 4 caracteres
// Retira separador de digito se houver
For _nI := 1 To Len(_aTitulos[_nCont][05])
	If Subs(_aTitulos[_nCont][05],_nI,1) $ "0/1/2/3/4/5/6/7/8/9/"
		_nAgen += Subs(_aTitulos[_nCont][05],_nI,1)
	Endif
Next _nI
// retira o digito verificador
_nAgen := StrZero(Val(Subs(Alltrim(_nAgen),1,Len(_nAgen)-1)),4)

// Monta numero da Conta Corrente sem dv e com 7 caracteres
// Retira separador de digito se houver
For _nI := 1 To Len(_aTitulos[_nCont][16])
	If Subs(_aTitulos[_nCont][16],_nI,1) $ "0/1/2/3/4/5/6/7/8/9/"
		_nCntCor += Subs(_aTitulos[_nCont][16],_nI,1)
	Endif
Next _nI
// retira o digito verificador
_nCntCor := StrZero(Val(Subs(Alltrim(_nCntCor),1,Len(_nCntCor)-1)),7)

_cCampo := ""
// Pos 01 a 03 - Identificacao do Banco
_cCampo += "237"
// Pos 04 a 04 - Moeda
_cCampo += "9"
// Pos 06 a 09 - Fator de vencimento
_cCampo += Str((_aTitulos[_nCont][02] - Fator),4)
// Pos 10 a 19 - Valor
_cCampo += StrZero(Int(_aTitulos[_nCont][03]*100),10)
// Pos 20 a 23 - Agencia
_cCampo += _nAgen
// Pos 24 a 25 - Carteira
_cCampo += _aTitulos[_nCont][07]
// Pos 26 a 36 - Nosso Numero
_cCampo += Subs(_aTitulos[_nCont][04],1,11)
// Pos 37 a 43 - Conta do Cedente
_cCampo += _nCntCor
// Pos 44 a 44 - Zero
_cCampo += "0"
_cDigitbar := CISFT07C()

// Monta codigo de barras com digito verificador
_cBarra := Subs(_cCampo,1,4)+_cDigitbar+Subs(_cCampo,5,43)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ CISTF07C º Autor ³                    º Data ³  11/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Calculo do Digito Verificador Codigo de Barras - MOD(11)   º±±
±±º          ³ Pesos (2 a 9)                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CISFT07C()

Local _nCnt   := 0
Local _nPeso  := 2
Local _nJ     := 1
Local _nResto := 0

For _nJ := Len(_cCampo) To 1 Step -1
	_nCnt  := _nCnt + Val(SUBSTR(_cCampo,_nJ,1))*_nPeso
	_nPeso :=_nPeso+1
	if _nPeso > 9
		_nPeso := 2
	endif
Next _nJ

_nResto:=(_ncnt%11)

_nResto:=11 - _nResto

if _nResto == 0 .or. _nResto==1 .or. _nResto > 9
	_nDigbar:='1'
else
	_nDigbar:=Str(_nResto,1)
endif

Return(_nDigbar)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ CISTF07D º Autor ³                    º Data ³  11/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta da Linha Digitavel                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUNCTION CISFT07D()

Local _nI   := 1
Local _nAux := 0
_cLinha     := ""
_nDigito    := 0
_cCampo     := ""

/*
Primeiro Campo
Posicao  Tam       Descricao
01 a 03   03   Codigo de Compensacao do Banco (237)
04 a 04   01   Codigo da Moeda (Real => 9, Outras => 0)
05 a 09   05   Pos 1 a 5 do campo Livre(Pos 1 a 4 Dig Agencia + Pos 1 Dig Carteira)
10 a 10   01   Digito Auto Correcao (DAC) do primeiro campo

Segundo Campo
11 a 20   10   Pos 6 a 15 do campo Livre(Pos 2 Dig Carteira + Pos 1 a 9 Nosso Num)
21 a 21   01   Digito Auto Correcao (DAC) do segundo campo

Terceiro Campo
22 a 31   10   Pos 16 a 25 do campo Livre(Pos 10 a 11 Nosso Num + Pos 1 a 8 Conta Corrente + "0")
32 a 32   01   Digito Auto Correcao (DAC) do terceiro campo

Quarto Campo
33 a 33   01   Digito Verificador do codigo de barras

Quinto Campo
34 a 37   04   Fator de Vencimento
38 a 47   10   Valor
*/

// Calculo do Primeiro Campo
_cCampo := ""
_cCampo := Subs(_cBarra,1,4)+Subs(_cBarra,20,5)
// Calculo do digito do Primeiro Campo
CISFT07E(2)
_cLinha += Subs(_cCampo,1,5)+"."+Subs(_cCampo,6,4)+Alltrim(Str(_nDigito))

// Insere espaco
_cLinha += " "

// Calculo do Segundo Campo
_cCampo := ""
_cCampo := Subs(_cBarra,25,10)
// Calculo do digito do Segundo Campo
CISFT07E(1)
_cLinha += Subs(_cCampo,1,5)+"."+Subs(_cCampo,6,5)+Alltrim(Str(_nDigito))

// Insere espaco
_cLinha += " "

// Calculo do Terceiro Campo
_cCampo := ""
_cCampo := Subs(_cBarra,35,10)
// Calculo do digito do Terceiro Campo
CISFT07E(1)
_cLinha += Subs(_cCampo,1,5)+"."+Subs(_cCampo,6,5)+Alltrim(Str(_nDigito))

// Insere espaco
_cLinha += " "

// Calculo do Quarto Campo
_cCampo := ""
_cCampo := Subs(_cBarra,5,1)
_cLinha += _cCampo

// Insere espaco
_cLinha += " "

// Calculo do Quinto Campo
_cCampo := ""
_cCampo := Subs(_cBarra,6,4)+Subs(_cBarra,10,10)
_cLinha += _cCampo

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ CISTF07E º Autor ³                    º Data ³  11/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Calculo do Digito Verificador da Linha Digitavel - Mod(10) º±±
±±º          ³ Pesos (1 e 2)                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CISFT07E (_nCnt)

Local _nI   := 1
Local _nAux := 0
Local _nInt := 0
_nDigito    := 0

For _nI := 1 to Len(_cCampo)
	
	_nAux := Val(Substr(_cCampo,_nI,1)) * _nCnt
	If _nAux >= 10
		_nAux:= (Val(Substr(Str(_nAux,2),1,1))+Val(Substr(Str(_nAux,2),2,1)))
	Endif
	
	_nCnt += 1
	If _nCnt > 2
		_nCnt := 1
	Endif
	_nDigito += _nAux
	
Next _nI

If (_nDigito%10) > 0
	_nInt    := Int(_nDigito/10) + 1
Else
	_nInt    := Int(_nDigito/10)
Endif

_nInt    := _nInt * 10
_nDigito := _nInt - _nDigito

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  22/02/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Da Nota            ?","","","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Nota         ?","","","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","SEA","",""})
aAdd(aRegs,{cPerg,"03","Serie              ?","","","mv_ch3","C",3,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","SEA","",""})

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
