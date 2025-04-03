

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="trainingLink.UI.login.Login" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Login - TrainingLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="../master/styles.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header con logo -->
        <div class="custom-header">
            <img src="../../Files/images/logoPhilips.png" alt="Philips Logo" />
        </div>

        <!-- Círculos decorativos -->
        <div class="background-circles">
            <div class="circle circle1"></div>
            <div class="circle circle2"></div>
            <div class="circle circle3"></div>
        </div>

        <!-- Contenedor del login -->
<!-- Contenedor del login -->
<div class="login-container">
    <div class="login-box">
        <h5 class="text-left mb-4">Loggin</h5>
        
        <div class="mb-3">
            <label for="Code1">Code1:</label>
            <asp:TextBox ID="txtCode1" runat="server" CssClass="form-control" placeholder="Code1" />
        </div>
        
        <div class="mb-3">
            <label for="Password">Password:</label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password" />
        </div>
        
        <div class="mt-6">
            <asp:Button ID="btnLogin" runat="server" Text="Ingresar" CssClass="btn btn-login w-100" OnClick="btnLogin_Click" />
        </div>
    </div>
</div>


        <!-- Footer -->
        <div class="custom-footer">
            <div class="footer-text">
                <strong>TrainingLink</strong><br />
                Sistema de Gestión de Training
            </div>
        </div>
    </form>
</body>
</html>