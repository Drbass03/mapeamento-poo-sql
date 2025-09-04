import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

// Classe abstrata Pessoa
public abstract class Pessoa {
    private int id;
    private String nome;
    private String email;
    private String telefone;

    // Getters e Setters
}

// Pessoa Física
public class PessoaFisica extends Pessoa {
    private String cpf;
    private LocalDate dataNascimento;

    // Getters e Setters
}

// Pessoa Jurídica
public class PessoaJuridica extends Pessoa {
    private String cnpj;
    private String razaoSocial;

    // Getters e Setters 
}

// Categoria de Produto
public class CategoriaProduto {
    private int id;
    private String nome;
    private String descricao;

    // Getters e Setters
}

// Produto
public class Produto {
    private int id;
    private String nome;
    private String descricao;
    private BigDecimal preco;
    private int estoqueAtual;
    private CategoriaProduto categoria;

    // Getters e Setters
}

// Item do Pedido
public class ItemPedido {
    private int id;
    private Produto produto;
    private int quantidade;
    private BigDecimal precoUnitario;

    public BigDecimal calcularSubtotal() {
        return precoUnitario.multiply(new BigDecimal(quantidade));
    }

    // Getters e Setters
}

// Endereço de Entrega
public class EnderecoEntrega {
    private int id;
    private String rua;
    private String numero;
    private String cidade;
    private String estado;
    private String cep;

    // Getters e Setters
} 

// Forma de Pagamento (Enum)
public enum FormaPagamento {
    CARTAO_CREDITO,
    CARTAO_DEBITO,
    BOLETO,
    PIX,
    TRANSFERENCIA
}

// Pagamento
public class Pagamento {
    private int id;
    private LocalDateTime dataPagamento;
    private BigDecimal valorPago;
    private FormaPagamento forma;

    // Getters e Setters
}

// Pedido
public class Pedido {
    private int id;
    private LocalDateTime dataCriacao;
    private Pessoa cliente;
    private List<ItemPedido> itens;
    private List<Pagamento> pagamentos;
    private EnderecoEntrega enderecoEntrega;

    public BigDecimal calcularTotal() {
        return itens.stream()
                .map(ItemPedido::calcularSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    // Getters e Setters
} 

 public class NotaFiscal {
    private int id;
    private String numero;          // Número da NF
    private String serie;           // Série da NFemiten
    private LocalDateTime dataEmissao;
    private Pedido pedido;          // Relacionamento com Pedido
    private Pessoa emitente;        // Quem está emitindo (vendedor)
    private Pessoa destinatario;    // Cliente
    private List<ItemNotaFiscal> itens;
    private BigDecimal valorTotal; }



public class ItemNotaFiscal {
    private int id;
    private Produto produto;
    private int quantidade;
    private BigDecimal precoUnitario;
    private BigDecimal subtotal;

    public BigDecimal calcularSubtotal() {
        return precoUnitario.multiply(new BigDecimal(quantidade));
    } 
    }


public class Transportadora {
    private int id;
    private String nome;
    private String cnpj;
    private String telefone;
   

    // Getters e Setters
} 











