﻿function abrirModalEditarUsuario(id, code1, nombre, idRol, status, rolNombre) {
    console.log("EDITANDO USUARIO →", {
        id, code1, nombre, idRol, status, rolNombre
    });

    // Debug visual de las opciones
    console.log("ddlRol values:", [...document.getElementById("ddlRol").options].map(opt => ({ value: opt.value, text: opt.text })));
    console.log("ddlEstadoUsuario values:", [...document.getElementById("ddlEstadoUsuario").options].map(opt => opt.value));

    // Asignar valores al modal
    document.getElementById("hdnIdUsuario").value = id;
    document.getElementById("txtNombreUsuario").value = nombre;

    $('#ddlCode1').val(code1).trigger('change');
    document.getElementById("ddlRol").value = idRol.toString();
    document.getElementById("ddlEstadoUsuario").value = status.toString();

    document.getElementById("modalUsuarioLabel").innerText = "Editar Usuario";

    const modal = new bootstrap.Modal(document.getElementById("modalUsuario"));
    modal.show();
}
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

function mostrarToastEliminadoBusinessUnit() {
    const toastEl = document.getElementById("toastSuccess");
    if (toastEl) {
        const toastBody = toastEl.querySelector(".toast-body");
        toastBody.textContent = "🗑️ Business Unit eliminada correctamente.";

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
    cerrarModal("modalEditarTurno");

    // Limpiar campos del formulario
    document.getElementById("txtNombreTurno").value = "";
    document.getElementById("ddlArea").selectedIndex = 0;
    document.getElementById("ddlEstadoTurno").selectedIndex = 0;
    document.getElementById("txtHoraInicio").value = "";
    document.getElementById("txtHoraFin").value = "";
    document.getElementById("txtHorasLaboradas").value = "";
    document.getElementById("ddlUnidadNegocio").selectedIndex = 0;
    document.getElementById("hdnIdTurno").value = "";

    // Mostrar el toast
    const toastEl = document.getElementById("toastSuccess");
    if (toastEl) {
        const toast = new bootstrap.Toast(toastEl);
        toast.show();

        // Ocultar después de 5 segundos
        toastEl.addEventListener('shown.bs.toast', () => {
            setTimeout(() => toast.hide(), 5000);
        });
    }
}



function mostrarToastExitoAcceso() {
    cerrarModal("modalPermiso");

    // Limpiar campos del modal
    document.getElementById("ddlCode1").selectedIndex = 0;
    document.getElementById("ddlMenuKey").selectedIndex = 0;
    document.getElementById("chkPuedeVer").checked = false;
    document.getElementById("hdnIdPermiso").value = "";

    // Mostrar toast de éxito
    const toastEl = document.getElementById("toastSuccess");
    if (toastEl) {
        const toast = new bootstrap.Toast(toastEl);
        toast.show();

        toastEl.addEventListener('shown.bs.toast', () => {
            setTimeout(() => toast.hide(), 5000);
        }, { once: true }); // evita múltiples registros del evento
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
function abrirModalEditarOperacion(id, name, output, yieldTarget, training, leadTime, days, areaId, status, percentOutput, percentYieldTarget, idBusinessUnit) {
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
    document.getElementById("ddlUnidadNegocio").value = idBusinessUnit;



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

    // Paso 1: Guardar valores existentes
    const valoresExistentes = {};
    const inputsActuales = contenedor.querySelectorAll("input[type='number']");
    inputsActuales.forEach(input => {
        const id = input.id; // ejemplo: inputDia3
        valoresExistentes[id] = input.value;
    });

    // Paso 2: Limpiar el contenedor
    contenedor.innerHTML = "";

    // Paso 3: Crear nuevos inputs reutilizando valores existentes
    if (!isNaN(numeroDias) && numeroDias > 0) {
        for (let i = 1; i <= numeroDias; i++) {
            const col = document.createElement("div");
            col.className = "col-md-3"; // aprox 4 columnas por fila

            const label = document.createElement("label");
            label.innerText = `Día ${i}:`;
            label.className = "form-label";

            const input = document.createElement("input");
            input.type = "number";
            input.className = "form-control";
            input.name = `inputDia${i}`;
            input.id = `inputDia${i}`;

            // Recuperar valor si ya existía
            const valorGuardado = valoresExistentes[`inputDia${i}`];
            if (valorGuardado !== undefined) {
                input.value = valorGuardado;
            }

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
/************************* */
///Muda
let contadorMudas = 0;
let listaMudas = [];

function cargarMudas(callback) {
    if (listaMudas.length > 0) {
        callback();
        return;
    }

    PageMethods.ObtenerMudasDesdeSP(
        function (data) {
            listaMudas = data;
            callback();
        },
        function (error) {
            console.error("Error al cargar mudas:", error);
        }
    );
}
/*
function agregarMuda(idSeleccionado = "", textoTipo = "Tiempo en minutos") {
    cargarMudas(function () {
        contadorMudas++;

        const div = document.createElement("div");
        div.className = "row align-items-center mb-2";
        div.id = `mudaRow${contadorMudas}`;

        let optionsMuda = '<option value="">Seleccione Muda</option>';
        listaMudas.forEach(m => {
            const selected = m.Id == idSeleccionado ? "selected" : "";
            optionsMuda += `<option value="${m.Id}" ${selected}>${m.Nombre}</option>`;
        });

        div.innerHTML = `
            <div class="col-md-5">
                <select name="ddlMuda_${contadorMudas}" class="form-select">
                    ${optionsMuda}
                </select>
            </div>
           <div class="col-md-5">
    <input type="text" name="ddlTipoMuda_${contadorMudas}" class="form-control" placeholder="${textoTipo}" />
</div>

            <div class="col-md-2">
                <button type="button" class="btn btn-danger" onclick="eliminarMuda('mudaRow${contadorMudas}')">
                    <i class="bi bi-x"></i>
                </button>
            </div>
        `;

        document.getElementById("contenedorMudas").appendChild(div);
    });
}


}*/

function agregarMuda(idSeleccionado = "", textoTipo = "Tiempo en minutos", idMudaSeguimiento = "") {
    cargarMudas(function () {
        contadorMudas++;

        const div = document.createElement("div");
        div.className = "row align-items-center mb-2";
        div.id = `mudaRow${contadorMudas}`;

        let optionsMuda = '<option value="">Seleccione Muda</option>';
        listaMudas.forEach(m => {
            const selected = m.Id == idSeleccionado ? "selected" : "";
            optionsMuda += `<option value="${m.Id}" ${selected}>${m.Nombre}</option>`;
        });

        div.innerHTML = `
            <div class="col-md-5">
                <select name="ddlMuda_${contadorMudas}" class="form-select">
                    ${optionsMuda}
                </select>
            </div>
            <div class="col-md-5">
                <input type="text" name="ddlTipoMuda_${contadorMudas}" class="form-control" placeholder="${textoTipo}" value="${textoTipo}" />
                <input type="hidden" name="ddlMudaSeguimiento_${contadorMudas}" value="${idMudaSeguimiento}" />
            </div>
            <div class="col-md-2">
                <button type="button" class="btn btn-danger" onclick="eliminarMuda(this, ${idMudaSeguimiento || 0})">
                    <i class="bi bi-x"></i>
                </button>
            </div>
        `;

        document.getElementById("contenedorMudas").appendChild(div);
    });
}



//Muda eliminar


function eliminarMuda(btn, idMudaSeguimiento) {
    const row = btn.closest(".row");

    if (idMudaSeguimiento && idMudaSeguimiento !== 0) {
        if (!confirm("¿Está seguro que desea eliminar esta muda registrada?")) return;

        $.ajax({
            type: "POST",
            url: "registroEntrenamiento.aspx/EliminarMudaSeguimiento",
            data: JSON.stringify({ idMudaSeguimiento: idMudaSeguimiento }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d) {
                    row.remove();
                } else {
                    alert("No se pudo eliminar la muda.");
                }
            },
            error: function () {
                alert("Error al intentar eliminar la muda.");
            }
        });
    } else {
        row.remove(); // Solo eliminar de la vista si no está en DB
    }
}



$(document).on("click", ".btnEliminarMuda", function () {
    const btn = $(this);
    const idMudaSeguimiento = btn.data("idmudaseguimiento");

    if (idMudaSeguimiento) {
        if (!confirm("¿Deseas eliminar esta muda definitivamente?")) return;

        $.ajax({
            type: "POST",
            url: "registroEntrenamiento.aspx/EliminarMudaSeguimiento",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({ idMudaSeguimiento }),
            dataType: "json",
            success: function (response) {
                if (response.d) {
                    btn.closest(".row").remove();
                } else {
                    alert("No se pudo eliminar la muda.");
                }
            },
            error: function () {
                alert("Error al eliminar la muda.");
            }
        });
    } else {
        // Si no tiene ID, solo se eliminó del frontend
        btn.closest(".row").remove();
    }
});




















function validarOperacionAntesDeGuardar() {
    const campos = [
        { id: "txtNombreOperacion", label: "Nombre" },
        { id: "ddlAreaOperacion", label: "Área", tipo: "select" },
        { id: "txtOutputTarget", label: "Output Target" },
        { id: "txtYieldTarget", label: "Yield Target" },
        { id: "txtOutputTargetTraining", label: "Output Target Training" },
        { id: "txtPercentOutput", label: "% Output" },
        { id: "txtPercentYieldTarget", label: "% Yield Target" },
        { id: "txtLeadTime", label: "Lead Time" },
        { id: "txtNumberDays", label: "Número de Días" }
    ];

    let esValido = true;

    campos.forEach(campo => {
        const input = document.getElementById(campo.id);
        const valor = input.value.trim();

        if ((campo.tipo === "select" && (valor === "" || valor === "0")) || (!campo.tipo && valor === "")) {
            input.classList.add("is-invalid");
            esValido = false;
        } else {
            input.classList.remove("is-invalid");
        }
    });

    if (!esValido) {
        alert("⚠ Por favor complete todos los campos obligatorios.");
    }

    return esValido;
}




///ENTRENAMIENTO

function validarEntrenamientoAntesDeGuardar() {
    let valido = true;

    const campos = [
        { id: "ddlColaborador", nombre: "Colaborador" },
        { id: "ddlOperacion", nombre: "Operación" },
        { id: "ddlEntrenador", nombre: "Entrenador" },
        { id: "ddlTurno", nombre: "Turno" },
        { id: "txtFechaInicio", nombre: "Fecha Inicio" },
        { id: "txtFechaFinal", nombre: "Fecha Final" },
        { id: "ddlTipoEntrenamiento", nombre: "Tipo de Entrenamiento" },
        { id: "ddlTipoEntrenador", nombre: "Tipo de Entrenador" },
        { id: "ddlEstado", nombre: "Estado" }
    ];

    campos.forEach(campo => {
        const control = document.getElementById(campo.id);
        if (!control || control.value === "" || control.value === "0") {
            control.classList.add("is-invalid");
            valido = false;
        } else {
            control.classList.remove("is-invalid");
        }
    });

    if (!valido) {
        alert("⚠ Por favor complete todos los campos obligatorios.");
    }

    return valido;
}
function mostrarToastExitoEntrenamiento() {
    cerrarModal("modalRegistroEntrenamiento");

    const toastEl = document.getElementById("toastSuccess");
    if (toastEl) {
        const toast = new bootstrap.Toast(toastEl);
        toast.show();

        toastEl.addEventListener('shown.bs.toast', () => {
            setTimeout(() => toast.hide(), 5000);
        });
    }
}

window.mostrarToastExitoEntrenamiento = mostrarToastExitoEntrenamiento;


function abrirModalEditarEntrenamiento(id, colaborador, operacion, entrenador, turno, fechaInicio, fechaFinal, tipoEntrenamiento, tipoEntrenador, estado) {
    document.getElementById("ddlColaborador").value = colaborador;
    document.getElementById("ddlOperacion").value = operacion;
    document.getElementById("ddlEntrenador").value = entrenador;
    document.getElementById("ddlTurno").value = turno;
    document.getElementById("txtFechaInicio").value = fechaInicio;
    document.getElementById("txtFechaFinal").value = fechaFinal;
    document.getElementById("ddlTipoEntrenamiento").value = tipoEntrenamiento;
    document.getElementById("ddlTipoEntrenador").value = tipoEntrenador;
    document.getElementById("ddlEstado").value = estado;

    const modal = new bootstrap.Modal(document.getElementById("modalRegistroEntrenamiento"));
    modal.show();
}


function mostrarToastSinResultados() {
    const toastHTML = `
        <div class="toast align-items-center text-white bg-warning border-0 show" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body">
                    🔍 No se encontraron resultados con los filtros aplicados.
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Cerrar"></button>
            </div>
        </div>
    `;
    const container = document.querySelector('.toast-container');
    if (container) {
        container.innerHTML = toastHTML;
    }
}

///
function cargarGraficoCurva(idEntrenamiento) {
    PageMethods.ObtenerDatosCurvaParaGrafico(idEntrenamiento, function (resultado) {
        //  líneas para depurar
        console.log("Esperada:", resultado.Esperada);
        console.log("Real:", resultado.Real);

        const maxDias = Math.max(resultado.Esperada.length, resultado.Real.length);
        const dias = Array.from({ length: maxDias }, (_, i) => "Día " + (i + 1));

        const data = {
            labels: dias,
            datasets: [
                {
                    label: "Esperada",
                    data: resultado.Esperada,
                    borderColor: "blue",
                    borderWidth: 2,
                    fill: false
                },
                {
                    label: "Real",
                    data: resultado.Real,
                    borderColor: "orange",
                    borderWidth: 2,
                    fill: false
                }
            ]
        };

        const config = {
            type: 'line',
            data: data,
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true,
                        text: 'Curva de Aprendizaje (Esperada vs Real)'
                    }
                }
            }
        };

        if (window.chartCurva) {
            window.chartCurva.destroy();
        }

        const canvas = document.getElementById("graficoCurva");
        if (canvas) {
            window.chartCurva = new Chart(canvas, config);
        }
    }, function (error) {
        console.error("Error al obtener datos del gráfico:", error);
    });
}



window.onload = function () {
    console.log("JS cargado");

    const modal = document.getElementById('modalSeguimientoEntrenamiento');
    if (modal) {
        modal.addEventListener('shown.bs.modal', function () {
            console.log("Modal abierto correctamente");
        });
    }
};


function toggleGraficoCurva() {
    const contenedor = document.getElementById("contenedorGrafico");
    const icono = document.getElementById("iconoToggleGrafico");

    if (!contenedor || !icono) return;

    const visible = contenedor.style.display !== "none";

    contenedor.style.display = visible ? "none" : "block";
    icono.className = visible ? "bi bi-chevron-up":"bi bi-chevron-down" ;
}

    // ACCESS

prepararModalCrearPermiso = function () {
    document.getElementById("hdnIdPermiso").value = "";

    $('#ddlCode1').val("").prop("disabled", false).trigger('change');
    $('#ddlMenuKey').val("").prop("disabled", false).trigger('change');

    document.getElementById("chkPuedeVer").checked = false;
    document.getElementById("modalPermisoLabel").innerText = "Agregar Permiso";

    // Ocultar botón eliminar
    const btnEliminar = document.getElementById("btnEliminarPermiso");
    if (btnEliminar) {
        btnEliminar.style.display = "none";
    }

    var modal = new bootstrap.Modal(document.getElementById("modalPermiso"));
    modal.show();
};


abrirModalEditarPermiso = function (idPermiso, code1, menuKey, puedeVer) {
    document.getElementById("hdnIdPermiso").value = idPermiso;

    $('#ddlCode1').val(code1).prop("disabled", true).trigger('change');
    $('#ddlMenuKey').val(menuKey).prop("disabled", true).trigger('change');

    document.getElementById("chkPuedeVer").checked = puedeVer;
    document.getElementById("modalPermisoLabel").innerText = "Editar Permiso";

    // Mostrar botón eliminar
    const btnEliminar = document.getElementById("btnEliminarPermiso");
    if (btnEliminar) {
        btnEliminar.style.display = "inline-block";
    }

    const modal = new bootstrap.Modal(document.getElementById("modalPermiso"));
    modal.show();
};



 cerrarModalPermiso  = function () {
        var modalElement = document.getElementById("modalPermiso");
        var modal = bootstrap.Modal.getInstance(modalElement);
        if (modal) {
            modal.hide();
        }
        return false;
    };

if (window.jQuery) {
    $(function () {
        $('#ddlCode1').select2({
            theme: 'bootstrap4',
            width: '100%',
            dropdownParent: $('#modalPermiso'),
            placeholder: "Seleccione un usuario"
        });

        $('#ddlMenuKey').select2({
            theme: 'bootstrap4',
            width: '100%',
            dropdownParent: $('#modalPermiso'),
            placeholder: "Seleccione un módulo"
        });

        $('#ddlUsuarios').select2({
            theme: 'bootstrap4',
            width: 'style',
            placeholder: "Seleccione un usuario"
        });
    });


}
function confirmarEliminacion() {
    return confirm("¿Estás seguro de que deseas eliminar este permiso?");
}


function mostrarToastExitoPermiso(mensaje = "Acción realizada exitosamente") {
    const toastEl = document.getElementById("toastSuccess");

    if (toastEl) {
        const toastBody = toastEl.querySelector(".toast-body");
        toastBody.textContent = mensaje;

        const toast = new bootstrap.Toast(toastEl);
        toast.show();

        toastEl.addEventListener('shown.bs.toast', () => {
            setTimeout(() => toast.hide(), 5000);
        });
    }
}

function mostrarToastYLimpiarPermiso(mensaje = "Permiso guardado correctamente") {
    cerrarModalPermiso();

    // Limpiar campos del modal
    $('#ddlCode1').val(null).trigger('change');
    $('#ddlMenuKey').val(null).trigger('change');

    const chk = document.getElementById("chkPuedeVer");
    if (chk) chk.checked = false;

    mostrarToastExitoPermiso(mensaje);
}


function limpiarFormularioPermiso() {
    $('#ddlCode1').val('').trigger('change');
    $('#ddlMenuKey').val('').trigger('change');
    document.getElementById("chkPuedeVer").checked = false;
    document.getElementById("hdnIdPermiso").value = "";
}






//Usuarios

// Usuarios

function prepararModalUsuario() {
    // Resetear campos
    $('#ddlCode1').val('').trigger('change');
    document.getElementById('txtNombreUsuario').value = '';
    document.getElementById('ddlRol').selectedIndex = 0;
    document.getElementById('ddlEstadoUsuario').value = '1';
    document.getElementById('hdnIdUsuario').value = '';
    document.getElementById("modalUsuarioLabel").innerText = "Agregar Usuario";

    // Mostrar modal
    const modal = new bootstrap.Modal(document.getElementById("modalUsuario"));
    modal.show();
}

$(document).ready(function () {
    $('#ddlCode1').select2({
        dropdownParent: $('#modalUsuario'),
        width: '100%',
        placeholder: 'Seleccione un colaborador'
    });

    $('#ddlCode1').on('change', function () {
        const selectedText = $(this).find("option:selected").text();
        const nombreSolo = selectedText.split(' - ')[1]?.trim() || "";
        $('#txtNombreUsuario').val(nombreSolo);
    });
});

function prepararModalCrearUsuario() {
    $('#ddlCode1').val('').trigger('change');
    document.getElementById('txtNombreUsuario').value = '';
    document.getElementById('ddlRol').selectedIndex = 0;
    document.getElementById('ddlEstadoUsuario').value = '1';
    document.getElementById('hdnIdUsuario').value = '';
    document.getElementById('modalUsuarioLabel').innerText = 'Agregar Usuario';
}

function abrirModalEditarUsuario(id, code1, nombre, idRol, status, rolNombre) {
    console.log("EDITANDO USUARIO →", {
        id, code1, nombre, idRol, status, rolNombre
    });

    console.log("ddlRol values:", [...document.getElementById("ddlRol").options].map(opt => ({ value: opt.value, text: opt.text })));
    console.log("ddlEstadoUsuario values:", [...document.getElementById("ddlEstadoUsuario").options].map(opt => opt.value));

    document.getElementById("hdnIdUsuario").value = id;
    document.getElementById("txtNombreUsuario").value = nombre;

    $('#ddlCode1').val(code1).trigger('change');
    document.getElementById("ddlRol").value = idRol.toString();
    document.getElementById("ddlEstadoUsuario").value = status.toString();

    document.getElementById("modalUsuarioLabel").innerText = "Editar Usuario";

    const modal = new bootstrap.Modal(document.getElementById("modalUsuario"));
    modal.show();
}

function eliminarUsuario(idUsuario) {
    if (confirm("¿Estás seguro de que deseas eliminar este usuario?")) {
        __doPostBack('EliminarUsuario', idUsuario);
    }
}




//ENTRENADOR


function prepararModalCrearEntrenador() {
    document.getElementById("<%= txtNombreEntrendor.ClientID %>").value = "";
    document.getElementById("<%= txtDescripcionEntrenador.ClientID %>").value = "";
    document.getElementById("<%= ddlEstadoEntrenador.ClientID %>").value = "1";
    document.getElementById("<%= hdnIdRol.ClientID %>").value = "";
    document.getElementById("<%= btnGuardarEntrenador.ClientID %>").value = "Guardar";
    document.getElementById("modalCrearEntrenadorLabel").innerText = "Agregar Nuevo Entrenador";
    document.getElementById("btnEliminarContainer").style.display = "none";
}


function abrirModalEditarEntrenador(id, nombre, tipoEntrenador, estado, idUsuario) {
    $('#ddlCode1').val(idUsuario).trigger('change');
    document.getElementById("txtTipoEntrenador").value = tipoEntrenador;
    document.getElementById("ddlEstadoEntrenador").value = estado;
    document.getElementById("hdnIdEntrenador").value = id;
    document.getElementById("btnGuardarEntrenador").value = "Actualizar";
    document.getElementById("modalCrearEntrenadorLabel").innerText = "Editar Entrenador";
    document.getElementById("btnEliminarContainer").style.display = "block";

    const modal = new bootstrap.Modal(document.getElementById("modalCrearEntrenador"));
    modal.show();
}




function mostrarToastExitoEntrenador() {
    cerrarModal("modalCrearEntrenador");

    // Reiniciar el dropdown de colaborador (Select2)
    $('#ddlCode1').val(null).trigger('change');

    // Limpiar tipo de entrenador y estado
    document.getElementById("txtTipoEntrenador").value = "";
    document.getElementById("ddlEstadoEntrenador").selectedIndex = 0;

    const toastEl = document.getElementById("toastSuccess");
    if (toastEl) {
        const toast = new bootstrap.Toast(toastEl);
        toast.show();

        toastEl.addEventListener('shown.bs.toast', () => {
            setTimeout(() => toast.hide(), 5000);
        });
    }
}



function abrirModalEditarEntrenador(id, nombre, tipoEntrenador, estado, idUsuario) {
    // Seleccionar el colaborador en el select2
    $('#ddlCode1').val(idUsuario).trigger('change');

    // Llenar el campo de descripción
    document.getElementById("txtTipoEntrenador").value = tipoEntrenador;

    // Seleccionar estado
    document.getElementById("ddlEstadoEntrenador").value = estado;

    // Cargar los IDs ocultos
    document.getElementById("hdnIdEntrenador").value = id;
    document.getElementById("hdnIdUsuario").value = idUsuario;

    // Cambiar texto del botón y encabezado
    document.getElementById("btnGuardarEntrenador").value = "Actualizar";
    document.getElementById("modalCrearEntrenadorLabel").innerText = "Editar Entrenador";

    // Mostrar botón eliminar
    document.getElementById("btnEliminarContainer").style.display = "block";

    // Mostrar el modal
    const modal = new bootstrap.Modal(document.getElementById("modalCrearEntrenador"));
    modal.show();
}

//TURNO
function abrirModalEditarTurno_(id, nombre, idArea, status, horaInicio, horaFin, horaLaboradas, idBusinessUnit) {
    // Asignar valores a los campos del modal
    document.getElementById("hdnIdTurno").value = id || "";
    document.getElementById("txtNombreTurno").value = nombre || "";
    document.getElementById("ddlArea").value = idArea || "";
    document.getElementById("ddlEstadoTurno").value = status || "1";

    // Convertir horaInicio y horaFin a formato HH:mm si viene como datetime o string largo
    document.getElementById("txtHoraInicio").value = horaInicio?.substring(0, 5) || "";
    document.getElementById("txtHoraFin").value = horaFin?.substring(0, 5) || "";

    document.getElementById("txtHorasLaboradas").value = horaLaboradas || "";
    document.getElementById("ddlUnidadNegocio").value = idBusinessUnit || "";

    // Cambiar etiquetas del modal
    document.getElementById("btnGuardarTurno").value = "Actualizar";
    document.getElementById("modalCrearTurnoLabel").innerText = "Editar Turno";

    // Mostrar modal
    const modal = new bootstrap.Modal(document.getElementById("modalCrearTurno"));
    modal.show();
}

function validarFormularioTurno() {
    const nombre = document.getElementById("txtNombreTurno").value.trim();
    const area = document.getElementById("ddlArea").value;
    const estado = document.getElementById("ddlEstadoTurno").value;
    const horaInicio = document.getElementById("txtHoraInicio").value;
    const horaFin = document.getElementById("txtHoraFin").value;
    const horasLaboradas = document.getElementById("txtHorasLaboradas").value;
    const unidadNegocio = document.getElementById("ddlUnidadNegocio").value;

    if (
        nombre === "" ||
        area === "0" ||
        estado === "" ||
        horaInicio === "" ||
        horaFin === "" ||
        horasLaboradas === "" ||
        unidadNegocio === "0"
    ) {
        alert("Por favor complete todos los campos antes de guardar.");
        return false;
    }

    return true;
}

//DIAS EXTRA
let contadorDiasExtra = 0;

function agregarDiaExtra(valor = 0, indiceForzado = null) {
    let indice = indiceForzado !== null ? indiceForzado : ++contadorDiasExtra;

    // Asegurar que el contador siempre sea el mayor para evitar duplicados
    contadorDiasExtra = Math.max(contadorDiasExtra, indice);

    const contenedor = document.getElementById("contenedorDiasExtra");

    const div = document.createElement("div");
    div.className = "col-md-4 mb-3 dia-extra-item";
    div.dataset.index = indice;
    div.id = `diaExtra${indice}`;

    const label = document.createElement("label");
    label.className = "form-label fw-bold";
    label.style.color = "#FFA500";
    label.innerText = `Día extra ${indice}:`;

    const inputGroup = document.createElement("div");
    inputGroup.className = "input-group";

    const input = document.createElement("input");
    input.type = "number";
    input.className = "form-control";
    input.name = `inputDiaExtra${indice}`;
    input.id = `inputDiaExtra${indice}`;
    input.value = valor;

    const button = document.createElement("button");
    button.type = "button";
    button.className = "btn btn-outline-danger";
    button.innerHTML = "<i class='bi bi-x'></i>";
    button.onclick = function () {
        contenedor.removeChild(div);
        reindexarDiasExtra();
    };

    const btnWrapper = document.createElement("div");
    btnWrapper.className = "input-group-append";
    btnWrapper.appendChild(button);

    inputGroup.appendChild(input);
    inputGroup.appendChild(btnWrapper);

    div.appendChild(label);
    div.appendChild(inputGroup);

    contenedor.appendChild(div);
}


function reindexarDiasExtra() {
    const items = document.querySelectorAll("#contenedorDiasExtra .dia-extra-item");
    contadorDiasExtra = 0;

    items.forEach((item, index) => {
        const nuevoIndice = index + 1;
        contadorDiasExtra = nuevoIndice;

        item.dataset.index = nuevoIndice;
        item.id = `diaExtra${nuevoIndice}`;

        // Actualizar label
        const label = item.querySelector("label");
        if (label) label.innerText = `Día extra ${nuevoIndice}:`;

        // Actualizar input ID y NAME
        const input = item.querySelector("input");
        if (input) {
            input.name = `inputDiaExtra${nuevoIndice}`;
            input.id = `inputDiaExtra${nuevoIndice}`;
        }
    });
}

function limpiarFormularioSeguimiento() {
    // Limpiar inputs de días normales
    for (let i = 1; i <= 1000; i++) {
        const input = document.getElementById(`inputSeguimientoDia${i}`);
        if (input) input.value = "0";
    }

    // Limpiar días extra (eliminarlos)
    const contenedor = document.getElementById("contenedorDiasExtra");
    if (contenedor) contenedor.innerHTML = "";

    // Limpiar campos adicionales del modal
    document.getElementById("txtHorasEfectivas").value = "";
    document.getElementById("txtBuenasIGTD").value = "";
    document.getElementById("txtMalasIGTD").value = "";

    // Restaurar dropdowns y campos según lógica de negocio si aplica
    document.getElementById("DropDownList1Seguimiento").selectedIndex = 0;
    document.getElementById("ddlStageSRC").selectedIndex = 0;
}
function limpiarDiasExtra() {
    const contenedor = document.getElementById("contenedorDiasExtra");
    contenedor.innerHTML = "";
    contadorDiasExtra = 0;

    // ✅ Agregamos toast visual
    const toast = document.createElement("div");
    toast.className = "toast align-items-center text-bg-warning border-0 show position-fixed bottom-0 end-0 m-3";
    toast.style.zIndex = "9999";
    toast.setAttribute("role", "alert");
    toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                Días extra limpiados correctamente.
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    `;

    document.body.appendChild(toast);

    // Remover después de 3 segundos
    setTimeout(() => {
        toast.remove();
    }, 3000);
}

if (typeof (Sys) !== "undefined" && Sys.WebForms && Sys.WebForms.PageRequestManager) {
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        window.limpiarDiasExtra = limpiarDiasExtra;
    });
}

//

document.addEventListener("DOMContentLoaded", function () {
    const btnCancelar = document.getElementById("btnCancelarSeguimiento");
    const btnCerrar = document.getElementById("btnCerrarModalSeguimiento");

    if (btnCancelar) {
        btnCancelar.addEventListener("click", function () {
            location.reload();
        });
    }

    if (btnCerrar) {
        btnCerrar.addEventListener("click", function () {
            location.reload();
        });
    }
});





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
window.mostrarToastExitoEntrenamiento = mostrarToastExitoEntrenamiento;
window.validarEntrenamientoAntesDeGuardar = validarEntrenamientoAntesDeGuardar;
window.abrirModalEditarEntrenamiento = abrirModalEditarEntrenamiento;
window.mostrarToastSinResultados = mostrarToastSinResultados;
window.cargarGraficoCurva = cargarGraficoCurva;
window.prepararModalCrearPermiso = prepararModalCrearPermiso;
    window.cerrarModalPermiso = cerrarModalPermiso;
window.abrirModalEditarPermiso = abrirModalEditarPermiso;
window.mostrarToastEliminadoBusinessUnit = mostrarToastEliminadoBusinessUnit;


window.prepararModalCrearEntrenador = prepararModalCrearEntrenador;
    window.abrirModalEditarEntrenador = abrirModalEditarEntrenador;
    window.agregarMuda = agregarMuda;
window.eliminarMuda = eliminarMuda;
window.abrirModalEditarTurno= abrirModalEditarArea;
window.agregarDiaExtra = agregarDiaExtra;
window.limpiarDiasExtra = limpiarDiasExtra;