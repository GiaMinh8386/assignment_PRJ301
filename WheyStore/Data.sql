USE [master]
GO

ALTER DATABASE [WheyStoreConsultationPortal]
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE [WheyStoreConsultationPortal];
GO

CREATE DATABASE [WheyStoreConsultationPortal];
GO

USE [WheyStoreConsultationPortal];
GO

-- 1. Users (Quản lý tài khoản người dùng: Admin/ Customer)
CREATE TABLE [dbo].[tblUsers] (
	[userID] [nvarchar](50) PRIMARY KEY NOT NULL,
	[fullname] [nvarchar](50) NULL,
	[email] [varchar](100) NOT NULL UNIQUE,
	[phone] [varchar](20),
	[address] [nvarchar](255),
	[username] [varchar](50) NOT NULL UNIQUE,
	[password] [nvarchar](256) NOT NULL,
	[roleID] [nvarchar](50) NOT NULL CHECK (RoleID IN ('AD', 'MB')),
	[status] [bit] NULL,
	[createdDate] DATETIME DEFAULT GETDATE()
)
GO
INSERT [dbo].[tblUsers] ([userID], [fullname], [email], [phone], [address], [username], [password], [roleID], [status]) VALUES (N'admin01', N'Administrator', N'admin1@gmail.com', N'0909113355', N'678 Lũy Bán Bích, P. Tân Thành, Q. Tân Phú, TP. Hồ Chí Minh', N'admin', N'1', N'AD', 1)
INSERT [dbo].[tblUsers] ([userID], [fullname], [email], [phone], [address], [username], [password], [roleID], [status]) VALUES (N'SE194044', N'Nguyễn Quốc Huy', N'huynguyen12042005@gmail.com', N'0824530430', N'12/4 Mạc Văn Thành, KP.6, P.2, TP. Gò Công, Tiền Giang', N'huynq', N'1', N'MB', 1)
INSERT [dbo].[tblUsers] ([userID], [fullname], [email], [phone], [address], [username], [password], [roleID], [status]) VALUES (N'SE172324', N'Nguyễn Trung Hậu', N'hauntse172324@fpt.edu.vn', N'0778819157', N'286 Trần Phú, Phường 7, Quận 5, TP. Hồ Chí Minh', N'haunt', N'1', N'MB', 1)
INSERT [dbo].[tblUsers] ([userID], [fullname], [email], [phone], [address], [username], [password], [roleID], [status]) VALUES (N'SE171594', N'Nguyễn Ngô Gia Minh', N'minhnngse171594@fpt.edu.vn', N'0908472386', N'388 Điện Biên Phủ, P.17, Q. Bình Thạnh, TP. Hồ Chí Minh', N'minhnng', N'1', N'MB', 1)
GO

-- 2. Categories (Danh mục sản phẩm)
CREATE TABLE [dbo].[tblCategories] (
	[categoryID] [int] IDENTITY(1,1) PRIMARY KEY,
    [categoryName] [nvarchar](100) NOT NULL,
    [description] [nvarchar](MAX)
)
GO
INSERT [dbo].[tblCategories]([categoryName], [description]) VALUES (N'Whey Protein', N'Whey Protein là sản phẩm được tách ra trong quá trình sản xuất phô mai, được xử lý qua quá trình phân tách lọc và sấy khô để tạo ra bột Whey. Sản phẩm Whey protein được đánh giá là một trong những dòng thực phẩm bổ sung có nguồn Protein tinh khiết hấp thụ nhanh, hỗ trợ khách hàng phát triển, phục hồi cơ bắp tốt trong quá trình tập luyện')
INSERT [dbo].[tblCategories]([categoryName], [description]) VALUES (N'Protein', N'')
INSERT [dbo].[tblCategories]([categoryName], [description]) VALUES (N'Sức Mạnh & Sức Bền', N'')
INSERT [dbo].[tblCategories]([categoryName], [description]) VALUES (N'Hỗ Trợ Giảm Mỡ', N'Hỗ Trợ Giảm Mỡ là các sản phẩm có công thức mạnh mẽ trong việc tăng khả năng sinh nhiệt của cơ thể, hỗ trợ khả năng đốt cháy chất béo tự nhiên. Với một số chất nổi bật như CLA, L-Carnitine, Yohimbine, Green Tea Extract')
INSERT [dbo].[tblCategories]([categoryName], [description]) VALUES (N'Vitamin & Khoáng Chất', N'')
GO

-- 3. Products (Quản lý sản phẩm chi tiết)
CREATE TABLE [dbo].[tblProducts] (
	[productID] [nvarchar](50) PRIMARY KEY NOT NULL,
	[productName] [nvarchar](100) NOT NULL,
	[description] [nvarchar](500) NOT NULL,
	[brand] [nvarchar](100) NOT NULL,
	[price] DECIMAL(10,2) NOT NULL,
	[imageURL][varchar](255) NULL,
	[categoryID] [int] FOREIGN KEY REFERENCES tblCategories(categoryID),
	[status] [bit] NOT NULL
)
GO
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'WP-001', N'PVL ISO Gold - Premium Whey Protein With Probiotic', N'Người tập luyện, vận động viên, người không ăn đủ đạm, người không dung nạp lactose', N'PVL - Canada', 2350000, 'WP-001.png', 1, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'WP-002', N'GHOST Whey Protein', N'Hỗ trợ xây dựng cơ bắp, cải thiện sức mạnh toàn diện, tăng tốc độ phục hồi sau khi tập luyện', N'GHOST LIFESTYLE', 1200000, 'WP-002.png', 1, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'WP-003', N'Rule 1 Protein', N'25G Protein (tỷ lệ đạt 83.3%), 0 Sugar, 0 Lactose, 0 Gluten, No Amino Spiking', N'Rule One Protein', 1950000, 'WP-003.png', 1, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'WP-004', N'Nutrabolics Hydropure', N'100% Hydrolyzed Whey Protein, 28g Protein, không chứa Lactose, Gluten', N'Nutrabolics Nutrition', 1950000, 'WP-004.png', 1, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-001', N'BareBells Bar', N'200 calo, 20g protein hỗ trợ xây dựng cơ bắp, hương vị thơm ngon', N'BareBells', 80000, 'P-001.png', 2, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-002', N'Orgain Organic Protein & Superfoods Plant Based Protein Powder', N'160 Calories, 21g Protein Thực Vật, 5g Chất béo tốt, 10g chất xơ', N'Orgain', 630000, 'P-002.png', 2, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-003', N'Applied Nutrition Clear Vegan Protein', N'11g protein thuần chay, 2g BCAA mỗi lần dùng, chỉ có 1.4g carb, 49 calo & rất ít đường', N'Applied Nutrition', 750000, 'P-003.png', 2, 0)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-004', N'Sữa tăng cân REPP Sports Raze Mass Gainer', N'1350 calo, 275g Carb, 55g Protein, hương vị độ đáo, tăng khả năng hấp thu dinh dưỡng', N'Repp Sports', 1450000, 'P-004.png', 2, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-001', N'Ostrovit Creatine Monohydrate', N'Tốt cho việc phát triển cơ bắp, tăng cường sức bền tập luyện, gia tăng hiệu suất tập luyện', N'Ostrovit', 650000, 'SMSB-001.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-002', N'Nutricost Creatine Monohydrate Powder Micronized', N'Tăng sức mạnh, sức bền, tăng kích thước và khối lượng cơ bắp, pump phồng cơ, thúc đẩy tổng hợp protein', N'Nutricost', 450000, 'SMSB-002.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-003', N'Ark Drops Natural Perfomance Booster', N'Tăng lưu lượng oxy, bùng nổ kích thích ngay tức thời, tăng năng lượng, tăng hiệu suất', N'Ark Drops', 899000, 'SMSB-003.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-004', N'BSN AMINOx Endurance & Recovery', N'Gia tăng hiệu suất tập luyện, hỗ trợ sức bền cơ bắp', N'BSN', 750000, 'SMSB-004.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-001', N'USN Cutting Edge L-Carnicut+Liquid 3500mg', N'Đốt mỡ, chuyển hóa mỡ thừa thành năng lượng', N'USN', 550000, 'HTGM-001.png', 4, 0)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-002', N'Nutrex Lipo 6 Black Cleanse & Detox, 60 Capsules', N'Nhuận tràng, giảm đầy hơi, khó tiêu; giảm mức cholesterol và lipid máu; tăng cường trao đổi chất, giảm tích tụ mỡ thừa', N'Nutrex', 490000, 'HTGM-002.png', 4, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-003', N'Ostrovit L-Carnitine 1250mg, 60 Capsules', N'Giảm kích thước của các tế bào mỡ, kích thích phát triển cơ bắp nạc; ngăn chặn sự tích mỡ của cơ thể; giảm thèm ăn, giúp kiểm soát calo tốt hơn', N'Ostrovit', 390000, 'HTGM-003.png', 4, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-004', N'Nutricost L-Carnitine Tartrate Capsules', N'Đốt mỡ, chuyển hóa mỡ thừa thành năng lượng; tăng phục hồi cơ bắp, giảm đau nhức cơ bắp', N'Nutricost', 550000, 'HTGM-004.png', 4, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-001', N'Viên uống mọc tóc CodeAge Hair Vitamins', N'Cải thiện nang tóc, kích thích mọc tóc; giảm gãy rụng, xơ rối, chẻ ngọn', N'Code Age', 1550000, 'VTM-001.png', 5, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-002', N'Bronson Basics Vitamin K2 MK-7 + D3', N'Tăng cường hấp thụ canxi; cải thiện sức khỏe tim mạch; gia tăng hiệu quả tập luyện; tăng cường sức đề kháng', N'Bronson', 250000, 'VTM-002.png', 5, 0)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-003', N'Fully Active B Complex with Quatrefolic', N'Hỗ trợ sản xuất năng lượng và trao đổi chất', N'Doctor''s Best', 520000, 'VTM-003.png', 5, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-004', N'Now Vitamin C-1000 With Rose Hips & Bioflavonoids', N'Hỗ trợ làm sáng da, làm mờ vết thâm mụn từ bên trong', N'Now', 600000, 'VTM-004.png', 5, 1)
GO

-- 4. Orders (Đơn đặt hàng của người dùng)
CREATE TABLE [dbo].[tblOrders] (
    [orderID] [int] PRIMARY KEY IDENTITY(1,1),
    [userID] [nvarchar](50) FOREIGN KEY REFERENCES tblUsers(userID),
    [orderDate] DATETIME DEFAULT GETDATE(),
    [totalAmount] DECIMAL(10,2) NOT NULL,
    [status] [nvarchar](50) DEFAULT 'Pending'
);
GO

-- 5. OrderDetails (Chi tiết từng đơn hàng: sản phẩm, số lượng)
CREATE TABLE [dbo].[tblOrderDetails] (
    [orderDetailID] [int] PRIMARY KEY IDENTITY(1,1),
    [orderID] [int] FOREIGN KEY REFERENCES tblOrders(orderID),
	[productID] [nvarchar](50) FOREIGN KEY REFERENCES tblProducts(productID),
    [quantity] [int] NOT NULL,
    [unitPrice] DECIMAL(10,2) NOT NULL
);
GO

-- 6. Reviews (Đánh giá sản phẩm: sao, bình luận, user)
CREATE TABLE [dbo].[tblReviews] (
    [reviewID] [int] PRIMARY KEY IDENTITY(1,1),
	[productID] [nvarchar](50) FOREIGN KEY REFERENCES tblProducts(productID),
    [userID] [nvarchar](50) FOREIGN KEY REFERENCES tblUsers(userID),
    [rating] [int] CHECK (Rating BETWEEN 1 AND 5),
    [comment] [nvarchar](MAX),
    [reviewDate] [datetime] DEFAULT GETDATE()
);
GO

-- 7. CartItems (Sản phẩm trong giỏ hàng tạm thời)
CREATE TABLE [dbo].[tblCartItems] (
    [cart_item_id] [int] PRIMARY KEY IDENTITY,
    [userID] [nvarchar](50) FOREIGN KEY REFERENCES tblUsers(userID),
    [productID] [nvarchar](50) FOREIGN KEY REFERENCES tblProducts(productID),
    [quantity] [int] NOT NULL,
    [added_at] [datetime] DEFAULT GETDATE()
);
GO

-- 8. Favorites (Danh sách sản phẩm yêu thích của người dùng)
CREATE TABLE [dbo].[tblFavorites] (
    [favoriteID] [int] PRIMARY KEY IDENTITY(1,1),
    [userID] [nvarchar](50)  FOREIGN KEY REFERENCES tblUsers(userID),
    [productID] [nvarchar](50)  FOREIGN KEY REFERENCES tblProducts(productID),
    [added_at] [datetime] DEFAULT GETDATE()
);
GO