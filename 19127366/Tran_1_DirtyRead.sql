-- Lỗi: Dirty Read 01
-- Transaction 1: : Giảm giá 120% cho tất cả sản phẩm được cung cấp bởi chi nhánh 1.

USE DB_QLDatChuyenHang
GO

begin tran
	
	Declare @MaChiNhanh int, @PhanTramGiamGia int
	Select	@MaChiNhanh = 1,
			@PhanTramGiamGia = 120

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
	
	if @PhanTramGiamGia > 100
	begin
		raiserror('Phần trăm giảm giá không hợp lệ', 16, 1);
		rollback tran
	end
	else
		commit tran