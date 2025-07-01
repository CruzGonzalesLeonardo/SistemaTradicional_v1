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
        
        /* Estilos para el selector de fechas */
        .date-range-selector {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .date-input-container {
            position: relative;
            flex: 1;
        }
        
        .date-input {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            background-color: white;
            box-sizing: border-box;
            height: 40px;
        }
        
        .date-input:focus {
            border-color: #4CAF50;
            outline: none;
        }
        
        .nights-control {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 5px;
            margin-top: 20px;
        }
        
        .nights-display {
            background-color: #4CAF50;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            font-weight: bold;
            min-width: 40px;
            text-align: center;
        }
        
        .nights-button {
            background-color: #f2f2f2;
            border: none;
            width: 30px;
            height: 20px;
            border-radius: 3px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        
        .nights-button:hover {
            background-color: #e6e6e6;
        }
        
        /* Estilos para el componente de notas */
        .notes-container {
            margin-top: 15px;
        }
        
        .notes-container label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .notes-textarea {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 5px;
            min-height: 80px;
            resize: vertical;
        }
        
        /* Estilos para el componente de monto total */
        .total-container {
            margin-top: 15px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
            border: 1px solid #ddd;
            display: none;
        }
        
        .total-display {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
        }
        
        .total-label {
            font-weight: bold;
        }
        
        .total-value {
            font-weight: bold;
            color: #4CAF50;
        }
        
        .grand-total {
            font-size: 1.2em;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #ddd;
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

            <main class="content-area">
                <section class="content-section active">
                    <h2>Realizar Check-in</h2>
                    
                    <div class="main-checkin-content">
                        <div class="panels-container">
                            <div class="panel">
                                <h3>Información del Huésped</h3>
                                
                                <div class="search-box">
                                    <asp:TextBox ID="txtBuscarHuesped" runat="server" CssClass="input-field" 
                                        placeholder="Buscar por DNI o Nombre"></asp:TextBox>
                                    <asp:Button ID="btnBuscarHuesped" runat="server" Text="Buscar" 
                                        CssClass="boton-primario" OnClick="btnBuscarHuesped_Click" />
                                </div>
                                
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
                                    </asp:GridView>
                                </div>
                                
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
                                        <asp:Label Text="ID" ID="txtIdHabitacion" runat="server" Visible="false" />
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
                                        <asp:HiddenField ID="hdnPrecioNoche" runat="server" />
                                    </div>
                                </div>
        
                                <div class="date-range-selector">
                                    <div class="date-input-container">
                                        <label for="txtFechaEntrada" style="display: block; margin-bottom: 5px; font-weight: bold;">Fecha de Entrada</label>
                                        <asp:TextBox ID="txtFechaEntrada" runat="server" TextMode="Date" CssClass="date-input"></asp:TextBox>
                                    </div>
                                    
                                    <div class="nights-control">
                                        <button type="button" class="nights-button" id="btnIncreaseNights">+</button>
                                        <div class="nights-display" id="nightsDisplay">1 noche</div>
                                        <button type="button" class="nights-button" id="btnDecreaseNights">-</button>
                                    </div>
                                    
                                    <div class="date-input-container">
                                        <label for="txtFechaSalida" style="display: block; margin-bottom: 5px; font-weight: bold;">Fecha de Salida</label>
                                        <asp:TextBox ID="txtFechaSalida" runat="server" TextMode="Date" CssClass="date-input" ReadOnly="false"></asp:TextBox>
                                    </div>
                                </div>
                                <div>
                                    <asp:Label Text="Precio por noche"  runat="server" ID="lblPrecioFinal"  />
                                </div>
                                <div class="notes-container">
                                    <label for="txtNotas">Notas adicionales:</label>
                                    <asp:TextBox ID="txtNotas" runat="server" TextMode="MultiLine" CssClass="notes-textarea" placeholder="Ingrese cualquier observación o nota especial..."></asp:TextBox>
                                </div>
                                
                                <div class="total-container" id="totalContainer">
                                    <div class="total-display">
                                        <span class="total-label">Precio por noche:</span>
                                        <span class="total-value" id="precioNocheDisplay">S/ 0.00</span>
                                    </div>
                                    <div class="total-display">
                                        <span class="total-label">Noches:</span>
                                        <span class="total-value" id="nochesDisplay">0</span>
                                    </div>
                                    <div class="total-display grand-total">
                                        <span class="total-label">Total estimado:</span>
                                        <span class="total-value" id="totalDisplay">S/ 0.00</span>
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
                                        <asp:ListItem Value="Reserva">Reservar</asp:ListItem>
                                        <asp:ListItem Value="Ocupado">Ocupado</asp:ListItem>
                                        <asp:ListItem Value="Cancelar">Cancelar</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        
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

        function actualizarBotonesHuesped(mostrarEditar) {
            const btnEditar = document.getElementById('<%= btnEditarHuesped.ClientID %>');
            const btnNuevo = document.getElementById('<%= btnNuevoHuesped.ClientID %>');

            btnEditar.style.display = mostrarEditar ? 'inline-block' : 'none';
        }

        // Control del selector de fechas y cálculo de total
        document.addEventListener('DOMContentLoaded', function () {
            const fechaEntrada = document.getElementById('<%= txtFechaEntrada.ClientID %>');
            const fechaSalida = document.getElementById('<%= txtFechaSalida.ClientID %>');
            const btnIncrease = document.getElementById('btnIncreaseNights');
            const btnDecrease = document.getElementById('btnDecreaseNights');
            const nightsDisplay = document.getElementById('nightsDisplay');
            const totalContainer = document.getElementById('totalContainer');
            const precioNocheDisplay = document.getElementById('precioNocheDisplay');
            const nochesDisplay = document.getElementById('nochesDisplay');
            const totalDisplay = document.getElementById('totalDisplay');
    
            let nights = 1;
            let precioNoche = 0;
    
            // Obtener el precio por noche del hidden field
            const hdnPrecioNoche = document.getElementById('<%= hdnPrecioNoche.ClientID %>');
            if (hdnPrecioNoche && hdnPrecioNoche.value) {
                precioNoche = parseFloat(hdnPrecioNoche.value.replace(',', '.')); // Asegurar formato decimal correcto
                updateTotalDisplay();
            }

            // Función para formatear fecha a YYYY-MM-DD (formato compatible con input type="date")
            function formatDate(date) {
                const d = new Date(date);
                let month = '' + (d.getMonth() + 1);
                let day = '' + d.getDate();
                const year = d.getFullYear();

                if (month.length < 2)
                    month = '0' + month;
                if (day.length < 2)
                    day = '0' + day;

                return [year, month, day].join('-');
            }

            // Establecer fecha mínima (hoy)
            const today = new Date();
            fechaEntrada.min = formatDate(today);

            // Establecer fechas iniciales
            if (!fechaEntrada.value) {
                fechaEntrada.value = formatDate(today);

                // Establecer fecha de salida como un día después
                const tomorrow = new Date(today);
                tomorrow.setDate(today.getDate() + 1);
                fechaSalida.value = formatDate(tomorrow);
            }

            // Actualizar fecha de salida cuando cambia la fecha de entrada
            fechaEntrada.addEventListener('change', function () {
                if (fechaEntrada.value) {
                    updateEndDate();
                }
            });

            // Botón para aumentar noches
            btnIncrease.addEventListener('click', function () {
                nights++;
                updateNightsDisplay();
                updateEndDate();
                updateTotalDisplay();
                showTotalContainer();
            });

            // Botón para disminuir noches (mínimo 1)
            btnDecrease.addEventListener('click', function () {
                if (nights > 1) {
                    nights--;
                    updateNightsDisplay();
                    updateEndDate();
                    updateTotalDisplay();
                    showTotalContainer();
                }
            });

            function updateNightsDisplay() {
                nightsDisplay.textContent = nights + (nights === 1 ? " noche" : " noches");
                nochesDisplay.textContent = nights;
            }

            function updateEndDate() {
                if (fechaEntrada.value) {
                    const startDate = new Date(fechaEntrada.value);
                    const endDate = new Date(startDate);
                    endDate.setDate(startDate.getDate() + nights);
                    fechaSalida.value = formatDate(endDate);
                }
            }

            function updateTotalDisplay() {
                if (precioNoche > 0) {
                    const total = nights * precioNoche;
                    precioNocheDisplay.textContent = 'S/ ' + precioNoche.toFixed(2);
                    totalDisplay.textContent = 'S/ ' + total.toFixed(2);
                }
            }

            function showTotalContainer() {
                if (precioNoche > 0) {
                    totalContainer.style.display = 'block';
                }
            }

            // Inicializar
            updateNightsDisplay();
        });
    </script>

</body>
</html>