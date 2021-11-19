-- Lỗi: Phantom Read 01
-- Transaction 2: Thêm đơn hàng mới thuộc chi nhánh 1.

USE DB_QLDatChuyenHang
GO


begin tran
	declare @HinhThucThanhToan nvarchar(20),
			@DiaChiGiaoHang nvarchar(50),
			@PhiVC int,
			@MaKH int,
			@MaChiNhanh int,
			@NgayLap datetime

	Select	@HinhThucThanhToan = N'Tiền mặt',
			@DiaChiGiaoHang = N'402 Nguyễn Thị Minh Khai, Q.1',
			@PhiVC = 30000,
			@MaChiNhanh = 1,
			@MaKH = 1,
			@NgayLap = GETDATE()

	-- !!!Không cần kiểm tra MaKH và MaChiNhanh vì đã có Foreign Key Constraint
	insert into DONHANG (HinhThucThanhToan, DiaChiGiaoHang, PhiVC, MaKH, MaChiNhanh, NgayLap, TinhTrangVanChuyen)
	values (@HinhThucThanhToan, @DiaChiGiaoHang, @PhiVC, @MaKH, @MaChiNhanh, @NgayLap, N'Chờ xác nhận')
	commit tran

