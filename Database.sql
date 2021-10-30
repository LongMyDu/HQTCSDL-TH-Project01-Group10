--GO
--ALTER DATABASE DB_QLDatChuyenHang
--SET SINGLE_USER WITH ROLLBACK IMMEDIATE
--USE master
--DROP DATABASE DB_QLDatChuyenHang

CREATE DATABASE DB_QLDatChuyenHang
GO

USE DB_QLDatChuyenHang
GO

CREATE TABLE [Admin] (
  [MaAdmin] int,
  [HoTen] nvarchar(30),
  [TenTaiKhoan] varchar(20),
  PRIMARY KEY ([MaAdmin])
);

CREATE TABLE [DOITAC] (
  [MaDoiTac] int,
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
  PRIMARY KEY ([MaDoiTac])
);

CREATE TABLE [HOPDONG] (
  [MaHopDong] int,
  [MaSoThue] varchar(10),
  [ThanhToanPhiKichHoat] bit,
  [PhiHoaHong] int,
  [ThoiGianHieuLuc] datetime,
  [SoChiNhanh] smallint,
  [MaDoiTac] int,
  [TrinhTrangDuyet] bit,
  PRIMARY KEY ([MaHopDong]),
  CONSTRAINT [FK_HOPDONG.MaDoiTac]
    FOREIGN KEY ([MaDoiTac])
      REFERENCES [DOITAC]([MaDoiTac])
);

CREATE TABLE [CHINHANH] (
  [MaChiNhanh] int,
  [DiaChi] nvarchar(200),
  [MaHopDong] int,
  PRIMARY KEY ([MaChiNhanh]),
  CONSTRAINT [FK_CHINHANH.MaHopDong]
    FOREIGN KEY ([MaHopDong])
      REFERENCES [HOPDONG]([MaHopDong])
);

CREATE TABLE [TAIXE] (
  [MaTaiXe] int,
  [HoTen] nvarchar(30),
  [CMND] varchar(12),
  [SoDT] nvarchar(10),
  [DiaChi] nvarchar(200),
  [BienSoXe] varchar(12),
  [KhuVucHoatDong] nvarchar(20),
  [Email] nvarchar(50),
  [TaiKhoanNganHang] varchar(20),
  [TenTaiKhoan] varchar(20),
  PRIMARY KEY ([MaTaiXe])
);

CREATE TABLE [KHACHHANG] (
  [MaKH] int,
  [HoTen] nvarchar(30),
  [SoDT] varchar(10),
  [DiaChi] nvarchar(200),
  [Email] varchar(50),
  [TenTaiKhoan] varchar(20),
  PRIMARY KEY ([MaKH])
);

CREATE TABLE [DONHANG] (
  [MaDonHang] int,
  [HinhThucThanhToan] nvarchar(20),
  [DiaChiGiaoHang] nvarchar(50),
  [PhiSP] int,
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
  [MaSP] int,
  [TenSP] nvarchar(100),
  [Gia] int,
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
  [Gia] int,
  PRIMARY KEY ([MaSP], [MaDonHang]),
  CONSTRAINT [FK_CHITIETDONHANG.MaSP]
    FOREIGN KEY ([MaSP])
      REFERENCES [SANPHAM]([MaSP]),
  CONSTRAINT [FK_CHITIETDONHANG.MaDonHang]
    FOREIGN KEY ([MaDonHang])
      REFERENCES [DONHANG]([MaDonHang])
);

CREATE TABLE [TaiKhoan] (
  [TenTaiKhoan] varchar(20),
  [MatKhau] varchar(20),
  [PhanLoai] char(2),
  [TinhTrangKhoa] bit,
  PRIMARY KEY ([TenTaiKhoan])
);

CREATE TABLE [NhanVien] (
  [MaNhanVien] int,
  [HoTen] nvarchar(30),
  [TenTaiKhoan] varchar(20),
  PRIMARY KEY ([MaNhanVien])
);

ALTER TABLE [TaiKhoan]
ADD CONSTRAINT check_TaiKhoan_PhanLoai 
CHECK(PhanLoai IN ('DT', 'KH', 'TX', 'NV', 'AD'));
