(* ============================================================================
 *                          FUNÇÃO GET_NEXT_ENA
 *
 *      FUNÇÃO: GET_NEXT_ENA
 *     REVISÃO: 1.0.00
 *        DATA: 30/07/2024
 * RESPONSAVEL: Eng. de Aplicação da HI TECNOLOGIA
 *
 *   DESCRIÇÃO: Esta função verifica a partir do ID do controlador de temperatura atual
 *   Qual o próximo controlador de temperatura habilitado.
 * ============================================================================*)
// Consiste o valor dentro dos IDs possíveis de 0 a 19
ID := IDX_ATUAL;
if (ID <0) or (ID>(MAX_EQP-1)) then
    ID := 0;
end_if;
// Reseta a flag que indica que encontrou ID Habilitado e com modelo configurado
ACHOU := false;
// Verifica qual o próximo controlador habilitado e com modelo configurado
for I := (ID + 1) to (MAX_EQP-1) do
      if (PRI_CFG.FDB.DAT.W.CONF_CTRL[I].HAB_CTRL = 1) AND
         (PRI_CFG.FDB.DAT.W.CONF_CTRL[I].MODELO <> 0)  THEN
// Caso encontrar algum controlador habilitado seta flag e sai do loop for.
          ACHOU := true;
          exit;
      end_if;
end_for;
// Caso não encontrou nenhum controlador habilitado e com modelo configurado, varre
// os IDs anteriores ao ID atual
if ACHOU = false then
   for I := 0 to ID do
      if (PRI_CFG.FDB.DAT.W.CONF_CTRL[I].HAB_CTRL = 1) AND
         (PRI_CFG.FDB.DAT.W.CONF_CTRL[I].MODELO <> 0)  THEN
          ACHOU := true;
          exit;
      end_if;
   end_for;
end_if;
// Se após a varredura completa não encontrar nenhum controlador de temperatura
// habilitado envia valor 255 para ID do controlador de temperatura
if ACHOU = false then
      I := 255;
end_if;
// Atribui o valor do ID como retorno da função.
GET_NEXT_ENA := I;