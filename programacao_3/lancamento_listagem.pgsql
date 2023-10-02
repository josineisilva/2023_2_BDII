CREATE TYPE lancamento_lista AS ( conta CHAR(2), grupo CHAR(2), data DATE, valor NUMERIC(6,2), acumulado NUMERIC(8,2) );

CREATE FUNCTION lancamento_listagem( ct conta.codigo%TYPE, grp grupo.codigo%TYPE, inicio DATE, final DATE ) RETURNS SETOF lancamento_lista AS $$
  DECLARE
    ret                lancamento_lista;
    lancamento_fields  RECORD;
    filtro             TEXT;
    line               TEXT;
    acumulado          NUMERIC(8,2);
  BEGIN
    acumulado = 0;
    line = 'SELECT conta, grupo, data, valor FROM lancamento';
    filtro = '';
    IF CHAR_LENGTH( TRIM( BOTH ct ) ) > 0 THEN
      filtro = ' conta = ' || quote_literal( ct );
    END IF;
    IF CHAR_LENGTH( TRIM( BOTH grp ) ) > 0 THEN
      IF CHAR_LENGTH( TRIM( BOTH filtro ) ) > 0 THEN
        filtro = filtro || ' AND ';
      END IF;
      filtro = filtro || ' grupo = ' || quote_literal( grp );
    END IF;
    IF inicio IS NOT NULL THEN
      IF CHAR_LENGTH( TRIM( BOTH filtro ) ) > 0 THEN
        filtro = filtro || ' AND ';
      END IF;
      filtro = filtro || ' data >= ' || quote_literal( inicio );
    END IF;
    IF final IS NOT NULL THEN
      IF CHAR_LENGTH( TRIM( BOTH filtro ) ) > 0 THEN
        filtro = filtro || ' AND ';
      END IF;
      filtro = filtro || ' data <= ' || quote_literal( final );
    END IF;
    IF CHAR_LENGTH( TRIM( BOTH filtro ) ) > 0 THEN
      line = line || ' WHERE ' || filtro;
    END IF;
    line = line || ' ORDER BY data';
    FOR lancamento_fields IN EXECUTE line LOOP
      acumulado = acumulado + COALESCE(lancamento_fields.valor,0);
      ret.conta = lancamento_fields.conta;
      ret.grupo = lancamento_fields.grupo;
      ret.data = lancamento_fields.data;
      ret.valor = lancamento_fields.valor;
      ret.acumulado = acumulado;
      RETURN NEXT ret;
    END LOOP;
    RETURN;
  END;
$$ LANGUAGE plpgsql;
