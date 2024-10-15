--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Sistema de execução de receitas
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: Equipe de desenvolvimento de software
        Data: 28/10/2014 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 


-------------------------------------------------------------------------------------------------------------------------------
-- Obtém Tags de configuração de acesso ao banco
-------------------------------------------------------------------------------------------------------------------------------

local NomeConexao = Param

local host_name     = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_BancoDeDados.TagLocal_HostName").Value
local database_name = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_BancoDeDados.TagLocal_DataBaseName").Value
local port_number   = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_BancoDeDados.TagLocal_PortNumber").Value
local user_name     = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_BancoDeDados.TagLocal_UserName").Value
local user_password = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_BancoDeDados.TagLocal_Password").Value


-------------------------------------------------------------------------------------------------------------------------------
-- Parametriza o acesso a um banco de dados no Postgres
-------------------------------------------------------------------------------------------------------------------------------
local postgres_dsn = {driver='PostgreSQL', host=host_name, database=database_name, port=port_number, username=user_name, password=user_password}


-------------------------------------------------------------------------------------------------------------------------------
-- Verifica se a conexão já esta aberta
-- Caso não, abre a conexão com o nome passado como parâmetro para o script
-------------------------------------------------------------------------------------------------------------------------------
local con = Database.Get(NomeConexao)
if con == nil then
  con = Database.Connect(NomeConexao, postgres_dsn)
  -- print("Alocou nova conexão")
end


-------------------------------------------------------------------------------------------------------------------------------
-- Verifica se houve erro na abertura da conexão
-------------------------------------------------------------------------------------------------------------------------------
if con.Error then
  print("Erro na abertura de conexão:" .. con.Error)
  print("Conexão:" .. tostring(con))
  return
end

-------------------------------------------------------------------------------------------------------------------------------
-- Retorna conexão
-------------------------------------------------------------------------------------------------------------------------------
return con
