<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="muda.aspx.cs" Inherits="trainingLink.UI.maintenance.maintenanceMuda.muda" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Muda - TrainingLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
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
                    <h2 class="mb-0">Muda</h2>
                    <button type="button" class="btn btn-plus-custom" data-bs-toggle="modal" data-bs-target="#modalCrearMuda" onclick="prepararModalCrearMuda()">
                        <i class="bi bi-plus-lg"></i>
                    </button>
                </div>
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row g-2">
                            <div class="col-md-3">
                                <asp:DropDownList ID="ddlFiltroStatusMuda" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroStatusMuda_SelectedIndexChanged">
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
                 <!-- GridView for Areas -->

                <asp:GridView ID="gvMuda" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered text-center align-middle" HeaderStyle-CssClass="table-info">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="Nombre" SortExpression="Name" />
                        <asp:TemplateField HeaderText="Estado">
                            <ItemTemplate>
                                <%# Convert.ToBoolean(Eval("Status")) ? "Activo" : "Inactivo" %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <a href="javascript:void(0);" onclick='abrirModalEditarMuda("<%# Eval("IdMuda") %>", "<%# Eval("Name") %>", "<%# Convert.ToBoolean(Eval("Status")) ? "1" : "0" %>")'>
                                    <i class="bi bi-pencil-square"></i>
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <!-- Toast -->
                <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">
                    <div id="toastSuccess" class="toast align-items-center text-white bg-success border-0" role="alert">
                        <div class="d-flex">
                            <div class="toast-body">✅ Acción realizada exitosamente.</div>
                            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Cerrar"></button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Muda -->
            <div class="modal fade" id="modalCrearMuda" tabindex="-1" aria-labelledby="modalCrearMudaLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalCrearMudaLabel">Agregar Muda</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <asp:HiddenField ID="hdnIdMuda" runat="server" />
                            <div class="mb-3">
                                <label for="txtNombreMuda" class="form-label">Nombre</label>
                                <asp:TextBox ID="txtNombreMuda" runat="server" CssClass="form-control" ClientIDMode="Static" />
                            </div>
                            <div class="mb-3">
                                <label for="ddlEstadoMuda" class="form-label">Estado</label>
                                <asp:DropDownList ID="ddlEstadoMuda" runat="server" CssClass="form-select" ClientIDMode="Static">
                                    <asp:ListItem Text="Activo" Value="1" />
                                    <asp:ListItem Text="Inactivo" Value="0" />
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <div id="btnEliminarContainerMuda" class="me-auto" style="display:none">
<asp:Button ID="btnEliminarMuda" runat="server"
    Text="Eliminar"
    CssClass="btn btn-delete-custom"
    OnClientClick="return confirm('¿Estás seguro de que deseas eliminar esta Muda?');"
    OnClick="btnEliminarMuda_ServerClick" />
                            </div>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <asp:Button ID="btnGuardarMuda" runat="server" CssClass="btn btn-save-custom" Text="Guardar" OnClick="btnGuardarMuda_ServerClick" ClientIDMode="Static" />
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="../../master/scripts.js"></script>
        <script>
            function prepararModalCrearMuda() {
                document.getElementById("txtNombreMuda").value = "";
                document.getElementById("ddlEstadoMuda").value = "1";
                document.getElementById("hdnIdMuda").value = "";
                document.getElementById("btnGuardarMuda").value = "Guardar";
                document.getElementById("modalCrearMudaLabel").innerText = "Agregar Muda";
                document.getElementById("btnEliminarContainerMuda").style.display = "none";
            }

            function abrirModalEditarMuda(id, name, status) {
                document.getElementById("txtNombreMuda").value = name;
                document.getElementById("ddlEstadoMuda").value = status;
                document.getElementById("hdnIdMuda").value = id;
                document.getElementById("btnGuardarMuda").value = "Actualizar";
                document.getElementById("modalCrearMudaLabel").innerText = "Editar Muda";
                document.getElementById("btnEliminarContainerMuda").style.display = "block";

                const modal = new bootstrap.Modal(document.getElementById("modalCrearMuda"));
                modal.show();
            }
        </script>
    </form>
</body>
</html>

