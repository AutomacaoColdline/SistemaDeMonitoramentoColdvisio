--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 03/10/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 
local AddUsefulFunctions = require "UsefulFunctions"

local scr = Sender.Screen
local Argumento = Sender.Argument

--Obtem tags do clp 
local cmd = ConsisteTagOpc("Kernel.Tags.Opc.TagOpcGroup_CMD.Comando")
local parametros = ConsisteTagOpc("Kernel.Tags.Opc.TagOpcGroup_CMD.Paramentos")

-- Obtem ID da instancia.
local numero_instancia = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Numero_Instancia")

if(cmd == false or parametros == false)then
  print("Falha ao obter Tags")
  return 
end

-----------------------------------------------------------------------------------------------------------------------------
-- ENVIA OS COMANDOS PARA CLP
-----------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------
-- COMANDO FORÇAR DEGELO
-----------------------------------------------------------------------------------------------------------------------------
if(Argumento == "forcar_degelo") then 

 cmd.Value = 31002
 parametros.Value[1] = numero_instancia.Value
 parametros.Value[2] = 0

-----------------------------------------------------------------------------------------------------------------------------
-- COMANDO PARAR DEGELO
-----------------------------------------------------------------------------------------------------------------------------
elseif(Argumento == "parar_degelo") then 

 cmd.Value = 31003
 parametros.Value[1] = numero_instancia.Value
 parametros.Value[2] = 0

-----------------------------------------------------------------------------------------------------------------------------
-- COMANDO LIGAR
-----------------------------------------------------------------------------------------------------------------------------
elseif(Argumento == "comando_liga") then 

 cmd.Value = 31004
 parametros.Value[1] = numero_instancia.Value
 parametros.Value[2] = 0


-----------------------------------------------------------------------------------------------------------------------------
-- COMANDO DESLIGAR
-----------------------------------------------------------------------------------------------------------------------------
elseif(Argumento == "comando_desliga") then 

 cmd.Value = 31005
 parametros.Value[1] = numero_instancia.Value
 parametros.Value[2] = 0

end

parametros:WriteValue()
cmd:WriteValue()
