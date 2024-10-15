--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 05/10/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local AddUsefulFunctions = require "UsefulFunctions"

----------------------------------------------------------------------------------------------------------------------------------------
-- Abre a conexão ou obtem conexão
----------------------------------------------------------------------------------------------------------------------------------------  
local conPostgre, error = Scripts.Run("Kernel.Scripts.ScriptGroup_BancoDeDados.Script_AbreConexaoPostgres", "con_analisador")
  
if(error ~= nil)then
  print("Ao abrir conexão com o banco: " .. error)
  return
end

if(conPostgre == nil)then
  print("Ao abrir conexão com o banco")
  return
end

----------------------------------------------------------------------------------------------------------------------------------------  
--Obtem os Tags.
----------------------------------------------------------------------------------------------------------------------------------------  
local DataHoraAtual = DateTime()

--Obtem quantidade de instancia.
local qtd_instancias = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Quantidade_Instancias")


----------------------------------------------------------------------------------------------------------------------------------------  
-- Verifica instancias habilitadas e realiza o insert
----------------------------------------------------------------------------------------------------------------------------------------  
for i = 1, qtd_instancias.Value do 

     caminho_isnt_habilitada_tag_local = "Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_" .. i
     isnt_habilitada_tag_local = Tags.Get(caminho_isnt_habilitada_tag_local)
 

     if(isnt_habilitada_tag_local.Value == true)then

       caminho_nome_tag_opc            = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Nome_Controlador.Nome_Controlador"
       caminho_modelo_tag_opc          = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Modelo_Controlador.Modelo"
       caminho_end_tag_opc             = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Endereco_Controlador.Endereco"
       caminho_temp_amb_tag_opc        = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Temperatura_Ambiente_Controlador.Temperatura_Ambiente"
       caminho_umidade_tag_opc         = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Umidade_Controlador.Umidade"
       caminho_temp_evap_tag_opc       = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Temperatura_Evaporador_Controlador.Temperatura_Evaporador_Controlador"
       caminho_status_degelo_tag_opc   = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Status_Degelo.Status_Degelo"
       caminho_status_desumid_tag_opc  = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Status_Desumidificacao.Status_Desumidificacao"
       caminho_status_vent_tag_opc     = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Status_Ventilacao.Status_Ventilacao"
       caminho_status_refrig_tag_opc   = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Status_Refrigeracao.Status_Refrigeracao"

       nome_controlador_opc            = ConsisteTagOpc(caminho_nome_tag_opc)
       modelo_controlador_opc          = ConsisteTagOpc(caminho_modelo_tag_opc)
       end_controlador_opc             = ConsisteTagOpc(caminho_end_tag_opc)
       temp_amb_controlador_opc        = ConsisteTagOpc(caminho_temp_amb_tag_opc)
       umidade_controlador_opc         = ConsisteTagOpc(caminho_umidade_tag_opc)
       temp_evap_controlador_opc       = ConsisteTagOpc(caminho_temp_evap_tag_opc)
       status_degelo_controlador_opc   = ConsisteTagOpc(caminho_status_degelo_tag_opc)
       status_desumid_controlador_opc  = ConsisteTagOpc(caminho_status_desumid_tag_opc)
       status_vent_controlador_opc     = ConsisteTagOpc(caminho_status_vent_tag_opc)
       status_refrig_controlador_opc   = ConsisteTagOpc(caminho_status_refrig_tag_opc)

       -- Verifica se tag esta ok
       if(nome_controlador_opc           == false or           
          modelo_controlador_opc         == false or       
          end_controlador_opc            == false or       
          temp_amb_controlador_opc       == false or        
          umidade_controlador_opc        == false or        
          temp_evap_controlador_opc      == false or       
          status_degelo_controlador_opc  == false or    
          status_desumid_controlador_opc == false or  
          status_vent_controlador_opc    == false or  
          status_refrig_controlador_opc  == false )then

         print("Falha ao obter Tags no insert historico")
         return 
       end


       ------------------------------------------------------------------------------------------------------------------------------------------------------------
       -- Insere No banco 
       -------------------------------------------------------------------------------------------------------------------------------------------------------------					   
	local CmdSQL = string.format("INSERT INTO public.historico(insert_timestamp,nome_controlador,modelo,endereco,temperatura_ambiente,temperatura_evaporador,umidade,sts_degelo,sts_desumidificacao,sts_ventilacao,sts_refrigeracao)\
                             VALUES('%s','%s',%d,%d,%.2f,%.2f,%d,%d,%d,%d,%d)",DataHoraAtual,nome_controlador_opc.Value,modelo_controlador_opc.Value,end_controlador_opc.Value,temp_amb_controlador_opc.Value,temp_evap_controlador_opc.Value,umidade_controlador_opc.Value,status_degelo_controlador_opc.Value,status_desumid_controlador_opc.Value, status_vent_controlador_opc.Value,status_refrig_controlador_opc.Value) 
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



-------------------------------------------------------------------------------------------------------------------------------------------------------------
--Fecha conexão com o Banco MySQL
-------------------------------------------------------------------------------------------------------------------------------------------------------------
local ret = conPostgre:Disconnect()




  



