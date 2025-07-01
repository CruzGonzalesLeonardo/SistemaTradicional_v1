<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="home.aspx.cs" Inherits="SistemaTradicional.page.home" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>International House Cusco - Dashboard</title>
    <link rel="stylesheet" href="../estilos.css"> 
    </head>
<body>
    <form id="form1" runat="server">
        <header class="navbar">
            <div class="navbar-left">
                <a href="../index.aspx" class="navbar-logo">
                    <img src="../img/logo.jpg" alt="International House Cusco Logo" style="height: 48px; width: 50px">
                </a>
                <nav class="navbar-nav">
                    <ul>
                        <li><a href="home.aspx" class="active">Inicio</a></li>
                        <li><a href="proceso.aspx">Proceso</a></li>
                </nav>
            </div>
            <div class="navbar-right">
                <a href="#" class="btn-salir">Salir</a> </div>
        </header>

        <main class="content-wrapper">
            <section class="info-general-hotel">
                <h2>Estado General del Hotel</h2>
                <div class="grid-info">
                    <div class="info-card">
                        <h3>Habitaciones Libres</h3>
                        <p class="data-number"> <asp:Label Text="--" ID="lblHlibres" runat="server" /></p> <i class="icon-bed"></i> </div>
                    <div class="info-card">
                        <h3>Habitaciones Ocupadas</h3>
                        <p class="data-number"> <asp:Label Text="--" ID="lblOcupadas" runat="server" /></p> <i class="icon-user"></i>
                    </div>
                    <div class="info-card">
                        <h3>Habitaciones Reservadas</h3>
                        <p class="data-number"> <asp:Label Text="--" ID="lblReservadas" runat="server" /></p> <i class="icon-calendar"></i>
                    </div>
                </div>

                <div class="date-time-card">
                    <h3>Fecha y Hora Actual</h3>
                    <p class="data-datetime"><span id="currentDate"></span> - <span id="currentTime"></span></p>
                    <p class="location">Cusco, Perú</p>
                </div>

                </section>
        </main>

        <footer>
            <p>&copy; 2025 International House Cusco. Todos los derechos reservados.</p>
        </footer>
    </form>

    <script>
        // Script para actualizar la fecha y hora
        function updateDateTime() {
            const now = new Date();
            const optionsDate = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            const optionsTime = { hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true };

            document.getElementById('currentDate').textContent = now.toLocaleDateString('es-ES', optionsDate);
            document.getElementById('currentTime').textContent = now.toLocaleTimeString('es-ES', optionsTime);
        }

        // Actualizar cada segundo
        setInterval(updateDateTime, 1000);
        // Llamar una vez al cargar para mostrarla inmediatamente
        updateDateTime();
    </script>
</body>
</html>