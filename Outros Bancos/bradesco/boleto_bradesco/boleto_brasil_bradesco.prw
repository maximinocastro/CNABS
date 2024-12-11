/*/
+---------------------------------------------------------------------------+
|  Programa  |  Boleta |Autor  |Balboena - ARM Minas   | Data |  15/10/02   |
+---------------------------------------------------------------------------+
|  Descricao | Emissão da boleta de cobrança com codigo de barras, nosso    |
|            | numero e linha digitavel conforme manual do Banco do Brasil  |
+---------------------------------------------------------------------------+
|  Uso       | Faturamento / Financeiro                                     |
+---------------------------------------------------------------------------+
|     Alterações Sofridas desde a sua Construcao Inicial                    |
+---------------------------------------------------------------------------+
| Programador | Data  |                 Alteracao                           |
+---------------------------------------------------------------------------+
| Sergio      |29/10  |Implementacao do Banco Bradesco no codigo da boleta  |
+---------------------------------------------------------------------------+
+---------------------------------------------------------------------------+
|                            [ Atenção ]                                    |
|Este rdmake foi desenvolvido de modo a ser generico e servir para impressão|
|da boleta de todos os bancos, bastando apenas que inclus-se os calculos que|
|forem espeficios a cada banco. Para isto existem estruturas case de para se|
|tratar o banco em uso no momento.                         Balboena 16.10.02|
+---------------------------------------------------------------------------+
/*/

#include "rwmake.ch"
User Function Boleta_BB()

SetPrvt("DV_NNUM,DV_BARRA,CBARRA,LINEDIG,NFI,NFF")
SetPrvt("SERIE,BANCO,NUMBOLETA,NDIGITO,PEDACO,CHAVE")
SetPrvt("FATORVCTO,B_CAMPO,CHAVE,NCONT,CCAMPO,I")
SetPrvt("NVAL,DEZENA,RESTO,NCONT,CPESO,RESULT")
SetPrvt("ARQ,CGRUPO,PERG")
SetPrvt("TIT,DESC1,DESC2,DESC3,ORDEM")
SetPrvt("TAMANHO,FILTIMP,ARETURN,AINFO,NLASTKEY,CSTRING")
SetPrvt("WNREL,TELA,BANCO,SERIE,NFI,NFF")
SetPrvt("CSAVSCR1,CSAVCUR1,CSAVROW1,CSAVCOL1,CCAMPO,NDIGITO")
SetPrvt("NCONT,XI,NVAL,CPESO,RESTO,APERGUNTAS")
SetPrvt("NXZ,NXY,cgrupo,xrow,Nvia,Nnumero")

// Define Variaveis

// Variaveis da boleta
M->DV_NNUM   := SPACE(1)
M->DV_BARRA  := SPACE(1)
M->cBARRA    := ""
M->LineDig   := ""
M->NumBoleta := ""
M->nDigito   := ""
M->Pedaco    := ""

//Paramentros de Impressao
M->NFi       := Space(6)
M->NFf       := Space(6)
M->Serie     := Space(3)
M->Banco     := Space(3)
M->Ag        := Space(5)
M->CC        := Space(10)

//Cadastro de Clientes
DbSelectArea("SA1")
DbSetOrder(1)

@ 00,00 TO 250,450 DIALOG oDlgX TITLE "Impressão de Boletas de Cobrança"
@ 05,05 TO 120,205 TITLE " Parametros "

@ 20,008 SAY "Prefixo do Título"
@ 35,008 SAY "Título Inicial"
@ 50,008 SAY "Título Final"
@ 65,008 Say "Código do Banco"
@ 80,008 SAY "Agencia"
@ 95,008 SAY "Conta Corrente"

@ 20,100 SAY "Bancos Homologados"
@ 30,100 SAY  "001 - Banco do Brasil - by Microsiga"
@ 37,100 SAY  "237 - Bradesco        - by Microsiga"

//Atenção: Coloque aqui o código dos demais Bancos
//@ 44,100 SAY  "XXX - XXXXXXXXXXXXXXX"
//@ 51,100 SAY  "XXX - XXXXXXXXXXXXXXX"
//@ 58,100 SAY  "XXX - XXXXXXXXXXXXXXX"

@ 20,060 GET M->Serie PICTURE "@!"         VALID !Empty(M->Serie)
@ 35,060 GET M->NFi   PICTURE "@E 999999"  VALID !Empty(M->NFi)
@ 50,060 GET M->NFf   PICTURE "@E 999999"  VALID !Empty(M->NFf)
@ 65,060 GET M->Banco F3 "SA6"             VALID !Empty(M->Banco)
@ 80,060 GET M->Ag
@ 95,060 GET M->CC

@ 100,120 BMPBUTTON TYPE 01 ACTION BoletaOK()
@ 100,160 BMPBUTTON TYPE 02 ACTION Close(oDlgX)

ACTIVATE  DIALOG oDlgX CENTER

Return


Static Function BoletaOK()
Close(oDlgX)

//Titulos dos Campos
oFont1 :=     TFont():New("Arial"      		,09,08,,.F.,,,,,.F.)
//Conteudo dos Campos
oFont2 :=     TFont():New("Arial"      		,09,10,,.F.,,,,,.F.)
//Nome do Banco
oFont3Bold := TFont():New("Arial Black"		,09,16,,.T.,,,,,.F.)
//Dados do Recibo de Entrega
oFont4 := 	  TFont():New("Arial"      		,09,12,,.T.,,,,,.F.)
//Codigo de Compensação do Banco
oFont5 := 	  TFont():New("Arial"      		,09,18,,.T.,,,,,.F.)
//Codigo de Compensação do Banco
oFont6 := 	  TFont():New("Arial"      	    ,09,14,,.T.,,,,,.F.)
//Conteudo dos Campos em Negrito
oFont7 := 	  TFont():New("Arial"           ,09,10,,.T.,,,,,.F.)
//Dados do Cliente
oFont8 := 	  TFont():New("Arial"           ,09,09,,.F.,,,,,.F.)
//Linha Digitavel
oFont9 := 	  TFont():New("Times New Roman" ,09,14,,.T.,,,,,.F.)

oPrn:=TMSPrinter():New()


//Cadastro de Contas a Receber
//Posicionar no titulo Incial do Paramentro
DbSelectArea("SE1")
DbSetOrder(1)
DbGoTop()
DbSeek(xFilial("SE1")+ M->Serie + M->NFi)

If !Found()
	MsgBox("Titulo não Encontrado, verifique os paramentros digitados!!")
	Return
Endif

oprn:setup()

Do While !Eof()
	
	If Val(SE1->E1_NUM) > Val(M->NFf) .or. SE1->E1_PREFIXO != M->Serie
		Exit
	Endif
	
	//Incrementar o Numero da Boleta(1a. Impressão) ou buscar no arquivo(reimpressão)
	M->RegSE1 := Recno()
	
	//Posicionar no Cliente
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbGoTop()
	DbSeek(xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA)
	
	If Empty(SE1->E1_NUMBCO)
		
		DbSelectArea("SX6")
		DbSetOrder(1)
		DbGoTop()
		
		Do Case
			
			//Atenção: Acrescentar aqui os codigos dos demais bancos
			
			Case M->BANCO == "001"
				DbSeek(Space(2) + "MV_SEQBB")   // Banco do Brasil
				M->NumBoleta := AllTrim(SX6->X6_CONTEUD)
				M->NumBoleta := AllTrim(Str(Val(M->NumBoleta)+1))
				
			Case M->BANCO == "237"
				DbSeek(Space(2) + "MV_SEQBRAD") // Bradesco
				M->NumBoleta := AllTrim(SX6->X6_CONTEUD)
				M->NumBoleta := StrZero((Val(M->NumBoleta)+1),11)
			Case M->BANCO == "341"
				DbSeek(Space(2) + "MV_SEQITAU") // ITAU
				M->NumBoleta := AllTrim(SX6->X6_CONTEUD)
				M->NumBoleta := StrZero((Val(M->NumBoleta)+1),11)
				
		EndCase
		
		
		
		//Regrava o SX6 com o ultimo numero utilizado
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := Alltrim(M->NumBoleta)
		DbCommit()
		MsUnlock()
		
	Else
		
		M->NumBoleta := AllTrim(SE1->E1_NUMBCO)
		
	Endif
	
	DbSelectArea("SE1")
	DbGoto(M->RegSE1)
/*	
	//Calcular o DV do N.Numero (1a. Impressão) ou buscar no arquivo(reimpressão)
	If Empty(SE1->E1_DVNBCO)//NUMBCO)
		NNumDV()
		
		//Grava o Numero Bancario no Titulo
		RecLock("SE1",.F.)
		SE1->E1_NUMBCO  := AllTrim(M->NumBoleta)
		SE1->E1_DVNBCO  := M->DV_NNUM  //DV DO NOSSO NUMERO
		DbCommit()
		MsUnlock()
		
	Else
		
		M->DV_NNUM := AllTrim(SE1->E1_DVNBCO)
		
	Endif
*/	
   M->DV_NNUM := 'X'
	oprn:startpage()
	
	//Calculos a serem impressos na boleta e gravados no SE1
	//Atenção: Acrescentar aqui os codigos dos demais bancos
	
	Do Case
		Case M->Banco == "237" //Banco Bradesco
			//Calculo de Juros Diarios
			M->Percentual := 0.1834
			M->Mora_Dia   := ( ( SE1->E1_VALOR * M->Percentual ) / 100 )
			
			RecLock("SE1",.F.)
			SE1->E1_PORCJUR := M->Percentual
			SE1->E1_VALJUR  := M->Mora_Dia
			DbCommit()
			MsUnlock()
	EndCase
	
	//Primeira Parte da Boleta
	Do Case
		
		//Atenção: Acrescentar aqui os codigos dos demais bancos
		
		// Banco do Brasil
		Case M->Banco == "001"
			M->Nome_Bco := "BANCO DO BRASIL"
			M->Cod_Comp := "|001-9|"
			M->Ag_Conta := "XXXX-X / XXXXXXX-X"
			M->Carteira := "17"
			M->Aceite   := "S"
			
			// Bradesco
		Case M->Banco == "237"
			M->Nome_Bco := "BRADESCO"
			M->Cod_Comp := "|237-2|"
			M->Ag_Conta := "XXXX-X / XXXXXXX-X"
			M->Carteira := "009"
			M->Aceite   := "N"
			// Bradesco
		Case M->Banco == "341"
			M->Nome_Bco := "ITAU"
			M->Cod_Comp := "|341-2|"
			M->Ag_Conta := "XXXX-X / XXXXXXX-X"
			M->Carteira := "009"
			M->Aceite   := "N"
	EndCase
	
	oPrn:Say(050,0100,M->Nome_Bco,oFont3Bold,100)
	oprn:say(050,0700,M->Cod_Comp,oFont5,100)
	oPrn:Say(060,1550,"RECIBO DE ENTREGA",oFont3Bold,100)
	
	oPrn:Box(130,0100,0210,1500)
	oPrn:Box(130,1500,0210,2200)
	oprn:box(210,0100,0290,1500)
	oprn:box(210,1500,0390,2200)
	oprn:box(290,0100,0370,0350)
	oprn:box(290,0350,0370,0700)
	oprn:box(290,0700,0370,0850)
	oprn:box(290,0850,0370,1060)
	oprn:box(290,1060,0370,1500)
	oprn:box(290,1500,0370,2200)
	oprn:box(370,0100,0450,0350)
	oprn:box(370,0350,0450,0500)
	oprn:box(370,0500,0450,0650)
	oprn:box(370,0650,0450,1060)
	oprn:box(370,1060,0450,1500)
	oprn:box(370,1500,0450,2200)
	oprn:box(850,0100,1020,2200)
	
	oprn:say(130,0120,"Sacado",oFont1,100)
	oprn:say(130,1520,"Vencimento",oFont1,100)
	oprn:say(160,0120,SA1->A1_NOME,oFont2,100)
	oprn:say(160,2000,DtoC(SE1->E1_VENCTO),oFont7,100)
	oprn:say(210,0120,"Cedente",oFont1,100)
	oprn:say(210,1520,"Agência/Código Cedente",oFont1,100)
	oprn:say(240,0120,"CLIENTE",oFont2,100)
	oprn:say(240,1700,M->Ag_Conta,oFont7,100)
	oprn:say(290,0120,"Dt Documento",oFont1,100)
	oprn:say(290,0370,"Número do Documento",oFont1,100)
	oprn:say(290,0720,"Esp.Doc.",oFont1,100)
	oprn:say(290,0870,"Aceite",oFont1,100)
	oprn:say(290,1080,"Data Processamento",oFont1,100)
	oprn:say(290,1520,"Nosso Número",oFont1,100)
	oprn:say(320,0120,DtoC(SE1->E1_EMISSAO),oFont2,100)
	oprn:say(320,0370,SE1->E1_PREFIXO + "-" + SE1->E1_NUM + "-" +SE1->E1_PARCELA,oFont2,100)
	oprn:say(320,0720,"DM",oFont2,100)
	oprn:say(320,0870,M->Aceite,oFont2,100)
	oprn:say(320,1090,DtoC(SE1->E1_EMISSAO),oFont2,100)
	
	//Coloque aqui os demais bancos
	Do Case
		Case M->Banco == "001" //Banco do Brasil
			oprn:say(320,1700,M->NumBoleta+"-"+M->DV_NNUM,oFont7,100)
		Case M->Banco == "237" //Bradesco
			oprn:say(320,1700,"009/"+M->NumBoleta+"-"+M->DV_NNUM,oFont7,100)
		Case M->Banco == "341" //Itau
			oprn:say(320,1700,"009/"+M->NumBoleta+"-"+M->DV_NNUM,oFont7,100)
	EndCase
	
	oprn:say(370,0120,"Uso do Banco",oFont1,100)
	oprn:say(370,0370,"Carteira",oFont1,100)
	oprn:say(370,0520,"Espécie",oFont1,100)
	oprn:say(370,0670,"Quantidade",oFont1,100)
	oprn:say(370,1090,"Valor",oFont1,100)
	oprn:say(370,1520,"(=) Valor do Documento",oFont1,100)
	oprn:say(400,370,M->Carteira,oFont2,100)
	oprn:say(400,520,"R$",oFont2,100)
	oprn:say(400,1750,Transform(SE1->E1_VALOR,"@E 999,999,999.99"),oFont7,100)
	
	oprn:say(530,0200,"NOME DO RECEBEDOR (legivel)",oFont4,100)
	oprn:say(530,0900,Repl("_",50),oFont4,100)
	oprn:say(630,0200,"ASSINATURA DO RECEBEDOR",oFont4,100)
	oprn:say(630,0900,Repl("_",50),oFont4,100)
	oprn:say(730,0200,"DATA DO RECEBIMENTO",oFont4,100)
	oprn:say(730,0900,Repl("_",50),oFont4,100)
	
	oprn:say(850,0120,"Sacado",oFont1,100)
	oprn:say(0870,0250,SA1->A1_NOME,oFont8,100)
//	If SA1->A1_PESSOA == "J"
//		oprn:say(0870,1500,transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont8,100)
//	ElseIf SA1->A1_PESSOA == "F"
		oprn:say(0870,1500,transform(SA1->A1_CGC,"@R 999.999.999-99"),oFont8,100)
//	Endif
	oprn:say(0910,0250,SA1->A1_ENDCOB+" "+SA1->A1_BAIRROC,oFont8,100)
	oprn:say(0950,0250,SA1->A1_CEPC+" "+SA1->A1_MUNC+SA1->A1_ESTC,oFont8,100)
	oprn:say(0990,0120,"Sacador/Avalista",oFont1,100)
	oprn:say(1010,0010,Repl("-",1800),oFont1,100)
	
	//Segunda Parte da Boleta
	oPrn:Say(001030,0100,M->Nome_Bco,oFont3Bold,100)
	oprn:say(001030,0700,M->Cod_Comp,oFont5,100)
	oPrn:Say(001050,1700,"RECIBO DO SACADO",oFont4,100)
	
	oPrn:Box(001110,0100,1310,1500)
	oPrn:Box(001110,1500,1310,2200)
	oprn:box(001190,0100,1390,1500)
	oprn:box(001190,1500,1390,2200)
	oprn:box(001270,0100,1470,0350)
	oprn:box(001270,0350,1470,0700)
	oprn:box(001270,0700,1470,0850)
	oprn:box(001270,0850,1470,1060)
	oprn:box(001270,1060,1470,1500)
	oprn:box(001270,1500,1470,2200)
	oprn:box(001350,0100,1550,0350)
	oprn:box(001350,0350,1550,0500)
	oprn:box(001350,0500,1550,0650)
	oprn:box(001350,0650,1550,1060)
	oprn:box(001350,1060,1550,1500)
	oprn:box(001350,1500,1550,2200)
	oprn:box(001430,1500,1630,2200)
	oprn:box(001430,0100,1950,1500)
	oprn:box(001510,1500,1710,2200)
	oprn:box(001590,1500,1790,2200)
	oprn:box(001670,1500,1870,2200)
	oprn:box(001750,1500,1950,2200)
	oprn:box(001830,0100,2020,2200)
	
	oprn:say(001110,0120,"Local de Pagamento",oFont1,100)
	oprn:say(001110,1520,"Vencimento",oFont1,100)
	oprn:say(001140,0120,"PAGAVEL EM QUALQUER BANCO ATE A DATA DE VENCIMENTO",oFont2,100)
	oprn:say(001140,2000,DtoC(SE1->E1_VENCTO),oFont7,100)
	oprn:say(001190,0120,"Cedente",oFont1,100)
	oprn:say(001190,1520,"Agência/Código Cedente",oFont1,100)
	oprn:say(001220,0120,"CLIENTE",oFont2,100)
	oprn:say(001220,1700,M->Ag_Conta,oFont7,100)
	
	oprn:say(001270,0120,"Dt Documento",oFont1,100)
	oprn:say(001270,0370,"Número do Documento",oFont1,100)
	oprn:say(001270,0720,"Esp.Doc.",oFont1,100)
	oprn:say(001270,0870,"Aceite",oFont1,100)
	oprn:say(001270,1080,"Data Processamento",oFont1,100)
	oprn:say(001270,1520,"Nosso Número",oFont1,100)
	oprn:say(001300,0120,DtoC(SE1->E1_EMISSAO),oFont2,100)
	oprn:say(001300,0370,SE1->E1_PREFIXO + "-" + SE1->E1_NUM + "-" +SE1->E1_PARCELA,oFont2,100)
	oprn:say(001300,0720,"DM",oFont2,100)
	oprn:say(001300,0870,M->Aceite,oFont2,100)
	oprn:say(001300,1090,DtoC(SE1->E1_EMISSAO),oFont2,100)
	
	//Coloque aqui os demais bancos
	Do Case
		Case M->Banco == "001" //Banco do Brasil
			oprn:say(001300,1700,M->NumBoleta+"-"+M->DV_NNUM,oFont7,100)
		Case M->Banco == "237" //Bradesco
			oprn:say(001300,1700,"009/"+M->NumBoleta+"-"+M->DV_NNUM,oFont7,100)
		Case M->Banco == "341" //Itau
			oprn:say(320,1700,"009/"+M->NumBoleta+"-"+M->DV_NNUM,oFont7,100)
	EndCase
	
	oprn:say(001350,0120,"Uso do Banco",oFont1,100)
	oprn:say(001350,0370,"Carteira",oFont1,100)
	oprn:say(001350,0520,"Espécie",oFont1,100)
	oprn:say(001350,0670,"Quantidade",oFont1,100)
	oprn:say(001350,1090,"Valor",oFont1,100)
	oprn:say(001350,1520,"(=) Valor do Documento",oFont1,100)
	oprn:say(001380,370,M->Carteira,oFont2,100)
	oprn:say(001380,520,"R$",oFont2,100)
	oprn:say(001380,1750,Transform(SE1->E1_VALOR,"@E 999,999,999.99"),oFont7,100)
	oprn:say(001430,0120,"Instruções",oFont1,100)
	oprn:say(001430,1520,"(-) Desconto/Abatimento",oFont1,100)
	oprn:say(001510,1520,"(-) Outras Deduções",oFont1,100)
	oprn:say(001600,1520,"(+) Mora/Multa",oFont1,100)
	oprn:say(001670,1520,"(+) Outros Acréscimos",oFont1,100)
	oprn:say(001750,1520,"(=) Valor Cobrado",oFont1,100)
	
	
	//Atenção: Caso queira imprimir observações na boleta, utilizar as linhas abaixo
	//Atenção: Colocar aqui os codigos dos demais bancos
	Do Case
		Case M->Banco == "237"
			oprn:say(001500,0120,"*** VALORES EXPRESSOS EM REAIS ***",oFont2,100)
			oprn:say(001540,0120,"Após o Vencimento mora dia " + Transform(SE1->E1_ValJur,"@E 999,999,999.99"),oFont2,100)
	EndCase
	
	//If !Empty(SE1->E1_DSCTOBL)
	//	oprn:say(001610,0120,"CONCEDER DESCONTO NO VALOR DE   " + Transform(SE1->E1_DSCTOBL,"@E 9,999,999.99"),oFont2,100)
	//	oprn:say(001650,0120,"SOMENTE ATE A DATA DE VENCIMENTO (" + DtoC(SE1->E1_VENCTO)+")",oFont2,100)
	//Endif
	
	oprn:say(001830,0120,"Sacado",oFont1,100)
	oprn:say(001970,1720,"Autenticação Mecânica",oFont1,100)
	oprn:say(001850,0250,SA1->A1_NOME,oFont8,100)
	
	//If SA1->A1_PESSOA == "J"
//		oprn:say(001850,1500,transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont8,100)
	//ElseIf SA1->A1_PESSOA == "F"
		oprn:say(001850,1500,transform(SA1->A1_CGC,"@R 999.999.999-99"),oFont8,100)
	//Endif
	
	oprn:say(001890,0250,SA1->A1_ENDCOB+" "+SA1->A1_BAIRROC,oFont8,100)
	oprn:say(001930,0250,SA1->A1_CEPC+" "+SA1->A1_MUNC+SA1->A1_ESTC,oFont8,100)
	oprn:say(001980,0120,"Sacador/Avalista",oFont1,100)
	oprn:say(001980,1520,"Cód.Baixa",oFont1,100)
	oprn:say(002030,0010,replicate("-",1800),oFont1,100)
	
	
	//Terceira parte da Boleta
	
	M->FatorVcto := Str( ( SE1->E1_VENCTO - Ctod("07/10/1997") ),4 )
	
	//Montagem do Codigo de Barras da Boleta
	Do Case
		
		//Atenção: Coloque aqui os codigos dos demais bancos
		
		Case M->BANCO == "001" // Banco do Brasil
			
			M->B_Campo := "001"  + "9" + M->FatorVcto
			M->B_Campo := M->B_Campo + StrZero(Int(SE1->E1_VALOR*100),10)
			M->B_Campo := M->B_Campo + M->Numboleta + "XXXX" + "XXXXXXXX" + "17"
			
			//Calculo do Digito do Codigo de Barras
			BarraDV()
			
			//Compor a barra com o Digito verificador
			M->CodBarras := "001"  + "9" + M->DV_BARRA + M->FatorVcto
			M->CodBarras := M->CodBarras + StrZero(Int(SE1->E1_VALOR*100),10)
			M->CodBarras := M->CodBarras + M->Numboleta + "1234" + "12345678" + "17"
			
		Case M->BANCO == "341" // Itau
			
			M->B_Campo := "341"  + "9" + M->FatorVcto
			M->B_Campo := M->B_Campo + StrZero(Int(SE1->E1_VALOR*100),10)
			M->B_Campo := M->B_Campo + M->Numboleta + "1234" + "12345678" + "17"
			
			//Calculo do Digito do Codigo de Barras
			BarraDV()
			
			//Compor a barra com o Digito verificador
			M->CodBarras := "341"  + "9" + M->DV_BARRA + M->FatorVcto
			M->CodBarras := M->CodBarras + StrZero(Int(SE1->E1_VALOR*100),10)
			M->CodBarras := M->CodBarras + M->Numboleta + "1234" + "12345678" + "17"
			
		Case M->BANCO == "237" // Bradesco
			
			M->B_Campo := "237"  + "9" + M->FatorVcto
			M->B_Campo := M->B_Campo + StrZero(Int(SE1->E1_VALOR*100),10)
			M->B_Campo := M->B_Campo + "2047" +"09"+M->Numboleta + "0000016" + "0"
			
			//Calculo do Digito do Codigo de Barras
			BarraDV()
			
			//Compor a barra com o Digito verificador
			M->CodBarras := "237"  + "9" + M->DV_BARRA + M->FatorVcto
			M->CodBarras := M->CodBarras + StrZero(Int(SE1->E1_VALOR*100),10)
			M->CodBarras := M->CodBarras + "2047" +"09"+M->Numboleta + "0000016" + "0"
	EndCase
	
	//Montar a Linha Digitavel da Boleta
	MontaLinha()
	
	//Terceira Parte da Boleta
	oPrn:Say(002080,0100,M->Nome_Bco,oFont3Bold,100)
	oprn:say(002080,0650,M->Cod_Comp,oFont6,100)
	
	//Impressão da Linha Digitavel
	oPrn:Say(002085,0890,M->LineDig,oFont9,100)

	oPrn:Box(002160,0100,2360,1500)
	oPrn:Box(002160,1500,2360,2200)
	oprn:box(002240,0100,2440,1500)
	oprn:box(002240,1500,2440,2200)
	oprn:box(002320,0100,2520,0350)
	oprn:box(002320,0350,2520,0700)
	oprn:box(002320,0700,2520,0850)
	oprn:box(002320,0850,2520,1060)
	oprn:box(002320,1060,2520,1500)
	oprn:box(002320,1500,2520,2200)
	oprn:box(002400,0100,2600,0350)
	oprn:box(002400,0350,2600,0500)
	oprn:box(002400,0500,2600,0650)
	oprn:box(002400,0650,2600,1060)
	oprn:box(002400,1060,2600,1500)
	oprn:box(002400,1500,2600,2200)
	oprn:box(002480,1500,2680,2200)
	oprn:box(002480,0100,3000,1500)
	oprn:box(002560,1500,2760,2200)
	oprn:box(002640,1500,2840,2200)
	oprn:box(002720,1500,2920,2200)
	oprn:box(002800,1500,3000,2200)
	oprn:box(002880,0100,3055,2200)

	oprn:say(002160,0120,"Local de Pagamento",oFont1,100)
	oprn:say(002160,1520,"Vencimento",oFont1,100)
	oprn:say(002190,0120,"PAGAVEL EM QUALQUER BANCO ATE A DATA DE VENCIMENTO",oFont2,100)
	oprn:say(002190,2000,DtoC(SE1->E1_VENCTO),oFont7,100)
	oprn:say(002240,0120,"Cedente",oFont1,100)
	oprn:say(002240,1520,"Agência/Código Cedente",oFont1,100)
	oprn:say(002270,0120,"CLIENTE",oFont2,100)
	oprn:say(002270,1700,M->Ag_Conta,oFont7,100)
	oprn:say(002320,0120,"Dt Documento",oFont1,100)
	oprn:say(002320,0370,"Número do Documento",oFont1,100)
	oprn:say(002320,0720,"Esp.Doc.",oFont1,100)
	oprn:say(002320,0870,"Aceite",oFont1,100)
	oprn:say(002320,1080,"Data Processamento",oFont1,100)
	oprn:say(002320,1520,"Nosso Número",oFont1,100)
	oprn:say(002350,0120,DtoC(SE1->E1_EMISSAO),oFont2,100)
	oprn:say(002350,0370,SE1->E1_PREFIXO + "-" + SE1->E1_NUM + "-" +SE1->E1_PARCELA,oFont2,100)
	oprn:say(002350,0720,"DM",oFont2,100)
	oprn:say(002350,0870,M->Aceite,oFont2,100)
	oprn:say(002350,1090,DtoC(SE1->E1_EMISSAO),oFont2,100)
	
	//Coloque aqui os demais bancos
	Do Case
		Case M->Banco == "001" //Banco do Brasil
			oprn:say(002350,1700,M->NumBoleta + "-" + DV_NNUM,oFont7,100)
		Case M->Banco == "237" //Bradesco
			oprn:say(002350,1700,"009/"+M->NumBoleta + "-" + DV_NNUM,oFont7,100)
	EndCase
	
	
	oprn:say(002400,0120,"Uso do Banco",oFont1,100)
	oprn:say(002400,0370,"Carteira",oFont1,100)
	oprn:say(002400,0520,"Espécie",oFont1,100)
	oprn:say(002400,0670,"Quantidade",oFont1,100)
	oprn:say(002400,1090,"Valor",oFont1,100)
	oprn:say(002400,1520,"(=) Valor do Documento",oFont1,100)
	oprn:say(002430,0370,M->Carteira,oFont2,100)
	oprn:say(002430,0520,"R$",oFont2,100)
	oprn:say(002430,1750,transform(SE1->E1_VALOR,"@E 999,999,999.99"),oFont7,100)
	oprn:say(002480,0120,"Instruções",oFont1,100)
	oprn:say(002480,1520,"(-) Desconto/Abatimento",oFont1,100)
	oprn:say(002560,1520,"(-) Outras Deduções",oFont1,100)
	oprn:say(002640,1520,"(+) Mora/Multa",oFont1,100)
	oprn:say(002720,1520,"(+) Outros Acréscimos",oFont1,100)
	oprn:say(002800,1520,"(=) Valor Cobrado",oFont1,100)
	
	//Atenção: Caso queira imprimir observações na boleta, utilizar as linhas abaixo
	//Atenção: Coloque aqui o codigo dos demais Bancos
	Do Case
		Case M->Banco == "237"
			oprn:say(002540,0120,"*** VALORES EXPRESSOS EM REAIS ***",oFont2,100)
			oprn:say(002580,0120,"Após o Vencimento mora dia " + Transform(SE1->E1_ValJur,"@E 999,999,999.99"),oFont2,100)
	EndCase
	
	//If !Empty(SE1->E1_DSCTOBL)
	//	oprn:say(002660,0120,"CONCEDER DESCONTO NO VALOR DE   " + Transform(SE1->E1_DSCTOBL,"@E 9,999,999.99"),oFont2,100)
	//	oprn:say(002700,0120,"SOMENTE ATE A DATA DE VENCIMENTO (" + DtoC(SE1->E1_VENCTO)+")",oFont2,100)
	//Endif
	
	oprn:say(002880,0120,"Sacado",oFont1,100)
	oprn:say(002900,0250,SA1->A1_NOME,oFont8,100)
	//If SA1->A1_PESSOA == "J"
	//	oprn:say(002900,1500,transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont8,100)
	//ElseIf SA1->A1_PESSOA == "F"
		oprn:say(002900,1500,transform(SA1->A1_CGC,"@R 999.999.999-99"),oFont8,100)
	//Endif
	oprn:say(002940,0250,SA1->A1_ENDCOB+" "+SA1->A1_BAIRROC,oFont8,100)
	oprn:say(002980,0250,SA1->A1_CEPC+" "+SA1->A1_MUNC+SA1->A1_ESTC,oFont8,100)
	oprn:say(003020,0120,"Sacador/Avalista",oFont1,100)
	oprn:say(003020,1520,"Cód.Baixa",oFont1,100)
	oprn:say(003020,1750,"Autenticação Mecânica",oFont1,100)
	oprn:say(003060,1730,"FICHA DE COMPENSAÇÃO",oFont2,100)

	//Impressao do Codigo de Barras
	MSBAR("INT25",20,1.5,M->CodBarras,oprn,.F.,,.T.,0.025,1.3,NIL,NIL,NIL,.F.)
	eject
	DbSkip()
	
	oprn:endpage()
	
EndDo

//Para Obter um preview da impressão, desabilite a linha abaixo
//oprn:PREVIEW()

//oPrn:Print()

MsgBox("Impessão Completa!!")

oprn:end()

Ms_Flush()

Return

//*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
//                              F U N Ç Õ E S                                         *
//*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
//Montagem da Linha Digitavel                                  |
Static Function MontaLinha()
M->LineDig := ""
M->nDigito := ""
M->Pedaco  := ""

Do Case
	
	//Atenção: Acrescentar aqui os codigos dos demais bancos
	
	// Banco do Brasil
	Case M->Banco == "001"
		
		M->LineDig := ""
		M->nDigito := ""
		M->Pedaco  := ""
		
		//Primeiro Campo
		//Codigo do Banco + Moeda + 5 primeiras posições do campo livre do Cod Barras
		M->Pedaco := Substr(M->CodBarras,01,03) + Substr(M->CodBarras,04,01) + Substr(M->CodBarras,20,5)
		DV_LINHA()
		M->LineDig := Substr(M->CodBarras,1,3)+Substr(M->CodBarras,4,1)+Substr(M->CodBarras,20,1)+"."+;
		Substr(M->CodBarras,21,4) + M->nDigito + Space(2)
		
		//Segundo Campo
		M->Pedaco  := Substr(M->CodBarras,25,10)
		DV_LINHA()
		M->LineDig := M->LineDig+Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
		M->nDigito+Space(2)
		
		//Terceiro Campo
		M->Pedaco  := Substr(M->CodBarras,35,10)
		DV_LINHA()
		M->LineDig := M->LineDig + Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
		M->nDigito+Space(2)
		
		//Quarto Campo
		M->LineDig := M->LineDig + DV_BARRA + Space(2)
		
		//Quinto Campo
		M->LineDig  := M->LineDig + M->FatorVcto + StrZero(Int(SE1->E1_Valor*100),10)
	Case M->Banco == "341"
		
		M->LineDig := ""
		M->nDigito := ""
		M->Pedaco  := ""
		
		//Primeiro Campo
		//Codigo do Banco + Moeda + 5 primeiras posições do campo livre do Cod Barras
		M->Pedaco := Substr(M->CodBarras,01,03) + Substr(M->CodBarras,04,01) + Substr(M->CodBarras,20,5)
		DV_LINHA()
		M->LineDig := Substr(M->CodBarras,1,3)+Substr(M->CodBarras,4,1)+Substr(M->CodBarras,20,1)+"."+;
		Substr(M->CodBarras,21,4) + M->nDigito + Space(2)
		
		//Segundo Campo
		M->Pedaco  := Substr(M->CodBarras,25,10)
		DV_LINHA()
		M->LineDig := M->LineDig+Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
		M->nDigito+Space(2)
		
		//Terceiro Campo
		M->Pedaco  := Substr(M->CodBarras,35,10)
		DV_LINHA()
		M->LineDig := M->LineDig + Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
		M->nDigito+Space(2)
		
		//Quarto Campo
		M->LineDig := M->LineDig + DV_BARRA + Space(2)
		
		//Quinto Campo
		M->LineDig  := M->LineDig + M->FatorVcto + StrZero(Int(SE1->E1_Valor*100),10)
		
		// Bradesco
	Case M->Banco == "237"
		
		M->LineDig := ""
		M->nDigito := ""
		M->Pedaco  := ""
		
		//Primeiro Campo
		//Codigo do Banco + Moeda + 5 primeiras posições do campo livre do Cod Barras
		M->Pedaco := Substr(M->CodBarras,01,03) + Substr(M->CodBarras,04,01) + Substr(M->CodBarras,20,5)
		DV_LINHA()
		M->LineDig := Substr(M->CodBarras,1,3)+Substr(M->CodBarras,4,1)+Substr(M->CodBarras,20,1)+"."+;
		Substr(M->CodBarras,21,4) + M->nDigito + Space(2)
		
		//Segundo Campo
		M->Pedaco  := Substr(M->CodBarras,25,10)
		DV_LINHA()
		M->LineDig := M->LineDig+Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
		M->nDigito+Space(2)
		
		//Terceiro Campo
		M->Pedaco  := Substr(M->CodBarras,35,10)
		DV_LINHA()
		M->LineDig := M->LineDig + Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
		M->nDigito+Space(2)
		
		//Quarto Campo
		M->LineDig := M->LineDig + DV_BARRA + Space(2)
		
		//Quinto Campo
		M->LineDig  := M->LineDig + M->FatorVcto + StrZero(Int(SE1->E1_Valor*100),10)
EndCase

Return


//Calculo do Digito da Linha Digitavel
Static Function DV_LINHA()
Do Case
	
	//Atenção: Acrescentar aqui os codigos dos demais bancos
	// Banco do Brasil
	Case M->Banco == "001"
		nCont  := 0
		Peso   := 2
		
		For i := Len(M->Pedaco) to 1 Step -1
			
			If M->Peso == 3
				M->Peso := 1
			Endif
			
			If Val(SUBSTR(M->Pedaco,i,1))*M->Peso >= 10
				nVal  := Val(SUBSTR(M->Pedaco,i,1)) * M->Peso
				nCont := nCont+(Val(SUBSTR(Str(nVal,2),1,1))+Val(SUBSTR(Str(nVal,2),2,1)))
			Else
				nCont:=nCont+(Val(SUBSTR(M->Pedaco,i,1))* M->Peso)
			Endif
			
			M->Peso := M->Peso + 1
		Next
		
		M->Dezena  := Substr(Str(nCont,2),1,1)
		M->Resto   := ( (Val(Dezena)+1) * 10) - nCont
		If M->Resto   == 10
			M->nDigito := "0"
		Else
			M->nDigito := Str(M->Resto,1)
		Endif
		// Bradesco
	Case M->Banco == "237"
		nCont  := 0
		Peso   := 2
		
		For i := Len(M->Pedaco) to 1 Step -1
			
			If M->Peso == 3
				M->Peso := 1
			Endif
			
			If Val(SUBSTR(M->Pedaco,i,1))*M->Peso >= 10
				nVal  := Val(SUBSTR(M->Pedaco,i,1)) * M->Peso
				nCont := nCont+(Val(SUBSTR(Str(nVal,2),1,1))+Val(SUBSTR(Str(nVal,2),2,1)))
			Else
				nCont:=nCont+(Val(SUBSTR(M->Pedaco,i,1))* M->Peso)
			Endif
			
			M->Peso := M->Peso + 1
		Next
		
		M->Dezena  := Substr(Str(nCont,2),1,1)
		M->Resto   := ( (Val(Dezena)+1) * 10) - nCont
		If M->Resto   == 10
			M->nDigito := "0"
		Else
			M->nDigito := Str(M->Resto,1)
		Endif
EndCase
Return


//Calculo do Digito Verificador do Nosso Numero
Static Function NNumDV()
Do Case
	
	//Atenção: Acrescentar aqui os codigos dos demais bancos
	
	// ITAU
	Case M->BANCO == "341"
		M->DV_NNUM := '1'
		// Banco do Brasil
	Case M->BANCO == "001"
		
		M->nCont := 0
		M->cPeso := 9
		
		For i := 11 To 1 Step -1
			M->nCont := M->nCont + (Val(SUBSTR(M->NumBoleta,i,1))) * M->cPeso
			M->cPeso := M->cPeso - 1
			If M->cPeso == 1
				M->cPeso := 9
			Endif
		Next
		M->Resto := ( M->nCont % 11 )
		If M->Resto < 10
			M->DV_NNUM := Str(Resto,1)
		Else
			M->DV_NNUM := "X"
		EndIf
		
		// Bradesco
	Case M->BANCO == "237"
		
		M->nCont   := 0
		M->cPeso   := 2
		M->nBoleta :="09" + M->NumBoleta
		
		For i := 13 To 1 Step -1
			
			M->nCont := M->nCont + (Val(SUBSTR(M->nBoleta,i,1))) * M->cPeso
			
			M->cPeso := M->cPeso + 1
			
			If M->cPeso == 8
				M->cPeso := 2
			Endif
			
		Next
		
		M->Resto := ( M->nCont % 11 )
		
		Do Case
			Case M->Resto == 1
				M->DV_NNUM := "P"
			Case M->Resto == 0
				M->DV_NNUM := "0"
			OtherWise
				M->Resto   := ( 11 - M->Resto )
				M->DV_NNUM := AllTrim(Str(M->Resto))
		EndCase
EndCase
Return

//Calculo do Digito do Codigo de Barras
Static Function BarraDV()

Do Case
	
	//Atenção: Coloque aqui o codigo dos demais bancos
	// Banco do Brasil
	Case M->BANCO == "001"
		
		M->nCont := 0
		M->cPeso := 2
		For i := 43 To 1 Step -1
			M->nCont := M->nCont + ( Val( SUBSTR( M->B_Campo,i,1 )) * M->cPeso )
			M->cPeso := M->cPeso + 1
			If M->cPeso >  9
				M->cPeso := 2
			Endif
		Next
		M->Resto  := ( M->nCont % 11 )
		M->Result := ( 11 - M->Resto )
		Do Case
			Case M->Result == 10 .or. M->Result == 11
				M->DV_BARRA := "1"
			OtherWise
				M->DV_BARRA := Str(M->Result,1)
		EndCase
		
		// Bradesco
	Case M->BANCO == "237"
		
		M->nCont := 0
		M->cPeso := 2
		For i := 43 To 1 Step -1
			M->nCont := M->nCont + ( Val( SUBSTR( M->B_Campo,i,1 )) * M->cPeso )
			M->cPeso := M->cPeso + 1
			If M->cPeso >  9
				M->cPeso := 2
			Endif
		Next
		M->Resto  := ( M->nCont % 11 )
		M->Result := ( 11 - M->Resto )
		Do Case
			Case M->Result == 10 .or. M->Result == 11
				M->DV_BARRA := "1"
			OtherWise
				M->DV_BARRA := Str(M->Result,1)
		EndCase
	Case M->BANCO == "341"
		
		M->nCont := 0
		M->cPeso := 2
		For i := 43 To 1 Step -1
			M->nCont := M->nCont + ( Val( SUBSTR( M->B_Campo,i,1 )) * M->cPeso )
			M->cPeso := M->cPeso + 1
			If M->cPeso >  9
				M->cPeso := 2
			Endif
		Next
		M->Resto  := ( M->nCont % 11 )
		M->Result := ( 11 - M->Resto )
		Do Case
			Case M->Result == 10 .or. M->Result == 11
				M->DV_BARRA := "1"
			OtherWise
				M->DV_BARRA := Str(M->Result,1)
		EndCase
EndCase

Return


/*/Documentação da Função de Código de Barras
//+-----------+------------+-------+---------------------+------+----------+
//| Função    |MSBAR       | Autor | ALEX SANDRO VALARIO | Data |  06/99   |
//|-----------+------------+-------+---------------------+------+----------|
//|Descrição  | Imprime codigo de barras                                   |
//|-----------+------------------------------------------------------------|
//|Parametros | 01 cTypeBar String com o tipo do codigo de barras          |
//|           | "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"                 |
//|           | "INT25","MAT25,"IND25","CODABAR" ,"CODE3_9"                |
//|           | 02 nRow	   Numero da Linha em centimentros                 |
//|           | 03 nCol	   Numero da coluna em centimentros	               |
//|           | 04 cCode	   String com o conteudo do codigo             |
//|           | 05 oPr	   Objeto Printer                                  |
//|           | 06 lcheck   Se calcula o digito de controle                |
//|           | 07 Cor 	   Numero  da Cor, utilize a "common.ch"           |
//|           | 08 lHort	   Se imprime na Horizontal                    |
//|           | 09 nWidth   Numero do Tamanho da barra em centimetros      |
//|           | 10 nHeigth  Numero da Altura da barra em milimetros        |
//|           | 11 lBanner  Se imprime o linha em baixo do codigo          |
//|           | 12 cFont	 String com o tipo de fonte                    |
//|           | 13 cMode	 String com o modo do codigo de barras CODE128 |
//|-----------+------------------------------------------------------------|
//| Uso      | Impressão de etiquetas c¢digo de Barras para HP e Laser     |
//+----------+-------------------------------------------------------------+
//MSBAR("EAN13"  , 10  , 16 ,"123456789012",oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("EAN13"  , 2   , 08 ,"123456789012",oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("EAN8"   , 5   ,  8 ,"1234567"     ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("EAN8"   , 19  ,  1 ,"1234567"     ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("UPCA"   , 15  ,  1 ,"07000002198" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("UPCA"   , 15  ,  6 ,"07000002198" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("EAN13"  , 20  , 13 ,"123456789012",oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("EAN13"  , 16  , 13 ,"123456789012",oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("SUP5"   , 12  ,  1 ,"100441"      ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("SUP5"   , 12  ,  3 ,"100441"      ,oPr,NIL,NIL,.F.,NIL,NIL,NIL,NIL,NIL)
//MSBAR("CODE128",  1  ,  1 ,"123456789011010" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("CODE128",  3  ,  1 ,"12345678901" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,"A")
//MSBAR("CODE128",  5  ,  1 ,"12345678901" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,"B")
//MSBAR("CODE3_9",  7.5,  1 ,"12345678901" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("CODABAR",  8  ,  7 ,"A12-34T"     ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("CODE128", 10  , 11 ,"12345678901" ,oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("CODE3_9", 17  ,  9 ,"123456789012",oPr,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
//MSBAR("INT25"  , 21  ,  3 ,"123456789012",oPr,,,.t.)
//MSBAR("MAT25"  , 23  ,  3 ,"123456789012",oPr,,,.t.)
//MSBAR("IND25"  , 23  , 15 ,"123456789012",oPr,,,.t.)
/*/


//FONT <oFont>
//[ NAME <cName> ] ;
//[ SIZE <nWidth>, <nHeight> ] ;
//[ <from:FROM USER> ] ;
//[ <bold: BOLD> ] ;
//[ <italic: ITALIC> ] ;
//[ <underline: UNDERLINE> ] ;
//[ WEIGHT <nWeight> ] ;
//[ OF <oDevice> ] ;
//[ NESCAPEMENT <nEscapement> ] ;
//<oFont> := TFont():New( <cName>, <nWidth>, <nHeight>, <.from.>,;
//[<.bold.>],<nEscapement>,,<nWeight>, [<.italic.>],;
//[<.underline.>],,,,,, [<oDevice>] )
//Exemplo: oFont8cn:= TFont():New("Courier New",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)


