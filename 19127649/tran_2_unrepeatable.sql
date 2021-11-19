-- transaction 2: đổi mk tài khoản DT01 
use DB_QLDatChuyenHang

begin tran  
declare @TK varchar(20), @MK varchar(20), @MKMoi varchar(20), @MKMoiLan2 varchar(20)
select @TK = 'DT01', @MK = '123', @MKMoi = '456',@MKMoiLan2  = '456'

if not exists(select * from TaiKhoan where taikhoan.TenTaiKhoan = @TK and TaiKhoan.MatKhau = @MK ) 
	begin 
		raiserror(N'Tài khoản hoặc mật khẩu không chính xác',16,1) 
		rollback 
	end 
else if (@MKMoi = null or len(@MKMoi) > 20 ) 
	begin 
	raiserror (N'Mật khẩu mới không hợp lệ',16,1)
	rollback 
	end
else if (@MKMoi != @MKMoiLan2 ) 
	begin 
	raiserror (N'Nhập sai mật khẩu mới',16,1)
	rollback 
	end
else  
	begin 
		update TaiKhoan 
		set MatKhau = @MKMoi 
		where TaiKhoan.TenTaiKhoan = @TK 
		print N'Đổi mật khẩu thành công'
	end 
commit tran 