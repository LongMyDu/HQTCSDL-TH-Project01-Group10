-- Lost Update
-- Transaction 2: Giảm giá 10% tất cả sản phẩm của chi nhánh '100043'

USE DB_QLDatChuyenHang
GO

exec dbo.CapNhat_SANPHAM_GiamGiaDongLoat '100043', '10';

Select * from SANPHAM
Where MaChiNhanh = '100043'