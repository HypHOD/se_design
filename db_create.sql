-- 需要手动数据库
-- >psql -d postgres;
-- >CREATE DATABASE campus_shop;

-- 使用数据库
-- >\c campus_shop;

-- create table user
CREATE TABLE IF NOT EXISTS user_info (
    user_id SERIAL PRIMARY KEY,
    user_student_id VARCHAR(20) UNIQUE NOT NULL,
    user_password VARCHAR(20) NOT NULL,
    user_name VARCHAR(20) NOT NULL,
    user_collage VARCHAR(20),
    user_email VARCHAR(100) UNIQUE NOT NULL,
    user_create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_status SMALLINT DEFAULT 1,
    user_avart VARCHAR(255) DEFAULT 'default-avatar.jpg'
);

-- create table category
CREATE TABLE IF NOT EXISTS category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    category_sort_order SMALLINT DEFAULT 0,
    category_create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- create table product
CREATE TABLE IF NOT EXISTS product (
    product_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES user_info (user_id),
    category INT NOT NULL REFERENCES category (category_id),
    product_title VARCHAR(255) NOT NULL,
    product_o_price INT NOT NULL,
    product_price INT NOT NULL,
    product_status SMALLINT NOT NULL DEFAULT 0,
    quality SMALLINT DEFAULT 1,
    reject_reason VARCHAR(255),
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP GENERATED ALWAYS AS (get_current_timestamp ()) STORED
);

-- create table prodcut_image
CREATE TABLE IF NOT EXISTS prodcut_image (
    image_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES product (prodcut_id),
    image_url VARCHAR(255) NOT NULL,
    sort_order SMALLINT DEFAULT 0
);
-- create table address
CREATE TABLE IF NOT EXISTS address (
    address_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES user_info (user_id),
    receiver_name VARCHAR(50) NOT NULL,
    receiver_phone VARCHAR(50) NOT NULL,
    receiver_address VARCHAR(255) NOT NULL,
    is_default SMALLINT DEFAULT 0
);
-- create table cart
CREATE TABLE IF NOT EXISTS cart (
    cart_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES user_info (user_id),
    product_id INT UNIQUE NOT NULL REFERENCES product (prodcut_id),
    add_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);
-- create table order
CREATE TABLE IF NOT EXISTS user_order (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES user_info (user_id),
    seller_id INT NOT NULL REFERENCES user_info (user_id),
    product_id INT UNIQUE NOT NULL REFERENCES product (prodcut_id),
    product_title VARCHAR(255) NOT NULL,
    product_image VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    order_status SMALLINT NOT NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pay_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    receive_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cancel_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    refund_resaon VARCHAR(255)
);
-- create table comment
CREATE TABLE IF NOT EXISTS comment (
    comment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES user_order (order_id),
    user_id INT NOT NULL REFERENCES user_info (user_id),
    seller_id INT NOT NULL REFERENCES user_info (user_id),
    comment_content VARCHAR(1000),
    rating SMALLINT DEFAULT 10,
    comment_status SMALLINT DEFAULT 0,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- create table reserve
CREATE TABLE IF NOT EXISTS reserve (
    reserve_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES user_order (order_id),
    user_id INT NOT NULL REFERENCES user_info (user_id),
    seller_id INT NOT NULL REFERENCES user_info (user_id),
    address_id INT NOT NULL REFERENCES address (address_id),
    reserve_status SMALLINT DEFAULT 0,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    finish_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- create table record 历史记录
CREATE TABLE IF NOT EXISTS record (
    record_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES user_info (user_id),
    product_id INT UNIQUE NOT NULL REFERENCES product (prodcut_id),
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- create table b_notice
CREATE TABLE IF NOT EXISTS b_notice (
    b_notice_id SERIAL PRIMARY KEY,
    notice_content VARCHAR(1000) NOT NULL,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sort_value SMALLINT DEFAULT 0
);
-- create table b_login
CREATE TABLE IF NOT EXISTS b_login (
    b_login_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES user_info (user_id),
    b_login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(50),
    b_login_device VARCHAR(100),
    b_login_status BOOLEAN
);
-- create table b_op
CREATE TABLE IF NOT EXISTS b_op (
    b_op_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES user_info (user_id),
    op_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    op_type VARCHAR(20),
    op_object VARCHAR(100),
    op_detail TEXT
);
-- create table b_error
CREATE TABLE IF NOT EXISTS b_error (
    b_error_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES user_info (user_id),
    error_type VARCHAR(50) NOT NULL,
    error_code SMALLINT NOT NULL,
    error_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    error_message TEXT NOT NULL,
    handle_status VARCHAR(20) NOT NULL DEFAULT '未处理',
    handle_time TIMESTAMP,
    handle_detail TEXT
);

-- 返回当前时间戳
CREATE OR REPLACE FUNCTION get_current_timestamp()
RETURNS TIMESTAMP AS $$
BEGIN
    RETURN CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql STABLE;
-- 标记为 STABLE（允许在生成列中使用）