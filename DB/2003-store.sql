-- ============================================================
-- 2003 STORE - DATABASE QUAN LY CUA HANG GIAY BAN TRUC TIEP
-- MySQL 8.x
-- Mo hinh: may tinh noi bo, ban hang tai cua hang
-- ============================================================

DROP DATABASE IF EXISTS `2003_store`;
CREATE DATABASE `2003_store`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE `2003_store`;

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 1. DANH MUC
-- ============================================================
CREATE TABLE danh_muc (
    ma_danh_muc INT AUTO_INCREMENT PRIMARY KEY,
    ten_danh_muc VARCHAR(100) NOT NULL UNIQUE,
    mo_ta VARCHAR(255),
    trang_thai TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

-- ============================================================
-- 2. THUONG HIEU
-- ============================================================
CREATE TABLE thuong_hieu (
    ma_thuong_hieu INT AUTO_INCREMENT PRIMARY KEY,
    ten_thuong_hieu VARCHAR(100) NOT NULL UNIQUE,
    quoc_gia VARCHAR(100),
    trang_thai TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

-- ============================================================
-- 3. SAN PHAM
-- Một sản phẩm là một mẫu giày; size/mau được quản lý ở kho.
-- ============================================================
CREATE TABLE san_pham (
    ma_san_pham INT AUTO_INCREMENT PRIMARY KEY,
    ma_sku VARCHAR(30) NOT NULL UNIQUE,
    ten_san_pham VARCHAR(200) NOT NULL,
    ma_danh_muc INT NOT NULL,
    ma_thuong_hieu INT NOT NULL,
    gia_nhap DECIMAL(15,2) NOT NULL DEFAULT 0,
    gia_ban DECIMAL(15,2) NOT NULL DEFAULT 0,
    origin VARCHAR(100) DEFAULT 'Chưa xác định',
    mo_ta TEXT,
    trang_thai ENUM('DANG_BAN','NGUNG_BAN') NOT NULL DEFAULT 'DANG_BAN',
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sp_dm FOREIGN KEY (ma_danh_muc) REFERENCES danh_muc(ma_danh_muc),
    CONSTRAINT fk_sp_th FOREIGN KEY (ma_thuong_hieu) REFERENCES thuong_hieu(ma_thuong_hieu),
    CONSTRAINT chk_sp_gia CHECK (gia_nhap >= 0 AND gia_ban >= 0)
) ENGINE=InnoDB;

-- ============================================================
-- 4. BIEN THE SAN PHAM
-- Mỗi size + màu là một biến thể có tồn kho riêng.
-- ============================================================
CREATE TABLE bien_the_san_pham (
    ma_bien_the INT AUTO_INCREMENT PRIMARY KEY,
    ma_san_pham INT NOT NULL,
    size_giay VARCHAR(10) NOT NULL,
    mau_sac VARCHAR(50) NOT NULL,
    ma_vach VARCHAR(50) NOT NULL UNIQUE,
    ton_toi_thieu INT NOT NULL DEFAULT 2,
    trang_thai ENUM('DANG_BAN','NGUNG_BAN') NOT NULL DEFAULT 'DANG_BAN',
    CONSTRAINT fk_bt_sp FOREIGN KEY (ma_san_pham) REFERENCES san_pham(ma_san_pham),
    CONSTRAINT uq_bt UNIQUE (ma_san_pham, size_giay, mau_sac),
    CONSTRAINT chk_bt_min CHECK (ton_toi_thieu >= 0)
) ENGINE=InnoDB;

-- ============================================================
-- 5. KHO
-- ============================================================
CREATE TABLE kho (
    ma_kho INT AUTO_INCREMENT PRIMARY KEY,
    ten_kho VARCHAR(100) NOT NULL UNIQUE,
    dia_chi VARCHAR(255),
    trang_thai TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

CREATE TABLE ton_kho (
    ma_kho INT NOT NULL,
    ma_bien_the INT NOT NULL,
    so_luong INT NOT NULL DEFAULT 0,
    PRIMARY KEY (ma_kho, ma_bien_the),
    CONSTRAINT fk_tk_kho FOREIGN KEY (ma_kho) REFERENCES kho(ma_kho),
    CONSTRAINT fk_tk_bt FOREIGN KEY (ma_bien_the) REFERENCES bien_the_san_pham(ma_bien_the),
    CONSTRAINT chk_tk_sl CHECK (so_luong >= 0)
) ENGINE=InnoDB;

-- ============================================================
-- 6. NHA CUNG CAP
-- ============================================================
CREATE TABLE nha_cung_cap (
    ma_ncc INT AUTO_INCREMENT PRIMARY KEY,
    ten_ncc VARCHAR(150) NOT NULL,
    nguoi_lien_he VARCHAR(100),
    so_dien_thoai VARCHAR(20),
    email VARCHAR(100),
    dia_chi VARCHAR(255),
    trang_thai TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

-- ============================================================
-- 7. NHAN VIEN
-- ============================================================
CREATE TABLE nhan_vien (
    ma_nhan_vien INT AUTO_INCREMENT PRIMARY KEY,
    ma_nv VARCHAR(20) NOT NULL UNIQUE,
    ho_ten VARCHAR(120) NOT NULL,
    gioi_tinh ENUM('NAM','NU','KHAC') NOT NULL DEFAULT 'NAM',
    ngay_sinh DATE,
    so_dien_thoai VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    dia_chi VARCHAR(255),
    chuc_vu ENUM('QUAN_LY','BAN_HANG','THU_KHO','THU_NGAN') NOT NULL,
    luong DECIMAL(15,2) NOT NULL DEFAULT 0,
    ngay_vao_lam DATE,
    trang_thai ENUM('DANG_LAM','NGHI_VIEC') NOT NULL DEFAULT 'DANG_LAM',
    CONSTRAINT chk_nv_luong CHECK (luong >= 0)
) ENGINE=InnoDB;

-- ============================================================
-- 8. TAI KHOAN NOI BO
-- Không phải tài khoản khách hàng/website.
-- ============================================================
CREATE TABLE tai_khoan (
    ma_tai_khoan INT AUTO_INCREMENT PRIMARY KEY,
    ma_nhan_vien INT NOT NULL UNIQUE,
    ten_dang_nhap VARCHAR(50) NOT NULL UNIQUE,
    mat_khau VARCHAR(255) NOT NULL,
    quyen ENUM('ADMIN','QUAN_LY','BAN_HANG','THU_KHO','THU_NGAN') NOT NULL,
    trang_thai TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT fk_tk_nv FOREIGN KEY (ma_nhan_vien) REFERENCES nhan_vien(ma_nhan_vien)
) ENGINE=InnoDB;

-- ============================================================
-- 9. KHACH HANG
-- Khách mua trực tiếp; không cần tài khoản website.
-- ============================================================
CREATE TABLE khach_hang (
    ma_khach_hang INT AUTO_INCREMENT PRIMARY KEY,
    ma_kh VARCHAR(20) NOT NULL UNIQUE,
    ho_ten VARCHAR(120) NOT NULL,
    gioi_tinh ENUM('NAM','NU','KHAC'),
    so_dien_thoai VARCHAR(20),
    email VARCHAR(100),
    dia_chi VARCHAR(255),
    diem_tich_luy INT NOT NULL DEFAULT 0,
    hang_khach_hang ENUM('THUONG','BAC','VANG','KIM_CUONG') NOT NULL DEFAULT 'THUONG',
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    trang_thai TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT chk_kh_diem CHECK (diem_tich_luy >= 0)
) ENGINE=InnoDB;

-- ============================================================
-- 10. PHIEU NHAP
-- ============================================================
CREATE TABLE phieu_nhap (
    ma_phieu_nhap INT AUTO_INCREMENT PRIMARY KEY,
    so_phieu VARCHAR(30) NOT NULL UNIQUE,
    ma_ncc INT NOT NULL,
    ma_nhan_vien INT NOT NULL,
    ma_kho INT NOT NULL,
    ngay_nhap DATETIME NOT NULL,
    tong_tien DECIMAL(15,2) NOT NULL DEFAULT 0,
    ghi_chu VARCHAR(255),
    trang_thai ENUM('DA_NHAP','DA_HUY') NOT NULL DEFAULT 'DA_NHAP',
    CONSTRAINT fk_pn_ncc FOREIGN KEY (ma_ncc) REFERENCES nha_cung_cap(ma_ncc),
    CONSTRAINT fk_pn_nv FOREIGN KEY (ma_nhan_vien) REFERENCES nhan_vien(ma_nhan_vien),
    CONSTRAINT fk_pn_kho FOREIGN KEY (ma_kho) REFERENCES kho(ma_kho),
    CONSTRAINT chk_pn_tien CHECK (tong_tien >= 0)
) ENGINE=InnoDB;

CREATE TABLE chi_tiet_phieu_nhap (
    ma_phieu_nhap INT NOT NULL,
    ma_bien_the INT NOT NULL,
    so_luong INT NOT NULL,
    don_gia DECIMAL(15,2) NOT NULL,
    thanh_tien DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (ma_phieu_nhap, ma_bien_the),
    CONSTRAINT fk_ctpn_pn FOREIGN KEY (ma_phieu_nhap) REFERENCES phieu_nhap(ma_phieu_nhap),
    CONSTRAINT fk_ctpn_bt FOREIGN KEY (ma_bien_the) REFERENCES bien_the_san_pham(ma_bien_the),
    CONSTRAINT chk_ctpn_sl CHECK (so_luong > 0),
    CONSTRAINT chk_ctpn_gia CHECK (don_gia >= 0 AND thanh_tien >= 0)
) ENGINE=InnoDB;

-- ============================================================
-- 11. HOA DON BAN HANG
-- ============================================================
CREATE TABLE hoa_don (
    ma_hoa_don INT AUTO_INCREMENT PRIMARY KEY,
    so_hoa_don VARCHAR(30) NOT NULL UNIQUE,
    ma_khach_hang INT NULL,
    ma_nhan_vien INT NOT NULL,
    ngay_ban DATETIME NOT NULL,
    tong_tien_hang DECIMAL(15,2) NOT NULL DEFAULT 0,
    giam_gia DECIMAL(15,2) NOT NULL DEFAULT 0,
    tien_khach_dua DECIMAL(15,2) NOT NULL DEFAULT 0,
    tien_thua DECIMAL(15,2) NOT NULL DEFAULT 0,
    thanh_tien DECIMAL(15,2) NOT NULL DEFAULT 0,
    phuong_thuc_thanh_toan ENUM('TIEN_MAT','CHUYEN_KHOAN','THE','MOMO') NOT NULL,
    trang_thai ENUM('DA_THANH_TOAN','DA_HUY','CHO_XU_LY') NOT NULL DEFAULT 'DA_THANH_TOAN',
    ghi_chu VARCHAR(255),
    CONSTRAINT fk_hd_kh FOREIGN KEY (ma_khach_hang) REFERENCES khach_hang(ma_khach_hang),
    CONSTRAINT fk_hd_nv FOREIGN KEY (ma_nhan_vien) REFERENCES nhan_vien(ma_nhan_vien),
    CONSTRAINT chk_hd_giam CHECK (giam_gia >= 0),
    CONSTRAINT chk_hd_tien CHECK (
        tong_tien_hang >= 0 AND
        giam_gia >= 0 AND
        tien_khach_dua >= 0 AND
        tien_thua >= 0 AND
        thanh_tien >= 0
    )
) ENGINE=InnoDB;

CREATE TABLE chi_tiet_hoa_don (
    ma_hoa_don INT NOT NULL,
    ma_bien_the INT NOT NULL,
    so_luong INT NOT NULL,
    don_gia DECIMAL(15,2) NOT NULL,
    giam_gia DECIMAL(15,2) NOT NULL DEFAULT 0,
    thanh_tien DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (ma_hoa_don, ma_bien_the),
    CONSTRAINT fk_cthd_hd FOREIGN KEY (ma_hoa_don) REFERENCES hoa_don(ma_hoa_don),
    CONSTRAINT fk_cthd_bt FOREIGN KEY (ma_bien_the) REFERENCES bien_the_san_pham(ma_bien_the),
    CONSTRAINT chk_cthd_sl CHECK (so_luong > 0),
    CONSTRAINT chk_cthd_gia CHECK (don_gia >= 0 AND giam_gia >= 0 AND thanh_tien >= 0)
) ENGINE=InnoDB;

-- ============================================================
-- 12. TRA HANG
-- ============================================================
CREATE TABLE phieu_tra_hang (
    ma_phieu_tra INT AUTO_INCREMENT PRIMARY KEY,
    so_phieu_tra VARCHAR(30) NOT NULL UNIQUE,
    ma_hoa_don INT NOT NULL,
    ma_nhan_vien INT NOT NULL,
    ngay_tra DATETIME NOT NULL,
    ly_do VARCHAR(255),
    tong_tien_tra DECIMAL(15,2) NOT NULL DEFAULT 0,
    trang_thai ENUM('DA_XU_LY','DA_HUY') NOT NULL DEFAULT 'DA_XU_LY',
    CONSTRAINT fk_pth_hd FOREIGN KEY (ma_hoa_don) REFERENCES hoa_don(ma_hoa_don),
    CONSTRAINT fk_pth_nv FOREIGN KEY (ma_nhan_vien) REFERENCES nhan_vien(ma_nhan_vien),
    CONSTRAINT chk_pth_tien CHECK (tong_tien_tra >= 0)
) ENGINE=InnoDB;

CREATE TABLE chi_tiet_tra_hang (
    ma_phieu_tra INT NOT NULL,
    ma_bien_the INT NOT NULL,
    so_luong INT NOT NULL,
    don_gia_tra DECIMAL(15,2) NOT NULL,
    thanh_tien DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (ma_phieu_tra, ma_bien_the),
    CONSTRAINT fk_ctth_pth FOREIGN KEY (ma_phieu_tra) REFERENCES phieu_tra_hang(ma_phieu_tra),
    CONSTRAINT fk_ctth_bt FOREIGN KEY (ma_bien_the) REFERENCES bien_the_san_pham(ma_bien_the),
    CONSTRAINT chk_ctth_sl CHECK (so_luong > 0)
) ENGINE=InnoDB;

-- ============================================================
-- DU LIEU MAU
-- ============================================================

INSERT INTO danh_muc (ten_danh_muc, mo_ta) VALUES
('Giày Sneaker','Giày sneaker thời trang'),
('Giày Thể Thao','Giày chạy bộ và luyện tập'),
('Giày Bóng Đá','Giày đá bóng sân cỏ nhân tạo'),
('Giày Cổ Cao','Giày cổ cao phong cách đường phố'),
('Giày Casual','Giày đi hàng ngày'),
('Dép','Dép thời trang và đi hàng ngày'),
('Giày Trẻ Em','Giày dành cho trẻ em');

INSERT INTO thuong_hieu (ten_thuong_hieu, quoc_gia) VALUES
('Nike','Hoa Ky'),
('Adidas','Duc'),
('Converse','Hoa Ky'),
('Vans','Hoa Ky'),
('Puma','Duc'),
('New Balance','Hoa Ky'),
('Mizuno','Nhat Ban'),
('Asics','Nhat Ban'),
('Jordan','Hoa Ky'),
('Bitis Hunter','Viet Nam');

INSERT INTO nha_cung_cap
(ten_ncc, nguoi_lien_he, so_dien_thoai, email, dia_chi) VALUES
('Nike Vietnam Distribution','Nguyen Van Hung','0901000001','nike@ncc.local','TP Ho Chi Minh'),
('Adidas Wholesale Vietnam','Tran Minh Quan','0901000002','adidas@ncc.local','Ha Noi'),
('Sneaker Viet Wholesale','Le Quoc Bao','0901000003','sneaker@ncc.local','Ha Noi'),
('Phong Vu Sport','Pham Thanh Son','0901000004','phongvu@ncc.local','Da Nang'),
('Streetwear Supply','Do Minh Khang','0901000005','street@ncc.local','TP Ho Chi Minh'),
('The Thao Minh Anh','Nguyen Thi Lan','0901000006','minhanh@ncc.local','Hai Phong');

INSERT INTO kho (ten_kho, dia_chi) VALUES
('Kho cua hang','Tang 1 - 2003 Store'),
('Kho sau','Tang 2 - 2003 Store');

INSERT INTO nhan_vien
(ma_nv, ho_ten, gioi_tinh, ngay_sinh, so_dien_thoai, email, dia_chi, chuc_vu, luong, ngay_vao_lam) VALUES
('NV001','Nguyen Van An','NAM','1998-03-12','0911000001','an@2003store.local','Ha Noi','QUAN_LY',18000000,'2022-01-10'),
('NV002','Tran Minh Duc','NAM','2001-07-21','0911000002','duc@2003store.local','Ha Noi','BAN_HANG',8500000,'2024-03-15'),
('NV003','Le Hoang Nam','NAM','2002-11-05','0911000003','nam@2003store.local','Ha Noi','BAN_HANG',8500000,'2024-08-01'),
('NV004','Pham Quoc Huy','NAM','1999-05-19','0911000004','huy@2003store.local','Ha Noi','THU_KHO',10000000,'2023-06-20'),
('NV005','Nguyen Thi Mai','NU','2000-02-14','0911000005','mai@2003store.local','Ha Noi','THU_NGAN',9000000,'2023-09-10'),
('NV006','Do Thanh Tung','NAM','2003-12-30','0911000006','tung@2003store.local','Ha Noi','BAN_HANG',8000000,'2025-01-12'),
('NV007','Vo Ngoc Anh','NU','2001-10-09','0911000007','anh@2003store.local','Ha Noi','BAN_HANG',8200000,'2025-04-18'),
('NV008','Hoang Duc Long','NAM','1997-01-25','0911000008','long@2003store.local','Ha Noi','THU_KHO',10500000,'2022-11-01'),
('NV009','Nhan Vien Da Nghi','NAM','1999-09-09','0911000009','nghiviec@2003store.local','Ha Noi','BAN_HANG',7000000,'2023-01-01');

UPDATE nhan_vien SET trang_thai='NGHI_VIEC' WHERE ma_nv='NV009';

INSERT INTO tai_khoan (ma_nhan_vien, ten_dang_nhap, mat_khau, quyen) VALUES
(1,'admin2003','123456','ADMIN'),
(2,'duc2003','123456','BAN_HANG'),
(3,'nam2003','123456','BAN_HANG'),
(4,'huy2003','123456','THU_KHO'),
(5,'mai2003','123456','THU_NGAN'),
(6,'tung2003','123456','BAN_HANG'),
(7,'anh2003','123456','BAN_HANG'),
(8,'long2003','123456','THU_KHO'),
(9,'nghiviec2003','123456','BAN_HANG');

INSERT INTO khach_hang
(ma_kh, ho_ten, gioi_tinh, so_dien_thoai, email, dia_chi, diem_tich_luy, hang_khach_hang) VALUES
('KH001','Nguyen Minh Anh','NU','0988000001','minhanh@gmail.com','Ha Noi',120,'BAC'),
('KH002','Tran Quoc Bao','NAM','0988000002','quocbao@gmail.com','Ha Noi',80,'THUONG'),
('KH003','Le Hoang Long','NAM','0988000003','hoanglong@gmail.com','Ha Noi',350,'VANG'),
('KH004','Pham Gia Huy','NAM','0988000004',NULL,'Ha Noi',20,'THUONG'),
('KH005','Doan Thu Trang','NU','0988000005','thutrang@gmail.com','Ha Noi',600,'KIM_CUONG'),
('KH006','Nguyen Duc Anh','NAM','0988000006',NULL,'Bac Ninh',150,'BAC'),
('KH007','Vu Thanh Ha','NU','0988000007','thanhha@gmail.com','Ha Noi',50,'THUONG'),
('KH008','Bui Minh Khang','NAM','0988000008',NULL,'Hung Yen',210,'VANG'),
('KH009','Hoang Ngoc Mai','NU','0988000009','ngocmai@gmail.com','Ha Noi',15,'THUONG'),
('KH010','Nguyen Quang Hieu','NAM','0988000010',NULL,'Ha Noi',90,'THUONG'),
('KH011','Khach vang lai','KHAC',NULL,NULL,NULL,0,'THUONG'),
('KH012','Tran Thanh Son','NAM','0988000012','thanhson@gmail.com','Ha Noi',300,'VANG'),
('KH013','Le Phuong Linh','NU','0988000013',NULL,'Ha Noi',0,'THUONG'),
('KH014','Do Duc Manh','NAM','0988000014',NULL,'Ha Noi',40,'THUONG'),
('KH015','Nguyen Ha My','NU','0988000015','hamy@gmail.com','Ha Noi',180,'BAC');

INSERT INTO san_pham
(ma_sku, ten_san_pham, ma_danh_muc, ma_thuong_hieu, gia_nhap, gia_ban, mo_ta) VALUES
('NKAF107','Nike Air Force 1 07',1,1,1800000,2890000,'Sneaker co ban'),
('NADUNKLOW','Nike Dunk Low',1,1,2100000,3290000,'Sneaker lifestyle'),
('AJ1LOW','Air Jordan 1 Low',1,9,2200000,3490000,'Jordan low'),
('ADSUPERSTAR','Adidas Superstar',1,2,1300000,2190000,'Mau kinh dien'),
('ADSAMBA','Adidas Samba OG',1,2,1800000,2990000,'Samba OG'),
('ADCAMPUS','Adidas Campus 00s',1,2,1500000,2590000,'Campus'),
('CONVERSE70','Converse Chuck 70',4,3,1100000,1890000,'Chuck 70'),
('VANSOLD','Vans Old Skool',1,4,1000000,1750000,'Old Skool'),
('PUMASUEDE','Puma Suede Classic',1,5,1050000,1790000,'Suede Classic'),
('NB530','New Balance 530',2,6,1600000,2690000,'Giay chay bo'),
('MIZUNO9','Mizuno Morelia',3,7,1900000,2990000,'Giay bong da'),
('ASICS24','Asics Gel 24',2,8,1700000,2890000,'Giay the thao'),
('BITISH','Bitis Hunter Street',5,10,700000,1290000,'Giay Viet Nam'),
('NIKEPEG','Nike Pegasus 41',2,1,2300000,3690000,'Giay chay bo'),
('VANSKID','Vans Kids Old Skool',7,4,700000,1290000,'Giay tre em'),
('CONVERSEALL','Converse All Star',5,3,850000,1490000,'Giay casual'),
('NIKECORTEZ','Nike Cortez',5,1,1400000,2290000,'Giay casual'),
('ADRUNFALCON','Adidas Runfalcon',2,2,900000,1590000,'Giay tap luyen'),
('PUMAFUTURE','Puma Future',3,5,1600000,2790000,'Giay bong da'),
('JORDAN1MID','Jordan 1 Mid',4,9,2500000,3990000,'Giay co cao');

-- Bien the: 20 mau giay x 5 size = 100 bien the
INSERT INTO bien_the_san_pham
(ma_san_pham, size_giay, mau_sac, ma_vach, ton_toi_thieu)
SELECT
    sp.ma_san_pham,
    s.size_giay,
    CASE MOD(sp.ma_san_pham + CAST(REPLACE(s.size_giay,'.','') AS UNSIGNED), 4)
        WHEN 0 THEN 'Trang'
        WHEN 1 THEN 'Den'
        WHEN 2 THEN 'Trang Den'
        ELSE 'Xam'
    END,
    CONCAT(sp.ma_sku,'-',REPLACE(s.size_giay,'.',''),'-',MOD(sp.ma_san_pham + CAST(REPLACE(s.size_giay,'.','') AS UNSIGNED),4)),
    CASE
        WHEN sp.ma_san_pham IN (11,19) THEN 1
        ELSE 2
    END
FROM san_pham sp
CROSS JOIN (
    SELECT '38' AS size_giay UNION ALL
    SELECT '39' UNION ALL
    SELECT '40' UNION ALL
    SELECT '41' UNION ALL
    SELECT '42'
) s;

-- Bổ sung size 43-45 cho một số sản phẩm
INSERT INTO bien_the_san_pham
(ma_san_pham, size_giay, mau_sac, ma_vach, ton_toi_thieu)
SELECT sp.ma_san_pham, s.size_giay, 'Den',
       CONCAT(sp.ma_sku,'-',s.size_giay,'-X'),
       2
FROM san_pham sp
CROSS JOIN (
    SELECT '43' AS size_giay UNION ALL SELECT '44' UNION ALL SELECT '45'
) s
WHERE sp.ma_san_pham IN (1,2,3,4,5,6,7,8,9,10,14,16,17,20);

-- Ton kho ban dau, co chu y tao nhieu muc sap het/hhet
INSERT INTO ton_kho (ma_kho, ma_bien_the, so_luong)
SELECT 1, ma_bien_the,
       CASE
           WHEN ma_bien_the IN (1,7,13,25,40) THEN 0
           WHEN ma_bien_the IN (2,8,14,26,41) THEN 1
           WHEN MOD(ma_bien_the,11)=0 THEN 2
           WHEN MOD(ma_bien_the,7)=0 THEN 3
           ELSE 8 + MOD(ma_bien_the,15)
       END
FROM bien_the_san_pham;

INSERT INTO ton_kho (ma_kho, ma_bien_the, so_luong)
SELECT 2, ma_bien_the,
       CASE
           WHEN MOD(ma_bien_the,13)=0 THEN 0
           WHEN MOD(ma_bien_the,9)=0 THEN 2
           ELSE MOD(ma_bien_the,8)
       END
FROM bien_the_san_pham;

-- ============================================================
-- PHIEU NHAP MAU
-- ============================================================
INSERT INTO phieu_nhap
(so_phieu, ma_ncc, ma_nhan_vien, ma_kho, ngay_nhap, tong_tien, ghi_chu) VALUES
('PN0001',1,4,1,'2026-08-01 09:00:00',180000000,'Nhap Nike dot 1'),
('PN0002',2,4,1,'2026-08-05 10:00:00',145000000,'Nhap Adidas dot 1'),
('PN0003',3,8,1,'2026-08-12 14:00:00',92000000,'Nhap hang tong hop'),
('PN0004',4,8,2,'2026-08-20 08:30:00',76000000,'Nhap kho sau'),
('PN0005',5,4,1,'2026-08-28 11:00:00',110000000,'Nhap hang streetwear'),
('PN0006',6,8,2,'2026-09-02 15:30:00',68000000,'Nhap giay the thao'),
('PN0007',1,4,1,'2026-09-05 09:15:00',125000000,'Nhap Nike dot 2'),
('PN0008',2,8,1,'2026-09-08 13:00:00',99000000,'Nhap Adidas dot 2');

-- Chi tiet nhap: sử dụng các biến thể khác nhau
INSERT INTO chi_tiet_phieu_nhap VALUES
(1,1,10,1800000,18000000),
(1,2,10,1800000,18000000),
(1,3,12,1800000,21600000),
(1,4,10,1800000,18000000),
(1,5,12,1800000,21600000),
(2,21,10,1300000,13000000),
(2,22,12,1300000,15600000),
(2,23,10,1300000,13000000),
(2,24,12,1300000,15600000),
(2,25,10,1300000,13000000),
(3,31,8,1100000,8800000),
(3,32,10,1100000,11000000),
(3,41,12,1000000,12000000),
(3,42,10,1000000,10000000),
(3,51,8,1050000,8400000),
(4,61,10,1600000,16000000),
(4,62,10,1600000,16000000),
(4,71,8,1900000,15200000),
(4,72,8,1900000,15200000),
(5,81,10,1700000,17000000),
(5,82,10,1700000,17000000),
(5,91,10,700000,7000000),
(5,92,10,700000,7000000),
(6,101,8,2300000,18400000),
(6,102,8,2300000,18400000),
(6,111,6,1400000,8400000),
(6,112,6,1400000,8400000),
(7,6,10,2100000,21000000),
(7,7,10,2100000,21000000),
(7,8,10,2100000,21000000),
(7,9,10,2100000,21000000),
(8,26,10,1500000,15000000),
(8,27,10,1500000,15000000),
(8,28,10,1500000,15000000),
(8,29,10,1500000,15000000);

-- ============================================================
-- HOA DON MAU
-- Co: khách hàng, khách vãng lai, nhiều phương thức,
-- giảm giá, hóa đơn hủy, hóa đơn chờ xử lý.
-- ============================================================
INSERT INTO hoa_don
(so_hoa_don, ma_khach_hang, ma_nhan_vien, ngay_ban,
 tong_tien_hang, giam_gia, tien_khach_dua, tien_thua, thanh_tien,
 phuong_thuc_thanh_toan, trang_thai, ghi_chu) VALUES
('HD0001',1,2,'2026-08-01 09:15:00',2890000,0,3000000,110000,2890000,'TIEN_MAT','DA_THANH_TOAN',NULL),
('HD0002',2,3,'2026-08-01 10:20:00',5080000,100000,5000000,20000,4980000,'CHUYEN_KHOAN','DA_THANH_TOAN','Khach quen'),
('HD0003',NULL,5,'2026-08-02 11:00:00',2190000,0,2190000,0,2190000,'TIEN_MAT','DA_THANH_TOAN','Khach vang lai'),
('HD0004',3,2,'2026-08-03 15:30:00',6580000,300000,7000000,720000,6280000,'TIEN_MAT','DA_THANH_TOAN',NULL),
('HD0005',4,6,'2026-08-05 17:45:00',3990000,0,3990000,0,3990000,'THE','DA_THANH_TOAN',NULL),
('HD0006',5,7,'2026-08-07 19:10:00',7470000,500000,6970000,0,6970000,'CHUYEN_KHOAN','DA_THANH_TOAN','Khuyen mai'),
('HD0007',6,3,'2026-08-10 14:00:00',1750000,0,2000000,250000,1750000,'TIEN_MAT','DA_THANH_TOAN',NULL),
('HD0008',7,2,'2026-08-12 16:20:00',5380000,200000,6000000,820000,5180000,'TIEN_MAT','DA_THANH_TOAN',NULL),
('HD0009',8,6,'2026-08-15 09:30:00',2990000,0,2990000,0,2990000,'MOMO','DA_THANH_TOAN',NULL),
('HD0010',9,7,'2026-08-18 12:00:00',1490000,0,1500000,10000,1490000,'TIEN_MAT','DA_THANH_TOAN',NULL),
('HD0011',10,3,'2026-08-20 18:00:00',7280000,300000,7000000,20000,6980000,'CHUYEN_KHOAN','DA_THANH_TOAN',NULL),
('HD0012',11,5,'2026-08-22 10:00:00',1290000,0,1500000,210000,1290000,'TIEN_MAT','DA_THANH_TOAN','Khach vang lai'),
('HD0013',12,2,'2026-08-25 13:40:00',6880000,800000,6080000,0,6080000,'THE','DA_THANH_TOAN','Voucher'),
('HD0014',13,6,'2026-08-28 16:00:00',3990000,0,3990000,0,3990000,'CHUYEN_KHOAN','DA_THANH_TOAN',NULL),
('HD0015',14,7,'2026-08-30 19:30:00',2190000,100000,2100000,10000,2090000,'TIEN_MAT','DA_THANH_TOAN',NULL),
('HD0016',15,3,'2026-09-01 09:10:00',8970000,500000,8470000,0,8470000,'MOMO','DA_THANH_TOAN',NULL),
('HD0017',1,2,'2026-09-03 11:20:00',3490000,0,3500000,10000,3490000,'TIEN_MAT','DA_THANH_TOAN',NULL),
('HD0018',2,3,'2026-09-04 15:00:00',5180000,180000,5000000,0,5000000,'CHUYEN_KHOAN','DA_THANH_TOAN',NULL),
('HD0019',3,6,'2026-09-06 17:15:00',2890000,0,2890000,0,2890000,'THE','DA_THANH_TOAN',NULL),
('HD0020',NULL,5,'2026-09-08 20:00:00',2980000,0,3000000,20000,2980000,'TIEN_MAT','DA_THANH_TOAN','Khach vang lai'),
('HD0021',4,2,'2026-09-09 09:30:00',3990000,0,3990000,0,3990000,'CHUYEN_KHOAN','DA_HUY','Khach doi y'),
('HD0022',5,3,'2026-09-09 14:30:00',6590000,200000,0,0,6390000,'TIEN_MAT','CHO_XU_LY','Chua nhan tien'),
('HD0023',6,7,'2026-09-10 18:00:00',2690000,0,3000000,310000,2690000,'TIEN_MAT','DA_THANH_TOAN',NULL),
('HD0024',8,6,'2026-09-10 19:30:00',6990000,500000,6490000,0,6490000,'CHUYEN_KHOAN','DA_THANH_TOAN','Khuyen mai cuoi tuan');

INSERT INTO chi_tiet_hoa_don VALUES
(1,1,1,2890000,0,2890000),
(2,4,1,2190000,0,2190000),
(2,5,1,2990000,100000,2890000),
(3,4,1,2190000,0,2190000),
(4,2,1,3290000,0,3290000),
(4,3,1,3490000,300000,3190000),
(5,20,1,3990000,0,3990000),
(6,5,1,2990000,200000,2790000),
(6,6,1,2590000,200000,2390000),
(6,10,1,2690000,100000,2590000),
(7,8,1,1750000,0,1750000),
(8,10,1,2690000,0,2690000),
(8,12,1,2890000,200000,2690000),
(9,11,1,2990000,0,2990000),
(10,16,1,1490000,0,1490000),
(11,13,1,1290000,0,1290000),
(11,14,1,3690000,0,3690000),
(11,17,1,2290000,300000,1990000),
(12,13,1,1290000,0,1290000),
(13,3,1,3490000,400000,3090000),
(13,20,1,3990000,400000,3590000),
(14,20,1,3990000,0,3990000),
(15,4,1,2190000,100000,2090000),
(16,14,1,3690000,250000,3440000),
(16,15,1,1290000,250000,1040000),
(16,18,1,1590000,0,1590000),
(16,10,1,2690000,0,2690000),
(17,3,1,3490000,0,3490000),
(18,5,1,2990000,90000,2900000),
(18,6,1,2590000,90000,2500000),
(19,1,1,2890000,0,2890000),
(20,16,2,1490000,0,1490000),
(20,13,1,1290000,0,1290000),
(21,20,1,3990000,0,3990000),
(22,2,1,3290000,100000,3190000),
(22,3,1,3490000,100000,3390000),
(23,10,1,2690000,0,2690000),
(24,14,1,3690000,250000,3440000),
(24,20,1,3990000,250000,3740000);

-- ============================================================
-- TRA HANG MAU
-- ============================================================
INSERT INTO phieu_tra_hang
(so_phieu_tra, ma_hoa_don, ma_nhan_vien, ngay_tra, ly_do, tong_tien_tra) VALUES
('TH0001',4,5,'2026-08-06 10:00:00','Khach doi size',3190000),
('TH0002',8,5,'2026-08-14 17:00:00','San pham khong vua',2690000),
('TH0003',16,5,'2026-09-04 10:00:00','Doi mau',3440000),
('TH0004',20,5,'2026-09-09 11:00:00','Khach doi y',1290000);

INSERT INTO chi_tiet_tra_hang VALUES
(1,3,1,3190000,3190000),
(2,10,1,2690000,2690000),
(3,14,1,3440000,3440000),
(4,13,1,1290000,1290000);

-- ============================================================
-- VIEW HO TRO THONG KE
-- ============================================================
CREATE OR REPLACE VIEW v_ton_kho AS
SELECT
    k.ma_kho,
    k.ten_kho,
    sp.ma_san_pham,
    sp.ma_sku,
    sp.ten_san_pham,
    bt.ma_bien_the,
    bt.size_giay,
    bt.mau_sac,
    tk.so_luong,
    bt.ton_toi_thieu,
    CASE
        WHEN tk.so_luong = 0 THEN 'HET_HANG'
        WHEN tk.so_luong <= bt.ton_toi_thieu THEN 'SAP_HET'
        ELSE 'CON_HANG'
    END AS tinh_trang
FROM ton_kho tk
JOIN kho k ON k.ma_kho = tk.ma_kho
JOIN bien_the_san_pham bt ON bt.ma_bien_the = tk.ma_bien_the
JOIN san_pham sp ON sp.ma_san_pham = bt.ma_san_pham;

CREATE OR REPLACE VIEW v_chi_tiet_ban_hang AS
SELECT
    hd.ma_hoa_don,
    hd.so_hoa_don,
    hd.ngay_ban,
    hd.trang_thai,
    nv.ma_nv,
    nv.ho_ten AS ten_nhan_vien,
    kh.ma_kh,
    kh.ho_ten AS ten_khach_hang,
    sp.ma_sku,
    sp.ten_san_pham,
    bt.size_giay,
    bt.mau_sac,
    cthd.so_luong,
    cthd.don_gia,
    cthd.giam_gia,
    cthd.thanh_tien,
    hd.phuong_thuc_thanh_toan
FROM chi_tiet_hoa_don cthd
JOIN hoa_don hd ON hd.ma_hoa_don = cthd.ma_hoa_don
JOIN bien_the_san_pham bt ON bt.ma_bien_the = cthd.ma_bien_the
JOIN san_pham sp ON sp.ma_san_pham = bt.ma_san_pham
JOIN nhan_vien nv ON nv.ma_nhan_vien = hd.ma_nhan_vien
LEFT JOIN khach_hang kh ON kh.ma_khach_hang = hd.ma_khach_hang;

-- ============================================================
-- INDEX
-- ============================================================
CREATE INDEX idx_hd_ngay_ban ON hoa_don(ngay_ban);
CREATE INDEX idx_hd_trang_thai ON hoa_don(trang_thai);
CREATE INDEX idx_hd_khach_hang ON hoa_don(ma_khach_hang);
CREATE INDEX idx_sp_ten ON san_pham(ten_san_pham);
CREATE INDEX idx_kh_sdt ON khach_hang(so_dien_thoai);
CREATE INDEX idx_bt_size ON bien_the_san_pham(size_giay);
CREATE INDEX idx_pn_ngay ON phieu_nhap(ngay_nhap);

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- MOT SO QUERY TEST
-- ============================================================

-- 1. Danh sach san pham
-- SELECT * FROM san_pham;

-- 2. San pham het/sap het
-- SELECT * FROM v_ton_kho WHERE tinh_trang IN ('HET_HANG','SAP_HET');

-- 3. Doanh thu theo ngay
-- SELECT DATE(ngay_ban) ngay, SUM(thanh_tien) doanh_thu
-- FROM hoa_don
-- WHERE trang_thai='DA_THANH_TOAN'
-- GROUP BY DATE(ngay_ban)
-- ORDER BY ngay;

-- 4. Doanh thu theo nhan vien
-- SELECT nv.ma_nv, nv.ho_ten, SUM(hd.thanh_tien) doanh_thu
-- FROM hoa_don hd JOIN nhan_vien nv ON hd.ma_nhan_vien=nv.ma_nhan_vien
-- WHERE hd.trang_thai='DA_THANH_TOAN'
-- GROUP BY nv.ma_nhan_vien, nv.ho_ten;

-- 5. San pham ban chay
-- SELECT sp.ten_san_pham, SUM(ct.so_luong) so_luong_ban
-- FROM chi_tiet_hoa_don ct
-- JOIN bien_the_san_pham bt ON ct.ma_bien_the=bt.ma_bien_the
-- JOIN san_pham sp ON bt.ma_san_pham=sp.ma_san_pham
-- JOIN hoa_don hd ON ct.ma_hoa_don=hd.ma_hoa_don
-- WHERE hd.trang_thai='DA_THANH_TOAN'
-- GROUP BY sp.ma_san_pham, sp.ten_san_pham
-- ORDER BY so_luong_ban DESC;

-- 6. Hoa don da huy / cho xu ly
-- SELECT * FROM hoa_don
-- WHERE trang_thai IN ('DA_HUY','CHO_XU_LY');

-- 7. Kiem tra khach vang lai
-- SELECT * FROM hoa_don WHERE ma_khach_hang IS NULL;

-- 8. Khach hang mua nhieu
-- SELECT kh.ma_kh, kh.ho_ten, COUNT(hd.ma_hoa_don) so_hoa_don,
--        SUM(hd.thanh_tien) tong_chi
-- FROM khach_hang kh JOIN hoa_don hd ON kh.ma_khach_hang=hd.ma_khach_hang
-- WHERE hd.trang_thai='DA_THANH_TOAN'
-- GROUP BY kh.ma_khach_hang, kh.ho_ten
-- ORDER BY tong_chi DESC;

-- 9. Doanh thu theo phuong thuc thanh toan
-- SELECT phuong_thuc_thanh_toan, COUNT(*) so_hoa_don, SUM(thanh_tien) doanh_thu
-- FROM hoa_don
-- WHERE trang_thai='DA_THANH_TOAN'
-- GROUP BY phuong_thuc_thanh_toan;

-- 10. Ton kho theo san pham
-- SELECT ma_sku, ten_san_pham, SUM(so_luong) tong_ton
-- FROM v_ton_kho
-- GROUP BY ma_san_pham, ma_sku, ten_san_pham
-- ORDER BY tong_ton ASC;
