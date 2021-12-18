use DB_QLDatChuyenHang
GO


-- Transaction 1: Tìm sản phẩm có chữ hữu cơ.
alter procedure Tim_SANPHAM_Ten
(
	@TenSP nvarchar(100),
	@KetQuaTimKiem nvarchar(100) OUTPUT
)
as
begin tran
	SET TRAN ISOLATION LEVEL READ UNCOMMITTED
	if exists 
	(
		Select * 
		From SANPHAM SP
		Where SP.TenSP LIKE ('%' + @TenSP + '%')
	)
	begin
		Set @KetQuaTimKiem = (N'Tồn tại kết quả')
		print @KetQuaTimKiem

		WAITFOR DELAY '00:00:10'
		Select * 
		From SANPHAM SP
		Where SP.TenSP LIKE ('%' + @TenSP + '%')
	end
	else
	begin
		Set @KetQuaTimKiem = N'Không tồn tại kết quả' 
	end
	commit tran
GO

-- Transaction 2: Thay đổi tên của sản phẩm 1 thành 'Hạt hạnh nhân'.
alter procedure CapNhat_SANPHAM_Ten
(
	@MaSP int,
	@TenMoi nvarchar(100)
)
as
begin tran
	if not exists 
		(
			select*
			from SANPHAM SP
			where SP.MaSP = @MaSP
		)
		begin
			raiserror('Không tìm thấy sản phẩm.', 16, 1)
			rollback tran
		end
	else
		begin
			update SANPHAM
			set [TenSP] = @TenMoi
			where [MaSP] = @MaSP

			commit tran
		end