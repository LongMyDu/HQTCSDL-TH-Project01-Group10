-- Tạo tài khoản mẫu để test quyền
--exec sp_addlogin 'ExampleAdmin', '123456', 'DB_QLDatChuyenHang'
--exec sp_addlogin 'LMD', '123456', 'DB_QLDatChuyenHang'

--Create user ExampleAdmin For login ExampleAdmin
--Create user LMD For login LMD 
--exec sp_addrolemember 'Admin','ExampleAdmin'  -- Chỉ có exampleAdmin là thuộc role admin, LMD thì không

use DB_QLDatChuyenHang
go

-- Phân quyền cho role Admin
exec sp_addrole 'Admin'
GRANT SELECT, INSERT, UPDATE, DELETE ON NhanVien TO Admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON [Admin] TO Admin WITH GRANT OPTION
GRANT SELECT, UPDATE ON TaiKhoan TO Admin WITH GRANT OPTION 

-- Phân quyền cho role Đối tác
exec sp_addrole 'DoiTac'
GRANT SELECT ON [DONHANG] TO [DOITAC] WITH GRANT OPTION
GRANT UPDATE ON [DONHANG]([TinhTrangVanChuyen]) TO [DOITAC] WITH GRANT OPTION
GRANT SELECT, INSERT ON [HOPDONG] TO [DOITAC] WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON [SANPHAM] TO [DOITAC] WITH GRANT OPTION