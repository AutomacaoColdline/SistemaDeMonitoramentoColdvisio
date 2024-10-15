--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 04/10/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local AddUsefulFunctions = require "UsefulFunctions"

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tela
-------------------------------------------------------------------------------------------------------------------------------
local scr = Sender.Screen


local Argumento = Sender.Argument

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tag
-------------------------------------------------------------------------------------------------------------------------------
local tag_local_controlador_1 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_1")
local tag_local_controlador_2 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_2")
local tag_local_controlador_3 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_3")
local tag_local_controlador_4 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_4")
local tag_local_controlador_5 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_5")
local tag_local_controlador_6 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_6")
local tag_local_controlador_7 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_7")
local tag_local_controlador_8 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_8")
local tag_local_controlador_9 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_9")
local tag_local_controlador_10 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_10")
local tag_local_controlador_11 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_11")
local tag_local_controlador_12 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_12")
local tag_local_controlador_13 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_13")
local tag_local_controlador_14 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_14")
local tag_local_controlador_15 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_15")
local tag_local_controlador_16 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_16")
local tag_local_controlador_17 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_17")
local tag_local_controlador_18 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_18")
local tag_local_controlador_19 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_19")
local tag_local_controlador_20 = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_20")


if(tag_local_controlador_1.Value == true)then 
  scr.Image_Controlador_1.Enabled = true
  scr.Image_config_1.Enabled      = true
else
  scr.Image_Controlador_1.Enabled = false
  scr.Image_config_1.Enabled      = false
end

if(tag_local_controlador_2.Value == true)then 
  scr.Image_Controlador_2.Enabled = true
  scr.Image_config_2.Enabled      = true
else
  scr.Image_Controlador_2.Enabled = false
  scr.Image_config_2.Enabled      = false
end

if(tag_local_controlador_3.Value == true)then 
  scr.Image_Controlador_3.Enabled = true
  scr.Image_config_3.Enabled      = true  
else
  scr.Image_Controlador_3.Enabled = false
  scr.Image_config_3.Enabled      = false  
end

if(tag_local_controlador_4.Value == true)then 
  scr.Image_Controlador_4.Enabled = true
  scr.Image_config_4.Enabled      = true  
else
  scr.Image_Controlador_4.Enabled = false
  scr.Image_config_4.Enabled      = false
end

if(tag_local_controlador_5.Value == true)then 
  scr.Image_Controlador_5.Enabled = true
  scr.Image_config_5.Enabled      = true
else
  scr.Image_Controlador_5.Enabled = false
  scr.Image_config_5.Enabled      = false
end

if(tag_local_controlador_6.Value == true)then 
  scr.Image_Controlador_6.Enabled = true
  scr.Image_config_6.Enabled      = true  
else
  scr.Image_Controlador_6.Enabled = false
  scr.Image_config_6.Enabled      = false
end

if(tag_local_controlador_7.Value == true)then 
  scr.Image_Controlador_7.Enabled = true
  scr.Image_config_7.Enabled      = true
else
  scr.Image_Controlador_7.Enabled = false
  scr.Image_config_7.Enabled      = false  
end

if(tag_local_controlador_8.Value == true)then 
  scr.Image_Controlador_8.Enabled = true
  scr.Image_config_8.Enabled      = true  
else
  scr.Image_Controlador_8.Enabled = false
  scr.Image_config_8.Enabled      = false
end

if(tag_local_controlador_9.Value == true)then 
  scr.Image_Controlador_9.Enabled = true
  scr.Image_config_9.Enabled      = true
else
  scr.Image_Controlador_9.Enabled = false
  scr.Image_config_9.Enabled      = false  
end

if(tag_local_controlador_10.Value == true)then 
  scr.Image_Controlador_10.Enabled = true
  scr.Image_config_10.Enabled      = true  
else
  scr.Image_Controlador_10.Enabled = false
  scr.Image_config_10.Enabled      = false    
end


if(tag_local_controlador_11.Value == true)then 
  scr.Image_Controlador_11.Enabled = true
  scr.Image_config_11.Enabled      = true    
else
  scr.Image_Controlador_11.Enabled = false
  scr.Image_config_11.Enabled      = false    
end

if(tag_local_controlador_12.Value == true)then 
  scr.Image_Controlador_12.Enabled = true
  scr.Image_config_12.Enabled      = true  
else
  scr.Image_Controlador_12.Enabled = false
  scr.Image_config_12.Enabled      = false  
end

if(tag_local_controlador_13.Value == true)then 
  scr.Image_Controlador_13.Enabled = true
  scr.Image_config_13.Enabled      = true    
else
  scr.Image_Controlador_13.Enabled = false
  scr.Image_config_13.Enabled      = false  
end

if(tag_local_controlador_14.Value == true)then 
  scr.Image_Controlador_14.Enabled = true
  scr.Image_config_14.Enabled      = true    
else
  scr.Image_Controlador_14.Enabled = false
  scr.Image_config_14.Enabled      = false    
end

if(tag_local_controlador_15.Value == true)then 
  scr.Image_Controlador_15.Enabled = true
  scr.Image_config_15.Enabled      = true    
else
  scr.Image_Controlador_15.Enabled = false
  scr.Image_config_15.Enabled      = false    
end

if(tag_local_controlador_16.Value == true)then 
  scr.Image_Controlador_16.Enabled = true
  scr.Image_config_16.Enabled      = true    
else
  scr.Image_Controlador_16.Enabled = false
  scr.Image_config_16.Enabled      = false    
end

if(tag_local_controlador_17.Value == true)then 
  scr.Image_Controlador_17.Enabled = true
  scr.Image_config_17.Enabled      = true    
else
  scr.Image_Controlador_17.Enabled = false
  scr.Image_config_17.Enabled      = false    
end

if(tag_local_controlador_18.Value == true)then 
  scr.Image_Controlador_18.Enabled = true
  scr.Image_config_18.Enabled      = true    
else
  scr.Image_Controlador_18.Enabled = false
  scr.Image_config_18.Enabled      = false    
end

if(tag_local_controlador_19.Value == true)then 
  scr.Image_Controlador_19.Enabled = true
  scr.Image_config_19.Enabled      = true    
else
  scr.Image_Controlador_19.Enabled = false
  scr.Image_config_19.Enabled      = false    
end

if(tag_local_controlador_20.Value == true)then 
  scr.Image_Controlador_20.Enabled = true
  scr.Image_config_20.Enabled      = false    
else
  scr.Image_Controlador_20.Enabled = false
  scr.Image_config_20.Enabled      = false    
end
