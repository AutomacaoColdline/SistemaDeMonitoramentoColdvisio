
    // Calcula Taxa de Sucesso e Falha na comunicação
    X[0] := (EV_OK);
    X[1] := (EV_NOK);
    X[2] := X[0] + X[1];

    // Inicializa KPI
    R[0] := 0.0; // KPI OK
    R[1] := 0.0; // KPI NOK

    // Calcula KPI se existem amostras de dados
    if (X[2] > 0) then
      // Calcula KPI OK
      if (EV_OK > 0) then
        R[0] := 100.0 * X[0] / X[2];
      end_if;
      // Calcula KPI NOK
      if (EV_NOK > 0) then
        R[1] := 100.0 * X[1] / X[2];
      end_if;
    end_if;

    // Retorna resultado do KPI
    KPI_OK  := REAL_TO_INT(R[0]); // Saida: Procentagem de taxa de comunicação OK (0..100%)
    KPI_NOK := REAL_TO_INT(R[1]); // Saida: Procentagem de taxa de comunicação NOK (0..100%)
