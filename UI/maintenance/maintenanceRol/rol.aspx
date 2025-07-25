﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="rol.aspx.cs" Inherits="trainingLink.UI.maintenance.maintenanceRol.rol" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Role - TrainingLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

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
                    <h2 class="mb-0 tituloRol">Role</h2>
                    <button type="button" class="btn btn-plus-custom" data-bs-toggle="modal" data-bs-target="#modalCrearRol" onclick="prepararModalCrear()">
                        <i class="bi bi-plus-lg"></i>
                    </button>
                </div>
<div class="card mb-4">
    <div class="card-body">
        <div class="row g-2 align-items-end">
            <!-- Dropdown: filtro por estado -->
            <div class="col-md-4">
                <asp:DropDownList ID="ddlFiltroStatus" runat="server"
                    CssClass="form-select"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="ddlFiltroStatus_SelectedIndexChanged">
                    <asp:ListItem Text="All" Value="" />
                    <asp:ListItem Text="Active" Value="1" />
                    <asp:ListItem Text="Inactive" Value="0" />
                </asp:DropDownList>
            </div>

            <!-- Búsqueda a la derecha -->
            <div class="col-md-8">
                <asp:Panel runat="server" DefaultButton="btnBuscar">
                    <div class="input-group">
                        <asp:TextBox ID="txtBuscar" runat="server"
                            CssClass="form-control"
                            placeholder="Search" />
                        <asp:LinkButton ID="btnBuscar" runat="server"
                            CssClass="btn btn-search-custom"
                            OnClick="btnBuscar_Click"
                            CausesValidation="false">
                            <i class="bi bi-search"></i>
                        </asp:LinkButton>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>
</div>


                <asp:GridView ID="gvRoles" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered text-center align-middle" HeaderStyle-CssClass="table-info">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="Role" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:TemplateField HeaderText="Estado">
    <ItemTemplate>
        <%# Convert.ToBoolean(Eval("Status")) ? "Activo" : "Inactivo" %>
    </ItemTemplate>
</asp:TemplateField>

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <a href="javascript:void(0);" onclick='abrirModalEditar("<%# Eval("IdRol") %>", "<%# Eval("Name") %>", "<%# Eval("Description") %>", "<%# (Convert.ToBoolean(Eval("Status")) ? "1" : "0") %>")'>
                                    <i class="bi bi-pencil-square"></i>
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>



                 <!-- Toast -->
            <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">
                <div id="toastSuccess" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="d-flex">
                        <div class="toast-body">
                            ✅ Acción realizada exitosamente.
                        </div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Cerrar"></button>
                    </div>
                </div>
            </div>

            <footer class="custom-footer">
                <strong>TrainingLink</strong><br />
                Sistema de Gestión de Training
            </footer>
        </div>

        <div class="modal fade" id="modalCrearRol" tabindex="-1" aria-labelledby="modalCrearRolLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content modal-bg-custom">
                    <div class="modal-header modal-header-custom">
                        <h5 class="modal-title" id="modalCrearRolLabel">Agregar Nuevo Rol</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="txtNombreRol" class="form-label">Nombre del Rol</label>
                            <asp:TextBox ID="txtNombreRol" runat="server" CssClass="form-control" placeholder="Ej. Supervisor" />
                            <asp:HiddenField ID="hdnIdRol" runat="server" />
                        </div>
                        <div class="mb-3">
                            <label for="txtDescripcionRol" class="form-label">Descripción</label>
                            <asp:TextBox ID="txtDescripcionRol" runat="server" CssClass="form-control" placeholder="Descripción del rol" />
                        </div>
                        <div class="mb-3">
                            <label for="ddlEstadoRol" class="form-label">Estado</label>
                            <asp:DropDownList ID="ddlEstadoRol" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Activo" Value="1" />
                                <asp:ListItem Text="Inactivo" Value="0" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <div id="btnEliminarContainer" class="me-auto" style="display:none">
                            <asp:Button ID="btnEliminarRol" runat="server" CssClass="btn btn-delete-custom" Text="Eliminar" OnClientClick="return confirm('¿Estás seguro de que deseas eliminar este rol?');" OnClick="btnEliminarRol_ServerClick" />
                        </div>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnGuardarRol" runat="server" CssClass="btn btn-save-custom" OnClick="btnGuardarRol_ServerClick" Text="Guardar" />
                    </div>
                </div>
            </div>
        </div>
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
            function prepararModalCrear() {
                document.getElementById("<%= txtNombreRol.ClientID %>").value = "";
                document.getElementById("<%= txtDescripcionRol.ClientID %>").value = "";
                document.getElementById("<%= ddlEstadoRol.ClientID %>").value = "1";
                document.getElementById("<%= hdnIdRol.ClientID %>").value = "";
                document.getElementById("<%= btnGuardarRol.ClientID %>").value = "Guardar";
                document.getElementById("modalCrearRolLabel").innerText = "Agregar Nuevo Rol";
                document.getElementById("btnEliminarContainer").style.display = "none";
            }

            function abrirModalEditar(id, name, description, status) {
                document.getElementById("<%= txtNombreRol.ClientID %>").value = name;
                document.getElementById("<%= txtDescripcionRol.ClientID %>").value = description;
                document.getElementById("<%= ddlEstadoRol.ClientID %>").value = status;
                document.getElementById("<%= hdnIdRol.ClientID %>").value = id;
                document.getElementById("<%= btnGuardarRol.ClientID %>").value = "Actualizar";
                document.getElementById("modalCrearRolLabel").innerText = "Editar Rol";
                document.getElementById("btnEliminarContainer").style.display = "block";
                const modal = new bootstrap.Modal(document.getElementById("modalCrearRol"));
                modal.show();
            }
        </script>
    </form>
</body>
</html>
