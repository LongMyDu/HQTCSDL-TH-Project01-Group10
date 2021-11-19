-- Lỗi: Dirty Read 01
-- Transaction 2: : Đọc thông tin các sản phẩm được cung cấp bởi chi nhánh 1.

USE DB_QLDatChuyenHang
GO

begin tran
	Declare @MaChiNhanh int
	Select	@MaChiNhanh = 1
	
	SET TRAN ISOLATION LEVEL READ UNCOMMITTED		
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