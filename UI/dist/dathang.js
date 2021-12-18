let global_sanpham_list;
let global_cart_list = Array();


const HtmlElements = {
    sanPhamList: document.getElementById('sanpham-list'),
    cartList: document.getElementById('cart-list'),
    chiNhanhInput: document.getElementById("chinhanh-input"),
    locButton: document.getElementById("loc-button"),
    totalLabel: document.getElementById("total-label"),
    datHangButton: document.getElementById("dathang-button"),
    datHangForm: document.getElementById("dathang-form"),
    diachiInput: document.getElementById("diachi-input"),
    htttInput: document.getElementById("httt-input"),

    timKiemSPInput: document.getElementById("timkiemsp-input"),
    timKiemSPButton: document.getElementById("timkiemsp-button"),
    timKiemSPForm: document.getElementById("timkiemsp-form"),
};


const sendGetSanPhamListRequest = (chinhanh, callback) => {
    let params = ``;
    params += chinhanh ? `chinhanh=${chinhanh}&`: ``;

    let request = new XMLHttpRequest();
    request.open('GET', `/api/sanpham-list?${params}`);
    
    request.onload = function() {
        let message_received = JSON.parse(request.response);
        console.log("Message received: ", message_received);
        callback(message_received.totalItems, message_received.sanpham_list);
    };
    request.send();
}

const clearSanPhamList = () => {
    HtmlElements.sanPhamList.innerHTML = '';
}

const clearCartList = () => {
    HtmlElements.cartList.innerHTML = '';
}

const showSanPham = (sanPham, index) => {
    let html = `
    <div class="row my-3 border rounded-pill py-2">
        <div id="item-id-${index}" class="col-1">
            <span>${sanPham.id}</span>
        </div>
        <div class="col-5">
            <span id="item-ten-${index}">${sanPham.tenSP}</span>
        </div>
        <div class="col-2">
            <span id="item-gia-${index}">${sanPham.gia}</span>
        </div>
        <div class="col-2">
            <span id="item-slton-${index}">${sanPham.soLuongTon}</span>
        </div>
        <div class="col-1">
            <span id="item-chinhanh-${index}">${sanPham.chiNhanh}</span>
        </div>
        <div class="col-1">
            <button id="insert-button-${index}" class="insert-button" type="button"><i class="fas fa-plus-circle"></i></button>
        </div>
    </div>`;
    HtmlElements.sanPhamList.insertAdjacentHTML('beforeend', html);

    let insert_button = document.getElementById(`insert-button-${index}`);
    insert_button.addEventListener("click", (e) => {
        let current_sanpham = e.currentTarget;
        console.log("Sanpham: ", current_sanpham);
        let last_index = current_sanpham.id.lastIndexOf("-");
        let sanpham_index = parseInt(current_sanpham.id.substring(last_index + 1));
        console.log("Index:", sanpham_index);

        console.log("Đã thêm vào cart: : ", global_sanpham_list[sanpham_index]);

        current_sanpham = global_sanpham_list[sanpham_index];
        current_sanpham.soluong = 1;

        global_cart_list.push(current_sanpham);
        console.log("Cart hiện tại: ", global_cart_list);

        showCartList(global_cart_list);
    });
}

const showSanPhamInCart = (sanPham, index) => {
    let html = `
    <div class="row my-3 border rounded-pill py-2">
        <div class="col-2">
            <span>${sanPham.id}</span>
        </div>
        <div class="col-5">
            <span>${sanPham.tenSP}</span>
        </div>
        <div class="col-2">
            <span>${sanPham.gia}</span>
        </div>
        <div class="col-2">
            <span>${sanPham.chiNhanh}</span>
        </div>
        <div class="col-1">
            <input id="soluong-input-${index}" class="soluong-input" type="number" min="1" max="99" value=${sanPham.soluong}>
        </div>
    </div>
    `
    HtmlElements.cartList.insertAdjacentHTML('beforeend', html);
    let soluong_input = document.getElementById(`soluong-input-${index}`);
    soluong_input.addEventListener("change", (e) => {
        let current_sanpham = e.currentTarget;
        console.log("Sanpham: ", current_sanpham);
        let last_index = current_sanpham.id.lastIndexOf("-");
        let sanpham_index = parseInt(current_sanpham.id.substring(last_index + 1));
        console.log("Index:", sanpham_index);

        global_cart_list[sanpham_index].soluong = parseInt(current_sanpham.value);
        showTotal(global_cart_list);
    });

}


const showSanPhamList = (sanpham_list) => {
    let index = 0;
    for (let sanpham of sanpham_list) {
        showSanPham(sanpham, index);
        index += 1;
    }
}


const showCartList = (cart_list) => {
    clearCartList();
    let index = 0;
    for (let sanpham of cart_list) {
        showSanPhamInCart(sanpham, index);
        index ++;
    }
    showTotal(cart_list);
}

const calculateTotal = (cart_list) => {
    let total = 0;
    for (let sanpham of cart_list) {
        total += parseInt(sanpham.gia * sanpham.soluong);
    }
    return total;
}

const showTotal = (cart_list) => {
    HtmlElements.totalLabel.innerText = calculateTotal(cart_list);
}

const showData = (totalItems, sanpham_list) => {
    global_sanpham_list = sanpham_list;
    clearSanPhamList();
    showSanPhamList(sanpham_list);
}

HtmlElements.locButton.addEventListener("click", function() {
    let chinhanh = HtmlElements.chiNhanhInput.value;
    sendGetSanPhamListRequest(chinhanh, showData);
});


HtmlElements.datHangForm.addEventListener("submit", (e) => {
    // Prevent reload after submit form 
    e.preventDefault();

    // Get customer id and date and all detail-list
    let diachi = HtmlElements.diachiInput.value;
    let httt = HtmlElements.htttInput.value;
    let chinhanh = HtmlElements.chiNhanhInput.value;
    let tongtien = calculateTotal(global_cart_list);
    let phiVC = 20000;
    console.log(diachi, httt, chinhanh);

    // httt :req.body.HTTT,
    //   diachi: req.body.DiaChi,
    //   tongtien: req.body.TongTien,
    //   phiVC: req.body.PhiVC,
    //   chinhanh: req.body.MaChiNhanh,
    //   cart_list: JSON.parse(req.body.cart_list)
    data = `DiaChi=${diachi}&HTTT=${httt}&TongTien=${tongtien}&PhiVC=${phiVC}&MaChiNhanh=${chinhanh}&cart_list=` + JSON.stringify(global_cart_list);

    // console.log(`Insert view: customer_id=${customer_id}&date=${date}&product_detail_list=` + JSON.stringify(product_detail_list));

    let request = new XMLHttpRequest();
    request.open('POST', '/insert-order-post', true);
    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    request.onreadystatechange = function() { 
        // Call a function when the state changes.
        if (this.readyState === XMLHttpRequest.DONE && this.status === 200) {
            // Request finished. Do processing here.
            alert(request.responseText);
        }
    }
    request.send(data);
})


HtmlElements.timKiemSPForm.addEventListener("submit", (e) => {
    e.preventDefault();

    let tukhoa = HtmlElements.timKiemSPInput.value;

    data = `TuKhoa=${tukhoa}`;
    let request = new XMLHttpRequest();
    request.open('POST', '/searchSP-post', true);
    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    request.onreadystatechange = function() { 
        // Call a function when the state changes.
        if (this.readyState === XMLHttpRequest.DONE && this.status === 200) {
            // Request finished. Do processing here.
            let message_received = JSON.parse(request.response);
            console.log("Message received: ", message_received);
            showData(message_received.totalResult, message_received.sanpham_list);
            alert(message_received.kqTimKiem);
        }
    }
    request.send(data);
})

