===============================================================================================
 Controle de Versões : Legendas 
===============================================================================================

 Legenda para classes de alterações:
 ==== ==============================  
 [N]  Notas                            
 [F]  Novas Funcionalidades            
 [B]  Correção de erros  
 [I]  Melhorias/Alterações              
 ==== ============================== 
 
===============================================================================================

===============================================================================================
  Controle de Versões : Supervisão e Controle de refrigeração.
===============================================================================================
Aplicação Versão 1.1.00      Data Liberação: xx/Jul/2024

> Compatibilidade
  HIscada:  Versão 1.7.02
  Mplserver Versã0 1.1.03


===============================================================================================
  Controle de Versões : Supervisão e Controle de refrigeração.
===============================================================================================
Aplicação Versão 1.2.02      Data Liberação: 17/Set/2024


> Compatibilidade
  HIscada:  Versão 1.7.02
  Mplserver Versã0 1.1.03

> Alteração: 17/Set/2024 - Daniel Bable Franco 

[F] - Adicionado um script para verificar se tem instancias habilitadas e pasar para controlador.
      Foi colocado no OnShow da Tela de Habilita instancias. 
        TELA: 'Viewers.Screens.ScreenGroup_Configuracao.Screen_Habilita_Instancias' 
      SCRIPT: 'Viewers.Scripts.ScriptGroup_Geral.Script_OnShowTelaControlador'
             


===============================================================================================
  Controle de Versões : Supervisão e Controle de refrigeração.
===============================================================================================
Aplicação Versão 1.2.01      Data Liberação: 29/Ago/2024


> Compatibilidade
  HIscada:  Versão 1.7.02
  Mplserver Versã0 1.1.03

> Alteração: 29/Ago/2024 - Daniel Bable Franco 

[I] - Melhoria nos script para verificar quais instancias estão habilitadas.
     SCRIPT: 'Kernel.Scripts.ScriptGroup_Instancias.Script_BeginKernel'
             'Kernel.Scripts.ScriptGroup_DADOS.Script_Coleta' 


===============================================================================================
  Controle de Versões : Supervisão e Controle de refrigeração.
===============================================================================================
Aplicação Versão 1.2.00      Data Liberação: 20/Ago/2024

[N] - Alteração da Versão para 1.2.00
      "Visando continuar utilizando a licença do Hiscada Pro 'L4' o Cliente optou pela retirada
      de 5 instancias, assim as tags passam a ser menor que 600 tag ficando dentro da licança L4. 
      Ficando assim apenas com 15 controladores habilitados."

[N] - No dia 19/08/2024 licença estava com uma LTRIAL e assim o supervisório não estava rodando.
      foi pedido para o cliente atualizar a licença.

[N] - Rodar Histudio e MplServer como adminsitardor.

> Compatibilidade
  HIscada:  Versão 1.7.02
  Mplserver Versã0 1.1.03

> Alteração: 19/Ago/2024 - Daniel Bable Franco 

[F] - Correção dos textos de taxa de comunicação e order by no relatório de taxa. 



> Alteração: 15/Ago/2024 - Daniel Bable Franco 

[F] - Retirado 5 instancias de controladores. 

[F] - Vou desabilitados os objetos de tela de habilitação dos controladores. Do 16 ao 20.
      Tela: "Viewers.Screens.ScreenGroup_Configuracao.Screen_Habilita_Instancias" 

[F] - Desabilitados os alarmes dos controladores 16 a 20. 
      Caminho: "Kernel.Tags.Opc.TagOpcGroup_Alarmes.TagOpc_Alarmes_Temperaturas_Min"
               "Kernel.Tags.Opc.TagOpcGroup_Alarmes.TagOpc_Alarmes_Temperaturas_Max"  
               "Kernel.Tags.Opc.TagOpcGroup_Alarmes.TagOpc_AlarmesProgramacaoHorariaLigar"
               "Kernel.Tags.Opc.TagOpcGroup_Alarmes.TagOpc_AlarmesProgramacaoHorariaDesligar"

[F] - Comentado os dados dos controladores de 16 ao 20 nos scripts. 
      Scripts: "Viewers.Scripts.ScriptGroup_Geral.Script_VisibilidadeHabilitacao"
               "Viewers.Scripts.ScriptGroup_Geral.Script_Visibilidade_cfg_controlador"


[F] - Retirado os textos dos controladores 16 a 20 TextList.
      Caminho: "Globals.GlbTextLists.GlbTextListGroup_Geral.GlbTextList_Qtd_Controlador"



===============================================================================================
  Controle de Versões : Supervisão e Controle de refrigeração.
===============================================================================================
Aplicação Versão 1.1.00      Data Liberação: 25/Jul/2024

[N] - Foi alterado a revisão maior pois foi individualizado o envido de comandos.
 
> Compatibilidade
  HIscada:  Versão 1.7.02
  Mplserver Versã0 1.1.03

> Alteração: 25/Jul/2024 - Daniel Bable Franco 

[F] - Adicionado uma mensagem para o usuário se caso a versão do CLP for incompatível com a versão do supervisório. 
      # Script: 'Viewers.Scripts.ScriptGroup_Notificacoes.Script_VersaoIncompativel'

[F] - Adicioando os alarmes de falha ao ligar e desligar programação horária. 

 

> Alteração: 25/Jul/2024 - Daniel Bable Franco 

[F] - Adicionado uma tela pra mostrar a taxa de comunicação para o administrador. (Apenas para usuário administador). 
[F] - Adicionado um relatório de taxa de comunicação.

> Alteração: 23/Jul/2024 - Daniel Bable Franco 

[I] - Alterada a forma de envio de comando para o controlador. Os comandos foram individualizados.
[I] - Não deixar sair da tela de configuração se tem envio de comando pendente. 


 


===============================================================================================
===============================================================================================
Aplicação Versão 1.0.16      Data Liberação: xx/Jul/2024

> Compatibilidade
   HIscada:  Versão 1.7.02
   Mplserver Versã0 1.1.03

Alteração: 08/Jul/2024 - Daniel Bable Franco 

[B] - Correção da memoria do nome do controlador 12 pois estva com endereço trocado,
      foi alterada de MW[S]3435:30 para  MW[S]3455:30 



===============================================================================================
Aplicação Versão 1.0.15      Data Liberação: 02/Jul/2024

> Compatibilidade
   HIscada:  Versão 1.7.02
   Mplserver Versã0 1.1.03

Alteração: 02/Jul/2024 - Daniel Bable Franco 

[I] - Melhoria nos scripts de abretura de telas. 


===============================================================================================
Aplicação Versão 1.0.14      Data Liberação: 26/Jun/2024

> Compatibilidade
   HIscada:  Versão 1.7.02
   Mplserver Versã0 1.1.03

Alteração: 26/Jun/2024 - Daniel Bable Franco 

[I] - Melhoria no script de habilita instancias para realizar uma consistencia no tag OPC.
     * script: 'Viewers.Scripts.ScriptGroup_Geral.Script_HabilitaInstancias' 


===============================================================================================
Aplicação Versão 1.0.13      Data Liberação: 09/Fev/2024

> Compatibilidade
   HIscada:  Versão 1.7.01
   Mplserver Versã0 1.1.02

Alteração: 05/Fev/2024 - Daniel Bable Franco 

[F] - adicionado uma mensagem para o usuário de "agurde coletando dados do clp"

[I] - Alteração no script de coleta de dados. remodelado
      * foi adicionado no script a parte para inserir um registro no banco

      *  script: 'Kernel.Scripts.ScriptGroup_DADOS.Script_Coleta' 

[I] - Retirado o script que fazia o registro dos dados no banco 

[I] - Alterado a forma de ativar o timer para ajudar na coleta de dados.



===============================================================================================
Aplicação Versão 1.0.12      Data Liberação: 05/Fev/2024

> Compatibilidade
   HIscada:  Versão 1.7.01
   Mplserver Versã0 1.1.02

Alteração: 05/Fev/2024 - Daniel Bable Franco 

 [F] - Alteração no script de coleta de dados do sdcard. 
       Foi feita uma melhoria no script para pode pegar os valos corretos e foi feito um 
       tratamento para pegar o valor real do sdcard. 
      
       script: 'Kernel.Scripts.ScriptGroup_DADOS.Script_Coleta'
 
 [F] -  Retirados os tags opcs de dados reais 


===============================================================================================
Aplicação Versão 1.0.12      Data Liberação: 01/Jan/2024

> Compatibilidade
  HIscada:  Versão 1.7.01
  Mplserver Versã0 1.1.02

Alteração: 01/Fev/2024- Daniel Bable Franco 

 [F] - Alterado o script que popula o banco de dados. 
       Adicionado no script para ele verificar se a data ja esta no banco e fazer um update ou 
       se a data for maior inserir no banco e caso a data for invalida descarta a coleta.
  script: 'Kernel.Scripts.ScriptGroup_DADOS.Script_InserteColeta'



===============================================================================================
Aplicação Versão 1.0.10      Data Liberação: 03/Jul/2023

> Compatibilidade
  HIscada:  Versão 1.7.00
  Mplserver Versã0 1.1.02

Alteração: 03/Jul/2023 - Alvim Alves Junior 
[F] - Foi incluído a leitura do item Intervalo de degelo que antes era somente escrita, para atualizar
      dado no supervisório.
[F] - Incluído um tempo de 500ms nos scripts de abertura de relatório no momento que é escrita a 
      variável string que será utilizada na Query para abertura do relatório após esse tento verifica se o valor 
      atual da variável foi atualizado com o valor do script, caso não atualizou repete tentativa de comparação
      por 03 vezes e se ainda sem sucesso finaliza script e envia mensagem ao operador, pois em alguns momentos
      não havia tempo hábil entre a gravação da tag local e a leitura derla para abertura do relatório.


===============================================================================================

Aplicação Versão 1.0.09      Data Liberação: 23/Jun/2023

> Compatibilidade
  HIscada:  Versão 1.7.00
  Mplserver Versã0 1.1.02

Alteração: 23/Jun/2023 - Alvim Alves Junior 
[B]  - Foi alterado o Script Viewers.Scripts.ScriptGroup_Geral.Script_SalvaEdit
       No controldador Dixel o Setpoint de umidade deve ser o dobro do valor desejado, segundo
       offset do equipamento, por este motivo antes de enviar valor desejado seu valor é 
       multiplicado por 2.

[F] - Compilado a alicação na versão 1.7 do HIScada Pro   

[F] - Realizado a consistência da Tag OPC de nímero de Registro no Script de coleta, para caso não haja 
      comunicação com o CLP saia do script sem coletar dados. 

===============================================================================================

Aplicação Versão 1.0.08      Data Liberação: 12/Jun/2023

> Compatibilidade
  HIscada:  Versão 1.6.09
  Mplserver Versã0 1.1.00

Alteração: 12/Jun/2023 - Daniel Franco 
[I] - [I] - Foi feito um filtro para o sup ler o set point de temperatura e umidade e escrever no tag local.



===============================================================================================

Aplicação Versão 1.0.07      Data Liberação: 07/Jun/2023

> Compatibilidade
  HIscada:  Versão 1.6.09
  Mplserver Versã0 1.1.00

Alteração: 07/Jun/2023 - Daniel Franco 
[I] - Melhora nas consuktas de relatórios.
[F] - Adicionado o campo se set point atual pros controladores.

===============================================================================================


Aplicação Versão 1.0.06      Data Liberação: 07/Jun/2023

> Compatibilidade
  HIscada:  Versão 1.6.09
  Mplserver Versã0 1.1.00

Alteração: 07/Jun/2023 - Daniel Franco 
[I] - Foi passado o script de configuração do mpl para kernel.  
   script: "Kernel.Scripts.ScriptGroup_CONEXAO.Script_K_ConectarCLP"

===============================================================================================


Aplicação Versão 1.0.05      Data Liberação: 06/Jun/2023

> Compatibilidade
  HIscada:  Versão 1.6.09
  Mplserver Versã0 1.1.00

Alteração: 06/Jun/2023 - Daniel Franco 
[I] - Correção de 3 textos. 

===============================================================================================
Alteração: 14/Nov/2022 - Daniel Franco 
[F] - Adicionado os icones de minimizar telas.
[F] - Retirado o combobox da programação de horarios e colocado dois check para habilitar e desabilitar liga/desliga. 
[F] - Adicionado o Relatporio gráfico de historico e eventos de temperatura minima e maxima. 
[F] - melhorado o filtro para geração de relatorios.
[F] - Adicionado um texto de "----" quando não tem umidade ou temperatura de evaporador no grid da tela inicial.
[I] - Retirada uma casa depois da virgula. 
[F] - Adiciona uma tela de cadasrtro de clps 
[F] - Adicionada a logica para realizar a comunicação quando selecionado o clp. 
 

===============================================================================================
Aplicação Versão 1.0.00      Data Liberação: 01/Nov/2022

> Compatibilidade
  HIscada:  Versão 1.6.09
  Mplserver Versã0 1.1.00


Alteração: 01/Nov/2022 - Alvim Alves / Daniel Franco / Paulo Inazumi
[F] - Versão inicial
===============================================================================================
