// test por fallo ala hora de cargar el js
console.log("JS cargado");

// Alternar el sidebar
function toggleSidebar() {
    const sidebar = document.getElementById("sidebar");
    const mainContent = document.getElementById("mainContent");
    sidebar.classList.toggle("collapsed");
    mainContent.classList.toggle("collapsed");
}

// Cerrar el modal
function cerrarModal() {
    const modalElement = document.getElementById("modalCrearRol");
    const modal = bootstrap.Modal.getInstance(modalElement);
    if (modal) {
        modal.hide();
    }
}

// Mostrar el toast
function mostrarToastExito() {
    cerrarModal(); // Cierra el modal

    // Limpiar campos del formulario
    document.getElementById("txtNombreRol").value = "";
    document.getElementById("txtDescripcionRol").value = "";
    document.getElementById("ddlEstadoRol").selectedIndex = 0;

    // Mostrar el toast
    const toastEl = document.getElementById("toastSuccess");
    if (toastEl) {
        const toast = new bootstrap.Toast(toastEl);
        toast.show();

        toastEl.addEventListener('shown.bs.toast', () => {
            setTimeout(() => {
                toast.hide();
            }, 3000);
        });
    }
}


// ? REGISTRA globalmente
window.mostrarToastExito = mostrarToastExito;
