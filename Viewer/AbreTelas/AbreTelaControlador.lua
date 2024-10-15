--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: 
     Empresa: 
      Versão: 1.0.00
 Responsável: 
        Data: 19/06/2015 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 


local AddUsefulFunctions  = require "UsefulFunctions"

---------------------------------------------------------------------------------------------------
-- Fecha Tela Controlador
---------------------------------------------------------------------------------------------------
if Screens.Exist("Screen_Controlador") then
  --print("Tela Existe")
  Screens.Close("Screen_Controlador")
end


---------------------------------------------------------------------------------------------------
-- Fecha Tela configuração
---------------------------------------------------------------------------------------------------
if Screens.Exist("Screen_Configuracao") then
  --print("Tela Existe")
  Screens.Close("Screen_Configuracao")
end


---------------------------------------------------------------------------------------------------
-- Fecha Tela Habilita Instancias
---------------------------------------------------------------------------------------------------
if(Argumento ~= "Screen_Habilita_Instancias")then
 if Screens.Exist("Screen_Habilita_Instancias") then
   --print("Tela Existe")
   Screens.Close("Screen_Habilita_Instancias")
 end
end

---------------------------------------------------------------------------------------------------
-- Fecha Tela configuração do controlador
---------------------------------------------------------------------------------------------------
if Screens.Exist("Screen_Configuracao_Controlador") then
   --print("Tela Existe")
  Screens.Close("Screen_Configuracao_Controlador")
end


---------------------------------------------------------------------------------------------------
-- Fecha Tela de Portas
---------------------------------------------------------------------------------------------------
if(Argumento ~= "Screen_Configuracao_Portas")then
 if Screens.Exist("Screen_Configuracao_Portas") then
   --print("Tela Existe")
   Screens.Close("Screen_Configuracao_Portas")
 end
end

---------------------------------------------------------------------------------------------------
-- Fecha Tela de Notificacao
---------------------------------------------------------------------------------------------------
if(Argumento ~= "Screen_Notificacao")then
 if Screens.Exist("Screen_Notificacao") then
   --print("Tela Existe")
   Screens.Close("Screen_Notificacao")
 end
end

---------------------------------------------------------------------------------------------------
-- Fecha Tela de Manutenção
---------------------------------------------------------------------------------------------------
if(Argumento ~= "Screen_Manutencao")then
 if Screens.Exist("Screen_Manutencao") then
   --print("Tela Existe")
   Screens.Close("Screen_Manutencao")
 end
end
---------------------------------------------------------------------------------------------------
-- fecha tela de Relatorio
---------------------------------------------------------------------------------------------------
if(Argumento ~= "Screen_Relatorio")then
 if Screens.Exist("Screen_Relatorio") then
   --print("Tela Existe")
   Screens.Close("Screen_Relatorio")
 end
end

---------------------------------------------------------------------------------------------------
-- fecha tela de cadastro clps
---------------------------------------------------------------------------------------------------
if(Argumento ~= "Screen_Cadastro_CLPS")then
 if Screens.Exist("Screen_Cadastro_CLPS") then
   --print("Tela Existe")
   Screens.Close("Screen_Cadastro_CLPS")
 end
end



local path   = "Instances."..CellInstance.Group.. "." .. CellInstance.Name


local ret = Screens.Open("Screen_Controlador","Viewers.Screens.ScreenGroup_Inicial.Screen_Controlador", {RefModel_Controlador = CellInstance.Group .. "." .. CellInstance.Name})


inst = CellInstance.Name

local tipo, modo = string.match(inst,'(.*)_(.*)')


-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tag
-------------------------------------------------------------------------------------------------------------------------------
local tag_opc_modelo = ConsisteTagOpc(path .. ".Tags.Opc.Modelo_Controlador.Modelo")


local numero_inst_controlador = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Numero_Instancia")
local modelo                  =  Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Modelo_Instancia")

numero_inst_controlador.Value = tonumber(modo)
numero_inst_controlador:WriteValue()

modelo.Value = tag_opc_modelo.Value
modelo:WriteValue()

--print(numero_inst_controlador.Value)
