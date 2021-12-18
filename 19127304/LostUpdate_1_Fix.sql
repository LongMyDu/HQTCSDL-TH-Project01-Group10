USE DB_QLDatChuyenHang
GO

-- Transaction 1: Bán được 3 sản phẩm '100001' và cập nhật số lượng tồn
alter procedure Ban_SanPham_SoLuong
(
	@masp int,
	@soluongban int
)
as
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
Begin Tran
	Declare @soluongton int

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
		Set @soluongton =(select SoLuongTon
							from SANPHAM where MaSP = @masp)

		Set @soluongton = @soluongton - @soluongban

		Waitfor DELAY '00:00:05'
		Update SANPHAM
		Set SoLuongTon = @soluongton
		Where MaSP = @masp

		if exists
		(
			select *
			from SANPHAM SP
			where SP.MaSP = @masp and SP.SoLuongTon < 0
		)
		Begin
			Raiserror('Sản phẩm không đủ số lượng.', 16, 1)
			Rollback Tran
		End

	End
Commit Tran
Go

-- Transaction 2: Thêm vào 5 sản phẩm '100001' và cập nhật số lượng tồn
alter procedure Them_SanPham_SoLuong
(
	@masp int,
	@soluongthem int
)
as
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
Begin Tran
	Declare @soluongton int

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
		Select @soluongton =(select SoLuongTon
							from SANPHAM where MaSP = @masp)

		Waitfor DELAY '00:00:02'
		Set @soluongton = @soluongton + @soluongthem
		
		Update SANPHAM
		Set SoLuongTon = @soluongton
		Where MaSP = @masp
	End
Commit Tran
Go		