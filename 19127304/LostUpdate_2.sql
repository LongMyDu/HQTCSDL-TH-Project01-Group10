USE DB_QLDatChuyenHang
GO

-- Transaction 1: Thay đổi giá bán của sản phẩm '100066' thành 120.000đ
Create procedure CapNhat_SANPHAM_gia
(
	@MaSP int,
	@GiaMoi bigint
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

	else if @GiaMoi < 0
	begin
		raiserror('Giá sản phẩm không hợp lệ.', 16, 1)
		rollback tran
	end

	else
	begin
		Waitfor DELAY '00:00:12'
		update SANPHAM
		set [Gia] = @GiaMoi
		where [MaSP] = @MaSP
	end
commit tran
Go

-- Transaction 2: Giảm giá 10% tất cả sản phẩm của chi nhánh '100043'
Create procedure CapNhat_SANPHAM_GiamGiaDongLoat
(
	@MaChiNhanh int,
	@PhanTramGiamGia int = 0
)
as
begin tran
	if not exists 
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
		Waitfor DELAY '00:00:03'
		update SANPHAM 
		set Gia = convert(bigint, Gia * (100 - @PhanTramGiamGia) /100)
		where MaChiNhanh = @MaChiNhanh
		
	end
		
	if @PhanTramGiamGia > 100
	begin
		raiserror('Phần trăm giảm giá không hợp lệ', 16, 1);
		rollback tran
	end			
commit tran
Go