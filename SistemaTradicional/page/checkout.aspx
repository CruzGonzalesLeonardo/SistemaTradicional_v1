<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="checkout.aspx.cs" Inherits="SistemaTradicional.page.checkout" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>International House Cusco - Check-out</title>
    <link rel="stylesheet" href="../estilos.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>
    <style>
        /* Estilos para el modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 60%;
            max-width: 800px;
            border-radius: 5px;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        .modal-header h3 {
            margin: 0;
        }

        .close-modal {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close-modal:hover {
            color: black;
        }

        .modal-body {
            margin-bottom: 20px;
        }

        .info-section {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 5px;
        }

        .info-section h4 {
            margin-top: 0;
            color: #333;
            border-bottom: 1px solid #ddd;
            padding-bottom: 5px;
        }

        .info-row {
            display: flex;
            margin-bottom: 8px;
        }

        .info-label {
            font-weight: bold;
            width: 120px;
        }

        .info-value {
            flex: 1;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            border-top: 1px solid #ddd;
            padding-top: 15px;
        }

        .modal-footer button {
            margin-left: 10px;
        }

        /* Estilos para el GridView */
        .data-grid {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
        }

        .data-grid th {
            background-color: #507CD1;
            color: white;
            font-weight: bold;
            padding: 8px;
            text-align: left;
        }

        .data-grid td {
            padding: 8px;
            border-bottom: 1px solid #ddd;
        }

        .data-grid tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .data-grid tr:hover {
            background-color: #e6f2ff;
        }

        .data-grid .selected-row {
            background-color: #D1EDF7 !important;
        }

        /* Estilos para botones */
        .btn-primario {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-primario:hover {
            background-color: #0069d9;
        }

        .btn-secundario {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-secundario:hover {
            background-color: #5a6268;
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
                        <li><a href="proceso.aspx">Proceso</a></li>
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
                        <li><a href="reservas.aspx" class="sidebar-item"><i class="fa-solid fa-calendar-check"></i> Reservaciones</a></li>
                        <li><a href="checkin.aspx" class="sidebar-item"><i class="fa-solid fa-door-open"></i> Check-in</a></li>
                        <li><a href="checkout.aspx" class="sidebar-item active"><i class="fa-solid fa-door-closed"></i> Check-out</a></li>
                    </ul>
                </nav>
            </aside>

            <main class="content-area">
                <section class="content-section active">
                    <h2>Habitaciones Ocupadas</h2>
                    <asp:GridView ID="gvHabitaciones" runat="server" CssClass="data-grid" AutoGenerateColumns="False" 
                        OnSelectedIndexChanged="gvHabitaciones_SelectedIndexChanged" DataKeyNames="IdReserva"
                        AutoGenerateSelectButton="True">
                        <Columns>
                            <asp:BoundField DataField="IdReserva" HeaderText="Reserva" />
                            <asp:BoundField DataField="Hab_NumeroHabitacion" HeaderText="Habitación" />
                            <asp:BoundField DataField="Res_FechaSalida" HeaderText="Fecha Salida" DataFormatString="{0:d}" />
                            <asp:BoundField DataField="H_NombreCompleto" HeaderText="Huésped" />
                        </Columns>
                        <SelectedRowStyle BackColor="#D1EDF7" ForeColor="#333333" />
                        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <RowStyle BackColor="#EFF3FB" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:GridView>
                </section>
            </main>
        </div>

        <!-- Modal para Check-out -->
        <div id="modalCheckout" class="modal" runat="server" visible="false">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Proceso de Check-out</h3>
                    <span class="close-modal" onclick="cerrarModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <!-- Información de la reserva -->
                    <div class="info-section">
                        <h4>Información de la Reserva</h4>
                        <div class="info-row">
                            <span class="info-label">Reserva ID:</span>
                            <asp:Label ID="lblReservaId" runat="server" CssClass="info-value"></asp:Label>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Habitación:</span>
                            <asp:Label ID="lblHabitacionNumero" runat="server" CssClass="info-value"></asp:Label>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Fecha Salida:</span>
                            <asp:Label ID="lblFechaSalida" runat="server" CssClass="info-value"></asp:Label>
                        </div>
                    </div>

                    <!-- Información del huésped -->
                    <div class="info-section">
                        <h4>Información del Huésped</h4>
                        <div class="info-row">
                            <span class="info-label">Nombre:</span>
                            <asp:Label ID="lblHuespedNombre" runat="server" CssClass="info-value"></asp:Label>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Documento:</span>
                            <asp:Label ID="lblHuespedDocumento" runat="server" CssClass="info-value"></asp:Label>
                        </div>
                    </div>

                    <!-- Opciones de check-out -->
                    <div class="info-section">
                        <h4>Acciones</h4>
                        <div class="form-group">
                            <asp:DropDownList ID="ddlAccionCheckout" runat="server" CssClass="input-field">
                                <asp:ListItem Text="Confirmar salida normal" Value="Normal"></asp:ListItem>
                                <asp:ListItem Text="Confirmar cancelación" Value="Cancelacion"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>Notas adicionales:</label>
                            <asp:TextBox ID="txtNotasCheckout" runat="server" CssClass="input-field" TextMode="MultiLine" Rows="3"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnConfirmarCheckout" runat="server" Text="Confirmar" CssClass="btn-primario" OnClick="btnConfirmarCheckout_Click" />
                    <button type="button" class="btn-secundario" onclick="cerrarModal()">Cancelar</button>
                </div>
            </div>
        </div>

        <!-- Script para manejar el modal -->
        <script type="text/javascript">
            function mostrarModal() {
                document.getElementById('<%= modalCheckout.ClientID %>').style.display = 'block';
            }

            function cerrarModal() {
                document.getElementById('<%= modalCheckout.ClientID %>').style.display = 'none';
            }
        </script>
    </form>
</body>
</html>