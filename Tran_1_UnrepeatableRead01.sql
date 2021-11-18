use DB_QLDatChuyenHang
GO

-- Giảm giá 20% sản phẩm 1 nếu giá sản phẩm này dưới 500.000.
begin tran
	Declare @MaSP int, @MucGiaToiDa bigint, @PhanTramGiamGia int
	Select	@MaSP = 1,
			@MucGiaToiDa = 500000,
			@PhanTramGiamGia = 20

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
		Print(N'Lần đọc 1: ' + CAST(@GiaHienTai as nvarchar(10)))

		WAITFOR DELAY '00:00:10'
		if (@GiaHienTai < @MucGiaToiDa)
		begin
			Declare @GiaChuaGiam bigint
			Set @GiaChuaGiam = (Select Gia From SanPham Where MaSP = @MaSP)
			Print(N'Lần đọc 2: ' + CAST(@GiaChuaGiam as nvarchar(10)))

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




