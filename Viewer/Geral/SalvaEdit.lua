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

--Salva valor do edit
scr[Argumento].SaveEdit = 1 


-- Obtem ID da instancia.
local numero_instancia = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Numero_Instancia")
local modelo_local     = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Modelo_Instancia")

--Obtem tags do clp 
local cmd = ConsisteTagOpc("Instances.InstanceGroup_Controladores.Controlador_" .. numero_instancia.Value .. ".Tags.Opc.Comandos.cmd")

if(cmd == false)then
  print("Falha ao obter Tags")
  return 
end

-----------------------------------------------------------------------------------------------------------------------------
-- Chama uma leitura do tag
-----------------------------------------------------------------------------------------------------------------------------
cmd:ReadDevice()


-----------------------------------------------------------------------------------------------------------------------------
-- Inicia as variavel. 
-----------------------------------------------------------------------------------------------------------------------------
local tentativas       = 5
local retorno_escrita  = false
local nome_controlador = ""

-----------------------------------------------------------------------------------------------------------------------------
-- Verifica qual o modelo do controlador para setar as tentativas de codigo de retorno.
-----------------------------------------------------------------------------------------------------------------------------
if(modelo_local.Value == 1)then 
  tentativas = 5
  nome_controlador = "DIXELL" 
elseif(modelo_local.Value == 2)then 
  tentativas = 5
  nome_controlador = "FULL GAUGE"
end 

-----------------------------------------------------------------------------------------------------------------------------
-- COMANDO SP DE TEMPERATURA AMBIENTE
-----------------------------------------------------------------------------------------------------------------------------
if(Argumento == "Edit_SetPoint_Temp_Ambiente") then 

  print("# COMANDO TEMPERATURA ===> " .. nome_controlador)

 -- Verifica se comando ja foi enviado
 if(cmd.Value[1] ~= 0)then 
   MessageBox("Aguarde comando já enviado!")
   return
 end 

 local tag_local_setpoint_temp_ambiente = Tags.Get("Instances.InstanceGroup_Controladores.Controlador_" .. numero_instancia.Value .. ".Tags.Local.TagLocalGroup_SetPoint.Temperatura_Ambiente")

 cmd.Value[1] = 1
 cmd.Value[9] = tag_local_setpoint_temp_ambiente.Value * 10
 cmd:WriteValue()
 
  -- ================================================================================
  -- Aguarda execução do comando para verificar código de retorno
  -- ================================================================================
  while (tentativas > 0 and retorno_escrita == false) do

      Sleep(1000) -- Intervalo de tempo
      cmd:ReadDevice() --realiza uma leitura.
     
      -- Verifica se a tag zerou
      if(cmd.Value[1] == 0)then
        retorno_escrita = true
      end

      tentativas = tentativas - 1  
	 
  end


-----------------------------------------------------------------------------------------------------------------------------
--  COMANDO SP TEMPERATURA EVAPORADOR
-----------------------------------------------------------------------------------------------------------------------------
elseif(Argumento == "Edit_SP_TempEvap") then 

  print("# COMANDO EVAPORADOR ===> " .. nome_controlador)

 -- Verifica se comando ja foi enviado
 if(cmd.Value[2] ~= 0)then 
   MessageBox("Aguarde comando já enviado!")
   return
 end  

 local tag_local_setpoint_temp_evap = Tags.Get("Instances.InstanceGroup_Controladores.Controlador_" .. numero_instancia.Value .. ".Tags.Local.TagLocalGroup_SetPoint.Temperatura_Evaporador")

 cmd.Value[2] = 1
 cmd.Value[10] = tag_local_setpoint_temp_evap.Value * 10
 cmd:WriteValue()
 
  -- ================================================================================
  -- Aguarda execução do comando para verificar código de retorno
  -- ================================================================================
  while (tentativas > 0 and retorno_escrita == false) do

      Sleep(1000) -- Intervalo de tempo
      cmd:ReadDevice() --realiza uma leitura.
     
      -- Verifica se a tag zerou
      if(cmd.Value[2] == 0)then
        retorno_escrita = true
      end

      tentativas = tentativas - 1  
	 
  end


-----------------------------------------------------------------------------------------------------------------------------
-- COMANDO SP UMIDADE
-----------------------------------------------------------------------------------------------------------------------------
elseif(Argumento == "Edit_SetPointUmidade") then 

   print("# COMANDO UMIDADE ===> " .. nome_controlador)

 -- Verifica se comando já foi enviado
 if(cmd.Value[2] ~= 0)then 
   MessageBox("Aguarde comando já enviado!")
   return
 end 

 local tag_local_setpoint_umidade = Tags.Get("Instances.InstanceGroup_Controladores.Controlador_" .. numero_instancia.Value .. ".Tags.Local.TagLocalGroup_SetPoint.Umidade")
-- Comando para o setpoint da umidade deve ser multiplicado por 2 pelo offset do próprio controlador Dixell

 cmd.Value[2] = 1
 cmd.Value[10] = tag_local_setpoint_umidade.Value * 2
 cmd:WriteValue()
 
  -- ================================================================================
  -- Aguarda execução do comando para verificar código de retorno
  -- ================================================================================
  while (tentativas > 0 and retorno_escrita == false) do

      Sleep(1000) -- Intervalo de tempo
      cmd:ReadDevice() --realiza uma leitura.
     
      -- Verifica se a tag zerou
      if(cmd.Value[2] == 0)then
        retorno_escrita = true
      end

      tentativas = tentativas - 1  
	 
  end


-----------------------------------------------------------------------------------------------------------------------------
-- COMANDO INTERVALO DEGELO
-----------------------------------------------------------------------------------------------------------------------------
elseif(Argumento == "Edit_IntervaloDegelo") then 

  print("# COMANDO INTERVALO DEGELO ===> " .. nome_controlador)

 -- Verifica se comando ja foi enviado
 if(cmd.Value[12] ~= 0)then 
   MessageBox("Aguarde comando já enviado!")
   return
 end 

 local tag_local_intervalo_degelo = Tags.Get("Instances.InstanceGroup_Controladores.Controlador_" .. numero_instancia.Value .. ".Tags.Local.TagLocalGroup_SetPoint.Intervalo_Degelo")

 cmd.Value[12] = 1
 cmd.Value[11] = tag_local_intervalo_degelo.Value
 cmd:WriteValue()
 
  -- ================================================================================
  -- Aguarda execução do comando para verificar código de retorno
  -- ================================================================================
  while (tentativas > 0 and retorno_escrita == false) do

      Sleep(1000) -- Intervalo de tempo
      cmd:ReadDevice() --realiza uma leitura.
     
      -- Verifica se a tag zerou
      if(cmd.Value[12] == 0)then
        retorno_escrita = true
      end

      tentativas = tentativas - 1  
	 
  end

end
   

--print(retorno_escrita)

-- ================================================================================
--Se retorno da escrita for true realiza uma leitura do codigo de retorno.
--Se retorno  for false falha no comando.  
-- ================================================================================
if(retorno_escrita == true)then 

   cmd:ReadDevice() -- Realiza uma leitura no codigo de retorno. 

   -- Se código de retorno for igual a 0, comando enviado com sucesso. 
   -- caso for diferente falha na execução do comando. 
   if(cmd.Value[24] == 0)then 
      --MessageBox("Comando enviado com sucesso!")
        print("Comando enviado com sucesso! ==> " .. nome_controlador)  
   else
     -- MessageBox("ERW:Falha na execução do comando")
      print("Falha na execução do comando, código de retorno = " .. cmd.Value[24])
      return 
   end

elseif(retorno_escrita == false)then  

  --MessageBox("ERW:Falha na execução do comando!")
  print("Falha na execução do comando de retorno da escrita ==> " .. nome_controlador)
  return
  
end 



