use DB_QLDatChuyenHang
GO


-- Thêm chi nhánh
INSERT INTO CHINHANH (DiaChi)
VALUES (N'45 Hải Biên, Q.1'),
	(N'93 Nguyễn Văn cừ, Q.5')

GO

-- Thêm sản phẩm
Delete SANPHAM
GO

INSERT INTO SANPHAM (TenSP, Gia, SoLuongTon, MaChiNhanh)
VALUES	(N'Hạt hạnh nhân hữu cơ 1kg', 450000, 100, 1),
		(N'Khô Heo Cháy Tỏi DTFood Đặc Biệt Thơm Ngon', 85000, 100, 1),
		(N'Thùng 20 gói Mì Rong Biển Ottogi 120gx20',250000, 200, 1),
		(N'Mì Trộn Xốt Tương Đen Hàn Quốc Ottogi 135Gr', 35000, 50, 1)
