<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="businessUnit.aspx.cs" Inherits="trainingLink.UI.maintenance.maintenanceBusinessUnit.businessUnit" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Business Unit - TrainingLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />

    <!-- Estilos personalizados -->

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
          <a href="..\Home\home.aspx" class="nav-link">Inicio</a>
         <a href="#" class="nav-link">Usuarios</a>
         <a href="#" class="nav-link">Reportes</a>
         <a href="#submenuMantenimientos" class="nav-link dropdown-toggle" data-bs-toggle="collapse" role="button" aria-expanded="false">Mantenimientos</a>
         <div class="collapse ms-3" id="submenuMantenimientos">
             <a href="../maintenanceRol/rol.aspx" class="nav-link">Role</a>
             <a href="../maintenanceBusinessUnit/businessUnit.aspx" class="nav-link">Bussines Unit</a>

             <a href="../maintenanceArea/area.aspx" class="nav-link">Área</a>
         </div>
         <a href="#" class="nav-link">Salir</a>
     </nav>

        <!-- Main Content -->
        <div class="main-content collapsed" id="mainContent">
            <div class="container py-5">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="mb-0">Business Unit</h2>
                    <button type="button" class="btn btn-plus-custom" data-bs-toggle="modal" data-bs-target="#modalCrearBusinessUnit" onclick="prepararModalCrearBusinessUnit()">
                        <i class="bi bi-plus-lg"></i>
                    </button>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row g-2">
                            <div class="col-md-3">
                               
 <asp:DropDownList ID="ddlFiltroStatusBusinessUnit" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroStatus_SelectedIndexChanged">
    <asp:ListItem Text="Todos" Value="" />
    <asp:ListItem Text="Activo" Value="1" />
    <asp:ListItem Text="Inactivo" Value="0" />
</asp:DropDownList>



                               
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar por nombre o descripción" />
                            </div>
                            <div class="col-md-3">
<asp:Panel runat="server" DefaultButton="btnBuscar">
    <div class="input-group">
        <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" placeholder="Search" />
        <asp:LinkButton ID="btnBuscar" runat="server" CssClass="btn btn-search-custom" OnClick="btnBuscar_Click" CausesValidation="false">
            <i class="bi bi-search"></i>
        </asp:LinkButton>
    </div>
</asp:Panel>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- GridView -->
                <asp:GridView ID="gvBusinessUnit" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered text-center align-middle">
                    <Columns>
                        <asp:BoundField DataField="Name" HeaderText="Nombre" SortExpression="Name" />
                        <asp:BoundField DataField="Status" HeaderText="Estado" SortExpression="Status" />
                        <asp:TemplateField HeaderText="Acciones">

                            <ItemTemplate>
                                <a href="javascript:void(0);" onclick='abrirModalEditar("<%# Eval("IdBusinessUnit") %>", "<%# Eval("Name") %>", "<%# Eval("Status") %>")'>
                                    <i class="bi bi-pencil-square"></i>
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>


        <!-- Modal -->
        <div class="modal fade" id="modalCrearBusinessUnit" tabindex="-1" aria-labelledby="modalCrearBusinessUnitLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalCrearBusinessUnitLabel">Agregar Nueva Business Unit</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <!-- HiddenField para almacenar el IdBusinessUnit -->
                        <asp:HiddenField ID="hdnIdBusinessUnit" runat="server" />

                        <div class="mb-3">
                            <label for="txtNombreBusinessUnit" class="form-label">Nombre</label>
                            <asp:TextBox ID="txtNombreBusinessUnit" runat="server" CssClass="form-control" />
                        </div>
                     
                        <div class="mb-3">
                            <label for="ddlEstadoBusinessUnit" class="form-label">Estado</label>
                            <asp:DropDownList ID="ddlEstadoBusinessUnit" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Activo" Value="1" />
                                <asp:ListItem Text="Inactivo" Value="0" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnGuardarBusinessUnit" runat="server" CssClass="btn btn-primary" Text="Guardar" OnClick="btnGuardarBusinessUnit_ServerClick" />
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="../../master/scripts.js"></script>

 <script>
     window.onload = function () {
         document.getElementById("<%= txtNombreBusinessUnit.ClientID %>").value = "";
        document.getElementById("<%= ddlEstadoBusinessUnit.ClientID %>").value = "1";
        document.getElementById("<%= btnGuardarBusinessUnit.ClientID %>").value = "Guardar";
        
        // Retrieve HiddenField value
        var idBusinessUnit = document.getElementById("<%= hdnIdBusinessUnit.ClientID %>").value;
         console.log(idBusinessUnit); // You can log or use this variable as needed
     };
 </script>

    </form>
</body>
</html>
