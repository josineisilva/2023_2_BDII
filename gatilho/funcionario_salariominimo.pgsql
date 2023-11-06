ALTER TABLE funcao ADD COLUMN salario_minimo NUMERIC (7,2);

CREATE FUNCTION funcionario_salariominimo() RETURNS TRIGGER AS $$
  DECLARE
    minimo     funcao.salario_minimo%TYPE;
  BEGIN
    IF NEW.salario IS NOT NULL THEN
      IF NEW.funcao IS NOT NULL THEN
        SELECT INTO minimo salario_minimo FROM funcao WHERE funcao=NEW.funcao;
        IF minimo IS NOT NULL THEN
          IF NEW.salario < minimo THEN
            NEW.salario = minimo;
          END IF;
        ELSE
          RAISE EXCEPTION 'Falta salario minimo para a funcao';
        END IF;
      ELSE
        RAISE EXCEPTION 'Funcao invalida';
      END IF;
    END IF;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER funcionario_salariominimo BEFORE INSERT OR UPDATE ON funcionario
       FOR EACH ROW EXECUTE PROCEDURE funcionario_salariominimo();
