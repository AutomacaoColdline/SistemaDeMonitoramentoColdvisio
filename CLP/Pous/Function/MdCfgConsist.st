



// Tempo de atraso no powerup [seg]
if (APP_WCFG.T_POWERUP < T_POWERUP_MIN) or
   (APP_WCFG.T_POWERUP > T_POWERUP_MAX) then
   // atribui valor default
   APP_WCFG.T_POWERUP := DEF_WCFG.T_POWERUP;
   IDX_ERR_CFG := IDX;         // indice do prametro invalido
   RESULT := AEC_INV_CFG_BASE; // base de configuração invalido
end_if;
IDX := IDX + 1;                // indice de parametros consistidos



