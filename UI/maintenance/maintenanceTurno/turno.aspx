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
        <a href="#" class="text-decoration-none text-dark"><i class="bi bi-person-circle fs-4"></i></a>
        <a href="#" class="text-decoration-none text-dark"><i class="bi bi-gear-fill fs-4"></i></a>
    </div>
</header>
           <!-- Sidebar -->
   <nav class="sidebar collapsed" id="sidebar">
       <a href="..\Home\home.aspx" class="nav-link">Inicio</a>
       <a href="#" class="nav-link">Usuarios</a>
       <a href="#" class="nav-link">Reportes</a>
       <a href="#submenuMantenimientos" class="nav-link dropdown-toggle" data-bs-toggle="collapse">Mantenimientos</a>
       <div class="collapse ms-3" id="submenuMantenimientos">
           <a href="../maintenanceRol/rol.aspx" class="nav-link">Role</a>
           <a href="../maintenanceBusinessUnit/businessUnit.aspx" class="nav-link">Bussines Unit</a>
           <a href="../maintenanceTurno/rol.aspx" class="nav-link">Turno</a>
           <a href="../maintenanceArea/area.aspx" class="nav-link">Área</a>
       </div>
       <a href="#" class="nav-link">Salir</a>
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

            <asp:GridView ID="gvTurno" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered text-center align-middle">
                <Columns>
                    <asp:BoundField DataField="Name" HeaderText="Nombre" SortExpression="Name" />
                    <asp:BoundField DataField="NombreArea" HeaderText="Área" SortExpression="NombreArea" />
                    <asp:TemplateField HeaderText="Estado">
                        <ItemTemplate>
                            <%# Convert.ToBoolean(Eval("Status")) ? "Activo" : "Inactivo" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Acciones">
                        <ItemTemplate>
                            <a href="javascript:void(0);" onclick='abrirModalEditarTurno("<%# Eval("IdTurno") %>", "<%# Eval("Name") %>", "<%# Eval("IdArea") %>", "<%# Convert.ToBoolean(Eval("Status")) ? "1" : "0" %>")'>
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

                            <div class="mb-3">
                                <label for="txtNombreTurno" class="form-label">Nombre</label>
                                <asp:TextBox ID="txtNombreTurno" runat="server" CssClass="form-control" ClientIDMode="Static" />
                            </div>

                            <div class="mb-3">
                                <label for="ddlArea" class="form-label">Área</label>
                                <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select" ClientIDMode="Static" />
                            </div>

                            <div class="mb-3">
                                <label for="ddlEstadoTurno" class="form-label">Estado</label>
                                <asp:DropDownList ID="ddlEstadoTurno" runat="server" CssClass="form-select" ClientIDMode="Static">
                                    <asp:ListItem Text="Activo" Value="1" />
                                    <asp:ListItem Text="Inactivo" Value="0" />
                                </asp:DropDownList>
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
    OnClientClick="return validarAreaAntesDeGuardar('ddlArea');"
    OnClick="btnGuardarTurno_ServerClick"
    ClientIDMode="Static" />

                        </div>
                    </div>
                </div>
            </div>
          <!-- Scripts -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <!-- JavaScript Functions -->
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

