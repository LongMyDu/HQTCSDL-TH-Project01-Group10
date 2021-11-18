USE DB_QLDatChuyenHang
GO

exec dbo.dangky_TAIKHOAN @TenTaiKhoan = 'LMD', @MatKhau = '111', @PhanLoai = 'AD';
exec dbo.dangky_TAIKHOAN @TenTaiKhoan = 'TKT', @MatKhau = '222', @PhanLoai = 'DT';
exec dbo.dangky_TAIKHOAN @TenTaiKhoan = 'TTT', @MatKhau = '333', @PhanLoai = 'KH';

Select * From TaiKhoan
Select * From KHACHHANG
Select * From TAIXE
Select * From DOITAC
Select * From NhanVien
Select * From Admin

UPDATE TaiKhoan
Set PhanLoai = 'DT'
WHERE TenTaiKhoan = 'ttt'

INSERT INTO KHACHHANG (MaKH, HoTen, TenTaiKhoan)
VALUES (1, N'Long Mỹ Du', 'lmd')

INSERT INTO DOITAC (MaDoiTac, TenDoiTac, TenTaiKhoan)
VALUES (1, N'Phạm Đoàn Ngọc Trinh', 'pdnt')

INSERT INTO DOITAC (MaDoiTac, TenDoiTac, TenTaiKhoan)
VALUES (2, N'Tô Thanh Tuấn', 'ttt')



UPDATE DOITAC
SET TenTaiKhoan = 'ttt'
WHERE MaDoiTac = 2

--Delete From KHACHHANG
--Delete From DOITAC
--Delete From TaiKhoan
--Delete From TAIXE


-- Tạo tài khoản mẫu để test quyền
exec sp_addlogin 'ExampleAdmin', '123456', 'DB_QLDatChuyenHang'
exec sp_addlogin 'LMD', '123456', 'DB_QLDatChuyenHang'

Create user ExampleAdmin For login ExampleAdmin
Create user LMD For login LMD 
exec sp_addrolemember 'Admin','ExampleAdmin'  -- Chỉ có exampleAdmin là thuộc role admin, LMD thì không


-- Tạo tài khoản nhân viên
exec sp_addlogin 'nhanvien1', 'nhanvien1'
exec sp_addlogin 'nhanvien2', '123456'
create user nhanvien1 for login nhanvien1 
create user ttt for login nhanvien2

exec sp_addrolemember 'Nhanvien', 'nhanvien1'
exec sp_addrolemember 'nhanvien','ttt' 
exec sp_addrolemember 'nhanvien','nhanvien2' 


-- tạo tài khoản mẫu cho khách hàng 
exec sp_addlogin 'customer1' , '123456','DB_QLDatChuyenHang'
exec sp_addlogin 'customer2', '123456'
exec sp_addlogin 'customer3', '123456'
exec sp_addlogin 'customer4', '123456'
-- tạo user tương ứng cho tài khoản 

create user customer1 for login customer1 
create user customer3 for login customer3
create user customer2 for login customer2
create user customer4 for login customer4

-- them user customer1 vao role khach hang 
exec sp_addrolemember 'Customer','customer1'



--revoke select on donhang from taixe
--revoke select on Doitac from Customer  

-- Thêm tài khoản
INSERT INTO TAIKHOAN (TenTaiKhoan, MatKhau, PhanLoai)
VALUES	('longmydu', 'dumylong', 'KH'),
		('duynguyen', 'nguyenduy', 'KH')

-- Thêm chi nhánh
INSERT INTO CHINHANH (DiaChi)
VALUES (N'45 Hải Biên, Q.1'),
	(N'93 Nguyễn Văn cừ, Q.5')


-- Thêm khách hàng
INSERT INTO KHACHHANG (HoTen, DiaChi, TenTaiKhoan)
VALUES	(N'Long Mỹ Du', '329 Đường 3/2, Q.5', 'longmydu'),
		(N'Nguyễn Huỳnh Khánh Duy', '43 Nguyễn Thị Minh Khai, Q.1', 'duynguyen')


-- Test procedure capnhat_taikhoan_gia
select * from sanpham
select * from donhang
delete SANPHAM


exec them_SANPHAM N'Khô Heo Cháy Tỏi DTFood Đặc Biệt Thơm Ngon', 85000,1
exec them_SANPHAM N'Thùng 20 gói Mì Rong Biển Ottogi 120gx20',247000,1
exec them_SANPHAM N'Mì Trộn Xốt Tương Đen Hàn Quốc Ottogi 135Gr', 36400, 1


exec capnhat_SANPHAM_gia 1, 450000
exec capnhat_SANPHAM_GiamGiaDongLoat 1, 10

exec XemTatCa_SANPHAM_ThuocChiNhanh 1



exec Them_DONHANG N'Tiền mặt', N'182 Nguyễn Huệ, Q.1', 20000, 1, 1
exec XemTatCa_DONHANG_ThuocChiNhanh 1, N'Chờ xác nhận'