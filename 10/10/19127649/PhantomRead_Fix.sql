use DB_QLDatChuyenHang
go
-- Transaction 1: khách hàng xem các sản phẩm của chi nhánh 1 
alter proc XemTatCa_SANPHAM_ThuocChiNhanh
(
	@MaChiNhanh int
)
as
begin tran 

	SET TRAN ISOLATION LEVEL SERIALIZABLE
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

	waitfor delay '00:00:10' --delay 10s 
	select  * from SANPHAM sp where sp.MaChiNhanh = @MaChiNhanh 
	select @TongSoSP as Tongso
	commit tran
go
--Transaction 2 : đối tác thêm một sản phẩm vào chi nhánh 1 
alter proc Them_1_Sp_VaoChiNhanh
	(
	@MaSP int, 
	@TenSP nvarchar(100),
	@Gia bigint,
	@SoLuongTon int,
	@MaChiNhanh int 
	)
	as
begin tran

	if @Gia < 0
	begin
		raiserror('Giá sản phẩm không hợp lệ.', 16, 1)
		rollback tran
	end
	else
	begin
		insert into SANPHAM (MaSP, TenSP, Gia, SoLuongTon, MaChiNhanh)
		values (@MaSP, @TenSP, @Gia, @SoLuongTon, @MaChiNhanh)
		commit tran
	end