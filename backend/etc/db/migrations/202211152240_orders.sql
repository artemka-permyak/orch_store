-- migrate:up

CREATE TYPE order_status as ENUM ('wait_paid', 'paid', 'delivery', 'done');


CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    delivery_address TEXT NOT NULL,
    status order_status NOT NULL DEFAULT 'wait_paid',
    en BOOLEAN NOT NULL DEFAULT true,
    delivery_date DATE,
    delivery_time VARCHAR(10),
    CONSTRAINT order_user_id_fk
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


CREATE TABLE orders_cart_items (
    order_id BIGINT NOT NULL,
    cart_item_id BIGINT NOT NULL,
    CONSTRAINT orders_cart_items_order_id_fk
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,
    CONSTRAINT orders_cart_items_cart_item_id_fk
        FOREIGN KEY (cart_item_id)
        REFERENCES stuff_in_cart(id)
        ON DELETE CASCADE
);


-- migrate:down

DROP TABLE orders_cart_items;
DROP TABLE orders;