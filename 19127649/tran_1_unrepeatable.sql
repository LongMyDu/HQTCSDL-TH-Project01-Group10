-- unrepeatable read 
-- T1: đăng nhập vào tài khoản DT01

begin tran 

declare @MK varchar(20), @TK varchar(20) 
select @TK = 'DT01', @MK = '123' 

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
