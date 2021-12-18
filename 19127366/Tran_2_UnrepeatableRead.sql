-- Lỗi: Unrepeatable Read
-- Transaction 2: Thay đổi tên của sản phẩm 1 thành Hạt hạnh nhân.

use DB_QLDatChuyenHang
GO


exec CapNhat_SANPHAM_Ten @MaSP = 1, @TenMoi = N'Hạt hạnh nhân hữu cơ'
