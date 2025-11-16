

CREATE TABLE users (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name           VARCHAR(50) NOT NULL,
    account             VARCHAR(25) UNIQUE NOT NULL,
    password            VARCHAR(255) NOT NULL,
    date_of_birth       DATE,
    email               VARCHAR(50) UNIQUE NOT NULL,
    phone_number        VARCHAR(15),
    role                VARCHAR(20) NOT NULL CHECK (role IN ('MANAGER', 'SALES_STAFF', 'WAREHOUSE_STAFF', 'TECHNICIAN', 'CUSTOMER'))
);

CREATE TABLE car (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    license_plate       VARCHAR(20) UNIQUE NOT NULL,
    brand               VARCHAR(50) NOT NULL,
    model               VARCHAR(50),
    description         VARCHAR(255),
    year_of_manufacture SMALLINT,
    mileage             INTEGER,
    customer_id         INTEGER NOT NULL REFERENCES users(id)
);

CREATE TYPE appointment_status AS ENUM ('BOOKED', 'CANCELLED', 'DONE');

CREATE TABLE appointment (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    creation_date       TIMESTAMP DEFAULT now(),
    appointment_date    DATE NOT NULL,
    appointment_time    TIME NOT NULL,
    status              appointment_status DEFAULT 'BOOKED',
    note                VARCHAR(255),
    customer_id         INTEGER NOT NULL REFERENCES users(id),
    CONSTRAINT uq_customer_per_time UNIQUE (customer_id, appointment_date, appointment_time)
);

CREATE TABLE service (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name                VARCHAR(50) NOT NULL,
    price               FLOAT NOT NULL,
    description         VARCHAR(255),
    estimate_duration   VARCHAR(25),
    category            VARCHAR(25),
    status              VARCHAR(10)
);

CREATE TABLE spare_part (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name                VARCHAR(50) NOT NULL,
    price               FLOAT NOT NULL,
    description         VARCHAR(255),
    available_quantity  INTEGER DEFAULT 0,
    manufacturer        VARCHAR(50),
    warranty_period     DATE
);

CREATE TABLE used_spare_part (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    quantity            INTEGER NOT NULL,
    service_id          INTEGER NOT NULL REFERENCES service(id),
    spare_part_id       INTEGER NOT NULL REFERENCES spare_part(id)
);

CREATE TYPE payment_status AS ENUM ('UNPAID', 'PAID', 'CANCELLED');
CREATE TYPE payment_method AS ENUM ('CASH', 'CARD', 'TRANSFER', 'EWALLET');

CREATE TABLE payment_invoice (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date                DATE NOT NULL,
    status              payment_status DEFAULT 'UNPAID',
    payment_method      payment_method,
    discount            FLOAT DEFAULT 0,
    sales_staff_id      INTEGER NOT NULL REFERENCES users(id),
    customer_id         INTEGER NOT NULL REFERENCES users(id),
    vehicle_id          INTEGER REFERENCES car(id)
);

CREATE TABLE payment_invoice_service (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    unit_price          FLOAT NOT NULL,
    payment_invoice_id  INTEGER NOT NULL REFERENCES payment_invoice(id),
    service_id          INTEGER NOT NULL REFERENCES service(id)
);

CREATE TABLE payment_invoice_spare_part (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    quantity            INTEGER NOT NULL,
    unit_price          FLOAT NOT NULL,
    payment_invoice_id  INTEGER NOT NULL REFERENCES payment_invoice(id),
    spare_part_id       INTEGER NOT NULL REFERENCES spare_part(id)
);

CREATE TYPE import_status AS ENUM ('PENDING', 'PAID', 'CANCELLED');

CREATE TABLE supplier (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name                VARCHAR(50) NOT NULL,
    address             VARCHAR(255),
    phone_number        VARCHAR(15) UNIQUE NOT NULL,
    email               VARCHAR(50) UNIQUE
);

CREATE TABLE import_invoice (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date                DATE NOT NULL,
    status              import_status DEFAULT 'PENDING',
    warehouse_staff_id  INTEGER NOT NULL REFERENCES users(id),
    supplier_id         INTEGER NOT NULL REFERENCES supplier(id)
);

CREATE TABLE import_invoice_spare_part (
    id                  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    quantity            INTEGER NOT NULL,
    unit_price          FLOAT NOT NULL,
    import_invoice_id   INTEGER NOT NULL REFERENCES import_invoice(id),
    spare_part_id       INTEGER NOT NULL REFERENCES spare_part(id)
);

CREATE TABLE used_service (
    id                      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    start_at                TIMESTAMP,
    end_at                  TIMESTAMP,
    payment_invoice_service_id INTEGER NOT NULL REFERENCES payment_invoice_service(id),
    technician_id           INTEGER NOT NULL REFERENCES users(id)
);

INSERT INTO users (full_name, account, password, date_of_birth, email, phone_number, role) VALUES
('Nguyễn Văn A', 'tech01', '123456', '1995-01-10', 'tech01@example.com', '0901000001', 'TECHNICIAN'),
('Nguyễn Văn B', 'tech02', '123456', '1994-03-11', 'tech02@example.com', '0901000002', 'TECHNICIAN'),
('Nguyễn Văn C', 'tech03', '123456', '1992-05-12', 'tech03@example.com', '0901000003', 'TECHNICIAN'),
('Nguyễn Văn D', 'tech04', '123456', '1991-07-13', 'tech04@example.com', '0901000004', 'TECHNICIAN'),
('Nguyễn Văn E', 'tech05', '123456', '1990-09-14', 'tech05@example.com', '0901000005', 'TECHNICIAN'),
('Nguyễn Văn F', 'tech06', '123456', '1989-11-15', 'tech06@example.com', '0901000006', 'TECHNICIAN'),
('Nguyễn Văn G', 'tech07', '123456', '1993-02-20', 'tech07@example.com', '0901000007', 'TECHNICIAN'),
('Nguyễn Văn H', 'tech08', '123456', '1996-04-21', 'tech08@example.com', '0901000008', 'TECHNICIAN'),
('Nguyễn Văn I', 'tech09', '123456', '1997-06-22', 'tech09@example.com', '0901000009', 'TECHNICIAN'),
('Nguyễn Văn K', 'tech10', '123456', '1998-08-23', 'tech10@example.com', '0901000010', 'TECHNICIAN');

INSERT INTO service (name, price, description, estimate_duration, category, status) VALUES
('Thay dầu động cơ', 300000, 'Thay dầu máy và kiểm tra lọc dầu', '30 phút', 'BẢO DƯỠNG', 'ACTIVE'),
('Thay lọc nhớt', 150000, 'Thay lọc nhớt định kỳ', '20 phút', 'BẢO DƯỠNG', 'ACTIVE'),
('Bảo dưỡng phanh', 500000, 'Vệ sinh và căn chỉnh phanh', '45 phút', 'SỬA CHỮA', 'ACTIVE'),
('Thay má phanh', 800000, 'Thay mới má phanh trước/sau', '60 phút', 'SỬA CHỮA', 'ACTIVE'),
('Bảo dưỡng hệ thống lái', 600000, 'Kiểm tra và căn chỉnh hệ thống lái', '50 phút', 'BẢO DƯỠNG', 'ACTIVE'),
('Kiểm tra tổng quát', 700000, 'Kiểm tra toàn bộ xe', '60 phút', 'CHẨN ĐOÁN', 'ACTIVE'),
('Rửa xe', 100000, 'Rửa xe cơ bản', '25 phút', 'DỊCH VỤ KHÁC', 'ACTIVE'),
('Vệ sinh nội thất', 400000, 'Vệ sinh ghế, táp-lô, cửa', '40 phút', 'DỊCH VỤ KHÁC', 'ACTIVE'),
('Thay lọc gió động cơ', 200000, 'Thay lọc gió xe con', '20 phút', 'BẢO DƯỠNG', 'ACTIVE'),
('Thay lọc gió điều hòa', 180000, 'Thay lọc gió cabin', '20 phút', 'BẢO DƯỠNG', 'ACTIVE'),
('Thay bugi', 350000, 'Thay bugi đánh lửa', '30 phút', 'BẢO DƯỠNG', 'ACTIVE'),
('Cân bằng lốp', 250000, 'Cân bằng động bánh xe', '30 phút', 'BẢO DƯỠNG', 'ACTIVE'),
('Đảo lốp', 200000, 'Đảo vị trí lốp để mòn đều', '25 phút', 'BẢO DƯỠNG', 'ACTIVE'),
('Thay lốp', 800000, 'Thay mới lốp xe', '45 phút', 'SỬA CHỮA', 'ACTIVE'),
('Sửa chữa điện', 500000, 'Khắc phục lỗi điện cơ bản', '60 phút', 'SỬA CHỮA', 'ACTIVE'),
('Thay ắc quy', 1500000, 'Thay bình ắc quy mới', '30 phút', 'SỬA CHỮA', 'ACTIVE'),
('Thay nước làm mát', 350000, 'Thay dung dịch làm mát động cơ', '20 phút', 'BẢO DƯỠNG', 'ACTIVE'),
('Thay dây curoa', 900000, 'Thay dây curoa động cơ', '60 phút', 'SỬA CHỮA', 'ACTIVE'),
('Vệ sinh kim phun', 600000, 'Làm sạch kim phun nhiên liệu', '50 phút', 'BẢO DƯỠNG', 'ACTIVE'),
('Chẩn đoán OBD', 300000, 'Đọc lỗi, xoá lỗi bằng máy OBD', '15 phút', 'CHẨN ĐOÁN', 'ACTIVE');

INSERT INTO spare_part (name, price, description, available_quantity, manufacturer, warranty_period) VALUES
('Dầu động cơ 5W30', 250000, 'Dầu tổng hợp 5W30', 80, 'Castrol', '2026-01-01'),
('Dầu động cơ 0W20', 300000, 'Dầu tổng hợp 0W20', 50, 'Shell', '2026-03-01'),
('Lọc nhớt', 150000, 'Lọc nhớt xe du lịch', 60, 'Toyota', '2026-05-01'),
('Lọc gió động cơ', 180000, 'Lọc gió xe con', 90, 'Honda', '2026-03-10'),
('Lọc gió điều hòa', 160000, 'Lọc gió cabin', 70, 'Hyundai', '2026-04-12'),
('Má phanh trước', 600000, 'Má phanh chất lượng cao', 40, 'Brembo', '2027-01-01'),
('Má phanh sau', 550000, 'Má phanh sau cho xe du lịch', 40, 'Brembo', '2027-02-01'),
('Lốp 205/55R16', 1800000, 'Lốp xe hạng C', 30, 'Michelin', '2028-01-01'),
('Lốp 195/60R15', 1500000, 'Lốp xe hạng B', 35, 'Bridgestone', '2028-02-10'),
('Ắc quy 12V-45Ah', 1900000, 'Ắc quy khởi động', 25, 'GS', '2027-03-05'),
('Bugi Iridium', 280000, 'Bugi hiệu suất cao', 50, 'NGK', '2027-07-01'),
('Dây curoa động cơ', 600000, 'Dây curoa cam', 20, 'Mitsuboshi', '2027-10-01'),
('Dung dịch làm mát', 150000, 'Nước làm mát động cơ', 100, 'Toyota', '2026-05-15'),
('Dung dịch rửa kim phun', 200000, 'Làm sạch kim phun', 45, 'Liqui Moly', '2026-08-01'),
('Cầu chì điện', 30000, 'Cầu chì ô tô các loại', 200, 'Bosch', '2029-01-01'),
('Bơm nước làm mát', 950000, 'Bơm nước xe con', 15, 'Denso', '2027-04-01'),
('Cảm biến oxy', 850000, 'O2 sensor', 12, 'Bosch', '2027-06-10'),
('Cảm biến nhiệt độ', 600000, 'Temperature sensor', 20, 'Hyundai', '2027-08-15'),
('Máy nén điều hòa', 3500000, 'Compressor AC', 8, 'Denso', '2028-01-01'),
('Lọc nhiên liệu', 300000, 'Lọc xăng/dầu', 50, 'Mazda', '2026-12-10'),
('Nước rửa kính', 80000, 'Dung dịch rửa kính', 200, '3M', '2026-10-01'),
('Bơm trợ lực lái', 2800000, 'Power steering pump', 10, 'Toyota', '2027-11-01'),
('Cao su càng A', 450000, 'Gầm xe – càng A', 25, 'Honda', '2027-02-05'),
('Rotuyn lái', 550000, 'Gầm xe – đầu rô-tuyn', 30, 'Toyota', '2027-04-01'),
('Giảm xóc trước', 1500000, 'Phuộc trước', 10, 'KYB', '2028-03-10');

INSERT INTO used_spare_part (quantity, service_id, spare_part_id) VALUES
(1, 1, 1),
(1, 1, 3),
(1, 2, 3),
(1, 1, 2),
(1, 9, 4),
(1, 10, 5),

(1, 3, 6),
(1, 4, 6),
(1, 4, 7),
(1, 5, 23),
(1, 5, 24),

(1, 12, 8),
(1, 12, 9),
(1, 13, 8),
(1, 13, 9),
(1, 14, 8),
(1, 14, 9),

(4, 11, 11),
(1, 16, 10),
(1, 15, 15),
(1, 6, 17),
(1, 6, 18),

(1, 10, 5),
(1, 19, 14),
(1, 19, 19),

(1, 17, 13),
(1, 18, 12),
(1, 17, 16),

(1, 20, 15),
(1, 6, 15),

(1, 7, 21),
(1, 8, 21),

(1, 3, 23),
(1, 4, 24),
(1, 5, 24),
(1, 6, 20),
(1, 18, 16),
(1, 17, 13),
(1, 12, 24),
(1, 19, 14),
(1, 11, 11),
(1, 3, 6);

INSERT INTO users (full_name, account, password, date_of_birth, email, phone_number, role) VALUES
('Trần Minh Hoàng', 'cus01', '123456', '1990-05-15', 'hoang.tm@example.com', '0912001001', 'CUSTOMER'),
('Lê Thu Hằng', 'cus02', '123456', '1993-08-20', 'hang.lt@example.com', '0912001002', 'CUSTOMER'),
('Phạm Anh Tuấn', 'cus03', '123456', '1988-12-02', 'tuan.pa@example.com', '0912001003', 'CUSTOMER'),
('Nguyễn Hải Yến', 'cus04', '123456', '1995-03-12', 'yen.nh@example.com', '0912001004', 'CUSTOMER'),
('Đỗ Quốc Khánh', 'cus05', 'cus05', '1992-11-10', 'khanh.dq@example.com', '0912001005', 'CUSTOMER');

INSERT INTO car (license_plate, brand, model, description, year_of_manufacture, mileage, customer_id) VALUES
('30H-123.45', 'Toyota', 'Vios', 'Xe đi gia đình', 2019, 55000, 11),
('30G-567.89', 'Mazda', 'Mazda 3', 'Bảo dưỡng định kỳ', 2021, 32000, 11),
('29A-888.68', 'Honda', 'Civic', 'Chủ yếu đi phố', 2018, 72000, 11),
('30E-111.22', 'Hyundai', 'Elantra', 'Xe công ty', 2020, 40000, 11);

INSERT INTO car (license_plate, brand, model, description, year_of_manufacture, mileage, customer_id) VALUES
('31F-445.22', 'Kia', 'Seltos', 'Xe cá nhân', 2022, 15000, 12),
('30H-998.55', 'Toyota', 'Corolla Altis', 'Xe đi lại hàng ngày', 2017, 95000, 12);

INSERT INTO car (license_plate, brand, model, description, year_of_manufacture, mileage, customer_id) VALUES
('29B-556.77', 'Ford', 'Ranger', 'Xe bán tải', 2020, 60000, 13),
('30K-112.90', 'Toyota', 'Fortuner', 'Xe gia đình 7 chỗ', 2018, 85000, 13),
('30M-221.12', 'Honda', 'CR-V', 'Bảo dưỡng định kỳ', 2019, 48000, 13);

INSERT INTO car (license_plate, brand, model, description, year_of_manufacture, mileage, customer_id) VALUES
('30Z-778.11', 'Mercedes-Benz', 'C200', 'Xe cao cấp', 2021, 28000, 14);

INSERT INTO car (license_plate, brand, model,description, year_of_manufacture, mileage, customer_id) VALUES
('30A-223.34', 'Hyundai', 'Accent', 'Xe chạy dịch vụ', 2020, 120000, 15),
('31A-998.22', 'VinFast', 'Fadil', 'Xe cá nhân', 2021, 35000, 15),
('30C-445.18', 'Mitsubishi', 'Xpander', 'Xe gia đình 7 chỗ', 2019, 65000, 15),
('30D-664.19', 'Toyota', 'Camry', 'Xe công ty', 2017, 110000, 15);

INSERT INTO users (full_name, account, password, date_of_birth, email, phone_number, role) VALUES
('VanLinh', 'vanlinh', '123456', '2004-01-01', 'vanlinh@example.com', '0901000010', 'SALES_STAFF'),
('Linh', 'linh', '123456', '2004-01-01', 'linh@example.com', '0901000011', 'CUSTOMER');