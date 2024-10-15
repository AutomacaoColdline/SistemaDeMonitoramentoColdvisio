(* ============================================================================
 *                    PROJETO COLDLINE
 *
 *   DESCRIÇÃO: SISTEMA DE RESFRIAMENTO - CONTROLE E MONITORAMENTO
 *     CLIENTE: COLDLINE
 * RESPONSAVEL: Eng. de Aplicação da HI TECNOLOGIA
 *
 * ============================================================================
 *)

 (*
   ESTA POU A AQUISIÇÃO DOS SINAIS DIGITAIS DE ENTRADA PARA MONITORAMENTO
   DAS PORTAS (ATÉ 08 PORTAS).

   MONITORA TAMBÉM O TIMEOUT DE PORTAS ABERTAS E GERA ALARME PARA SINALIZAÇÃO
   PARA SUPERVISÓRIO / PORTAL TELEMETRIA.
    *** MD_INPUT ***
  *)

(*==============================================================================
                       AQUISIÇÃO de I
================================================================================
  Trata aquisição dos sinais de I do processo
================================================================================*)
{IFDEF NEON}
  PORTA[0] := DI00;
  PORTA[1] := DI01;
  PORTA[2] := DI02;
  PORTA[3] := DI03;
  PORTA[4] := DI04;
  PORTA[5] := DI05;
  PORTA[6] := DI06;
  PORTA[7] := DI07;
{ENDIF}

{IFNDEF NEON}
  {WARNING 'Controlador NEON original do projeto NÃO está selecionado'}
{ENDIF}

{IFDEF SIMU}
  {WARNING 'Habilitada diretiva de simulação SIMU no projeto'}
{ENDIF}

(*------------------------------------------------------------------------------
    Fim Tratamento aquisição dos sinais de I do processo
================================================================================*)

(* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           Temporização inicial de power-up
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *)

// Ticks para controle do programa
TICK_1S(RUN := true, TM := T#1s);

// Determina Tempo de power-up p/ inicialização do sistema
if (PRI_CFG.FDB.DAT.W.T_POWERUP < T_POWERUP_MIN) then
  // tempo minimo de power-up para inicialização do sistema
  TIME_POWERUP := T#5s;
else
  // considera o tempo de atraso no power-up configurado na aplicação
  TIME_POWERUP := INT_TO_TIME(PRI_CFG.FDB.DAT.W.T_POWERUP);
end_if;

// Temporiza 'x' segundos para inicializaçao, onde :
//   * Desabilita alarmes durante este tempo de inicialização
//   * Aguarda um ciclo de aquisição do filtro das entradas analogicas
DLY_POWERUP(      // TON
  IN := true,     // [BOOL] Entrada de habilitação da temporização
  PT := TIME_POWERUP     // T#5s // T_POWERUP  // [TIME] Tempo de atraso para ligar e estabilizar o sistema
  );

// Set falg de sistema já temporizou tempo de power-up
LOC_XAPP.POWERUP_OK := DLY_POWERUP.Q;


(*==============================================================================
       TRATAMENTO DO VALOR DE TEMPO VINDO DO SUPERVISÓRIO
--------------------------------------------------------------------------------*)

FOR I := 0 TO 7 DO
// CONSISTE TEMPO DIGITADO NO SUPERVISÓRIO DE 0 A 50 MINUTOS.
    IF PRI_CFG.FDB.DAT.W.TEMPO[I] < 0 THEN
           PUB_WCFG.TEMPO[I] := 0;
    ELSIF PRI_CFG.FDB.DAT.W.TEMPO[I] > 50 THEN
           PUB_WCFG.TEMPO[I] := 50;
    END_IF;
// CONVERTE VALOR DIGITADO PARA SEGUNDOS.
    TEMPO_S[I] := PRI_CFG.FDB.DAT.W.TEMPO[I] * 60;
// CONVERTE O VALOR EM SEGUNDO PARA VARIÁVEL TIPO TIME.
    TIMEOUT_P[I] := INT_TO_TIME(TEMPO_S[I]);
// CASO O TEMPO SELECIONADO SEJA 0 INDICA STATUS DE DESABILITADO
    IF PRI_CFG.FDB.DAT.W.TEMPO[I] = 0 THEN
          PUB_WAPP.STS_PORTAS[I] := 0;
// CASO A PORTA ESTEJA HABILITADA E FECHADA ENVIA STATUS PARA O SUPERVISÓRIO
    ELSIF PORTA[I] THEN
          PUB_WAPP.STS_PORTAS[I] := 1;
// CASO A PORTA ESTEJA HABILITADA E ABERTA ENVIA STATUS PARA O SUPERVISÓRIO
    ELSIF NOT PORTA[I] THEN
          PUB_WAPP.STS_PORTAS[I] := 2;
    END_IF;
END_FOR;

(*------------------------------------------------------------------------------
       FIM TRATAMENTO DO VALOR DE TEMPO VINDO DO SUPERVISÓRIO
================================================================================*)


(*==============================================================================
       INICIO DO TRATAMENTO DE TIMEOUT DE ALARME DE PORTA ABERTA
--------------------------------------------------------------------------------*)

// ********************* PORTA 01 ******************************************
// CASO O TEMPO SETADO SEJA MAIOR QUE ZERO E TENHA SINAL DE PORTA ABERTA
IF (PRI_CFG.FDB.DAT.W.TEMPO[0] > 0) AND (NOT PORTA[0]) THEN
// INICIA TIMEOUT
     TIMER1(              // TON
       IN := TRUE,        // [BOOL] Entrada de habilitação da temporização
       PT := TIMEOUT_P[0] // [TIME] Tempo de atraso para ligar
       );
// ATIV FLAG DE ALARME DE PORTA ABERTA
     IF TIMER1.Q THEN
         PUB_XAPP.ALM_PORTA[0] := TRUE;
     END_IF;
ELSE
// CASO O TEMPO SEJA 0 OU A PORTA NÃO ESTIVER ABERTA RESETA ALARME E TEMPOTIZADOR
     PUB_XAPP.ALM_PORTA[0] := FALSE;
     TIMER1(IN := FALSE);
     //TIMER1.Q  := FALSE;
END_IF;

// ********************* PORTA 02 ******************************************
// CASO O TEMPO SETADO SEJA MAIOR QUE ZERO E TENHA SINAL DE PORTA ABERTA
IF (PRI_CFG.FDB.DAT.W.TEMPO[1] > 0) AND (NOT PORTA[1]) THEN
// INICIA TIMEOUT
     TIMER2(              // TON
       IN := TRUE,        // [BOOL] Entrada de habilitação da temporização
       PT := TIMEOUT_P[1] // [TIME] Tempo de atraso para ligar
       );
// ATIV FLAG DE ALARME DE PORTA ABERTA
     IF TIMER2.Q THEN
         PUB_XAPP.ALM_PORTA[1] := TRUE;
     END_IF;
ELSE
// CASO O TEMPO SEJA 0 OU A PORTA NÃO ESTIVER ABERTA RESETA ALARME E TEMPOTIZADOR
     PUB_XAPP.ALM_PORTA[1] := FALSE;
     TIMER2(IN := FALSE);
     //TIMER2.Q  := FALSE;
END_IF;

// ********************* PORTA 03 ******************************************
// CASO O TEMPO SETADO SEJA MAIOR QUE ZERO E TENHA SINAL DE PORTA ABERTA
IF (PRI_CFG.FDB.DAT.W.TEMPO[2] > 0) AND (NOT PORTA[2]) THEN
// INICIA TIMEOUT
     TIMER3(              // TON
       IN := TRUE,        // [BOOL] Entrada de habilitação da temporização
       PT := TIMEOUT_P[2] // [TIME] Tempo de atraso para ligar
       );
// ATIV FLAG DE ALARME DE PORTA ABERTA
     IF TIMER3.Q THEN
         PUB_XAPP.ALM_PORTA[2] := TRUE;
     END_IF;
ELSE
// CASO O TEMPO SEJA 0 OU A PORTA NÃO ESTIVER ABERTA RESETA ALARME E TEMPOTIZADOR
     PUB_XAPP.ALM_PORTA[2] := FALSE;
     TIMER3(IN := FALSE);
     //TIMER3.Q  := FALSE;
END_IF;

// ********************* PORTA 04 ******************************************
// CASO O TEMPO SETADO SEJA MAIOR QUE ZERO E TENHA SINAL DE PORTA ABERTA
IF (PRI_CFG.FDB.DAT.W.TEMPO[3] > 0) AND (NOT PORTA[3]) THEN
// INICIA TIMEOUT
     TIMER4(              // TON
       IN := TRUE,        // [BOOL] Entrada de habilitação da temporização
       PT := TIMEOUT_P[3] // [TIME] Tempo de atraso para ligar
       );
// ATIV FLAG DE ALARME DE PORTA ABERTA
     IF TIMER4.Q THEN
         PUB_XAPP.ALM_PORTA[3] := TRUE;
     END_IF;
ELSE
// CASO O TEMPO SEJA 0 OU A PORTA NÃO ESTIVER ABERTA RESETA ALARME E TEMPOTIZADOR
     PUB_XAPP.ALM_PORTA[3] := FALSE;
     TIMER4(IN := FALSE);
     //TIMER4.Q  := FALSE;
END_IF;

// ********************* PORTA 05 ******************************************
// CASO O TEMPO SETADO SEJA MAIOR QUE ZERO E TENHA SINAL DE PORTA ABERTA
IF (PRI_CFG.FDB.DAT.W.TEMPO[4] > 0) AND (NOT PORTA[4]) THEN
// INICIA TIMEOUT
     TIMER5(              // TON
       IN := TRUE,        // [BOOL] Entrada de habilitação da temporização
       PT := TIMEOUT_P[4] // [TIME] Tempo de atraso para ligar
       );
// ATIV FLAG DE ALARME DE PORTA ABERTA
     IF TIMER5.Q THEN
         PUB_XAPP.ALM_PORTA[4] := TRUE;
     END_IF;
ELSE
// CASO O TEMPO SEJA 0 OU A PORTA NÃO ESTIVER ABERTA RESETA ALARME E TEMPOTIZADOR
     PUB_XAPP.ALM_PORTA[4] := FALSE;
     TIMER5(IN := FALSE);
     //TIMER5.Q  := FALSE;
END_IF;

// ********************* PORTA 06 ******************************************
// CASO O TEMPO SETADO SEJA MAIOR QUE ZERO E TENHA SINAL DE PORTA ABERTA
IF (PRI_CFG.FDB.DAT.W.TEMPO[5] > 0) AND (NOT PORTA[5]) THEN
// INICIA TIMEOUT
     TIMER6(              // TON
       IN := TRUE,        // [BOOL] Entrada de habilitação da temporização
       PT := TIMEOUT_P[5] // [TIME] Tempo de atraso para ligar
       );
// ATIV FLAG DE ALARME DE PORTA ABERTA
     IF TIMER6.Q THEN
         PUB_XAPP.ALM_PORTA[5] := TRUE;
     END_IF;
ELSE
// CASO O TEMPO SEJA 0 OU A PORTA NÃO ESTIVER ABERTA RESETA ALARME E TEMPOTIZADOR
     PUB_XAPP.ALM_PORTA[5] := FALSE;
     TIMER6(IN := FALSE);
     //TIMER6.Q  := FALSE;
END_IF;

// ********************* PORTA 07 ******************************************
// CASO O TEMPO SETADO SEJA MAIOR QUE ZERO E TENHA SINAL DE PORTA ABERTA
IF (PRI_CFG.FDB.DAT.W.TEMPO[6] > 0) AND (NOT PORTA[6]) THEN
// INICIA TIMEOUT
     TIMER7(              // TON
       IN := TRUE,        // [BOOL] Entrada de habilitação da temporização
       PT := TIMEOUT_P[6] // [TIME] Tempo de atraso para ligar
       );
// ATIV FLAG DE ALARME DE PORTA ABERTA
     IF TIMER7.Q THEN
         PUB_XAPP.ALM_PORTA[6] := TRUE;
     END_IF;
ELSE
// CASO O TEMPO SEJA 0 OU A PORTA NÃO ESTIVER ABERTA RESETA ALARME E TEMPOTIZADOR
     PUB_XAPP.ALM_PORTA[6] := FALSE;
     TIMER7(IN := FALSE);
     //TIMER7.Q  := FALSE;
END_IF;

// ********************* PORTA 08 ******************************************
// CASO O TEMPO SETADO SEJA MAIOR QUE ZERO E TENHA SINAL DE PORTA ABERTA
IF (PRI_CFG.FDB.DAT.W.TEMPO[7] > 0) AND (NOT PORTA[7]) THEN
// INICIA TIMEOUT
     TIMER8(              // TON
       IN := TRUE,        // [BOOL] Entrada de habilitação da temporização
       PT := TIMEOUT_P[7] // [TIME] Tempo de atraso para ligar
       );
// ATIV FLAG DE ALARME DE PORTA ABERTA
     IF TIMER8.Q THEN
         PUB_XAPP.ALM_PORTA[7] := TRUE;
     END_IF;
ELSE
// CASO O TEMPO SEJA 0 OU A PORTA NÃO ESTIVER ABERTA RESETA ALARME E TEMPOTIZADOR
     PUB_XAPP.ALM_PORTA[7] := FALSE;
     TIMER8(IN := FALSE);
     //TIMER8.Q  := FALSE;
END_IF;

(*------------------------------------------------------------------------------
       FIM INICIO DO TRATAMENTO DE TIMEOUT DE ALARME DE PORTA ABERTA
================================================================================*)

// TRATA A CONDIÇÃO DE FALTA DE COMUNICAÇÃO COM O SUPERVISÓRIO.
TICK_COM(RUN := LOC_XAPP.WARMUP_OK, TM := T#1M);

IF TICK_COM.EV THEN
   IF PUB_XAPP.STS_SUP THEN
        SEM_SUP          := FALSE;
        PUB_XAPP.STS_SUP := FALSE;
   ELSE
        SEM_SUP := TRUE;
   END_IF;
END_IF;

(*==============================================================================
               TRATA ID DE CONTROLADORES IGUAIS
--------------------------------------------------------------------------------*)
ENDERECO := 0;
FOR I := 0 TO (MAX_EQP-1) DO
      FOR J := 0 TO (MAX_EQP-1) DO
            IF (J <> I) AND (PRI_CFG.FDB.DAT.W.CONF_CTRL[I].HAB_CTRL = 1) AND
            (PRI_CFG.FDB.DAT.W.CONF_CTRL[I].END_EQUIP <> 0) THEN
                   IF PRI_CFG.FDB.DAT.W.CONF_CTRL[I].END_EQUIP = PRI_CFG.FDB.DAT.W.CONF_CTRL[J].END_EQUIP THEN
                       ENDERECO := ENDERECO + 1;
                   END_IF;
            END_IF;
      END_FOR;
END_FOR;

IF ENDERECO > 0 THEN
       PUB_XAPP.END_INV := TRUE;
ELSE
       PUB_XAPP.END_INV := FALSE;
END_IF;

(*------------------------------------------------------------------------------
            FIM TRATA ID DE CONTROLADORES IGUAIS
================================================================================*)

(*==============================================================================
| Atualiza status de RTC invalido
|=============================================================================*)

// Monitora o RTC a cada 1 seg
//
if (TICK_1S.EV) and (debug_block_rtc = false) then

  // Le o relogico calendario do controlador
  ret_code := HILS.READ_RTC(
               LOC_WAPP.RTC_SEG,  // cur_seg,  // segundos corrente do controlador
               LOC_WAPP.RTC_MIN,  // cur_min,  // minutos corrente do controlador
               LOC_WAPP.RTC_HOR,  // cur_hor,  // hora corrente do controlador
               LOC_WAPP.RTC_DIA,  // cur_dia,  // dia corrente do controlador
               LOC_WAPP.RTC_MES,  // cur_mes,  // mes corrente do controlador
               LOC_WAPP.RTC_ANO); // cur_ano); // ano corrente do controlador

  // Testa se leitura do RTC foi realizada com sucesso
  if (ret_code = 0) then
     // Leitura do RTC realizada com sucesso, temos:
     //
     //   cur_seg = segundos corrente do controlador
     //   cur_min = minutos corrente do controlador
     //   cur_hor = hora corrente do controlador
     //   cur_dia = dia corrente do controlador
     //   cur_mes = mes corrente do controlador
     //   cur_ano = ano corrente do controlador

     // testa se ano é valido
     if (LOC_WAPP.RTC_ANO < ANO_VALIDO) then
       LOC_XAPP.STS_INV_RTC := true;
     else
       LOC_XAPP.STS_INV_RTC := false;
     end_if;
  else
     LOC_XAPP.STS_INV_RTC := true;
  end_if;
  // Dia da semana corrente do equipamento (0: Domingo, 1: Segunda,…).
  LOC_WAPP.RTC_WEEK := HILS.GET_SYSVAR(56);
end_if;
