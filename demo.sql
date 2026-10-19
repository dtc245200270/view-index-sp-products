-- Buoc 1: Tao co so du lieu demo
CREATE DATABASE IF NOT EXISTS demo;
USE demo;

-- Buoc 2: Tao bang Products va them du lieu mau
CREATE TABLE IF NOT EXISTS Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL UNIQUE,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(10, 2) NOT NULL,
    productAmount INT NOT NULL,
    productDescription TEXT,
    productStatus VARCHAR(50)
);

INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
VALUES 
    ('P001', 'Bàn phím cơ', 1200000, 15, 'Bàn phím cơ switch blue', 'Còn hàng'),
    ('P002', 'Chuột không dây', 450000, 30, 'Chuột silent pin sạc', 'Còn hàng'),
    ('P003', 'Màn hình 24 inch', 3200000, 8, 'Màn hình IPS 75Hz', 'Còn hàng'),
    ('P004', 'Tai nghe Gaming', 890000, 0, 'Tai nghe có mic chống ồn', 'Hết hàng');

-- Buoc 3: Tao Index va so sanh EXPLAIN
-- Truoc khi tao index
EXPLAIN SELECT * FROM Products WHERE productCode = 'P002';
EXPLAIN SELECT * FROM Products WHERE productName = 'Bàn phím cơ' AND productPrice = 1200000;

-- Tao Unique Index tren cot productCode
CREATE UNIQUE INDEX idx_productCode ON Products(productCode);

-- Tao Composite Index tren cot productName va productPrice
CREATE INDEX idx_name_price ON Products(productName, productPrice);

-- Sau khi tao index (kiem tra lai hieu nang)
EXPLAIN SELECT * FROM Products WHERE productCode = 'P002';
EXPLAIN SELECT * FROM Products WHERE productName = 'Bàn phím cơ' AND productPrice = 1200000;

-- Buoc 4: Thao tac voi View
-- Tao view lay productCode, productName, productPrice, productStatus
CREATE VIEW product_view AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

-- Xem du lieu view
SELECT * FROM product_view;

-- Sua doi view (them cot productAmount)
CREATE OR REPLACE VIEW product_view AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products;

-- Xoa view
DROP VIEW product_view;

-- Buoc 5: Thao tac voi Stored Procedure
DELIMITER //

-- 5.1. SP lay tat ca thong tin san pham
CREATE PROCEDURE getAllProducts()
BEGIN
    SELECT * FROM Products;
END //

-- 5.2. SP them mot san pham moi
CREATE PROCEDURE addProduct(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10, 2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status VARCHAR(50)
)
BEGIN
    INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_desc, p_status);
END //

-- 5.3. SP sua thong tin san pham theo id
CREATE PROCEDURE updateProductById(
    IN p_id INT,
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10, 2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status VARCHAR(50)
)
BEGIN
    UPDATE Products
    SET productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_desc,
        productStatus = p_status
    WHERE Id = p_id;
END //

-- 5.4. SP xoa san pham theo id
CREATE PROCEDURE deleteProductById(IN p_id INT)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //

DELIMITER ;

-- Test goi cac Stored Procedure
CALL getAllProducts();
CALL addProduct('P005', 'Lót chuột RGB', 250000, 20, 'Lót chuột cỡ lớn', 'Còn hàng');
CALL updateProductById(1, 'Bàn phím cơ Pro', 1350000, 10, 'Bàn phím cơ switch brown', 'Còn hàng');
CALL deleteProductById(4);
CALL getAllProducts();
