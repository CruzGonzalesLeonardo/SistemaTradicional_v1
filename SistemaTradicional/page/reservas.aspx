<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="reservas.aspx.cs" Inherits="SistemaTradicional.page.reservas" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>International House Cusco - Listado Habitaciones</title>
    <link rel="stylesheet" href="../estilos.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>
    <style>
        /* New styles for the two-panel layout */
        .content-flex-container {
            display: flex;
            gap: 20px; /* Space between the two panels */
            margin-top: 20px;
        }

        .panel-left, .panel-right {
            flex: 1; /* Both panels take equal width */
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background: #f9f9f9;
        }

        .panel-right {
            display: flex;
            flex-direction: column;
            gap: 10px; /* Space between info rows */
        }

        .info-row {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
        }

        .info-row label {
            font-weight: bold;
            min-width: 120px; /* Align labels */
            margin-right: 10px;
        }
        
        .action-buttons-bottom {
            margin-top: 30px;
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .boton-primario, .boton-secundario {
            padding: 8px 15px;
            margin-left: 10px;
            cursor: pointer;
            border-radius: 4px;
            font-size: 1em;
        }

        .boton-primario {
            background-color: #4CAF50;
            color: white;
            border: none;
        }

        .boton-secundario {
            background-color: #f44336;
            color: white;
            border: none;
        }

        .data-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .data-grid th, .data-grid td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        .data-grid th {
            background-color: #f2f2f2;
            font-weight: bold;
        }

        .data-grid tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .data-grid tr:hover {
            background-color: #e6e6e6;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <header class="navbar">
            <div class="navbar-left">
                <a href="../index.aspx" class="navbar-logo">
                    <img src="../img/logo.jpg" alt="International House Cusco Logo">
                </a>
                <nav class="navbar-nav">
                    <ul>
                        <li><a href="home.aspx">Inicio</a></li>
                        <li><a href="proceso.aspx" class="active">Proceso</a></li>
                    </ul>
                </nav>
            </div>
            <div class="navbar-right">
                <a href="#" class="btn-salir">Salir</a>
            </div>
        </header>

        <div class="main-container">
            <aside class="sidebar">
                <nav class="sidebar-nav">
                    <ul>
                        <li><a href="proceso.aspx" class="sidebar-item"><i class="fa-solid fa-hotel"></i> Listar Habitaciones</a></li>
                        <li><a href="reservas.aspx" class="sidebar-item active"><i class="fa-solid fa-calendar-check"></i> Reservaciones</a></li> 
                        <%-- Changed from proceso.aspx to reservaciones.aspx if this page is specifically for reservations --%>
                        <li><a href="checkin.aspx" class="sidebar-item"><i class="fa-solid fa-door-open"></i> Check-in</a></li>
                        <li><a href="checkout.aspx" class="sidebar-item"><i class="fa-solid fa-door-closed"></i> Check-out</a></li>
                    </ul>
                </nav>
            </aside>

            <main class="content-area">
                <section class="content-section active">
                    <h2>Gestión de Reservaciones</h2> 
                    <%-- Changed title to reflect the new purpose --%>

                    <div class="content-flex-container">
                        <%-- Left Panel: Reservations List --%>
                        <div class="panel-left">
                            <h3>Próximas Reservaciones</h3>
                            <asp:GridView ID="gvReservaciones" runat="server" CssClass="data-grid" AutoGenerateColumns="False" 
                                OnSelectedIndexChanged="gvReservaciones_SelectedIndexChanged" AutoGenerateSelectButton="True" >
                                <Columns>
                                    <%-- Assuming 'Hab_NumeroHabitacion' and 'Res_FechaLlegada' are relevant fields --%>
                                    <asp:BoundField DataField="IdReserva" HeaderText="Reserva" />
                                    <asp:BoundField DataField="Hab_NumeroHabitacion" HeaderText="Habitación" />
                                    <asp:BoundField DataField="Res_FechaLlegada" HeaderText="Fecha Inicio" DataFormatString="{0:d}" />
                                    <asp:BoundField DataField="H_NombreCompleto" HeaderText="Huésped" />
                                    <%-- You might add more fields like Res_FechaSalida, Res_EstadoReserva, etc. --%>
                                </Columns>
                                <SelectedRowStyle BackColor="#D1EDF7" ForeColor="#333333" />
                                <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                                <RowStyle BackColor="#EFF3FB" />
                                <AlternatingRowStyle BackColor="White" />
                            </asp:GridView>
                        </div>

                        <%-- Right Panel: Reservation Details --%>
                        <div class="panel-right">
                            <h3>Detalles de la Reserva Seleccionada</h3>
                            <h4>Información del Cliente</h4>
                            <div class="info-row">
                                <label>ID Huésped:</label>
                                <asp:Label ID="lblClienteID" runat="server" Text="-"></asp:Label>
                            </div>
                            <div class="info-row">
                                <label>Nombre:</label>
                                <asp:Label ID="lblClienteNombre" runat="server" Text="-"></asp:Label>
                            </div>
                            <div class="info-row">
                                <label>Email:</label>
                                <asp:Label ID="lblClienteEmail" runat="server" Text="-"></asp:Label>
                            </div>
                            <div class="info-row">
                                <label>Teléfono:</label>
                                <asp:Label ID="lblClienteTelefono" runat="server" Text="-"></asp:Label>
                            </div>

                            <h4 style="margin-top: 20px;">Información de la Reserva</h4>
                            <div class="info-row">
                                <label>ID Reserva:</label>
                                <asp:Label ID="lblReservaID" runat="server" Text="-"></asp:Label>
                            </div>
                            <div class="info-row">
                                <label>Habitación:</label>
                                <asp:Label ID="lblReservaHabitacion" runat="server" Text="-"></asp:Label>
                            </div>
                            <div class="info-row">
                                <label>Llegada:</label>
                                <asp:Label ID="lblFechaLlegada" runat="server" Text="-"></asp:Label>
                            </div>
                            <div class="info-row">
                                <label>Salida:</label>
                                <asp:Label ID="lblFechaSalida" runat="server" Text="-"></asp:Label>
                            </div>
                             <div class="info-row">
                                <label>Noches:</label>
                                <asp:Label ID="lblNoches" runat="server" Text="-"></asp:Label>
                            </div>
                            <div class="info-row">
                                <label>Total:</label>
                                <asp:Label ID="lblTotalReserva" runat="server" Text="-"></asp:Label>
                            </div>
                            <div class="info-row">
                                <label>Estado Actual:</label>
                                <asp:Label ID="lblEstadoReservaActual" runat="server" Text="-"></asp:Label>
                            </div>
                            <div class="info-row">
                                <label for="<%= ddlCambiarEstadoReserva.ClientID %>">Cambiar Estado:</label>
                                <asp:DropDownList ID="ddlCambiarEstadoReserva" runat="server" CssClass="input-field">
                                    <asp:ListItem Text="Confirmada" Value="Confirmar"></asp:ListItem>
                                    <asp:ListItem Text="Cancelada" Value="Cancelar"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>

                    <%-- Action Buttons at the bottom --%>
                    <div class="action-buttons-bottom">
                        <asp:Button ID="btnGuardarCambiosReserva" runat="server" Text="Guardar Cambios" 
                            CssClass="boton-primario" OnClick="btnGuardarCambiosReserva_Click" />
                        <asp:Button ID="btnCancelarSeleccion" runat="server" Text="Cancelar" 
                            CssClass="boton-secundario" OnClick="btnCancelarSeleccion_Click" />
                    </div>

                </section>
            </main>
        </div>
    </form>
</body>
</html>
