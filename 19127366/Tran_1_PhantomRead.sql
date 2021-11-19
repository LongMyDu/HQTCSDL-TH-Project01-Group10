-- Lỗi: Phantom Read 01
-- Transaction 1: Xem tất cả đơn hàng thuộc chi nhánh 1 trong tình trạng “Chờ xác nhận”.

USE DB_QLDatChuyenHang
GO

begin tran
	Declare @MaChiNhanh int, @TinhTrang nvarchar(50)
	Select	@MaChiNhanh = 1,
			@TinhTrang = N'Chờ xác nhận'

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
		Declare @SoDonHangChoXacNhan int
		Set @SoDonHangChoXacNhan = (
			Select count(*)
			From DONHANG
			Where MaChiNhanh = @MaChiNhanh and TinhTrangVanChuyen = @TinhTrang
		)
		
		Print N'Tổng số đơn hàng trong tình trạng "' + @TinhTrang + '": ' + CAST(@SoDonHangChoXacNhan AS VARCHAR(10))
		WAITFOR DELAY '00:00:10'

		Select *
		From DONHANG
		Where MaChiNhanh = @MaChiNhanh and TinhTrangVanChuyen = @TinhTrang
		commit tran
	end