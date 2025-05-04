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


function mostrarToastExitoBusinessUnit() {
    cerrarModal("modalCrearBusinessUnit");

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
    document.getElementById("ddlEstadoTurno").selectedIndex = 0;
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






//MUDA

// Función para mostrar el toast de éxito para MUDA
function mostrarToastExitoMuda() {
    cerrarModal("modalCrearMuda");

    document.getElementById("txtNombreMuda").value = "";
    document.getElementById("ddlEstadoMuda").selectedIndex = 0;
    document.getElementById("hdnIdMuda").value = "";

    const toastEl = document.getElementById("toastSuccess");
    if (toastEl) {
        const toast = new bootstrap.Toast(toastEl);
        toast.show();

        toastEl.addEventListener('shown.bs.toast', () => {
            setTimeout(() => toast.hide(), 5000);
        });
    }
}

// Modal de creación para MUDA
function prepararModalCrearMuda() {
    document.getElementById("txtNombreMuda").value = "";
    document.getElementById("ddlEstadoMuda").value = "1";
    document.getElementById("hdnIdMuda").value = "";
    document.getElementById("btnGuardarMuda").value = "Guardar";
    document.getElementById("modalCrearMudaLabel").innerText = "Agregar Nueva MUDA";
    document.getElementById("btnEliminarContainerMuda").style.display = "none";
}

// Modal de edición para MUDA
function abrirModalEditarMuda(id, name, status) {
    document.getElementById("txtNombreMuda").value = name;
    document.getElementById("ddlEstadoMuda").value = status;
    document.getElementById("hdnIdMuda").value = id;
    document.getElementById("btnGuardarMuda").value = "Actualizar";
    document.getElementById("modalCrearMudaLabel").innerText = "Editar MUDA";
    document.getElementById("btnEliminarContainerMuda").style.display = "block";

    const modal = new bootstrap.Modal(document.getElementById("modalCrearMuda"));
    modal.show();
}


//SCRAP


// Toast para SCRAP
function mostrarToastExitoScrap() {
    cerrarModal("modalCrearScrap");

    document.getElementById("txtNombreScrap").value = "";
    document.getElementById("ddlEstadoScrap").selectedIndex = 0;
    document.getElementById("hdnIdScrap").value = "";

    const toastEl = document.getElementById("toastSuccess");
    if (toastEl) {
        const toast = new bootstrap.Toast(toastEl);
        toast.show();

        toastEl.addEventListener('shown.bs.toast', () => {
            setTimeout(() => toast.hide(), 5000);
        });
    }
}

// Modal creación para SCRAP
function prepararModalCrearScrap() {
    document.getElementById("txtNombreScrap").value = "";
    document.getElementById("ddlEstadoScrap").value = "1";
    document.getElementById("hdnIdScrap").value = "";
    document.getElementById("btnGuardarScrap").value = "Guardar";
    document.getElementById("modalCrearScrapLabel").innerText = "Agregar Scrap";
    document.getElementById("btnEliminarContainerScrap").style.display = "none";
}

// Modal edición para SCRAP
function abrirModalEditarScrap(id, name, status) {
    document.getElementById("txtNombreScrap").value = name;
    document.getElementById("ddlEstadoScrap").value = status;
    document.getElementById("hdnIdScrap").value = id;
    document.getElementById("btnGuardarScrap").value = "Actualizar";
    document.getElementById("modalCrearScrapLabel").innerText = "Editar Scrap";
    document.getElementById("btnEliminarContainerScrap").style.display = "block";

    const modal = new bootstrap.Modal(document.getElementById("modalCrearScrap"));
    modal.show();
}

//OPERACION


// Mostrar toast y cerrar modal
function mostrarToastExitoOperacion() {
    cerrarModal("modalCrearOperacion");

    document.getElementById("txtNombreOperacion").value = "";
    document.getElementById("ddlAreaOperacion").selectedIndex = 0;
    document.getElementById("txtOutputTarget").value = "";
    document.getElementById("txtYieldTarget").value = "";
    document.getElementById("txtPercentOutput").value = "";
    document.getElementById("txtPercentYieldTarget").value = "";
    document.getElementById("txtLeadTime").value = "";
    document.getElementById("txtNumberDays").value = "";
    document.getElementById("contenedorCurvaEntrenamiento").innerHTML = "";
    document.getElementById("ddlEstadoOperacion").selectedIndex = 0;

    const toastEl = document.getElementById("toastSuccess");
    if (toastEl) {
        const toast = new bootstrap.Toast(toastEl);
        toast.show();

        toastEl.addEventListener('shown.bs.toast', () => {
            setTimeout(() => toast.hide(), 5000);
        });
    }
}

// Preparar modal de creación
function prepararModalCrearOperacion() {
    document.getElementById("txtNombreOperacion").value = "";
    document.getElementById("ddlAreaOperacion").selectedIndex = 0;
    document.getElementById("txtOutputTarget").value = "";
    document.getElementById("txtYieldTarget").value = "";
    document.getElementById("txtPercentOutput").value = "";
    document.getElementById("txtPercentYieldTarget").value = "";
    document.getElementById("txtLeadTime").value = "";
    document.getElementById("txtNumberDays").value = "";
    document.getElementById("contenedorCurvaEntrenamiento").innerHTML = "";
    document.getElementById("ddlEstadoOperacion").value = "1";
    document.getElementById("hdnIdOperacion").value = "";
    document.getElementById("btnGuardarOperacion").value = "Guardar";
    document.getElementById("modalCrearOperacionLabel").innerText = "Agregar Operación";
    document.getElementById("btnEliminarContainerOperacion").style.display = "none";
}

// Abrir modal de edición
function abrirModalEditarOperacion(id, name, output, yieldTarget, training, leadTime, days, areaId, status, percentOutput, percentYieldTarget) {
    document.getElementById("hdnIdOperacion").value = id;
    document.getElementById("txtNombreOperacion").value = name;
    document.getElementById("txtOutputTarget").value = output;
    document.getElementById("txtYieldTarget").value = yieldTarget;
    document.getElementById("txtOutputTargetTraining").value = training;
    document.getElementById("txtLeadTime").value = leadTime;
    document.getElementById("txtNumberDays").value = days;
    document.getElementById("ddlAreaOperacion").value = areaId;
    document.getElementById("ddlEstadoOperacion").value = status;

    document.getElementById("txtPercentOutput").value = percentOutput;
    document.getElementById("txtPercentYieldTarget").value = percentYieldTarget;


    cargarCurva(id); // <- aquí se carga la curva en el modal

    document.getElementById("modalCrearOperacionLabel").innerText = "Editar Operación";
    document.getElementById("btnGuardarOperacion").value = "Actualizar";
    document.getElementById("btnEliminarContainerOperacion").style.display = "block";

    const modal = new bootstrap.Modal(document.getElementById("modalCrearOperacion"));
    modal.show();
}



// Generar inputs de curva automáticamente
function generarCurvaAutomatica() {
    const container = document.getElementById("contenedorCurvaEntrenamiento");
    const numberDays = parseInt(document.getElementById("txtNumberDays").value);
    const percentOutput = parseFloat(document.getElementById("txtPercentOutput").value);
    const outputTarget = parseFloat(document.getElementById("txtOutputTarget").value);

    container.innerHTML = "";
    if (!numberDays || numberDays <= 0 || isNaN(percentOutput) || isNaN(outputTarget)) return;

    let currentValue = 0;
    for (let i = 1; i <= numberDays; i++) {
        const percentPerDay = percentOutput / numberDays;
        const value = Math.round((outputTarget * (percentPerDay * i)) / 100);

        const inputGroup = document.createElement("div");
        inputGroup.className = "mb-2";
        inputGroup.innerHTML = `
            <label>Día ${i}:</label>
            <input type="number" class="form-control" name="day_${i}" value="${value}" readonly />
        `;

        container.appendChild(inputGroup);
    }
}

// Validar antes de guardar
function validarOperacionAntesDeGuardar() {
    const nombre = document.getElementById("txtNombreOperacion").value.trim();
    const area = document.getElementById("ddlAreaOperacion").value;
    const dias = document.getElementById("txtNumberDays").value;

    if (nombre === "" || area === "0" || dias === "") {
        alert("⚠ Todos los campos obligatorios deben ser completados.");
        return false;
    }
    return true;
}


function generarCurvaEntrenamiento() {
    const contenedor = document.getElementById("contenedorCurvaEntrenamiento");
    const cantidad = parseInt(document.getElementById("txtNumberDays").value, 10);

    contenedor.innerHTML = ""; // Limpiar lo anterior

    if (isNaN(cantidad) || cantidad <= 0) return;

    for (let i = 1; i <= cantidad; i++) {
        const div = document.createElement("div");
        div.className = "col-md-2 mb-2";

        const label = document.createElement("label");
        label.className = "form-label";
        label.innerText = `Día ${i}:`;

        const input = document.createElement("input");
        input.type = "number";
        input.className = "form-control";
        input.name = `inputDia${i}`;
        input.id = `inputDia${i}`;

        div.appendChild(label);
        div.appendChild(input);
        contenedor.appendChild(div);
    }




}


function generarCamposCurva() {
    const numeroDias = parseInt(document.getElementById("txtNumberDays").value);
    const contenedor = document.getElementById("contenedorCurvaEntrenamiento");

    contenedor.innerHTML = ""; // Limpiar anterior

    if (!isNaN(numeroDias) && numeroDias > 0) {
        for (let i = 1; i <= numeroDias; i++) {
            const col = document.createElement("div");
            col.className = "col-md-3"; // 4 por fila aprox.

            const label = document.createElement("label");
            label.innerText = `Día ${i}:`;
            label.className = "form-label";

            const input = document.createElement("input");
            input.type = "number";
            input.className = "form-control";
            input.name = `inputDia${i}`;
            input.id = `inputDia${i}`;

            col.appendChild(label);
            col.appendChild(input);
            contenedor.appendChild(col);
        }
    }

}



// Cargar curva desde el backend
function cargarCurva(idOperacion) {
    PageMethods.ObtenerCurvaPorOperacion(idOperacion, function (data) {
        const contenedor = document.getElementById("contenedorCurvaEntrenamiento");
        contenedor.innerHTML = "";
        data.forEach(item => {
            const div = document.createElement("div");
            div.classList.add("col-md-6");
            div.innerHTML = `
    <label class="form-label">Día ${item.Dia}:</label>
    <input type="number" class="form-control" name="inputDia${item.Dia}" id="inputDia${item.Dia}" value="${item.Valor}" />
`;

            contenedor.appendChild(div);
        });
    });
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
window.mostrarToastExitoScrap = mostrarToastExitoScrap;
window.prepararModalCrearScrap = prepararModalCrearScrap;
window.abrirModalEditarScrap = abrirModalEditarScrap;

window.prepararModalCrearOperacion = prepararModalCrearOperacion;

window.abrirModalEditarOperacion = abrirModalEditarOperacion;
window.mostrarToastExitoOperacion = mostrarToastExitoOperacion;
window.validarOperacionAntesDeGuardar = validarOperacionAntesDeGuardar;
// Registrar funciones globales para Operación
window.generarCamposCurva = generarCamposCurva;
window.generarCurvaAutomatica = generarCurvaAutomatica;
