﻿USE DB_QLDatChuyenHang
GO

INSERT INTO TaiKhoan (TenTaiKhoan, MatKhau, PhanLoai)
VALUES ('lmd', '123', 'KH')

INSERT INTO TaiKhoan (TenTaiKhoan, MatKhau, PhanLoai)
VALUES ('pdnt', '123', 'KH')

INSERT INTO TaiKhoan (TenTaiKhoan, MatKhau, PhanLoai)
VALUES ('ttt', '123', 'KH')

INSERT INTO TaiKhoan (TenTaiKhoan, MatKhau, PhanLoai)
VALUES ('ttt2', '123', 'DT')

UPDATE TaiKhoan
Set PhanLoai = 'DT'
WHERE TenTaiKhoan = 'ttt'

INSERT INTO KHACHHANG (MaKH, HoTen, TenTaiKhoan)
VALUES (1, N'Long Mỹ Du', 'lmd')

INSERT INTO DOITAC (MaDoiTac, TenDoiTac, TenTaiKhoan)
VALUES (1, N'Phạm Đoàn Ngọc Trinh', 'pdnt')

INSERT INTO DOITAC (MaDoiTac, TenDoiTac, TenTaiKhoan)
VALUES (2, N'Tô Thanh Tuấn', 'ttt')


Select * From TaiKhoan
Select * From KHACHHANG
Select * From TAIXE
Select * From DOITAC
Select * From NhanVien
Select * From Admin

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