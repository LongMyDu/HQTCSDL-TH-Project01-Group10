
const HtmlElements = {
    
    changePassForm: document.getElementById("changepass-form"),
    taiKhoanInput: document.getElementById("taikhoan-input"),
    matKhauCuInput: document.getElementById("oldpass-input"),
    matKhauMoiInput: document.getElementById("newpass-input"),
    matKhauMoiLaiInput: document.getElementById("newpass2-input"),
};

HtmlElements.changePassForm.addEventListener("submit", (e) => {
    // Prevent reload after submit form 
    e.preventDefault();

    // Get username and password
    let username = HtmlElements.taiKhoanInput.value;
    let password = HtmlElements.matKhauCuInput.value;
    let newpass = HtmlElements.matKhauMoiInput.value;
    let newpass2 = HtmlElements.matKhauMoiLaiInput.value;

    if(username === '' || password === '' || newpass === '' || newpass2 === ''){
        alert("Nhập thiếu thông tin"); 
        return;
    }

    if (newpass !== newpass2)
    {
        alert("Nhập lại mật khẩu không khớp");
        return;
    }
    
    data = `TaiKhoan=${username}&MatKhauCu=${password}&MatKhauMoi=${newpass}`;

    let request = new XMLHttpRequest();
    request.open('POST', '/changepass-post', true);
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
