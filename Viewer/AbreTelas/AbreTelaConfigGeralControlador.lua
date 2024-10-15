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

local Argumento = Sender.Argument

if Screens.Exist("Screen_Configuracao_Controlador") then
   --print("Tela Existe")
  Screens.Close("Screen_Configuracao_Controlador")
end

if Screens.Exist("Screen_Habilita_Instancias") then
   --print("Tela Existe")
  Screens.Close("Screen_Habilita_Instancias")
end

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém instancia
-------------------------------------------------------------------------------------------------------------------------------

local nome_inst = Argumento 

local instance_path  = "Instances.InstanceGroup_Controladores" .. "." .. nome_inst

local ret = Screens.Open("Screen_Configuracao_Controlador","Viewers.Screens.ScreenGroup_Configuracao.Screen_Configuracao_Controlador", {RefModel_Cfg_controlador = "InstanceGroup_Controladores." .. nome_inst})


