DROP TABLE IF EXISTS product;
CREATE TABLE product (
    id BIGINT(20) NOT NULL AUTO_INCREMENT,
    title VARCHAR(255) DEFAULT NULL,
    description VARCHAR(1255) DEFAULT NULL,
    amount DECIMAL(13,2) DEFAULT NULL,
    `date` DATETIME(6) DEFAULT NULL,
    image_url VARCHAR(255) DEFAULT NULL,
    category CHAR(1) DEFAULT NULL,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS role;
CREATE TABLE role (
    id int(11) NOT NULL AUTO_INCREMENT,
    name varchar(100) NOT NULL,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS user;
CREATE TABLE user (
    id int(11) NOT NULL AUTO_INCREMENT,
    username varchar(50) NOT NULL,
    password varchar(150) NOT NULL,
    email varchar(250) NULL,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS user_role;
CREATE TABLE user_role (
    user_id int(11) default null,
    role_id int(11) default null,
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT FK_user_role_01 FOREIGN KEY (user_id) REFERENCES user (id) on delete no action on update no action,
    CONSTRAINT FK_user_role_02 FOREIGN KEY (role_id) REFERENCES role (id) on delete no action on update no action
);

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
    id int(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) DEFAULT NULL,
    total DECIMAL(13,2) DEFAULT NULL,
    address VARCHAR(255) DEFAULT NULL,
    order_tracking_number VARCHAR(255) DEFAULT NULL,
    date_created datetime(6) DEFAULT NULL,
    user_id int(11) DEFAULT NULL,
    PRIMARY KEY (id),
    CONSTRAINT FK_orders_user_id FOREIGN KEY (user_id) REFERENCES user (id)
);

DROP TABLE IF EXISTS order_item;
CREATE TABLE order_item (
    id int(11) NOT NULL AUTO_INCREMENT,
    title VARCHAR(255) DEFAULT NULL,
    image_url VARCHAR(255) DEFAULT NULL,
    unit DECIMAL(13,2) DEFAULT NULL,
    quantity int(11) DEFAULT NULL,
    product_id BIGINT(20) DEFAULT NULL,
    order_id int(11) DEFAULT NULL,
    PRIMARY KEY (id),
    CONSTRAINT FK_order_item_01 FOREIGN KEY (order_id) REFERENCES `orders` (id)
);


DROP TABLE IF EXISTS user_favorite_product;
CREATE TABLE user_favorite_product (
   user_id int DEFAULT NULL,
   product_id bigint DEFAULT NULL,
   is_favorite BIT DEFAULT 0,
   PRIMARY KEY (user_id, product_id),
   CONSTRAINT FK_favorite_user_id FOREIGN KEY (user_id) REFERENCES user (id) on delete no action on update no action,
   CONSTRAINT FK_favorite_product_id FOREIGN KEY (product_id) REFERENCES product (id) on delete no action on update no action
);
