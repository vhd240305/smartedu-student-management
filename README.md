# SmartEdu – Hệ thống quản lý sinh viên và điểm số

Ứng dụng web phân quyền theo vai trò để quản lý sinh viên, giáo viên, lớp học và điểm số, xây dựng bằng Java (JSP/Servlet), JDBC và MySQL. Hệ thống có quy trình duyệt điểm, nhập/xuất Excel, dashboard thống kê và REST API bảo vệ bằng JWT.


## Tính năng

**Quản trị viên (Admin)**
- Quản lý tài khoản, sinh viên, giáo viên và lớp học (CRUD, tìm kiếm, phân trang)
- Nhập hàng loạt sinh viên và danh sách lớp từ Excel
- Duyệt điểm giáo viên gửi lên: chấp nhận hoặc từ chối kèm góp ý; mọi lần admin chỉnh sửa điểm đều được lưu vào lịch sử
- Xuất bảng điểm ra Excel
- Dashboard thống kê (Chart.js): xu hướng GPA theo học kỳ, tỷ lệ đạt/không đạt, phân bố xếp loại, sinh viên theo lớp và giới tính

**Giáo viên**
- Xem các lớp được phân công và danh sách sinh viên
- Nhập điểm và gửi duyệt
- Xuất bảng điểm của lớp ra Excel
- Cập nhật hồ sơ và đổi mật khẩu

**Sinh viên**
- Xem lớp học, giáo viên và điểm đã được duyệt
- Cập nhật hồ sơ và đổi mật khẩu

**Xác thực**
- Đăng nhập và chuyển hướng theo vai trò (Admin / Giáo viên / Sinh viên)
- Đặt lại mật khẩu bằng mã OTP gửi qua email (hết hạn sau 5 phút)

## Điểm nổi bật

- **Quy trình duyệt điểm:** nháp (draft) → chờ duyệt (pending) → đã duyệt / từ chối (approved / rejected), có góp ý của người duyệt và lịch sử chỉnh sửa đầy đủ. Màn hình điểm của sinh viên và thống kê trên dashboard dựa trên điểm đã duyệt.
- **Bảo mật:** mã hóa mật khẩu BCrypt (cost 12), bộ lọc phân quyền dựa trên session cho từng cổng, dùng prepared statement xuyên suốt để chống SQL injection.
- **REST API:** `/api/students`, `/api/teachers`, `/api/classrooms` được bảo vệ bằng JWT, kèm bộ giới hạn tốc độ theo IP (60 request/phút) và trả về các header chuẩn `X-RateLimit-*`.
- **Truy cập database:** dùng Tomcat JDBC connection pool.
- **Kiến trúc:** mô hình MVC kết hợp DAO (Servlet → DAO → MySQL, giao diện JSP).

## Công nghệ

| Lớp | Công nghệ |
|---|---|
| Ngôn ngữ | Java 21 |
| Web | Jakarta Servlet / JSP, Apache Tomcat 10.1 |
| Cơ sở dữ liệu | MySQL 8, JDBC với Tomcat JDBC Pool |
| Bảo mật | BCrypt (at.favre), JWT (jjwt) |
| Excel | Apache POI |
| Email | Jakarta Mail (SMTP) |
| Biểu đồ | Chart.js |

## Hướng dẫn chạy

### Yêu cầu
- JDK 21
- Apache Tomcat 10.1
- MySQL 8 trở lên
- Eclipse IDE for Enterprise Java (khuyên dùng)

### 1. Cài đặt database
Chạy file `quanlysinhvien.sql` trong MySQL (Workbench hoặc `mysql` client). File này tạo database `quanlysinhvien` cùng toàn bộ các bảng.

Tạo tài khoản admin đầu tiên với mật khẩu đã mã hóa BCrypt (mật khẩu demo bên dưới là `Admin@123`):

```sql
INSERT INTO account (username, password, role)
VALUES ('admin', '$2b$12$DTa.s3Hkp5sQ3sDAzh1DfOyy8uH3RcRfWQPgHano72wS0OKD1/9Ui', 'admin');
```

Hãy đổi mật khẩu này sau lần đăng nhập đầu tiên.

### 2. Cấu hình thông tin đăng nhập
Các thông tin bí mật không được đưa lên Git. Trong thư mục `src/main/java/util/`:

Mở `EmailUtil.java` và điền thông tin SMTP 
    private static final String USERNAME = "ea9b8092ea12a5"; // email của bạn
    private static final String PASSWORD = "84255d3d69691e"; // app password Gmail 
    (ví dụ hộp thư sandbox miễn phí của [Mailtrap](https://mailtrap.io) để thử gửi OTP).

URL và tên đăng nhập của database nằm trong `DBConnection.java` (mặc định: `localhost:3306/quanlysinhvien`, user `root`).

### 3. Chạy ứng dụng
1. Import project vào Eclipse (**File → Import → Existing Projects into Workspace**).
2. Đảm bảo đã cấu hình Tomcat 10.1 runtime.
3. Chuột phải project → **Run As → Run on Server**.
4. Mở `http://localhost:8080/QuanLySinhVien/` (đường dẫn phụ thuộc vào context root của project).

Tài khoản giáo viên và sinh viên do admin tạo trong trang **Tài khoản**.

## REST API

Lấy token rồi gửi trong header `Authorization`.

```http
POST /api/auth/login
Content-Type: application/json

{ "username": "admin", "password": "Admin@123" }
```

```http
GET /api/students
Authorization: Bearer <token>
```

| Tài nguyên | Đường dẫn |
|---|---|
| Xác thực | `/api/auth/login` |
| Sinh viên | `/api/students/*` |
| Giáo viên | `/api/teachers/*` |
| Lớp học | `/api/classrooms/*` |

Phản hồi có các header `X-RateLimit-*`; vượt quá 60 request/phút từ một IP sẽ bị từ chối.

## Cấu trúc dự án

```
src/main/
├── java/
│   ├── api/          REST servlet, JwtFilter, RateLimitFilter
│   ├── controller/   Servlet MVC (cổng admin / giáo viên / sinh viên)
│   ├── dao/          Tầng truy cập dữ liệu (JDBC)
│   ├── filter/       Bộ lọc phân quyền theo vai trò
│   ├── model/        Các lớp thực thể
│   └── util/         DBConnection, EmailUtil, Secrets (không đưa lên Git)
└── webapp/
    ├── view/         Trang JSP (admin, teacher, student, auth)
    ├── assets/       CSS và tệp tĩnh
    └── WEB-INF/lib/  Thư viện
quanlysinhvien.sql    Cấu trúc database
```

## Tác giả

**Vũ Huy Đạt** – [GitHub](https://github.com/vhd240305)

Dự án được xây dựng cho mục đích học tập và portfolio.
