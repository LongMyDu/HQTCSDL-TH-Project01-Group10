use DB_QLDatChuyenHang
GO

-- Transaction 1: Tìm sản phẩm có chữ hữu cơ.
alter procedure Tim_SANPHAM_Ten
(
	@TenSP nvarchar(100)
)
as
begin tran
	SET TRAN ISOLATION LEVEL REPEATABLE READ
	if exists 
	(
		Select * 
		From SANPHAM SP
		Where SP.TenSP LIKE ('%' + @TenSP + '%')
	)
	begin
		print(N'Tồn tại sản phẩm có tên ' + @TenSP);
		WAITFOR DELAY '00:00:10'
		Select * 
		From SANPHAM SP
		Where SP.TenSP LIKE ('%' + @TenSP + '%')
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
