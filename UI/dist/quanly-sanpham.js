

const HtmlElements = {
    sanPhamList: document.getElementById('sanpham-list'),
    cartList: document.getElementById('cart-list'),
    chiNhanhInput: document.getElementById("chinhanh-input"),
    locButton: document.getElementById("loc-button"),

    themSLTonForm: document.getElementById("themSLton-form"),
    giamGiaForm: document.getElementById("giamgia-tatca-form"),
    themSLTon_maSP_Input: document.getElementById("themSLton-masanpham-input"),
    themSLTon_SL_Input: document.getElementById("themSLton-SLton-input"),

    capNhatGiaForm: document.getElementById("capnhatgia-form"),
    capNhatGia_maSP_Input: document.getElementById("capnhatgia-masanpham-input"),
    capNhatGia_giaMoi_Input: document.getElementById("capnhatgia-giamoi-input")
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

const showSanPham = (sanPham, index) => {
    let html = `
    <div class="row my-3 border rounded-pill py-2">
        <div id="item-id-${index}" class="col-1">
            <span>${sanPham.id}</span>
        </div>
        <div class="col-6">
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
    </div>`;
    HtmlElements.sanPhamList.insertAdjacentHTML('beforeend', html);
}

const showSanPhamList = (sanpham_list) => {
    let index = 0;
    for (let sanpham of sanpham_list) {
        showSanPham(sanpham, index);
        index += 1;
    }
}

const showData = (totalItems, sanpham_list) => {
    clearSanPhamList();
    showSanPhamList(sanpham_list);
}

HtmlElements.locButton.addEventListener("click", function() {
    let chinhanh = HtmlElements.chiNhanhInput.value;
    sendGetSanPhamListRequest(chinhanh, showData);
});


HtmlElements.themSLTonForm.addEventListener("submit", (e) => {
    e.preventDefault();

    // Get mã sản phảm và số lượng tồn tăng thêm
    let masp = HtmlElements.themSLTon_maSP_Input.value;
    let slThem = HtmlElements.themSLTon_SL_Input.value;
  
    console.log(masp, slThem);

    data = `MaSP=${masp}&SLThem=${slThem}`;

    let request = new XMLHttpRequest();
    request.open('POST', '/themSLTon-post', true);
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


HtmlElements.capNhatGiaForm.addEventListener("submit", (e) => {
    e.preventDefault();

    // Get mã sản phảm và giá bán mới 
    let masp = HtmlElements.capNhatGia_maSP_Input.value;
    let giamoi = HtmlElements.capNhatGia_giaMoi_Input.value;
  
    console.log(masp, giamoi);

    data = `MaSP=${masp}&GiaMoi=${giamoi}`;

    let request = new XMLHttpRequest();
    request.open('POST', '/capnhatgia-post', true);
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