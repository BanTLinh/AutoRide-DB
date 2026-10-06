CREATE DATABASE IF NOT EXISTS autoride_db 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE autoride_db;

DROP TABLE IF EXISTS Inspections;
DROP TABLE IF EXISTS Rentals;
DROP TABLE IF EXISTS Cars;

CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME NULL,
    status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'BOOKED',
    security_deposit DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    late_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    damage_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    FOREIGN KEY (car_id) REFERENCES Cars(car_id)
);

CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    CONSTRAINT fk_inspections_rentals 
        FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

DELIMITER //
CREATE TRIGGER trg_before_inspection_insert
BEFORE INSERT ON Inspections
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);
    SELECT status INTO v_status FROM Rentals WHERE rental_id = NEW.rental_id;
    IF v_status = 'BOOKED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Cannot create inspection for a BOOKED rental.';
    END IF;
END;
//
DELIMITER ;

-- DỮ LIỆU MẪU VÀ MÔ PHỎNG QUY TRÌNH
INSERT INTO Cars (model_name, license_plate) VALUES ('Toyota Camry 2023', '30H-999.99');

INSERT INTO Rentals (car_id, customer_name, rent_date, security_deposit, status) 
VALUES (1, 'Nguyen Van A', '2026-10-01 08:00:00', 10000000.00, 'ACTIVE');

INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name)
VALUES (1, '2026-10-06 10:00:00', 'Vỡ đèn pha trái do va chạm nhẹ', 'Nhan Vien Tran Van B');

UPDATE Rentals 
SET return_date = '2026-10-06 10:00:00',
    late_fee = 0.00,
    damage_fee = 2000000.00,
    status = 'COMPLETED'
WHERE rental_id = 1;

-- TRUY VẤN TÍNH TOÁN TIỀN HOÀN TRẢ
SELECT 
    r.rental_id,
    r.customer_name,
    c.model_name,
    c.license_plate,
    r.security_deposit,
    r.late_fee,
    r.damage_fee,
    (r.security_deposit - r.late_fee - r.damage_fee) AS net_refund_amount,
    i.damage_description,
    i.inspector_name,
    r.status
FROM Rentals r
JOIN Cars c ON r.car_id = c.car_id
LEFT JOIN Inspections i ON r.rental_id = i.rental_id
WHERE r.rental_id = 1;