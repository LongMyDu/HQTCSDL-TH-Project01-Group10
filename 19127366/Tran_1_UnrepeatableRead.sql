-- Lỗi: Unrepeatable Read
-- Transaction 1: Tìm sản phẩm có chữ hữu cơ
use DB_QLDatChuyenHang
GO


exec Tim_SANPHAM_Ten @TenSP=N'hữu cơ'