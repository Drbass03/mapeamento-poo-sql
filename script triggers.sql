CREATE TRIGGER TRG_preencheTipo 
ON cliente
AFTER INSERT, UPDATE 
AS  
BEGIN
    
    IF EXISTS (
        SELECT 1 
        FROM INSERTED 
        WHERE CPF IS NOT NULL AND CNPJ IS NOT NULL
    )

    BEGIN 
        RAISERROR('Cliente não pode ter CPF e CNPJ ao mesmo tempo.', 16, 1);
        ROLLBACK; 
        RETURN;
    END

    BEGIN TRAN 

    UPDATE cliente 
    SET tipo = 'PJ'
    WHERE id_cliente IN (
        SELECT id_cliente 
        FROM INSERTED 
        WHERE CNPJ IS NOT NULL AND CPF IS NULL
    );


    UPDATE cliente 
    SET tipo = 'PF'
    WHERE id_cliente IN (
        SELECT id_cliente
        FROM INSERTED 
        WHERE CNPJ IS NULL AND CPF IS NOT NULL
    );

    COMMIT
END


CREATE TRIGGER TRG_total_pedido
ON item_pedido  
AFTER INSERT, UPDATE  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    BEGIN TRY  
        BEGIN TRAN;  
  
        -- Atualiza o total do pedido  
        UPDATE p  
        SET vl_total = (  
            SELECT SUM(sub_total)  
            FROM item_pedido ip  
            WHERE ip.pedido_id = p.id_pedido  
        )  
        FROM pedido p  
        WHERE p.id_pedido IN (  
            SELECT DISTINCT pedido_id FROM inserted  
        )
        
        COMMIT;  
    END TRY  
    
    BEGIN CATCH  
        ROLLBACK;  
        THROW;  
    END CATCH  
END
                  
