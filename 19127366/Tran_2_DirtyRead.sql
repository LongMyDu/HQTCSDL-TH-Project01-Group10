-- Lỗi: Dirty Read 01
-- Transaction 2: : Đọc thông tin các sản phẩm được cung cấp bởi chi nhánh 1.

USE DB_QLDatChuyenHang
GO

exec XemTatCa_SANPHAM_ThuocChiNhanh	@MaChiNhanh = 1
	
