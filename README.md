# 2003 Store - Java Servlet Management System

A role-based retail management solution for a footwear store, built with Java Servlet, JSP, Maven, and MySQL. The system supports sales operations, inventory control, employee administration, reporting, and VietQR payment processing for a modern store workflow.

## Overview
2003 Store is a Java web application designed for store operations with a shared database and a multi-role dashboard model. It is optimized for internal store management and helps teams manage sales, inventory, reporting, and bank transfer confirmation in a single platform.

### Highlights
- Role-based dashboard for Admin, Manager, and Employee
- Permission-aware access control for backend routes and UI menus
- Product, order, customer, and supplier management
- Warehouse and stock tracking workflows
- Revenue and staff reporting
- VietQR-compatible payment configuration and QR-based payment confirmation flow
- Modern dashboard UI tailored for operational usage

## Tech Stack
- Java 17
- Maven
- Servlet 5.0
- JSP / JSTL
- HTML / CSS / JavaScript
- JDBC / MySQL
- JUnit 5

## Tài khoản demo + flow đăng nhập
Có sẵn các tài khoản demo cho phân quyền:

- Admin
  - Username: `admin`
  - Password: `123456`
  - Mục tiêu: quản trị toàn hệ thống, xem báo cáo, quản lý nhân sự, cấu hình hệ thống

- Manager
  - Username: `manager`
  - Password: `123456`
  - Mục tiêu: quản lý vận hành cửa hàng, đơn hàng, sản phẩm, nhập/xuất/kiểm kho, báo cáo kho

- Employee / Staff
  - Username: `staff` hoặc `employee`
  - Password: `123456`
  - Mục tiêu: thao tác bán hàng, xem sản phẩm, tạo đơn, xử lý khách hàng

- Cashier
  - Username: `cashier`
  - Password: `123456`
  - Mục tiêu: xác nhận thanh toán, xử lý các đơn chuyển khoản / VietQR

### Flow đăng nhập
1. Truy cập trang login của ứng dụng.
2. Nhập username và password tương ứng với tài khoản demo.
3. Sau khi đăng nhập thành công, hệ thống sẽ tự redirect theo vai trò:
   - Admin -> `/dashboard/admin`
   - Manager -> `/dashboard/manager`
   - Employee -> `/dashboard/employee`
4. Từ dashboard, người dùng chỉ nhìn thấy menu và chức năng được phép theo quyền.
5. Nếu truy cập thẳng vào URL không được phép, hệ thống sẽ trả về lỗi `403 Forbidden`.

## Chạy dự án
Yêu cầu: JDK 17, Maven và MySQL đang chạy.

1. Vào thư mục dự án.
2. Chạy:

```bash
mvn clean package
```

3. Để chạy local test nhanh:

```bash
mvn test
```

4. Dùng Tomcat hoặc server Java EE để deploy WAR được tạo tại:

```bash
target/2003-store.war
```

> Nếu project đang được build dưới dạng WAR, sau khi package hoàn tất bạn có thể deploy file WAR vào Tomcat.

## Cấu trúc chính
- `src/main/java`: backend Java (Servlet, DAO, Service, model)
- `src/main/webapp`: giao diện JSP, CSS, JS, file tĩnh
- `src/main/webapp/WEB-INF/web.xml`: cấu hình ứng dụng
- `src/test/java`: unit test cho logic nghiệp vụ và phân quyền

## Tính năng chính
- Dashboard theo role: Admin / Manager / Employee
- Phân quyền truy cập theo module và chức năng
- Quản lý sản phẩm, đơn hàng, khách hàng, nhân viên
- Quản lý nhập kho, xuất kho, kiểm kho
- Báo cáo doanh thu, báo cáo kho, báo cáo nhân viên
- Nhật ký đăng nhập và lịch sử hoạt động
- Quản lý nhà cung cấp
- Thanh toán chuyển khoản VietQR với thông tin ngân hàng có thể cấu hình
- Xác nhận thanh toán theo quyền riêng (`payment_confirm`)
- Giao diện bán hàng, dashboard, và sidebar được chia theo từng vai trò

## Hướng dẫn sử dụng chi tiết theo từng role

### 1) Admin
Admin is the highest-privilege user in the system.

Primary goals:
- oversee the entire store operation
- manage employees and system users
- review store-wide reports
- configure payment settings and VietQR account info
- monitor system activity and business performance

Core functions:
- admin dashboard overview
- employee management
- order management
- product management
- customer management
- revenue reports
- staff reports
- login history
- inventory checks
- supplier management

Notes:
- Admin has access to most modules.
- Admin can view and operate across the full application.

### 2) Manager
Manager focuses on daily operational control and warehouse execution.

Primary goals:
- manage sales and orders
- oversee product inventory and stock movement
- monitor warehouse and revenue performance
- supervise team workflow

Core functions:
- management dashboard
- order and sales workflows
- product catalog
- customer tracking
- stock-in / stock-out / inventory check
- inventory report
- sales report
- employee oversight
- supplier records

Notes:
- Manager is more operational than administrative.
- Manager does not have full system-level control like Admin.

### 3) Employee
Employee handles the front-line sales workflow.

Primary goals:
- create and manage sales transactions
- view product information
- maintain customer records
- process routine operational tasks

Core functions:
- sales dashboard
- create orders
- view order list
- manage product essentials
- manage customer data
- confirm payment when permitted

Notes:
- Employee is restricted from system administration modules.
- If the account lacks `payment_confirm` permission, payment-related menu items are hidden.

### 4) Cashier
Cashier is a specialized employee role for payment flow.

Primary goals:
- verify incoming payment requests
- confirm bank transfer / VietQR payments
- support transaction completion

Core functions:
- view pending orders
- monitor payment state
- approve payment confirmation

Notes:
- Cashier still remains under employee-level role restrictions.
- Payment approval is controlled by permission instead of role alone.

## Role-based access
The system supports three main role groups:

- Admin: full system administration
- Manager: inventory, warehouse, order, and operational reporting
- Employee: sales and store-facing tasks with permission-based access

Protected routes such as `/employees`, `/reports`, `/inventory-check`, `/login-history` are checked server-side to prevent direct unauthorized access.

## Payment QR / VietQR
The platform supports configuration of receiving bank information for QR payments, including:
- bank code
- account number
- account holder name

This config is used in the payment confirmation flow and can be displayed to customers for transfer-based payment.

## Demo mockups
The following sections are intended as visual placeholders for portfolio presentations and demo slides.

### Dashboard mockup
![Dashboard mockup](https://via.placeholder.com/1200x700?text=2003+Store+Dashboard+Mockup)

### Sales / order workflow mockup
![Sales workflow mockup](https://via.placeholder.com/1200x700?text=Order+Management+Mockup)

### Inventory and reporting mockup
![Inventory report mockup](https://via.placeholder.com/1200x700?text=Inventory+%26+Reporting+Mockup)

## Deployment checklist
Use the following checklist before presenting or deploying the project:

- [ ] JDK 17 installed
- [ ] Maven installed and working
- [ ] MySQL running and database initialized
- [ ] `mvn clean package` runs successfully
- [ ] WAR file generated in `target/`
- [ ] Tomcat or servlet container configured
- [ ] Login credentials verified for demo roles
- [ ] Role permissions confirmed for dashboard and modules
- [ ] QR bank information updated in production config
- [ ] Smoke test completed for sales, inventory, and reports

## Testing
Run the full test suite:

```bash
mvn test
```

## Notes
This application uses a shared database and shared UI shell, while separating dashboard entry points and access permissions by role. That design keeps the project maintainable while giving each role a cleaner workflow and a more focused operational experience.
