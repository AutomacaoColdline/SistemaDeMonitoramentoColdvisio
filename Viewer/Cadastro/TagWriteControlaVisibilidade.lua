--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Sistemas de licenças mensal
     Empresa: HI Tecnologia
      Versão: 1.0.00
 Responsável: Equipe de desenvolvimento de software
        Data: 26/03/2019 

 \b Descrição:  \brief
   Controla visibilidade dos objetos na tela de Pigmentos por Cliente

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

local screen = Screens.Get('Screen_Cadastro_CLPS')

local lista_objetos = {
'StaticText_Nome',
'Edit_Nome_clp',
'StaticText_IP',
'Edit_IP',
'StaticText_HB',
'ImageList_Habilitacao',
'Button_ConfirmaEdicao',
'Button_CancelaEdicao',
'StaticText_Gateway',
'Edit_Gateway',
'StaticText_Mascara',
'Edit_Mascara',
'Image_000',
'Image_001',
'Image_002',
'Image_003',
'Image_004',
}

for idx,value in ipairs(lista_objetos) do
   -- print(value)
  screen[value].Visible = Tag.Value
end



