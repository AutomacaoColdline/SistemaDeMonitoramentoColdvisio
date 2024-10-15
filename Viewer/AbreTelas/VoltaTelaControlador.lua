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

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tela
-------------------------------------------------------------------------------------------------------------------------------
local scr = Sender.Screen

local AddUsefulFunctions = require "UsefulFunctions"

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém instancia
-------------------------------------------------------------------------------------------------------------------------------
local instance = scr.Instances["RefModel_Controlador_cfg"] 


local instance_path  = "Instances." .. instance.Group .. "." .. instance.Name


-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tag
-------------------------------------------------------------------------------------------------------------------------------
local tag_modelo = ConsisteTagOpc(instance_path.. ".Tags.Opc.Modelo_Controlador.Modelo")

-------------------------------------------------------------------------------------------------------------------------------
-- Modelo Dixell XH260
-------------------------------------------------------------------------------------------------------------------------------
if(tag_modelo.Value == 1)then 


  if(scr.Edit_SetPoint_Temp_Ambiente.UpdatePending == true or scr.Edit_SetPointUmidade.UpdatePending == true)then 
  
     ret = MessageBox("YN2: Parâmetros alterados não enviados para o controlador.\n\n Cancelar a programação?")

     if(ret ~= 0)then
        return
     end
             
  end 

-------------------------------------------------------------------------------------------------------------------------------
-- Full Gauge TC 900e Log
-------------------------------------------------------------------------------------------------------------------------------
elseif(tag_modelo.Value == 2)then 

  if(scr.Edit_SetPoint_Temp_Ambiente.UpdatePending == true or scr.Edit_SP_TempEvap.UpdatePending == true or scr.Edit_IntervaloDegelo.UpdatePending == true)then
  
     ret = MessageBox("YN2: Parâmetros alterados não enviados para o controlador.\n\n Cancelar a programação?")

     if(ret ~= 0)then
        return
     end
	 
  end 
  
end


local ret = Screens.Open("Screen_Controlador","Viewers.Screens.ScreenGroup_Inicial.Screen_Controlador", {RefModel_Controlador = instance.Group .. "." .. instance.Name})


if Screens.Exist("Screen_Configuracao") then
  --print("Tela Existe")
  Screens.Close("Screen_Configuracao")
end


