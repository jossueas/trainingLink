<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="registroEntrenamiento.aspx.cs" Inherits="trainingLink.UI.master.registroEntrenamiento" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Registro de Entrenamiento - TrainingLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" />
    <link href="../master/styles.css" rel="stylesheet" />
 

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
         <a href="../maintenanceTurno/turno.aspx" class="nav-link">Turno</a>
          <a href="../maintenanceMuda/muda.aspx" class="nav-link">Muda</a>
         <a href="../maintenanceArea/area.aspx" class="nav-link">Área</a>
           <a href="../maintenanceScrap/scrap.aspx" class="nav-link active">Scrap</a>
     </div>
     <a href="#" class="nav-link">Salir</a>
 </nav>
    
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
    <div class="main-content container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0">Registro de Entrenamientos</h2>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalRegistroEntrenamiento">
                <i class="bi bi-plus-lg"></i> Nuevo Entrenamiento
            </button>
        </div>

        <!-- Aquí iría el GridView o tabla de entrenamientos -->

          <!-- Main Content -->
  <div class="main-content collapsed" id="mainContent">

      <div class ="container py-5">
<div class="row mb-3">
    <div class="col-md-3"> 
        <label for="ddlFiltroEstado"  class="form-label label-turquesa">Estado</label>
       <asp:DropDownList ID="ddlFiltroEstado" runat="server" CssClass="form-select">
    <asp:ListItem Text="Todos" Value="" />
    <asp:ListItem Text="Activo" Value="1" />
    <asp:ListItem Text="Completo" Value="2" />
    <asp:ListItem Text="Incompleto" Value="3" />
</asp:DropDownList>

    </div>

    <div class="col-md-4">
        <label for="ddlFiltroColaborador" class="form-label label-turquesa">Colaborador</label>
        <asp:DropDownList ID="ddlFiltroColaborador" runat="server" CssClass="form-select" />
    </div>

    <div class="col-md-4">
        <label for="ddlFiltroEntrenador" class="form-label label-turquesa">Entrenador</label>
        <asp:DropDownList ID="ddlFiltroEntrenador" runat="server" CssClass="form-select" />
    </div>

    <div class="col-md-1 d-flex align-items-end">
        <asp:LinkButton ID="btnBuscarEntrenamiento" runat="server" CssClass="btn btn-primary w-100" OnClick="btnBuscarEntrenamiento_Click">
            <i class="bi bi-search"></i>
        </asp:LinkButton>
    </div>
</div>





      
<asp:GridView ID="gvEntrenamientos" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered text-center align-middle" HeaderStyle-CssClass="table-info" Visible="true">
    <Columns>
        <asp:BoundField DataField="NombreColaborador" HeaderText="Colaborador" />
        <asp:BoundField DataField="NombreOperacion" HeaderText="Operación" />
        <asp:BoundField DataField="NombreEntrenador" HeaderText="Entrenador" />
        <asp:BoundField DataField="NombreTurno" HeaderText="Turno" />
        <asp:BoundField DataField="FechaInicio" HeaderText="Fecha Inicio" DataFormatString="{0:yyyy-MM-dd}" />
        <asp:BoundField DataField="FechaFinal" HeaderText="Fecha Final" DataFormatString="{0:yyyy-MM-dd}" />
        <asp:BoundField DataField="TipoEntrenamiento" HeaderText="Tipo Entrenamiento" />
        <asp:BoundField DataField="TipoEntrenador" HeaderText="Tipo Entrenador" />
  <asp:TemplateField HeaderText="Estado">

<ItemTemplate>
    <%# Convert.ToInt32(Eval("Estado")) == 1 ? "Activo" :
        Convert.ToInt32(Eval("Estado")) == 2 ? "Completo" :
        Convert.ToInt32(Eval("Estado")) == 3 ? "Incompleto" : "Desconocido" %>
</ItemTemplate>



</asp:TemplateField>

        <asp:TemplateField HeaderText="Acciones">
            <ItemTemplate>
                <a href="javascript:void(0);" onclick='<%# Eval("ScriptEditCall") %>'>
                    <i class="bi bi-eye"></i>
                </a>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>


           



        <!-- Toast para éxito -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">
    <div id="toastSuccess" class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                ✅ Entrenamiento registrado exitosamente.
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Cerrar"></button>
        </div>
    </div>
</div>

          <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 9999;"></div>




              <!-- Footer -->
      <footer class="custom-footer">
          <strong>TrainingLink</strong><br />
          Sistema de Gestión de Training
      </footer>
  </div>
        



        <!-- Modal Registro Entrenamiento -->
        <div class="modal fade" id="modalRegistroEntrenamiento" tabindex="-1" aria-labelledby="modalRegistroEntrenamientoLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalRegistroEntrenamientoLabel">Registrar Entrenamiento</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Colaborador</label>
<asp:DropDownList ID="ddlColaborador" runat="server" CssClass="form-select" />                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Operación</label>
<asp:DropDownList ID="ddlOperacion" runat="server" CssClass="form-select" />                       </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Entrenador</label>
<asp:DropDownList ID="ddlEntrenador" runat="server" CssClass="form-select" />                         </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Turno</label>
<asp:DropDownList ID="ddlTurno" runat="server" CssClass="form-select" />                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Fecha Inicio</label>
                                <asp:TextBox ID="txtFechaInicio" runat="server" CssClass="form-control" TextMode="Date" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Fecha Final</label>
                                <asp:TextBox ID="txtFechaFinal" runat="server" CssClass="form-control" TextMode="Date" />
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Tipo de Entrenamiento</label>
<asp:DropDownList ID="ddlTipoEntrenamiento" runat="server" CssClass="form-select" />                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Tipo de Entrenador</label>
<asp:DropDownList ID="ddlTipoEntrenador" runat="server" CssClass="form-select">
    <asp:ListItem Text="Trainer" Value="Trainer" />
    <asp:ListItem Text="Train the Trainer" Value="TrainTheTrainer" />
</asp:DropDownList>

                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Estado</label>
                                <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                                     <asp:ListItem Text=" " Value="0" />
                                    <asp:ListItem Text="Activo" Value="1" />
                                    <asp:ListItem Text="Completo" Value="2" />
                                    <asp:ListItem Text="Incompleto" Value="3" />
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnGuardarEntrenamiento" runat="server"
    CssClass="btn btn-save-custom"
    Text="Guardar"
    OnClick="btnGuardarEntrenamiento_Click"
    OnClientClick="return validarEntrenamientoAntesDeGuardar();" />

                    </div>
                </div>
            </div>
        </div>
    

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script src="../master/scripts.js"></script>

</form>

</body>
</html>
