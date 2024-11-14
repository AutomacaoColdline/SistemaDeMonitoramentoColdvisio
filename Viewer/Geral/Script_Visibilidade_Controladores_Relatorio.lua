-- Obtém a tela, garantindo que `scr` não seja nil
local scr = Sender and Sender.Screen
if scr == nil then
    print("Erro: 'scr' está nil. Verifique se Sender.Screen está disponível.")
    return
end

-- Itera sobre os 15 controladores
for i = 1, 15 do
    -- Obtém a tag com o nome do controlador
    local nome_controlador_tag = Tags.Get("Kernel.Tags.Local.TagLocalGroup_KN_Instancias.Nome_controlador_" .. i)
    print(nome_controlador_tag.Value)
    
    -- Verifica se a tag existe e seu valor é diferente de "Controlador Desabilitado"
    if nome_controlador_tag and nome_controlador_tag.Value ~= "Controlador Desabilitado" then
        -- Nomes dos elementos display e checkbox correspondentes ao controlador
        local display = "Display_Nome_Controlador_" .. i
        local checkbox = "CheckBox_Controlador_" .. i
        
        -- Torna o display visível se ele existe
        if scr[display] then
            scr[display].Visible = true
        else
            print("Aviso: Elemento '" .. display .. "' não encontrado na tela.")
        end
        
        -- Torna o checkbox visível se ele existe
        if scr[checkbox] then
            scr[checkbox].Visible = true
        else
            print("Aviso: Elemento '" .. checkbox .. "' não encontrado na tela.")
        end
    else
        -- Se o controlador está desabilitado, oculta o display e o checkbox
        local display = "Display_Nome_Controlador_" .. i
        local checkbox = "CheckBox_Controlador_" .. i

        -- Oculta o display se ele existe
        if scr[display] then
            scr[display].Visible = false
        end
        
        -- Oculta o checkbox se ele existe
        if scr[checkbox] then
            scr[checkbox].Visible = false
        end
    end
end