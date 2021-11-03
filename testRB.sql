USE DB_QLDatChuyenHang
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
