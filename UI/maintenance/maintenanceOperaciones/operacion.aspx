﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="operacion.aspx.cs" Inherits="trainingLink.UI.maintenance.maintenanceOperacion.operacion" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Operación - TrainingLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
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
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />

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

            <!-- Botón Salir al fondo -->
            <div class="mt-auto p-3">
                <asp:Button ID="btnSalir" runat="server" CssClass="btn-plus-custom btn-sm w-100 d-flex align-items-center justify-content-center gap-2" Text="Salir" OnClick="btnSalir_Click" UseSubmitBehavior="false" />
            </div>
        </nav>


    <div class="main-content collapsed" id="mainContent">
        <div class="container py-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0">Operaciones</h2>
                <button type="button" class="btn btn-plus-custom" data-bs-toggle="modal" data-bs-target="#modalCrearOperacion" onclick="prepararModalCrearOperacion()">
                    <i class="bi bi-plus-lg"></i>
                </button>
            </div>
<div class="card mb-4">
    <div class="card-body">
<div class="d-flex gap-2 align-items-center mb-3">
    <!-- Filtro de estado -->
<asp:DropDownList ID="ddlFiltroStatus" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroStatus_SelectedIndexChanged">
    <asp:ListItem Text="Todos" Value=""></asp:ListItem>
    <asp:ListItem Text="Activo" Value="1"></asp:ListItem>
    <asp:ListItem Text="Inactivo" Value="0"></asp:ListItem>
</asp:DropDownList>


    <!-- Campo de búsqueda -->
<asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar por nombre..."></asp:TextBox>
    <!-- Botón de búsqueda -->
  <asp:LinkButton ID="btnBuscar" runat="server" CssClass="btn btn-primary" OnClick="btnBuscar_Click">
    <i class="bi bi-search"></i>
</asp:LinkButton>
</div>

    </div>
</div>


            <asp:GridView ID="gvOperacion" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered text-center align-middle" HeaderStyle-CssClass="table-info">
                <Columns>
                    <asp:BoundField DataField="Name" HeaderText="Nombre" />
                    <asp:BoundField DataField="OutputTarget" HeaderText="Output Target" />
                    <asp:BoundField DataField="YieldTarget" HeaderText="Yield Target" />
                    <asp:BoundField DataField="OutputTargetTraining" HeaderText="Output Target Training" />
                    <asp:BoundField DataField="LeadTime" HeaderText="Lead Time" />
                    <asp:BoundField DataField="NumberDays" HeaderText="Días" />
                    <asp:BoundField DataField="Area" HeaderText="Área" />
                    <asp:TemplateField HeaderText="Estado">
                        <ItemTemplate>
                            <%# Convert.ToBoolean(Eval("Status")) ? "Activo" : "Inactivo" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                  <asp:TemplateField HeaderText="Acciones">
    <ItemTemplate>
      <a href="javascript:void(0);" 
   onclick='<%# Eval("ScriptEditCall") %>'>
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
    </div>

    <!-- Modal -->
    <!-- Modal Crear Operación -->
<div class="modal fade" id="modalCrearOperacion" tabindex="-1" aria-labelledby="modalCrearOperacionLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalCrearOperacionLabel">Agregar Operación</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <asp:HiddenField ID="hdnIdOperacion" runat="server" />
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtNombreOperacion" class="form-label">Nombre</label>
                        <asp:TextBox ID="txtNombreOperacion" runat="server" CssClass="form-control" ClientIDMode="Static" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="ddlAreaOperacion" class="form-label">Área</label>
                        <asp:DropDownList ID="ddlAreaOperacion" runat="server" CssClass="form-select" ClientIDMode="Static" />
                    </div>
                    <div class="col-md-6 mb-3">
    <label for="ddlUnidadNegocio" class="form-label">Unidad de Negocio</label>
<asp:DropDownList ID="ddlUnidadNegocio" runat="server" CssClass="form-select" ClientIDMode="Static"/>
</div>


                    <div class="col-md-4 mb-3">
                        <label for="txtOutputTarget" class="form-label">Output Target</label>
                        <asp:TextBox ID="txtOutputTarget" runat="server" CssClass="form-control" TextMode="Number" ClientIDMode="Static" />
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="txtYieldTarget" class="form-label">Yield Target</label>
<asp:TextBox ID="txtYieldTarget" runat="server" CssClass="form-control" TextMode="Number" ClientIDMode="Static" />                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="txtOutputTargetTraining" class="form-label">Output Target Training</label>
                        <asp:TextBox ID="txtOutputTargetTraining" runat="server" CssClass="form-control" TextMode="Number" ClientIDMode="Static" />
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="txtPercentOutput" class="form-label">% Output</label>
<asp:TextBox ID="txtPercentOutput" runat="server" CssClass="form-control" TextMode="Number" ClientIDMode="Static" />                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="txtPercentYieldTarget" class="form-label">% Yield Target</label>
<asp:TextBox ID="txtPercentYieldTarget" runat="server" CssClass="form-control" TextMode="Number" ClientIDMode="Static" />                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="txtLeadTime" class="form-label">Lead Time</label>
<asp:TextBox ID="txtLeadTime" runat="server" CssClass="form-control" TextMode="Number" ClientIDMode="Static" />                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <label for="ddlEstadoOperacion" class="form-label">Estado</label>
                       <asp:DropDownList ID="ddlEstadoOperacion" runat="server" CssClass="form-select" ClientIDMode="Static">
    <asp:ListItem Text="Activo" Value="1" />
    <asp:ListItem Text="Inactivo" Value="0" />
</asp:DropDownList>
                    </div>
                </div>
                  <div class="modal-header">
            <h5 class="modal-title" id="cuvaAprendizaje">Curva de Aprendizaje</h5>
</div>
            
                                    <div class="col-md-6 mb-3">
                        <label for="txtNumberDays" class="form-label">Número de Días</label>
<asp:TextBox ID="txtNumberDays" runat="server" CssClass="form-control" 
    TextMode="Number" ClientIDMode="Static" oninput="generarCamposCurva()" />
            </div>

                <div class="mb-3">
        <label class="form-label"></label>
        <div id="contenedorCurvaEntrenamiento" class="row g-2"></div>
    </div>






            <div class="modal-footer">
                <div id="btnEliminarContainerOperacion" class="me-auto" style="display:none">
                    <asp:Button ID="btnEliminarOperacion" runat="server" CssClass="btn btn-delete-custom" Text="Eliminar"
                        OnClientClick="return confirm('¿Estás seguro de que deseas eliminar esta operación?');"
                        OnClick="btnEliminarOperacion_ServerClick" />
                </div>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
               <asp:Button ID="btnGuardarOperacion" runat="server" CssClass="btn btn-save-custom" Text="Guardar"
    OnClick="btnGuardarOperacion_ServerClick" OnClientClick="return validarOperacionAntesDeGuardar();" ClientIDMode="Static" />

            </div>
        </div>
    </div>
</div>

<!-- JQUERY -->
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

<!-- SELECT2 -->
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<!-- BOOTSTRAP -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- TU SCRIPT CENTRAL -->
<script src="../../master/scripts.js"></script>



</form>
    
</body>
</html>

