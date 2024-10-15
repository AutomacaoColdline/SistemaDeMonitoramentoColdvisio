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
--    Script para fechar a tela que executou o evento
--
--  Objeto Associado: 
--    Botão Voltar
-------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------
-- Obtém a tela que chamou o evento e fecha a mesma
-------------------------------------------------------------------------------------------------------------------------------
local scr = Sender.Screen
local ret = Screens.Close(scr.Name)