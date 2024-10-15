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


-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tela
-------------------------------------------------------------------------------------------------------------------------------
local scr = Sender.Screen

local Argumento = Sender.Argument

local caminho_isnt_habilitada_tag_local = "Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_" .. Argumento
local caminho_isnt_habilitada_tag_opc   = "Kernel.Tags.Opc.TagOpcGroup_Habilita_Controladores.Controlador_" .. Argumento

local isnt_habilitada_tag_local = Tags.Get(caminho_isnt_habilitada_tag_local)
local isnt_habilitada_tag_opc   = ConsisteTagOpc(caminho_isnt_habilitada_tag_opc)

if(isnt_habilitada_tag_opc == false)then 
 print("Falha ao obter o tag opc script = " .. ScriptName)
 return
end

isnt_habilitada_tag_opc:ReadDevice()

print(isnt_habilitada_tag_local.Value)
print(isnt_habilitada_tag_opc.Value)


if(isnt_habilitada_tag_local.Value == false)then  
  isnt_habilitada_tag_local.Value =  true
elseif(isnt_habilitada_tag_local.Value == true)then  
  isnt_habilitada_tag_local.Value =  false
end

if(isnt_habilitada_tag_local.Value == false)then  
  isnt_habilitada_tag_opc.Value   =  0
elseif(isnt_habilitada_tag_local.Value == true)then  
  isnt_habilitada_tag_opc.Value   =  1
end


--[[-----------------------------------
if(isnt_habilitada_tag_opc.Value == 0)then  
  isnt_habilitada_tag_opc.Value   =  1
elseif(isnt_habilitada_tag_opc.Value == 1)then  
  isnt_habilitada_tag_opc.Value   =  0
end
--]]-------------------------------------

isnt_habilitada_tag_local:WriteValue() 
isnt_habilitada_tag_opc:WriteValue()



print(isnt_habilitada_tag_local.Value)
print(isnt_habilitada_tag_opc.Value)

