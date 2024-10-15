--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 30/09/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local AddUsefulFunctions = require "UsefulFunctions"


-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tela
-------------------------------------------------------------------------------------------------------------------------------
local scr = Sender.Screen

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém instancia
-------------------------------------------------------------------------------------------------------------------------------
local instance = scr.Instances["RefModel_Controlador"] 

if Screens.Exist("Screen_Controlador") then
  --print("Tela Existe")
  Screens.Close("Screen_Controlador")
end

-------------------------------------------------------------------------------------------------------------------------------
-- pega a instancia
-------------------------------------------------------------------------------------------------------------------------------
local instance_path  = "Instances." .. instance.Group .. "." .. instance.Name
--print(instance_path)

-------------------------------------------------------------------------------------------------------------------------------
-- obtem os tags
-------------------------------------------------------------------------------------------------------------------------------
local tag_local_set_point_ambi = Tags.Get(instance_path .. ".Tags.Local.TagLocalGroup_SetPoint.Temperatura_Ambiente")
local tag_local_set_point_evap = Tags.Get(instance_path .. ".Tags.Local.TagLocalGroup_SetPoint.Temperatura_Evaporador")
local tag_local_set_point_umid = Tags.Get(instance_path .. ".Tags.Local.TagLocalGroup_SetPoint.Umidade")
local tag_local_int_degelo     = Tags.Get(instance_path .. ".Tags.Local.TagLocalGroup_SetPoint.Intervalo_Degelo")

local tag_opc_set_point_ambi = ConsisteTagOpc(instance_path .. ".Tags.Opc.SetPoint_Temperatura_Ambiente.SetPoint_Temperatura_Ambiente")
local tag_opc_set_point_evap = ConsisteTagOpc(instance_path .. ".Tags.Opc.SetPoint_Temperatura_Evaporador.SetPoint_Temperatura_Evaporador")
local tag_opc_set_point_umid = ConsisteTagOpc(instance_path .. ".Tags.Opc.SetPoint_Temperatura_Umidade.SetPoint_Temperatura_Umidade")
local tag_opc_int_degelo     = ConsisteTagOpc(instance_path .. ".Tags.Opc.TagOpcGroup_Int_Degelo.IntervaloDegelo")


-------------------------------------------------------------------------------------------------------------------------------
-- tratamendo do tag 
-------------------------------------------------------------------------------------------------------------------------------
if(tag_opc_set_point_ambi == false or tag_opc_set_point_evap == false or 
   tag_opc_set_point_umid == false or tag_opc_int_degelo == false )then 
  
   print("Falha ao obter o tag OPC no script: " .. ScriptName)
 return
end 

-------------------------------------------------------------------------------------------------------------------------------
-- força leitura do tag
-------------------------------------------------------------------------------------------------------------------------------
tag_opc_set_point_ambi:ReadDevice()
tag_opc_set_point_evap:ReadDevice()
tag_opc_set_point_umid:ReadDevice()
tag_opc_int_degelo:ReadDevice()

-------------------------------------------------------------------------------------------------------------------------------
-- atribui o valor para teg local 
-------------------------------------------------------------------------------------------------------------------------------
tag_local_set_point_ambi.Value = tag_opc_set_point_ambi.Value
tag_local_set_point_evap.Value = tag_opc_set_point_evap.Value
tag_local_set_point_umid.Value = tag_opc_set_point_umid.Value
tag_local_int_degelo.Value     = tag_opc_int_degelo.Value

-------------------------------------------------------------------------------------------------------------------------------
-- escreve no tag local
-------------------------------------------------------------------------------------------------------------------------------
tag_local_set_point_ambi:WriteValue()
tag_local_set_point_evap:WriteValue()
tag_local_set_point_umid:WriteValue()
tag_local_int_degelo:WriteValue()


Sleep(50)

-------------------------------------------------------------------------------------------------------------------------------
-- abre a tela
-------------------------------------------------------------------------------------------------------------------------------
local ret = Screens.Open("Screen_Configuracao","Viewers.Screens.ScreenGroup_Inicial.Screen_Configuracao", {RefModel_Controlador_cfg = instance.Group .. "." .. instance.Name})

-------------------------------------------------------------------------------------------------------------------------------
-- fecha a tela
-------------------------------------------------------------------------------------------------------------------------------
if Screens.Exist("Screen_Controlador") then
  --print("Tela Existe")
  Screens.Close("Screen_Controlador")
end


