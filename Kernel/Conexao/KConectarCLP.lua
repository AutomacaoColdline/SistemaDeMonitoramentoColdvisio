--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Alc11Tools
     Empresa: 
      Versão: 
 Responsável: 
        Data: 06/10/2014 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

tag = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Conexao.TagLocal_ComandoConectar")

reiniciar_mcs = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Conexao.TagLocal_Reiniciar_MCS")

if (tag.Value == 0) then
   return
end
print("================== REINICIANDO O MPLSERVER ================")

tipo_conexao = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Conexao.TagLocal_TipoConexao").Value

----------------------------------------------------------------
-- Fechar o mcs
----------------------------------------------------------------
if (reiniciar_mcs.Value == 1) then

   os.execute("start /min TASKKILL /F /IM MOS.EXE")
   os.execute("start /min TASKKILL /F /IM MCS.EXE")

   Sleep(3000)

   path_exe = ProjectsFolder .. ProjectName .. "\\publ\\bin\\RefreshTrayIcon"

   ret = os.execute('"' .. path_exe .. '"')

   reiniciar_mcs.Value = 0
   reiniciar_mcs:WriteValue()

end

if (tipo_conexao == 1) then

   comm = "ETH"

elseif (tipo_conexao == 2) then

   comm = "SER"

end


local AddUsefulFunctions = require "UsefulFunctions"

Sleep(5000)-- Aguarda um tempo 5s inicial para o Kernel reiniciar o MplServer

local tentativas = 20
local conectou = false 

--device_type = ConsisteTagOpc("Instances.Pocos.CLP.Tags.Opc.InfoDevice.deviceType")

while (tentativas > 0 and conectou == false) do
      Sleep(1000) -- Intervalo de tempo entre tentativas de conexão

      device_type = ConsisteTagOpc("Kernel.Tags.Opc.TagOpcGroup_InfosControlador.F1_deviceTypeCode")

      conectou = device_type 

      tentativas = tentativas - 1
     -- print(tentativas)
end

if (device_type == false) then

   tag.Value = 0
   tag:WriteValue()

   return

end

----------------------------------------------------------------
-- Obtem dados do CLP
----------------------------------------------------------------
--Obtem o tipo de CLP e se conectou com sucesso atualiaza status de conexão

tempo_maximo = 1

if (device_type.Value == "?" or device_type == nil or device_type.Quality ~= 192) then

   while (tempo_maximo <= 100 and (device_type.Value == "?" or device_type == nil or device_type.Quality ~= 192)) do

      tempo_maximo = tempo_maximo + 1

      device_type:ReadDevice()
      Sleep(50)

   end

end


tag.Value = 0
tag:WriteValue()


Sleep(10000)
--------------------------------------------------------------------------------------------------------
-- Envia Comando para atualizar as instancias.
--------------------------------------------------------------------------------------------------------
local tag_local_atualiza = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.TagLocal_AtualizaInstancias")

if(tag_local_atualiza.Value == false)then
  tag_local_atualiza.Value = true
  tag_local_atualiza:WriteValue()
end
