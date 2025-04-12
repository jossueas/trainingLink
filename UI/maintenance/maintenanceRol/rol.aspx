<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="rol.aspx.cs" Inherits="trainingLink.UI.maintenance.maintenanceRol.rol" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Role - TrainingLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

    <!-- Estilos personalizados -->
    <link href="../../master/styles.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <header class="custom-header">
            <button type="button" class="toggle-btn" onclick="toggleSidebar()">☰</button>
            <img src="../../../Files/images/logoPhilips.png" alt="Philips Logo" class="logo" />
            <div class="header-icons d-flex gap-3">
                <a href="#" class="text-decoration-none text-dark">
                    <i class="bi bi-person-circle fs-4"></i>
                </a>
                <a href="#" class="text-decoration-none text-dark">
                    <i class="bi bi-gear-fill fs-4"></i>
                </a>
            </div>
        </header>

        <!-- Sidebar -->
        <nav class="sidebar collapsed" id="sidebar">
            <a href="#" class="nav-link">Inicio</a>
            <a href="#" class="nav-link">Usuarios</a>
            <a href="#" class="nav-link">Reportes</a>
            <a href="#submenuMantenimientos" class="nav-link dropdown-toggle" data-bs-toggle="collapse" role="button" aria-expanded="false">Mantenimientos</a>
            <div class="collapse ms-3" id="submenuMantenimientos">
                <a href="../maintenanceRol/rol.aspx" class="nav-link">Role</a>
                <a href="#" class="nav-link">Business Unit</a>
            </div>
            <a href="#" class="nav-link">Salir</a>
        </nav>

        <!-- Main Content -->
        <div class="main-content collapsed" id="mainContent">
            <div class="container py-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="mb-0 tituloRol">Role</h2>
                    <button type="button" class="btn btn-plus-custom" data-bs-toggle="modal" data-bs-target="#modalCrearRol">
                        <i class="bi bi-plus-lg"></i>
                    </button>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row g-2">
                            <div class="col-md-4">
                            <asp:DropDownList ID="ddlFiltroStatus" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroStatus_SelectedIndexChanged">
                   <asp:ListItem Text="All" Value="" />
                   <asp:ListItem Text="Active" Value="1" />
                   <asp:ListItem Text="Inactive" Value="0" />
                   </asp:DropDownList>
                            </div>

                            <!-- Buscar -->
<div class="col-md-8">
    <div class="input-group">
        <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Search" />
        <asp:LinkButton ID="btnBuscar" runat="server" CssClass="btn btn-search-custom" OnClick="btnBuscar_Click" CausesValidation="false">
            <i class="bi bi-search"></i>
        </asp:LinkButton>
    </div>
</div>

                        </div>
                    </div>
                </div>

                <asp:GridView ID="gvRoles" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered text-center align-middle" HeaderStyle-CssClass="table-info">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="Role" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <a href="#"><i class="bi bi-pencil-square"></i></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <!-- Toast de éxito -->
            <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">
              <div id="toastSuccess" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                  <div class="toast-body">
                    ✅ Rol creado exitosamente.
                  </div>
                  <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Cerrar"></button>
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
        <div class="modal fade" id="modalCrearRol" tabindex="-1" aria-labelledby="modalCrearRolLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content modal-bg-custom">
                    <div class="modal-header modal-header-custom">
                        <h5 class="modal-title">Agregar Nuevo Rol</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="txtNombreRol" class="form-label">Nombre del Rol</label>
                            <asp:TextBox ID="txtNombreRol" runat="server" CssClass="form-control" placeholder="Ej. Supervisor" />
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
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" runat="server" class="btn btn-save-custom" onserverclick="btnGuardarRol_ServerClick">Guardar</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap Bundle (Bootstrap + Popper) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Scripts personalizados (antes del cierre del form) -->
        <script src="../../master/scripts.js"></script>
    </form>

  
</body>
</html>
