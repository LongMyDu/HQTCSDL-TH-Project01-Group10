-- Lost Update
-- Transaction 2: Thêm vào 5 sản phẩm '100001' và cập nhật số lượng tồn

USE DB_QLDatChuyenHang
GO

exec dbo.Them_SanPham_SoLuong '100001', '5';

Select * from SANPHAM