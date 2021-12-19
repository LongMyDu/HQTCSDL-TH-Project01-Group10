-- Lost Update
-- Transaction 1: Thay đổi giá bán của sản phẩm '100066' thành 120.000đ

USE DB_QLDatChuyenHang
GO

exec dbo.CapNhat_SANPHAM_gia '100066', '120000';

Select * from SANPHAM