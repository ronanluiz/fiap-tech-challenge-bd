-- Inserção de dados (exemplos)

INSERT INTO customer (customer_id, name, email, cpf) VALUES
('f8f0414d-db16-42d4-ab1f-444d53b1fd3e', 'João da Silva', 'joao@email.com', '12345678901'),
('1c36d785-0ea1-4d3f-8b21-27914969b366', 'Maria Oliveira', 'maria@email.com', '98765432109');

-- Inserção de dados na tabela product
INSERT INTO product (
    product_id, name, description, category, price, status, 
    time_to_prepare, is_available, created_at
) VALUES
(
    '08518e58-fcc3-4298-aa5a-50d954ad3bc3',
    'X-Burguer com Queijo e Bacon',
    'Três hamburgueres, alface, queijo, molho espacial, cebola, pickles e pão com gergelin',
    0, -- Lanche (assumindo que "Lanche" seja representado como 0 no enum)
    10.00,
    1, -- Status 1 (provavelmente representa um valor válido no enum de status)
    10, -- 10 minutos de preparo, convertido para valor inteiro    
    FALSE,
    '2025-01-15T13:25:37.6893259Z'
),
(
    '6a4b8d15-74ea-4b54-bec5-2d9f64fed573',
    'Batata Frita Crocante',
    'Porção de batatas fritas crocantes, ideal para acompanhar qualquer lanche',
    1, -- Acompanhamento (assumindo que "Acompanhamento" seja representado como 1 no enum)
    5.00,
    1,
    5,
    TRUE,
    '2025-01-15T14:00:00Z'
),
(
    '964e8baf-5984-4f61-aae5-d2a4730b9882',
    'Refrigerante Cola 350ml',
    'Lata de refrigerante sabor cola, gelado e refrescante',
    2, -- Bebida (assumindo que "Bebida" seja representado como 2 no enum)
    3.50,
    1,
    0,
    TRUE,
    '2025-01-15T14:15:00Z'
),
(
    'cdc2f171-ad5f-475f-8707-14c103207ad8',
    'Mousse de Maracujá Cremoso',
    'Sobremesa cremosa feita com maracujá fresco, ideal para adoçar o dia',
    3, -- Sobremesa (assumindo que "Sobremesa" seja representado como 3 no enum)
    4.00,
    1,
    3,
    TRUE,
    '2025-01-15T14:30:00Z'
);

-- Para inserir em "order", precisamos primeiro obter os IDs dos clientes inseridos
-- Usamos subqueries para isso
INSERT INTO "order" (order_id, customer_id, amount, order_number) VALUES
('67078c6e-dc64-4775-a3d3-fb348db4c1cd', (SELECT customer_id FROM customer WHERE name = 'João da Silva'), 1999.99,1),
('96966223-7334-4030-9171-0f09c28ae98a', (SELECT customer_id FROM customer WHERE name = 'Maria Oliveira'), 49.90,2);

-- Para inserir em order_item, precisamos dos IDs dos produtos e pedidos
INSERT INTO order_item (order_item_id, order_id, product_id, quantity, price) VALUES
(
    '4213ade3-7c04-4d23-9e22-fadeb058bd39',
    '67078c6e-dc64-4775-a3d3-fb348db4c1cd',
    (SELECT product_id FROM product WHERE name = 'X-Burguer com Queijo e Bacon'),
    1,
    1999.99
),
(
    '00740e15-8efc-4166-b9ba-42814c9fe973',
    '96966223-7334-4030-9171-0f09c28ae98a',
    (SELECT product_id FROM product WHERE name = 'Batata Frita Crocante'),
    2,
    24.95
);

INSERT INTO payment (payment_id, order_id, total_amount) VALUES
('aed0e8d8-f609-4f68-80f7-aacb36d7bac5', '96966223-7334-4030-9171-0f09c28ae98a', 1999.99);

--------------------------------------------------------------------------------------------------------------------------------
-- Atualização Diogo 08/03/2025 - Inserção de clientes adicionais, assim como pedidos e itens dos pedidos
--------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
-- INSERÇÃO DOS PEDIDOS
------------------------------------------------------------

INSERT INTO customer (customer_id, name, email, cpf)
VALUES
  (gen_random_uuid(), 'José Neves', 'joseneves@outlook.com', '30806499826'),
  (gen_random_uuid(), 'Samanta Silva', 'samantas@gmail.com', '16727130809'),
  (gen_random_uuid(), 'Clarice Porto', 'claricepor@hotmail.com', '58265515855'),
  (gen_random_uuid(), 'Maria da Silva', 'mariasilva@yahoo.com' ,'06044142850'),
  (gen_random_uuid(), 'João Oliveira', 'joaoo@hotmail.com', '56156233814'),
  (gen_random_uuid(), 'Vanessa Souza', 'vanessasouza@gmail.com', '00171203810'),
  (gen_random_uuid(), 'Silvia dos Santos', 'silviasantos@outlook.com', '05475035806'),
  (gen_random_uuid(), 'Rodrigo Rodrigues', 'rodrigoro@yahoo.com', '94278522835'),
  (gen_random_uuid(), 'Marcos Borges', 'marcosborges@gmail.com', '71197537899'),
  (gen_random_uuid(), 'Helena Cardoso', 'cardosoh@outlook.com', '18581319874'),
  (gen_random_uuid(), 'Rafaela Ferreira', 'rafaelaferreira@hotmail.com', '75722338800'),
  (gen_random_uuid(), 'Ana Machado', 'machadoana@outlook.com.br', '93257754841');

------------------------------------------------------------
-- INSERÇÃO DOS PEDIDOS
------------------------------------------------------------
INSERT INTO "order" (order_id, customer_id, status, amount)
VALUES
  (gen_random_uuid(), (SELECT customer_id FROM customer WHERE name = 'Ana Machado'), 'Ready', 13.50),         
  (gen_random_uuid(), (SELECT customer_id FROM customer WHERE name = 'Rafaela Ferreira'), 'Preparing', 9.00),   
  (gen_random_uuid(), (SELECT customer_id FROM customer WHERE name = 'Helena Cardoso'), 'Received', 20.00),         
  (gen_random_uuid(), (SELECT customer_id FROM customer WHERE name = 'Marcos Borges'), 'Finished', 12.50),     
  (gen_random_uuid(), (SELECT customer_id FROM customer WHERE name = 'Rodrigo Rodrigues'), 'Ready', 15.00),       
  (gen_random_uuid(), (SELECT customer_id FROM customer WHERE name = 'Silvia dos Santos'), 'Preparing', 11.00),   
  (gen_random_uuid(), (SELECT customer_id FROM customer WHERE name = 'Vanessa Souza'), 'Received', 15.00),        
  (gen_random_uuid(), (SELECT customer_id FROM customer WHERE name = 'João Oliveira'), 'Finished', 18.00),      
  (gen_random_uuid(), (SELECT customer_id FROM customer WHERE name = 'Maria da Silva'), 'Ready', 12.00),          
  (gen_random_uuid(), (SELECT customer_id FROM customer WHERE name = 'Clarice Porto'), 'Preparing', 15.50),    
  (gen_random_uuid(), (SELECT customer_id FROM customer WHERE name = 'Samanta Silva'), 'Preparing', 20.00),
  (gen_random_uuid(), (SELECT customer_id FROM customer WHERE name = 'José Neves'), 'Finished', 12.50);

------------------------------------------------------------
-- INSERÇÃO DOS ITENS DOS PEDIDOS
------------------------------------------------------------
INSERT INTO order_item (order_item_id, order_id, product_id, quantity, price, note)
VALUES
  -- Pedido 3
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'José Neves')), '08518e58-fcc3-4298-aa5a-50d954ad3bc3', 1, 10.00, NULL),
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'José Neves')), '964e8baf-5984-4f61-aae5-d2a4730b9882', 1, 3.50, NULL),

  -- Pedido 4
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Samanta Silva')), '6a4b8d15-74ea-4b54-bec5-2d9f64fed573', 1, 5.00, NULL),
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Samanta Silva')), 'cdc2f171-ad5f-475f-8707-14c103207ad8', 1, 4.00, NULL),

  -- Pedido 5
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Clarice Porto')), '08518e58-fcc3-4298-aa5a-50d954ad3bc3', 2, 10.00, NULL),

  -- Pedido 6
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Maria da Silva')), '6a4b8d15-74ea-4b54-bec5-2d9f64fed573', 1, 5.00, NULL),
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Maria da Silva')), '964e8baf-5984-4f61-aae5-d2a4730b9882', 1, 3.50, NULL),
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Maria da Silva')), 'cdc2f171-ad5f-475f-8707-14c103207ad8', 1, 4.00, NULL),

  -- Pedido 7
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'João Oliveira')), '08518e58-fcc3-4298-aa5a-50d954ad3bc3', 1, 10.00, NULL),
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'João Oliveira')), '6a4b8d15-74ea-4b54-bec5-2d9f64fed573', 1, 5.00, NULL),

  -- Pedido 8
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Vanessa Souza')), '964e8baf-5984-4f61-aae5-d2a4730b9882', 2, 3.50, NULL),
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Vanessa Souza')), 'cdc2f171-ad5f-475f-8707-14c103207ad8', 1, 4.00, NULL),

  -- Pedido 9
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Silvia dos Santos')), '6a4b8d15-74ea-4b54-bec5-2d9f64fed573', 3, 5.00, NULL),

  -- Pedido 10
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Rodrigo Rodrigues')), 'cdc2f171-ad5f-475f-8707-14c103207ad8', 2, 4.00, NULL),
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Rodrigo Rodrigues')), '08518e58-fcc3-4298-aa5a-50d954ad3bc3', 1, 10.00, NULL),

  -- Pedido 11
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Marcos Borges')), '964e8baf-5984-4f61-aae5-d2a4730b9882', 2, 3.50, NULL),
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Marcos Borges')), '6a4b8d15-74ea-4b54-bec5-2d9f64fed573', 1, 5.00, NULL),

  -- Pedido 12
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Helena Cardoso')), 'cdc2f171-ad5f-475f-8707-14c103207ad8', 3, 4.00, NULL),
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Helena Cardoso')), '964e8baf-5984-4f61-aae5-d2a4730b9882', 1, 3.50, NULL),

  -- Pedido 13
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Rafaela Ferreira')), '6a4b8d15-74ea-4b54-bec5-2d9f64fed573', 2, 5.00, NULL),
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Rafaela Ferreira')), '08518e58-fcc3-4298-aa5a-50d954ad3bc3', 1, 10.00, NULL),

  -- Pedido 14
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Ana Machado')), '964e8baf-5984-4f61-aae5-d2a4730b9882', 1, 3.50, NULL),
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Ana Machado')), 'cdc2f171-ad5f-475f-8707-14c103207ad8', 1, 4.00, NULL),
  (gen_random_uuid(), (SELECT order_id FROM "order" WHERE customer_id = (SELECT customer_id FROM customer WHERE name = 'Ana Machado')), '6a4b8d15-74ea-4b54-bec5-2d9f64fed573', 1, 5.00, NULL);

