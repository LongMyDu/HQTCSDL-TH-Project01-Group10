use DB_QLDatChuyenHang
GO

-- Transaction 1: Giảm giá 20% sản phẩm 1 nếu giá sản phẩm này dưới 500.000.
create procedure CapNhat_SANPHAM_GiamGiaCoDieuKien
(
	@MaSP int,
	@MucGiaToiDa bigint,
	@PhanTramGiamGia int
)
as
begin tran
	SET TRAN ISOLATION LEVEL READ UNCOMMITTED
	if not exists 
	(
		select *
		from SANPHAM SP
		where SP.MaSP = @MaSP
	)
	begin
		raiserror('Không tìm thấy sản phẩm.', 16, 1)
		rollback tran
	end

	else if @MucGiaToiDa < 0
	begin
		raiserror('Mức giá tối đa của sản phẩm không hợp lệ.', 16, 1)
		rollback tran
	end

	else
	begin
		Declare @GiaHienTai bigint
		Set @GiaHienTai = (Select Gia From SanPham Where MaSP = @MaSP)
		Print(N'Giá của sản phẩm 1 ở lần đọc 1: ' + CAST(@GiaHienTai as nvarchar(10)))

		WAITFOR DELAY '00:00:10'
		if (@GiaHienTai < @MucGiaToiDa)
		begin
			Declare @GiaChuaGiam bigint
			Set @GiaChuaGiam = (Select Gia From SanPham Where MaSP = @MaSP)
			Print(N'Giá của sản phẩm 1 ở lần đọc 2: ' + CAST(@GiaChuaGiam as nvarchar(10)))

			Declare @GiaDaGiam bigint
			Set @GiaDaGiam = CAST(@GiaChuaGiam * (100 - @PhanTramGiamGia) / 100 as bigint)

			update SANPHAM 
			set Gia = @GiaDaGiam
			where MaSP = @MaSP

			commit tran
		end
		else
			rollback tran
	end

GO

-- Transaction 2: Thay đổi giá của sản phẩm 1 thành 550000.
create procedure CapNhat_SANPHAM_gia
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
		begin
			update SANPHAM
			set [Gia] = @GiaMoi
			where [MaSP] = @MaSP

			commit tran
		end