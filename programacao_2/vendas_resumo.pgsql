CREATE TYPE venda_diaria AS ( data DATE, dia NUMERIC(8,2), acumulado NUMERIC(8,2) );

CREATE FUNCTION vendas_resumo() RETURNS SETOF venda_diaria AS $$
  DECLARE
    venda_fields   RECORD;
    ret            venda_diaria;
  BEGIN
    FOR venda_fields IN SELECT data, valor FROM venda ORDER BY data LOOP
      IF ret.data IS NULL THEN
        ret.data = venda_fields.data;
        ret.dia  = 0;
        ret.acumulado = 0;
      END IF;
      IF ret.data != venda_fields.data THEN
        RETURN NEXT ret;
        ret.data = venda_fields.data;
        ret.dia  = venda_fields.valor;
        ret.acumulado = ret.acumulado + venda_fields.valor;
      ELSE
        ret.dia = ret.dia + venda_fields.valor;
        ret.acumulado = ret.acumulado + venda_fields.valor;
      END IF;
    END LOOP;
    IF ret.data IS NOT NULL THEN
      RETURN NEXT ret;
    END IF;
    RETURN;
  END;
$$ LANGUAGE plpgsql;
