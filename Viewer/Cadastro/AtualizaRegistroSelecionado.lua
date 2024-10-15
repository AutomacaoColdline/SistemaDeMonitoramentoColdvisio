--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Sistemas de licenças mensal
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: Equipe de desenvolvimento de software
        Data: 26/03/2019 

 \b Descrição:  \brief
   Apaga registro selecionado

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém o item de DataSource através do caminho completo até o mesmo
-------------------------------------------------------------------------------------------------------------------------------
local data_source = DataSources:GetDataSource("Viewers.DataSources.DataSourceGroup_Cadastro.DataSource_ReadOnly")

if(data_source == nil)then
  MessageBox("ERW:Falha ao obter DataSource!")
end

-------------------------------------------------------------------------------------------------------------------------------
-- Executa método do DataSource que obtém o valor do field selecionado através de seu nome
-------------------------------------------------------------------------------------------------------------------------------
local selected_field_value = data_source:GetSelectedFieldValueFromName("id")

print(selected_field_value)

-------------------------------------------------------------------------------------------------------------------------------
-- Obtém tag associado ao parâmetro da consulta e o atualiza com o valor do field obtido acima
-------------------------------------------------------------------------------------------------------------------------------
local tag_param_p1 = Tags.Get("Viewers.Tags.Local.ViewerTagGroup_Cadastro.ViewerTag_ID")
tag_param_p1.Value = tonumber(selected_field_value)
tag_param_p1:WriteValue()
