DROP DATABASE [WheyStoreConsultationPortal]
GO

CREATE DATABASE [WheyStoreConsultationPortal]
GO 
USE [WheyStoreConsultationPortal]
GO 
-- 1. Categories (Danh mục sản phẩm)
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255)
);

-- 2. Products (Sản phẩm)
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Brand NVARCHAR(100),
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL,
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID)
	ADD ImageURL VARCHAR(255);
	ADD ProductCode VARCHAR(10);
);

-- 3. Customers (Khách hàng)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Address NVARCHAR(255),
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(100) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);

go 

-- 4. Orders (Đơn hàng)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    ShipperID INT, -- sẽ được liên kết bên dưới
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Pending'
);

-- 5. OrderDetails (Chi tiết đơn hàng)
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL
);

-- 6. Users (Tài khoản Admin / Nhân viên)
CREATE TABLE Admins (
    AdminID INT PRIMARY KEY IDENTITY(1,1),
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(100) NOT NULL,
    Role NVARCHAR(50) NOT NULL CHECK (Role IN ('Admin', 'Staff')),
    CreatedDate DATETIME DEFAULT GETDATE()
);

go 


-- 7. Guarantee(Bảo hành )
CREATE TABLE Guarantee (
    GuaranteeID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    GuaranteeStartDate DATETIME DEFAULT GETDATE(),
    GuaranteeEndDate DATETIME NOT NULL,
    Note NVARCHAR(255)
);

-- 8. Reviews (Đánh giá sản phẩm)
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX),
    ReviewDate DATETIME DEFAULT GETDATE()
);
go 
-- Thêm Admin và Staff
-- Admins và Staff
INSERT INTO Admins (Username, Password, Role)
VALUES
('admin01', 'admin123', 'Admin'),
('staff01', 'staff123', 'Staff');

-- Customers
INSERT INTO Customers (FullName, Email, Phone, Address, Username, Password)
VALUES
(N'Nguyễn Văn A', 'nva@example.com', '0901234567', N'Hà Nội', 'nvauser', 'nva123'),
(N'Lê Thị B', 'ltb@example.com', '0912345678', N'Hồ Chí Minh', 'ltbuser', 'ltb123'),
(N'Trần Văn C', 'tvc@example.com', '0934567890', N'Đà Nẵng', 'tvcuser', 'tvc123');


-- Whey Protein (CategoryID = 1)
INSERT INTO Products (ProductCode, ProductName, CategoryID)
VALUES
('1.1', N'Whey Gold Standard', 1),
('1.2', N'Serious Mass', 1),
('1.3', N'Rule 1 Whey Blend', 1),
('1.4', N'NitroTech Whey', 1);

-- Creatine (CategoryID = 2)
INSERT INTO Products (ProductCode, ProductName, CategoryID)
VALUES
('2.1', N'Creatine Monohydrate 300g', 2),
('2.2', N'Micronized Creatine', 2),
('2.3', N'Creactor Formula', 2),
('2.4', N'Creatine 600g', 2);

-- Sức khỏe toàn diện (CategoryID = 3)
INSERT INTO Products (ProductCode, ProductName, CategoryID)
VALUES
('3.1', N'Vitamin Tổng hợp Daily', 3),
('3.2', N'Multivitamin Women', 3),
('3.3', N'Multivitamin Men Sport', 3),
('3.4', N'Zinc + Magnesium + B6', 3);

-- Hỗ trợ giảm mỡ (CategoryID = 4)
INSERT INTO Products (ProductCode, ProductName, CategoryID)
VALUES
('4.1', N'Lipo 6 Black', 4),
('4.2', N'Hydroxycut Hardcore', 4),
('4.3', N'CLA 1000', 4),
('4.4', N'Thermogenic Burner', 4);

-- Sinh lý & nội tiết tố (CategoryID = 5)
INSERT INTO Products (ProductCode, ProductName, CategoryID)
VALUES
('5.1', N'Tribulus 625mg', 5),
('5.2', N'Maca Root Extract', 5),
('5.3', N'Fenugreek Booster', 5),
('5.4', N'Kẽm + Vitamin D3', 5);

GO