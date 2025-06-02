<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="usuarios.aspx.cs" Inherits="trainingLink.UI.maintenance.maintenanceUsuario.usuario" %>
<%@ Import Namespace="System.Web" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Usuarios - TrainingLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="../../master/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
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
                </div>
            </div>
            <div class="mt-auto p-3">
                <asp:Button ID="btnSalir" runat="server" CssClass="btn-plus-custom btn-sm w-100 d-flex align-items-center justify-content-center gap-2" Text="Salir" OnClick="btnSalir_Click" UseSubmitBehavior="false" />
            </div>
        </nav>

        <!-- Main Content -->
        <div class="main-content collapsed" id="mainContent">
            <div class="container py-5">
   <div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="mb-0">Usuarios</h2>

 <asp:Button ID="btnAgregarUsuario" runat="server"
    CssClass="btn btn-plus-custom"
    OnClientClick="prepararModalUsuario(); return false;" Text="+" />

</div>

   <asp:GridView ID="gvUsuarios" runat="server" AutoGenerateColumns="False"
    CssClass="table table-bordered text-center align-middle" HeaderStyle-CssClass="table-info">
    <Columns>
        <asp:BoundField DataField="Code1" HeaderText="Code1" />
        <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
        <asp:BoundField DataField="Rol" HeaderText="Rol" />

        <asp:TemplateField HeaderText="Estado">
            <ItemTemplate>
                <%# Convert.ToInt32(Eval("Status")) == 1 ? "Activo" : "Inactivo" %>
            </ItemTemplate>
        </asp:TemplateField>

   <asp:TemplateField HeaderText="Acciones">
    <ItemTemplate>
        <a href="javascript:void(0);"
           onclick='<%# "abrirModalEditarUsuario(" 
           + Eval("IdUsuario") + ", \"" 
           + Eval("Code1") + "\", \"" 
           + Eval("Nombre").ToString().Replace("\"", "\\\"") + "\", " 
           + Eval("IdRol") + ", " 
           + (Convert.ToBoolean(Eval("Status")) ? "1" : "0") + ", \"" 
           + Eval("Rol").ToString().Replace("\"", "\\\"") + "\")" %>'>
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

        <!-- Modal -->
<div class="modal fade" id="modalUsuario" tabindex="-1" aria-labelledby="modalUsuarioLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content rounded-3 shadow-lg">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="modalUsuarioLabel">Agregar/Editar Usuario</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hdnIdUsuario" runat="server" />

                <div class="mb-3">
                    <label for="ddlCode1" class="form-label">Usuario</label>
<asp:DropDownList ID="ddlCode1" runat="server" ClientIDMode="Static" />                </div>
<div class="mb-3">
    <label for="txtNombreUsuario" class="form-label">Nombre</label>
<asp:TextBox ID="txtNombreUsuario" runat="server" ClientIDMode="Static" /></div>



                <div class="mb-3">
                    <label for="ddlRol" class="form-label">Rol</label>
<asp:DropDownList ID="ddlRol" runat="server" CssClass="form-select" ClientIDMode="Static" EnableViewState="true" />                </div>

           <div class="mb-3">
    <label for="ddlEstadoUsuario" class="form-label">Estado</label>
<asp:DropDownList ID="ddlEstadoUsuario" runat="server" CssClass="form-select" ClientIDMode="Static" EnableViewState="true">
    <asp:ListItem Text="Activo" Value="1" />
    <asp:ListItem Text="Inactivo" Value="0" />
</asp:DropDownList>


</div>


            </div>
            <div class="modal-footer">
                <asp:Button ID="btnGuardarUsuario" runat="server" CssClass="btn btn-success" Text="Guardar" OnClick="btnGuardarUsuario_Click" />
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
            </div>
        </div>
    </div>
</div>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script src="../../master/scripts.js"></script>

<script>
    $(document).ready(function () {
        const ddl = $('#ddlCode1');

        if (ddl.length) {
            ddl.select2({
                dropdownParent: $('#modalUsuario'),
                width: '100%',
                placeholder: 'Seleccione un colaborador'
            });

            ddl.on('change', function () {
                const text = $(this).find("option:selected").text();
                const nombreSolo = text.split(' - ')[1]?.trim() || "";
                $('#txtNombreUsuario').val(nombreSolo);
            });
        }
    });
</script>



    </form>
</body>
</html>
