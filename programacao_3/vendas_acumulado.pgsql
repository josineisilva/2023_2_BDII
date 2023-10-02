CREATE FUNCTION vendas_acumulado( cid revenda.cidade%TYPE, fab fabricante.nome%TYPE, mod automovel.modelo%TYPE ) RETURNS SETOF venda_diaria AS $$
  DECLARE
    venda_fields   RECORD;
    ret            venda_diaria;
    line           TEXT;
  BEGIN
    line = 'SELECT data, valor FROM venda,automovel,revenda,fabricante WHERE automovel.codigo=venda.automovel ';
    line = line || 'AND revenda.codigo=venda.revenda AND fabricante.codigo=automovel.fabricante';
    IF CHAR_LENGTH( TRIM( BOTH cid ) ) > 0 THEN
      line = line || ' AND revenda.cidade = ' || quote_literal( cid );
    END IF;
    IF CHAR_LENGTH( TRIM( BOTH fab ) ) > 0 THEN
      line = line || ' AND fabricante.nome = ' || quote_literal( fab );
    END IF;
    IF CHAR_LENGTH( TRIM( BOTH mod ) ) > 0 THEN
      line = line || ' AND automovel.modelo = ' || quote_literal( mod );
    END IF;
    line = line || ' ORDER BY data';
    FOR venda_fields IN EXECUTE line LOOP
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
