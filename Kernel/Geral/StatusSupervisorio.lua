--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 05/10/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local AddUsefulFunctions = require "UsefulFunctions"


--Obtem quantidade de instancia.
local tag_opc_status_supervisorio = ConsisteTagOpc("Kernel.Tags.Opc.TagOpcGroup_Geral.Status_Supervisorio")

local tag_local_comunicacao = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Comunicacao_CLP")


--verifica se tem comunicação com o tag
if(tag_opc_status_supervisorio == false)then
  tag_local_comunicacao.Value = true
  tag_local_comunicacao:WriteValue()

  print("Falha ao Obter Tag de status do supervisorio")
  return
end


--verifica se o tag esta desligado e caso estiver desligado liga tag.
if(tag_opc_status_supervisorio.Value == false)then
  tag_opc_status_supervisorio.Value = true
  tag_opc_status_supervisorio:WriteValue()
end

tag_local_comunicacao.Value = false
tag_local_comunicacao:WriteValue()
