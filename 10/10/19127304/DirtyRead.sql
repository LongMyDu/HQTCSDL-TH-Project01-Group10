USE DB_QLDatChuyenHang
GO

-- Transaction 1: Bán 8 sản phẩm '100028', sau đó hủy do lỗi số lượng
alter procedure Ban_SanPham_SoLuong
(
	@masp int,
	@soluongban int
)
as
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

		Update SANPHAM
		Set SoLuongTon = @soluongton
		Where MaSP = @masp

		Waitfor DELAY '00:00:05'
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

-- Transaction 2: Xem thông tin sản phẩm '100028' thuộc chi nhánh '100023'
alter procedure XemTatCa_SANPHAM_ThuocChiNhanh
(
	@MaChiNhanh int
)
as
begin tran
	Set transaction isolation level read uncommitted

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

	declare @TongSoSP int 
	set @TongSoSP = (select count (sp.MaSP) from SANPHAM sp 
						where sp.MaChiNhanh = @MaChiNhanh)
	print N'Có ' + cast (@TongSoSP as nvarchar(10))+N' sản phẩm'

	select  * from SANPHAM sp where sp.MaChiNhanh = @MaChiNhanh 
	select @TongSoSP as Tongso

	commit tran
GO