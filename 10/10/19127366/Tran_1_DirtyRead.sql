-- Lỗi: Dirty Read 01
-- Transaction 1: : Giảm giá 10% cho tất cả sản phẩm được cung cấp bởi chi nhánh 1.

USE DB_QLDatChuyenHang
GO

exec CapNhat_SANPHAM_GiamGiaDongLoat @MaChiNhanh = 1, @PhanTramGiamGia = 10