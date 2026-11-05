/*
===============================================================================
TRABALHO PRÁTICO 01 - GESTÃO DE BANCO DE DADOS (PostgreSQL)

Lucas Eduardo Silva Amorim RA:007274


JUSTIFICATIVA do tema:
Escolhi esse tema de vendas de camisas de futebol pois é um assunto em alta no território mundial 
e além de gostar muito e praticar o esporte viso muito os uniformes e trabalhar com esse tema é muito satisfatório 
esse mercado pois atingi fortemente o publico de crianças jovens e adultos e a loja com o objetivo de oferecer qualidade rapidez e um preço 
satisfatório ao meu público para expandir o negócio.

O mercado de camisas esportivas movimenta um grande volume de vendas diárias e 
exige uma gestão eficiente do catálogo de produtos (clubes, seleções, edições 
retro, edições comemorativas), controle de estoque por tamanho, gestão de 
cadastro de clientes e histórico detalhado de compras/pedidos. 
===============================================================================
*/

-- ============================================================================
-- 1.TABELAS E RESTRIÇÕES
-- ============================================================================

/*
 TABELA: clientes
  Objetivo operacional da tabela clientes é armazenar os dados de cada cliente para o cadastro na loja 
  e ao finalizar a compra enviar o produto para o seu destinatário
*/
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    cidade VARCHAR(60) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    data_cadastro DATE DEFAULT CURRENT_DATE
);

/*
  TABELA: categorias
  Objetivo operacional da tabela categoria é dizer ce são camisas internacionais, nacionais, seleções ou rêtros
*/
CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nome_categoria VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT
);

/*
  TABELA: produtos
  Objetivo operacional da tabela produto é  manter o catálogo de camisas de time ativas na loja, 
  controlando o preço unitário, fornecedor, marca, tamanho e saldo em estoque.
*/
CREATE TABLE produtos (
    id_produto SERIAL PRIMARY KEY,
    id_categoria INT NOT NULL,
    nome_camisa VARCHAR(100) NOT NULL,
    time_selecao VARCHAR(60) NOT NULL,
    tamanho VARCHAR(5) NOT NULL,
    preco NUMERIC(10,2) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_produtos_categorias FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE RESTRICT,
    -- RESTRIÇÃO CHECK 1: O preço da camisa deve ser maior que zero e o estoque não pode ser negativo
    CONSTRAINT chk_preco_positivo CHECK (preco > 0),
    CONSTRAINT chk_estoque_nao_negativo CHECK (quantidade_estoque >= 0)
);

/*
   TABELA: pedidos
  Objetivo operacional da tabela pedidos é registrar os cabeçalhos das transações de venda realizadas, 
  vinculando cada compra a um cliente especifico, com data, status do pedido e valor total.
*/
CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pedido VARCHAR(20) NOT NULL DEFAULT 'Pendente',
    valor_total NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_pedidos_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE,
    -- RESTRIÇÃO CHECK 2: Validação dos status permitidos para o fluxo do pedido
    CONSTRAINT chk_status_valido CHECK (status_pedido IN ('Pendente', 'Pago', 'Enviado', 'Entregue', 'Cancelado'))
);

/*
   TABELA: itens_pedido
  Objetivo operacional da tabela itens_pedido é detalhar cada produto individual que compõe um pedido, 
  registrando a quantidade comprada de cada camisa e o preço unitário cobrado no momento do pedido.
*/
CREATE TABLE itens_pedido (
    id_item SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario NUMERIC(10,2) NOT NULL,
    CONSTRAINT fk_itens_pedidos FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    CONSTRAINT fk_itens_produtos FOREIGN KEY (id_produto) REFERENCES produtos(id_produto) ON DELETE RESTRICT,
    -- RESTRIÇÃO CHECK 3: Garante que a quantidade do item no pedido seja sempre maior que zero
    CONSTRAINT chk_quantidade_positiva CHECK (quantidade > 0)
);


-- ============================================================================
-- 2. POPULAÇÃO DE DADOS 
-- ============================================================================

-- Inserindo Categorias 
INSERT INTO categorias (nome_categoria, descricao) VALUES
('Clubes Nacionais', 'Camisas oficiais de times do futebol brasileiro'),
('Clubes Internacionais', 'Camisas de clubes europeus e das Américas'),
('Seleções Nacionais', 'Mantos de seleções que disputam a Copa do Mundo e torneios continentais'),
('Retrô / Clássicas', 'Réplicas e reedições históricas de temporadas marcantes'),
('Edições Especiais', 'Edições comemorativas, de pré-jogo e terceiros uniformes exclusivos');

-- Inserindo Clientes 
INSERT INTO clientes (nome, email, cpf, telefone, cidade, estado) VALUES
('Lucas Amorim', 'lucas.amorim@email.com', '111.222.333-01', '(35) 99881-1122', 'Passos', 'MG'),
('Tatiane Silva', 'tatiane.silva@email.com', '222.333.444-02', '(35) 99772-2233', 'São Sebastião do Paraíso', 'MG'),
('Murilo Ramon', 'murilo.ramon@email.com', '333.444.555-03', '(11) 99663-3344', 'São Paulo', 'SP'),
('Luan Silva', 'luan.silva@email.com', '444.555.666-04', '(21) 99554-4455', 'Rio de Janeiro', 'RJ'),
('Davi Amorim', 'davi.amorim@email.com', '555.666.777-05', '(31) 99445-5566', 'Belo Horizonte', 'MG'),
('David Silva', 'david.silva@email.com', '666.777.888-06', '(41) 99336-6677', 'Curitiba', 'PR');

-- Inserindo Produtos 
INSERT INTO produtos (id_categoria, nome_camisa, time_selecao, tamanho, preco, quantidade_estoque) VALUES
(1, 'Camisa I Principal 2025/2026', 'Flamengo', 'G', 349.90, 25),
(1, 'Camisa II Visitante 2025/2026', 'Palmeiras', 'M', 329.90, 18),
(1, 'Camisa I Oficial 2025/2026', 'Atletico Mineiro', 'GG', 349.90, 12),
(2, 'Camisa Home 2025/2026', 'Real Madrid', 'M', 449.90, 30),
(2, 'Camisa Away 2025/2026', 'Barcelona', 'P', 429.90, 15),
(3, 'Camisa Titular Brasil Amarela', 'Seleção Brasileira', 'G', 399.90, 40),
(4, 'Camisa Retrô 1981 Mundial', 'Flamengo', 'L', 299.90, 10),
(5, 'Camisa Black Edition Especial', 'Corinthians', 'M', 379.90, 8);

-- Inserindo Pedidos 
INSERT INTO pedidos (id_cliente, data_pedido, status_pedido, valor_total) VALUES
(1, '2026-10-01 10:30:00', 'Entregue', 699.80),
(2, '2026-10-05 14:15:00', 'Entregue', 449.90),
(3, '2026-10-12 09:00:00', 'Enviado', 779.80),
(1, '2026-10-20 16:45:00', 'Pago', 399.90),
(4, '2026-10-28 11:20:00', 'Pago', 349.90),
(5, '2026-11-02 18:00:00', 'Pendente', 429.90);

-- Inserindo Itens dos Pedidos 
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 349.90), -- Pedido 1: Camisa Flamengo 2025
(1, 3, 1, 349.90), -- Pedido 1: Camisa Atletico Mineiro
(2, 4, 1, 449.90), -- Pedido 2: Camisa Real Madrid
(3, 2, 1, 329.90), -- Pedido 3: Camisa Palmeiras
(3, 4, 1, 449.90), -- Pedido 3: Camisa Real Madrid (preço c/ desconto aplicado no combo)
(4, 6, 1, 399.90), -- Pedido 4: Camisa Seleção Brasileira
(5, 1, 1, 349.90), -- Pedido 5: Camisa Flamengo
(6, 5, 1, 429.90); -- Pedido 6: Camisa Barcelona


-- ============================================================================
-- 3. CONSULTAS SQL 
-- ============================================================================

-- CONSULTA 1: Lista detalhada de vendas
-- Finalidade: Visualizar as compras finalizadas com nome do cliente e status.
SELECT 
    p.id_pedido,
    c.nome AS nome_cliente,
    c.cidade,
    c.estado,
    p.data_pedido,
    p.status_pedido,
    p.valor_total
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE p.status_pedido IN ('Pago', 'Enviado', 'Entregue')
ORDER BY p.data_pedido DESC;


-- CONSULTA 2: Detalhamento dos produtos comprados por pedido
-- Finalidade: Exibir os itens de cada carrinho com categoria e preço cobrado.
SELECT 
    p.id_pedido,
    c.nome AS cliente,
    prod.nome_camisa,
    prod.time_selecao,
    cat.nome_categoria,
    ip.quantidade,
    ip.preco_unitario,
    (ip.quantidade * ip.preco_unitario) AS subtotal
FROM itens_pedido ip
INNER JOIN pedidos p ON ip.id_pedido = p.id_pedido
INNER JOIN clientes c ON p.id_cliente = c.id_cliente
INNER JOIN produtos prod ON ip.id_produto = prod.id_produto
INNER JOIN categorias cat ON prod.id_categoria = cat.id_categoria
ORDER BY p.id_pedido, prod.nome_camisa;


-- CONSULTA 3: Total faturado e quantidade de pedidos por categoria 
-- Finalidade: Análise de receita e desempenho por tipo/categoria de camisa.
SELECT 
    cat.nome_categoria,
    COUNT(DISTINCT p.id_pedido) AS total_pedidos,
    SUM(ip.quantidade) AS total_camisas_vendidas,
    SUM(ip.quantidade * ip.preco_unitario) AS faturamento_total
FROM itens_pedido ip
INNER JOIN produtos prod ON ip.id_produto = prod.id_produto
INNER JOIN categorias cat ON prod.id_categoria = cat.id_categoria
INNER JOIN pedidos p ON ip.id_pedido = p.id_pedido
WHERE p.status_pedido != 'Cancelado'
GROUP BY cat.nome_categoria
ORDER BY faturamento_total DESC;


-- CONSULTA 4: Clientes com maior valor acumulado de compras 
-- Finalidade: Identificar clientes VIP / recorrentes com gastos acima de R$ 400.00.
SELECT 
    c.id_cliente,
    c.nome,
    c.email,
    COUNT(p.id_pedido) AS qtd_pedidos_realizados,
    SUM(p.valor_total) AS total_gasto
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nome, c.email
HAVING SUM(p.valor_total) >= 400.00
ORDER BY total_gasto DESC;