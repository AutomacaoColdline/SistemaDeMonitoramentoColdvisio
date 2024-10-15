--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto Sup Controle Refrigeração
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: HI Tecnologia
        Data: 09/11/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

--Verifica total de instrancias 
local qtd_instancias = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Quantidade_Instancias")

-----------------------------------------------------------------------------------------------------------------------------
-- Atualiza o nome do controlador  
-----------------------------------------------------------------------------------------------------------------------------
for j = 1, qtd_instancias.Value do 

       caminho_habilita_controlador = "Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_" .. j
       controlador_local = Tags.Get(caminho_habilita_controlador)

  if(controlador_local.Value == true)then 

    -- Obtem Tag
    local tag_local_temperatura_evaporador = Tags.Get("Instances.InstanceGroup_Controladores.Controlador_" .. j .. ".Tags.Local.TagLocalGroup_Variaveis.TemperaturaEvaporador") 
    local tag_local_umidade                = Tags.Get("Instances.InstanceGroup_Controladores.Controlador_" .. j .. ".Tags.Local.TagLocalGroup_Variaveis.Umidade")

    local tag_opc_temperatura_evaporador = Tags.Get("Instances.InstanceGroup_Controladores.Controlador_" .. j .. ".Tags.Opc.Temperatura_Evaporador_Controlador.Temperatura_Evaporador_Controlador") 
    local tag_opc_umidade                = Tags.Get("Instances.InstanceGroup_Controladores.Controlador_" .. j .. ".Tags.Opc.Umidade_Controlador.Umidade") 
    local tag_opc_modelo                 = Tags.Get("Instances.InstanceGroup_Controladores.Controlador_" .. j .. ".Tags.Opc.Modelo_Controlador.Modelo") 


   if(tag_opc_modelo.Value == 1)then
     tag_local_temperatura_evaporador.Value = "-----"
     tag_local_umidade.Value = string.format('%d',tag_opc_umidade.Value) .. " %"
   elseif(tag_opc_modelo.Value == 2)then
     tag_local_temperatura_evaporador.Value = string.format('%.1f',tag_opc_temperatura_evaporador.Value) .. " ºC"
     tag_local_umidade.Value = "-----"
   end
 
     tag_local_temperatura_evaporador:WriteValue()
     tag_local_umidade:WriteValue()

  end 
 
end
