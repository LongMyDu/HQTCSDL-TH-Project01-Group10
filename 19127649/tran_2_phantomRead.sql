--T2 : đối tác thêm một sản phẩm vào chi nhánh 1 

begin tran
	declare
	@TenSP nvarchar(100),
	@Gia bigint,
	@SoLuongTon int = NULL,
	@MaChiNhanh int = NULL

select 

	@TenSP = N'Sữa ông thọ 300g',
	@Gia = 25000,
	@SoLuongTon = 100, 
	@MaChiNhanh = 1

	if @Gia < 0
	begin
		raiserror('Giá sản phẩm không hợp lệ.', 16, 1)
		rollback tran
	end
	else
	begin
		insert into SANPHAM (TenSP, Gia, SoLuongTon, MaChiNhanh)
		values (@TenSP, @Gia, @SoLuongTon, @MaChiNhanh)
		commit tran
	end