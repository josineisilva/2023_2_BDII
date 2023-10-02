CREATE TYPE extrato AS ( data DATE, valor NUMERIC(6,2), descricao CHAR(15), saldo NUMERIC(9,2) );

CREATE FUNCTION conta_extrato( cod conta.codigo%TYPE, inicio DATE, final DATE ) RETURNS SETOF extrato AS $$
  DECLARE
    lancamento_fields   RECORD;
    ret                 extrato;
  BEGIN
    SELECT INTO ret.saldo COALESCE(SUM(valor),0) FROM lancamento WHERE conta=cod AND data<inicio;
    ret.data = inicio;
    ret.descricao = 'Saldo inicial';
    RETURN NEXT ret;
    FOR lancamento_fields IN SELECT data, valor, grupo FROM lancamento WHERE conta=cod AND data>=inicio AND data <=final ORDER BY data LOOP
      ret.data  = lancamento_fields.data;
      ret.valor = lancamento_fields.valor;
      SELECT INTO ret.descricao descricao FROM grupo WHERE codigo=lancamento_fields.grupo;
      ret.saldo = ret.saldo+lancamento_fields.valor;
      RETURN NEXT ret;
    END LOOP;
    ret.data = final;
    ret.valor = NULL;
    ret.descricao = 'Saldo final';
    RETURN NEXT ret;
    RETURN;
  END;
$$ LANGUAGE plpgsql;
