
// Incrementa contador sequencial e circular
VALUE := VALUE + 1.0;
if VALUE > 20000000.0 then
  VALUE := 0;    // reseta contador ao atingir o limite de contagem
end_if;
