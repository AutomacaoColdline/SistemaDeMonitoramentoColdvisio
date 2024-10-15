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
--    Script para salvar os parâmetros inseridos em uma determinada Tela 
--
--  Objeto Associado: 
--
-------------------------------------------------------------------------------------------------------------------------------




-------------------------------------------------------------------------------------------------------------------------------
-- Chama o módulo UsefulFunctions.lua para utilizar a função para consistir um Tag OPC(ConsisteTagOpc)
-------------------------------------------------------------------------------------------------------------------------------
local AddUsefulFunctions = require "UsefulFunctions"


-------------------------------------------------------------------------------------------------------------------------------
-- Flag para indicar que o tratamento de execução deste script está consistindo a comunicação com o Controlador
-- true  = trata a comunicação com o Controlador para executar o script
-- false = desconsidera a comunicação com o Controlador para exeutar o script
-------------------------------------------------------------------------------------------------------------------------------
local FlagTrataComunicacao = true


-------------------------------------------------------------------------------------------------------------------------------
-- Confirma com o usuario se realmente deseja salvar os parãmetros
-------------------------------------------------------------------------------------------------------------------------------
local RetMsg = MessageBox("YN2:Desaja salvar os Parâmetros editados?")


-------------------------------------------------------------------------------------------------------------------------------
-- Resposta do Operador = Sim Executa função
-------------------------------------------------------------------------------------------------------------------------------
if(RetMsg == 0) then

  -- Caso o FlagTrataComunicacao esteja setado(true), trata a comunicação com o Controlador para executar o script
  if(FlagTrataComunicacao)then

    -- Obtém o Tag Local do Kernel que contém o Status de Comunicação com o Device
    local TagStatusComunicacao = ConsisteComunicaoCLP("Kernel.Tags.Opc.TagOpcGroup_KN_Comunicacao.TagOpc_StatusDevice")

    -- Se a comunicação não estiver OK, não executa o script
    if(TagStatusComunicacao == false)then
      MessageBox("ERW: Falha na execução do comando!")
      return
    end  
  end

  -- Obtém a tela onde estão os componetes a serem atualizados
  local scr = Sender.Screen

  -- Salva os valores de todos os componentes de tela que possuam alteração pendente
  local ret = scr:SaveAllEdit()

  -- Verifica se o comando foi realizado com sucesso
  if(ret ~= 0)then
    MessageBox("ERW: Falha na execução do comando!")
    return
  end

end
