CREATE TYPE produto_saldo AS ( data DATE, saldo INTEGER );

CREATE FUNCTION saldo_diario( cod produto.codigo%TYPE, mes INTEGER, ano INTEGER ) RETURNS SETOF produto_saldo AS $$
  DECLARE
    dia     DATE;
    ret     produto_saldo;
    saldo   INTEGER;
    e       INTEGER;
    s       INTEGER;
  BEGIN
    dia = CAST( ano || '/' || mes || '/01' AS DATE );
    SELECT INTO e SUM(quantidade) FROM entrada WHERE produto=cod AND data<dia;
    SELECT INTO s SUM(quantidade) FROM saida WHERE produto=cod AND data<dia;
    saldo = COALESCE(e,0)-COALESCE(s,0);
    WHILE ( EXTRACT( MONTH FROM dia ) = mes ) AND ( EXTRACT( YEAR FROM dia ) = ano ) LOOP
      SELECT INTO e SUM(quantidade) FROM entrada WHERE produto=cod AND data=dia;
      SELECT INTO s SUM(quantidade) FROM saida WHERE produto=cod AND data=dia;
      saldo = saldo+ COALESCE(e,0)-COALESCE(s,0);
      ret.data = dia;
      ret.saldo = saldo;
      RETURN NEXT ret;
      dia = dia + INTERVAL '1 day';
    END LOOP;
    RETURN;
  END;
$$ LANGUAGE plpgsql;
