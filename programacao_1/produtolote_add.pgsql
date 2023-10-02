CREATE FUNCTION produtolote_add( cod produto.codigo%TYPE, num_lote produtolote.lote%TYPE, quant produtolote.quantidade%TYPE ) RETURNS produtolote.quantidade%TYPE AS $$
  DECLARE
    produto_fields RECORD;
    atual          produtolote.quantidade%TYPE;
    novo           produtolote.quantidade%TYPE;
    existe         BOOLEAN = FALSE;
  BEGIN
    SELECT INTO produto_fields * FROM produto WHERE codigo=cod;
    IF FOUND THEN
      SELECT INTO atual quantidade FROM produtolote WHERE produto=cod AND lote=num_lote;
      IF FOUND THEN
        existe = TRUE;
      END IF;
      novo = COALESCE(atual,0)+quant;
      IF novo < 0 THEN
        RAISE NOTICE 'Quantidade negativa para o produto %, lote %',cod, num_lote;
      END IF;
      IF existe THEN
        UPDATE produtolote SET quantidade = novo WHERE produto=cod AND lote=num_lote;
      ELSE
        INSERT INTO produtolote ( produto, lote, quantidade ) VALUES ( cod, num_lote, novo );
      END IF;
    ELSE
      RAISE EXCEPTION 'Produto % nao encontrado', cod;
    END IF;
    RETURN novo;
  END;
$$ LANGUAGE plpgsql;
