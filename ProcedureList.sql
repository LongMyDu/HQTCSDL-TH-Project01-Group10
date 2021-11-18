﻿use DB_QLDatChuyenHang
GO

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
create procedure Them_SANPHAM
(
	@TenSP nvarchar(100),
	@Gia bigint,
	@MaChiNhanh int = NULL
)
as
begin tran
	-- !!!Không cần kiểm tra MaChiNhanh vì đã có Foreign Key Constraint

	if @Gia < 0
	begin
		raiserror('Giá sản phẩm không hợp lệ.', 16, 1)
		rollback tran
	end
	else
	begin
		insert into SANPHAM (TenSP, Gia, MaChiNhanh)
		values (@TenSP, @Gia, @MaChiNhanh)
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
		Declare @TongSoSanPham bigint
		Set @TongSoSanPham = (Select count(*) From SANPHAM Where MaChiNhanh = @MaChiNhanh)
		Print N'Tổng số sản phẩm được cập nhật: ' + CAST(@TongSoSanPham AS VARCHAR(15))

		update SANPHAM 
		set Gia = convert(bigint, Gia * (100 - @PhanTramGiamGia) /100)
		where MaChiNhanh = @MaChiNhanh
		
	end
	
	if @PhanTramGiamGia > 100
	begin
		raiserror('Phần trăm giảm giá không hợp lệ', 16, 1);
		rollback tran
	end
	else
		commit tran
GO


--Procedure xem tất cả sản phẩm của chi nhánh X
create procedure XemTatCa_SANPHAM_ThuocChiNhanh
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
	else 
	begin
		Select *
		From SANPHAM
		Where MaChiNhanh = @MaChiNhanh
		commit tran
	end
GO

--Procedure xem tất cả đơn hàng của chi nhánh X có tình trạng vận chuyển Y
create procedure XemTatCa_DONHANG_ThuocChiNhanh
(
	@MaChiNhanh int,
	@TinhTrang nvarchar(50)
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
		Declare @SoDonHangChoXacNhan int
		Set @SoDonHangChoXacNhan = (
			Select count(*)
			From DONHANG
			Where MaChiNhanh = @MaChiNhanh and TinhTrangVanChuyen = @TinhTrang
		)
		
		Print N'Tổng số đơn hàng trong tình trạng ' + @TinhTrang + ': ' + CAST(@SoDonHangChoXacNhan AS VARCHAR(10))

		Select *
		From DONHANG
		Where MaChiNhanh = @MaChiNhanh and TinhTrangVanChuyen = @TinhTrang
		commit tran
	end
GO

--Procedure thêm đơn hàng mới 
create procedure Them_DONHANG
(
	@HinhThucThanhToan nvarchar(20),
	@DiaChiGiaoHang nvarchar(50),
	@PhiVC int,
	@MaKH int,
	@MaChiNhanh int
)
as
begin tran
	-- !!!Không cần kiểm tra MaKH và MaChiNhanh vì đã có Foreign Key Constraint

	insert into DONHANG (HinhThucThanhToan, DiaChiGiaoHang, PhiVC, MaKH, MaChiNhanh, TinhTrangVanChuyen)
	values (@HinhThucThanhToan, @DiaChiGiaoHang, @PhiVC, @MaKH, @MaChiNhanh, N'Chờ xác nhận')
	commit tran
GO
