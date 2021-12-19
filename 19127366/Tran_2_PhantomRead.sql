-- Lỗi: Phantom Read 01
-- Transaction 2: Thêm đơn hàng mới thuộc chi nhánh 1.

USE DB_QLDatChuyenHang
GO

exec Them_DONHANG @MaDonHang = 5, @HinhThucThanhToan = N'Tiền mặt', @DiaChiGiaoHang = N'402 Nguyễn Thị Minh Khai, Q.1',@PhiVC = 30000, @PhiSP = 450000, @MaChiNhanh = 1,@MaKH = 1, @NgayLap = '11/20/2021'


-- Chạy câu lệnh này khi đã chạy file fix lỗi
--exec Them_DONHANG @MaDonHang = 6, @HinhThucThanhToan = N'Tiền mặt', @DiaChiGiaoHang = N'402 Nguyễn Thị Minh Khai, Q.1',@PhiVC = 30000, @PhiSP = 450000, @MaChiNhanh = 1,@MaKH = 1, @NgayLap = '11/20/2021'
