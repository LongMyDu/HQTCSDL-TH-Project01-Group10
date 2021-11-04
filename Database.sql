/*
GO
ALTER DATABASE DB_QLDatChuyenHang
SET SINGLE_USER WITH ROLLBACK IMMEDIATE
USE master
DROP DATABASE DB_QLDatChuyenHang
*/

CREATE DATABASE DB_QLDatChuyenHang
GO

USE DB_QLDatChuyenHang
GO

CREATE TABLE [TaiKhoan] (
  [TenTaiKhoan] varchar(20),
  [MatKhau] varchar(20),
  [PhanLoai] char(2),
  [TinhTrangKhoa] bit,
  PRIMARY KEY ([TenTaiKhoan])
);

CREATE TABLE [Admin] (
  [MaAdmin] int identity(1,1),
  [HoTen] nvarchar(30),
  [TenTaiKhoan] varchar(20),
  PRIMARY KEY ([MaAdmin]),
  CONSTRAINT [FK_Admin.TenTaiKhoan]
    FOREIGN KEY ([TenTaiKhoan])
      REFERENCES [TaiKhoan]([TenTaiKhoan])
);

CREATE TABLE [DOITAC] (
  [MaDoiTac] int identity(1,1),
  [TenDoiTac] nvarchar(30),
  [NguoiDaiDien] nvarchar(30),
  [ThanhPho] nvarchar(15),
  [Quan] nvarchar(15),
  [SoChiNhanh] smallint,
  [SoDonHangMoiNgay] int,
  [LoaiHang] nvarchar(15),
  [DiaChiKinhDoanh] nvarchar(200),
  [SoDT] varchar(10),
  [Email] varchar(50),
  [TenTaiKhoan] varchar(20),
  PRIMARY KEY ([MaDoiTac]),
  CONSTRAINT [FK_DOITAC.TenTaiKhoan]
    FOREIGN KEY ([TenTaiKhoan])
      REFERENCES [TaiKhoan]([TenTaiKhoan])
);

CREATE TABLE [HOPDONG] (
  [MaHopDong] int identity(1,1),
  [MaSoThue] varchar(10),
  [ThanhToanPhiKichHoat] bit,
  [PhiHoaHong] bigint,
  [ThoiGianHieuLuc] datetime,
  [SoChiNhanh] smallint,
  [MaDoiTac] int,
  [TinhTrangDuyet] bit,
  PRIMARY KEY ([MaHopDong]),
  CONSTRAINT [FK_HOPDONG.MaDoiTac]
    FOREIGN KEY ([MaDoiTac])
      REFERENCES [DOITAC]([MaDoiTac])
);

CREATE TABLE [CHINHANH] (
  [MaChiNhanh] int identity(1,1),
  [DiaChi] nvarchar(200),
  [MaHopDong] int,
  PRIMARY KEY ([MaChiNhanh]),
  CONSTRAINT [FK_CHINHANH.MaHopDong]
    FOREIGN KEY ([MaHopDong])
      REFERENCES [HOPDONG]([MaHopDong])
	
);

CREATE TABLE [TAIXE] (
  [MaTaiXe] int identity(1,1),
  [HoTen] nvarchar(30),
  [CMND] varchar(12),
  [SoDT] nvarchar(10),
  [DiaChi] nvarchar(200),
  [BienSoXe] varchar(12),
  [KhuVucHoatDong] nvarchar(20),
  [Email] nvarchar(50),
  [TaiKhoanNganHang] varchar(20),
  [TenTaiKhoan] varchar(20),
  PRIMARY KEY ([MaTaiXe]),
  CONSTRAINT [FK_TAIXE.TenTaiKhoan]
    FOREIGN KEY ([TenTaiKhoan])
      REFERENCES [TaiKhoan]([TenTaiKhoan])
);

CREATE TABLE [KHACHHANG] (
  [MaKH] int identity(1,1),
  [HoTen] nvarchar(30),
  [SoDT] varchar(10),
  [DiaChi] nvarchar(200),
  [Email] varchar(50),
  [TenTaiKhoan] varchar(20),
  PRIMARY KEY ([MaKH]),
  CONSTRAINT [FK_KHACHHANG.TenTaiKhoan]
    FOREIGN KEY ([TenTaiKhoan])
      REFERENCES [TaiKhoan]([TenTaiKhoan])
);

CREATE TABLE [DONHANG] (
  [MaDonHang] int identity(1,1),
  [HinhThucThanhToan] nvarchar(20),
  [DiaChiGiaoHang] nvarchar(50),
  [PhiSP] bigint,
  [PhiVC] int,
  [MaKH] int,
  [MaChiNhanh] int,
  [MaTaiXe] int,
  [TinhTrangVanChuyen] nvarchar(50),
  PRIMARY KEY ([MaDonHang]),
  CONSTRAINT [FK_DONHANG.MaChiNhanh]
    FOREIGN KEY ([MaChiNhanh])
      REFERENCES [CHINHANH]([MaChiNhanh]),
  CONSTRAINT [FK_DONHANG.MaTaiXe]
    FOREIGN KEY ([MaTaiXe])
      REFERENCES [TAIXE]([MaTaiXe]),
  CONSTRAINT [FK_DONHANG.MaKH]
    FOREIGN KEY ([MaKH])
      REFERENCES [KHACHHANG]([MaKH])
);

CREATE TABLE [SANPHAM] (
  [MaSP] int identity(1,1),
  [TenSP] nvarchar(100),
  [Gia] bigint,
  [MaChiNhanh] int,
  PRIMARY KEY ([MaSP]),
  CONSTRAINT [FK_SANPHAM.MaChiNhanh]
    FOREIGN KEY ([MaChiNhanh])
      REFERENCES [CHINHANH]([MaChiNhanh])
);

CREATE TABLE [CHITIETDONHANG] (
  [MaSP] int,
  [MaDonHang] int,
  [SoLuong] int,
  [Gia] bigint,
  PRIMARY KEY ([MaSP], [MaDonHang]),
  CONSTRAINT [FK_CHITIETDONHANG.MaSP]
    FOREIGN KEY ([MaSP])
      REFERENCES [SANPHAM]([MaSP]),
  CONSTRAINT [FK_CHITIETDONHANG.MaDonHang]
    FOREIGN KEY ([MaDonHang])
      REFERENCES [DONHANG]([MaDonHang])
);


CREATE TABLE [NhanVien] (
  [MaNhanVien] int,
  [HoTen] nvarchar(30),
  [TenTaiKhoan] varchar(20),
  PRIMARY KEY ([MaNhanVien]),
  CONSTRAINT [FK_NHANVIEN.TenTaiKhoan]
    FOREIGN KEY ([TenTaiKhoan])
      REFERENCES [TaiKhoan]([TenTaiKhoan])
);
GO

ALTER TABLE [TaiKhoan]
ADD CONSTRAINT CK_TaiKhoan_PhanLoai 
CHECK(PhanLoai IN ('DT', 'KH', 'TX', 'NV', 'AD'));
GO

-- Ràng buộc: PhiSP (trong DonHang) = Tổng các Soluong * Gia trong ChiTietDonHang
CREATE TRIGGER CTDH_DONHANG_PHISP ON [CHITIETDONHANG]
FOR INSERT, UPDATE, DELETE
AS
IF UPDATE(SoLuong) OR UPDATE(Gia)
BEGIN
	UPDATE [DONHANG]
	SET PhiSP = (SELECT SUM(CTDH.SoLuong * CTDH.Gia)
				FROM [CHITIETDONHANG] CTDH
				WHERE CTDH.[MaDonHang] = [DONHANG].[MaDonHang])
	WHERE EXISTS (SELECT* FROM INSERTED I WHERE I.[MaDonHang] = [DONHANG].[MaDonHang])
	OR EXISTS (SELECT* FROM DELETED I WHERE I.[MaDonHang] = [DONHANG].[MaDonHang])
END
GO

-- Ràng buộc: Mỗi tài khoản chỉ được thuộc về 1 người dùng
-- Bảng TAH:
--					Thêm	|	Xóa		|	Sửa
--DoiTac			  +		|	 -		|	 + (TenTaiKhoan)
--TaiXe				  +		|	 -		|	 + (TenTaiKhoan)
--KhachHang			  +		|	 -		|	 + (TenTaiKhoan)
--NhanVien			  +		|	 -		|	 + (TenTaiKhoan)
--Admin				  +		|	 -		|	 + (TenTaiKhoan)


-- Ràng buộc: Mỗi tài khoản phải cùng loại với người dùng sử dụng tài khoản đó 
-- Bảng TAH:
--					Thêm	|	Xóa		|	Sửa
--TaiKhoan			  -		|	 -		|	 + (PhanLoai)	
--DoiTac			  +		|	 -		|	 + (TenTaiKhoan)
--TaiXe				  +		|	 -		|	 + (TenTaiKhoan)
--KhachHang			  +		|	 -		|	 + (TenTaiKhoan)
--NhanVien			  +		|	 -		|	 + (TenTaiKhoan)
--Admin				  +		|	 -		|	 + (TenTaiKhoan)


-- Trigger trên bảng TaiKhoan
CREATE TRIGGER TG_TaiKhoan_PhanLoai ON [TAIKHOAN]
FOR UPDATE
AS
IF UPDATE(PhanLoai)
BEGIN
	IF EXISTS (
		SELECT * 
		FROM INSERTED I 
		WHERE I.TenTaiKhoan IN (
			SELECT TenTaiKhoan FROM [KHACHHANG] KH WHERE I.TenTaiKhoan = KH.TenTaiKhoan
			UNION
			SELECT TenTaiKhoan FROM [DOITAC] DT WHERE I.TenTaiKhoan = DT.TenTaiKhoan
			UNION
			SELECT TenTaiKhoan FROM [TAIXE] TX WHERE I.TenTaiKhoan = TX.TenTaiKhoan
			UNION
			SELECT TenTaiKhoan FROM [NHANVIEN] NV WHERE I.TenTaiKhoan = NV.TenTaiKhoan
			UNION
			SELECT TenTaiKhoan FROM [ADMIN] AD WHERE I.TenTaiKhoan = AD.TenTaiKhoan
		)
	)
	BEGIN
		raiserror(N'Lỗi: Tài khoản đã có người sử dụng. Không được phép thay đổi loại tài khoản.', 16, 1)
		rollback
	END
END
GO

-- Trigger trên bảng DOITAC
CREATE TRIGGER TG_DOITAC_TAIKHOAN ON [DOITAC]
FOR INSERT, UPDATE
AS
IF UPDATE(TenTaiKhoan)
BEGIN
	IF EXISTS (
		SELECT * 
		FROM INSERTED I join [TaiKhoan] TK on (I.TenTaiKhoan = TK.TenTaiKhoan)
		WHERE (TK.PhanLoai != 'DT') 
			OR (I.TenTaiKhoan IN (
			SELECT TenTaiKhoan 
			FROM [DOITAC] DT 
			WHERE I.TenTaiKhoan = DT.TenTaiKhoan AND I.MaDoiTac != DT.MaDoiTac
		))
	)
	BEGIN
		raiserror(N'Lỗi: Tài khoản không hợp lệ. Tài khoản đã có người khác sử dụng hoặc không cùng loại với người dùng.', 16, 1)
		rollback
	END
END
GO

-- Trigger trên bảng KHACHHANG
CREATE TRIGGER TG_KHACHHANG_TAIKHOAN ON [KHACHHANG]
FOR INSERT, UPDATE
AS
IF UPDATE(TenTaiKhoan)
BEGIN
	IF EXISTS (
		SELECT * 
		FROM INSERTED I join [TaiKhoan] TK on (I.TenTaiKhoan = TK.TenTaiKhoan)
		WHERE (TK.PhanLoai != 'KH') OR (I.TenTaiKhoan IN (
			SELECT TenTaiKhoan 
			FROM [KHACHHANG] KH 
			WHERE I.TenTaiKhoan = KH.TenTaiKhoan AND I.MaKH != KH.MaKH
		))
	)
	BEGIN
		raiserror(N'Lỗi: Tài khoản không hợp lệ. Tài khoản đã có người khác sử dụng hoặc không cùng loại với người dùng.', 16, 1)
		rollback
	END
END
GO

-- Trigger trên bảng TAIXE
CREATE TRIGGER TG_TAIXE_TAIKHOAN ON [TAIXE]
FOR INSERT, UPDATE
AS
IF UPDATE(TenTaiKhoan)
BEGIN
	IF EXISTS (
		SELECT * 
		FROM INSERTED I join [TaiKhoan] TK on (I.TenTaiKhoan = TK.TenTaiKhoan)
		WHERE (TK.PhanLoai != 'TX') OR (I.TenTaiKhoan IN (
			SELECT TenTaiKhoan 
			FROM [TAIXE] TX 
			WHERE I.TenTaiKhoan = TX.TenTaiKhoan AND I.MaTaiXe != TX.MaTaiXe
		))
	)
	BEGIN
		raiserror(N'Lỗi: Tài khoản không hợp lệ. Tài khoản đã có người khác sử dụng hoặc không cùng loại với người dùng.', 16, 1)
		rollback
	END
END
GO

-- Trigger trên bảng NHANVIEN
CREATE TRIGGER TG_NHANVIEN_TAIKHOAN ON [NHANVIEN]
FOR INSERT, UPDATE
AS
IF UPDATE(TenTaiKhoan)
BEGIN
	IF EXISTS (
		SELECT * 
		FROM INSERTED I join [TaiKhoan] TK on (I.TenTaiKhoan = TK.TenTaiKhoan)
		WHERE (TK.PhanLoai != 'NV') OR (I.TenTaiKhoan IN (
			SELECT TenTaiKhoan 
			FROM [NHANVIEN] NV
			WHERE I.TenTaiKhoan = NV.TenTaiKhoan AND I.MaNhanVien!= NV.MaNhanVien
		))
	)
	BEGIN
		raiserror(N'Lỗi: Tài khoản không hợp lệ. Tài khoản đã có người khác sử dụng hoặc không cùng loại với người dùng.', 16, 1)
		rollback
	END
END
GO

-- Trigger trên bảng ADMIN
CREATE TRIGGER TG_ADMIN_TAIKHOAN ON [ADMIN]
FOR INSERT, UPDATE
AS
IF UPDATE(TenTaiKhoan)
BEGIN
IF EXISTS (
		SELECT * 
		FROM INSERTED I join [TaiKhoan] TK on (I.TenTaiKhoan = TK.TenTaiKhoan)
		WHERE (TK.PhanLoai != 'AD') OR (I.TenTaiKhoan IN (
			SELECT TenTaiKhoan 
			FROM [ADMIN] AD 
			WHERE I.TenTaiKhoan = AD.TenTaiKhoan AND I.MaAdmin != AD.MaAdmin
		))
	)
	BEGIN
		raiserror(N'Lỗi: Tài khoản không hợp lệ. Tài khoản đã có người khác sử dụng hoặc không cùng loại với người dùng.', 16, 1)
		rollback
	END
END
GO

create procedure insert_TAIKHOAN
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

create procedure delete_TAIKHOAN
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

create procedure update_TAIKHOAN_PhanLoai
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

-- ràng buộc: mỗi đơn hàng chỉ được có các sản phẩm thuộc cùng một chi nhánh 
-- bảng TAH:  chi tiết đơn hàng, đơn hàng

--								thêm	|	xóa	|	sửa
-- bảng đơn hàng:				-		|  -	|	+(mã chi nhánh )
-- bảng ct đơn hàng:			+		|	-	|	+(mã đơn hàng, mã sản phẩm)

-- trigger trên bảng chi tiết đơn hàng: 
-- sản phẩm trong chi tiết đơn hàng phải có chi nhánh cùng với chi nhánh trong đơn hàng mà chứa sản phẩm đó 

create trigger TG_CUNGCHINHANH_CTDONHANG on chitietdonhang
for insert,update
as 
begin 
		if exists(	select * 
					from inserted i join SANPHAM sp on i.MaSP = sp.MaSP
					where sp.MaChiNhanh <> (select dh.machinhanh
											from DONHANG dh join inserted i on dh.MaDonHang = i.MaDonHang
											)
					)
		begin 
			raiserror(N'Sản phẩm không cùng chi nhánh với đơn hàng.',16,1)
			rollback 
		end 
end 
go

-- trigger trên bảng đơn hàng(sửa mã chi nhánh) 

create trigger TG_CUNGCHINHANH_DONHANG on donhang 
for update 
as 
begin 
		if exists(	select * 
					from CHITIETDONHANG ct join inserted i  on i.MaDonHang = ct.MaDonHang join SANPHAM sp on ct.MaSP = sp.MaSP
					where i.MaChiNhanh <> sp.MaChiNhanh)
		begin 
			raiserror (N'Sản phẩm trong đơn hàng không cùng chi nhánh với đơn hàng',16,1)
			rollback 
		end 
end
go 

--insert into KHACHHANG values 
--('0', 'Nguyễn Văn A', '0123456777', 'Quận 5 TP Hồ Chí Minh', 'Nguyenvana@gmail.com', 'customer1')

