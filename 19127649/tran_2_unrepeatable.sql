-- transaction 2: đổi mk tài khoản DT01 
use DB_QLDatChuyenHang
go
exec DoiMatKhau @TK = '_hopeful', @MK = 'tOxd4cLQkFyI', @MKMoi = '123456',@MKMoiLan2  = '123456'

