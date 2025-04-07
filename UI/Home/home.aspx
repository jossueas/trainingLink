<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="home.aspx.cs" Inherits="trainingLink.UI.Home.Home" %>









<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Inicio - TrainingLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="../master/styles.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Sidebar -->
        <div class="sidebar" id="sidebar">
            <div class="menu-header">Menú</div>
            <ul class="nav flex-column">
                <li class="nav-item"><a href="#" class="nav-link">Inicio</a></li>
                <li class="nav-item"><a href="#" class="nav-link">Módulos</a></li>
                <li class="nav-item"><a href="#" class="nav-link">Reportes</a></li>
                <li class="nav-item"><a href="#" class="nav-link">Salir</a></li>
            </ul>
        </div>

        <!-- Contenedor principal -->
        <div class="main-content">
            <!-- Header -->
            <header class="home-header d-flex justify-content-between align-items-center px-4 py-2">
                <div class="logo-container d-flex align-items-center">
                    <img src="../../Files/images/logoPhilips.png" alt="Philips Logo" class="logo" />
                </div>
                <div class="menu-toggle" onclick="toggleSidebar()">☰</div>
            </header>

            <!-- Contenido principal -->
            <main class="home-content container py-5">
                <h1>Bienvenido a <span class="accent">TrainingLink</span></h1>
                <p>Seleccione una opción del menú para comenzar</p>
            </main>

            <!-- Footer -->
            <footer class="custom-footer text-end px-4 py-3">
                <div>
                    <strong>TrainingLink</strong><br />
                    Sistema de Gestión de Training
                </div>
            </footer>
        </div>
    </form>

    <script>
        function toggleSidebar() {
            var sidebar = document.getElementById("sidebar");
            sidebar.classList.toggle("collapsed");
        }
    </script>
</body>
</html>
