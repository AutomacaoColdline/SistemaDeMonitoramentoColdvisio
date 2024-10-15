(* ============================================================================
 *                          FUNÇÃO CHK_CMD_WR
 *
 *      FUNÇÃO: CHK_CMD_WR
 *     REVISÃO: 1.0.00
 *        DATA: 30/07/2024
 * RESPONSAVEL: Eng. de Aplicação da HI TECNOLOGIA
 *
 *   DESCRIÇÃO: Esta função verifica qual o controlador que possui comando a ser executado.
 * ============================================================================*)
// Reseta a flag que indica que encontrou comando a ser executado
ACHOU := false;
FOR I := 0 to 19 DO
        // Verifica se há comandos para o controlador atual
        if    (CMD_WR[I].SP_TEMP      <> 0) or
			  (CMD_WR[I].SP_PROC      <> 0) or
              (CMD_WR[I].DEGELO       <> 0) or
              (CMD_WR[I].PARAR_DEGELO <> 0) or
              (CMD_WR[I].LIGAR        <> 0) or
              (CMD_WR[I].DESLIGAR     <> 0) or
              (CMD_WR[I].LIGAR_PH     <> 0) or
              (CMD_WR[I].DESLIGAR_PH  <> 0) or
              (CMD_WR[I].INT_DEGELO  <> 0 ) then
                      ACHOU := true;
					  exit;
        end_if;
END_FOR;
// Caso não tenha encontrado comando a ser executado atribui o valor 255 ao ID
// do controlador para gravação.
if ACHOU = FALSE then
      I := 255;
end_if;
// Atualiza o ID do controlador de temperatura a ser enviado o bloco de comunicação.
CHK_CMD_WR := I;