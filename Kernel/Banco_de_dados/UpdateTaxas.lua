--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
    Projeto: Projeto_Colegio
    Empresa: HI Tecnologia
    Versão: 1.1.0.0
    Responsável: Daniel kantor
    Data: 19/10/2022 

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local AddUsefulFunctions = require "UsefulFunctions"

----------------------------------------------------------------------------------------------------------------------------------------  
--Obtem os Tags.
----------------------------------------------------------------------------------------------------------------------------------------  
local DataHoraAtual = DateTime()

local tag_opc_grava_temp_diaria = ConsisteTagOpc("Kernel.Tags.Opc.TagOpcGroup_Geral.Flag_Salva_Temp_Diaria")

--Obtem quantidade de instancia.
local qtd_instancias = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Quantidade_Instancias")


--verifica se tem comunicação com o tag opc
if(tag_opc_grava_temp_diaria == false)then
  print("Falha ao Obter Tag de grava temperatura diária")
  return
end


--verifica se o tag esta TRUE para continuar a gravação
if(tag_opc_grava_temp_diaria.Value == false)then
  print("Sem Flag de gravação diaria desligado")
  return
end

----------------------------------------------------------------------------------------------------------------------------------------
-- Abre a conexão ou obtem conexão
----------------------------------------------------------------------------------------------------------------------------------------  
local conPostgre, error = Scripts.Run("Kernel.Scripts.ScriptGroup_BancoDeDados.Script_AbreConexaoPostgres", "con_temp_diaria")
  
if(error ~= nil)then
  print("Ao abrir conexão com o banco: " .. error)
  return
end

if(conPostgre == nil)then
  print("Ao abrir conexão com o banco")
  return
end


----------------------------------------------------------------------------------------------------------------------------------------  
-- Verifica instancias habilitadas e realiza o insert
----------------------------------------------------------------------------------------------------------------------------------------  
for i = 1, qtd_instancias.Value do 

     caminho_isnt_habilitada_tag_local = "Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_" .. i
     isnt_habilitada_tag_local = Tags.Get(caminho_isnt_habilitada_tag_local)
 

     if(isnt_habilitada_tag_local.Value == true)then

       caminho_nome_tag_opc   = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Nome_Controlador.Nome_Controlador"
       caminho_temp_mim       = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Temperatura_Min_Diaria.Temperatura_Min_Diaria"
       	

       nome_controlador_opc   = ConsisteTagOpc(caminho_nome_tag_opc)
       temp_min_opc           = ConsisteTagOpc(caminho_temp_mim)
       temp_max_opc           = ConsisteTagOpc(caminho_temp_max)


       -- Verifica se tag esta ok
       if(nome_controlador_opc  == false or           
          temp_min_opc          == false or       
          temp_max_opc          == false )then

         print("Falha ao obter Tags no insert temperatura diaria")
         return 
       end


       ------------------------------------------------------------------------------------------------------------------------------------------------------------
       -- Insere No banco 
       -------------------------------------------------------------------------------------------------------------------------------------------------------------					   
	    local CmdSQL = string.format("INSERT INTO eventos_temp_diaria(insert_timestamp, nome_controlador, temp_min, tem_max)\
                             VALUES('%s','%s',%.2f,%.2f)",DataHoraAtual,nome_controlador_opc.Value,temp_min_opc.Value,temp_max_opc.Value) 
       --print(CmdSQL)
   
       -- Executa o comando no banco 
       local cursor,error = conPostgre:Execute(CmdSQL)

       -- Verifica se ocorreu algum erro
       if(error ~= nil) then
        print("Falha na execução do comando SQL: " .. tostring(error))
        return
       end
  
     else


     end

end



------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Desliga flag.
------------------------------------------------------------------------------------------------------------------------------------------------------------
if(tag_opc_grava_temp_diaria.Value == true)then
 tag_opc_grava_temp_diaria.Value = false
 tag_opc_grava_temp_diaria:WriteValue()
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
--Fecha conexão com o Banco MySQL
-------------------------------------------------------------------------------------------------------------------------------------------------------------
local ret = conPostgre:Disconnect()

