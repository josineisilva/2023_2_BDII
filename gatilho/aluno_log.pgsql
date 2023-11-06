CREATE FUNCTION aluno_log() RETURNS TRIGGER AS $$
  DECLARE
    op             CHAR(1);
    log_matricula  aluno.matricula%TYPE;
    log_nome       aluno.nome%TYPE;
  BEGIN
    op = SUBSTR(TG_OP,1,1);
    IF op = 'I' THEN
      log_matricula = NEW.matricula;
      log_nome      = NEW.nome;
    END IF;
    IF op = 'D' THEN
      log_matricula = OLD.matricula;
      log_nome      = OLD.nome;
    END IF;
    IF op = 'U' THEN
      log_matricula = OLD.matricula;
      log_nome      = OLD.nome;
    END IF;
    INSERT INTO alunolog ( data, usuario, operacao, matricula, nome ) 
                  VALUES ( current_timestamp, current_user, op, log_matricula, log_nome );
    RETURN NULL;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER aluno_log AFTER INSERT OR UPDATE OR DELETE ON aluno
       FOR EACH ROW EXECUTE PROCEDURE aluno_log();
