CREATE FUNCTION conta_movimento( cod conta.codigo%TYPE ) RETURNS SETOF RECORD AS $$
  DECLARE
    lancamento_fields   RECORD;
    soma                NUMERIC;
  BEGIN
    soma = 0;
    FOR lancamento_fields IN SELECT lancamento.data, lancamento.valor, grupo.descricao, CAST(0 AS NUMERIC) AS saldo FROM lancamento,grupo WHERE conta=cod AND grupo.codigo=lancamento.grupo ORDER BY data LOOP
      soma = soma + lancamento_fields.valor;
      lancamento_fields.saldo = soma;
      RETURN NEXT lancamento_fields;
    END LOOP;
    RETURN;
  END;
$$ LANGUAGE plpgsql;
