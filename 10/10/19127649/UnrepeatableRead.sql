use DB_QLDatChuyenHang
go 

-- Transaction 1: đăng nhập vào tài khoản 

alter proc DangNhap
(	
	@TK varchar(20),
	@MK varchar(20)
	
)
 
as
begin tran 	
	SET TRAN ISOLATION LEVEL READ UNCOMMITTED	

	if exists(select * from TaiKhoan
						where TaiKhoan.TenTaiKhoan = @TK and TaiKhoan.MatKhau = @MK) 
		
		begin
			print (N'Đăng nhập thành công')
			waitfor delay '00:00:05' --delay 5s 

		if not exists (select * from TaiKhoan 
					where TaiKhoan.TenTaiKhoan = @TK and TaiKhoan.MatKhau = @MK)
			begin 
				
				raiserror(N'Không tìm thấy thông tin tài khoản này',16,1)
				rollback Tran  
			end
		else 
			begin 
				declare @Loai char(2),
						@MaNguoiDung int
				set @MaNguoiDung = -1
				select @Loai = PhanLoai
				from TaiKhoan
				where TaiKhoan.TenTaiKhoan = @TK
					if (@Loai = 'KH')
						begin
							select @MaNguoiDung  = MaKH
							from TaiKhoan tk join KhachHang  kh on tk.TenTaiKhoan = kh.TenTaiKhoan 
						end
					else if (@Loai = 'DT')
						begin
							select @MaNguoiDung = dt.MaDoiTac 
							from TaiKhoan tk join DOITAC dt on tk.TenTaiKhoan = dt.TenTaiKhoan
						end 
					select @MaNguoiDung as MaNguoiDung,
							@Loai as LoaiTaiKhoan
			end
	end
	else 
		begin 
			raiserror(N'Tài khoản hoặc mật khẩu không đúng',16,1);
		end
 IF @@TRANCOUNT > 0 COMMIT TRAN

go 
-- transaction 2: đổi mk tài khoản 

alter proc DoiMatKhau
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
