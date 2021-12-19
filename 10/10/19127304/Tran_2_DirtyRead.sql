-- Dirty Read
-- Transaction 2: Xem thông tin sản phẩm '100028' thuộc chi nhánh '100023'

USE DB_QLDatChuyenHang
GO

exec dbo.XemTatCa_SANPHAM_ThuocChiNhanh '100023';