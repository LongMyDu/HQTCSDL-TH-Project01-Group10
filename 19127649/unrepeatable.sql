
-- T1: đăng nhập vào tài khoản 
use DB_QLDatChuyenHang
go 
create proc DangNhap
(	
	@TK varchar(20),
	@MK varchar(20)
	
)
 
as
begin tran 	
	SET TRAN ISOLATION LEVEL READ UNCOMMITTED
	if (LEN(@TK) > 20) 
		begin
			raiserror(N'Tên đăng nhập không tồn tại', 16,1)
			rollback tran 
		end

	else if (LEN(@MK) > 20) 
		begin
			raiserror(N'Sai mật khẩu', 16,1)
			rollback tran 
		end 

	else if not exists(select * from TaiKhoan
						where TaiKhoan.TenTaiKhoan = @TK and TaiKhoan.MatKhau = @MK) 
		begin
			raiserror (N'Sai tên đăng nhập hoặc mật khẩu', 16,1) 
			rollback tran  
		end
	else 
			print (N'Đăng nhập thành công')

	waitfor delay '00:00:10'

	if not exists (select * from TaiKhoan 
					where TaiKhoan.TenTaiKhoan = @TK and TaiKhoan.MatKhau = @MK)
		begin 
			raiserror(N'Không tìm thấy thông tin tài khoản này',16,1)
			rollback tran  
		end
commit tran 

go 
-- transaction 2: đổi mk tài khoản 

create proc DoiMatKhau
(
	@TK varchar(20), 
	@MK varchar(20), 
	@MKMoi varchar(20), 
	@MKMoiLan2 varchar(20)
)
as
begin tran  


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
		commit tran 
	end 
