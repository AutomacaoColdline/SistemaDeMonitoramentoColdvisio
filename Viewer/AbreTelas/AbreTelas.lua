--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_GeradoraEletricaBiogas
     Empresa: HI Tecnologia
      Versão: 1.0.0.0
 Responsável: Eng. Aplicação
        Data: 08/06/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local AddUsefulFunctions = require "UsefulFunctions"

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tela
-------------------------------------------------------------------------------------------------------------------------------
local scr = Sender.Screen

--Verifica se tem tela aberta e fecha
--result,err = Scripts.Run('Viewers.Scripts.ScriptGroup_AbreTelas.Script_Fecha_Telas')

-- Argumento do objeto
pcall(load("x = " .. Sender.Argument))

local Argumento = x.nome

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


 -------------------------------------------------------------------------------------------------------------------------------
 -- Obtém instancia
 -------------------------------------------------------------------------------------------------------------------------------
 local instance = scr.Instances["RefModel_Controlador_cfg"] 

  local instance_path  = "Instances." .. instance.Group .. "." .. instance.Name
  --print(instance_path)
 
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


---------------------------------------------------------------------------------------------------
-- Fecha Tela de Taxas
---------------------------------------------------------------------------------------------------
if Screens.Exist("Screen_Taxas") then
  --print("Tela Existe")
  Screens.Close("Screen_Taxas")
end

---------------------------------------------------------------------------------------------------------------------
-- Abre telas
---------------------------------------------------------------------------------------------------------------------
--print(x.nome)
--print(x.caminho)

-- Configurar esta variavel
local nome_da_tela = x.nome

-- Caminho da definição da tela (Ex: Viewers.Screens.ScreenGroup_001.Screen_001)
local caminho_da_tela = x.caminho

-- Abre a tela especificada
local ret = Screens.Open(nome_da_tela,caminho_da_tela)

-- Se falha imprime erro na interface
if (ret ~= 0) then
  print("Falha na abertura da tela" .. nome_da_tela);
end


