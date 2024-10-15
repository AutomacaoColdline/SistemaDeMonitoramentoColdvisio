--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto Sup Controle Refrigeração
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: HI Tecnologia
        Data: 10/11/2022 

 \b Descrição:  \brief
   ... função do script
ret_code = my_instance:DisableComm()
- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

--Obtem a tela
local scr  = Sender.Screen

---------------------------------------------------------------------------------------------------------------
--Ontem tags 
---------------------------------------------------------------------------------------------------------------
local tag_local      = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.TagLocal_DesabilitaInstancia")
local qtd_instancias = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Quantidade_Instancias")

if(tag_local.Value == false)then
  return
end

local numero_controladores = qtd_instancias.Value

print("================== DESABILITANDO AS INSTANCIAS ================")


for i = 1 , numero_controladores do 
  
   -- Monta path da instancia
    local PathInst = "InstanceGroup_Controladores.Controlador_" .. i
    -- Obtém a instancia 
    local Inst = Instances.Get(PathInst)

    caminho          = 'Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_' .. i
    hab_controlado = Tags.Get(caminho)
    
    if(hab_controlado.Value == true)then 
      hab_controlado.Value = false
      hab_controlado:WriteValue()

       caminho_nome_tag_local = "Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Nome_controlador_" .. i
       nome_controlador_local = Tags.Get(caminho_nome_tag_local)
  
       -- escreve no tag.
       nome_controlador_local.Value = ""
      nome_controlador_local:WriteValue()
    end

end


if(tag_local.Value == true)then
  tag_local.Value = false
  tag_local:WriteValue()
end


Sleep(2000)

-- Envia comando para configurar o mpl com os valores novos; 
local tag_local_cfg_mpl = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.TagLocal_ConfiguraMPL")

if(tag_local_cfg_mpl.Value == false)then
   tag_local_cfg_mpl.Value = true
   tag_local_cfg_mpl:WriteValue()
end




