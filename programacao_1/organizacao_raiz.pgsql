CREATE FUNCTION organizacao_raiz( n organizacao.nome%TYPE ) RETURNS TEXT AS $$
  DECLARE
    s    organizacao.nome%TYPE;
    ret  TEXT = '';
  BEGIN
    SELECT INTO s superior FROM organizacao WHERE nome=n;
    IF FOUND THEN
      IF s IS NULL THEN
        ret = n;
      ELSE
        ret = organizacao_raiz( s );
      END IF;
      RETURN ret;
    ELSE
      RAISE EXCEPTION 'Nome % nao encontrado', n;
    END IF;
    RETURN ret;
  END;
$$ LANGUAGE plpgsql;
