CREATE FUNCTION aluno_inserir( aluno_nome aluno.nome%TYPE, aluno_rg aluno.rg%TYPE, aluno_curso aluno.curso%TYPE, aluno_serie aluno.serie%TYPE ) RETURNS sala.turma%TYPE AS $$
  DECLARE
    nova_turma        sala.turma%TYPE;
    nova_quantidade   INTEGER;
    menor_turma       sala.turma%TYPE;
    menor_quantidade  INTEGER;
  BEGIN
    PERFORM * FROM aluno WHERE rg=aluno_rg;
    IF NOT FOUND THEN
      FOR nova_turma IN SELECT turma FROM sala WHERE curso=aluno_curso AND serie=aluno_serie LOOP
        SELECT INTO nova_quantidade COUNT(*) FROM aluno WHERE curso=aluno_curso AND serie=aluno_serie AND turma=nova_turma;
        IF menor_turma IS NULL OR nova_quantidade<menor_quantidade THEN
          menor_turma = nova_turma;
          menor_quantidade = nova_quantidade;
        END IF;
      END LOOP;
      IF menor_turma IS NOT NULL THEN
        INSERT INTO aluno ( nome, rg, curso, serie, turma ) VALUES ( aluno_nome, aluno_rg, aluno_curso, aluno_serie, menor_turma );
      ELSE
        RAISE EXCEPTION 'Nao foi encontrada turma para o curso % serie %', aluno_curso, aluno_serie;
      END IF;
    ELSE
      RAISE EXCEPTION 'RG % ja cadastrado', aluno_rg;
    END IF;
    RETURN menor_turma;
  END;
$$ LANGUAGE plpgsql;
