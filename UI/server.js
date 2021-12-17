const express = require('express');
const app = express();
const bodyParser = require("body-parser");
const sql = require("mssql");
const { request } = require('express');

let newID;

const config = {
   user: 'sa',
   password: 'lmd',
   server: 'localhost', 
   port: 51713,
   database: 'DB_QLDatChuyenHang',
   trustServerCertificate: true,
};


// const config = {
//    user: 'sa',
//    password: 'ttt',
//    server: 'localhost', 
//    port: 8888,
//    database: 'DB_QLDatChuyenHang',
//    trustServerCertificate: true,
// };

// const config = {
//    user: 'sa',
//    password: 'tkt',
//    server: 'localhost', 
//    port: 62437,
//    database: 'DB_QLDatChuyenHang',
//    trustServerCertificate: true,
// };

app.use(express.static('dist'));
//Here we are configuring express to use body-parser as middle-ware.
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.get('/', function (req, res) {
   res.sendFile(__dirname + "/dist/signin.html");
})



// Lấy ngày hiện tại
function getCurrentDate(){
   var dt = new Date();

   var day = ("0" + dt.getDate()).slice(-2);
   var month = ("0" + (dt.getMonth() + 1)).slice(-2);
   var year = dt.getFullYear();
   var hours = ("0" + dt.getHours()).slice(-2);
   var minutes = ("0" + dt.getMinutes()).slice(-2);
   var seconds = ("0" + dt.getSeconds()).slice(-2);

   var dateTime = year + "-" + month + "-" + day + " " + hours + ":" + minutes + ":" + seconds;
   return dateTime;
}

// Tạo mã đơn hàng
function getIDofTable(id_name, table_name) {
   return new Promise((resolve, reject) => {
      // Select the last row in table 
      var sqlQuery = `select top 1 ${id_name} from ${table_name} order by ${id_name} desc`
      const request = new sql.Request();
      request.query(sqlQuery, (err, result) => {
         if(err){
            console.log("Can't get id from table"); 
            return; 
         }
         newID =  (parseInt(Object.values(result.recordset[0]), 10) + 1);
        
         return resolve(true);
      });
    }).catch(err => {      
    });
}

app.post('/insert-order-post', async function (req, res) {
   await getIDofTable("MaDonHang", "DONHANG");
   console.log("[insert-order-post] Mã đơn hàng mới: ", newID);

   // Prepare output in JSON format
   let response = {
      donhang: newID,
      httt :req.body.HTTT,
      diachi: req.body.DiaChi,
      phiVC: req.body.PhiVC,
      khachhang:req.body.KhachHang,
      chinhanh: req.body.MaChiNhanh,
      ngaylap: getCurrentDate(),
      tongtien: req.body.TongTien,
      cart_list: JSON.parse(req.body.cart_list)
   };

   //TODO: Thêm đơn hàng mới vào DB
   console.log("[insert-order-post] Đơn hàng được gửi tới: ", response);

   sqlQuery = `exec Them_DONHANG ${response.donhang}, ${response.httt}, ${response.diachi}, ${response.phiVC}, ${response.khachhang}, ${response.chinhanh}, ${response.ngaylap}`; 

   const request = new sql.Request(); 
   request.query(sqlQuery, (err, result) => {
      if(err){
         res.send("Đơn hàng không hợp lệ"); 
         //res.status(500).send(err);
         return; 
      }

      //TODO: Gửi thông báo lại cho client:
      res.send("Đặt hàng thành công!");
   })
})



app.post('/insert-product-post', async function (req, res) {
   await getIDofTable("MaSP", "SANPHAM");
   console.log("[insert-product-post] Mã sản phẩm mới: ", newID);

   // Prepare output in JSON format
   let response = {
      MaSp : newID,
      tensp :req.body.TenSP,
      slTon: req.body.SlTon,
      chinhanh: req.body.MaChiNhanh,
      giaban: req.body.GiaBan
   };

   // Thêm sản phẩm mới vào DB
   console.log("[insert-product-post] Sản phẩm được gửi tới: ", response);
   
   
   sqlQuery = `exec Them_1_Sp_VaoChiNhanh ${response.MaSp}, N'${response.tensp}', ${response.giaban}, ${response.slTon}, ${response.chinhanh}`; 
   
   if(response.slTon < 1){
      res.send("Số lượng tồn không hợp lệ");
      return;
   }
   else if (response.giaban < 0) { 
      res.send("Giá bán không hợp lệ");
   }
   const request = new sql.Request(); 
   request.query(sqlQuery, (err, result) => {
      if(err){
         res.send("Thêm sản phẩm không thành công\n\n" + err);
         return; 
      }

      //Gửi thông báo lại cho client:
      res.send("Thêm sản phẩm thành công!");
   })
})



app.post('/add-quantity-item-post', async function (req, res) {
   // Prepare output in JSON format
   let response = {
      sanpham: req.body.SanPham,
      soluongthem: req.body.SoLuongThem,
   };

   //Thêm số lượng tồn của sản phẩm
   console.log("[add-quantity-item-post] Số lượng thêm gửi tới: ", response);
   sqlQuery = `exec Them_SanPham_SoLuong ${response.sanpham}, ${response.soluongthem}`;

   const request = new sql.Request();
   request.query(sqlQuery, (err, result) => {
      if(err){
         res.send("Thêm số lượng sản phẩm thất bại");
         return;
      }
      res.send("Thêm số lượng sản phẩm thành công")
   })
})



app.post('/update-price-item-post', async function (req, res) {
   // Prepare output in JSON format
   let response = {
      sanpham: req.body.SanPham,
      giamoi: req.body.GiaMoi,
   };

   // thay đổi giá bán
   console.log("[update-price-item-post] Giá mới gửi tới: ", response);
   sqlQuery = `exec CapNhat_SANPHAM_gia ${response.sanpham}, ${response.giamoi}`;

   const request = new sql.Request();
   request.query(sqlQuery, (err, result) => {
      if(err){
         res.send("Thay đổi giá bán thất bại");
         return;
      }
      res.send("Thay đổi giá bán thành công")
   })
})



app.post('/discount-branch-post', async function (req, res) {
   // Prepare output in JSON format
   let response = {
      chinhanh: req.body.MaChiNhanh,
      giamgia: req.body.PhanTramGiamGia,
   };

   // giảm giá phần trăm tất cả sản phẩm của chi nhánh
   console.log("[discount-branch-post] Giảm giá gửi tới: ", response);
   sqlQuery = `exec CapNhat_SANPHAM_GiamGiaDongLoat ${response.chinhanh}, ${response.giamgia}`;

   const request = new sql.Request();
   request.query(sqlQuery, (err, result) => {
      if(err){
         res.send("Giảm giá chi nhánh thất bại");
         return;
      }
      res.send("Giảm giá chi nhánh thành công")
   })
})


app.post('/signin-post', async function (req, res) {
   // Prepare output in JSON format
   let response = {
      username :req.body.TaiKhoan,
      password: req.body.MatKhau,
   };
    console.log("sign in post here");
   //TODO: Check username và password có hợp lệ hay không

   if(response.username.length > 20 || response.password.length > 20 || response.username === '' || response.password === ''){
      res.send("Tài khoản hoặc mật khẩu không hợp lệ."); 
      return; 
   }
   console.log("[signin-post] Tài khoản và mật khẩu gửi tới: ", response);

   sqlQuery = `exec DangNhap ${response.username}, ${response.password}`; 
   const request = new sql.Request(); 
   request.query(sqlQuery, (err, result) => {
      if(err){
         console.log(err);
         res.status(401).send("Tài khoản hoặc mật khẩu không chính xác"); 
         return; 
      }  
      // Trả về client thông tin mã KH và loại người dùng
      const Info_Account = result.recordset.map(elm => ({ MaNguoiDung: elm.MaNguoiDung, PhanLoai: elm.LoaiTaiKhoan}));
       
      global.Ma_Nguoi_Dung; 

      global.Ma_Nguoi_Dung = Info_Account[0].MaNguoiDung;
   
      console.log("Ma nguoi dung:", global.Ma_Nguoi_Dung);
      // Send to res
      res.json(Info_Account);
   })

})



app.post('/changepass-post', async function (req, res) {
   // Prepare output in JSON format
   let response = {
      username: req.body.TaiKhoan,
      oldpass: req.body.MatKhauCu,
      newpass: req.body.MatKhauMoi
   };
    
   //TODO: Check username và password có hợp lệ hay không, có thì đổi mật khẩu trong DB
   console.log("[changepass-post] Tài khoản và mật khẩu gửi tới: ", response);


   sqlQuery = `exec DoiMatKhau ${response.username},  ${response.oldpass}, ${response.newpass}, ${response.newpass}`
   const request = new sql.Request(); 
   request.query(sqlQuery, (err, result) => {
      if(err){
         res.send("Tài khoản hoặc mật khẩu không chính xác"); 
         //res.status(500).send(err);
         return; 
      }
      
      //TODO: Gửi thông báo lại cho client
      res.send("Change password successfully!");
   })

})


app.get('/api/sanpham-list', function (req, res) {
    var sqlQuery = `exec XemTatCa_SANPHAM_ThuocChiNhanh ${req.query.chinhanh}`

    // TODO: get sanpham_list in DB
    const request = new sql.Request();
    request.query(sqlQuery, (err, result) => {
      if (err)
      {
        res.status(500).send(err);
        return;
      }
      var totalItems = result.recordset.length;
      const total_sanpham_list = result.recordset.map(elm => ({ id: elm.MaSP, tenSP: elm.TenSP, gia: elm.Gia, soLuongTon: elm.SoLuongTon, chiNhanh: elm.MaChiNhanh}));
      
      // Send to res
      res.json({totalItems: totalItems, sanpham_list: total_sanpham_list});
   });
})



app.get('/api/donhang-list', function (req, res) {
   let chinhanh = req.query.chinhanh;
   let tinhtrang = req.query.tinhtrang;
   console.log("[get donhang-list] Chi nhánh: ", chinhanh, "Tình trạng: ", tinhtrang);

   //TODO: sửa lại câu câu truy vấn này
   var sqlQuery = `exec XemTatCa_DONHANG_ThuocChiNhanh ${req.query.chinhanh}, N'${req.query.tinhtrang}'`;
   console.log("sql :", sqlQuery);
   //TODO: get donhang_list in DB
   const request = new sql.Request();
   request.query(sqlQuery, (err, result) => {
     if (err)
     {
       res.status(500).send(err);
       return;
     }
     // Số lượng kết quả trả về
     var totalResult = result.recordset.length; 
     
     //TODO: sửa lại câu này
     const donhang_list = result.recordset.map(elm => ({ id: elm.MaDonHang, MaKH: elm.MaKH, tongTien: elm.PhiSP, tinhTrang: elm.TinhTrangVanChuyen, maCN: elm.MaChiNhanh}));
     
     // Send to res
     res.json({SLdonhang: totalResult, donhang_list: donhang_list});
  });
})


app.post('/searchSP-post', async function (req, res) {
   // Prepare output in JSON format
   let response = {
      tukhoa: req.body.TuKhoa
   };
    
   console.log("[searchSP-post] Từ khóa được gửi tới: ", response);

   sqlQuery = `exec Tim_SANPHAM_Ten N'${response.tukhoa}'`
   const request = new sql.Request(); 
   request.query(sqlQuery, (err, result) => {
      if(err){
         res.status(500).send(err);
         return; 
      }
      console.log(result.recordset);
      var totalItems = result.recordset.length;
      const total_sanpham_list = result.recordset.map(elm => ({ id: elm.MaSP, tenSP: elm.TenSP, gia: elm.Gia, soLuongTon: elm.SoLuongTon, chiNhanh: elm.MaChiNhanh}));
      
      // Send to res
      res.json({totalItems: totalItems, sanpham_list: total_sanpham_list});
   })

})


app.post('/capnhat-sp-ten-post', async function (req, res) {
   // Prepare output in JSON format
   let response = {
      masp: req.body.MaSP,
      tensp: req.body.TenSP
   };
    
   //TODO: Check username và password có hợp lệ hay không, có thì đổi mật khẩu trong DB
   console.log("[capnhat-sp-ten-post] Mã sp và tên sp được gửi tới: ", response);

   sqlQuery = `exec CapNhat_SANPHAM_Ten ${response.masp},  N'${response.tensp}'`
   const request = new sql.Request(); 
   request.query(sqlQuery, (err, result) => {
      if(err){
         res.status(500).send(err);
         return; 
      }
      
      //TODO: Gửi thông báo lại cho client
      res.send("Cập nhật tên sản phẩm thành công!");
   })
})


sql.connect(config, err => {
   if (err) {
      console.log('Failed to open a SQL Database connection.', err.stack);
      process.exit(1);
   }
   var server = app.listen(8080, function () {
      var host = server.address().address;
      var port = server.address().port;
     
      console.log("Example app listening at http://%s:%s", host, port);
   });
});



