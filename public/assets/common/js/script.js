function changeTheme(theme) {
    var expiry_date = new Date();
    expiry_date.setFullYear(expiry_date.getFullYear() + 1);
    document.cookie = "theme=" + theme + ";path=/;expires=" + expiry_date.toUTCString();
    document.getElementById("stylesheet-theme").href = "/assets/common/css/" + theme + ".css"
}

function previousPage() {
  window.history.back();
}
