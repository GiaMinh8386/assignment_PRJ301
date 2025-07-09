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
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'WP-005', N'BioTechUSA Hydro Whey Zero', N'3.7g BCAA, 7.5g EAA, 4g Glutamine',N'Biotech USA', 2300000, 'WP-005.png', 1, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'WP-006', N'ON Platinum Hydrowhey', N'Ít đường, ít calo phù hợp với người ăn kiêng', N'Optimum Nutrition', 2550000, 'WP-006.png', 1, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'WP-007', N'Mutant ISO Surge', N'Bổ sung enzyme hỗ trợ tiêu hóa', N'Mutant', 2300000, 'WP-007.png', 1, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'WP-008', N'BiotechUSA ISO Whey Zero', N'22G Protein Isolate; Hương vị dễ uống', N'Biotech USA', 2300000, 'WP-008.png', 1, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'WP-009', N'ON Whey Gold Standard 100% Whey Protein', N'Bán chạy nhất thế giới 9 năm liên tiếp', N'Optimum Nutrition', 2280000, 'WP-009.png', 1, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'WP-010', N'AllMax IsoFlex', N'Cung cấp Enzyme hỗ trợ tiêu hóa tốt hơn', N'AllMax Nutrition', 2350000, 'WP-010.png', 1, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-001', N'BareBells Bar', N'200 calo, 20g protein hỗ trợ xây dựng cơ bắp, hương vị thơm ngon', N'BareBells', 80000, 'P-001.png', 2, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-002', N'Orgain Organic Protein & Superfoods Plant Based Protein Powder', N'160 Calories, 21g Protein Thực Vật, 5g Chất béo tốt, 10g chất xơ', N'Orgain', 630000, 'P-002.png', 2, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-003', N'Applied Nutrition Clear Vegan Protein', N'11g protein thuần chay, 2g BCAA mỗi lần dùng, chỉ có 1.4g carb, 49 calo & rất ít đường', N'Applied Nutrition', 750000, 'P-003.png', 2, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-004', N'Sữa tăng cân REPP Sports Raze Mass Gainer', N'1350 calo, 275g Carb, 55g Protein, hương vị độ đáo, tăng khả năng hấp thu dinh dưỡng', N'Repp Sports', 1450000, 'P-004.png', 2, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-005', N'Whey Protein Hammer Bar', N'Bổ sung protein và carb duy trì năng lượng', N'Hammer Nutrition', 780000, 'P-005.png', 2, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-006', N'Applied Nutrition Clear Vegan Protein', N'Hương vị trái cây thanh mát, thơm ngon', N'Applied Nutrition', 600000, 'P-006.png', 2, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-007', N'Perfect Diesel Vegan', N'100% Protein từ thực vật', N'Perfect Sports', 1050000, 'P-007.png', 2, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-008', N'Protein Bar Ostrovit The Bar', N'15g Protein chất lượng cao', N'Ostrovit', 45000, 'P-008.png', 2, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-009', N'VitaXtrong Mega Mass Pro 1350', N'1350 calo giúp tăng cân nhanh, hiệu quả', N'VitaXtrong', 1600000, 'P-009.png', 2, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'P-010', N'Thanh Protein Bar Warrior Crunch High Protein, Low Sugar Bar', N'Bữa ăn phụ NGON - BỔ -TIỆN', N'Warrior', 75000, 'P-010.png', 2, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-001', N'Ostrovit Creatine Monohydrate', N'Tốt cho việc phát triển cơ bắp, tăng cường sức bền tập luyện, gia tăng hiệu suất tập luyện', N'Ostrovit', 650000, 'SMSB-001.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-002', N'Nutricost Creatine Monohydrate Powder Micronized', N'Tăng sức mạnh, sức bền, tăng kích thước và khối lượng cơ bắp, pump phồng cơ, thúc đẩy tổng hợp protein', N'Nutricost', 450000, 'SMSB-002.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-003', N'Ark Drops Natural Perfomance Booster', N'Tăng lưu lượng oxy, bùng nổ kích thích ngay tức thời, tăng năng lượng, tăng hiệu suất', N'Ark Drops', 899000, 'SMSB-003.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-004', N'BSN AMINOx Endurance & Recovery', N'Gia tăng hiệu suất tập luyện, hỗ trợ sức bền cơ bắp', N'BSN', 750000, 'SMSB-004.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-005', N'Now Micronized Creatine Monohydrate Powder', N'Được micronized hóa với kích thước phân tử chỉ bằng 1/17 so với creatine thông thường', N'Now', 690000, 'SMSB-005.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-006', N'Nutricost EAA 1200mg - Essential Amino Acids', N'Dạng viên con nhộng tiện lợi, dễ bảo quản', N'Nutricost', 600000, 'SMSB-006.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-007', N'Hammer GEL Rapid Energy Fuel', N'Tăng lượng đường trong máu khi vận động cường độ cao', N'Hammer Nutrition', 48000, 'SMSB-007.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-008', N'Viên sủi bù điện giải Hammer Endurrolytes FIZZ', N'Không đường, không chất tạo ngọt nhân tạo', N'Hammer Nutrition', 170000, 'SMSB-008.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-009', N'Viên bổ sung điện giải Nutricost Electrolyte Complex with Real Salt', N'Thành phần đặc biệt Real Salt® giúp tối ưu hiệu quả hydrat hóa', N'Nutricost', 440000, 'SMSB-009.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'SMSB-010', N'Bột phục hồi Hammer Recoverite Recovery Drink', N'Tỷ lệ Carb : Protein lý tưởng giúp phục hồi cơ bắp hiệu quả', N'Hammer Nutrition', 2000000, 'SMSB-010.png', 3, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-001', N'USN Cutting Edge L-Carnicut+Liquid 3500mg', N'Đốt mỡ, chuyển hóa mỡ thừa thành năng lượng', N'USN', 550000, 'HTGM-001.png', 4, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-002', N'Nutrex Lipo 6 Black Cleanse & Detox, 60 Capsules', N'Nhuận tràng, giảm đầy hơi, khó tiêu; giảm mức cholesterol và lipid máu; tăng cường trao đổi chất, giảm tích tụ mỡ thừa', N'Nutrex', 490000, 'HTGM-002.png', 4, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-003', N'Ostrovit L-Carnitine 1250mg, 60 Capsules', N'Giảm kích thước của các tế bào mỡ, kích thích phát triển cơ bắp nạc; ngăn chặn sự tích mỡ của cơ thể; giảm thèm ăn, giúp kiểm soát calo tốt hơn', N'Ostrovit', 390000, 'HTGM-003.png', 4, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-004', N'Nutricost L-Carnitine Tartrate Capsules', N'Đốt mỡ, chuyển hóa mỡ thừa thành năng lượng; tăng phục hồi cơ bắp, giảm đau nhức cơ bắp', N'Nutricost', 550000, 'HTGM-004.png', 4, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-005', N'MuscleTech Hydroxycut Hardcore Elite', N'270mg Caffeine Anhydrous', N'MuscleTech', 500000, 'HTGM-005.png', 4, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-006', N'Nutrex Lipo-6 Black Hers Ultra Concentrate, 60 Black-Cap', N'Hỗ Trợ Giảm Mỡ Hiệu Quả', N'Nutrex', 490000, 'HTGM-006.png', 4, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-007', N'JYM Supplement Science Shred JYM - Fat Burner, 240 v-Capsules', N'1.5 grams (1500 milligrams) Acetyl-L-Carnitine', N'JYM', 750000, 'HTGM-007.png', 4, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-008', N'Repp Sports Raze L-Carnitine 3000mg Liquid, 31 Serving', N'Tăng cường chuyển hóa chất béo', N'Repp Sports', 700000, 'HTGM-008.png', 4, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-009', N'AP Sports Regimen L-Carnitine 3000mg, 31 Servings', N'Thúc đẩy sản xuất năng lượng tự nhiên', N'Alpha Prime', 600000, 'HTGM-009.png', 4, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'HTGM-010', N'GHOST Burn, 60 Servings', N'Tăng cường trao đổi chất đốt cháy calo dư thừa', N'GHOST', 900000, 'HTGM-010.png', 4, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-001', N'Viên uống mọc tóc CodeAge Hair Vitamins', N'Cải thiện nang tóc, kích thích mọc tóc; giảm gãy rụng, xơ rối, chẻ ngọn', N'Code Age', 1550000, 'VTM-001.png', 5, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-002', N'Bronson Basics Vitamin K2 MK-7 + D3', N'Tăng cường hấp thụ canxi; cải thiện sức khỏe tim mạch; gia tăng hiệu quả tập luyện; tăng cường sức đề kháng', N'Bronson', 250000, 'VTM-002.png', 5, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-003', N'Fully Active B Complex with Quatrefolic', N'Hỗ trợ sản xuất năng lượng và trao đổi chất', N'Doctor''s Best', 520000, 'VTM-003.png', 5, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-004', N'Now Vitamin C-1000 With Rose Hips & Bioflavonoids', N'Hỗ trợ làm sáng da, làm mờ vết thâm mụn từ bên trong', N'Now', 600000, 'VTM-004.png', 5, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-005', N'Now Vitamin D-3 & K-2, 1,000 IU / 45 mcg, 120 Veg Capsules', N'Tối ưu khả năng hấp thụ canxi vào xương, răng', N'Now', 320000, 'VTM-005.png', 5, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-006', N'JYM Supplement Science Vita JYM, 60 Tablets', N'Cung cấp 25 vi chất quan trọng nhất với người tập luyện', N'JYM', 490000, 'VTM-006.png', 5, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-007', N'JYM Supplement Science ZMA JYM, 90 Vegetarian Capsules', N'30mg Kẽm', N'JYM', 650000, 'VTM-007.png', 5, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-008', N'Scitec Nutrition Multi Pro Plus, 30 Servings', N'OMEGA-3, LECITHIN VÀ COENZYME Q–10', N'Scitec Nutrition', 880000, 'VTM-008.png', 5, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-009', N'Nutricost Vitamin K2 MK-7 100 mcg', N'Hỗ trợ tổng thể sức khỏe của xương', N'Nutricost', 690000, 'VTM-009.png', 5, 1)
INSERT [dbo].[tblProducts] ([productID], [productName], [description], [brand], [price], [imageURL], [categoryID], [status]) VALUES (N'VTM-010', N'NOW Foods P-5-P | 50 mg', N'Hỗ trợ giảm stress, điều hòa tâm trạng', N'Now', 350000, 'VTM-005.png', 5, 1)
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