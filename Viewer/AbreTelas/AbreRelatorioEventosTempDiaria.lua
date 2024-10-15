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
local string_eventos   = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_String_eventos_Temp_Diaria")
local valor_combo        = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_SelecaoControlador")

valor_combo:ReadDevice()

local tag_inicio = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Inicial")
local tag_final  = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Final")

local tag_param_temp_min   = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Param_TempMinima")
local tag_param_temp_max  = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Param_TempMaxima")

local tag_tipo_relat   = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_TipoGraficoTabular")

local clp_conectado = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Conexao.TagLocal_Id_Ultima_conexao")


--Obtém o texto do combobox
local texto_combo = scr.ComboBox_Controladores.Text

--Verifica se foi selecioanda um controlador.
if(valor_combo.Value == 0)then
    MessageBox("WAW:Selecione um Ambiente!")
  return
end


--Verifica se foi selecioanda um controlador.
if(tag_param_temp_min.Value == false and tag_param_temp_max.Value == false)then
    MessageBox("WAW:Selecione um ou mais parâmetros!")
  return
end

Sleep(300)

local cmd = ""

--Verifica qual o filtro do controlador
if(valor_combo.Value == -1)then
 -- cmd = string.format("SELECT * FROM eventos_temp_diaria WHERE insert_timestamp BETWEEN '%s' AND '%s' ORDER BY nome_controlador", tag_inicio.Value,tag_final.Value)   
else
  cmd = string.format("SELECT * FROM (select dado_tmstamp,id_disp,nome_controlador,modelo,max(dado_real) filter (where dado_id = id_disp) as dado_1,\
                                      max(dado_real) filter (where dado_id = %d + id_disp) as dado_2\
					   from coleta WHERE dado_tmstamp BETWEEN '%s' AND '%s' AND nome_controlador = '%s' AND clp_conectado = %d group by dado_tmstamp,nome_controlador,modelo,id_disp ORDER BY dado_tmstamp,nome_controlador) AS A WHERE dado_1 IS NOT NULL AND dado_2 IS NOT NULL",
					   100,tag_inicio.Value,tag_final.Value,texto_combo,clp_conectado.Value) 
end

--print(cmd)

string_eventos.Value = cmd
string_eventos:WriteValue()  

-- Incluído sleep para gravação correta da string na variável local.
Sleep(500)

local i = 0
-- Tenta por 3 vezes ler tag, caso não tenha sucesso sai do loop
while (i<=2) do
       err = string_eventos:ReadCache()
       if (string_eventos.Value == cmd) then
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

   

if(tag_tipo_relat.Value == 0)then
  CaminhoRelatorio = "Globals.Reports.ReportsGroup_relatorios.Report_Eventos_Temp_Diaria"  
elseif(tag_tipo_relat.Value == 1)then
  CaminhoRelatorio = "Globals.Reports.ReportsGroup_relatorios.Report_Eventos_Temp_Diaria_Grafico"    
end               
                       
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


