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
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />
    <div class="main-content container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0">Registro de Entrenamientos</h2>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalRegistroEntrenamiento">
                <i class="bi bi-plus-lg"></i> Nuevo Entrenamiento
            </button>
        </div>

        <!-- Aquí iría el GridView o tabla de entrenamientos -->

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
                                    <asp:ListItem Text="Activo" Value="1" />
                                    <asp:ListItem Text="Completo" Value="2" />
                                    <asp:ListItem Text="Incompleto" Value="0" />
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnGuardarEntrenamiento" runat="server" CssClass="btn btn-primary" Text="Guardar" OnClick="btnGuardarEntrenamiento_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../master/scripts.js"></script>
</form>
</body>
</html>
