-- Lost Update
-- Xem số lượng tồn của sản phẩm '100001'
-- Transaction 1: Bán được 3 sản phẩm '100001' và cập nhật số lượng tồn

USE DB_QLDatChuyenHang
GO

Begin Tran T1
	Declare @masp int, @soluongton int, @soluongban int
	Select @masp = 100001

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
		Set @soluongban = 3
		Select @soluongton =(select SoLuongTon
							from SANPHAM where MaSP = @masp)

		Waitfor DELAY '00:00:12'
		Set @soluongton = @soluongton - @soluongban

		Update SANPHAM
		Set SoLuongTon = @soluongton
		Where MaSP = @masp
	End
Commit Tran T1

Select * from SANPHAM