﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="area.aspx.cs" Inherits="trainingLink.UI.maintenance.maintenanceArea.area" %> 
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
            <a href="..\registroEntrenamiento/registroEntrenamiento.aspx" class="nav-link">Registro Entrenamiento</a>
            <a href="#" class="nav-link">Usuarios</a>
            <a href="#" class="nav-link">Reportes</a>
            <a href="#submenuMantenimientos" class="nav-link dropdown-toggle" data-bs-toggle="collapse">Mantenimientos</a>
            <div class="collapse ms-3" id="submenuMantenimientos">
                <a href="../maintenanceRol/rol.aspx" class="nav-link">Role</a>
                <a href="../maintenanceBusinessUnit/businessUnit.aspx" class="nav-link">Bussines Unit</a>
                <a href="../maintenanceTurno/turno.aspx" class="nav-link">Turno</a>
                 <a href="../maintenanceMuda/muda.aspx" class="nav-link">Muda</a>
                <a href="../maintenanceArea/area.aspx" class="nav-link">Área</a>
                  <a href="../maintenanceScrap/scrap.aspx" class="nav-link active">Scrap</a>
            </div>
            <a href="#" class="nav-link">Salir</a>
        </nav>

        <!-- Main Content -->
        <div class="main-content collapsed" id="mainContent">
            <div class="container py-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="mb-0 tituloRol">Area</h2>
                    <button type="button" class="btn btn-plus-custom" data-bs-toggle="modal" data-bs-target="#modalCrearArea" onclick="prepararModalCrearArea()">
                        <i class="bi bi-plus-lg"></i>
                    </button>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row g-2">
                            <div class="col-md-3">
                                <asp:DropDownList ID="ddlFiltroStatus" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroStatus_SelectedIndexChanged">
                                    <asp:ListItem Text="Todos" Value="" />
                                    <asp:ListItem Text="Activo" Value="1" />
                                    <asp:ListItem Text="Inactivo" Value="0" />
                                </asp:DropDownList>
                            </div>
                           <div class="col-md-3">
    <asp:DropDownList ID="ddlFiltroBusinessUnit" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroBusinessUnit_SelectedIndexChanged">
        <asp:ListItem Text="Todos" Value="0" />
      
    </asp:DropDownList>
</div>

                            <div class="col-md-6">
                                <asp:Panel runat="server" DefaultButton="btnBuscar">
                                    <div class="input-group">
                                        <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar por nombre o descripción" />
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
                <asp:GridView ID="gvAreas" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered text-center align-middle" HeaderStyle-CssClass="table-info">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="Nombre" SortExpression="Name" />
                        <asp:BoundField DataField="Description" HeaderText="Descripción" SortExpression="Description" />
                        <asp:BoundField DataField="BusinessUnitName" HeaderText="Unidad de Negocio" SortExpression="BusinessUnitName" />
                        <asp:TemplateField HeaderText="Estado">
                            <ItemTemplate>
                                <%# (Convert.ToBoolean(Eval("Status")) ? "Activo" : "Inactivo") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <a href="javascript:void(0);" onclick='abrirModalEditar("<%# Eval("IdArea") %>", "<%# Eval("Name") %>", "<%# Eval("Description") %>", "<%# Eval("IdBussinesUnit") %>", "<%# (Convert.ToBoolean(Eval("Status")) ? "1" : "0") %>")'>
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

        <!-- Modal Área -->
        <div class="modal fade" id="modalCrearArea" tabindex="-1" aria-labelledby="modalCrearAreaLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content modal-bg-custom">
                    <div class="modal-header modal-header-custom">
                        <h5 class="modal-title" id="modalCrearAreaLabel">Agregar Nueva Área</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="txtNombreArea" class="form-label">Nombre del Área</label>
                            <asp:TextBox ID="txtNombreArea" runat="server" CssClass="form-control" />
                            <asp:HiddenField ID="hdnIdArea" runat="server" />
                        </div>
                        <div class="mb-3">
                            <label for="txtDescripcionArea" class="form-label">Descripción</label>
                            <asp:TextBox ID="txtDescripcionArea" runat="server" CssClass="form-control" />
                        </div>
                        <div class="mb-3">
                            <label for="ddlBusinessUnit" class="form-label">Unidad de Negocio</label>
                         <asp:DropDownList ID="ddlBusinessUnit" runat="server" CssClass="form-select">
                         </asp:DropDownList>

                        </div>
                        <div class="mb-3">
                            <label for="ddlEstadoArea" class="form-label">Estado</label>
                            <asp:DropDownList ID="ddlEstadoArea" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Activo" Value="1" />
                                <asp:ListItem Text="Inactivo" Value="0" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <div id="btnEliminarContainer" class="me-auto" style="display:none">
                            <asp:Button ID="btnEliminarArea" runat="server" CssClass="btn btn-delete-custom" Text="Eliminar" OnClientClick="return confirm('¿Estás seguro de que deseas eliminar esta área?');" OnClick="btnEliminarArea_ServerClick" />
                        </div>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnGuardarArea" runat="server" CssClass="btn btn-save-custom" OnClick="btnGuardarArea_ServerClick" Text="Guardar" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <!-- JavaScript Functions -->
        <script src="../../master/scripts.js"></script>
        <script>
            // Function to prepare the modal for creating a new Area
            function prepararModalCrearArea() {
                document.getElementById("<%= txtNombreArea.ClientID %>").value = "";
                document.getElementById("<%= txtDescripcionArea.ClientID %>").value = "";
                document.getElementById("<%= ddlEstadoArea.ClientID %>").value = "1";
                document.getElementById("<%= hdnIdArea.ClientID %>").value = "";
                document.getElementById("<%= btnGuardarArea.ClientID %>").value = "Guardar";
                document.getElementById("modalCrearAreaLabel").innerText = "Agregar Nueva Área";
                document.getElementById("btnEliminarContainer").style.display = "none";
            }

            // Function to open the modal for editing an existing Area
            function abrirModalEditar(id, name, description, businessUnitId, status) {
                document.getElementById("<%= txtNombreArea.ClientID %>").value = name;
                document.getElementById("<%= txtDescripcionArea.ClientID %>").value = description;
                document.getElementById("<%= ddlEstadoArea.ClientID %>").value = status;
                document.getElementById("<%= hdnIdArea.ClientID %>").value = id;

                // Set the business unit value - if necessary, you can populate the dropdown here
                document.getElementById("<%= ddlBusinessUnit.ClientID %>").value = businessUnitId;

                document.getElementById("<%= btnGuardarArea.ClientID %>").value = "Actualizar";
                document.getElementById("modalCrearAreaLabel").innerText = "Editar Área";
                document.getElementById("btnEliminarContainer").style.display = "block";

                const modal = new bootstrap.Modal(document.getElementById("modalCrearArea"));
                modal.show();
            }
        </script>
    </form>
</body>
</html>
