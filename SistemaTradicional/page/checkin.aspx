<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="checkin.aspx.cs" Inherits="SistemaTradicional.page.checkin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>International House Cusco - Check-in</title>
    <link rel="stylesheet" href="../estilos.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>
    <style>
        .boton-primario, .boton-secundario {
            padding: 8px 15px;
            margin-left: 10px;
            cursor: pointer;
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
        
        /* Estilos adicionales */
        .checkin-container {
            display: flex;
            gap: 20px;
            margin-top: 20px;
        }
        
        .panel {
            flex: 1;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background: #f9f9f9;
        }
        
        .panel h3 {
            margin-top: 0;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }
        
        .guest-info {
            margin-top: 20px;
        }
        
        .info-row {
            margin-bottom: 10px;
        }
        
        .info-row label {
            font-weight: bold;
            display: inline-block;
            width: 120px;
        }
        
        .search-box {
            margin-bottom: 15px;
        }
        
        .input-field {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
        }
        
        .boton-primario, .boton-secundario {
            padding: 8px 15px;
            margin-right: 10px;
            cursor: pointer;
        }
        
        #gvHuespedes {
            width: 100%;
            margin-top: 15px;
            display: none;
        }
        
        #gvHuespedes.visible {
            display: table;
        }
        
        .action-buttons {
            margin-top: 20px;
            text-align: center;
            padding: 20px;
            border-top: 1px solid #ddd;
        }
        
        /* Estilos para el modal */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.7);
            z-index: 1000;
        }
        
        .modal-content {
            background: white;
            width: 400px;
            padding: 20px;
            border-radius: 5px;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            box-shadow: 0 0 20px rgba(0,0,0,0.3);
        }
        
        .form-row {
            margin-bottom: 15px;
        }
        
        .form-row label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-actions {
            text-align: right;
            margin-top: 20px;
        }
        .data-grid {
            width: 100%;
            margin-top: 20px;
            border: 1px solid #ddd;
            border-collapse: collapse;
            background-color: white;
        }

        .data-grid th {
            background-color: #f2f2f2;
            padding: 10px;
            text-align: left;
            font-weight: bold;
        }

        .data-grid td {
            padding: 8px 10px;
            border-bottom: 1px solid #ddd;
        }

        .data-grid tr:hover {
            background-color: #f9f9f9;
        }

        .empty-row {
            text-align: center;
            color: #666;
            padding: 20px;
        }

        .boton-secundario {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 3px;
            cursor: pointer;
        }

        .boton-secundario:hover {
            background-color: #45a049;
        }
        
        /* Nuevos estilos para el contenedor principal */
        .main-checkin-content {
            display: flex;
            flex-direction: column;
        }
        
        .panels-container {
            display: flex;
            gap: 20px;
        }
        
        .buttons-container {
            margin-top: 20px;
            text-align: center;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 5px;
            border: 1px solid #ddd;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Cabecera común -->
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
            <aside class="sidebar">
                <nav class="sidebar-nav">
                    <ul>
                        <li><a href="proceso.aspx" class="sidebar-item"><i class="fa-solid fa-hotel"></i> Listar Habitaciones</a></li>
                        <li><a href="checkin.aspx" class="sidebar-item active"><i class="fa-solid fa-door-open"></i> Check-in</a></li>
                        <li><a href="checkout.aspx" class="sidebar-item"><i class="fa-solid fa-door-closed"></i> Check-out</a></li>
                    </ul>
                </nav>
            </aside>

            <!-- Contenido principal - Check-in -->
            <main class="content-area">
                <section class="content-section active">
                    <h2>Realizar Check-in</h2>
                    
                    <div class="main-checkin-content">
                        <div class="panels-container">
                            <!-- Panel izquierdo - Huésped -->
                            <div class="panel">
                                <h3>Información del Huésped</h3>
                                
                                <div class="search-box">
                                    <asp:TextBox ID="txtBuscarHuesped" runat="server" CssClass="input-field" 
                                        placeholder="Buscar por DNI o Nombre"></asp:TextBox>
                                    <asp:Button ID="btnBuscarHuesped" runat="server" Text="Buscar" 
                                        CssClass="boton-primario" OnClick="btnBuscarHuesped_Click" />
                                </div>
                                
                                <!-- GridView  resultados de búsqueda -->
                                <div>
                                    <asp:GridView ID="gvHuespedes" runat="server" AutoGenerateColumns="False" 
                                        CssClass="data-grid" OnRowCommand="gvHuespedes_RowCommand">
                                        <Columns>
                                            <asp:BoundField DataField="HuespedID" HeaderText="ID" />
                                            <asp:BoundField DataField="H_NombreCompleto" HeaderText="Nombre Completo" />
                                            <asp:TemplateField HeaderText="Acción">
                                                <ItemTemplate>
                                                    <asp:Button ID="btnSeleccionar" runat="server" Text="Seleccionar" 
                                                        CommandName="Seleccionar" 
                                                        CommandArgument='<%# Eval("HuespedID") %>'
                                                        CssClass="boton-secundario" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <div class="empty-row">
                                                No se encontraron huéspedes. Realice una búsqueda.
                                            </div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>                            </div>
                                <!-- Información del huésped seleccionado -->
                                <div class="guest-info">
                                    <div class="info-row">
                                        <label>ID:</label>
                                        <asp:Label ID="lblID" runat="server" Text="-" CssClass="info-value"></asp:Label>
                                    </div>
                                    <div class="info-row">
                                        <label>Nombre:</label>
                                        <asp:Label ID="lblNombreCompleto" runat="server" Text="-" CssClass="info-value"></asp:Label>
                                    </div>
                                    <div class="info-row">
                                        <label>Email:</label>
                                        <asp:Label ID="lblEmail" runat="server" Text="-" CssClass="info-value"></asp:Label>
                                    </div>
                                    <div class="info-row">
                                        <label>Teléfono:</label>
                                        <asp:Label ID="lblTelefono" runat="server" Text="-" CssClass="info-value"></asp:Label>
                                    </div>
                                </div>
                                
                                <!-- Botón Editar/Nuevo debajo de la información -->
                                <div style="margin-top: 20px;">
                                    <asp:Button ID="btnEditarHuesped" runat="server" Text="Editar" 
                                        CssClass="boton-secundario" OnClick="btnEditarHuesped_Click" Visible="false" />
                                    <asp:Button ID="btnNuevoHuesped" runat="server" Text="Nuevo" 
                                        CssClass="boton-secundario" OnClick="btnNuevoHuesped_Click" />
                                </div>
                            </div>
                            
                            <div class="panel">
                                <h3>Información de Habitación</h3>
                 
                                <div class="room-info">
                                    <div class="info-row">
                                        <label>Número:</label>
                                        <asp:Label ID="lblNumeroHabitacion" runat="server" Text="-" CssClass="info-value"></asp:Label>
                                    </div>
                                    <div class="info-row">
                                        <label>Tipo:</label>
                                        <asp:Label ID="lblTipoHabitacion" runat="server" Text="-" CssClass="info-value"></asp:Label>
                                    </div>
                                    <div class="info-row">
                                        <label>Estado Actual:</label>
                                        <asp:Label ID="lblEstadoActual" runat="server" Text="-" CssClass="info-value"></asp:Label>
                                    </div>
                                    <div class="info-row">
                                        <label>Precio/Noche:</label>
                                        <asp:Label ID="lblPrecioNoche" runat="server" Text="-" CssClass="info-value"></asp:Label>
                                    </div>
                                </div>
        
                                <!-- Campos de fecha simples -->
                                <div class="form-group">
                                    <label for="txtFechaEntrada">Fecha de Entrada:</label>
                                    <asp:TextBox ID="txtFechaEntrada" runat="server" TextMode="Date" CssClass="input-field"></asp:TextBox>
                                </div>
        
                                <div class="form-group">
                                    <label for="txtFechaSalida">Fecha de Salida:</label>
                                    <asp:TextBox ID="txtFechaSalida" runat="server" TextMode="Date" CssClass="input-field"></asp:TextBox>
                                </div>
        
                                <div class="form-group">
                                    <label for="txtNumeroHuespedes">Número de Huéspedes:</label>
                                    <asp:TextBox ID="txtNumeroHuespedes" runat="server" TextMode="Number" 
                                        CssClass="input-field" min="1" value="1"></asp:TextBox>
                                </div>
        
                                <div class="form-group">
                                    <label for="ddlNuevoEstado">Cambiar Estado a:</label>
                                    <asp:DropDownList ID="ddlNuevoEstado" runat="server" CssClass="input-field">
                                        <asp:ListItem Value="Ocupada">Ocupada</asp:ListItem>
                                        <asp:ListItem Value="Mantenimiento">Mantenimiento</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Botones de acción ahora al final -->
                        <div class="buttons-container">
                            <asp:Button ID="btnConfirmarCheckIn" runat="server" Text="Confirmar Check-in" 
                                CssClass="boton-primario" OnClick="btnConfirmarCheckIn_Click" />
                            <asp:Button ID="btnCancelarCheckIn" runat="server" Text="Cancelar" 
                                CssClass="boton-secundario" OnClick="btnCancelarCheckIn_Click" />
                        </div>
                    </div>
                </section>
            </main>
        </div>
        
        <!-- Modal para Editar/Nuevo Huésped -->
        <div id="modalHuesped" class="modal-overlay">
            <div class="modal-content">
                <h3 id="modalTitulo">Editar Huésped</h3>
                
                <div class="form-row">
                    <label for="txtModalDNI">ID:</label>
                    <asp:TextBox ID="txtModalDNI" runat="server" CssClass="input-field"></asp:TextBox>
                </div>
                
                <div class="form-row">
                    <label for="txtModalNombre">Nombre:</label>
                    <asp:TextBox ID="txtModalNombre" runat="server" CssClass="input-field"></asp:TextBox>
                </div>         
                <div class="form-row">
                    <label for="txtModalEmail">Email:</label>
                    <asp:TextBox ID="txtModalEmail" runat="server" TextMode="Email" CssClass="input-field"></asp:TextBox>
                </div>
                
                <div class="form-row">
                    <label for="txtModalTelefono">Teléfono:</label>
                    <asp:TextBox ID="txtModalTelefono" runat="server" CssClass="input-field"></asp:TextBox>
                </div>
                
                <div class="form-actions">
                    <asp:Button ID="btnGuardarHuesped" runat="server" Text="Guardar" 
                        CssClass="boton-primario" OnClick="btnGuardarHuesped_Click" />
                    <asp:Button ID="btnActualizarHuesped" runat="server" Text="Actualizar" 
                        CssClass="boton-primario" OnClick="btnActualizarHuesped_Click" />
                    <button type="button" id="btnCerrarModal" class="boton-secundario">Cancelar</button>
                </div>
            </div>
        </div>
    </form>

    <script>
        // Control del modal
        document.addEventListener('DOMContentLoaded', function () {
            const modal = document.getElementById('modalHuesped');
            const btnCerrarModal = document.getElementById('btnCerrarModal');
            const modalTitulo = document.getElementById('modalTitulo');
            const lblNombre = document.getElementById('<%= lblNombreCompleto.ClientID %>');

        // Cerrar modal
        btnCerrarModal.addEventListener('click', function () {
            modal.style.display = 'none';
        });

        // Cerrar modal al hacer clic fuera
        modal.addEventListener('click', function (e) {
            if (e.target === modal) {
                modal.style.display = 'none';
            }
        });
    });

        // Esta función puede ser llamada desde el code-behind cuando se selecciona un huésped
        function actualizarBotonesHuesped(mostrarEditar) {
            const btnEditar = document.getElementById('<%= btnEditarHuesped.ClientID %>');
        const btnNuevo = document.getElementById('<%= btnNuevoHuesped.ClientID %>');

            btnEditar.style.display = mostrarEditar ? 'inline-block' : 'none';
        }

    </script>
</body>
</html>