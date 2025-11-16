# Garage Management System

Hệ thống quản lý garage chuyên nghiệp được xây dựng bằng Java Web với Jakarta Servlet/JSP.

## 📋 Mục lục

- [Giới thiệu](#giới-thiệu)
- [Công nghệ sử dụng](#công-nghệ-sử-dụng)
- [Cài đặt](#cài-đặt)
- [Cấu hình Database](#cấu-hình-database)
- [Chức năng](#chức-năng)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Hướng dẫn sử dụng](#hướng-dẫn-sử-dụng)

## 🎯 Giới thiệu

Hệ thống quản lý garage cung cấp các tính năng quản lý khách hàng, xe, dịch vụ, phụ tùng và hóa đơn thanh toán cho garage ô tô.

## 🛠️ Công nghệ sử dụng

- **Backend**: Java 21
- **Web Framework**: Jakarta Servlet API 6.0.0, Jakarta JSP API 3.1.1
- **Database**: PostgreSQL 42.7.3
- **Build Tool**: Apache Maven 3.x
- **Web Server**: Apache Tomcat 10.1.48
- **Frontend**: HTML, CSS, JavaScript, JSP
- **Libraries**: 
  - Jakarta JSTL 3.0.1
  - Gson 2.10.1 (JSON processing)

## 📦 Cài đặt

### Yêu cầu hệ thống

- Java 21 hoặc cao hơn
- Apache Maven 3.6+
- PostgreSQL
- Apache Tomcat 10.1.48 (hoặc tương thích)

### Các bước cài đặt

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd GarageManagement
   ```

2. **Build project**
   ```bash
   mvn clean package -DskipTests
   ```

3. **Setup database**
   - Tạo database PostgreSQL tên `pttk`
   - Chạy script SQL từ file `src/main/java/util/database.sql`
   - Cập nhật thông tin kết nối trong `src/main/java/util/DBConnection.java` nếu cần

4. **Deploy lên Tomcat**
   - Copy file `target/GarageManagement.war` vào thư mục `webapps` của Tomcat
   - Start Tomcat server

5. **Truy cập ứng dụng**
   - Mở trình duyệt và truy cập: `http://localhost:8080/GarageManagement/`

## 🗄️ Cấu hình Database

### Kết nối Database

File cấu hình: `src/main/java/util/DBConnection.java`

Mặc định:
- **URL**: `jdbc:postgresql://localhost:5432/pttk`
- **Username**: `postgres`
- **Password**: Cập nhật trong file `DBConnection.java`

### Schema Database

Hệ thống sử dụng các bảng chính:
- `users` - Quản lý người dùng
- `car` - Quản lý xe
- `appointment` - Quản lý lịch hẹn
- `service` - Quản lý dịch vụ
- `spare_part` - Quản lý phụ tùng
- `used_spare_part` - Phụ tùng sử dụng trong dịch vụ
- `payment_invoice` - Hóa đơn thanh toán
- `payment_invoice_service` - Dịch vụ trong hóa đơn
- `payment_invoice_spare_part` - Phụ tùng trong hóa đơn

## ✨ Chức năng

### 1. Quản lý người dùng

- **Đăng ký/Đăng nhập**: Hệ thống hỗ trợ đăng ký và đăng nhập người dùng
- **Phân quyền**: 5 vai trò
  - `MANAGER` - Quản lý
  - `SALES_STAFF` - Nhân viên bán hàng
  - `WAREHOUSE_STAFF` - Nhân viên kho
  - `TECHNICIAN` - Kỹ thuật viên
  - `CUSTOMER` - Khách hàng

### 2. Quản lý khách hàng

- **Thêm khách hàng**: Form thêm khách hàng mới
- **Tìm kiếm khách hàng**: Tìm kiếm khách hàng theo tên
- **Validation**: Kiểm tra email và số điện thoại phải unique

### 3. Quản lý xe

- **Thêm xe**: Form thêm xe mới với thông tin biển số, hãng, model, năm sản xuất, số km
- **Chọn xe**: Chọn xe từ danh sách xe của khách hàng
- **Validation**: Kiểm tra biển số xe phải unique
- **Chế độ không có xe**: Hỗ trợ tạo hóa đơn không cần chọn xe

### 4. Đặt lịch hẹn

- **Chọn ngày**: Calendar để chọn ngày đặt lịch
- **Chọn khung giờ**: 
  - Thứ 2-6: 7h-12h và 13h-18h (10 slot)
  - Thứ 7: 7h-12h (5 slot)
  - Chủ nhật: Không làm việc
- **Kiểm tra trùng lịch**: Không cho phép đặt 2 lịch hẹn cùng khung giờ
- **Kiểm tra quá khứ**: Không cho phép đặt lịch trong quá khứ

### 5. Quản lý dịch vụ và phụ tùng

- **Tìm kiếm dịch vụ**: Tìm kiếm dịch vụ theo tên
- **Tìm kiếm phụ tùng**: Tìm kiếm phụ tùng theo tên
- **Chọn dịch vụ/phụ tùng**: Checkbox để chọn các dịch vụ và phụ tùng cho hóa đơn
- **Quản lý số lượng**: Nhập số lượng cho mỗi phụ tùng
- **Hiển thị hết hàng**: 
  - Hiển thị phụ tùng hết hàng (số lượng = 0) với text "Hết hàng"
  - Disable checkbox và input số lượng cho phụ tùng hết hàng
  - Dimmed visual style cho phụ tùng hết hàng
- **Validation số lượng**: 
  - Kiểm tra số lượng phụ tùng khách hàng đặt + số lượng phụ tùng dùng trong dịch vụ đã chọn ≤ số lượng có sẵn
  - Hiển thị thông báo chi tiết khi không đủ số lượng (tên phụ tùng, tổng cần, có sẵn, thiếu, phân tích từ đơn hàng khách và từ dịch vụ)

### 6. Hóa đơn thanh toán

- **Tạo hóa đơn**: Tạo hóa đơn với dịch vụ và phụ tùng đã chọn
- **Tính tổng tiền**: Tự động tính tổng tiền từ dịch vụ và phụ tùng
- **Trừ số lượng**: Tự động trừ số lượng phụ tùng khi tạo hóa đơn
  - Trừ từ phụ tùng khách hàng đặt mua
  - Trừ từ phụ tùng sử dụng trong dịch vụ
- **Transaction**: Sử dụng database transaction để đảm bảo tính toàn vẹn dữ liệu

### 7. Quản lý kỹ thuật viên

- **Phân công kỹ thuật viên**: Trang phân công kỹ thuật viên cho dịch vụ

## 📁 Cấu trúc dự án

```
GarageManagement/
├── pom.xml                          # Maven configuration
├── src/
│   └── main/
│       ├── java/
│       │   ├── controller/          # Controller layer (8 files)
│       │   │   ├── UserController.java
│       │   │   ├── CustomerController.java
│       │   │   ├── CarController.java
│       │   │   ├── ServiceController.java
│       │   │   ├── SparePartController.java
│       │   │   ├── PaymentInvoiceController.java
│       │   │   ├── AppointmentController.java
│       │   │   └── TechnicianController.java
│       │   ├── dao/                 # Data Access Object layer (8 files)
│       │   ├── model/               # Model layer (13 files)
│       │   └── util/
│       │       ├── DBConnection.java    # Database connection
│       │       └── database.sql         # Database schema
│       └── webapp/
│           ├── *.jsp                # JSP pages (14 files)
│           └── WEB-INF/
│               └── web.xml          # Web application configuration
└── target/                          # Build output
```

## 🚀 Hướng dẫn sử dụng

### Tài khoản mẫu

Sau khi setup database, các tài khoản mẫu được tạo:
- **Kỹ thuật viên**: `tech01`, `tech02`, ..., `tech10` / `123456`
- Các role khác cần được tạo thông qua đăng ký hoặc thêm trực tiếp vào database

### Luồng nghiệp vụ chính

1. **Khách hàng đăng ký/đăng nhập**
2. **Nhân viên bán hàng tìm kiếm khách hàng**
3. **Nhân viên thêm xe cho khách hàng (nếu chưa có)**
4. **Nhân viên chọn dịch vụ và phụ tùng**
5. **Hệ thống kiểm tra số lượng phụ tùng đủ không**
6. **Nhân viên tạo hóa đơn thanh toán**
7. **Hệ thống trừ số lượng phụ tùng tự động**
8. **Khách hàng có thể đặt lịch hẹn**

## 🔧 Build & Deploy

### Build project

```bash
mvn clean package -DskipTests
```

File WAR sẽ được tạo tại: `target/GarageManagement.war`

### Deploy lên Tomcat

1. Copy `target/GarageManagement.war` vào `$TOMCAT_HOME/webapps/`
2. Start Tomcat: `$TOMCAT_HOME/bin/startup.bat` (Windows) hoặc `startup.sh` (Linux/Mac)
3. Truy cập: `http://localhost:8080/GarageManagement/`

## 📝 Lưu ý

- Database connection được cấu hình trong `DBConnection.java`, cần cập nhật thông tin kết nối phù hợp với môi trường
- Session timeout mặc định: 30 phút (cấu hình trong `web.xml`)
- Hệ thống sử dụng hardcode time slots cho appointment, không có bảng `slot` riêng

## 📄 License

Dự án phục vụ mục đích học tập và nghiên cứu.

