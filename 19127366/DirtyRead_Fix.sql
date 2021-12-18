use DB_QLDatChuyenHang
GO

-- Transaction 1: : Giảm giá 10% cho tất cả sản phẩm được cung cấp bởi chi nhánh 1.
alter procedure CapNhat_SANPHAM_GiamGiaDongLoat
(
	@MaChiNhanh int,
	@PhanTramGiamGia int = 0
)
as
begin tran
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
		update SANPHAM 
		set Gia = convert(bigint, Gia * (100 - @PhanTramGiamGia) /100)
		where MaChiNhanh = @MaChiNhanh
		WAITFOR DELAY '00:00:10'
	end
	Declare @Suco bit = 1
	if (@Suco = 1)
	begin
		raiserror('Đã xảy ra sự cố', 16, 1);
		rollback tran
	end
	else
		commit tran

GO

-- Transaction 2: : Đọc thông tin các sản phẩm được cung cấp bởi chi nhánh 1.
alter procedure XemTatCa_SANPHAM_ThuocChiNhanh
(
	@MaChiNhanh int
)
as
begin tran
	
	SET TRAN ISOLATION LEVEL READ COMMITTED		
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
		Select *
		From SANPHAM
		Where MaChiNhanh = @MaChiNhanh
		commit tran
	end