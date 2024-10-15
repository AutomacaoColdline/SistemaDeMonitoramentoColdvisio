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


-- Obtem ID da instancia.
local numero_instancia = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Numero_Instancia")
local modelo_local     = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Modelo_Instancia")

local comando_local    = Tags.Get("Instances.InstanceGroup_Controladores.Controlador_" .. numero_instancia.Value .. ".Tags.Opc.Status_Ligado_Desligado.Status_Ligado_Desligado")

--Obtem tags do clp 
local cmd = ConsisteTagOpc("Instances.InstanceGroup_Controladores.Controlador_" .. numero_instancia.Value .. ".Tags.Opc.Comandos.cmd")


if(cmd == false)then
  print("Falha ao obter Tags")
  return 
end

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
  tentativas = 10
  nome_controlador = "DIXELL" 
elseif(modelo_local.Value == 2)then 
  tentativas = 12
  nome_controlador = "FULL GAUGE"
end 


-----------------------------------------------------------------------------------------------------------------------------
-- ENVIA OS COMANDOS PARA CLP
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-- COMANDO DESLIGAR
-----------------------------------------------------------------------------------------------------------------------------
if(comando_local.Value == 1) then 
  print("# COMANDO DESLIGAR ===> " .. nome_controlador)

 -- Verifica se comando ja foi enviado
 if(cmd.Value[6] ~= 0)then 
   MessageBox("Aguarde comando já enviado!")
   return
 end 

  local var1 = MessageBox("YN2:Deseja desligar o controlador?")
  if (var1 ~= 0) then
    print("Saiu do comando de desligar!")
    return
  end

 cmd.Value[6] = 1
 cmd:WriteValue()
 
 -- ================================================================================
 -- Aguarda execução do comando para verificar código de retorno
 -- ================================================================================

 while (tentativas > 0 and retorno_escrita == false) do

     Sleep(1000) -- Intervalo de tempo
     cmd:ReadDevice() --realiza uma leitura.
     
     -- Verifica se a tag zerou
     if(cmd.Value[6] == 0)then
       retorno_escrita = true
     end

     tentativas = tentativas - 1  
	 
 end 
 
 

-----------------------------------------------------------------------------------------------------------------------------
-- COMANDO LIGAR
-----------------------------------------------------------------------------------------------------------------------------
elseif(comando_local.Value == 0) then 
  print("# COMANDO LIGAR ===> " .. nome_controlador)

 -- Verifica se comando ja foi enviado
 if(cmd.Value[5] ~= 0)then 
   MessageBox("Aguarde comando já enviado!")
   return
 end 

  local var1 = MessageBox("YN2:Deseja ligar o controlador?")
  if (var1 ~= 0) then
    print("Saiu do comando de ligar!")
    return
  end


 cmd.Value[5] = 1
 cmd:WriteValue()
 
 -- ================================================================================
 -- Aguarda execução do comando para verificar código de retorno
 -- ================================================================================
 while (tentativas > 0 and retorno_escrita == false) do

     Sleep(1000) -- Intervalo de tempo
     cmd:ReadDevice() --realiza uma leitura.
     
     -- Verifica se a tag zerou
     if(cmd.Value[5] == 0)then
       retorno_escrita = true
     end

     tentativas = tentativas - 1  
	 
 end
 
end


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
      --MessageBox("ERW:Falha na execução do comando")
      print("Falha na execução do comando, código de retorno = " .. cmd.Value[24])
      return 
   end

elseif(retorno_escrita == false)then 
 
  --MessageBox("ERW:Falha na execução do comando!")
  print("Falha na execução do comando de retorno da escrita ==> " .. nome_controlador)
  return
  
end 

