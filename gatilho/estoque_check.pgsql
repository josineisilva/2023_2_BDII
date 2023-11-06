CREATE FUNCTION estoque_check() RETURNS TRIGGER AS $$ 
  DECLARE
    produto_codigo  CHAR(2);
    saldo           INTEGER;
  BEGIN
    IF TG_OP = 'UPDATE' THEN
      IF NEW.produto != OLD.produto THEN
        RAISE EXCEPTION 'Nao e permitido alterar o codigo do produto';
      END IF;
    END IF;
    IF TG_OP = 'INSERT' THEN
      produto_codigo = NEW.produto;
    ELSE
      produto_codigo = OLD.produto;
    END IF;
    SELECT INTO saldo COALESCE((SELECT SUM(quantidade) FROM entrada WHERE produto=produto_codigo),0)-
                      COALESCE((SELECT SUM(quantidade) FROM saida   WHERE produto=produto_codigo),0);
    IF saldo < 0 THEN
      RAISE EXCEPTION 'Saldo do produto nao pode ficar negativo';
    END IF;
    RETURN NULL;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER entrada_check AFTER UPDATE OR INSERT OR DELETE ON entrada FOR EACH ROW
  EXECUTE PROCEDURE estoque_check();

CREATE TRIGGER saida_check AFTER UPDATE OR INSERT OR DELETE ON saida FOR EACH ROW
  EXECUTE PROCEDURE estoque_check();
