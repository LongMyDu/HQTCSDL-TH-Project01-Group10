-- Lỗi: Unrepeatable Read
-- Transaction 1: Giảm giá 20% sản phẩm 1 nếu giá sản phẩm này dưới 500.000.
use DB_QLDatChuyenHang
GO


exec CapNhat_SANPHAM_GiamGiaCoDieuKien @MaSP = 1, @MucGiaToiDa = 500000,@PhanTramGiamGia = 20