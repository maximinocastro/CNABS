/*---------------------------------------------------------------------------------------------------
		Titulo							Impressão Boleto Bancario FACS
		Nome Programa					FACFI50_AP5.prw
		Descricao						Imprime Boletos Bancarios para titulos a receber previamente incluidos em 
										Borderos.
		Autor							Monica Moura - Microsiga Salvador	
		Dt criacao						16/nov/2000
		Revisao							Sergio Silverfox - Microsiga Salvador 14/dez/2000
										Humberto Fernandes - Microsiga Salvador 14/dez/2000
		Cliente							FACS S/C
		Indices especif.			
		Prog. relacionados		        Nenhum
		Observacoes						Este programa está previsto para atender apenas aos bancos com os quais
													o cliente tem  cobranca e CNAB configurados no momento de sua criação:
													BRADESCO, BANDEIRANTES, ITAU.
		Alteracao em : 08/06/01         Inclusao do Banco do Brasil	 
		Alteracao em : 06/07/01			Adaptação para a Sisa do Brasil - Renata Barreto										        
------------------------------------------------------------------------------------------------------*/
// composicao de nosso numero invalida no bradesco 

#include "rwmake.ch"     
#include "topconn.ch"
#IFNDEF WINDOWS
  DEFINE PSAY SAY
#ENDIF
User Function NET67009()    

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,WNREL") 
SetPrvt("ARETURN,NOMEPROG,ALINHA,NLASTKEY7,LEND,TITULO")
SetPrvt("CABEC1,CABEC2,CCANCEL,M_PAG,CPERG")
SetPrvt("NLIN,_cArea,")


cPerg  :="FACS50"
//ValidPerg()

_cNros			:=	''		// ----- Sequencia de Numeros para calculo de digito verificador
_cDV			:=	''		// ----- Digito verificador calculado
_cDvConta		:=	''    // ----- digito Verificador da conta
_cCtaLimpa	    :=	''    // ----- Conta sem pontos e tracos
_cArea			:= 	''		// ----- Area de trabalho
dt					:=	ctod('07/10/1997')  //----- DataBase Definida
fator				:= "1000"//----- Fator Vencto

cString:="SX5"
cDesc1:= OemToAnsi("Este programa tem como objetivo imprimir boleto de ")
cDesc2:= OemToAnsi("acordo com os parametros informados pelo usuario.")
cDesc3:= ""
tamanho:="P"
wnrel:="BOLETO"            //Nome Default do relatorio em Disco
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="BOLETO"
aLinha  := { }
nLastKey := 0
lEnd := .f.
titulo      :="Boleto Bancário"
cabec1      :=""
cabec2      :=""
cCancel := "***** CANCELADO PELO OPERADOR *****"

m_pag := 0  //Variavel que acumula numero da pagina


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif


     RptStatus({|| RodeBoleto() })// Substituido pelo assistente de conversao do AP5 IDE em 16/11/00 ==>         RptStatus({|| Execute(RptDetail) })
       
     Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RptDetail ³ Autor ³ M“nica Moura Bomfim   ³ Data ³ 04.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

// Substituido pelo assistente de conversao do AP5 IDE em 16/11/00 ==> Function RptDetail

Static Function RodeBoleto()


//----- Parametros
//  DO VENCIMENTO      ?,"C",3,0,mv_par01
//  ATE O VENCIMENTO   ?,"C",3,0,mv_par02
//  DO CLIENTE         ?,"C",3,0,mv_par03
//  ATE O CLIENTE      ?,"C",9,0,mv_par04
//  DO BORDERO         ?,"C",9,0,mv_par05
//  ATE O BORDERO      ?,"D",8,0,mv_par06
//  DO TITULO          ?,"D",8,0,mv_par07
//  ATE O TITULO       ?,"N",1,0,mv_par08
pergunte(cPerg,.F.)

_mvpar01 := mv_par01
_mvpar02 := mv_par02
_mvpar03 := mv_par03
_mvpar04 := mv_par04
_mvpar05 := mv_par05
_mvpar06 := mv_par06
_mvpar07 := mv_par07
_mvpar08 := mv_par08
_mvpar09 := mv_par09
_mvpar10 := mv_par10



Private oFont, cCode
nHeight:=15
lBold:= .F.
lUnderLine:= .F.

lPixel:= .T.
lPrint:=.F.

oFont	:= TFont():New( "Arial",,nHeight,,lBold,,,,,lUnderLine )
oFont5	:= TFont():New( "Arial",,5,,.f.,,,,,.f. )
oFont6	:= TFont():New( "Arial",,6,,.f.,,,,,.f. ) 
oFont7	:= TFont():New( "Arial",,7,,.f.,,,,,.f. ) 
oFont8	:= TFont():New( "Arial",,8,,.t.,,,,,.f. )
oFont9	:= TFont():New( "Arial",,9,,.f.,,,,,.f. )
oFont9b	:= TFont():New( "Arial",,9,,.t.,,,,,.f. )
oFont10b:= TFont():New( "Arial",,10,,.t.,,,,,.f.)
oFont10	:= TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont102:= TFont():New( "Arial",,10,,.f.,,,,,.f.)
oFont10i:= TFont():New( "Arial",,10,,.t.,,,,.t.,.f. )
oFont12	:= TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont12i:= TFont():New( "Arial",,12,,.t.,,,,.t.,.f. )
oFont122:= TFont():New( "Arial",,12,,.t.,,,,,.f. )
oFont14	:= TFont():New( "Arial",,14,,.f.,,,,,.f. )
oFont142:= TFont():New( "Arial Narrow",,14,,.T.,,,,,.f. )
oFont152:= TFont():New( "Arial",,15,,.T.,,,,,.f. )
oFont16	:= TFont():New( "Arial Narrow",,16,,.f.,,,,,.f. )
oFont162:= TFont():New( "Arial Narrow",,14,,.T.,,,,,.f. )
oFont18	:= TFont():New( "Arial",,18,,.f.,,,,,.f. )
oFont20	:= TFont():New( "Arial",,20,,.f.,,,,,.f. )
oFont22	:= TFont():New( "Arial",,22,,.f.,,,,,.f. )


t1	 := 6
t15  := 8
t2	 := 10
t3	 := 12
t4	 := 16
t5	 :=	18
t6	 :=	24
t7	 := 36



//----- Nomes de fonte
Cour	:=	"Courier New"


oFt1 := TFont():New( "Arial"  ,,t1 ,,.t.,,,,,.f. )
oFt15:= TFont():New( Cour ,,t15,,.t.,,,,,.f. )
oFt2 := TFont():New( Cour ,,t2 ,,.f.,,,,,.f. )
oFt3 := TFont():New( Cour ,,t3 ,,.f.,,,,,.f. )
oFt4 := TFont():New( Cour ,,t4 ,,.f.,,,,,.f. )
oFt5 := TFont():New( Cour ,,t5 ,,.f.,,,,,.f. )
oFt6 := TFont():New( Cour ,,t6 ,,.f.,,,,,.f. )
oFt7 := TFont():New( Cour ,,t7 ,,.f.,,,,,.f. )
oFt1b:= TFont():New( Cour ,,t1 ,,.t.,,,,,.f. )
oFt2b:= TFont():New( Cour ,,t2 ,,.t.,,,,,.f. )
oFt3b:= TFont():New( Cour ,,t3 ,,.t.,,,,,.f. )
oFt4b:= TFont():New( Cour ,,t4 ,,.t.,,,,,.f. )
oFt5b:= TFont():New( Cour ,,t5 ,,.t.,,,,,.f. )
oFt6b:= TFont():New( Cour ,,t6 ,,.t.,,,,,.f. )
oFt7b:= TFont():New( Cour ,,t7 ,,.t.,,,,,.f. )

oPrn 		:= TMSPrinter():New()

BoletoBrasil()
	        
	
oPrn:Setup() // para configurar impressora
oPrn:Preview()
//oPrn:Print() // descomentar esta linha para imprimir

MS_FLUSH()

Return





Static Function BoletoBrasil()
	//----- Impressao do Boleto Banco do Brasil

  
	pergunte( cperg, .f.) 
	MontaQuery()
   
   
	dbSelectArea("QRY")
	SetRegua(RecCount("QRY"))
	dbGoTop()

	While !EOF()            
	  IncRegua()
    
		//----- Verifica o cancelamento pelo usuario...                             
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif       
	    //----- Busca informacoes para linha digitavel e codigo de barras
    DbSelectArea('SEE')      
    DbSetOrder(1)
    Dbseek( xFilial()+'237'+QRY->EA_AGEDEP+QRY->EA_NUMCON )
    _cFxConv	:=	StrZero(Val(Alltrim(SEE->EE_CODEMP)),8)
    _cAgConv	:= 	Strzero(val(SUBSTR(QRY->EA_AGEDEP,1,4)),4)
    _cCtConv	:= 	Strzero(val(SUBSTR(QRY->EA_NUMCON,1,10)),10)
    _cNossoNum  :=	Alltrim(QRY->E1_NUMBCO)
    _cNumDv		:=	alltrim(QRY->E1_NUMDV)
    _nTotAbat   := 0
    _nSaldo		:= QRY->E1_SALDO
 
     dt:=ctod('07/10/1997')
     vencto:=SubStr(QRY->E1_VENCTO,7,2)+"/"+ SubStr(QRY->E1_VENCTO,5,2)+"/"+SubStr(QRY->E1_VENCTO,1,4) 
     vencto1:= ctod("'"+vencto+"'")    
     fator:= alltrim(str(vencto1 - dt)) 

	dbSelectArea("QRY")
    
    _cCodBar			:=	'237'+'9'+_cNumDv+fator+strzero(ROUND(_nSaldo,2)*100,10)+_cAgConv+'0911'+_cNossoNum+'00589010'
//    _cCodBar			:=	'237'+'9'+_cNumDv+fator+strzero(ROUND(_nSaldo,2)*100,10)+_cAgConv+'0911'+_cNossoNum+_cFxConv+'00589010'    
	_cNros 				:= _cCodBar
	CalcMod11BB()
	_cDVCodBar 		    :=	_cDV
//    _cCodBar			:=	subs(_cCodBar,1,4)+ _cDvCodBar + Subs(_cCodBar,6)		

//	_cLinDig	:=	'237'+'9'+substr(_cCodBar,20,5)+substr(_cCodBar,24,10)+substr(_cCodBar,24,10)
    _cCampo1	:=	'237'+'9'+substr(_cCodBar,20,5) //Subs(_cLinDig,1,9)
    _cCampo2	:=	substr(_cCodBar,25,10) //Subs(_cLindig,10,10)
    _cCampo3	:=	substr(_cCodBar,35,10) //subs(_cLindig,20,10)
                                                                   
    //----- Calcula digitos do campos 1, 2, 3
		_cNros :=		_cCampo1
		CalcMod10()
		_cDvCpo1	:= _cDV
		
		_cNros :=		_cCampo2
		CalcMod10()
		_cDvCpo2	:= _cDV
		
		_cNros :=		_cCampo3
		CalcMod10()
		_cDvCpo3	:= _cDV

		_cLinDig	:=           ' '+subs(_cCampo1,1,5)+'.'+subs(_cCampo1,6,4)+_cDvCpo1+' '
		_cLinDig 	:= _cLinDig     +subs(_cCampo2,1,5)+'.'+subs(_cCampo2,6,5)+_cDvCpo2+' ' 
		_cLinDig 	:= _cLinDig     +subs(_cCampo3,1,5)+'.'+subs(_cCampo3,6,5)+_cDvCpo3+' '
		_cLinDig 	:= _cLinDig     +_cDvCodBar+' '
        _cLinDig 	:= _cLinDig     +alltrim(fator)+strzero(Round(_nSaldo,2)*100,10)

		//----- Monta Variaveis para impressao no Boleto
		_cLocalPagt	:=	"PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO"
     
		_cCedente		:=	Alltrim(SM0->M0_NOMECOM)+'   CGC: '+SUBSTR(SM0->M0_CGC,1,2)+"."+SUBSTR(SM0->M0_CGC,3,3)+"."+SUBSTR(SM0->M0_CGC,6,3)+"/"+SUBSTR(SM0->M0_CGC,9,4)+"-"+SUBSTR(SM0->M0_CGC,13,2)
		_cVencto    :=SubStr(QRY->E1_VENCTO,7,2)+"/"+ SubStr(QRY->E1_VENCTO,5,2)+"/"+SubStr(QRY->E1_VENCTO,1,4)
     
		_cDtDoc     :=SubStr(QRY->E1_EMISSAO,7,2)+"/"+ SubStr(QRY->E1_EMISSAO,5,2)+"/"+SubStr(QRY->E1_EMISSAO,1,4)
		_cDtProc    :=SubStr(QRY->E1_EMISSAO,7,2)+"/"+ SubStr(QRY->E1_EMISSAO,5,2)+"/"+SubStr(QRY->E1_EMISSAO,1,4)
		_cNumdoc		:=	QRY->E1_PREFIXO+'-'+QRY->E1_NUM+'-'+QRY->E1_PARCELA
		_cEspDoc		:=	'01'
		_cAceite		:=	'N'   
		_nTxJuros		:= GetMv("MV_TXPER")
		_nValjur		:= QRY->E1_VALJUR
		_cSacado		:=	alltrim(QRY->A1_NOME)
		_cCGCCedente:=	SUBSTR(SM0->M0_CGC,1,2)+"."+SUBSTR(SM0->M0_CGC,3,3)+"."+SUBSTR(SM0->M0_CGC,6,3)+"/"+SUBSTR(SM0->M0_CGC,9,4)+"-"+SUBSTR(SM0->M0_CGC,13,2)
        _cCartDoc		:=	'09'
        _cEspMoeda	    :=	'R$'
        _cMsg1 := GetMV("MV_MENBOL1")
        _cMsg2 := GetMV("MV_MENBOL2")
        _cMsg3 := GetMV("MV_MENBOL3")
	      
	    _endAluno:=    Alltrim(QRY->A1_END)
        _bairroAluno:= Alltrim(QRY->A1_BAIRRO)
        _munAluno:=    Alltrim(QRY->A1_MUN)
        _estAluno:=    Alltrim(QRY->A1_EST)
        _cepAluno:=    Alltrim(QRY->A1_CEP) 
        _cepAlFormat:="CEP: "+substr(_cepAluno,1,2)+"."+substr(_cepAluno,3,3)+"-"+substr(_cepAluno,6,3)
 
     //-------------- fim calculo digitos dos campos 1,2,3 modulo 10
    cAgencia:=QRY->EA_AGEDEP
    cConta:="058901-2"//SUBSTR(QRY->EA_NUMCON,1,3)+SUBSTR(QRY->EA_NUMCON,5,3)+SUBSTR(QRY->EA_NUMCON,9,1)//56367
    
    // Montagem da cadeia do codigo de barras (sem o DAC)
                //Identificacao do banco+codigo da moeda + valor do titulo +               codigo da agencia+tipo da conta+numero da conta+nosso numero e dv+ campo livre

     cCadeiaCB := '237'+'9'+_cNumDv+fator+strzero(ROUND(_nSaldo,2)*100,14)+_cNossoNum+_cAgConv+_cFxConv+"09"
   
    
    // Cálculo do DAC do cod. de barras

     K:=0 
     J:=4
     FOR I:=1 TO Len(cCadeiaCB)
       if j==1
         j:=9
       endif
       K:=K+val(SUBSTR(cCadeiaCB,I,1))*J
       j:=j-1
     NEXT  

     
     resto:= MOD(K,11)
     DAC5:= 11-RESTO 
    
     cSeqCB := alltrim(QRY->EA_PORTADO)+'9'+alltrim(str(DAC5))+STRZERO(ROUND((QRY->E1_VALOR),2)*100,14)+_cNossoNum+_cAgConv+_cFxConv+"09"


        
     //Formato da representação númerica :
     
     //                 campo1     campo2     campo3     
     //             BBBMAAATTDTCCCCCCCNNDNNNNNNNN00DXVVVVVVVVVVVVVV
    
 
     BBB:= QRY->EA_PORTADO    // Codigo do banco
     M:=   "9"     							  // Codigo da MOEDA 
     AAA:= Substr(_cNossoNum,1,5)	  //Nosso Numero
     
     dig3:=VAL(SUBSTR(AAA,5,1))*2
     if dig3>9
       dig3:=val(SUBSTR(str(dig3,2),1,1))+val(SUBSTR(str(dig3,2),2,1))
     EndIF

     dig5:=VAL(SUBSTR(AAA,3,1))*2
     if dig5>9
       dig5:=val(SUBSTR(str(dig5,2),1,1))+val(SUBSTR(str(dig5,2),2,1))
     EndIF
     
     dig4:=VAL(SUBSTR(AAA,1,1))*2
     if dig4>9
       dig4:=val(SUBSTR(str(dig4,2),1,1))+val(SUBSTR(str(dig4,2),2,1))
     EndIF

     dig7:=VAL(SUBSTR(BBB,3,1))*2
     if dig7>9
       dig7:=val(SUBSTR(str(dig7,2),1,1))+val(SUBSTR(str(dig7,2),2,1))
     EndIF
   
     dig9:=VAL(SUBSTR(BBB,1,1))*2
     if dig9>9
       dig9:=val(SUBSTR(str(dig9,1),1,1))+val(SUBSTR(str(dig9,2),2,1))
     EndIF
   
     DACSomaX:= dig9+Val(SubStr(BBB,2,1))+dig7+Val(M)+dig5+Val(SubStr(AAA,2,1))+dig3+dig4
     DACDivX:= MOD(DACSomaX,10)
     DACX:= 10-DACDivX
     
     X:=STR(DACX) //Variável que armazena o DAC que amarra o campo 1   
        
        

     ccccccc:= Substr(_cNossoNum,6,6)+_cAgConv

     // Calculo do DAC da representação Numérica do campo 2
     
     dig2:= VAL(SUBSTR(CCCCCCC,2,1))*2
     if dig2>9
       dig2:=val(SUBSTR(str(dig2,2),1,1))+val(SUBSTR(str(dig2,2),2,1))
     EndIF
     
     dig4:= VAL(SUBSTR(CCCCCCC,4,1))*2
     if dig4 > 9
       dig4:=val(SUBSTR(str(dig4,2),1,1))+val(SUBSTR(str(dig4,2),2,1))
     EndIF
     
     dig6:= VAL(SUBSTR(CCCCCCC,6,1))*2
     if dig6>9
        dig6:=val(SUBSTR(str(dig6,2),1,1))+val(SUBSTR(str(dig6,2),2,1))
     EndIf
    
     dig8:= VAL(SUBSTR(CCCCCCC,8,1))*2
     if dig8>9
        dig8:=val(SUBSTR(str(dig8,2),1,1))+val(SUBSTR(str(dig8,2),2,1))
     EndIf

     dig10:= VAL(SUBSTR(CCCCCCC,10,1))*2
     if dig10>9
        dig10:=val(SUBSTR(str(dig10,2),1,1))+val(SUBSTR(str(dig10,2),2,1))
     EndIf

     DACSomaY:=  Val(SubStr(CCCCCCC,1,1))+dig2+VAL(SubStr(CCCCCCC,3,1))+dig4+Val(SubStr(CCCCCCC,5,1))+dig6+Val(SubStr(CCCCCCC,7,1))+dig8+Val(SubStr(CCCCCCC,9,1))+dig10
     DACDivY:= MOD(DACSomaY,10)
     DACY:= 10-DACDivY
     
     Y:= STR(DACY)  //Variável que armazena o DAC que amarra o campo 2
     
     //Campo3

     NNNNNNN:=_cFxConv+"09"
     
     // Calculo do DAC da representação Numérica do campo 3

     dg2:= VAL(SUBSTR(NNNNNNN,2,1))*2
     if dg2>9
       dg2:=val(SUBSTR(str(dg2,2),1,1))+val(SUBSTR(str(dg2,2),2,1))
     EndIF
     
     dg4:= VAL(SUBSTR(NNNNNNN,4,1))*2
     if dg4 > 9
       dg4:=val(SUBSTR(str(dg4,2),1,1))+val(SUBSTR(str(dg4,2),2,1))
     EndIF
     
     dg6:= VAL(SUBSTR(NNNNNNN,6,1))*2
     if dg6>9
        dg6:=val(SUBSTR(str(dg6,2),1,1))+val(SUBSTR(str(dg6,2),2,1))
     EndIF

     dg8:=VAL(SUBSTR(NNNNNNN,8,1))*2
     if dg8>9
       dg8:=val(SUBSTR(str(dg8,2),1,1))+val(SUBSTR(str(dg8,2),2,1))
     EndIF

     
     DACSomaZ:= VAL(SUBSTR(NNNNNNN,1,1))+dg2+VAL(SUBSTR(NNNNNNN,3,1))+dg4+VAL(SUBSTR(NNNNNNN,5,1))+dg6+VAL(SUBSTR(NNNNNNN,7,1))+dg8
     DACDivZ:= MOD(DACSomaZ,10)
     DACZ:= 10-DACDivZ
     
     Z:= STR(DACZ)
     
   
     // Linha que sera impressa
     nValor:=STRZERO(ROUND((QRY->E1_VALOR),2)*100,14)                                                                                                                                                                                                         
     cLinDig:=" "+BBB+M+SUBSTR(AAA,1,1)+"."+SUBSTR(AAA,2,4)+alltrim(X)+"  "+Substr(alltrim(CCCCCCC),1,5)+"."+Substr(alltrim(CCCCCCC),6,5)+alltrim(Y)+"  "+SUBSTR(NNNNNNN,1,5)+"."+SUBSTR(NNNNNNN,6,3)+"00"+alltrim(Z)+"  "+fator+"  " +alltrim(nValor)     
   

//      Linha que sera passada para montar o codigo de barras
    
     cLinCB:=alltrim(BBB)+alltrim(M)+alltrim(AAA)+alltrim(X)+alltrim(CCCCCCC)+alltrim(Y)+alltrim(NNNNNNN)+"00"+alltrim(Z)+alltrim(nValor)
   
     
   
    // Inicio da impressao do boleto
    // Primeira parte - Recibo do Sacado


    oPrn:StartPage()
     
    cBitMap:="LogoBr.Bmp"
    oPrn:SayBitmap( 035,085,cBitMap,650,070)        //oPrn:SayBitmap( 055,085,cBitMap,650,070)
    oPrn:Box( 060,730,115,731)
    oPrn:Box( 060,950,115,951)
    oPrn:Say( 092, 070, Repli('_',2000),oFont7,100)  
	oPrn:Box( 115, 1590,773,1591)
    oPrn:Say( 183, 070, Repli('_',1000),oFont7,100)  
    oPrn:Say( 250, 070, Repli('_',2000),oFont7,100)  
    oPrn:Box( 275,370,340,371) //300
    oPrn:Box( 275,780,340,781)     
    oPrn:Box( 275,1000,340,1001)     
    oPrn:Box( 275,1180,410,1181)
    oPrn:Say( 320, 070, Repli('_',1800),oFont7,100)  
    oPrn:Box( 345,400,410,401) //370
    oPrn:Box( 345,660,410,661)
    oPrn:Box( 345,800,410,801)
    oPrn:Say( 390, 070, Repli('_',1800),oFont7,100)                          
    oPrn:Say( 470,1590,Repli("_",200),oFont7,100)
    oPrn:Say( 540,1590,Repli("_",200),oFont7,100)
    oPrn:Say( 610,1590,Repli("_",200),oFont7,100)
    oPrn:Say( 680,1590,Repli("_",200),oFont7,100)
    //     renata
    oPrn:Say( 640, 070, Repli('_',370),oFont7,100)  
    //
    oPrn:Say( 753,1590,Repli("_",200),oFont7,100)
    oPrn:Say( 890, 070, Repli('_',2000),oFont7,100)  
    oPrn:Say( 980,000,Repli('-',2000),oFont7,100)
    
     // Segunda parte - Ficha de Caixa

    cBitMap:="LogoBr.Bmp"
    oPrn:SayBitmap( 1060,085,cBitMap,650,070)
    oPrn:Box( 1050,730,1135,731)
    oPrn:Box( 1050,950,1135,951)
    oPrn:Say( 1110, 070, Repli('_',2000),oFont7,100)  
    oPrn:Box( 1131, 1590,1783,1591)
    oPrn:Say( 1203, 070, Repli('_',1000),oFont7,100)  
    oPrn:Say( 1270, 070, Repli('_',2000),oFont7,100)  
    oPrn:Box( 1295,370,1360,371) // 1300
    oPrn:Box( 1295,780,1360,781)     
    oPrn:Box( 1295,1000,1360,1001)     
    oPrn:Box( 1295,1180,1430,1181)
    oPrn:Say( 1340, 070, Repli('_',1800),oFont7,100)  
    oPrn:Box( 1360,400,1430,401)  // 1350
    oPrn:Box( 1360,660,1430,661)
    oPrn:Box( 1360,800,1430,801)
    oPrn:Say( 1410, 070, Repli('_',1800),oFont7,100)                          
    oPrn:Say( 1480,1590,Repli("_",200),oFont7,100)
    oPrn:Say( 1550,1590,Repli("_",200),oFont7,100)
    oPrn:Say( 1620,1590,Repli("_",200),oFont7,100)
    oPrn:Say( 1690,1590,Repli("_",200),oFont7,100)
    oPrn:Say( 1763, 070, Repli('_',2000),oFont7,100)  
    oPrn:Say( 1870, 070, Repli('_',2000),oFont7,100)  
    oPrn:Say( 2100,070, Repli('-',2000),oFont10,100)

    // Terceira parte - Linha digitavel

    cBitMap:="LogoBr.Bmp"
    oPrn:SayBitmap( 2180,085,cBitMap,650,070)
    oPrn:Box( 2190,730,2255,731 )
    oPrn:box( 2190,950,2255,951) 
    oPrn:Say( 2230, 070, Repli('_',2000),oFont7,100)  
    oPrn:Box( 2251, 1590,2900,1591)
    oPrn:Say( 2313, 070, Repli('_',1000),oFont7,100)  
    oPrn:Say( 2390, 070, Repli('_',2000),oFont7,100)  
    oPrn:Box( 2415,390,2485,391)
    oPrn:Box( 2415,820,2485,821)     
    oPrn:Box( 2415,1030,2485,1031)     
    oPrn:Box( 2415,1210,2555,1211)
    oPrn:Say( 2460, 070, Repli('_',1800),oFont7,100)  
    oPrn:Box( 2485,430,2555,431)
    oPrn:Box( 2485,690,2555,691)
    oPrn:Box( 2485,830,2555,831)
    oPrn:Say( 2530, 070, Repli('_',1800),oFont7,100)                          
    oPrn:Say( 2600,1590,Repli("_",200),oFont7,100)
    oPrn:Say( 2675,1590,Repli("_",200),oFont7,100)
    oPrn:Say( 2740,1590,Repli("_",200),oFont7,100)
    oPrn:Say( 2800,1590,Repli("_",200),oFont7,100)
    oPrn:Say( 2883, 070, Repli('_',2000),oFont7,100)  
    oPrn:Say( 2990, 070, Repli('_',2000),oFont7,100)  
      
    
//    ----------TEXTOS
     
    oPrn:Say( 060,1730, "RECIBO DO SACADO",oFt4b,100)
    oPrn:Say( 040,740, "237-2",oFt5b,100)
    


    oPrn:Say( 118,100,"Local de Pagamento",oFont7,100)
    oPrn:Say( 118,1600,"  Vencimento",oFont7,100)
    oPrn:Say( 160,100,_cLocalPagt,oFt2b,100)
    oPrn:Say( 160,1900,_cVencto,oFt2b,100)


     
    oPrn:Say( 208,100,"Cedente",oFont7,100)
    oPrn:Say( 208,1600,"  Agencia/Codigo Cedente",oFont7,100)
    oPrn:Say( 235,100,_cCedente,oFt2b,100)
    
    oPrn:Say( 235,1900,_cAgConv+"-2/0058901-2",oFt2b,100)
     
     
    oPrn:Say( 275,100,"Data do Documento",oFont7,100)
    oPrn:Say( 275,380," Número Documento",oFont7,100)
    oPrn:Say( 275,790," Espécie Doc.",oFont7,100)
    oPrn:Say( 275,1010,"      Aceite",oFont7,100)
    oPrn:Say( 275,1190," Data de processamento",oFont7,100)
    oPrn:Say( 275,1590,"  Cart/Nosso Número",oFont7,100)            
    oPrn:Say( 310,115,_cDtDoc,oFt2b,100)
    oPrn:Say( 310,400,_cNumDoc,oFt2b,100) 
    oPrn:Say( 310,880,_cEspDoc,oFt2b,100)
    oPrn:Say( 310,1090,_cAceite,oFt2b,100)
    oPrn:Say( 310,1300,_cDtProc,oFt2b,100)  
    oPrn:Say( 310,1900,"09/11/"+_cNossoNum+'-'+_cNumDv,oFt2b,100) 

    
    oPrn:Say( 345,100,"C.G.C. do Cedente",oFont7,100) 
    oPrn:Say( 345,410," Carteira",oFont7,100)
    oPrn:Say( 345,670," Espécie",oFont7,100)
    oPrn:Say( 345,810," Quantidade",oFont7,100)
    oPrn:Say( 345,1200," (x)Valor",oFont7,100)        
    oPrn:Say( 345,1590,"   (=)Valor do Documento",oFont7,100) 
    oPrn:Say( 370,100,_cCGCCedente,oFont8,100)
    oPrn:Say( 370,520,_cCartDoc,oFt2b,100)
    oPrn:Say( 370,720,_cEspMoeda,oFt2b,100)     
    oPrn:Say( 370,1900,Trans(_nSaldo, "@E@R 999,999,999.99"),oFt2b,100) //PICTURE "@E@R 999,999,999.99"
 
    oPrn:Say( 415,100,"Instruções",oFont7,100)        
    oPrn:Say( 415,1600,"  (-) Desconto /Abatimento",oFont7,100)
    oPrn:Say( 495,1600,"  (-) Outras Deduções",oFont7,100)

    oPrn:Say( 460,150,"Juros de 8.5% ao mes ",oFt2b,100)
    //oPrn:Say( 460,350,Trans(_nValJur,"@E@R 999,999,999.99"),oFt2b,100)
    oPrn:Say( 490,150,_cMsg1,oFt2b,100)
    oPrn:Say( 520,150,_cMsg2,oFt2b,100)
	oPrn:Say( 550,150,_cMsg3,oFt2b,100)    
    
    oPrn:Say( 720,200,_endAluno,oFt3b,100)
    oPrn:Say( 755,200,_bairroAluno,oFt3b,100)
    oPrn:Say( 790,200,_munAluno+"-"+_estAluno,oFt3b,100) 
    oPrn:Say( 825,200,_cepAlFormat,oFt3b,100)   
    oPrn:Say( 570,1600,"  (+) Mora/Multa",oFont7,100)
    oPrn:Say( 630,1600,"  (+) Outros Acréscimos",oFont7,100)
    oPrn:Say( 710,1600," (=) Valor Cobrado",oFont7,100)     

    oPrn:Say( 665,100,"Sacado",oFont7,100)
    oPrn:Say( 690,200,_cSacado,oFt3b,100)
    oPrn:Say( 880,100,"Sacador/Avalista",oFont7,100)     
    oPrn:Say( 880,1700,"Código de Baixa",oFont7,100) 
          
    oPrn:Say( 920,1590,"Autenticação Mecânica",oFont7,100)
     
    oPrn:Say( 1010,080,"CORTE AQUI",oFont5,100)  
    
     // Segunda parte - Ficha de Caixa

    cBitMap:="LogoBr.Bmp"
    oPrn:SayBitmap( 1060,085,cBitMap,650,070)
    oPrn:Say( 1080,1800, "FICHA DE CAIXA",oFt4b,100)
    oPrn:Say( 1060,740, "237-2",oFt5b,100)

    oPrn:Say( 1130,100,"Local de Pagamento",oFont7,100)
    oPrn:Say( 1130,1590,"  Vencimento",oFont7,100)
    oPrn:Say( 1170,100,_cLocalPagt,oFt2b,100)
    oPrn:Say( 1170,1900,_cVencto,oFt2b,100)
     
    oPrn:Say( 1228,100,"Cedente",oFont7,100)
    oPrn:Say( 1228,1590,"  Agencia/Codigo Cedente",oFont7,100)
    oPrn:Say( 1250,100,_cCedente,oFt2b,100)
    oPrn:Say( 1250,1900,_cAgConv+"-2/0058901-2",oFt2b,100)
         
    oPrn:Say( 1295,100,"Data do Documento",oFont7,100)
    oPrn:Say( 1295,380," Número Documento",oFont7,100)
    oPrn:Say( 1295,790," Espécie Doc.",oFont7,100)
    oPrn:Say( 1295,1010,"      Aceite",oFont7,100)
    oPrn:Say( 1295,1190," Data de processamento",oFont7,100)
    oPrn:Say( 1295,1590,"  Cart/Nosso Número",oFont8,100)            
    oPrn:Say( 1320,115,_cDtDoc,oFt2b,100)
    oPrn:Say( 1320,400,_cNumDoc,oFt2b,100) 
    oPrn:Say( 1320,880,_cEspDoc,oFt2b,100)
    oPrn:Say( 1320,1090,_cAceite,oFt2b,100)
    oPrn:Say( 1320,1300,_cDtProc,oFt2b,100)  
    oPrn:Say( 1320,1900,"09/11/"+_cNossoNum+'-'+_cNumDv,oFt2b,100) 
     
    oPrn:Say( 1365,100,"C.G.C. do Cedente",oFont7,100) 
    oPrn:Say( 1365,410," Carteira",oFont7,100)
    oPrn:Say( 1365,670," Espécie",oFont7,100)
    oPrn:Say( 1365,810," Quantidade",oFont7,100)
    oPrn:Say( 1365,1200," (x)Valor",oFont7,100)        
    oPrn:Say( 1365,1590,"   (=)Valor do Documento",oFont7,100) 
    oPrn:Say( 1390,100,_cCGCCedente,oFont8,100)
    oPrn:Say( 1390,520,_cCartDoc,oFt2b,100)
    oPrn:Say( 1390,720,_cEspMoeda,oFt2b,100)     
    oPrn:Say( 1390,1900,Trans(_nSaldo, "@E@R 999,999,999.99"),oFt2b,100) //PICTURE "@E@R 999,999,999.99"
 
    oPrn:Say( 1435,100,"Instruções",oFont7,100)        
    oPrn:Say( 1435,1600,"  (-) Desconto /Abatimento",oFont7,100)
    oPrn:Say( 1505,1600,"  (-) Outras Deduções",oFont7,100)
    oPrn:Say( 1510,150,"Juros de 8.5 ao mes ",oFt2b,100)
    //oPrn:Say( 1510,350,Trans(_nValJur,"@E@R 999,999,999.99"),oFt2b,100)
    oPrn:Say( 1540,150,_cMsg1,oFt2b,100)
    oPrn:Say( 1570,150,_cMsg2,oFt2b,100)
    oPrn:Say( 1600,150,_cMsg3,oFt2b,100)
    oPrn:Say( 1590,1600,"  (+) Mora/Multa",oFont7,100)
    oPrn:Say( 1650,1600,"  (+) Outros Acréscimos",oFont7,100)
    oPrn:Say( 1720,1600," (=) Valor Cobrado",oFont7,100)     

    oPrn:Say( 1783,100,"Sacado",oFont7,100)
    oPrn:Say( 1800,250,_cSacado,oFt3b,100)
    oPrn:Say( 1860,100,"Sacador/Avalista",oFont7,100)     
    oPrn:Say( 1860,1700,"Código de Baixa",oFont7,100) 
               
    oPrn:Say( 1900,1590,"Autenticação Mecânica",oFont7,100)
     
    oPrn:Say( 2130,080,"CORTE AQUI",oFont5,100)
    
    // Terceira parte - Linha digitavel

    cBitMap:="LogoBr.Bmp"
    oPrn:SayBitmap( 2180,085,cBitMap,650,070)
    oPrn:Say( 2180,740, "237-2",oFt5b,100)
    oPrn:Say( 2200,970,_cLinDig,oFont162,100)

    oPrn:Say( 2255,100,"Local de Pagamento",oFont7,100)
    oPrn:Say( 2255,1610,"  Vencimento",oFont7,100)
    oPrn:Say( 2300,100,_cLocalPagt,oFt2b,100)
    oPrn:Say( 2300,1900,_cVencto,oFt2b,100)
     
    oPrn:Say( 2348,100,"Cedente",oFont7,100)
    oPrn:Say( 2348,1610,"  Agencia/Codigo Cedente",oFont7,100)
    oPrn:Say( 2370,100,_cCedente,oFt2b,100)
    oPrn:Say( 2370,1900,_cAgConv+"-2/0058901-2",oFt2b,100)

    oPrn:Say( 2415,100,"Data do Documento",oFont7,100)
    oPrn:Say( 2415,400," Número Documento",oFont7,100)
    oPrn:Say( 2415,830," Espécie Doc.",oFont7,100)
    oPrn:Say( 2415,1040,"      Aceite",oFont7,100)
    oPrn:Say( 2415,1220," Data de processamento",oFont7,100)
    oPrn:Say( 2415,1610,"  Cart/Nosso Número",oFont8,100)            
    oPrn:Say( 2440,115,_cDtDoc,oFt2b,100)
    oPrn:Say( 2440,400,_cNumDoc,oFt2b,100) 
    oPrn:Say( 2440,880,_cEspDoc,oFt2b,100)
    oPrn:Say( 2440,1090,_cAceite,oFt2b,100)
    oPrn:Say( 2440,1300,_cDtProc,oFt2b,100)  
    oPrn:Say( 2440,1900,"09/11/"+_cNossoNum+'-'+_cNumDv,oFt2b,100) 

              
    oPrn:Say( 2485,100,"C.G.C. do Cedente",oFont7,100) 
    oPrn:Say( 2485,440," Carteira",oFont7,100)
    oPrn:Say( 2485,700," Espécie",oFont7,100)
    oPrn:Say( 2485,840," Quantidade",oFont7,100)
    oPrn:Say( 2485,1220," (x)Valor",oFont7,100)        
    oPrn:Say( 2485,1610,"   (=)Valor do Documento",oFont7,100) 
    oPrn:Say( 2510,100,_cCGCCedente,oFont8,100)
    oPrn:Say( 2510,520,_cCartDoc,oFt2b,100)
    oPrn:Say( 2510,720,_cEspMoeda,oFt2b,100)     
    oPrn:Say( 2510,1900,Trans(_nSaldo, "@E@R 999,999,999.99"),oFt2b,100)    //PICTURE "@E@R 999,999,999.99"
    
    oPrn:Say( 2555,100,"Instruções",oFont7,100)        
    oPrn:Say( 2555,1610,"  (-) Desconto /Abatimento",oFont7,100)
    oPrn:Say( 2625,1610,"  (-) Outras Deduções",oFont7,100)
    oPrn:Say( 2640,150,"Juros de 8.5% ao mes ",oFt2b,100)
    //oPrn:Say( 2640,350,Trans(_nValJur,"@E@R 999,999,999.99"),oFt2b,100)
    oPrn:Say( 2670,150,_cMsg1,oFt2b,100)
    oPrn:Say( 2700,150,_cMsg2,oFt2b,100)
    oPrn:Say( 2730,150,_cMsg3,oFt2b,100)
    oPrn:Say( 2710,1610,"  (+) Mora/Multa",oFont7,100)
    oPrn:Say( 2770,1610,"  (+) Outros Acréscimos",oFont7,100)
    oPrn:Say( 2840,1610," (=) Valor Cobrado",oFont7,100)     
                
    oPrn:Say( 2903,100,"Sacado",oFont7,100)
    oPrn:Say( 2920,250,_cSacado,oFt3b,100)
    oPrn:Say( 2980,100,"Sacador/Avalista",oFont7,100)     
    oPrn:Say( 2980,1700,"Código de Baixa",oFont7,100) 
          
    oPrn:Say( 3020,1590,"Autenticação Mecânica - Ficha de Compensação",oFont7,100)
     
    //MSBAR("INT25",26.5,1.3,_cCodBar,oPrn,,,.t.,0.028,1.3,nil,nil,nil,.f.) //Impressora Laser
    MSBAR("INT25",22.5,1.3,_cCodBar,oPrn,,,.t.,0.028,1.3,nil,nil,nil,.f.)  //Impressora Jato de Tinta
    
    dbSelectArea("QRY")
    DbSkip()
    oPrn:EndPage()            
	EndDo
 
	DbCloseArea()      

Return

/*/
STATIC FUNCTION ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Do Vencimento      ?","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate o Vencimento   ?","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Do Cliente         ?","mv_ch3","C",6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"04","Ate o Cliente      ?","mv_ch4","C",6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","SA1"})
aAdd(aRegs,{cPerg,"05","Do Bordero         ?","mv_ch5","C",6,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Ate o Bordero      ?","mv_ch6","C",6,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Do Titulo          ?","mv_ch7","C",6,0,0,"G","","mv_par07","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Ate o Titulo       ?","mv_ch8","C",6,0,1,"G","","mv_par08","","","","","","","","","","","","","","",""})


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
/*/
STATIC FUNCTION CalcMod10()
  //----- Calcula Digito Verificador usando modulo 10
	//----- Sequencia de Numeros para calculo do digito verificador

	aNros 		:= {}
  _cProdutos:= ''
  _nsoma		:= 0 
	For i := Len(_cNros) to 1 step -1
		AADD(aNros,Subs(_cNros,i,1))
	Next
	For i := 1 to Len(aNros)           
		If !( i%2 ) = 0 
			/*[ Posicao Par na Sequencia ]*/   
			_cProdutos := _cProdutos+alltrim(str(Val(aNros[i])*2	))
		Else                               
			/*[ Posicao Impar na Sequencia ]*/
			_cProdutos := _cProdutos+alltrim(str(Val(aNros[i])*1))
		Endif
	Next
	For i:= 1 to Len(_cProdutos)
		_nSoma := _nSoma+Val(Subs(_cProdutos,i,1))
	Next                 
	_nDV  := 10 - Mod(_nSoma,10) 
	_nDV 	:= IIF( _nDV==10, 0, _nDV )
	_cDv :=	 Alltrim(Str(_nDV))
Return

STATIC FUNCTION CalcMod11()

	aNros 			:= {}
	_nDivisor 	:=	2
  _nSoma			:= 	0 
  _nBaseMod11	:= 	9 // IIF(_mvpar01='237',7,9)
	For i := 1 to Len(_cNros)
		AADD(aNros,Subs(_cNros,i,1))
	Next
	For i := Len(aNros)  to  1  step -1             
		_nSoma := _nSoma+ (   Val(aNros[i]) * _nDivisor   )
		_nDivisor		:= iif( _nDivisor >= _nBaseMod11 , 2 , _nDivisor+1	)  
	Next

	_nDV	:=	11 -( Mod(_nSoma,11) )      
	_nDV 	:= IIF( _nDV==11, 1, _nDV )
	_nDV 	:= IIF( _nDV==10, 1, _nDV )
	_nDV 	:= IIF( _nDV== 1, 1, _nDV )
	_nDV 	:= IIF( _nDV== 0, 1, _nDV )
	
	_cDv	:=		Alltrim(Str(_nDV))



Return


STATIC FUNCTION CalcMod11BB()

    aNros 		:= {}
    _nDivisor 	:=	2
    _nSoma		:= 	0 
    _nBaseMod11	:= 	9 
	For i := 1 to Len(_cNros)
		AADD(aNros,Subs(_cNros,i,1))
	Next
	For i := Len(aNros)  to  1  step -1             
		If i <> 5
		   _nSoma := _nSoma+ (   Val(aNros[i]) * _nDivisor   )
           _nDivisor		:= iif( _nDivisor >= _nBaseMod11 , 2 , _nDivisor+1	)  
	   	Endif   
	Next

	_nDV	:=	11 - Mod(_nSoma,11)
	
	If _nDV ==11
	   _novDV	:= "1"
	  elseif  _nDV ==10
       _novDV 	:= "1"
      elseif _nDV<>10 .and. _nDV<>11
 	   _novDV 	:= alltrim(str(_nDV))
	Endif
	
	_cDv	:= _novDV

Return

STATIC FUNCTION TESTAIMP()
		
    oPrn:StartPage()
    oPrn:Say( 175,245, "BRADESCO",oFont142,100)
     
    oPrn:Say( 200,700,_cLinDig,oFont12,100)
    oPrn:Say( 400,700,"Codigo de Barras "+_cCodBar,oFont12,100)

	//MSBAR("INT25",26.5,1.3,_cCodBar,oPrn,,,.t.,0.028,1.3,nil,nil,nil,.f.) //Impressora Laser
    MSBAR("INT25",22.5,1.3,_cCodBar,oPrn,,,.t.,0.028,1.3,nil,nil,nil,.f.)  //Impressora Jato de Tinta
		
    oPrn:EndPage()
    
RETURN    

Static Function fLimpaConta()
	//----- Retira caracteres estranhos da conta
	//_cConta		:=	SEE->EE_CONTA
	_cCta				:= subs(_cConta,1, Len(alltrim(_cConta))-1 )   //----- Sem o digito verificador
    _cDvConta		:=subs(_cConta, Len(alltrim(_cConta)),1 )				//----- digito Verificador
	_cCtaLimpa	:=	''                                              //----- Conta sem pontos e tracos

	For i  := 1 to Len(_cCta)
		If LetterOrNum(subs(_cCta,i,1))
	  	_cCtaLimpa := _cCtaLimpa +	subs(_cCta,i,1)	       
		Endif
	Next 	

Return


STATIC FUNCTION MSGABAT()
//----- Monta mensagem de Desconto/Abatimento 
	_cArea := Alias()
	//SetPrvt("_nTotAbat,_cTipoAbat,_cRet,")          
	//SetPrvt("_CCLIENTE,_CLOJA,_CPREFIXO,_CNUM,_CPARCELA,_aSE1,")


	_cRet					:= ""
	_cTipoAbat		:= ""
	_nTotAbat     := 0
	fCalcAbat()		//----- Calcula Abatimento

	//----- Caso o titulo tenha abatimentos, monta frase de acordo com o tipo 
	//----- do abatimento (Credito ou Bolsa)
	If _nTotAbat > 0 
		_cRet 	:=		"CONCEDER DESCONTO DE R$"+Alltrim(Str(_nTotAbat,17,2))
	  DbSelectArea('SX5')
		If DbSeek(xFilial()+'83'+_cTipoAbat )
			_cRet	:=		_cRet + " REFERENTE A "+SX5->X5_DESCRI
		Endif
	Endif
	DbSelectArea(_cArea) 
Return( _cRet )
                 

STATIC FUNCTION fCalcAbat()
	//----- CALCULO ABATIMENTO

	DbSelectArea("SE1")                                
	_aSE1 :=	{ Alias(), IndexOrd(), Recno() }

	//----- carga de variaveis p/busca 

	_cCliente 		:= QRY->E1_CLIENTE
	_cLoja				:= QRY->E1_LOJA
	_cPrefixo			:= QRY->E1_PREFIXO
	_cNum					:= QRY->E1_NUM
	_cParcela			:= QRY->E1_PARCELA
	_nTotAbat			:= 0
	_cTipoAbat		:= ""

	DbGoTOP()           
	DbSelectArea("SE1")
	dbSetOrder(1)
	DbSeek( xFilial()+ _cPrefixo+_cNum+_cParcela, .T. )

	While !Eof()  .and.  SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_CLIENTE+SE1->E1_LOJA == ;
								_cPrefixo+_cNum+_cParcela+_cCliente+_cLoja
		If Right(SE1->E1_TIPO,1) = '-' 
			_nTotAbat 	:= _nTotAbat+SE1->E1_SALDO
         
			_cTipoAbat 	:=	iif(len(alltrim(_cTipoAbat))=0,SE1->E1_CLASBEN ,_cTipoAbat)
      
		Endif	 
  	DbSkip()
	End							                                 

	//----- Restaura área original 
	DbSelectarea( _aSE1[1]) 
	DbSetOrder( _aSE1[2])
	DbGoto( _aSE1[3])
	
Return




STATIC FUNCTION MontaQuery()
	//----- Monta Area de Trabalho com Query SQL 
	_cArqSA1:= retsqlname("SA1")
	_cArqSE1:= retsqlname("SE1")         
	_cArqSEA:= retsqlname("SEA")

	cQuery :="SELECT "
	cQuery := cQuery +"E1.E1_PREFIXO,E1.E1_NUM,E1.E1_PARCELA,E1.E1_CLIENTE,E1.E1_LOJA, E1.E1_VENCTO,E1.E1_EMISSAO,E1.E1_NUMBCO,E1.E1_NUMDV, "
	cQuery := cQuery +"E1.E1_SALDO,E1.E1_VALOR,E1.E1_VALJUR,E1.E1_BAIXA, EA.EA_NUMCON,EA.EA_NUMBOR, EA.EA_AGEDEP, EA.EA_PORTADO, EA.EA_NUM,  "
	cQuery := cQuery +"A1.A1_NOME, A1.A1_COD, A1.A1_LOJA, A1_END,A1_BAIRRO, A1_MUN,A1_EST,A1_CEP " 

	cQuery := cQuery + 	"FROM "+ _cArqSE1 +" E1, "
	cQuery := cQuery + 		_cArqSA1  +" A1, "
	cQuery := cQuery + 		_cArqSEA  +" EA  "

	cQuery := cQuery + 	"WHERE E1.E1_CLIENTE >='" + _mvpar03 + "' AND "
	cQuery := cQuery + 		"E1.E1_CLIENTE <='" + _mvpar04 + "' AND "
	cQuery := cQuery + 	    "E1.E1_LOJA >='" + _mvpar09 + "' AND "
	cQuery := cQuery + 		"E1.E1_LOJA <='" + _mvpar10 + "' AND "
	cQuery := cQuery + 		"EA.EA_NUMBOR >='" + _mvpar05 + "' AND  "
	cQuery := cQuery + 		"EA.EA_NUMBOR <='" + _mvpar06 + "' AND   "
	cQuery := cQuery + 		"E1.E1_VENCTO >='" + DtoS(_mvpar01) + "' AND "
	cQuery := cQuery + 		"E1.E1_VENCTO <='" + DtoS(_mvpar02)+ "' AND   "
	cQuery := cQuery + 		"E1.E1_NUM >='" + _mvpar07 + "' AND  "
	cQuery := cQuery + 		"E1.E1_NUM <='" + _mvpar08 + "' AND   "
    cQuery := cQuery + 		"A1.A1_COD = E1.E1_CLIENTE AND "
    cQuery := cQuery + 		"A1.A1_LOJA = E1.E1_LOJA AND "
	cQuery := cQuery + 		"EA.EA_PORTADO ='" + "237" + "' AND "  // 001 = BANDO DO BRASIL
	cQuery := cQuery + 		"LEN(E1.E1_NUMBCO) > 0 AND EA.EA_NUMBOR = E1.E1_NUMBOR  AND EA.EA_NUM = E1.E1_NUM  "
	cQuery := cQuery + 		"AND EA.D_E_L_E_T_ <> '*' "
	cQuery := cQuery + 		"AND A1.D_E_L_E_T_ <> '*' "
	cQuery := cQuery + 		"AND E1.D_E_L_E_T_ <> '*' "	
    cQuery := cQuery + 		"AND EA.EA_NUMBOR = E1.E1_NUMBOR  AND EA.EA_PREFIXO = E1.E1_PREFIXO AND EA.EA_NUM = E1.E1_NUM AND EA.EA_PARCELA = E1.E1_PARCELA AND EA.EA_TIPO = E1.E1_TIPO "
	cQuery := cQuery + 	" ORDER BY E1.E1_NUM "
	
//  Query := cQuery + 		"EA.EA_NUMBOR = E1.E1_NUMBOR  AND EA.EA_PREFIXO = E1.E1_PREFIXO AND EA.EA_NUM = E1.E1_NUM AND EA.EA_PARCELA = E1.E1_PARCELA AND EA.EA_TIPO = E1.E1_TIPO "
//	cQuery := cQuery + 	" ORDER BY A1.A1_NOME+E1.E1_VENCTO"  // Implementado por Humberto 26/12/2000

	TCQUERY cQuery NEW ALIAS "QRY"
  
Return
                                    

STATIC FUNCTION FatorVencto(Vencto)

     //-->> Calculo do Fator de vencimento
     dt:=ctod('07/10/1997')  //-->> Database definida pela FEBRABAN
     vencto:=SubStr(Vencto,7,2)+"/"+ SubStr(Vencto,5,2)+"/"+SubStr(Vencto,1,4) 
     vencto1:= ctod("'"+vencto+"'")    
     fator:= strzero((vencto1 - dt),4) 

RETURN fator
