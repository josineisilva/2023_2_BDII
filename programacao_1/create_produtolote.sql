CREATE TABLE produtolote (
                         produto    CHAR(2) REFERENCES produto,
                         lote       CHAR(10),
                         quantidade INTEGER,
                         PRIMARY KEY ( produto, lote )
                         );
