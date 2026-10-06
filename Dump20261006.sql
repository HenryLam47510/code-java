-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: 2003_store
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `note` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Hoang','099851225','hoang771@gmail.com','');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_permissions`
--

DROP TABLE IF EXISTS `employee_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int DEFAULT NULL,
  `module_name` varchar(100) DEFAULT NULL,
  `allowed` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `employee_permissions_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_permissions`
--

LOCK TABLES `employee_permissions` WRITE;
/*!40000 ALTER TABLE `employee_permissions` DISABLE KEYS */;
INSERT INTO `employee_permissions` VALUES (1,1,'dashboard',1),(2,1,'products',1),(3,1,'orders',1),(4,1,'customers',1),(5,1,'stock',1),(6,1,'stock-out',1),(7,1,'reports',1),(8,1,'inventory-report',1),(9,1,'warehouse-detail',1),(10,1,'suppliers',1),(11,1,'inventory-check',1),(12,1,'employees',1),(13,1,'login-history',1),(14,2,'dashboard',1),(15,2,'stock',1),(16,2,'stock-out',1),(17,2,'inventory-report',1),(18,2,'warehouse-detail',1),(19,2,'suppliers',1),(20,2,'inventory-check',1),(21,2,'reports',1),(22,3,'dashboard',1),(23,3,'orders',1),(24,3,'customers',1),(25,3,'products',1);
/*!40000 ALTER TABLE `employee_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `position` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'Quản trị viên 2003 Store','admin','123456','ADMIN','Quản trị','0901000001','2026-09-14 17:35:54'),(2,'Quản lý kho 2003 Store','manager','123456','MANAGER','Quản lý kho','0901000002','2026-09-14 17:35:54'),(3,'Nhân viên bán hàng','staff','123456','STAFF','Nhân viên','0901000003','2026-09-14 17:35:54');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_counts`
--

DROP TABLE IF EXISTS `inventory_counts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_counts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `expected_quantity` int DEFAULT NULL,
  `counted_quantity` int DEFAULT NULL,
  `variance` int DEFAULT NULL,
  `counted_by` varchar(255) DEFAULT NULL,
  `note` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_counts`
--

LOCK TABLES `inventory_counts` WRITE;
/*!40000 ALTER TABLE `inventory_counts` DISABLE KEYS */;
INSERT INTO `inventory_counts` VALUES (1,6,'GIÀY BÓNG ĐÁ JOMA TOP FLEX TF',29,29,0,'lam','hang ton so lieu trong kho','2026-09-14 18:02:14'),(2,4,'Puma RS-X',6,6,0,'Dung','1 san pham bi chuot gam 1 goc hop phia tren goc trai san pham, 5 hop con lai van nguyen ven','2026-09-14 18:03:45');
/*!40000 ALTER TABLE `inventory_counts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `invoice_code` varchar(100) DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `total_amount` decimal(12,0) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_history`
--

DROP TABLE IF EXISTS `login_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `login_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT NULL,
  `ip_address` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_history`
--

LOCK TABLES `login_history` WRITE;
/*!40000 ALTER TABLE `login_history` DISABLE KEYS */;
INSERT INTO `login_history` VALUES (1,'admin','Quản trị viên 2003 Store','2026-09-14 17:36:57','SUCCESS','0:0:0:0:0:0:0:1'),(2,'admin','Quản trị viên 2003 Store','2026-09-14 17:54:00','SUCCESS','0:0:0:0:0:0:0:1'),(3,'admin','Quản trị viên 2003 Store','2026-09-14 20:24:26','SUCCESS','0:0:0:0:0:0:0:1'),(4,'staff','Nhân viên bán hàng','2026-09-14 20:26:07','SUCCESS','0:0:0:0:0:0:0:1'),(5,'admin','admin','2026-09-16 12:53:09','FAILED','0:0:0:0:0:0:0:1'),(6,'admin','Quản trị viên 2003 Store','2026-09-16 12:53:16','SUCCESS','0:0:0:0:0:0:0:1'),(7,'admin','Quản trị viên 2003 Store','2026-09-21 09:25:15','SUCCESS','0:0:0:0:0:0:0:1'),(8,'admin','Quản trị viên 2003 Store','2026-09-21 09:56:43','SUCCESS','0:0:0:0:0:0:0:1'),(9,'staff','Nhân viên bán hàng','2026-09-21 10:05:45','SUCCESS','0:0:0:0:0:0:0:1'),(10,'admin','Quản trị viên 2003 Store','2026-09-21 10:10:39','SUCCESS','0:0:0:0:0:0:0:1'),(11,'admin','Quản trị viên 2003 Store','2026-09-21 10:21:04','SUCCESS','0:0:0:0:0:0:0:1'),(12,'admin','Quản trị viên 2003 Store','2026-09-21 10:43:05','SUCCESS','0:0:0:0:0:0:0:1'),(13,'admin','Quản trị viên 2003 Store','2026-09-21 10:45:44','SUCCESS','0:0:0:0:0:0:0:1'),(14,'admin','Quản trị viên 2003 Store','2026-09-21 10:52:39','SUCCESS','0:0:0:0:0:0:0:1'),(15,'admin','Quản trị viên 2003 Store','2026-09-21 13:28:09','SUCCESS','0:0:0:0:0:0:0:1'),(16,'admin','Quản trị viên 2003 Store','2026-09-21 14:14:20','SUCCESS','0:0:0:0:0:0:0:1'),(17,'admin','Quản trị viên 2003 Store','2026-09-21 14:32:46','SUCCESS','0:0:0:0:0:0:0:1'),(18,'admin','Quản trị viên 2003 Store','2026-09-21 15:35:54','SUCCESS','0:0:0:0:0:0:0:1'),(19,'staff','Nhân viên bán hàng','2026-09-21 15:36:53','SUCCESS','0:0:0:0:0:0:0:1'),(20,'admin ','admin ','2026-09-21 15:58:48','FAILED','0:0:0:0:0:0:0:1'),(21,'admin','Quản trị viên 2003 Store','2026-09-21 15:58:54','SUCCESS','0:0:0:0:0:0:0:1'),(22,'manager','Quản lý kho 2003 Store','2026-09-21 15:59:37','SUCCESS','0:0:0:0:0:0:0:1'),(23,'admin','admin','2026-09-21 16:54:07','FAILED','0:0:0:0:0:0:0:1'),(24,'admin','Quản trị viên 2003 Store','2026-09-21 16:54:15','SUCCESS','0:0:0:0:0:0:0:1'),(25,'manager','Quản lý kho 2003 Store','2026-09-21 16:55:05','SUCCESS','0:0:0:0:0:0:0:1'),(26,'staff','Nhân viên bán hàng','2026-09-21 16:55:22','SUCCESS','0:0:0:0:0:0:0:1'),(27,'admin','Quản trị viên 2003 Store','2026-10-06 16:20:01','SUCCESS','0:0:0:0:0:0:0:1'),(28,'admin','Quản trị viên 2003 Store','2026-10-06 16:21:06','SUCCESS','0:0:0:0:0:0:0:1'),(29,'admin','Quản trị viên 2003 Store','2026-10-06 16:24:15','SUCCESS','0:0:0:0:0:0:0:1'),(30,'admin','Quản trị viên 2003 Store','2026-10-06 16:33:48','SUCCESS','0:0:0:0:0:0:0:1');
/*!40000 ALTER TABLE `login_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_code_sequence`
--

DROP TABLE IF EXISTS `order_code_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_code_sequence` (
  `date_key` varchar(8) NOT NULL,
  `next_sequence` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`date_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_code_sequence`
--

LOCK TABLES `order_code_sequence` WRITE;
/*!40000 ALTER TABLE `order_code_sequence` DISABLE KEYS */;
INSERT INTO `order_code_sequence` VALUES ('20260921',1),('20261006',1);
/*!40000 ALTER TABLE `order_code_sequence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `unit_price` decimal(12,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,4,5,'GIÀY BÓNG ĐÁ JOMA TOP FLEX REBOUND TF',1,2500000),(2,5,1,'Nike Air Max 2003',1,2499000),(3,6,2,'Adidas Ultra Boost',5,2999000);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `total_amount` decimal(12,0) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` varchar(50) DEFAULT 'CHUA_THANH_TOAN',
  `transaction_note` varchar(255) DEFAULT NULL,
  `qr_code` text,
  `is_hidden` tinyint(1) DEFAULT '0',
  `cancel_reason` varchar(255) DEFAULT NULL,
  `order_code` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_orders_order_code` (`order_code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'Nguyen Van A','0901234567','Hoan thanh',5499000,'2026-09-14 17:35:54',NULL,'CHUA_THANH_TOAN',NULL,NULL,0,NULL,'DH20260915-0001'),(2,'Tran Thi B','0912345678','Da thanh toan',3999000,'2026-09-14 17:35:54','BANK_TRANSFER','DA_THANH_TOAN','',NULL,0,NULL,NULL),(3,'Le Van C','0987654321','Hoan thanh',7990000,'2026-09-14 17:35:54','COD','DA_THANH_TOAN','',NULL,0,NULL,NULL),(4,'hoang','099851225','Hoan thanh',2500000,'2026-09-14 18:05:20','COD','DA_THANH_TOAN','',NULL,0,NULL,NULL),(5,'dung','0398051871','Cho xac nhan',2499000,'2026-09-21 16:55:48','BANK_TRANSFER','CHUA_THANH_TOAN','',NULL,0,NULL,'DH20260921-0001'),(6,'hoang lam','0397049421','Hoan thanh',14995000,'2026-10-06 16:25:54','COD','DA_THANH_TOAN','',NULL,0,NULL,'DH20261006-0001');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_configs`
--

DROP TABLE IF EXISTS `payment_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_configs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bank_id` varchar(20) DEFAULT NULL,
  `account_number` varchar(50) DEFAULT NULL,
  `account_name` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_configs`
--

LOCK TABLES `payment_configs` WRITE;
/*!40000 ALTER TABLE `payment_configs` DISABLE KEYS */;
INSERT INTO `payment_configs` VALUES (1,'TCB','190123456789','Test Receiver','2026-10-06 16:33:14'),(2,'VPBank','0123456789','Persisted Receiver','2026-09-21 15:26:58');
/*!40000 ALTER TABLE `payment_configs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `price` decimal(12,0) DEFAULT NULL,
  `stock` int DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `description` text,
  `is_deleted` tinyint(1) DEFAULT '0',
  `deleted_reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Nike Air Max 2003','Running','Nike',2499000,12,'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80','Giay chay bo thoang khi, de cao su ben bi.',0,NULL),(2,'Adidas Ultra Boost','Lifestyle','Adidas',2999000,58,'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?auto=format&fit=crop&w=800&q=80','Phong cach tre trung, phu hop di hoc va di choi.',0,NULL),(3,'New Balance 530','Sneaker','New Balance',2199000,10,'https://images.unsplash.com/photo-1608231387042-66d1773070a5?auto=format&fit=crop&w=800&q=80','Thiet ke co dien, thoai mai moi hoat dong.',0,NULL),(4,'Puma RS-X','Sport','Puma',2699000,6,'https://images.unsplash.com/photo-1543508282-6319a3e2621f?auto=format&fit=crop&w=800&q=80','Giay the thao nang dong, ho tro di chuyen nhanh.',0,NULL),(5,'GIÀY BÓNG ĐÁ JOMA TOP FLEX REBOUND TF','giay the thao','JOMA',2500000,20,'https://bizweb.dktcdn.net/thumb/1024x1024/100/458/331/products/1788001973901-2428970510781083193-2428970510781083193-afd8095848565c87d74a58a5b9761a1b-1788002021061.jpg','Thông tin sản phẩm đang được cập nhật',0,NULL),(6,'GIÀY BÓNG ĐÁ JOMA TOP FLEX TF','sport','JOMA',2250000,29,'https://bizweb.dktcdn.net/thumb/1024x1024/100/458/331/products/1788001973904-2428970510781083193-2428970510781083193-f1cc2c6e2a2591d42ced88b052ee65d3-1788002031767.jpg','Thông tin sản phẩm đang được cập nhật',0,NULL),(12,'test','111','1243',1000,1,'https://chatgpt.com/backend-api/estuary/content?id=file_0000000074e081fda05bbc24f2fe4b35&ts=497218&p=fs&cid=1&sig=692d4fb8268beada3aaab38d52f7018104d8deb19cc08ac1bebee01326a445fc&v=0','mo ta',1,'Xóa khỏi danh sách sản phẩm');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_issues`
--

DROP TABLE IF EXISTS `stock_issues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_issues` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `reason` varchar(100) DEFAULT NULL,
  `note` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_issues`
--

LOCK TABLES `stock_issues` WRITE;
/*!40000 ALTER TABLE `stock_issues` DISABLE KEYS */;
INSERT INTO `stock_issues` VALUES (1,6,'GIÀY BÓNG ĐÁ JOMA TOP FLEX TF',1,'Ban hang','khach hang mua','2026-09-14 17:59:13'),(2,6,'GIÀY BÓNG ĐÁ JOMA TOP FLEX TF',10,'Ban hang','club dat giay the thao\r\n','2026-09-14 17:59:49');
/*!40000 ALTER TABLE `stock_issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_receipts`
--

DROP TABLE IF EXISTS `stock_receipts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_receipts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `supplier` varchar(255) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `unit_price` decimal(12,0) DEFAULT NULL,
  `total_cost` decimal(12,0) DEFAULT NULL,
  `note` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_receipts`
--

LOCK TABLES `stock_receipts` WRITE;
/*!40000 ALTER TABLE `stock_receipts` DISABLE KEYS */;
INSERT INTO `stock_receipts` VALUES (1,6,'GIÀY BÓNG ĐÁ JOMA TOP FLEX TF','JOMA',30,1800000,54000000,'nhap 30 doi giay','2026-09-14 17:58:48'),(2,2,'Adidas Ultra Boost','Adidas',50,3000000,150000000,'nhap kho truoc 50 doi giay','2026-10-06 16:25:24');
/*!40000 ALTER TABLE `stock_receipts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `note` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'joma','12345678900','test01@gmail.com','77 trinh van bo','kho hang hoa khu CN TVB','2026-09-14 18:01:00');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06 23:52:33
