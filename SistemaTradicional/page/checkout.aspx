<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="checkout.aspx.cs" Inherits="SistemaTradicional.page.checkout" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <!-- Mismo head -->
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>International House Cusco - Check-out</title>
    <link rel="stylesheet" href="../estilos.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Misma cabecera -->
        <header class="navbar">
            <div class="navbar-left">
                <a href="../index.aspx" class="navbar-logo">
                    <img src="../img/logo.jpg" alt="International House Cusco Logo">
                </a>
                <nav class="navbar-nav">
                    <ul>
                        <li><a href="home.aspx">Inicio</a></li>
                        <li><a href="proceso.aspx">Proceso</a></li>
                        <li><a href="#">Reportes/Registros</a></li>
                    </ul>
                </nav>
            </div>
            <div class="navbar-right">
                <a href="#" class="btn-salir">Salir</a>
            </div>
        </header>

        <div class="main-container">
            <!-- Mismo sidebar (cambiando la clase active) -->
            <aside class="sidebar">
                <nav class="sidebar-nav">
                    <ul>
                        <li><a href="proceso.aspx" class="sidebar-item"><i class="fa-solid fa-hotel"></i> Listar Habitaciones</a></li>
                        <li><a href="checkin.aspx" class="sidebar-item"><i class="fa-solid fa-door-open"></i> Check-in</a></li>
                        <li><a href="checkout.aspx" class="sidebar-item active"><i class="fa-solid fa-door-closed"></i> Check-out</a></li>
                    </ul>
                </nav>
            </aside>

            <!-- Contenido específico de Check-out -->
            <main class="content-area">
                <section class="content-section active">
                    <h2>Realizar Check-out</h2>
                    <!-- Todo el contenido del check-out original -->
                    <asp:GridView ID="gvHabitaciones" runat="server" CssClass="data-grid" AutoGenerateColumns="False">
                        <Columns>
                            <asp:BoundField DataField="Hab_NumeroHabitacion" HeaderText="N° Hab." />
                            <asp:BoundField DataField="Hab_NombreTipo" HeaderText="Tipo" />
                            <asp:BoundField DataField="Hab_Capacidad" HeaderText="Cap." />
                            <asp:BoundField DataField="Hab_Estado" HeaderText="Estado" />
                            <asp:BoundField DataField="Hab_TarifaBase" HeaderText="Precio/Noche" DataFormatString="{0:C}" />
                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>
                                    <asp:Button ID="btnVerDetalles" runat="server" Text="Ver" CssClass="boton-secundario" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </section>
            </main>
        </div>
    </form>
</body>
</html>