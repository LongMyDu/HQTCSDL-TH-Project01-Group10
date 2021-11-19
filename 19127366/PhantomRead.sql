use DB_QLDatChuyenHang
GO

-- Thêm tài khoản
INSERT INTO TAIKHOAN (TenTaiKhoan, MatKhau, PhanLoai)
VALUES	('longmydu', 'dumylong', 'KH'),
		('duynguyen', 'nguyenduy', 'KH')

GO

-- Thêm khách hàng
INSERT INTO KHACHHANG (HoTen, DiaChi, TenTaiKhoan)
VALUES	(N'Long Mỹ Du', '329 Đường 3/2, Q.5', 'longmydu'),
		(N'Nguyễn Huỳnh Khánh Duy', '43 Nguyễn Thị Minh Khai, Q.1', 'duynguyen')

GO

-- Thêm chi nhánh
INSERT INTO CHINHANH (DiaChi)
VALUES (N'45 Hải Biên, Q.1'),
	(N'93 Nguyễn Văn cừ, Q.5')

GO

-- Thêm đơn hàng
INSERT INTO DONHANG (HinhThucThanhToan, DiaChiGiaoHang, PhiVC, MaKH, MaChiNhanh, NgayLap, TinhTrangVanChuyen)
VALUES	(N'Tiền mặt', N'182 Nguyễn Huệ, Q.1', 20000, 1, 1, '10/21/2021', N'Chờ xác nhận'),
		(N'MoMo', N'64 Hàn Hải Nguyên, Q.11', 20000, 2, 1, '10/3/2021', N'Chờ xác nhận')