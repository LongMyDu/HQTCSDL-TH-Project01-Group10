-- Lost Update
-- Transaction 1: Bán được 3 sản phẩm '100001' và cập nhật số lượng tồn

USE DB_QLDatChuyenHang
GO

exec dbo.Ban_SanPham_SoLuong '100001', '3';

Select * from SANPHAM