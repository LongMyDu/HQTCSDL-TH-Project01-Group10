let global_sanpham_list;
let global_cart_list = Array();


const HtmlElements = {
    donHangList: document.getElementById('donhang-list'),
    chiNhanhInput: document.getElementById("chinhanh-input"),
    locButton: document.getElementById("loc-button"),
    tinhTrangInput: document.getElementById("tinhtrang-input")
};


const sendGetDonHangListRequest = (chinhanh, tinhtrang, callback) => {
    let params = ``;
    params += chinhanh != null ? `chinhanh=${chinhanh}`: ``;
    params += tinhtrang != null ? `&tinhtrang=${tinhtrang}`: ``;

    let request = new XMLHttpRequest();
    request.open('GET', `/api/donhang-list?${params}`);
    console.log(`gửi đi: /api/donhang-list?${params}`);

    request.onload = function() {
        let message_received = JSON.parse(request.response);
        console.log("Danh sách đơn hàng nhận được: ", message_received);
        callback(message_received.totalItems, message_received.donhang_list);
    };
    request.send();
}

const clearDonHangList = () => {
    HtmlElements.donHangList.innerHTML = '';
}

const showDonHang = (donHang, index) => {
    let html = `
    <div class="row my-3 border rounded-pill py-2 ">
        <div id="donhang-id-${index}" class="col-2">
            <span>${donHang.id}</span>
        </div>
        <div class="col-2">
            <span>${donHang.maKH}</span>
        </div>
        <div class="col-3">
            <span>${donHang.tongTien}</span>
        </div>
        <div class="col-3">
            <span>${donHang.tinhTrang}</span>
        </div>
        <div class="col-1">
            <span>${donHang.maCN}</span>
        </div>
    </div>
    `
    HtmlElements.sanPhamList.insertAdjacentHTML('beforeend', html);
}

const showDonHangList = (donhang_list) => {
    let index = 0;
    for (let donhang of donhang_list) {
        showDonHang(donhang, index);
        index += 1;
    }
}

const showData = (totalItems, donhang_list) => {
    clearDonHangList();
    showDonHangList(donhang_list);
}

HtmlElements.locButton.addEventListener("click", function() {
    let chinhanh = HtmlElements.chiNhanhInput.value;
    let tinhtrang = HtmlElements.tinhTrangInput.value;
    sendGetDonHangListRequest(chinhanh, tinhtrang, showData);
});