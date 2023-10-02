CREATE FUNCTION lancamento_add( ct conta.codigo%TYPE, gr grupo.codigo%TYPE, dt DATE, vl lancamento.valor%TYPE ) RETURNS VOID AS $$
  DECLARE
    conta_fields RECORD;
    grupo_fields RECORD;
  BEGIN
    SELECT INTO conta_fields * FROM conta WHERE codigo=ct;
    IF FOUND THEN
      SELECT INTO grupo_fields * FROM grupo WHERE codigo=gr;
      IF FOUND THEN
        CASE
          WHEN grupo_fields.tipo = 'R' THEN
            IF vl < 0 THEN
              RAISE EXCEPTION 'Grupos de receita nao aceitam valores negativos';
            END IF;
          WHEN grupo_fields.tipo = 'D' THEN
            IF vl > 0 THEN
              RAISE EXCEPTION 'Grupos de despesa nao aceitam valores positovos';
            END IF;
          ELSE
        END CASE;
        INSERT INTO lancamento ( conta, grupo, data, valor ) VALUES ( ct, gr, dt, vl );
      ELSE
        RAISE EXCEPTION 'Grupo % nao encontrado', gr;
      END IF;
    ELSE
      RAISE EXCEPTION 'Conta % nao encontrada', ct;
    END IF;
  END;
$$ LANGUAGE plpgsql;
