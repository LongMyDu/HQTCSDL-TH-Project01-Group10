USE DB_QLDatChuyenHang
go

/*
ADMIN
*/
exec sp_addrole 'Admin'
GRANT SELECT, INSERT, UPDATE, DELETE ON NhanVien TO Admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON [Admin] TO Admin WITH GRANT OPTION
GRANT SELECT, UPDATE ON TaiKhoan TO Admin WITH GRANT OPTION 


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

-- Cấp quyền xem danh sách đơn hàng cho khách hàng  
grant select on DonHang to Customer 


/*
TAIXE
*/
-- Tạo role tài xế, cấp quyền xem, sửa thông tin cá nhân và xem, sửa tình trạng đơn hàng
exec sp_addrole 'Taixe'
grant select,update on Taixe to Taixe 
grant select on donhang to taixe
grant update on donhang([tinhtrangvanchuyen]) to taixe


/*
NHANVIEN
*/
-- Phân quyền nhân viên
exec sp_addrole 'Nhanvien' 
grant select on Hopdong to Nhanvien 
grant update on Hopdong([PhiHoaHong],[thoigianhieuluc],[trinhtrangduyet]) to Nhanvien


/*
DOITAC
*/
-- Phân quyền cho role Đối tác
exec sp_addrole 'DoiTac'
GRANT SELECT ON [DONHANG] TO [DOITAC] WITH GRANT OPTION
GRANT UPDATE ON [DONHANG]([TinhTrangVanChuyen]) TO [DOITAC] WITH GRANT OPTION
GRANT SELECT, INSERT ON [HOPDONG] TO [DOITAC] WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON [SANPHAM] TO [DOITAC] WITH GRANT OPTION
