CREATE TABLE IF NOT EXISTS customer (
    customer_id UUID PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NULL,
    cpf VARCHAR(11) NULL,
    status VARCHAR(50) DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS product (
    product_id UUID PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200) NOT NULL,
    category INT NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    status INT NOT NULL,
    time_to_prepare NUMERIC(5, 2) NOT NULL, -- Tempo em minutos como decimal
    is_available BOOLEAN NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS "order" (
    order_id UUID PRIMARY KEY,
    customer_id UUID NOT NULL,
    status VARCHAR(255) NOT NULL DEFAULT 'Received',
    amount DECIMAL(10, 2) NOT NULL,
    order_number SERIAL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS order_item (
    order_item_id UUID PRIMARY KEY,
    order_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INTEGER NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    note VARCHAR(255) NULL,
    FOREIGN KEY (order_id) REFERENCES "order"(order_id) ON DELETE RESTRICT,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE RESTRICT
);


CREATE TABLE IF NOT EXISTS payment (
    payment_id UUID PRIMARY KEY,
    order_id UUID NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    qr_data TEXT NULL,
    external_payment_id VARCHAR(255) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    paid_at TIMESTAMP NULL,
    status VARCHAR(255) NOT NULL DEFAULT 'Pending',
    status_detail VARCHAR(255) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES "order"(order_id) ON DELETE RESTRICT
);


CREATE TABLE IF NOT EXISTS cart (
    cart_id UUID PRIMARY KEY,
    customer_id UUID NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Created',
    created_at TIMESTAMP NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS cart_item (
    cart_item_id UUID PRIMARY KEY,
    cart_id UUID NOT NULL,
    product_id UUID NOT NULL,
    quantity INTEGER NOT NULL,
    notes VARCHAR(255) NULL,
    FOREIGN KEY (cart_id) REFERENCES cart(cart_id) ON DELETE RESTRICT,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE RESTRICT
);