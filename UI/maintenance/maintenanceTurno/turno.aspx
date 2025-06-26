<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="turno.aspx.cs" Inherits="trainingLink.UI.maintenance.maintenanceTurno.turno" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Area - TrainingLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

    <!-- Estilos personalizados -->
    <link href="../../master/styles.css" rel="stylesheet" />
    <style>
        .btn-delete-custom {
            background-color: #E9738E;
            color: white;
            border: none;
        }

        .btn-delete-custom:hover {
            background-color: #d95b76;
            color: white;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- Header -->
<header class="custom-header">
    <button type="button" class="toggle-btn" onclick="toggleSidebar()">☰</button>
    <img src="../../../Files/images/logoPhilips.png" alt="Philips Logo" class="logo" />
               <div class="header-icons d-flex gap-3">
<a href="#" class="text-decoration-none text-dark"
   data-bs-toggle="tooltip"
   data-bs-placement="bottom"
   title="<%= Session["FullName"] != null ? Session["FullName"].ToString() : "Usuario" %>">
   <i class="bi bi-person-circle fs-4"></i>
</a>


        <a href="../maintenanceAccess/access.aspx" class="text-decoration-none text-dark">
            <i class="bi bi-gear-fill fs-4"></i>
        </a>
             </div>
</header>
                   

        <!-- Sidebar -->
        <nav class="sidebar d-flex flex-column vh-100" id="sidebar">
            <div>
                <a id="linkInicio" runat="server" href="../../Home/home.aspx" class="nav-link">Inicio</a>
                <a id="linkAccesos" runat="server" href="../maintenanceAccess/access.aspx" class="nav-link">Acesos</a>
                <a id="linkRegistroEntrenamiento" runat="server" href="../../registroEntrenamiento/registroEntrenamiento.aspx" class="nav-link">Registro Entrenamiento</a>
                <a href="#submenuMantenimientos" class="nav-link dropdown-toggle" data-bs-toggle="collapse" role="button" aria-expanded="false">Mantenimientos</a>
                <div class="collapse ms-3" id="submenuMantenimientos">
                    <a id="linkRol" runat="server" href="../maintenanceRol/rol.aspx" class="nav-link">Role</a>
                    <a id="linkBusinessUnit" runat="server" href="../maintenanceBusinessUnit/businessUnit.aspx" class="nav-link">Business Unit</a>
                    <a id="linkTurno" runat="server" href="../maintenanceTurno/turno.aspx" class="nav-link">Turno</a>
                    <a id="linkMuda" runat="server" href="../maintenanceMuda/muda.aspx" class="nav-link">Muda</a>
                    <a id="linkArea" runat="server" href="../maintenanceArea/area.aspx" class="nav-link">Área</a>
                    <a id="linkScrap" runat="server" href="../maintenanceScrap/scrap.aspx" class="nav-link">Scrap</a>
                    <a id="linkOperacion" runat="server" href="../maintenanceOperaciones/operacion.aspx" class="nav-link">Operación</a>
                    <a id="linkEntrenadores" runat="server" href="../maintenanceEntrenador/entrenador.aspx" class="nav-link">Entrenadores</a> 

                </div>
            </div>

            <!-- Botón Salir al fondo -->
            <div class="mt-auto p-3">
                <asp:Button ID="btnSalir" runat="server" CssClass="btn-plus-custom btn-sm w-100 d-flex align-items-center justify-content-center gap-2" Text="Salir" OnClick="btnSalir_Click" UseSubmitBehavior="false" />
            </div>
        </nav>
         <!-- Main Content -->
 <div class="main-content collapsed" id="mainContent">

        <div class="container py-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0">Turno</h2>
                <button type="button" class="btn btn-plus-custom" data-bs-toggle="modal" data-bs-target="#modalCrearTurno" onclick="prepararModalCrearTurno()">
                    <i class="bi bi-plus-lg"></i>
                </button>
            </div>

            <div class="card mb-4">
                <div class="card-body">
                    <div class="row g-2">
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlFiltroStatusTurno" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroStatus_SelectedIndexChanged">
                                <asp:ListItem Text="Todos" Value="" />
                                <asp:ListItem Text="Activo" Value="1" />
                                <asp:ListItem Text="Inactivo" Value="0" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-9">
                            <asp:Panel runat="server" DefaultButton="btnBuscar">
                                <div class="input-group">
                                    <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar por nombre" />
                                    <asp:LinkButton ID="btnBuscar" runat="server" CssClass="btn btn-search-custom" OnClick="btnBuscar_Click" CausesValidation="false">
                                        <i class="bi bi-search"></i>
                                    </asp:LinkButton>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>

 <asp:GridView ID="gvTurno" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered text-center align-middle" HeaderStyle-CssClass="table-info">
    <Columns>
        <asp:BoundField DataField="Name" HeaderText="Nombre" SortExpression="Name" />
        <asp:BoundField DataField="NombreArea" HeaderText="Área" SortExpression="NombreArea" />
<asp:BoundField DataField="horaInicio" HeaderText="Hora Inicio" />
<asp:BoundField DataField="horaFin" HeaderText="Hora Fin" />

        <asp:BoundField DataField="horaLaboradas" HeaderText="Horas Laboradas" />
        <asp:BoundField DataField="NombreUnidadNegocio" HeaderText="Unidad de Negocio" />

        <asp:TemplateField HeaderText="Estado">
            <ItemTemplate>
                <%# Convert.ToBoolean(Eval("Status")) ? "Activo" : "Inactivo" %>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Acciones">
            <ItemTemplate>
                <a href="javascript:void(0);" onclick='abrirModalEditarTurno(
    "<%# Eval("IdTurno") %>",
    "<%# Eval("Name") %>",
    "<%# Eval("IdArea") %>",
    "<%# Convert.ToBoolean(Eval("Status")) ? "1" : "0" %>",
    "<%# Eval("horaInicio", "{0:hh\\:mm}") %>",
    "<%# Eval("horaFin", "{0:hh\\:mm}") %>",
    "<%# Eval("horaLaboradas") %>",
    "<%# Eval("idBusinessUnit") %>")'>
    <i class="bi bi-pencil-square"></i>
</a>

            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

                    <!-- Toast -->
        <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">
            <div id="toastSuccess" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body" id="toastMessage">
                        ✅ Acción realizada exitosamente.
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Cerrar"></button>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="custom-footer">
        <strong>TrainingLink</strong><br />
        Sistema de Gestión de Training
    </footer>
</div>

            <!-- Modal -->
           <div class="modal fade" id="modalCrearTurno" tabindex="-1" aria-labelledby="modalCrearTurnoLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalCrearTurnoLabel">Agregar Turno</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hdnIdTurno" runat="server" />

                <!-- Nombre del Turno -->
                <div class="mb-3">
                    <label for="txtNombreTurno" class="form-label">Nombre</label>
                    <asp:TextBox ID="txtNombreTurno" runat="server" CssClass="form-control" ClientIDMode="Static" />
                </div>

                <!-- Área -->
                <div class="mb-3">
                    <label for="ddlArea" class="form-label">Área</label>
                    <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select" ClientIDMode="Static" />
                </div>

                <!-- Estado -->
                <div class="mb-3">
                    <label for="ddlEstadoTurno" class="form-label">Estado</label>
                    <asp:DropDownList ID="ddlEstadoTurno" runat="server" CssClass="form-select" ClientIDMode="Static">
                        <asp:ListItem Text="Activo" Value="1" />
                        <asp:ListItem Text="Inactivo" Value="0" />
                    </asp:DropDownList>
                </div>

      <!-- Hora de Inicio -->
<div class="mb-3">
    <label for="txtHoraInicio" class="form-label">Hora de Inicio</label>
    <asp:TextBox ID="txtHoraInicio" runat="server" CssClass="form-control" TextMode="Time" ClientIDMode="Static" />
</div>

<!-- Hora de Fin -->
<div class="mb-3">
    <label for="txtHoraFin" class="form-label">Hora de Fin</label>
    <asp:TextBox ID="txtHoraFin" runat="server" CssClass="form-control" TextMode="Time" ClientIDMode="Static" />
</div>


                <!-- Horas Laboradas -->
                <div class="mb-3">
                    <label for="txtHorasLaboradas" class="form-label">Horas Laboradas</label>
                    <asp:TextBox ID="txtHorasLaboradas" runat="server" CssClass="form-control" TextMode="Number" ClientIDMode="Static" />
                </div>

                <!-- Unidad de Negocio -->
                <div class="mb-3">
                    <label for="ddlUnidadNegocio" class="form-label">Unidad de Negocio</label>
                    <asp:DropDownList ID="ddlUnidadNegocio" runat="server" CssClass="form-select" ClientIDMode="Static" />
                </div>
            </div>

            <div class="modal-footer">
                <asp:Button ID="Button1" runat="server" CssClass="btn btn-primary" Text="Guardar" OnClick="btnGuardarTurno_ServerClick" />
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
            </div>
        </div>
    </div>
</div>

                          <div class="modal-footer">
      <div id="btnEliminarContainerTurno" class="me-auto" style="display:none">
<asp:Button ID="btnEliminarTurno" runat="server"
            CssClass="btn btn-delete-custom"
            Text="Eliminar"
            OnClientClick="return confirm('¿Estás seguro de que deseas eliminar este Turno?');"
            OnClick="btnEliminarTurno_ServerClick" />
      </div>
      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
<asp:Button ID="btnGuardarTurno" runat="server"
    CssClass="btn btn-save-custom"
    Text="Guardar"
    OnClientClick="return validarFormularioTurno();"
    OnClick="btnGuardarTurno_ServerClick"
    ClientIDMode="Static" />


                        </div>
           
          <!-- Scripts -->
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Select2 -->
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<!-- Bootstrap JS (esto es lo que falta) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Tu script personalizado -->
<script src="../../master/scripts.js"></script>

  

            <script>
                function prepararModalCrearTurno() {
                    document.getElementById("txtNombreTurno").value = "";
                    document.getElementById("ddlEstadoTurno").value = "1";
                    document.getElementById("ddlArea").selectedIndex = 0;
                    document.getElementById("hdnIdTurno").value = "";
                    document.getElementById("btnGuardarTurno").value = "Guardar";
                    document.getElementById("modalCrearTurnoLabel").innerText = "Agregar Turno";
                    // Ocultar botón eliminar
                    document.getElementById("btnEliminarContainerTurno").style.display = "none";
                }

                function abrirModalEditarTurno(id, name, idArea, status) {
                    document.getElementById("txtNombreTurno").value = name;
                    document.getElementById("ddlEstadoTurno").value = status;
                    document.getElementById("ddlArea").value = idArea;
                    document.getElementById("hdnIdTurno").value = id;
                    document.getElementById("btnGuardarTurno").value = "Actualizar";
                    document.getElementById("modalCrearTurnoLabel").innerText = "Editar Turno";

                    // Mostrar botón eliminar
                    document.getElementById("btnEliminarContainerTurno").style.display = "block";


                    const modal = new bootstrap.Modal(document.getElementById("modalCrearTurno"));
                    modal.show();
                }
            </script>
        
    </form>
</body>
</html>

