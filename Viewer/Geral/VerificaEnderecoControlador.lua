--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 19/10/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local AddUsefulFunctions = require "UsefulFunctions"


local instance  = Sender.Screen:GetInstance('RefModel_Cfg_controlador')
local prefix = 'Instances.' .. instance.Group .. '.' .. instance.Name

print(prefix)

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tela
-------------------------------------------------------------------------------------------------------------------------------
local scr = Sender.Screen

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tag
-------------------------------------------------------------------------------------------------------------------------------
local tag_endereco        = ConsisteTagOpc(prefix .. ".Tags.Opc.Endereco_Controlador.Endereco")
local tag_opc_verificacao = ConsisteTagOpc("Kernel.Tags.Opc.TagOpcGroup_Geral.ID_existente")

if(tag_endereco == false or tag_opc_verificacao == false)then
  print("Falha ao obter o tag na verificacao de endereco")
  return
end


if(tag_opc_verificacao.Value == true)then 
  tag_endereco.Value = 0
  tag_endereco:WriteValue()
  MessageBox("WAW:Endereço ja alocado em um controlador!")
  return
end 

