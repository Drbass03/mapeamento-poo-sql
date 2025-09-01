CREATE TABLE cliente (
    id_cliente INT IDENTITY PRIMARY KEY,
    nome_cliente VARCHAR(30) NOT NULL,
    tipo CHAR(2) ,
    email VARCHAR(40) UNIQUE,
    dt_nasc DATE,
    cpf VARCHAR(11) NULL,
    cnpj VARCHAR(20) NULL,
    contato VARCHAR(11),
    
    CONSTRAINT chk_tipo CHECK (tipo IN ('PJ', 'PF'))
);

CREATE TABLE endereco (

    id_endereco INT IDENTITY PRIMARY KEY,
    rua VARCHAR (30),
    numero VARCHAR (10),
    cidade VARCHAR (30),
    cep VARCHAR (9),
    cliente_enderecoID INT
    
    CONSTRAINT FK_endereco_cliente 
        FOREIGN KEY (cliente_enderecoID) REFERENCES cliente (id_cliente)
) 

CREATE TABLE produto (

    id_produto INT IDENTITY PRIMARY KEY,
    nome_produto VARCHAR (50),
    desc_produto VARCHAR (100),
    preco DECIMAL (8,2),
    estoque_atual INT,
    categoria_prodID INT,
    
    CONSTRAINT FK_produto_ctg
        FOREIGN KEY (categoria_prodID) REFERENCES categoria (id_categoria) 
);

CREATE TABLE categoria ( --Autorelacionamento categoria ---> subCategoria
    
    id_categoria INT IDENTITY PRIMARY KEY,
    nome VARCHAR(30),
    sb_ctg_nome VARCHAR (30), 
	descricao VARCHAR(100),
    id_categoria_pai INT
    
    CONSTRAINT FK_categoria_pai 
        FOREIGN KEY (id_categoria_pai) REFERENCES categoria(id_categoria)
);

CREATE TABLE pagamento (

    id_pag INT,  
    data_pgto DATETIME,
    valor DECIMAL (8,2),
    forma_pgto VARCHAR (20),
    pgto_pedidoID INT,
    
    CONSTRAINT CK_formaPgto CHECK (forma_pgto IN ('Dinheiro','Credito', 'Debito', 'Pix')),
    CONSTRAINT FK_pgto_pedido 
        FOREIGN KEY (pgto_pedidoID) REFERENCES pedido (id_pedido)
) 


CREATE TABLE pedido (

    id_pedido INT IDENTITY PRIMARY KEY,
    data_pedido DATETIME,
    vl_total DECIMAL (8,2),
    status_pedido VARCHAR (20),
    pedido_cliente INT,
    
    CONSTRAINT CK_statusPedido CHECK (status_pedido IN ('Aprovado', 'Cancelado','Em analise')),
    CONSTRAINT FK_pedido_cliente 
        FOREIGN KEY (pedido_cliente) REFERENCES cliente (id_cliente)
);


CREATE TABLE item_pedido (
    id_item INT IDENTITY PRIMARY KEY,
    qtd_item TINYINT NOT NULL,
    preco_unit DECIMAL(8,2) NOT NULL,
    sub_total AS (qtd_item * preco_unit) PERSISTED,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,

    CONSTRAINT FK_item_pedido 
        FOREIGN KEY (pedido_id) REFERENCES pedido(id_pedido),

    CONSTRAINT FK_item_produto 
        FOREIGN KEY (produto_id) REFERENCES produto(id_produto)
);



CREATE TABLE transportadora (
    
    id_transportadora INT IDENTITY PRIMARY KEY,
    nome VARCHAR (30),
    cnpj VARCHAR (20),
    contato VARCHAR (11)
)


CREATE TABLE NotaFiscal (

    id_NF INT IDENTITY PRIMARY KEY,
    numero BIGINT,
    serie INT,
    dt_emissao DATE DEFAULT GETDATE(),
    valorTotal DECIMAL (8,2),
    valor_frete DECIMAL (8,2) DEFAULT 0,
    nota_pedidoID INT,
    nota_clienteID INT,
    nota_transportadoraID INT,
    CONSTRAINT FK_nota_pedido
        FOREIGN KEY (nota_pedidoID) REFERENCES pedido (id_pedido),
    CONSTRAINT FK_nota_cliente
        FOREIGN KEY (nota_clienteID) REFERENCES cliente (id_cliente),
    CONSTRAINT FK_nota_transportadora
        FOREIGN KEY (nota_transportadoraID) REFERENCES transportadora (id_transportadora)
    
); 

CREATE TABLE ItensNota (

    id_item INT IDENTITY PRIMARY KEY,
    qtd_item TINYINT,
    precoUnit DECIMAL (8,2),
    subTotal AS (qtd_item * precoUnit) PERSISTED,
    item_notaID INT, 
    item_produtoID INT,
    CONSTRAINT FK_itemNF_nota 
        FOREIGN KEY (item_notaID) REFERENCES NotaFiscal (id_NF),
    CONSTRAINT FK_itemNF_produto 
        FOREIGN KEY (item_produtoID) REFERENCES produto (id_pedido)
);





