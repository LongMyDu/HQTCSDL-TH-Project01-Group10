-- T1: khách hàng xem các sản phẩm của chi nhánh 1 

begin tran 
declare @MaChiNhanh int 
select @MaChiNhanh = 1 
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
