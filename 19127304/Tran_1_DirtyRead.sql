-- Dirty Read
-- Xem số lượng tồn của sản phẩm '100028'
-- Transaction 1: Cập nhật số lượng tồn của sản phẩm, sau đó hủy

USE DB_QLDatChuyenHang
GO

Begin Tran T1
	Declare @masp int, @soluongton int, @soluongban int
	Select @masp = 100028

	if not exists
	(
		select *
		from SANPHAM SP
		where SP.MaSP = @masp
	)
	Begin
		Raiserror('Không tồn tại sản phẩm này.', 16, 1)
		Rollback tran
	End

	else
	Begin
		Set @soluongban = 8
		Select @soluongton =(select SoLuongTon
							from SANPHAM where MaSP = @masp)

		Set @soluongton = @soluongton - @soluongban

		Update SANPHAM
		Set SoLuongTon = @soluongton
		Where MaSP = @masp

		Waitfor DELAY '00:00:10'
		if exists
		(
			select *
			from SANPHAM SP
			where SP.MaSP = @masp and SP.SoLuongTon < 0
		)
		Begin
			Raiserror('Sản phẩm không đủ số lượng.', 16, 1)
			Rollback Tran T1
		End

	End
Commit Tran T1

Select * from SANPHAM