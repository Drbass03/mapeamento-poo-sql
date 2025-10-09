--Seq criada para simular a geração de novas notas a medida em que novos pedidos são aprovados.

CREATE SEQUENCE seq_numeroNF
    START WITH 2025001
    INCREMENT BY 1;

CREATE SEQUENCE seq_serieNF
    START WITH 1
    INCREMENT BY 1;


/* Procedure responsável por gerar a nota fiscal, a partir do recebimento dos parametros: id do pedido, valor de frete e transportador responsável
pela entrega */

CREATE PROCEDURE gerar_NF 
    @id_pedido INT,  
    @vl_frete DECIMAL (8,2),
    @transportadora INT 
AS
BEGIN 
    SET NOCOUNT ON;
        
    -- Validação de parâmetros
    IF @id_pedido IS NULL
    BEGIN
        THROW 50001, 'Parametro @id_pedido não pode ser NULL', 1;
    END;

    IF @transportadora IS NULL
    BEGIN
        THROW 50002, 'Parametro @transportadora não pode ser NULL', 2;
    END;

    DECLARE @vl_total DECIMAL(8,2);
    DECLARE @num_NF BIGINT;
    DECLARE @num_serie INT;
    DECLARE @idNF INT;
    DECLARE @id_cliente INT;

    BEGIN TRY
        BEGIN TRAN;
        
        
        SET @num_NF = NEXT VALUE FOR seq_numeroNF;
        SET @num_serie = NEXT VALUE FOR seq_serieNF; 

        
        SELECT @id_cliente = p.pedido_clienteID
        FROM pedido p
        WHERE p.id_pedido = @id_pedido;

        
        SELECT @vl_total = SUM(sub_total)
        FROM item_pedido
        WHERE pedido_id = @id_pedido; 

        -- Insere cabeçalho da Nota Fiscal
        INSERT INTO NotaFiscal (
            numero, serie, dt_emissao, valorTotal, valor_frete,
            nota_pedidoID, nota_clienteID, nota_transportadoraID
        )
        VALUES (
            @num_NF, @num_serie, GETDATE(), @vl_total, @vl_frete,
            @id_pedido, @id_cliente, @transportadora
        );

        -- Captura o ID gerado
        SET @idNF = SCOPE_IDENTITY();

        -- Insere itens da NF
        INSERT INTO ItensNota (qtd_item, precoUnit, item_notaID, item_produtoID)
        SELECT 
            ip.qtd_item,
            ip.preco_unit,
            @idNF,
            ip.produto_id
        FROM item_pedido ip
        WHERE ip.pedido_id = @id_pedido;
      
        -- Atualiza o valor total da NF considerando o frete
        UPDATE nf 
        SET valorTotal = (
            SELECT SUM(inf.subTotal)
            FROM ItensNota inf
            WHERE inf.item_notaID = @idNF
        ) + ISNULL(@vl_frete, 0)
        FROM NotaFiscal nf 
        WHERE id_NF = @idNF;

        COMMIT;
    END TRY

    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
