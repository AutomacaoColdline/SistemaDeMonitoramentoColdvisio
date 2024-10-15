--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto Sup Controle Refrigeração
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: HI Tecnologia
        Data: 25/07/2024 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local AddUsefulFunctions = require "UsefulFunctions" --chama função do consiste Tags

----------------------------------------------------------------------------------------------------------------------------------------  
--Obtem Data e Hora Atual
----------------------------------------------------------------------------------------------------------------------------------------  
local DataAtual     = os.date('%d/%m/%Y') -- Data Atual
local DataHoraAtual = DateTime() -- Data e Hora Atual

----------------------------------------------------------------------------------------------------------------------------------------  
--Inicia variaveis
----------------------------------------------------------------------------------------------------------------------------------------  
local tipo_comando_banco = 1

----------------------------------------------------------------------------------------------------------------------------------------  
--Obtem os Tags
----------------------------------------------------------------------------------------------------------------------------------------  
--Obtem quantidade de instancia.
local qtd_instancias = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Geral.Quantidade_Instancias")

----------------------------------------------------------------------------------------------------------------------------------------
-- Abre a conexão ou obtem conexão
----------------------------------------------------------------------------------------------------------------------------------------  
local conPostgre, error = Scripts.Run("Kernel.Scripts.ScriptGroup_BancoDeDados.Script_AbreConexaoPostgres", "con_taxas")
  
if(error ~= nil)then
  print("Ao abrir conexão com o banco: " .. error)
  return
end

if(conPostgre == nil)then
  print("Ao abrir conexão com o banco")
  return
end


----------------------------------------------------------------------------------------------------------------------------------------  
-- Verifica instancias habilitadas e realiza o insert ou update
----------------------------------------------------------------------------------------------------------------------------------------  
for i = 1, qtd_instancias.Value do

    caminho_isnt_habilitada_tag_local = "Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Controlador_" .. i
    isnt_habilitada_tag_local = Tags.Get(caminho_isnt_habilitada_tag_local)

    if(isnt_habilitada_tag_local.Value == true)then

       caminho_tag_opc_ambiente        = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Nome_Controlador.Nome_Controlador"
       caminho_tag_opc_status          = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Status_Controlador.Status_Controlador"
       caminho_tag_opc_comunicacao_ok  = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Comunicacao_Ok.Comunicacao_Ok"
       caminho_tag_opc_comunicacao_nok = "Instances.InstanceGroup_Controladores.Controlador_" .. i .. ".Tags.Opc.Comunicacao_NOk.Comunicacao_NOk"

       tag_opc_ambiente        = ConsisteTagOpc(caminho_tag_opc_ambiente)
       tag_opc_status          = ConsisteTagOpc(caminho_tag_opc_status)
       tag_opc_comunicacao_ok  = ConsisteTagOpc(caminho_tag_opc_comunicacao_ok)
       tag_opc_comunicacao_nok = ConsisteTagOpc(caminho_tag_opc_comunicacao_nok)

      -- Verifica se tag esta ok
      if(tag_opc_ambiente        == false or           
         tag_opc_status          == false or       
         tag_opc_comunicacao_ok  == false or
         tag_opc_comunicacao_nok == false )then

        print("Falha ao obter Tags no insert/update taxas")
        return 
      end

      ------------------------------------------------------------------------------------------------------------------------------------------------------------  
      -- Aloca os valores dos tags para outras variaveis.  
      ------------------------------------------------------------------------------------------------------------------------------------------------------------
      controlador     = i
      ambiente        = tag_opc_ambiente.Value
      status          = tag_opc_status.Value
      comunicacao_ok  = tag_opc_comunicacao_ok.Value
      comunicacao_nok = tag_opc_comunicacao_nok.Value

      -------------------------------------------------------------------------------------------------------------------------------------------------------------
      -- Select para verificar se ja existe registro no banco com a mesma data de um controlador.
      -------------------------------------------------------------------------------------------------------------------------------------------------------------	
      local sql_select_registro = string.format("SELECT * FROM taxas WHERE data = '%s' AND controlador = %d",DataAtual,controlador)
      --print(ql_select_registro)

      local cursor, error = conPostgre:Execute(sql_select_registro) -- executa o select no banco de dados. 

      if (error ~= nil) then
          MessageBox("ERW:Falha na consulta de verificação de registro no banco!")
          return
      end

      local row = cursor:Fetch() -- Pega linha do banco 

      if row == nil then
        tipo_comando_banco = 1
      else
        tipo_comando_banco = 2
      end

      cursor:Close() -- facha o comando do banco. 

      -------------------------------------------------------------------------------------------------------------------------------------------------------------
      -- Verifica se o comando é Insert ou Update para executar no banco. 
      -- Tipo: 1 = Insert , 2 = Update
      -------------------------------------------------------------------------------------------------------------------------------------------------------------	
      if(tipo_comando_banco == 1 )then
        -- print("== INSERT TAXAS ==") 

         -- Insert Banco
         local CmdSQL_Insert = string.format("INSERT INTO taxas(controlador, data, ambiente,status, comunicacao_ok, comunicacao_nok, data_hora)\
                                              VALUES(%d,'%s','%s',%d,%d,%d,'%s')",controlador,DataAtual,ambiente,status,comunicacao_ok,comunicacao_nok,DataHoraAtual)
         --print(CmdSQL_Insert)

         -- Executa o comando no banco 
         local cursor_insert,error_insert = conPostgre:Execute(CmdSQL_Insert)

         -- Verifica se ocorreu algum erro
         if(error_insert ~= nil) then
           print("Falha na execução do comando SQL: " .. tostring(error_insert))
           return
        end

      elseif(tipo_comando_banco == 2)then
         --print("== UPDATE TAXAS ==") 

         -- Update Banco 
         local CmdSQL_Update = string.format("UPDATE taxas SET ambiente='%s',status=%d,comunicacao_ok=%d,comunicacao_nok=%d,data_hora='%s'\
                                              WHERE data = '%s' AND controlador = %d",ambiente,status,comunicacao_ok,comunicacao_nok,DataHoraAtual,DataAtual,controlador)
         --print(CmdSQL_Update)

         -- Executa o comando no banco 
         local cursor_update,error_update = conPostgre:Execute(CmdSQL_Update)

         -- Verifica se ocorreu algum erro
         if(error_update ~= nil) then
           print("Falha na execução do comando SQL: " .. tostring(error_update))
           return
        end

      end
    end -- fim do if de instacias habilitadas 
end --fim do for         


-------------------------------------------------------------------------------------------------------------------------------------------------------------
--Fecha conexão com o Banco MySQL
-------------------------------------------------------------------------------------------------------------------------------------------------------------
local ret = conPostgre:Disconnect()

