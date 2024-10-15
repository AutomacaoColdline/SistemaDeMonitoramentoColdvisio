--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto Sup Controle Refrigeração
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: HI Tecnologia
        Data: 19/09/2024 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

-- Obtem a tela
local scr = Sender.Screen
print("Tela obtida: ", scr.Name)

-- Obtém os tags locais
local string_alarme = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_String_Alarmes")
local valor_combo = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_SelecaoControlador")

print("Tags obtidos:\nTag String Alarme: ", string_alarme.Name, "\nTag Valor Combo (Controlador): ", valor_combo.Name)

valor_combo:ReadDevice()

local tag_inicio = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Inicial")
local tag_final = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Final")

print("Tag Inicio: ", tag_inicio.Name, "\nTag Final: ", tag_final.Name)

-- Verifica se foi selecionado um controlador.
if (valor_combo.Value == 0) then
    MessageBox("WAW: Selecione um controlador!")
    return
end

-- Extrai o número do controlador do valor selecionado
local numero_controlador = valor_combo.Value
print("Valor do controlador selecionado: ", valor_combo.Value, "\nControlador selecionado: ", numero_controlador)

-- Gera o nome do event_name com base no controlador selecionado
local event_name = string.format("STS_PHP_Controlador_%02d", numero_controlador)
print("Nome gerado para event_name: ", event_name)

-- Verifica o valor das tags de intervalo de tempo
print("Valor da tag Inicio: ", tag_inicio.Value, "\nValor da tag Final: ", tag_final.Value)

-- Monta a consulta SQL para os alarmes da tabela history_ae
local cmd = string.format(
    "SELECT * FROM history_ae WHERE tag_name = 'TagOpcGroup_Alarmes.TagOpc_AlarmesStatusPHP' AND event_name = '%s' AND timestamp BETWEEN '%s' AND '%s' ORDER BY timestamp", 
    event_name, tag_inicio.Value, tag_final.Value)

print("Comando SQL gerado: ", cmd)

-- Grava a consulta no tag de string de alarme
string_alarme.Value = cmd
string_alarme:WriteValue()
print("Consulta SQL gravada na tag de string de alarme.")

-- Inclui sleep para garantir a gravação correta
Sleep(500)

local i = 0
-- Tenta por 3 vezes ler a tag, caso não tenha sucesso sai do loop
print("Tentando ler a tag de alarme...")
while (i <= 2) do
    err = string_alarme:ReadCache()
    print("Valor da tag String Alarme na tentativa ", i, ": ", string_alarme.Value)
    
    if (string_alarme.Value == cmd) then
        print("Consulta SQL confirmada na tag.")
        i = 10
    end
    
    i = i + 1
    Sleep(100)
end

-- Caso saia do loop sem sucesso
if (i == 3) then
    MessageBox("WAW: Erro ao abrir o relatório, tente novamente!")
    return
end

-- Verifica qual é o relatório a ser aberto
local CaminhoRelatorio = "Globals.Reports.ReportsGroup_alarme.Report_Alarmes"
print("Caminho do relatório selecionado: ", CaminhoRelatorio)

-- Comando de Preview do Relatório
local rep = Reports.GetReport(CaminhoRelatorio)

-- Verifica se o relatório foi obtido
if (rep == nil) then
    MessageBox("ERW: Falha na execução do comando!")
    print("Falha ao obter o relatório.")
    return
end

-- Exibe o relatório
rep:ShowReport()
print("Relatório exibido com sucesso.")