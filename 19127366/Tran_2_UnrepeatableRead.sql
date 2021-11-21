-- Lỗi: Unrepeatable Read
-- Transaction 2: Thay đổi giá của sản phẩm 1 thành 550000.

use DB_QLDatChuyenHang
GO


exec CapNhat_SANPHAM_gia @MaSP = 1, @GiaMoi = 550000
