use DB_QLDatChuyenHang
GO

/*
Danh sách các procedure đã tồn tại:
	1. dangky_TAIKHOAN
	2. huy_TAIKHOAN
	3. capnhat_TAIKHOAN_PhanLoai
	4. CapNhat_SANPHAM_gia
	5. Them_1_Sp_VaoChiNhanh
	6. Them_DONHANG
	7. CapNhat_SANPHAM_GiamGiaDongLoat
	8. XemTatCa_SANPHAM_ThuocChiNhanh
	9. XemTatCa_DONHANG_ThuocChiNhanh
	10. CapNhat_SANPHAM_GiamGiaCoDieuKien: Procedure giảm giá X% của một sản phẩm nếu giá của sản phẩm đó dưới Y
	11. Ban_SanPham_SoLuong: Bán số lượng x sản phẩm y
	12. Them_SanPham_SoLuong: Thêm số lượng x sản phẩm y
	13. DangNhap: Đăng nhập 
	14. DoiMatKhau: Đổi mật khẩu 
	15. Tim_SANPHAM_Ten: tìm sản phẩm có tên chứa từ khóa
	16. CapNhat_SANPHAM_Ten: cập nhật tên của 1 sản phẩm
*/


create procedure dangky_TAIKHOAN
(
	@TenTaiKhoan varchar(20),
	@MatKhau varchar(20),
	@PhanLoai char(2)
)
as
begin tran
	if exists 
		(
			select*
			from TaiKhoan TK
			where TK.TenTaiKhoan = @TenTaiKhoan
		)
		begin
			raiserror('Tên tài khoản đã được sử dụng.', 16, 1)
			rollback tran
		end

	else
		insert into TaiKhoan ([TenTaiKhoan], [MatKhau], [PhanLoai])
		values (@TenTaiKhoan, @MatKhau, @PhanLoai)

		if @PhanLoai = 'DT'
			begin
				insert into DOITAC ([TenTaiKhoan]) values (@TenTaiKhoan)
			end

		else if @PhanLoai = 'KH'
			begin
				insert into KHACHHANG([TenTaiKhoan]) values (@TenTaiKhoan)
			end

		else if @PhanLoai = 'TX'
			begin
				insert into TAIXE([TenTaiKhoan]) values (@TenTaiKhoan)
			end

		else if @PhanLoai = 'NV'
			begin
				insert into NhanVien([TenTaiKhoan]) values (@TenTaiKhoan)
			end

		else if @PhanLoai = 'AD'
			begin
				insert into Admin([TenTaiKhoan]) values (@TenTaiKhoan)
			end

		else
			begin
				raiserror('Phân loại không hợp lệ', 16, 1)
				rollback tran
			end
commit tran
GO

create procedure huy_TAIKHOAN
(
	@TenTaiKhoan varchar(20),
	@MatKhau varchar(20),
	@PhanLoai char(2)
)
as

begin tran
	if not exists 
		(
			select*
			from TaiKhoan TK
			where TK.TenTaiKhoan = @TenTaiKhoan
		)
		begin
			raiserror('Không tìm thấy tài khoản.', 16, 1)
			rollback tran
		end

	else
		delete from TaiKhoan where [TenTaiKhoan] = @TenTaiKhoan

		if @PhanLoai = 'DT'
			begin
				delete from DOITAC where [TenTaiKhoan] = @TenTaiKhoan
			end

		else if @PhanLoai = 'KH'
			begin
				delete from KHACHHANG where [TenTaiKhoan] = @TenTaiKhoan
			end

		else if @PhanLoai = 'TX'
			begin
				delete from TAIXE where [TenTaiKhoan] = @TenTaiKhoan
			end

		else if @PhanLoai = 'NV'
			begin
				delete from NhanVien where [TenTaiKhoan] = @TenTaiKhoan
			end

		else if @PhanLoai = 'AD'
			begin
				delete from Admin where [TenTaiKhoan] = @TenTaiKhoan
			end
commit tran
GO

create procedure capnhat_TAIKHOAN_PhanLoai
(
	@TenTaiKhoan varchar(20),
	@PhanLoai char(2)
)
as
begin tran
	if not exists 
		(
			select*
			from TaiKhoan TK
			where TK.TenTaiKhoan = @TenTaiKhoan
		)
		begin
			raiserror('Không tìm thấy tài khoản.', 16, 1)
			rollback tran
		end

	else
		-- tạo biến tạm giữ "phân loại" cũ
		declare @PhanLoai_cu as char(2)
		set @PhanLoai_cu = (select TK.PhanLoai from TaiKhoan TK
		where TK.TenTaiKhoan = @TenTaiKhoan)

		update TaiKhoan
		set [PhanLoai] = @PhanLoai
		where [TenTaiKhoan] = @TenTaiKhoan

		-- thêm tài khoản mới vào bảng tương ứng 
		if @PhanLoai = 'DT'
			begin
				insert into DOITAC ([TenTaiKhoan]) values (@TenTaiKhoan)
			end

		else if @PhanLoai = 'KH'
			begin
				insert into KHACHHANG([TenTaiKhoan]) values (@TenTaiKhoan)
			end

		else if @PhanLoai = 'TX'
			begin
				insert into TAIXE([TenTaiKhoan]) values (@TenTaiKhoan)
			end

		else if @PhanLoai = 'NV'
			begin
				insert into NhanVien([TenTaiKhoan]) values (@TenTaiKhoan)
			end

		else if @PhanLoai = 'AD'
			begin
				insert into Admin([TenTaiKhoan]) values (@TenTaiKhoan)
			end

		else
			begin
				raiserror('Phân loại không hợp lệ', 16, 1)
				rollback tran
			end

		-- xóa tài khoản cũ ở bảng tương ứng 
		if @PhanLoai_cu = 'DT'
			begin
				delete from DOITAC where [TenTaiKhoan] = @TenTaiKhoan
			end

		else if @PhanLoai_cu = 'KH'
			begin
				delete from KHACHHANG where [TenTaiKhoan] = @TenTaiKhoan
			end

		else if @PhanLoai_cu = 'TX'
			begin
				delete from TAIXE where [TenTaiKhoan] = @TenTaiKhoan
			end

		else if @PhanLoai_cu = 'NV'
			begin
				delete from NhanVien where [TenTaiKhoan] = @TenTaiKhoan
			end

		else if @PhanLoai_cu = 'AD'
			begin
				delete from Admin where [TenTaiKhoan] = @TenTaiKhoan
			end

commit tran
GO

-- Procedure cập nhật giá sản phẩm
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
GO


-- Procedure Thêm sản phẩm mới
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
GO

-- Procedure giảm giá lượng phần trăm X cho tất cả sản phẩm được cung cấp bởi một chi nhánh Y
create procedure CapNhat_SANPHAM_GiamGiaDongLoat
(
	@MaChiNhanh int,
	@PhanTramGiamGia int = 0
)
as
begin tran
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
	else 
	begin
		update SANPHAM 
		set Gia = convert(bigint, Gia * (100 - @PhanTramGiamGia) /100)
		where MaChiNhanh = @MaChiNhanh

		Declare @Suco bit = 0
		if (@Suco = 1)
		begin
			raiserror('Đã xảy ra sự cố', 16, 1);
			rollback tran
		end
		else
			commit tran
	end
	
GO


--Procedure xem tất cả sản phẩm của chi nhánh X

create proc XemTatCa_SANPHAM_ThuocChiNhanh
(
	@MaChiNhanh int
)
as
begin tran 

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

	select  * from SANPHAM sp where sp.MaChiNhanh = @MaChiNhanh 
	select @TongSoSP as Tongso
	commit tran

GO

--Procedure xem tất cả đơn hàng của chi nhánh X có tình trạng vận chuyển Y
create procedure XemTatCa_DONHANG_ThuocChiNhanh
(
	@MaChiNhanh int,
	@TinhTrang nvarchar(50),
	@SoDonHang int OUTPUT
)
as
begin tran
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
	else 
	begin
		Set @SoDonHang = (
			Select count(*)
			From DONHANG
			Where MaChiNhanh = @MaChiNhanh and TinhTrangVanChuyen = @TinhTrang
		)
		
		Print N'Tổng số đơn hàng trong tình trạng "' + @TinhTrang + '": ' + CAST(@SoDonHang AS VARCHAR(10))
		
		Select *
		From DONHANG
		Where MaChiNhanh = @MaChiNhanh and TinhTrangVanChuyen = @TinhTrang
		commit tran
	end

GO

--Procedure thêm đơn hàng mới 
create procedure Them_DONHANG
(
	@MaDonHang int,
	@NgayLap datetime,
	@HinhThucThanhToan nvarchar(20),
	@DiaChiGiaoHang nvarchar(50),
	@PhiSP int,
	@PhiVC int,
	@MaKH int,
	@MaChiNhanh int
)
as
begin tran
	-- !!!Không cần kiểm tra MaKH và MaChiNhanh vì đã có Foreign Key Constraint
	insert into DONHANG (MaDonHang, NgayLap, HinhThucThanhToan, DiaChiGiaoHang, PhiSP, PhiVC, MaKH, MaChiNhanh, TinhTrangVanChuyen)
	values (@MaDonHang, CAST(@NgayLap AS DateTime), @HinhThucThanhToan, @DiaChiGiaoHang, @PhiSP, @PhiVC, @MaKH, @MaChiNhanh, N'Chờ xác nhận')
commit tran	
GO

create procedure Them_CTDonHang
(
	@MaSP int, 
	@MaDonHang int,
	@SoLuong int,
	@Gia bigint
)
as
begin tran
	insert into CHITIETDONHANG(MaSP, MaDonHang, SoLuong, Gia)
	values (@MaSP, @MaDonHang, @SoLuong, @Gia)
commit tran
go


--Procedure Bán số lượng x sản phẩm y
Create procedure Ban_SanPham_SoLuong
(
	@masp int,
	@soluongban int
)
as
Begin Tran
	Declare @soluongton int

	if not exists
	(
		select *
		from SANPHAM SP
		where SP.MaSP = @masp
	)
	Begin
		Raiserror('Không tồn tại sản phẩm này.', 16, 1)
		Rollback tran
	End

	else
	Begin
		Set @soluongton =(select SoLuongTon
							from SANPHAM where MaSP = @masp)

		Set @soluongton = @soluongton - @soluongban

		Update SANPHAM
		Set SoLuongTon = @soluongton
		Where MaSP = @masp

		if exists
		(
			select *
			from SANPHAM SP
			where SP.MaSP = @masp and SP.SoLuongTon < 0
		)
		Begin
			Raiserror('Sản phẩm không đủ số lượng.', 16, 1)
			Rollback Tran
		End

	End
Commit Tran
Go

--Procedure Thêm số lượng x sản phẩm y
Create procedure Them_SanPham_SoLuong
(
	@masp int,
	@soluongthem int
)
as

Begin Tran
	Declare @soluongton int

	if not exists
	(
		select *
		from SANPHAM SP
		where SP.MaSP = @masp
	)
	Begin
		Raiserror('Không tồn tại sản phẩm này.', 16, 1)
		Rollback tran
	End

	else
	Begin
		Select @soluongton =(select SoLuongTon
							from SANPHAM where MaSP = @masp)

		Set @soluongton = @soluongton + @soluongthem
		
		Update SANPHAM
		Set SoLuongTon = @soluongton
		Where MaSP = @masp
	End
Commit Tran
Go			

-- DangNhap: Đăng nhập 

create proc DangNhap
(	
	@TK varchar(20),
	@MK varchar(20)
	
)
 
as
begin tran 	

	if exists(select * from TaiKhoan
						where TaiKhoan.TenTaiKhoan = @TK and TaiKhoan.MatKhau = @MK) 
		
		begin
			print (N'Đăng nhập thành công')

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

-- DoiMatKhau: đổi mật khẩu 

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

else if (@MKMoi = @MK ) 
	begin 
	raiserror (N'Mật khẩu mới phải khác mật khẩu cũ',16,1)
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
GO
create procedure Tim_SANPHAM_Ten
(
	@TenSP nvarchar(100),
	@KetQuaTimKiem nvarchar(100) OUTPUT
)
as
begin tran
	if exists 
	(
		Select * 
		From SANPHAM SP
		Where SP.TenSP LIKE ('%' + @TenSP + '%')
	)
	begin
		Set @KetQuaTimKiem = (N'Tồn tại kết quả')
		print @KetQuaTimKiem

		WAITFOR DELAY '00:00:10'
		Select * 
		From SANPHAM SP
		Where SP.TenSP LIKE ('%' + @TenSP + '%')
	end
	else
	begin
		Set @KetQuaTimKiem = N'Không tồn tại kết quả' 
	end
	commit tran
GO


-- Transaction 2: Thay đổi tên của sản phẩm 1 thành 'Hạt hạnh nhân'.
create procedure CapNhat_SANPHAM_Ten
(
	@MaSP int,
	@TenMoi nvarchar(100)
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
	else
		begin
			update SANPHAM
			set [TenSP] = @TenMoi
			where [MaSP] = @MaSP

			commit tran
		end

GO