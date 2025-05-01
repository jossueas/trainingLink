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

// Toast para BussinesUnirr
function mostrarToastExitoBsinessUnit() {
    cerrarModal("modalCrearArea");

    document.getElementById("txtNombreBusinessUnit").value = "";
    document.getElementById("ddlEstadoBusinessUnit").selectedIndex = 0;
    document.getElementById("hdnIdBusinessUnit").value = "";

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





//************************Business Unit*******************************



// Función para abrir el modal de edición de Business Unit
/*
function mostrarModalCrearBusinessUnit() {
    console.log("Modal abrir: prepararModalCrearBusinessUnit()");
    prepararModalCrearBusinessUnit();
    const modal = new bootstrap.Modal(document.getElementById("modalCrearBusinessUnit"));
    modal.show();
}
*/


// Función para eliminar una Business Unit
function eliminarBusinessUnit(id) {
    if (confirm("¿Estás seguro de que deseas eliminar esta unidad de negocio?")) {
        // Llamar al servidor para eliminar el registro
        window.location.href = "area.aspx?delete=" + id;  // Aquí puedes redirigir o hacer un request AJAX para eliminar el registro
    }
}



// Función para cargar las unidades de negocio en el modal (si es necesario)
function cargarUnidadesDeNegocio() {
    const ddlBusinessUnit = document.getElementById("<%= ddlBusinessUnit.ClientID %>");
    fetch('path_to_get_business_units') // Aquí debes poner la ruta correcta a tu endpoint o el código del servidor que envía la lista de unidades de negocio
        .then(response => response.json())
        .then(data => {
            // Limpiar opciones anteriores
            ddlBusinessUnit.innerHTML = '';

            // Agregar opción 'Seleccione' por defecto
            const defaultOption = document.createElement('option');
            defaultOption.value = '0'; // O valor predeterminado
            defaultOption.innerText = 'Seleccione una Unidad de Negocio';
            ddlBusinessUnit.appendChild(defaultOption);

            // Llenar con las unidades de negocio
            data.forEach(item => {
                const option = document.createElement('option');
                option.value = item.IdBusinessUnit;
                option.innerText = item.Name;
                ddlBusinessUnit.appendChild(option);
            });
        })
        .catch(error => console.error('Error cargando las unidades de negocio:', error));
}


// Función para mostrar el toast de éxito
function mostrarToastExitoBusinessUnit() {
    const toastEl = document.getElementById("toastSuccess");
    const toast = new bootstrap.Toast(toastEl);
    toast.show();

    toastEl.addEventListener('shown.bs.toast', () => {
        setTimeout(() => toast.hide(), 5000);
    });
}


function abrirModalEditarBusinessUnit(id, nombre, estado) {
    console.log("Estado recibido:", estado);

    document.getElementById("hdnIdBusinessUnit").value = id;
    document.getElementById("txtNombreBusinessUnit").value = nombre;
    document.getElementById("ddlEstadoBusinessUnit").value = estado;

    const btnGuardar = document.getElementById("btnGuardarBusinessUnit");
    btnGuardar.value = "Actualizar";

    const modal = new bootstrap.Modal(document.getElementById("modalCrearBusinessUnit"));
    modal.show();
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