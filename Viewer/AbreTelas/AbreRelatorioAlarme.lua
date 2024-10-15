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
local string_alarme  = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_String_Alarmes")

local tag_inicio = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Inicial")
local tag_final  = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Final")


local cmd = string.format("SELECT * FROM history_ae WHERE timestamp BETWEEN '%s' AND '%s' ORDER BY timestamp", tag_inicio.Value,tag_final.Value)   

--print(cmd)

string_alarme .Value = cmd
string_alarme :WriteValue()  

-- Incluído sleep para gravação correta da string na variável local.
Sleep(500)
-- Tenta por 3 vezes ler tag, caso não tenha sucesso sai do loop
local i = 0
while (i<=2) do
       err = string_alarme :ReadCache()
       if (string_alarme.Value == cmd) then
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

CaminhoRelatorio = "Globals.Reports.ReportsGroup_alarme.Report_Alarmes"                   
                       
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



