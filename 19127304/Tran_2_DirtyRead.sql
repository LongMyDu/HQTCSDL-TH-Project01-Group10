-- Dirty Read
-- Xem số lượng tồn của sản phẩm '100001'
-- Transaction 2: Xem thông tin sản phẩm

USE DB_QLDatChuyenHang
GO

Set transaction isolation level read uncommitted

Select * from SANPHAM