#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ BLTCDBAR ³ Autor ³ Microsiga             ³ Data ³ 28/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCO REAL                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BLTCDBAR()

LOCAL	aPergs 		:= {} 
PRIVATE lExec    	:= .F.
PRIVATE cIndexName 	:= ''
PRIVATE cIndexKey  	:= ''
PRIVATE cFilter    	:= ''

Tamanho  := "M"
titulo   := "Impressao de Boleto Banco REAL com Codigo de Barras."
cDesc1   := "Este programa destina-se a impressao do Boleto do banco REAL, com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLETO"
lEnd     := .F.
cPerg    :="BLT356"
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

dbSelectArea("SE1")

Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Numero","","","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",6,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Cliente","","","mv_ch7","C",6,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"Ate Cliente","","","mv_ch8","C",6,0,0,"G","","MV_PAR08","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"De Loja","","","mv_ch9","C",2,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Loja","","","mv_cha","C",2,0,0,"G","","MV_PAR10","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Emissao","","","mv_chb","D",8,0,0,"G","","MV_PAR11","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Emissao","","","mv_chc","D",8,0,0,"G","","MV_PAR12","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Vencimento","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Vencimento","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Bordero","","","mv_chf","C",6,0,0,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Bordero","","","mv_chg","C",6,0,0,"G","","MV_PAR16","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1(cPerg,aPergs)

//Pergunte (cPerg,.F.)

//Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)
Wnrel := SetPrint(cString,Wnrel,"",@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

cIndexName	:= Criatrab(Nil,.F.)
cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
///FILTRO
cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And." 
cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
cFilter		+= "E1_PORTADO = '356' .And."
cFilter		+= "E1_CLIENTE>='" + MV_PAR07 + "'.And.E1_CLIENTE<='" + MV_PAR08 + "'.And."
cFilter		+= "E1_LOJA>='" + MV_PAR09 + "'.And.E1_LOJA<='"+MV_PAR10+"'.And."
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par11)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par12)+"'.And."
cFilter		+= 'DTOS(E1_VENCREA)>="'+DTOS(mv_par13)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par14)+'".And.'
cFilter		+= "E1_NUMBOR>='" + MV_PAR15 + "'.And.E1_NUMBOR<='" + MV_PAR16 + "'.And."
cFilter		+= "!(E1_TIPO$MVABATIM).And."
cFilter		+= "E1_PORTADO<>'   '"

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF
dbGoTop()
@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED
	
dbGoTop()
If lExec
	Processa({|lEnd|MontaRel()})
Endif
RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel()
LOCAL oPrint
LOCAL nX := 0
Local cNroDoc :=  " "
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
								SM0->M0_ENDCOB                                     ,; //[2]Endereço
								AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
								"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
								"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
								"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
								Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
								Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
								"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
								Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {"Após o vencimento cobrar multa de R$ "                ,;
								"Mora Diaria de R$ "                                   ,;
								"Sujeito a Protesto apos 05 (cinco) dias do vencimento"}

LOCAL nI           := 1
LOCAL aCB_RN_NN    := {}
LOCAL nVlrAbat		:= 0

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

dbGoTop()
ProcRegua(RecCount())
Do While !EOF()
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.)
	
	//Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	
	DbSelectArea("SE1")
	aDadosBanco  := {SA6->A6_COD                        ,; 							// [1]Numero do Banco
                      SA6->A6_NOME      	            	                  ,; 	// [2]Nome do Banco
	                  SUBSTR(SA6->A6_AGENCIA, 1, 4)                        ,; 		// [3]Agência
                      SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-2),; 	// [4]Conta Corrente
                      SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)  ,; 	// [5]Dígito da conta corrente
                      " "                                              		}		// [6]Codigo da Carteira
                      
	_cPessoa := IIF(Len(AllTrim(str(val(SA1->A1_CGC))))>11,"J","F")

	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
		AllTrim(SA1->A1_MUN )                            ,;  			// [4]Cidade
		SA1->A1_EST                                      ,;     		// [5]Estado
		SA1->A1_CEP                                      ,;      	// [6]CEP
		SA1->A1_CGC										          ,;  			// [7]CGC
		_cPESSOA										}       				// [8]PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)            	 ,;   	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
		AllTrim(SA1->A1_MUNC)	                             ,;   	// [4]Cidade
		SA1->A1_ESTC	                                     ,;   	// [5]Estado
		SA1->A1_CEPC                                        ,;   	// [6]CEP
		SA1->A1_CGC												 		 ,;		// [7]CGC
		_cPESSOA										}       				// [8]PESSOA
	Endif
	
	nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

	//Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo. 
	//Abaixo apenas uma sugestao.
	cNroDoc	:= StrZero(	Val(Alltrim(SE1->E1_NUM)+Alltrim(SE1->E1_PARCELA)),8)
	
	//Monta codigo de barras
	aCB_RN_NN    := Ret_cB(Subs(aDadosBanco[1],1,3),"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNroDoc,(E1_VALOR-nVlrAbat),E1_VENCTO,E1_NUMBCO)
	//(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)
	//                         NUMERO DO BANCO      ,MOEDA,AGENCIA, CONTA CORRENTE
	
	aDadosTit	:= {AllTrim(E1_NUM)+AllTrim(E1_PARCELA)		,;  // [1] Número do título
						E1_EMISSAO                          ,;  // [2] Data da emissão do título
						dDataBase                    		,;  // [3] Data da emissão do boleto
						E1_VENCTO                           ,;  // [4] Data do vencimento
						(E1_SALDO - nVlrAbat)               ,;  // [5] Valor do título
						aCB_RN_NN[3]                        ,;  // [6] Nosso número (Ver fórmula para calculo)
						E1_PREFIXO                          ,;  // [7] Prefixo da NF
						E1_TIPO	                           	}   // [8] Tipo do Titulo
	
	If Marked("E1_OK")
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
		nX := nX + 1
	EndIf
	dbSkip()
	IncProc()
	nI := nI + 1
EndDo
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
LOCAL oFont7
LOCAL oFont8
LOCAL oFont9
LOCAL oFont9n
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont13
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont18
LOCAL oFont24
LOCAL nI := 0
LOCAL oBrush                 

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont7  	:= TFont():New("Arial",9,7,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8  	:= TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9  	:= TFont():New("Arial",9,9,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9n  	:= TFont():New("Arial",9,9,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c 	:= TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  	:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12  	:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13  	:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont18  	:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  	:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  	:= TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n 	:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  	:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n 	:= TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n 	:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  	:= TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
oBrush 		:= TBrush():New("",4)

oPrint:StartPage()   // Inicia uma nova página

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow1 := 0

For jj:=0 to 6 Step 1
	oPrint:Line (nRow1+0146+jj,100,nRow1+0146+jj,2300) 
	oPrint:Line (nRow1+0150,503+jj,nRow1+0070, 503+jj)
	oPrint:Line (nRow1+0150,713+jj,nRow1+0070, 713+jj)
Next

oPrint:FillRect({nRow1+0250,1050,nRow1+0350,1900},oBrush)

cBitMap:= "LOGO_REAL.BMP" 
oPrint:SayBitmap(nRow1+065,095,cBitMap,0065,080 )
oPrint:Say  (nRow1+0065,170,"BANCO REAL",oFont13 )	// [2]Nome do Banco
oPrint:Say  (nRow1+0108,170,"ABN AMRO",oFont8 )	// [2]Nome do Banco
oPrint:Say  (nRow1+0075,530,aDadosBanco[1]+"-5",oFont18 )		// [1]Numero do Banco

oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)

oPrint:Say  (nRow1+0150,100 ,"Cedente:",oFont8)
oPrint:Say  (nRow1+0200,100 ,aDadosEmp[1],oFont10)				//Nome + CNPJ

oPrint:Say  (nRow1+0150,1060,"Agência/Código Cedente:",oFont8)
oPrint:Say  (nRow1+0200,1060,"  "+aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (nRow1+0150,1510,"Nro.Documento:",oFont8)
oPrint:Say  (nRow1+0200,1510,"  "+aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0150,1910,"Motivo devolução:"                         	,oFont8)

oPrint:Say  (nRow1+0250,0100 ,"Sacado:",oFont8)
oPrint:Say  (nRow1+0280,0100 ,aDatSacado[1],oFont10)				//Nome
if aDatSacado[8] = "J"                                         
	oPrint:Say  (nRow1+0310,0100,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow1+0310,0100,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf
oPrint:Say  (nRow1+350,0100 ,Substr(aDatSacado[3],1,50)                              ,oFont9n)
oPrint:Say  (nRow1+380,0100 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5]  ,oFont9n) // CEP+Cidade+Estado

oPrint:Say  (nRow1+0250,1060,"Vencimento:",oFont8)
oPrint:Say  (nRow1+0300,1060,"  "+StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4),oFont10)

oPrint:Say  (nRow1+0250,1510,"Valor do Documento:",oFont8)
oPrint:Say  (nRow1+0300,1510,"  R$ "+AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (nRow1+0350,1060,"Espécie Doc. / Nosso Numero:",oFont8)
oPrint:Say  (nRow1+0400,1060,"  DS "+"/"+" "+ StrZero(Val(aDadosTit[6]),7) ,oFont10)
oPrint:Say  (nRow1+0350,1510,"Multa por dia:",oFont8)
oPrint:Say  (nRow1+0400,1510,"  R$ "+AllTrim(Transform(aDadosTit[5]*9/30/100,"@E 99,999.99"))          ,oFont10)

oPrint:Say  (nRow1+0480,0100,"DECLARAMOS TER RECEBIDO ESTE TÍTULO, REFERENTE À PRESTAÇÃO DE SERVIÇOS, PARA ACEITE.",oFont9)
oPrint:Say  (nRow1+0550,0310,"_____ / _____ / _____              __________________________________________",oFont10)

oPrint:Line (nRow1+0250,0100,nRow1+0250,1900 )
oPrint:Line (nRow1+0350,1050,nRow1+0350,1900 )
oPrint:Line (nRow1+0450,0100,nRow1+0450,1900 ) //---

For jj:=0 to 6 Step 1
	oPrint:Line (nRow1+0620+jj, 100,nRow1+0620+jj,2300 )
Next

oPrint:Line (nRow1+0450,1050,nRow1+0150,1050 )
oPrint:Line (nRow1+0450,1500,nRow1+0150,1500 ) //--
oPrint:Line (nRow1+0620,1900,nRow1+0150,1900 )

oPrint:Say  (nRow1+0205,1910,"(  ) Mudou-se"                                	,oFont8)
oPrint:Say  (nRow1+0245,1910,"(  ) Ausente"                                    ,oFont8)
oPrint:Say  (nRow1+0285,1910,"(  ) Não existe nº indicado"                  	,oFont8)
oPrint:Say  (nRow1+0325,1910,"(  ) Recusado"                                	,oFont8)
oPrint:Say  (nRow1+0365,1910,"(  ) Não procurado"                              ,oFont8)
oPrint:Say  (nRow1+0405,1910,"(  ) Endereço insuficiente"                  	,oFont8)
oPrint:Say  (nRow1+0445,1910,"(  ) Desconhecido"                            	,oFont8)
oPrint:Say  (nRow1+0485,1910,"(  ) Falecido"                                   ,oFont8)
oPrint:Say  (nRow1+0525,1910,"(  ) Outros (anotar no verso)"                  	,oFont8)
           

/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := 080

//Pontilhado separador
For nI := 100 to 2280 step 25
	oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+15)
Next nI

For jj:=0 to 6 Step 1
	oPrint:Line (nRow2+0706+jj,100,nRow2+0706+jj,2300)
	oPrint:Line (nRow2+0710,503+jj,nRow2+0630, 503+jj)
	oPrint:Line (nRow2+0710,713+jj,nRow2+0630, 713+jj)
Next	

oPrint:FillRect({nRow2+0710,1800,nRow2+0810,2300},oBrush)
oPrint:FillRect({nRow2+0980,1800,nRow2+1050,2300},oBrush)
oPrint:FillRect({nRow2+1330,1800,nRow2+1400,2300},oBrush)

cBitMap:= "LOGO_REAL.BMP" 
oPrint:SayBitmap(nRow2+0625,095,cBitMap,0065,080 )
oPrint:Say  (nRow2+0600,1810,"Recibo do Sacado",oFont10)
oPrint:Say  (nRow2+0625,170,"BANCO REAL",oFont13 )	// [2]Nome do Banco
oPrint:Say  (nRow2+0668,170,"ABN AMRO",oFont8 )	// [2]Nome do Banco
oPrint:Say  (nRow2+0635,530,aDadosBanco[1]+"-5",oFont18 )	// [1]Numero do Banco
oPrint:Say  (nRow2+0638,740,aCB_RN_NN[2],oFont14n)			//		Linha Digitavel do Codigo de Barras


oPrint:Line (nRow2+0810,100,nRow2+0810,2300 )
oPrint:Line (nRow2+0910,100,nRow2+0910,2300 )
oPrint:Line (nRow2+0980,100,nRow2+0980,2300 )
oPrint:Line (nRow2+1050,100,nRow2+1050,2300 )

oPrint:Line (nRow2+0910,500,nRow2+1050,500)
oPrint:Line (nRow2+0980,750,nRow2+1050,750)
oPrint:Line (nRow2+0910,1000,nRow2+1050,1000)
oPrint:Line (nRow2+0910,1300,nRow2+0980,1300)
oPrint:Line (nRow2+0910,1480,nRow2+1050,1480)

oPrint:Say  (nRow2+0710,100 ,"Local de Pagamento:",oFont8)
oPrint:Say  (nRow2+0745,100 ,"Pagável em qualquer Banco até o vencimento.",oFont10)


oPrint:Say  (nRow2+0710,1810,"Vencimento:"                                     ,oFont8)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1900+(374-(len(cString)*22))
oPrint:Say  (nRow2+0750,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0810,100 ,"Cedente:"                                        ,oFont8)
oPrint:Say  (nRow2+0850,100 ,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0810,1810,"Agência/Código Cedente:",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+iif(RIGHT(aDadosBanco[4],1)="-","","-")+aDadosBanco[5])
nCol := 1890+(374-(len(cString)*22))
oPrint:Say  (nRow2+0850,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0910,100 ,"Data do Documento:"                              ,oFont8)
oPrint:Say  (nRow2+0940,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0910,505 ,"Nro.Documento:"                                  ,oFont8)
oPrint:Say  (nRow2+0940,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0910,1005,"Espécie Doc.:"                                   ,oFont8)
oPrint:Say  (nRow2+0940,1050,"DS"										,oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0910,1305,"Aceite:"                                         ,oFont8)
oPrint:Say  (nRow2+0940,1400,"A"                                             ,oFont10)

oPrint:Say  (nRow2+0910,1485,"Data do Processamento:"                          ,oFont8)
oPrint:Say  (nRow2+0940,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0910,1810,"Nosso Número:"                                   ,oFont8)
cString := StrZero(Val(aDadosTit[6]),7)
nCol := 1890+(374-(len(cString)*22))
oPrint:Say  (nRow2+0940,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0980,100 ,"Uso do Banco:"                                   ,oFont8)

oPrint:Say  (nRow2+0980,505 ,"Carteira:"                                       ,oFont8)
oPrint:Say  (nRow2+1010,555 ,"20"                                  	,oFont10)

oPrint:Say  (nRow2+0980,755 ,"Espécie:"                                        ,oFont8)
oPrint:Say  (nRow2+1010,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow2+0980,1005,"Quantidade:"                                     ,oFont8)
oPrint:Say  (nRow2+0980,1485,"Valor:"                                          ,oFont8)

oPrint:Say  (nRow2+0980,1810,"(=) Valor do Documento:"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1900+(374-(len(cString)*22))
oPrint:Say  (nRow2+1010,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+1050,100 ,"Instruções:",oFont8)                                                                 
oPrint:Say  (nRow2+1100,120 ,"MULTA POR DIA - R$ "+AllTrim(Transform(aDadosTit[5]*9/30/100,"@E 99,999.99")),oFont10)

oPrint:Say  (nRow2+1050,1810,"(+) Outros Acréscimos:"                           ,oFont8)
oPrint:Say  (nRow2+1120,1810,"(-) Desconto / Abatimento:"                       ,oFont8)
oPrint:Say  (nRow2+1190,1810,"(-) Outras Deduções:"                             ,oFont8)
oPrint:Say  (nRow2+1260,1810,"(+) Mora/Multa:"                                  ,oFont8)
oPrint:Say  (nRow2+1330,1810,"(=) Valor Cobrado:"                               ,oFont8)

oPrint:Say  (nRow2+1400,100 ,"Sacado:"                                         ,oFont8)
oPrint:Say  (nRow2+1400,250 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2+1400,1600,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow2+1400,1600,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow2+1435,0250 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow2+1470,0250 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
oPrint:Say  (nRow2+1470,1600,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

oPrint:Say  (nRow2+1535,0100 ,"Sacador/Avalista:"                               	,oFont8)
oPrint:Say  (nRow2+1535,1720 ,"Código de Baixa"									,oFont8)
oPrint:Say  (nRow2+1585,1680,"Autenticação Mecânica"							,oFont8)

oPrint:Line (nRow2+0710,1800,nRow2+1400,1800 ) 
oPrint:Line (nRow2+1120,1800,nRow2+1120,2300 )
oPrint:Line (nRow2+1190,1800,nRow2+1190,2300 )
oPrint:Line (nRow2+1260,1800,nRow2+1260,2300 )
oPrint:Line (nRow2+1330,1800,nRow2+1330,2300 )
oPrint:Line (nRow2+1400,100 ,nRow2+1400,2300 )
For jj:=0 to 6 Step 1
	oPrint:Line (nRow2+1570+jj,100 ,nRow2+1570+jj,2300 )
Next

/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := -80

For nI := 100 to 2280 step 25
	oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+15)
Next nI
                             
For jj := 0 to 6 Step 1
	oPrint:Line (nRow3+1996+jj,100,nRow3+1996+jj,2300)
	oPrint:Line (nRow3+2000,503+jj,nRow3+1920, 503+jj)
	oPrint:Line (nRow3+2000,713+jj,nRow3+1920, 713+jj)
Next	
                       
oPrint:FillRect({nRow3+2000,1800,nRow3+2100,2300},oBrush)
oPrint:FillRect({nRow3+2200,1800,nRow3+2270,2300},oBrush)
oPrint:FillRect({nRow3+2620,1800,nRow3+2690,2300},oBrush)

//oPrint:Say  (nRow3+1934,100,aDadosBanco[2],oFont14 )		// 	[2]Nome do Banco
cBitMap:= "LOGO_REAL.BMP" 
oPrint:SayBitmap(nRow3+1915,095,cBitMap,0065,080 )
oPrint:Say  (nRow3+1915,170,"BANCO REAL",oFont13 )	// [2]Nome do Banco
oPrint:Say  (nRow3+1958,170,"ABN AMRO",oFont8 )	// [2]Nome do Banco
oPrint:Say  (nRow3+1925,530,aDadosBanco[1]+"-5",oFont18 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1934,740,aCB_RN_NN[2],oFont14n)			//		Linha Digitavel do Codigo de Barras
                            
oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento:",oFont8)
oPrint:Say  (nRow3+2045,100 ,"Pagável em qualquer Banco até o vencimento.",oFont10)
           
oPrint:Say  (nRow3+2000,1810,"Vencimento:",oFont8)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1900+(374-(len(cString)*22))
oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2100,100 ,"Cedente:",oFont8)
oPrint:Say  (nRow3+2140,100 ,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+2100,1810,"Agência/Código Cedente:",oFont8)
cString := Alltrim(aDadosBanco[3]+"/"+aDadosBanco[4]+iif(RIGHT(aDadosBanco[4],1)="-","","-")+aDadosBanco[5])
nCol 	 := 1890+(374-(len(cString)*22))
oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)


oPrint:Say  (nRow3+2200,100 ,"Data do Documento:"                              ,oFont8)
oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)


oPrint:Say  (nRow3+2200,505 ,"Nro.Documento:"                                  ,oFont8)
oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1]						,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+2200,1005,"Espécie Doc.:"                                   ,oFont8)
oPrint:Say  (nRow3+2230,1050,"DS"	  									,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+2200,1305,"Aceite:"                                         ,oFont8)
oPrint:Say  (nRow3+2230,1400,"A"                                             ,oFont10)

oPrint:Say  (nRow3+2200,1485,"Data do Processamento:"                          ,oFont8)
oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


oPrint:Say  (nRow3+2200,1810,"Nosso Número:"                                   ,oFont8)
cString := StrZero(Val(aDadosTit[6]),7)
nCol 	 := 1890+(374-(len(cString)*22))
oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)


oPrint:Say  (nRow3+2270,100 ,"Uso do Banco:"                                   ,oFont8)

oPrint:Say  (nRow3+2270,505 ,"Carteira:"                                       ,oFont8)
oPrint:Say  (nRow3+2300,555 ,"20"                                 	,oFont10)

oPrint:Say  (nRow3+2270,755 ,"Espécie:"                                        ,oFont8)
oPrint:Say  (nRow3+2300,805 ,"R$"                                             ,oFont10)

oPrint:Say  (nRow3+2270,1005,"Quantidade:"                                     ,oFont8)
oPrint:Say  (nRow3+2270,1485,"Valor:"                                          ,oFont8)

oPrint:Say  (nRow3+2270,1810,"(=) Valor do Documento:"                          	,oFont8)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1900+(374-(len(cString)*22))
oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2340,100 ,"Instruções:",oFont8)
oPrint:Say  (nRow3+2390,120 ,"MULTA POR DIA - R$ "+AllTrim(Transform(aDadosTit[5]*9/30/100,"@E 99,999.99")),oFont10)

oPrint:Say  (nRow3+2340,1810,"(+) Outros Acréscimos:"                           ,oFont8)
oPrint:Say  (nRow3+2410,1810,"(-) Desconto / Abatimento:"                       ,oFont8)
oPrint:Say  (nRow3+2480,1810,"(-) Outras Deduções:"                             ,oFont8)
oPrint:Say  (nRow3+2550,1810,"(+) Mora/Multa:"                                  ,oFont8)
oPrint:Say  (nRow3+2620,1810,"(=) Valor Cobrado:"                               ,oFont8)

oPrint:Say  (nRow3+2690,100 ,"Sacado:"                                         ,oFont8)
oPrint:Say  (nRow3+2690,250 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3+2690,1600,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
Else
	oPrint:Say  (nRow3+2690,1600,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) 	// CPF
EndIf

oPrint:Say  (nRow3+2725,0250 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow3+2760,0250 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
oPrint:Say  (nRow3+2760,1600,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont10)

oPrint:Say  (nRow3+2815,0100 ,"Sacador/Avalista:"                               ,oFont8)
oPrint:Say  (nRow3+2815,1720 ,"Código de Baixa",oFont8)
oPrint:Say  (nRow3+2860,1680,"Autenticação Mecânica"                        ,oFont8)
oPrint:Say  (nRow3+3020,1800,"Ficha de Compensação"                        ,oFont12)

oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )
For jj:=0 to 6 Step 1
	oPrint:Line (nRow3+2850+jj,100 ,nRow3+2850+jj,2300 )
Next	

MSBAR("INT25",24.6,1.3,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.3,Nil,Nil,"A",.F.)

//oPrint:Line (nRow3+3135,030 ,nRow3+3135,060 ) 
//oPrint:Line (nRow3+3120,035 ,nRow3+3145,035 ) 
//oPrint:Line (nRow3+3135,2330 ,nRow3+3135,2360 )
//oPrint:Line (nRow3+3125,2355 ,nRow3+3145,2355 ) 
For nI := 100 to 2280 step 20
	oPrint:Line(nRow3+3135, nI, nRow3+3135, nI+10)
Next nI

oPrint:EndPage() // Finaliza a página

Return Nil

/*/
'ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)


//***********************************************************************************
Static Function Ret_CB(cBanco,cMd,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto,cNNum)
//***********************************************************************************
LOCAL cValorFinal := strzero(int(nValor*100),10)
LOCAL nDvnn			:= 0
LOCAL nDvcb			:= 0
LOCAL nDv			:= 0
LOCAL cNN			:= ''
LOCAL cRN			:= ''
LOCAL cCB			:= ''
LOCAL cS			:= ''
LOCAL cFator      	:= strzero(dVencto - ctod("07/10/97"),4)
LOCAL cCart			:= "109"

//-----------------------------
// Definicao do NOSSO NUMERO
// ----------------------------
cS    :=  cAgencia + cConta + cCart + cNroDoc
nDvnn := modulo10(cS) // digito verifacador Agencia + Conta + Carteira + Nosso Num
cNN   := StrZero(Val(cNNum),13)
           
_cDC := AllTrim(Str(modulo10(cNN + cAgencia + cConta)))


//----------------------------------
//	 Definicao da LINHA DIGITAVEL 
//----------------------------------
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3		 Campo 4	Campo 5		
//	AAABC.CCCDX		DDDDD.DEFFFY	FFFFF.FFFFZ	 K			HHHHIIIIIIIIII

// 	CAMPO 1:
//	AAA	 		= Codigo do banco na Camara de Compensacao 356
//	  B  		= Codigo da moeda, sempre 9
//	CCCC 		= Agencia
//	  D  		= Primeiro digito na conta corrente
//	  X 		= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
_cBlc1 		:= cBanco + "9" + cAgencia + Substr(cConta,1,1)
_cDgBlc1 	:= AllTrim(Str(modulo10(_cBlc1)))


// 	CAMPO 2:
//	DDDDDD 		= Restante do numero da conta corrente
//  E			= Digito da Cobranca
//  FFF			= Tres primeiros digitos do Nosso Numero
//	  Y 		= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
_cBlc2 		:= Substr(cConta,2,7) + _cDC + Substr(cNN,1,3)
_cDgBlc2 	:= AllTrim(Str(modulo10(_cBlc2)))


// 	CAMPO 3:
//	FFFFFFFFFF 	= Restante do nosso numero 
//	  Z 		= DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
_cBlc3 		:= Substr(cNN,4,10)
_cDgBlc3 	:= AllTrim(Str(modulo10(_cBlc3)))
                                   

// 	CAMPO 4:    
//  K			= Digitao do codigo de barras
K:= cBanco + "9" + cFator + cValorFinal + cAgencia + cConta + _cDC + cNN
_cDg_K := AllTrim(Str(modulo11(K)))


// 	CAMPO 5:
//	HHHH   		= Fator de Vencimento
//	IIIIIIIIII 	= Valor do Titulo
_cBlc4 		:= cFator + cValorFinal
//msgbox(_cBlc4)

cRN := Substr(_cBlc1 + _cDgBlc1,1,5)+"."+Substr(_cBlc1 + _cDgBlc1,6,5) + "   " 
cRN := cRN + Substr(_cBlc2 + _cDgBlc2,1,5) + "." +Substr(_cBlc2 + _cDgBlc2,6,6) + "   "
cRN := cRN + Substr(_cBlc3 + _cDgBlc3,1,5) + "." +Substr(_cBlc3 + _cDgBlc3,6,6) + "   "
cRN := cRN + _cDg_K + "   " + _cBlc4


//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------
cCB		:= cBanco + "9" + _cDg_K + cFator +  cValorFinal + cAgencia + cConta + _cDC + cNN

Return({cCB,cRN,cNN})



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                    	  		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."


		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif

		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next
