-- T1: khách hàng xem các sản phẩm của chi nhánh 1 
use DB_QLDatChuyenHang
go
create proc XemSP_ThuocChiNhanh
(
	@MaChiNhanh int 
)
as
begin tran 

	SET TRAN ISOLATION LEVEL REPEATABLE READ
if not exists (select * from CHINHANH
				where CHINHANH.MaChiNhanh = 1 )
	begin 
		raiserror(N'Không có chi nhánh này', 16,1) 
		rollback 
	end 
declare @TongSoSP int 
	set @TongSoSP = (select count (sp.MaSP) from SANPHAM sp 
						where sp.MaChiNhanh = @MaChiNhanh)
	print N'Có ' + cast (@TongSoSP as nvarchar(10))+N' sản phẩm'

waitfor delay '00:00:05' --delay 5s 
	select * from SANPHAM sp where sp.MaChiNhanh = @MaChiNhanh 
	commit tran

go 
--T2 : đối tác thêm một sản phẩm vào chi nhánh 1 
create proc Them_1_Sp_VaoChiNhanh
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