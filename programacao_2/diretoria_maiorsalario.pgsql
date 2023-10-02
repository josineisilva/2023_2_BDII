CREATE FUNCTION diretoria_maiorsalario( cod diretoria.codigo%TYPE ) RETURNS funcionario AS $$
  DECLARE
    ret         funcionario;
    registro    funcionario;
  BEGIN
    FOR registro IN SELECT * FROM funcionario WHERE ( SELECT diretoria FROM secao WHERE codigo=funcionario.secao )=cod LOOP
      IF ret.salario IS NULL OR registro.salario>ret.salario THEN
        ret = registro;
      END IF;
    END LOOP;
    RETURN ret;
  END;
$$ LANGUAGE plpgsql;
