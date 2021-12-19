-- Dirty Read
-- Transaction 1: Bán 8 sản phẩm '100028', sau đó bị hủy do lỗi số lượng

USE DB_QLDatChuyenHang
GO

exec dbo.Ban_SanPham_SoLuong '100028', '8';

Select * from SANPHAM