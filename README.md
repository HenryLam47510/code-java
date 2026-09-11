# 2003 Store - Java Servlet Project

Dự án website quản lý cửa hàng giày 2003 Store được xây dựng bằng Java Servlet, JSP và Maven.

## Công nghệ sử dụng
- Java 17
- Maven
- Servlet 5.0
- JSP / JSTL
- HTML / CSS / JavaScript

## Tài khoản admin mặc định
- Username: admin
- Password: 123456

## Chạy dự án
1. Cài đặt JDK 17 và Maven.
2. Vào thư mục dự án.
3. Chạy lệnh:

```bash
mvn clean package
```

4. Copy file target/2003-store.war vào thư mục deploy của Tomcat hoặc chạy bằng Maven Tomcat plugin.

## Cấu trúc chính
- src/main/java: code Java backend
- src/main/webapp: giao diện JSP và tài nguyên tĩnh
- src/main/webapp/WEB-INF/web.xml: cấu hình ứng dụng

## Tính năng chính
- Hiển thị danh sách sản phẩm giày
- Quản lý sản phẩm: thêm, sửa, xóa
- Đăng nhập admin
- Dashboard quản lý
- Giao diện bán hàng trực quan
