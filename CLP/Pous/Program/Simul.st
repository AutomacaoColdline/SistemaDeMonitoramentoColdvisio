// POU APENAS PARA SIMULAR CONTROLADORES


//******************************************************************************
//             SIMULAÇÃO PARA OS CONTROALDORES
//******************************************************************************



       IF CONFIGURA THEN
          DRIXELL := ((MAX_EQP-1) - FULLGAUGE);
          SEM2 := DRIXELL - 1;
          J := 0;
          FOR I := 0 TO (MAX_EQP-1) DO
              //PUB_WCFG.CONF_CTRL[J].SEMANA[SEMANA] := 1;
              //J := I + 1;
              //PUB_WCFG.CONF_CTRL[J].SEMANA[SEMANA] := 2;
              //J := I + 1;
              PUB_WCFG.CONF_CTRL[I].SEMANA[SEMANA] := 3;
          END_FOR;
          CONFIGURA := FALSE;
       END_IF;
       IF CONFIGURA2 THEN
          FOR I := 0 TO 9  DO
              PUB_WCFG.CONF_CTRL[I].HORA_LIGAR[SEMANA] := HORA_L;
              PUB_WCFG.CONF_CTRL[I].HORA_DESL[SEMANA]  := HORA_D;
              PUB_WCFG.CONF_CTRL[I].MIN_LIGAR[SEMANA]  := MIN;
              MIN := MIN + 1;
              PUB_WCFG.CONF_CTRL[I].MIN_DESL[SEMANA]   := MIN;
              PUB_WCFG.CONF_CTRL[I].MODELO             := MODELO;
              PUB_WCFG.CONF_CTRL[I].HAB_CTRL           := HABILITA;
              MIN := MIN + 1;
          END_FOR;
          CONFIGURA2 := FALSE;
       END_IF;
       IF CONFIGURA3 THEN
          FOR I := 10 TO (MAX_EQP-1)  DO
              PUB_WCFG.CONF_CTRL[I].HORA_LIGAR[SEMANA] := HORA_L;
              PUB_WCFG.CONF_CTRL[I].HORA_DESL[SEMANA]  := HORA_D;
              PUB_WCFG.CONF_CTRL[I].MIN_LIGAR[SEMANA]  := MIN;
              MIN := MIN + 1;
              PUB_WCFG.CONF_CTRL[I].MIN_DESL[SEMANA]   := MIN;
              PUB_WCFG.CONF_CTRL[I].MODELO             := MODELO;
              PUB_WCFG.CONF_CTRL[I].HAB_CTRL           := HABILITA;
              MIN := MIN + 1;
          END_FOR;
          CONFIGURA3 := FALSE;
         END_IF;
