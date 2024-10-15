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
--    Script para o tratamento de Logout do usuário corrente da aplicação
--
--  Objeto Associado: 
--    Viewers.Screens.ScreenGroup_Visualizacao.Screen_TelaBase.Img_Login
-------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------
-- Obtém o nome do usuário corrente
-------------------------------------------------------------------------------------------------------------------------------
local TagUserName = Tags.Get("Viewers.Tags.Internal.Application.UserName")

local ret_MessageBox = MessageBox("YN2:Deseja efetuar o Logout do usuário "..tostring(TagUserName.Value).. "?")
if(ret_MessageBox == 0)then 
  UserLogout()
end 
