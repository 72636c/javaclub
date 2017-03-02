function changeTheme(theme) {
    var expiry_date = new Date();
    expiry_date.setTime(expiry_date.getTime() + (10*365*24*60*60*1000));
    document.cookie = "theme=" + theme + ";expires=" + expiry_date.toUTCString() + ";path=/";
    location.reload();
}

function previousPage() {
  window.history.back();
}
