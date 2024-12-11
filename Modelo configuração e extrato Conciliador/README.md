#Conciliador BackOffice - Arquivos de configuração e extratos bancários na conciliação bancária automática

Tempo aproximado para leitura: 2 minutos
01 ESTRUTURA PARA OS ARQUIVOS 
02 ARQUIVOS DE CONFIGURAÇÃO
03 ARQUIVOS DE EXTRATO
04 ARQUIVOS MODELO


01 ESTRUTURA PARA OS ARQUIVOS 
A estrutura para os arquivos devem seguir algumas regras:

A estrutura de diretórios pode estar em qualquer diretório.
Este será utilizado na configuração do Job de importação automática dos extratos.
Para maiores informações, vide Parâmetros de Bancos - FINA130 na Aba Extrato Conciliação Automática

#Caso a empresa utilize diversos bancos, sugerimos criar uma estrutura para cada banco.

02 ARQUIVOS DE CONFIGURAÇÃO
O arquivo de configuração de leitura dos arquivos de extrato contém as posições a serem lidas para que o extrato possa ser importado para as tabelas do sistema.
Apenas as posições solicitadas deverão serem preenchidas, de acordo com o manual do banco.
Para maiores informações, vide Configuração de Extratos Bancários (CFGX023 - SIGACFG) 


#A configuração e ajustes é de responsabilidade do cliente, uma vez que estas se alternam de cliente para cliente.

03 ARQUIVOS DE EXTRATO
O arquivo de extratos são obtidos junto ao banco da sua conta bancária.
Estes conterão as informações dos movimentos realizados na sua conta bancária e que serão importados para tabelas Cabeçalho Imp.Extrato Bancário (SIF) e Itens Import Extrato Bancário (SIG) e utilizados posteriormente para a conciliação automática

04 ARQUIVOS MODELO
De forma a facilitar o entendimento sobre a configuração do arquivo para leitura do extrato bancário, anexamos um arquivo .ZIP  que contém uma configuração e um arquivo de extratos de um banco fictício.

#LINKS TOTVS CONCILIADOR BACKOFFICE - EXTRATO AUTOMATICO:

https://tdn.totvs.com/pages/releaseview.action?pageId=773509455

https://tdn.totvs.com/pages/releaseview.action?pageId=312158241

https://tdn.totvs.com/pages/releaseview.action?pageId=747320567

https://tdn.totvs.com/pages/releaseview.action?pageId=721003882