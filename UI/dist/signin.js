
const HtmlElements = {
    
    signInForm: document.getElementById("signin-form"),
    taiKhoanInput: document.getElementById("taikhoan-input"),
    matKhauInput: document.getElementById("matkhau-input")
};

HtmlElements.signInForm.addEventListener("submit", (e) => {
    // Prevent reload after submit form 
    e.preventDefault();

    // Get username and password
    let username = HtmlElements.taiKhoanInput.value;
    let password = HtmlElements.matKhauInput.value;
    
    data = `TaiKhoan=${username}&MatKhau=${password}`;

    let request = new XMLHttpRequest();
    request.open('POST', '/signin-post', true);
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
