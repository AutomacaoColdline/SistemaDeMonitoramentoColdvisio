(* ============================================================================
 *                          FUNÇÃO DEMUX16
 *
 *      FUNÇÃO: DEMUX16
 *     REVISÃO: 1.0.00
 *        DATA: 08/Abr/2021
 * RESPONSAVEL: Eng. de Aplicação da HI TECNOLOGIA
 *
 *   DESCRIÇÃO: Esta função Constroi um Vetor Booleano a partir de um inteiro
 *              UINT 16 bits.
 * ============================================================================
 *)
SUCESS := TRUE;                   // Setar booleano de retorno
TESTE := 1;
FOR IDX := 0 TO 15 DO
  MASK := SHL(TESTE, IDX);           // Move valor 1 para todos os bits (Máscara)
  TEST :=  AND(MASK, VUINT16);    // Testa de posição do Index é 1 ou 0
  IF TEST = 0 THEN                // Se a posição for zero atribui FALSE  para
     VETBIT[IDX] := FALSE;      // o Vetor booleano na posição do Index
     ELSE                         // Senão atribui TRUE
         VETBIT[IDX] := TRUE;   // Para o Vetor Booleano na posição do Index
  END_IF;
END_FOR;
SUCESS := FALSE;                   // Retorno de finalização
DEMUX16 := SUCESS;                 // Retorna valor 0 para a função.
