use DB_QLDatChuyenHang
GO

-- Transaction 1: Xem tất cả đơn hàng thuộc chi nhánh 1 trong tình trạng “Chờ xác nhận”.
alter procedure XemTatCa_DONHANG_ThuocChiNhanh
(
	@MaChiNhanh int,
	@TinhTrang nvarchar(50),
	@SoDonHang int OUTPUT
)
as
begin tran
	SET TRAN ISOLATION LEVEL REPEATABLE READ
	if @MaChiNhanh != NULL and not exists 
	(
		select *
		from CHINHANH CN
		where CN.MaChiNhanh = @MaChiNhanh
	)
	begin
		raiserror('Không tìm thấy chi nhánh.', 16, 1);
		rollback tran
	end
	else 
	begin
		Set @SoDonHang = (
			Select count(*)
			From DONHANG
			Where MaChiNhanh = @MaChiNhanh and TinhTrangVanChuyen = @TinhTrang
		)
		
		Print N'Tổng số đơn hàng trong tình trạng "' + @TinhTrang + '": ' + CAST(@SoDonHang AS VARCHAR(10))
		WAITFOR DELAY '00:00:10'

		Select *
		From DONHANG
		Where MaChiNhanh = @MaChiNhanh and TinhTrangVanChuyen = @TinhTrang
		commit tran
	end

GO

-- Transaction 2: Thêm đơn hàng mới thuộc chi nhánh 1.
alter procedure Them_DONHANG
(
	@MaDonHang int,
	@HinhThucThanhToan nvarchar(20),
	@DiaChiGiaoHang nvarchar(50),
	@PhiVC int,
	@MaKH int,
	@MaChiNhanh int,
	@NgayLap datetime
)
as
begin tran
	-- !!!Không cần kiểm tra MaKH và MaChiNhanh vì đã có Foreign Key Constraint
	insert into DONHANG (MaDonHang, HinhThucThanhToan, DiaChiGiaoHang, PhiVC, MaKH, MaChiNhanh, NgayLap, TinhTrangVanChuyen)
	values (@MaDonHang, @HinhThucThanhToan, @DiaChiGiaoHang, @PhiVC, @MaKH, @MaChiNhanh, @NgayLap, N'Chờ xác nhận')
	commit tran
