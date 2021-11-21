-- Lỗi: Phantom Read 01
-- Transaction 1: Xem tất cả đơn hàng thuộc chi nhánh 1 trong tình trạng “Chờ xác nhận”.

USE DB_QLDatChuyenHang
GO

exec XemTatCa_DONHANG_ThuocChiNhanh @MaChiNhanh = 1, @TinhTrang = N'Chờ xác nhận'
