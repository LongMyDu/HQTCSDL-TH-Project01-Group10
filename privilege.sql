-- Tạo tài khoản mẫu để test quyền
--exec sp_addlogin 'ExampleAdmin', '123456', 'DB_QLDatChuyenHang'
--exec sp_addlogin 'LMD', '123456', 'DB_QLDatChuyenHang'

--Create user ExampleAdmin For login ExampleAdmin
--Create user LMD For login LMD 
--exec sp_addrolemember 'Admin','ExampleAdmin'  -- Chỉ có exampleAdmin là thuộc role admin, LMD thì không

-- Phân quyền cho role Admin
exec sp_addrole 'Admin'
GRANT SELECT, INSERT, UPDATE, DELETE ON NhanVien TO Admin WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON [Admin] TO Admin WITH GRANT OPTION
GRANT SELECT, UPDATE ON TaiKhoan TO Admin WITH GRANT OPTION 

-- tạo tài khoản mẫu cho khách hàng 
exec sp_addlogin 'customer1' , '123456','DB_QLDatChuyenHang'
exec sp_addlogin 'customer2', '123456'
exec sp_addlogin 'customer3', '123456'
exec sp_addlogin 'customer4', '123456'
-- tạo user tương ứng cho tài khoản 

create user customer1 for login customer1 
create user customer3 for login customer3
create user customer2 for login customer2
create user customer4 for login customer4

-- tạo role khách hàng 
exec sp_addrole 'Customer' 

-- them user customer1 vao role khach hang 

exec sp_addrolemember 'Customer','customer1'

-- grant select, update customer's information 
grant select on KhachHang to Customer  
grant update on KhachHang(Hoten, sodt, diachi, email) to Customer

-- xem danh sách đối tác chi nhánh, sản phẩm 
grant select on DoiTac(tendoitac, Thanhpho, Quan, LoaiHang,SoDT, DiaChiKinhDoanh) to Customer
grant select on Chinhanh(diachi) to Customer 
grant select on SanPham(MaSp, Tensp, gia, machinhanh) to Customer 

-- xem danh sách đơn hàng của khách hàng đó 
grant select on DonHang to Customer 
-- sua
revoke select on Doitac from Customer 
select * from DOITAC

