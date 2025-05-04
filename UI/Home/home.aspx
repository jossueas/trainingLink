<!-- HTML (home.aspx) -->

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <meta charset="utf-8" />
    <title>Inicio - TrainingLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="../master/styles.css" rel="stylesheet" />
        <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />


 

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>





</head>
<body>
    <form id="form1" runat="server">
        <header class="custom-header">
            <button type="button" class="toggle-btn" onclick="toggleSidebar()">☰</button>
            <img src="../../Files/images/logoPhilips.png" alt="Philips Logo" class="logo" />
         <div class="header-icons d-flex gap-3">
        <a href="#" class="text-decoration-none text-dark">
            <i class="bi bi-person-circle fs-4"></i>
        </a>
        <a href="#" class="text-decoration-none text-dark">
            <i class="bi bi-gear-fill fs-4"></i>
        </a>
        </header>

        <!-- Sidebar -->
        <nav class="sidebar collapsed" id="sidebar">
            <a href="..\Home\home.aspx" class="nav-link">Inicio</a>
            <a href="#" class="nav-link">Registro Entrenamiento</a>
            <a href="#" class="nav-link">Reportes</a>
           <a href="#submenuMantenimientos" class="nav-link dropdown-toggle" data-bs-toggle="collapse" role="button" aria-expanded="false">
        Mantenimientos
    </a>
    <div class="collapse ms-3" id="submenuMantenimientos">
     <a href="..\maintenance\maintenanceRol\rol.aspx" class="nav-link">Role</a>
        <a href="..\maintenance\maintenanceBusinessUnit\businessUnit.aspx" class="nav-link">Bussines Unit</a>
       
        <a href="..\maintenance\maintenanceTurno\turno.aspx" class="nav-link">Turno</a>
         <a href="..\maintenance\maintenanceMuda\muda.aspx" class="nav-link">Muda</a>
        <a href="..\maintenance\maintenanceArea\area.aspx" class="nav-link">Area</a>
          <a href="..\maintenance\maintenanceScrap\scrap.aspx" class="nav-link active">Scrap</a>
          <a href="..\maintenance\maintenanceOperaciones\operacion.aspx" class="nav-link">Operación</a>
   
    </div>

    <a href="#" class="nav-link">Salir</a>
</nav>
         

        <!-- Main Content -->
        <div class="main-content collapsed" id="mainContent">
            <div class="container py-5">
                <h2 class="mb-4">Bienvenido a <span class="accent">TrainingLink</span></h2>
                <p>Seleccione una opción del menú para comenzar.</p>

                <div class="row">
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Usuarios</h5>
                                <p>Administra los usuarios registrados en el sistema.</p>
                                <a href="#" class="btn btn-primary">Ir</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Reportes</h5>
                                <p>Genera informes detallados de actividades.</p>
                                <a href="#" class="btn btn-primary">Ver Reportes</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Configuración</h5>
                                <p>Ajustes generales de la aplicación.</p>
                                <a href="#" class="btn btn-primary">Configurar</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <footer class="custom-footer">
                <strong>TrainingLink</strong><br />
                Sistema de Gestión de Training
            </footer>
        </div>
    </form>

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
