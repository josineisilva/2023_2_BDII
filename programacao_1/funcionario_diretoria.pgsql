CREATE FUNCTION funcionario_diretoria( cod funcionario.matricula%TYPE ) RETURNS TEXT AS $$
  DECLARE
    funcionario_fields  RECORD;
    ret                 TEXT = '';
  BEGIN
    SELECT INTO funcionario_fields * FROM funcionario WHERE matricula=cod;
    IF FOUND THEN
      SELECT INTO ret diretoria.descricao FROM secao,diretoria WHERE secao.codigo=funcionario_fields.secao AND diretoria.codigo=secao.diretoria;
      IF NOT FOUND THEN
        ret = 'nao alocado';
      END IF;
    ELSE
      RAISE EXCEPTION 'Funcionario % nao existe', cod;
    END IF;
    RETURN ret;
  END;
$$ LANGUAGE plpgsql;
