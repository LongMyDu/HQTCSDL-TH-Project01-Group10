USE DB_QLDatChuyenHang
go

/*
ADMIN
*/
exec sp_addrole 'Admin'
GRANT SELECT, INSERT, UPDATE, DELETE ON NhanVien TO Admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON [Admin] TO Admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON TaiKhoan TO Admin WITH GRANT OPTION 
-- Tạo tài khoản login và user cho Admin
exec sp_addlogin 'lg_admin', 'admin123'
Create user us_admin For login lg_admin
exec sp_addrolemember 'Admin','us_admin'


/*
KHACHHANG 
*/
-- Tạo role khách hàng 
exec sp_addrole 'Customer' 

-- Cấp quyền xem và sửa thông tin cho role khách hàng
grant select on KhachHang to Customer  
grant update on KhachHang(Hoten, sodt, diachi, email) to Customer

-- Cấp quyền xem danh sách đối tác chi nhánh, sản phẩm cho khách hàng
grant select on DoiTac(tendoitac, Thanhpho, Quan, LoaiHang,SoDT, DiaChiKinhDoanh) to Customer
grant select on Chinhanh(diachi) to Customer 
grant select on SanPham(MaSp, Tensp, gia, machinhanh) to Customer 

-- Cấp quyền xem danh sách đơn hàng và chi tiết đơn hàng cho khách hàng  
grant select on DonHang to Customer
grant update on Donhang(hinhthucthanhtoan, diachigiaohang,machinhanh) to Customer 
grant select on Chitietdonhang to Customer
grant update on chitietdonhang(Masp, soluong) to Customer

-- Tạo tài khoản login và user cho khách hàng
exec sp_addlogin 'lg_khachhang', 'khachhang123'
Create user us_khachhang For login lg_khachhang
exec sp_addrolemember 'Customer','us_khachhang'

/*
TAIXE
*/
-- Tạo role tài xế, cấp quyền xem, sửa thông tin cá nhân và xem, sửa tình trạng đơn hàng
exec sp_addrole 'Taixe'
grant select,update on Taixe to Taixe 
grant select on donhang to taixe
grant update on donhang([tinhtrangvanchuyen]) to taixe
-- Tạo tài khoản login và user cho tài xế
exec sp_addlogin 'lg_taixe', 'taixe123'
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
exec sp_addlogin 'lg_nhanvien', 'nhanvien123'
Create user us_nhanvien For login lg_nhanvien
exec sp_addrolemember 'Nhanvien','us_nhanvien'

/*
DOITAC
*/
-- Phân quyền cho role Đối tác
exec sp_addrole 'DoiTac'
GRANT SELECT ON [DONHANG] TO [DOITAC] 
GRANT UPDATE ON [DONHANG]([TinhTrangVanChuyen]) TO [DOITAC]
GRANT SELECT, INSERT ON [HOPDONG] TO [DOITAC] 
GRANT SELECT, INSERT, UPDATE, DELETE ON [SANPHAM] TO [DOITAC]
-- Tạo tài khoản login và user cho đối tác
exec sp_addlogin 'lg_doitac', 'doitac123'
Create user us_doitac For login lg_doitac
exec sp_addrolemember 'DoiTac','us_doitac'