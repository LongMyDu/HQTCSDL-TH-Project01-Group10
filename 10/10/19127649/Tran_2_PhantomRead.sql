--T2 : đối tác thêm một sản phẩm vào chi nhánh 1 
use DB_QLDatChuyenHang
go
exec Them_1_Sp_VaoChiNhanh @MaSP = 5, @TenSP = N'Bánh oreo ngon giòn 150g', @Gia = 15000, @SoLuongTon = 100, @MaChiNhanh = 1