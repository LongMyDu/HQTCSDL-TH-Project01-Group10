-- Lỗi: Unrepeatable Read
-- Transaction 1: Tìm sản phẩm có chữ hữu cơ
use DB_QLDatChuyenHang
GO

Declare @KetQuaTimKiem nvarchar(100)
exec Tim_SANPHAM_Ten @TenSP=N'hữu cơ', @KetQuaTimKiem = null