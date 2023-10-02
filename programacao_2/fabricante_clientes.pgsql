CREATE FUNCTION fabricante_clientes( cod fabricante.codigo%TYPE ) RETURNS SETOF venda_cliente AS $$
  BEGIN
    RETURN QUERY  SELECT cliente.nome, automovel.modelo, CAST( venda.valor-automovel.preco AS NUMERIC(7,2) ) AS lucro FROM venda, automovel, cliente WHERE automovel.fabricante=cod AND automovel.codigo=venda.automovel AND cliente.codigo=venda.cliente;
  END;
$$ LANGUAGE plpgsql;
