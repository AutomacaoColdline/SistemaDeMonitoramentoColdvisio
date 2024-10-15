-------------------------------------------------------------------------------------------------------------------------------
--    HI Tecnologia Ind. Com. Ltda - www.hitecnologia.com.br
-------------------------------------------------------------------------------------------------------------------------------
--    Projeto: App Model HIscada Pro
--    Cliente: 
--       Data: 01/ago/2013  
--      Resp.: Eng. de Produto da HI Tecnologia
--   Ambiente: HIscada Pro, versão 1.3.03 ou superior
-------------------------------------------------------------------------------------------------------------------------------
--  Descrição: 
--    Script para o tratamento de encerramento da Aplicação
--
--  Objeto Associado: 
--    Viewers.Screens.ScreenGroup_Visualizacao.Screen_TelaBase.Img_BotaoSair
-------------------------------------------------------------------------------------------------------------------------------

local ret_MessageBox = MessageBox("YN2:Deseja realmente Sair do Sistema")
  if(ret_MessageBox == 0)then 
    ApplicationClose()
  end 
  