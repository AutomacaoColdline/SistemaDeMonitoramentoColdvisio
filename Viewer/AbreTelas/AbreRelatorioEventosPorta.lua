--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_Colegio
     Empresa: HI Tecnologia
      Versão: 1.1.0.0
 Responsável: Daniel kantor
        Data: 18/10/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]]
--Obtem a tela
local scr  = Sender.Screen

--Obtém os tags locais
local string_porta  = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_string_portas")
local valor_combo   = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Selecao_porta")

local tag_inicio = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Inicial")
local tag_final  = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Final")

local clp_conectado = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Conexao.TagLocal_Id_Ultima_conexao")


--Verifica se foi selecioanda um controlador.
if(valor_combo.Value == 0)then
    MessageBox("WAW:Selecione uma Porta!")
  return
end

local cmd = ""

--Verifica qual o filtro do controlador
if(valor_combo.Value == -1)then
  cmd = string.format("SELECT * FROM coleta WHERE dado_tmstamp BETWEEN '%s' AND '%s' AND dado_id > 500 AND clp_conectado = %d ORDER BY id_disp ", tag_inicio.Value,tag_final.Value,clp_conectado.Value)   
else
  cmd = string.format("SELECT * FROM coleta WHERE dado_tmstamp BETWEEN '%s' AND '%s' AND dado_id = %d AND clp_conectado = %d ORDER BY dado_tmstamp", tag_inicio.Value,tag_final.Value,500 + valor_combo.Value,clp_conectado.Value)   
end

--print(cmd)

string_porta.Value = cmd
string_porta:WriteValue()  

-- Incluído sleep para gravação correta da string na variável local.
Sleep(500)

local i = 0
-- Tenta por 3 vezes ler tag, caso não tenha sucesso sai do loop
while (i<=2) do
       err = string_porta:ReadCache()
       if (string_porta.Value == cmd) then
          i = 10
       end
       print(i)
  	i=i+1
       Sleep(100)
end
-- Caso saia do loop com valor 3 indica que não teve sucesso na criação do relatório.
if (i == 3) then
       MessageBox("WAW:Erro ao abrir o relatório, tente novamente!")
       return
end

-------------------------------------------------------------------------------------------------------------------------------
-- Verifica qual é o relatório a ser aberto
-------------------------------------------------------------------------------------------------------------------------------

local CaminhoRelatorio = ""

CaminhoRelatorio = "Globals.Reports.ReportsGroup_relatorios.Report_Eventos_Porta"                   
                       
--print(CaminhoRelatorio)

-------------------------------------------------------------------------------------------------------------------------------
-- Verifica o argumento recebido
-------------------------------------------------------------------------------------------------------------------------------
if(CaminhoRelatorio == nil)then
  MessageBox("ERW: Falha na execução do comando!")
  return
end


-------------------------------------------------------------------------------------------------------------------------------
-- Comando de Preview do Relatório
-------------------------------------------------------------------------------------------------------------------------------
local rep = Reports.GetReport(CaminhoRelatorio)

-------------------------------------------------------------------------------------------------------------------------------
-- Verifica se o relatório foi obtido
-------------------------------------------------------------------------------------------------------------------------------
if(rep == nil)then
  MessageBox("ERW: Falha na execução do comando!")
  return
end
rep:ShowReport()




