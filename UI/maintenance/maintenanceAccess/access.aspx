﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="access.aspx.cs" Inherits="trainingLink.UI.maintenance.maintenanceAccess.access" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Gestión de Accesos</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

    <!-- Select2 y Bootstrap 5 theme -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/@ttskch/select2-bootstrap4-theme@1.6.2/dist/select2-bootstrap4.min.css" rel="stylesheet" />

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
<!-- Sidebar -->
<nav class="sidebar collapsed d-flex flex-column vh-100" id="sidebar">
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
    <!-- Main Content -->
<div class="main-content collapsed" id="mainContent">
            <div class="container py-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="mb-0 tituloRol">Gestión de Accesos</h2>
                </div>
         <div class="d-flex justify-content-between align-items-center mb-3">
    <div class="w-25">
        <asp:DropDownList ID="ddlUsuarios" runat="server" CssClass="form-select select2-bootstrap" ClientIDMode="Static" AutoPostBack="true" OnSelectedIndexChanged="ddlUsuarios_SelectedIndexChanged" />
    </div>
    <div class="d-flex gap-2">
       <a href="../maintenanceUsuarios/usuarios.aspx" class="btn btn-outline-primary">
    <i class="bi bi-person-fill"></i> Usuarios
</a>
        <asp:Button ID="btnAgregar" runat="server" Text="Agregar Acceso" CssClass="btn btn-primary" OnClientClick="prepararModalCrearPermiso(); return false;" />
    </div>
</div>

                <div class="card mb-4">
                    <asp:GridView ID="gvPermisos" runat="server" CssClass="table table-bordered table-hover text-center align-middle" AutoGenerateColumns="False" DataKeyNames="IdPermiso">
                        <Columns>
                            <asp:BoundField DataField="Code1" HeaderText="Usuario" />
                            <asp:BoundField DataField="FullName" HeaderText="Nombre" />
                            <asp:BoundField DataField="MenuKey" HeaderText="Módulo" />
                            <asp:CheckBoxField DataField="PuedeVer" HeaderText="Tiene Acceso" />
                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>
                                    <button type="button" class="btn btn-outline-info btn-sm" onclick='<%# "abrirModalEditarPermiso(\"" + Eval("IdPermiso") + "\",\"" + Eval("Code1") + "\",\"" + Eval("MenuKey") + "\"," + Eval("PuedeVer").ToString().ToLower() + ")" %>'>
                                        <i class="bi bi-pencil-square"></i>
                                    </button>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

                <!-- Toast -->
                <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">
                    <div id="toastSuccess" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                        <div class="d-flex">
                            <div class="toast-body">✅ Acción realizada exitosamente.</div>
                            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Cerrar"></button>
                        </div>
                    </div>
                </div>
            </div>

            <footer class="custom-footer">
                <strong>TrainingLink</strong><br />
                Sistema de Gestión de Training
            </footer>
        </div>

        <!-- Modal -->
        <div class="modal fade" id="modalPermiso" tabindex="-1" aria-labelledby="modalPermisoLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content rounded-3 shadow-lg">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="modalPermisoLabel">Agregar/Editar Permiso</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <asp:HiddenField ID="hdnIdPermiso" runat="server" />
                        <div class="mb-3">
                            <label for="ddlCode1" class="form-label">Usuario</label>
                            <asp:DropDownList ID="ddlCode1" runat="server" CssClass="form-select" ClientIDMode="Static" />
                        </div>
                        <div class="mb-3">
                            <label for="txtMenuKey" class="form-label">Módulo (MenuKey)</label>
                            <asp:DropDownList ID="ddlMenuKey" runat="server" CssClass="form-select" ClientIDMode="Static" />
                        </div>
                        <div class="form-check form-switch mb-3">
                            <input type="checkbox" class="form-check-input" id="chkPuedeVer" name="chkPuedeVer" />
                            <label class="form-check-label label-turquesa" for="chkPuedeVer">Acceso</label>
                        </div>
                        <div class="modal-footer d-flex justify-content-between">
                            <asp:Button ID="btnEliminarPermiso" runat="server" CssClass="btn btn-danger me-auto" Text="Eliminar" OnClientClick="return confirmarEliminacion();" OnClick="btnEliminarPermiso_Click" Style="display: none;" />
                            <div>
                                <asp:Button ID="btnGuardarPermiso" runat="server" CssClass="btn btn-success" Text="Guardar" OnClick="btnGuardarPermiso_Click" />
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script src="../../master/scripts.js"></script>

<script>
    $(function () {
        $('#ddlCode1').select2({
            dropdownParent: $('#modalPermiso'),
            theme: 'bootstrap4',
            width: '100%',
            placeholder: 'Seleccione un usuario'
        });
    });
</script>


    </form>
</body>
</html>