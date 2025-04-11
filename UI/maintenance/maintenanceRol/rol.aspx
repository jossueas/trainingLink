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
    
    <!-- Tu hoja de estilos -->
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
                    <h2 class="mb-0 tituloRol" >Role</h2>

                    <!--btn + -->
<button type="button" class="btn btn-plus-custom" data-bs-toggle="modal" data-bs-target="#modalCrearRol">
    <i class="bi bi-plus-lg"></i>
</button>




                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row g-2">
                            <div class="col-md-4">
                                <select class="form-select">
                                    <option>Status</option>
                                    <option>Active</option>
                                    <option>Inactive</option>
                                </select>
                            </div>
                           <div class="col-md-8">
    <div class="input-group">
        <input type="search" class="form-control" placeholder="Search" aria-label="Search" />
        <button class="btn btn-search-custom" type="submit">
            <i class="bi bi-search"></i>
        </button>
    </div>
</div>
                        </div>
                    </div>
                </div>

                <table class="table table-bordered text-center align-middle">
                    <thead class="table-info">
                        <tr>
                            <th>Role</th>
                            <th>Description</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Administrator</td>
                            <td>Admin</td>
                            <td><a href="#"><i class="bi bi-pencil-square"></i></a></td>
                        </tr>
                        <tr>
                            <td>Supervisor</td>
                            <td>Area Supervisor</td>
                            <td><a href="#"><i class="bi bi-pencil-square"></i></a></td>
                        </tr>
                        <tr>
                            <td>Manufacturing Engineering</td>
                            <td>Rol for manufacturing</td>
                            <td><a href="#"><i class="bi bi-pencil-square"></i></a></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Footer -->
            <footer class="custom-footer">
                <strong>TrainingLink</strong><br />
                Sistema de Gestión de Training
            </footer>
        </div>


<!-- Modal para crear rol -->
<div class="modal fade" id="modalCrearRol" tabindex="-1" aria-labelledby="modalCrearRolLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content modal-bg-custom"> <!-- <- Añadido este div para controlar css del body footer del modal -->

      <div class="modal-header modal-header-custom">
        <h5 class="modal-title">Agregar Nuevo Rol</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>

      <div class="modal-body">
        <div class="mb-3">
          <label for="txtNombreRol" class="form-label">Nombre del Rol</label>
          <input type="text" class="form-control" id="txtNombreRol" placeholder="Ej. Supervisor" />
        </div>
        <div class="mb-3">
          <label for="txtDescripcionRol" class="form-label">Descripción</label>
          <input type="text" class="form-control" id="txtDescripcionRol" placeholder="Descripción del rol" />
        </div>
        <div class="mb-3">
          <label for="ddlEstadoRol" class="form-label">Estado</label>
          <select class="form-select" id="ddlEstadoRol">
            <option value="1">Activo</option>
            <option value="0">Inactivo</option>
          </select>
        </div>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-save-custom">Guardar</button>
      </div>

    </div>
  </div>
</div>


    </form>




    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function toggleSidebar() {
            const sidebar = document.getElementById("sidebar");
            const mainContent = document.getElementById("mainContent");
            sidebar.classList.toggle("collapsed");
            mainContent.classList.toggle("collapsed");
        }
    </script>
</body>
</html>
