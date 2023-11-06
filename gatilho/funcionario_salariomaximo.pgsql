ALTER TABLE funcao ADD COLUMN salario_maximo NUMERIC (7,2);

CREATE FUNCTION funcionario_salariomaximo() RETURNS TRIGGER AS $$
  DECLARE
    maximo     funcao.salario_maximo%TYPE;
  BEGIN
    IF NEW.salario IS NOT NULL THEN
      IF NEW.funcao IS NOT NULL THEN
        SELECT INTO maximo salario_maximo FROM funcao WHERE funcao=NEW.funcao;
        IF maximo IS NOT NULL THEN
          IF NEW.salario > maximo THEN
            RAISE EXCEPTION 'Salario maior que o maximo permitido';
          END IF;
        ELSE
          RAISE EXCEPTION 'Falta salario maximo para a funcao';
        END IF;
      ELSE
        RAISE EXCEPTION 'Funcao invalida';
      END IF;
    END IF;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER funcionario_salariomaximo AFTER INSERT OR UPDATE ON funcionario
       FOR EACH ROW EXECUTE PROCEDURE funcionario_salariomaximo();
