--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto Sup Controle Refrigeração
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: HI Tecnologia
        Data: 26/07/2024 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local AddUsefulFunctions = require "UsefulFunctions" --chama função do consiste Tags


----------------------------------------------------------------------------------------------------------------------------
--Obtem tag Locais
----------------------------------------------------------------------------------------------------------------------------
local tag_local_versao_clp_compatibilidade = Tags.Get("Kernel.Tags.Local.TagLocalGroup_APP.Versao_CLP_Compatibilidade")

----------------------------------------------------------------------------------------------------------------------------
--Obtem tag OPCs
----------------------------------------------------------------------------------------------------------------------------
local tag_opc_versao_app = ConsisteTagOpc("Kernel.Tags.Opc.TagOpcGroup_InfosControlador.TagOpc_VersaoProgramaCLP")

if(tag_opc_versao_app == false)then

 print("Falha ao obter Tags no insert/update taxas")
 return 

end

-----------------------------------------------------------------------------------------
-- Verifica se a versão é compativel
-----------------------------------------------------------------------------------------
local local_versao_app = tag_local_versao_clp_compatibilidade.Value
local opc_versao_app   = string.format(tag_opc_versao_app.Value)

if(opc_versao_app < local_versao_app)then 

   MessageBox("ERW: Versão do programa do CLP é incompatível com a versão do supervisório.\n\n Por favor atualize para versão mais atual do programa do CLP")
  print("Versão Menor que " .. local_versao_app)
  return false

end

return true
