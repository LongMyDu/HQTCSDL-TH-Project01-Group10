﻿-- Lỗi: Unrepeatable Read
-- Transaction 2: Thay đổi giá của sản phẩm 1 thành 550000.

use DB_QLDatChuyenHang
GO

begin tran
	declare @MaSP int, @GiaMoi bigint
	select @MaSP = 1, @GiaMoi = 550000

	if not exists 
		(
			select*
			from SANPHAM SP
			where SP.MaSP = @MaSP
		)
		begin
			raiserror('Không tìm thấy sản phẩm.', 16, 1)
			rollback tran
		end
		else if @GiaMoi < 0
		begin
			raiserror('Giá sản phẩm không hợp lệ.', 16, 1)
			rollback tran
		end
		begin
			update SANPHAM
			set [Gia] = @GiaMoi
			where [MaSP] = @MaSP

			commit tran
		end