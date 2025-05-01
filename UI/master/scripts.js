// test por fallo ala hora de cargar el js
console.log("JS cargado");

// Alternar el sidebar
function toggleSidebar() {
    const sidebar = document.getElementById("sidebar");
    const mainContent = document.getElementById("mainContent");
    sidebar.classList.toggle("collapsed");
    mainContent.classList.toggle("collapsed");
}

// Cerrar el modal por ID

/*
function cerrarModal(modalId = "modalCrearRol") {
    const modalElement = document.getElementById(modalId);
    const modal = bootstrap.Modal.getInstance(modalElement);
    if (modal) {
        modal.hide();
    }
}
*/
// Función para cerrar cualquier modal pasando el ID del modal
function cerrarModal(modalId) {
    const modalElement = document.getElementById(modalId);
    const modal = bootstrap.Modal.getInstance(modalElement);
    if (modal) {
        modal.hide();
    }
}








// Toast para ROL
function mostrarToastExito() {
    cerrarModal("modalCrearRol");

    document.getElementById("txtNombreRol").value = "";
    document.getElementById("txtDescripcionRol").value = "";
    document.getElementById("ddlEstadoRol").selectedIndex = 0;

    const toastEl = document.getElementById("toastSuccess");
    if (toastEl) {
        const toast = new bootstrap.Toast(toastEl);
        toast.show();

        toastEl.addEventListener('shown.bs.toast', () => {
            setTimeout(() => toast.hide(), 5000);
        });
    }
}

// Toast para ÁREA
function mostrarToastExitoArea() {
    cerrarModal("modalCrearArea");

    document.getElementById("txtNombreArea").value = "";
    document.getElementById("txtDescripcionArea").value = "";
    document.getElementById("ddlBusinessUnit").selectedIndex = 0;
    document.getElementById("ddlEstadoArea").selectedIndex = 0;

    const toastEl = document.getElementById("toastSuccess");
    if (toastEl) {
        const toast = new bootstrap.Toast(toastEl);
        toast.show();

        toastEl.addEventListener('shown.bs.toast', () => {
            setTimeout(() => toast.hide(), 5000);
        });
    }
}


// Cerrar el modal por ID

/*
function cerrarModal(modalId = "modalCrearRol") {
    const modalElement = document.getElementById(modalId);
    const modal = bootstrap.Modal.getInstance(modalElement);
    if (modal) {
        modal.hide();
    }
}
*/
// Función para cerrar cualquier modal pasando el ID del modal
function cerrarModal(modalId) {
    const modalElement = document.getElementById(modalId);
    const modal = bootstrap.Modal.getInstance(modalElement);
    if (modal) {
        modal.hide();
    }
}

// Modal de edición para ROL
function abrirModalEditar(id, nombre, descripcion, estado) {
    console.log("Estado recibido:", estado);

    document.getElementById("hdnIdRol").value = id;
    document.getElementById("txtNombreRol").value = nombre;
    document.getElementById("txtDescripcionRol").value = descripcion;
    document.getElementById("ddlEstadoRol").value = estado;

    const btnGuardar = document.getElementById("btnGuardarRol");
    btnGuardar.value = "Actualizar";

    const modal = new bootstrap.Modal(document.getElementById("modalCrearRol"));
    modal.show();
}

// Modal de creación para ÁREA
function prepararModalCrearArea() {
    // Restablecer los valores del formulario
    document.getElementById("<%= txtNombreArea.ClientID %>").value = "";
    document.getElementById("<%= txtDescripcionArea.ClientID %>").value = "";
    document.getElementById("<%= ddlEstadoArea.ClientID %>").value = "1"; // Estado activo
    document.getElementById("<%= hdnIdArea.ClientID %>").value = "";
    document.getElementById("<%= btnGuardarArea.ClientID %>").value = "Guardar";
    document.getElementById("modalCrearAreaLabel").innerText = "Agregar Nueva Área";
    document.getElementById("btnEliminarContainer").style.display = "none";

    // si ocupo que se llene el DropDownList en el modal de manera asincrónica,
    // puedo llamar a la función del servidor para recargar las unidades de negocio.
    // CargarUnidadesNegocio(); // Puedes habilitar esta función si es necesario cargar de nuevo
}



// Modal de edición para ÁREA
function abrirModalEditarArea(id, name, description, businessUnitId, status) {
    document.getElementById("txtNombreArea").value = name;
    document.getElementById("txtDescripcionArea").value = description;
    document.getElementById("ddlBusinessUnit").value = businessUnitId;
    document.getElementById("ddlEstadoArea").value = status;
    document.getElementById("hdnIdArea").value = id;
    document.getElementById("btnGuardarArea").value = "Actualizar";
    document.getElementById("modalCrearAreaLabel").innerText = "Editar Área";
    document.getElementById("btnEliminarContainer").style.display = "block";

    const modal = new bootstrap.Modal(document.getElementById("modalCrearArea"));
    modal.show();
}

// Validación antes de guardar área
function validarUnidadNegocioAntesDeGuardar(idDropDown) {
    const ddl = document.getElementById(idDropDown);
    if (ddl && (ddl.value === "" || ddl.value === "0")) {
        alert("⚠ Por favor seleccione una Unidad de Negocio válida antes de guardar el Área.");
        return false;
    }
    return true;
}







//Turno


// Toast para TURNO


function validarAreaAntesDeGuardar(idDropDown) {
    const ddl = document.getElementById(idDropDown);
    if (ddl && (ddl.value === "" || ddl.value === "0")) {
        alert("⚠ Por favor seleccione un área válida antes de guardar el turno.");
        return false;
    }
    return true;
}

function mostrarToastExitoTurno() {
    cerrarModal("modalCrearTurno");

    document.getElementById("txtNombreTurno").value = "";
    document.getElementById("ddlEstadoTurno").value = "1";
    document.getElementById("ddlArea").selectedIndex = 0;
    document.getElementById("hdnIdTurno").value = "";

    const toastEl = document.getElementById("toastSuccess");
    if (toastEl) {
        const toast = new bootstrap.Toast(toastEl);
        toast.show();

        toastEl.addEventListener('shown.bs.toast', () => {
            setTimeout(() => toast.hide(), 5000);
        });
    }
}

















// Registrar funciones en scope global
window.toggleSidebar = toggleSidebar;
window.cerrarModal = cerrarModal;
window.mostrarToastExito = mostrarToastExito;
window.mostrarToastExitoArea = mostrarToastExitoArea;
window.prepararModalCrearArea = prepararModalCrearArea;
window.abrirModalEditar = abrirModalEditar;
window.abrirModalEditarArea = abrirModalEditarArea;
window.validarUnidadNegocioAntesDeGuardar = validarUnidadNegocioAntesDeGuardar;
window.mostrarToastExitoTurno = mostrarToastExitoTurno;
window.validarAreaAntesDeGuardar = validarAreaAntesDeGuardar;

