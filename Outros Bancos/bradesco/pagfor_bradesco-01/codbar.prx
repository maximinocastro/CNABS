#include "rwmake.ch"

///--------------------------------------------------------------------------\
//| Função: CODBAR				Autor: Flávio Novaes				Data: 19/10/2003 |
//|--------------------------------------------------------------------------|
//| Essa Função foi desenvolvida com base no Manual do Bco. Itaú e no RDMAKE:|
//| CODBARVL - Autor: Vicente Sementilli - Data: 26/02/1997.                 |
//|--------------------------------------------------------------------------|
//| Descrição: Função para Validação de Código de Barras (CB) e Representação|
//|            Numérica do Código de Barras - Linha Digitável (LD).			  |
//|                                                                          |
//|            A LD de Bloquetos possui três Digitos Verificadores (DV) que  |
//|				são consistidos pelo Módulo 10, além do Dígito Verificador    |
//|				Geral (DVG) que é consistido pelo Módulo 11. Essa LD têm 47   |
//|            Dígitos.                                                      |
//|                                                                          |
//|            A LD de Títulos de Concessinárias do Serviço Público e IPTU   |
//|				possui quatro Digitos Verificadores (DV) que são consistidos  |
//|            pelo Módulo 10, além do Digito Verificador Geral (DVG) que    |
//|            também é consistido pelo Módulo 10. Essa LD têm 48 Dígitos.   |
//|                                                                          |
//|            O CB de Bloquetos e de Títulos de Concessionárias do Serviço  |
//|            Público e IPTU possui apenas o Dígito Verificador Geral (DVG) |
//|            sendo que a única diferença é que o CB de Bloquetos é         |
//|            consistido pelo Módulo 11 enquanto que o CB de Títulos de     |
//|            Concessionárias é consistido pelo Módulo 10. Todos os CB´s    |
//|            têm 44 Dígitos.                                               |
//|                                                                          |
//|            Para utilização dessa Função, deve-se criar o campo E2_CODBAR,|
//|            Tipo Caracter, Tamanho 48 e colocar na Validação do Usuário:  |
//|            EXECBLOCK("CODBAR",.T.).                                      |
//|                                                                          |
//|            Utilize também o gatilho com a Função CONVLD() para converter |
//|            a LD em CB.																     |
//\--------------------------------------------------------------------------/

USER FUNCTION CodBar()
SETPRVT("cStr,lRet,cTipo,nConta,nMult,nVal,nDV,cCampo,i,nMod,nDVCalc")

// Retorna .T. se o Campo estiver em Branco.
IF VALTYPE(M->E2_CODBAR) == NIL .OR. EMPTY(M->E2_CODBAR)
	RETURN(.T.)
ENDIF

cStr := LTRIM(RTRIM(M->E2_CODBAR))

// Se o Tamanho do String for 45 ou 46 está errado! Retornará .F.
lRet := IF(LEN(cStr)==45 .OR. LEN(cStr)==46,.F.,.T.)

// Se o Tamanho do String for menor que 44, completa com zeros até 47 dígitos. Isso é
// necessário para Bloquetos que NÂO têm o vencimento e/ou o valor informados na LD.
cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)

// Verifica se a LD é de (B)loquetos ou (C)oncessionárias/IPTU. Se for CB retorna (I)ndefinido.
cTipo := IF(LEN(cStr)==47,"B",IF(LEN(cStr)==48,"C","I"))

// Verifica se todos os dígitos são numérios.
FOR i := LEN(cStr) TO 1 STEP -1
	lRet := IF(SUBSTR(cStr,i,1) $ "0123456789",lRet,.F.)
NEXT

IF LEN(cStr) == 47 .AND. lRet
	// Consiste os três DV´s de Bloquetos pelo Módulo 10.
	nConta  := 1
	WHILE nConta <= 3
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,IF(nConta==1,10,IF(nConta==2,21,32)),1))
		cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,11,22)),IF(nConta==1,9,10))
		FOR i := LEN(cCampo) TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
			nMult := IF(nMult==2,1,2)
		NEXT
		nDVCalc := 10-MOD(nVal,10)
		// Se o DV Calculado for 10 é assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		nConta  := nConta + 1			
	ENDDO
	// Se os DV´s foram consistidos com sucesso (lRet=.T.), converte o número para CB para consistir o DVG. 
  	cStr := IF(lRet,SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10),cStr)
ENDIF

IF LEN(cStr) == 48 .AND. lRet
	// Consiste os quatro DV´s de Títulos de Concessionárias de Serviço Público e IPTU pelo Módulo 10.
	nConta  := 1
	WHILE nConta <= 4
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,IF(nConta==1,12,IF(nConta==2,24,IF(nConta==3,36,48))),1))
		cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,13,IF(nConta==3,25,37))),11)
		FOR i := 11 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
			nMult := IF(nMult==2,1,2)
		NEXT
		nDVCalc := 10-MOD(nVal,10)
		// Se o DV Calculado for 10 é assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		nConta  := nConta + 1			
	ENDDO
	// Se os DV´s foram consistidos com sucesso (lRet=.T.), converte o número para CB para consistir o DVG. 
  	cStr := IF(lRet,SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11),cStr)
ENDIF

IF LEN(cStr) == 44 .AND. lRet
	IF cTipo $ "BI"
		// Consiste o DVG do CB de Bloquetos pelo Módulo 11.
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,5,1))
		cCampo := SUBSTR(cStr,1,4)+SUBSTR(cStr,6,39)
		FOR i := 43 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + nMod
			nMult := IF(nMult==9,2,nMult+1)
		NEXT
		nDVCalc := 11-MOD(nVal,11)
		// Se o DV Calculado for 0,10 ou 11 é assumido 1 (Um).
		nDVCalc := IF(nDVCalc==0 .OR. nDVCalc==10 .OR. nDVCalc==11,1,nDVCalc)		
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
		// Se o Tipo é (I)ndefinido E o DVG NÂO foi consistido com sucesso (lRet=.F.), tentará
		// consistir como CB de Título de Concessionárias/IPTU no IF abaixo.  
	ENDIF
	IF cTipo == "C" .OR. (cTipo == "I" .AND. !lRet)
		// Consiste o DVG do CB de Títulos de Concessionárias pelo Módulo 10.
		lRet   := .T.
		nMult  := 2
		nVal   := 0
		nDV    := VAL(SUBSTR(cStr,4,1))
		cCampo := SUBSTR(cStr,1,3)+SUBSTR(cStr,5,40)
		FOR i := 43 TO 1 STEP -1
			nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
			nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
			nMult := IF(nMult==2,1,2)
		NEXT
		nDVCalc := 10-MOD(nVal,10)
		// Se o DV Calculado for 10 é assumido 0 (Zero).
		nDVCalc := IF(nDVCalc==10,0,nDVCalc)
		lRet    := IF(lRet,(nDVCalc==nDV),.F.)
	ENDIF
ENDIF

IF !lRet
	HELP(" ",1,"ONLYNUM")
ENDIF

RETURN(lRet)