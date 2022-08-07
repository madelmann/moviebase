// Cookies
function checkCookies() {
    var text = "";

    if ( navigator.cookieEnabled ) {
        text = "Cookies are enabled.";
    }
    else {
        text = "Cookies are not enabled.";
    }

    document.getElementById("cookies").innerHTML = text;
}

