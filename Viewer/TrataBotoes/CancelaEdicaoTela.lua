-------------------------------------------------------------------------------------------------------------------------------
--    HI Tecnologia Ind. Com. Ltda - www.hitecnologia.com.br
-------------------------------------------------------------------------------------------------------------------------------
--    Projeto: App Model HIscada Pro
--    Cliente: 
--       Data: 01/ago/2013  
--      Resp.: Eng. de Produto da HI Tecnologia
--   Ambiente: HIscada Pro, versão 1.3.01 ou superior
-------------------------------------------------------------------------------------------------------------------------------
--  Descrição: 
--    Script para Cancelar os parâmetros inseridos em uma determinada Tela 
--
--  Objeto Associado: 
--
-------------------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------------
-- Confirma com o usuario se realmente deseja cancelar os parãmetros
-------------------------------------------------------------------------------------------------------------------------------
local RetMsg = MessageBox("YN2:Deseja Cancelar os Parâmetros editados??")



-------------------------------------------------------------------------------------------------------------------------------
-- Resposta do Operador = Sim Executa função
-------------------------------------------------------------------------------------------------------------------------------
if(RetMsg == 0) then

  -- Obtém a tela onde estão os componetes a serem Cancelados a edição
  local scr = Sender.Screen

  -- Cancela os valores de todos os componentes de tela que tenham sido alterados
  local ret = scr:CancelAllEdit()

  -- Verifica se o comando foi realizado com sucesso
  if(ret ~= 0)then
    MessageBox("ERW: Falha na execução do comando!")
    return
  end
end
