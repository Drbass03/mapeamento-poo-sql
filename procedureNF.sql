CREATE OR ALTER PROCEDURE sp_gerarNotaFiscal
    @id_pedido INT,
    @valor_frete DECIMAL(8,2) = 0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @valorTotal DECIMAL(8,2);
    DECLARE @numeroNF BIGINT;

    BEGIN TRY
        BEGIN TRAN;

        -- Calcula o total dos itens do pedido
        SELECT @valorTotal = SUM(sub_total)
        FROM item_pedido
        WHERE pedido_id = @id_pedido;

        -- Gera o número sequencial da NF
        SET @numeroNF = NEXT VALUE FOR seq_NumeroNF;

        -- Insere a NF
        INSERT INTO NotaFiscal (nota_pedidoID, numeroNF, valorTotal, valor_frete)
        VALUES (@id_pedido, @numeroNF, @valorTotal + @valor_frete, @valor_frete);

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
