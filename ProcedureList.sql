use DB_QLDatChuyenHang
go

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
go

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
go

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
go