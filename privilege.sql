USE DB_QLDatChuyenHang
go

/*
ADMIN
*/
exec sp_addrole 'Admin'
GRANT SELECT, INSERT, UPDATE, DELETE ON NhanVien TO Admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON [Admin] TO Admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON TaiKhoan TO Admin WITH GRANT OPTION
USE DB_QLDatChuyenHang
GRANT EXECUTE ON DATABASE::DB_QLDatChuyenHang To Admin 
  
-- Tạo tài khoản login và user cho Admin
exec sp_addlogin 'lg_admin', 'admin123', 'DB_QLDatChuyenHang'
Create user us_admin For login lg_admin
exec sp_addrolemember 'Admin','us_admin'


/*
KHACHHANG 
*/
-- Tạo role khách hàng 
exec sp_addrole 'KhachHang' 

-- Cấp quyền xem và sửa thông tin cho role khách hàng
grant select on KhachHang to KhachHang
grant update on KhachHang(Hoten, sodt, diachi, email) to KhachHang

-- Cấp quyền xem danh sách đối tác chi nhánh, sản phẩm cho khách hàng
grant select on DoiTac(tendoitac, Thanhpho, Quan, LoaiHang,SoDT, DiaChiKinhDoanh) to KhachHang
grant select on Chinhanh(diachi) to KhachHang
grant select on SanPham(MaSp, Tensp, gia, machinhanh) to KhachHang

-- Cấp quyền xem danh sách đơn hàng và chi tiết đơn hàng cho khách hàng  
grant select, insert, delete on DonHang to KhachHang
grant update on Donhang(hinhthucthanhtoan, diachigiaohang,machinhanh) to KhachHang
grant select, insert, delete on Chitietdonhang to KhachHang
grant update on chitietdonhang(Masp, soluong) to KhachHang

-- Tạo tài khoản login và user cho khách hàng
exec sp_addlogin 'lg_khachhang', 'khachhang123', 'DB_QLDatChuyenHang'
Create user us_khachhang For login lg_khachhang
exec sp_addrolemember 'KhachHang','us_khachhang'

/*
TAIXE
*/
-- Tạo role tài xế, cấp quyền xem, sửa thông tin cá nhân và xem, sửa tình trạng đơn hàng
exec sp_addrole 'Taixe'
grant select,update on Taixe to Taixe 
grant select on donhang to taixe
grant update on donhang([tinhtrangvanchuyen]) to taixe
grant select on khachhang to taixe
-- Tạo tài khoản login và user cho tài xế
exec sp_addlogin 'lg_taixe', 'taixe123', 'DB_QLDatChuyenHang'
Create user us_taixe For login lg_taixe
exec sp_addrolemember 'Taixe','us_taixe'

/*
NHANVIEN
*/
-- Phân quyền nhân viên
exec sp_addrole 'Nhanvien' 
grant select on Hopdong to Nhanvien 
grant update on Hopdong([PhiHoaHong],[thoigianhieuluc],[tinhtrangduyet]) to Nhanvien
-- Tạo tài khoản login và user cho nhân viên
exec sp_addlogin 'lg_nhanvien', 'nhanvien123', 'DB_QLDatChuyenHang'
Create user us_nhanvien For login lg_nhanvien
exec sp_addrolemember 'Nhanvien','us_nhanvien'

/*
DOITAC
*/
-- Phân quyền cho role Đối tác
exec sp_addrole 'DoiTac'

-- Xem, cập nhật tình trạng vận chuyển đơn hàng
GRANT SELECT ON [DONHANG] TO [DOITAC] 
GRANT SELECT ON [CHITIETDONHANG] TO [DOITAC]
GRANT UPDATE ON [DONHANG]([TinhTrangVanChuyen]) TO [DOITAC]

-- Xem, thêm hợp đồng
GRANT SELECT, INSERT ON [HOPDONG] TO [DOITAC] 

-- Xem, thêm, xóa, sửa chi nhánh
GRANT SELECT, INSERT, DELETE ON [CHINHANH] TO [DOITAC]
GRANT UPDATE ON [CHINHANH]([DiaChi]) TO [DOITAC]

-- Xem, xóa, sửa sản phẩm
GRANT SELECT, INSERT, UPDATE, DELETE ON [SANPHAM] TO [DOITAC]

-- Xem, sửa thông tin đối tác
GRANT SELECT, UPDATE ON [DOITAC] TO [DOITAC]

-- Tạo tài khoản login và user cho đối tác
exec sp_addlogin 'lg_doitac', 'doitac123', 'DB_QLDatChuyenHang'
Create user us_doitac For login lg_doitac
exec sp_addrolemember 'DoiTac','us_doitac'

grant select, update on [TaiKhoan]([TenTaiKhoan]) to KhachHang, TaiXe, NhanVien, DoiTac
grant update on [TaiKhoan]([MatKhau]) to KhachHang, TaiXe, NhanVien, DoiTac
grant select on [TaiKhoan]([TinhTrangKhoa]) to KhachHang, TaiXe, NhanVien, DoiTac