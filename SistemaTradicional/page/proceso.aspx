<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="proceso.aspx.cs" Inherits="SistemaTradicional.page.proceso" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>International House Cusco - Gestión de Procesos</title>
    <link rel="stylesheet" href="../estilos.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>
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
                        <li><a href="#" id="btnListarHabitaciones" class="sidebar-item active" data-target="listarHabitacionesSection"><i class="fa-solid fa-hotel"></i> Listar Habitaciones</a></li>
                        <li><a href="#" id="btnCheckIn" class="sidebar-item" data-target="checkInSection"><i class="fa-solid fa-door-open"></i> Check-in</a></li>
                        <li><a href="#" id="btnCheckOut" class="sidebar-item" data-target="checkOutSection"><i class="fa-solid fa-door-closed"></i> Check-out</a></li>
                    </ul>
                </nav>
            </aside>

            <main class="content-area">
                <section id="listarHabitacionesSection" class="content-section active">
                    <h2>Listado de Habitaciones</h2>
                    <p>Aquí se mostrará un DataGrid o tabla con todas las habitaciones y sus estados actuales.</p>
                    <asp:GridView ID="gvHabitaciones" runat="server" CssClass="data-grid" HeaderStyle-CssClass="data-grid-header" RowStyle-CssClass="data-grid-row" AutoGenerateColumns="False">
                        <Columns>
                            <asp:BoundField DataField="NumeroHabitacion" HeaderText="N° Hab." />
                            <asp:BoundField DataField="TipoHabitacion" HeaderText="Tipo" />
                            <asp:BoundField DataField="Capacidad" HeaderText="Cap." />
                            <asp:BoundField DataField="Estado" HeaderText="Estado" />
                            <asp:BoundField DataField="PrecioNoche" HeaderText="Precio/Noche" DataFormatString="{0:C}" />
                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>
                                    <asp:Button ID="btnVerDetalles" runat="server" Text="Ver" CssClass="boton-secundario" CommandName="VerDetalles" CommandArgument='<%# Eval("HabitacionID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </section>

                <section id="checkInSection" class="content-section">
                    <h2>Realizar Check-in</h2>
                    <div class="checkin-form content-form-layout">
                        <div class="form-section">
                            <h3>Información del Huésped</h3>
                            <div class="search-box">
                                <asp:TextBox ID="txtBuscarHuesped" runat="server" CssClass="input-field" Placeholder="Buscar Huésped (DNI/ID)"></asp:TextBox>
                                <asp:Button ID="btnBuscarHuesped" runat="server" Text="Buscar" CssClass="boton-primario" OnClick="btnBuscarHuesped_Click" />
                            </div>
                            <div class="client-details">
                                <label>Nombre:</label> <asp:Label ID="lblNombreHuesped" runat="server" Text=""></asp:Label><br />
                                <label>Apellido:</label> <asp:Label ID="lblApellidoHuesped" runat="server" Text=""></asp:Label><br />
                                <label>Email:</label> <asp:Label ID="lblEmailHuesped" runat="server" Text=""></asp:Label><br />
                                <label>Teléfono:</label> <asp:Label ID="lblTelefonoHuesped" runat="server" Text=""></asp:Label><br />
                                <asp:Button ID="btnModificarHuesped" runat="server" Text="Modificar Datos" CssClass="boton-secundario open-cliente-modal" ClientIDMode="Static" type="button" />
                                <asp:Button ID="btnNuevoHuesped" runat="server" Text="Registrar Nuevo" CssClass="boton-secundario open-cliente-modal" ClientIDMode="Static" type="button" />
                            </div>
                            <div class="form-group">
                                <label for="txtFechaLlegada">Fecha de Llegada:</label>
                                <asp:TextBox ID="txtFechaLlegada" runat="server" TextMode="Date" CssClass="input-field"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label for="txtFechaSalida">Fecha de Salida:</label>
                                <asp:TextBox ID="txtFechaSalida" runat="server" TextMode="Date" CssClass="input-field"></asp:TextBox>
                            </div>
                             <div class="form-group">
                                <label for="txtNumeroHuespedes">N° Huéspedes:</label>
                                <asp:TextBox ID="txtNumeroHuespedes" runat="server" TextMode="Number" CssClass="input-field" Text="1"></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-section">
                            <h3>Detalles de la Habitación</h3>
                            <div class="room-details">
                                <label>Habitación N°:</label> <asp:Label ID="lblNumeroHabitacionCI" runat="server" Text="[Seleccionar]"></asp:Label><br />
                                <label>Tipo:</label> <asp:Label ID="lblTipoHabitacionCI" runat="server" Text=""></asp:Label><br />
                                <label>Estado:</label> <asp:Label ID="lblEstadoHabitacionCI" runat="server" Text=""></asp:Label><br />
                                <label>Tarifa Noche:</label> <asp:Label ID="lblPrecioNocheCI" runat="server" Text=""></asp:Label><br />
                                <label>Total Est.:</label> <asp:Label ID="lblTotalEstimadoCI" runat="server" Text=""></asp:Label>
                                <div class="form-group">
                                    <label for="ddlSeleccionarHabitacion">Seleccionar Habitación:</label>
                                    <asp:DropDownList ID="ddlSeleccionarHabitacion" runat="server" CssClass="input-field"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="section-buttons">
                        <asp:Button ID="btnRegistrarCheckIn" runat="server" Text="Registrar Check-in" CssClass="boton-primario" OnClick="btnRegistrarCheckIn_Click" />
                        <asp:Button ID="btnDescartarCheckIn" runat="server" Text="Limpiar" CssClass="boton-secundario" />
                    </div>
                </section>

                <section id="checkOutSection" class="content-section">
                    <h2>Realizar Check-out</h2>
                    <h3>Seleccione la Habitación a Desocupar</h3>
                    <asp:GridView ID="gvHabitacionesOcupadas" runat="server" CssClass="data-grid" HeaderStyle-CssClass="data-grid-header" RowStyle-CssClass="data-grid-row" AutoGenerateColumns="False" OnSelectedIndexChanged="gvHabitacionesOcupadas_SelectedIndexChanged" AutoGenerateSelectButton="True">
                        <Columns>
                            <asp:BoundField DataField="NumeroHabitacion" HeaderText="N° Hab." />
                            <asp:BoundField DataField="HuespedPrincipal" HeaderText="Huésped" />
                            <asp:BoundField DataField="FechaLlegada" HeaderText="Llegada" DataFormatString="{0:d}" />
                            <asp:BoundField DataField="FechaSalida" HeaderText="Salida Est." DataFormatString="{0:d}" />
                            <asp:BoundField DataField="Estado" HeaderText="Estado" />
                        </Columns>
                    </asp:GridView>

                    <div id="modificarEstadoCheckoutModal" class="modal small-modal">
                        <div class="modal-content">
                            <span class="close-button">&times;</span>
                            <h2>Confirmar Check-out y Estado</h2>
                            <div class="modal-body client-form-details">
                                <div class="form-section-full">
                                    <label>Huésped:</label> <asp:Label ID="lblHuespedCO" runat="server" Text=""></asp:Label><br />
                                    <label>Habitación N°:</label> <asp:Label ID="lblNumeroHabitacionCO" runat="server" Text=""></asp:Label><br />
                                    <label>Fecha Llegada:</label> <asp:Label ID="lblFechaLlegadaCO" runat="server" Text=""></asp:Label><br />
                                    <label>Fecha Salida Est.:</label> <asp:Label ID="lblFechaSalidaEstCO" runat="server" Text=""></asp:Label><br />
                                    <label>Estado Actual Hab.:</label> <asp:Label ID="lblEstadoActualHabCO" runat="server" Text=""></asp:Label><br />
                                    <div class="form-group">
                                        <label for="ddlEstadoFinalHabitacion">Cambiar Estado a:</label>
                                        <asp:DropDownList ID="ddlEstadoFinalHabitacion" runat="server" CssClass="input-field">
                                            <asp:ListItem Value="Disponible">Disponible</asp:ListItem>
                                            <asp:ListItem Value="Mantenimiento">Mantenimiento</asp:ListItem>
                                            <asp:ListItem Value="Limpieza">Limpieza</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <label>Total a Pagar:</label> <asp:Label ID="lblTotalPagarCO" runat="server" Text="[Calcular]"></asp:Label>
                                </div>
                            </div>
                            <div class="modal-buttons">
                                <asp:Button ID="btnRegistrarCheckOut" runat="server" Text="Confirmar Check-out" CssClass="boton-primario" OnClick="btnRegistrarCheckOut_Click" />
                                <asp:Button ID="btnCancelarCheckOutModal" runat="server" Text="Cancelar" CssClass="boton-secundario" />
                            </div>
                        </div>
                    </div>
                    </section>
            </main>
        </div>

        <div id="clienteModal" class="modal">
            <div class="modal-content">
                <span class="close-button">&times;</span>
                <h2 id="clienteModalTitle">Registrar Nuevo Huésped</h2>
                <div class="modal-body client-form-details">
                    <div class="form-section-full">
                        <div class="form-group">
                            <label for="txtClienteDNI">DNI/ID:</label>
                            <asp:TextBox ID="txtClienteDNI" runat="server" CssClass="input-field" placeholder="Número de Documento"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtClienteNombre">Nombre(s):</label>
                            <asp:TextBox ID="txtClienteNombre" runat="server" CssClass="input-field" placeholder="Nombre(s) del huésped"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtClienteApellido">Apellidos:</label>
                            <asp:TextBox ID="txtClienteApellido" runat="server" CssClass="input-field" placeholder="Apellidos del huésped"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtClienteEmail">Email:</label>
                            <asp:TextBox ID="txtClienteEmail" runat="server" TextMode="Email" CssClass="input-field" placeholder="correo@ejemplo.com"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtClienteTelefono">Teléfono:</label>
                            <asp:TextBox ID="txtClienteTelefono" runat="server" CssClass="input-field" placeholder="+51 9XXXXXXXX"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtClienteNacionalidad">Nacionalidad:</label>
                            <asp:TextBox ID="txtClienteNacionalidad" runat="server" CssClass="input-field" placeholder="Nacionalidad"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="modal-buttons">
                    <asp:Button ID="btnGuardarCliente" runat="server" Text="Guardar Huésped" CssClass="boton-primario" OnClick="btnGuardarCliente_Click" />
                    <asp:Button ID="btnCancelarCliente" runat="server" Text="Cancelar" CssClass="boton-secundario" />
                </div>
            </div>
        </div>

    </form>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Referencias a las modales que SÍ se superponen
            const clienteModal = document.getElementById('clienteModal');
            const clienteModalTitle = document.getElementById('clienteModalTitle');
            const modificarEstadoCheckoutModal = document.getElementById('modificarEstadoCheckoutModal');

            // Referencias a los botones de la barra lateral (AHORA CONTROLAN SECCIONES)
            const sidebarItems = document.querySelectorAll('.sidebar-item'); // Selecciona todos los elementos de la sidebar

            // Referencias a los botones que abren modales
            const btnModificarHuesped = document.getElementById('btnModificarHuesped');
            const btnNuevoHuesped = document.getElementById('btnNuevoHuesped');
            const btnCancelarCliente = document.getElementById('<%= btnCancelarCliente.ClientID %>');
            const btnCancelarCheckOutModal = document.getElementById('<%= btnCancelarCheckOutModal.ClientID %>');

            // Botones de "limpiar" en las secciones
            const btnDescartarCheckIn = document.getElementById('<%= btnDescartarCheckIn.ClientID %>');

            // Botones de cierre de modales
            const closeButtons = document.querySelectorAll('.close-button');

            // Función para mostrar una sección de contenido y ocultar las demás
            function showContentSection(sectionId) {
                document.querySelectorAll('.content-section').forEach(section => {
                    section.classList.remove('active');
                });
                document.getElementById(sectionId).classList.add('active');

                // Actualizar el estado 'active' en la sidebar
                sidebarItems.forEach(item => {
                    if (item.dataset.target === sectionId) {
                        item.classList.add('active');
                    } else {
                        item.classList.remove('active');
                    }
                });
            }

            // Función para limpiar la modal de cliente
            function clearClienteModal() {
                document.getElementById('<%= txtClienteDNI.ClientID %>').value = '';
                document.getElementById('<%= txtClienteNombre.ClientID %>').value = '';
                document.getElementById('<%= txtClienteApellido.ClientID %>').value = '';
                document.getElementById('<%= txtClienteEmail.ClientID %>').value = '';
                document.getElementById('<%= txtClienteTelefono.ClientID %>').value = '';
                document.getElementById('<%= txtClienteNacionalidad.ClientID %>').value = '';
            }

            // Función para limpiar la sección de Check-in
            function clearCheckInSection() {
                document.getElementById('<%= txtBuscarHuesped.ClientID %>').value = '';
                document.getElementById('<%= lblNombreHuesped.ClientID %>').textContent = '';
                document.getElementById('<%= lblApellidoHuesped.ClientID %>').textContent = '';
                document.getElementById('<%= lblEmailHuesped.ClientID %>').textContent = '';
                document.getElementById('<%= lblTelefonoHuesped.ClientID %>').textContent = '';
                document.getElementById('<%= txtFechaLlegada.ClientID %>').value = '';
                document.getElementById('<%= txtFechaSalida.ClientID %>').value = '';
                document.getElementById('<%= txtNumeroHuespedes.ClientID %>').value = '1';
                // Resetear dropdown de habitacion o cargar por defecto
                if (document.getElementById('<%= ddlSeleccionarHabitacion.ClientID %>')) {
                    document.getElementById('<%= ddlSeleccionarHabitacion.ClientID %>').selectedIndex = 0;
                }
                document.getElementById('<%= lblNumeroHabitacionCI.ClientID %>').textContent = '[Seleccionar]';
                document.getElementById('<%= lblTipoHabitacionCI.ClientID %>').textContent = '';
                document.getElementById('<%= lblEstadoHabitacionCI.ClientID %>').textContent = '';
                document.getElementById('<%= lblPrecioNocheCI.ClientID %>').textContent = '';
                document.getElementById('<%= lblTotalEstimadoCI.ClientID %>').textContent = '';
            }

            // Eventos para los elementos de la barra lateral (navegación entre secciones)
            sidebarItems.forEach(item => {
                item.addEventListener('click', function(e) {
                    e.preventDefault();
                    const targetSectionId = this.dataset.target;
                    showContentSection(targetSectionId);
                });
            });

            // Eventos para abrir la modal de cliente
            btnNuevoHuesped.addEventListener('click', function(e) {
                e.preventDefault();
                clearClienteModal();
                clienteModalTitle.textContent = 'Registrar Nuevo Huésped';
                clienteModal.style.display = 'block';
            });

            btnModificarHuesped.addEventListener('click', function(e) {
                e.preventDefault();
                clienteModalTitle.textContent = 'Modificar Datos del Huésped';
                // Cargar datos actuales del huésped en la modal (se asume que lblNombreHuesped, etc. tienen los datos)
                document.getElementById('<%= txtClienteDNI.ClientID %>').value = document.getElementById('<%= lblNombreHuesped.ClientID %>').dataset.dni || ''; // Asume data-dni
                document.getElementById('<%= txtClienteNombre.ClientID %>').value = document.getElementById('<%= lblNombreHuesped.ClientID %>').textContent.trim();
                document.getElementById('<%= txtClienteApellido.ClientID %>').value = document.getElementById('<%= lblApellidoHuesped.ClientID %>').textContent.trim();
                document.getElementById('<%= txtClienteEmail.ClientID %>').value = document.getElementById('<%= lblEmailHuesped.ClientID %>').textContent.trim();
                document.getElementById('<%= txtClienteTelefono.ClientID %>').value = document.getElementById('<%= lblTelefonoHuesped.ClientID %>').textContent.trim();
                // Si tienes nacionalidad u otros campos, cárgalos de manera similar
                clienteModal.style.display = 'block';
            });

            // Evento para limpiar la sección de Check-in
            btnDescartarCheckIn.addEventListener('click', function (e) {
                e.preventDefault(); // Evita el postback
                clearCheckInSection();
            });

            // Eventos para cerrar todas las modales
            closeButtons.forEach(button => {
                button.addEventListener('click', function () {
                    this.closest('.modal').style.display = 'none';
                });
            });

            // Evento para el botón Cancelar dentro de la modal de cliente
            btnCancelarCliente.addEventListener('click', function (e) {
                e.preventDefault(); // Previene el postback
                clienteModal.style.display = 'none';
            });

            // Evento para el botón Cancelar dentro de la modal de Check-out (confirmación de estado)
            btnCancelarCheckOutModal.addEventListener('click', function (e) {
                e.preventDefault(); // Previene el postback
                modificarEstadoCheckoutModal.style.display = 'none';
            });

            // Cerrar modal al hacer clic fuera (modificado para incluir solo las modales que se superponen)
            window.addEventListener('click', function (event) {
                if (event.target == clienteModal) {
                    clienteModal.style.display = 'none';
                }
                if (event.target == modificarEstadoCheckoutModal) {
                    modificarEstadoCheckoutModal.style.display = 'none';
                }
            });

            // Para que la sección inicial "Listar Habitaciones" esté activa al cargar la página
            showContentSection('listarHabitacionesSection');
        });
    </script>