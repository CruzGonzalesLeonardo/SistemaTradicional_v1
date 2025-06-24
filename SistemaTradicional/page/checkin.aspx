<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="checkin.aspx.cs" Inherits="SistemaTradicional.page.checkin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>International House Cusco - Check-in</title>
    <link rel="stylesheet" href="../estilos.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>
    <style>
        /* Estilos adicionales para el modal */
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
                         <li><a href="checkin.aspx" class="sidebar-item active" ><i class="fa-solid fa-door-open"></i> Check-in</a></li>
                         <li><a href="checkout.aspx" class="sidebar-item "><i class="fa-solid fa-door-closed"></i> Check-out</a></li>
                     </ul>
                 </nav>
             </aside>

            <!-- Contenido principal - Check-in -->
            <main class="content-area">
                <section class="content-section active">
                    <h2>Realizar Check-in</h2>
                    
                    <div class="checkin-container">
                        <!-- Panel del Huésped (izquierda) -->
                        <div class="guest-panel">
                            <h3>Información del Huésped</h3>
                            
                            <div class="search-box">
                                <asp:TextBox ID="txtBuscarHuesped" runat="server" CssClass="input-field" 
                                    placeholder="Buscar por DNI o Nombre"></asp:TextBox>
                                <asp:Button ID="btnBuscarHuesped" runat="server" Text="Buscar" 
                                    CssClass="boton-primario" OnClick="btnBuscarHuesped_Click" />
                                <button type="button" id="btnEditarNuevo" class="boton-secundario">
                                    <i class="fas fa-user-edit"></i> Editar/Nuevo
                                </button>
                            </div>
                            <div class="guest-info">
                                <div class="info-row">
                                    <label>Nombre:</label>
                                    <asp:Label ID="lblNombreCompleto" runat="server" Text="-" CssClass="info-value"></asp:Label>
                                </div>
                                <div class="info-row">
                                    <label>DNI:</label>
                                    <asp:Label ID="lblDNI" runat="server" Text="-" CssClass="info-value"></asp:Label>
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
                        </div>
                        
                        <!-- Panel de Habitación (derecha) -->
                        <div class="room-panel">
                            <h3>Información de Habitación</h3>
                            
                            <div class="form-group">
                                <label for="ddlHabitaciones">Seleccionar Habitación:</label>
                                <asp:DropDownList ID="ddlHabitaciones" runat="server" CssClass="input-field" 
                                    AutoPostBack="true" OnSelectedIndexChanged="ddlHabitaciones_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                            
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
                    
                    <!-- Botones de acción -->
                    <div class="action-buttons">
                        <asp:Button ID="btnConfirmarCheckIn" runat="server" Text="Confirmar Check-in" 
                            CssClass="boton-primario" OnClick="btnConfirmarCheckIn_Click" />
                        <asp:Button ID="btnCancelarCheckIn" runat="server" Text="Cancelar" 
                            CssClass="boton-secundario" OnClick="btnCancelarCheckIn_Click" />
                    </div>
                </section>
            </main>
        </div>
        
        <!-- Modal para Editar/Nuevo Huésped -->
        <div id="modalHuesped" class="modal-overlay">
            <div class="modal-content">
                <h3 id="modalTitulo">Editar Huésped</h3>
                
                <div class="form-row">
                    <label for="txtModalDNI">DNI:</label>
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
                    <button type="button" id="btnCerrarModal" class="boton-secundario">Cancelar</button>
                </div>
            </div>
        </div>
    </form>

    <script>
        // Control del modal
        document.addEventListener('DOMContentLoaded', function() {
            const btnEditarNuevo = document.getElementById('btnEditarNuevo');
            const modal = document.getElementById('modalHuesped');
            const btnCerrarModal = document.getElementById('btnCerrarModal');
            const modalTitulo = document.getElementById('modalTitulo');
            const txtBuscarHuesped = document.getElementById('<%= txtBuscarHuesped.ClientID %>');
            const lblNombre = document.getElementById('<%= lblNombreCompleto.ClientID %>');
            
            // Abrir modal para nuevo/editar
            btnEditarNuevo.addEventListener('click', function() {
                // Si hay un huésped seleccionado, es edición
                if (lblNombre.textContent !== '-') {
                    modalTitulo.textContent = 'Editar Huésped';
                    // Aquí deberías cargar los datos actuales en los campos del modal
                } else {
                    modalTitulo.textContent = 'Nuevo Huésped';
                    // Limpiar campos para nuevo huésped
                    document.getElementById('<%= txtModalDNI.ClientID %>').value = '';
                    document.getElementById('<%= txtModalNombre.ClientID %>').value = '';
                    document.getElementById('<%= txtModalEmail.ClientID %>').value = '';
                    document.getElementById('<%= txtModalTelefono.ClientID %>').value = '';
                }
                modal.style.display = 'block';
            });
            
            // Cerrar modal
            btnCerrarModal.addEventListener('click', function() {
                modal.style.display = 'none';
            });
            
            // Cerrar modal al hacer clic fuera
            modal.addEventListener('click', function(e) {
                if (e.target === modal) {
                    modal.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>