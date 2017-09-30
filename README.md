TODO 
  - Mount remote partition [ DONE ] 
  - Check Local Files      [ DONE ] 
  - Parametrizar script
  - Implementar Verificação de Erros 
  - Mail Notification

HowTo
1 - Definindo as credenciais Credentials:
O script precisa de um arquivo contendo usuário senha domain, é necessário criar esse arquivo e adicionar o path pra esse arquivo no script na variavel CREDENTIAL. 
CREDENTIALS='/dir/to/file/with/credentials'

A Estrutura do arquivo é a seguinte:
username = sambauser
password = sambapass 

2 - Configurando as Váriaveis origem e destino:
DIR_ORIG="/backup/exports"
MNT_DIR='//192.168.0.18/bkp-oracle'

DIR_ORIG é o diretório que vai ter o backup realizado.
MNT_DIR é o diretório qual vai receber o backup de DIR_ORIG

Então é basicamente isso, have a good debug. 

EOF
