--[[- - - - - - - - - - - - - - - - - - - - - - - - - - 

    Ambiente: HIscada_Pro
     Projeto: Projeto_GeradoraEletricaBiogas
     Empresa: HI Tecnologia
      Versão: 1.0.0.0
 Responsável: Eng. Aplicação
        Data: 07/06/2022 

 \b Descrição:  \brief
   ... função do script

- - - - - - - - - - - - - - - - - - - - - - - - - - - -]] 

-- Verifica se tem tela aberta e fecha quando clicar na tela inicial.

-- Argumento do objeto
pcall(load("x = " .. Sender.Argument))

local Argumento = x.nome

---------------------------------------------------------------------------------------------------
-- Fecha Tela Controlador
---------------------------------------------------------------------------------------------------
if Screens.Exist("Screen_Controlador") then
  --print("Tela Existe")
  Screens.Close("Screen_Controlador")
end

---------------------------------------------------------------------------------------------------
-- Fecha Tela configuração
---------------------------------------------------------------------------------------------------
if Screens.Exist("Screen_Configuracao") then
  --print("Tela Existe")
  Screens.Close("Screen_Configuracao")
end


---------------------------------------------------------------------------------------------------
-- Fecha Tela Habilita Instancias
---------------------------------------------------------------------------------------------------
if(Argumento ~= "Screen_Habilita_Instancias")then
 if Screens.Exist("Screen_Habilita_Instancias") then
   --print("Tela Existe")
   Screens.Close("Screen_Habilita_Instancias")
 end
end

---------------------------------------------------------------------------------------------------
-- Fecha Tela configuração do controlador
---------------------------------------------------------------------------------------------------
if Screens.Exist("Screen_Configuracao_Controlador") then
   --print("Tela Existe")
  Screens.Close("Screen_Configuracao_Controlador")
end


---------------------------------------------------------------------------------------------------
-- Fecha Tela de Portas
---------------------------------------------------------------------------------------------------
if(Argumento ~= "Screen_Configuracao_Portas")then
 if Screens.Exist("Screen_Configuracao_Portas") then
   --print("Tela Existe")
   Screens.Close("Screen_Configuracao_Portas")
 end
end

---------------------------------------------------------------------------------------------------
-- Fecha Tela de Notificacao
---------------------------------------------------------------------------------------------------
if(Argumento ~= "Screen_Notificacao")then
 if Screens.Exist("Screen_Notificacao") then
   --print("Tela Existe")
   Screens.Close("Screen_Notificacao")
 end
end

---------------------------------------------------------------------------------------------------
-- Fecha Tela de Manutenção
---------------------------------------------------------------------------------------------------
if(Argumento ~= "Screen_Manutencao")then
 if Screens.Exist("Screen_Manutencao") then
   --print("Tela Existe")
   Screens.Close("Screen_Manutencao")
 end
end
---------------------------------------------------------------------------------------------------
-- fecha tela de 
---------------------------------------------------------------------------------------------------
if(Argumento ~= "Screen_Relatorio")then
 if Screens.Exist("Screen_Relatorio") then
   --print("Tela Existe")
   Screens.Close("Screen_Relatorio")
 end
end


---------------------------------------------------------------------------------------------------
-- Fecha Tela de Taxas
---------------------------------------------------------------------------------------------------
if(Argumento ~= "Screen_Taxas")then
  if Screens.Exist("Screen_Taxas") then
    --print("Tela Existe")
    Screens.Close("Screen_Taxas")
  end
end
