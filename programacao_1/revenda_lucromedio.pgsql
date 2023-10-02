CREATE FUNCTION revenda_lucromedio( cod revenda.codigo%TYPE ) RETURNS venda.valor%TYPE AS $$
  DECLARE
    lucro       venda.valor%TYPE := 0;
    quantidade  INTEGER;
    ret         venda.valor%TYPE;
  BEGIN
    SELECT INTO quantidade COUNT(*) FROM venda WHERE revenda=cod;
    IF quantidade > 0 THEN
      SELECT INTO lucro SUM(venda.valor-automovel.preco) FROM venda,automovel WHERE revenda=cod AND automovel.codigo=venda.automovel;
      ret = COALESCE(lucro,0)/quantidade;
    ELSE
      ret = 0;
    END IF;
    RETURN ret;
  END;
$$ LANGUAGE plpgsql;
