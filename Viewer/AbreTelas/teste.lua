-- Obtém a tela, garantindo que `scr` não seja nil
local scr = Sender and Sender.Screen
if scr == nil then
    MessageBox("Erro: 'scr' está nil. Verifique se Sender.Screen está disponível.")
    return
end
local value_minimun_temp = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_MinimunTemp")
-- Obtém as tags locais para armazenar o histórico dos 6 controladores
local string_historico_tags = {
    Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_HistoricoControlador1"),
    Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_HistoricoControlador2"),
    Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_HistoricoControlador3"),
    Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_HistoricoControlador4"),
    Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_HistoricoControlador5"),
    Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_HistoricoControlador6")
}

local valor_combo = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_SelecaoControlador")
local tempo_de_amostragem = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_SelecaoTempoAmostragem")

local tag_inicio = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Inicial")
local tag_final = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Final")

local tag_param_temp_amb = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Param_TempAmbiente")
local tag_param_temp_eva = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Param_TempEvaporador")
local tag_param_umidade = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_Param_Umidade")

local tag_tipo_relat = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_relatorio.TagLocal_TipoGraficoTabular")
local clp_conectado = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Conexao.TagLocal_Id_Ultima_conexao")

-- Verifica se `tag_tipo_relat` está definida corretamente (1 para tabular, 2 para gráfico)
if not tag_tipo_relat or (tag_tipo_relat.Value ~= 1 and tag_tipo_relat.Value ~= 2) then
    MessageBox("Erro: 'tag_tipo_relat' não está definido corretamente. Deve ser 1 para tabular ou 2 para gráfico.")
    return
end

-- Valida as tags de data e obtém o intervalo de tempo
local data_inicio = tag_inicio and tag_inicio.Value or ""
local data_final = tag_final and tag_final.Value or ""
if data_inicio == "" or data_final == "" then
    MessageBox("Erro: Datas de início e fim são necessárias.")
    return
end

-- Gera consultas SQL para os seis controladores e grava nas tags correspondentes
for i = 1, 6 do
    local nome_controlador_tag = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Nome_controlador_" .. i)
    local controlador_nome = nome_controlador_tag and nome_controlador_tag.Value or ("Controlador_" .. i)
    
    local cmd = string.format(
        "SELECT * FROM (SELECT dado_tmstamp, id_disp, nome_controlador, modelo, " ..
        "MAX(dado_real) FILTER (WHERE dado_id = %d + id_disp) AS dado_1, " ..
        "MAX(dado_real) FILTER (WHERE dado_id = %d + id_disp) AS dado_2, " ..
        "MAX(dado_int) FILTER (WHERE dado_id = %d + id_disp) AS dado_3 " ..
        "FROM coleta WHERE dado_tmstamp BETWEEN '%s' AND '%s' AND nome_controlador = '%s' " ..
        "AND clp_conectado = %d GROUP BY dado_tmstamp, nome_controlador, modelo, id_disp " ..
        "ORDER BY dado_tmstamp) AS A " ..
        "WHERE dado_1 IS NOT NULL AND dado_2 IS NOT NULL AND dado_3 IS NOT NULL;",
        200, 300, 400, data_inicio, data_final, controlador_nome, clp_conectado.Value
    )

    -- Verifica se a tag de histórico correspondente existe e armazena o comando nela
    if string_historico_tags[i] then
        string_historico_tags[i].Value = cmd
        local write_success = string_historico_tags[i]:WriteValue()

        -- Exibe o comando SQL gerado para cada controlador
        print("Consulta gerada para Controlador", i, "(", controlador_nome, "):", cmd)

        if not write_success then
            MessageBox("Erro ao gravar o comando no histórico para o controlador: " .. controlador_nome)
            return
        end
    else
        MessageBox("Erro: Tag de histórico para o controlador " .. i .. " não encontrada.")
    end
end

-- Define o caminho do relatório baseado no tipo de gráfico/tabular
local CaminhoRelatorio = ""
if tag_tipo_relat.Value == 1 then
    CaminhoRelatorio = "Globals.Reports.ReportsGroup_relatorios.Report_historico"  -- Tabular
elseif tag_tipo_relat.Value == 2 then
    CaminhoRelatorio = "Globals.Reports.ReportsGroup_relatorios.Report_Controladores"  -- Gráfico
end

-- Verifica se o caminho do relatório foi definido corretamente
if CaminhoRelatorio == "" then
    MessageBox("ERW: Falha na execução do comando! Caminho do relatório não foi definido.")
    return
end

-- Exibe o relatório
local rep = Reports.GetReport(CaminhoRelatorio)
if rep == nil then
    MessageBox("ERW: Falha ao obter o relatório!")
    return
end

-- Tenta exibir o relatório
local show_success = rep:ShowReport()
if not show_success then
    MessageBox("ERW: Falha ao exibir o relatório!")
end
