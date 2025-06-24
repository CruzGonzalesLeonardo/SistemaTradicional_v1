using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace SistemaTradicional.page
{
    public partial class proceso : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadHabitaciones(); // Carga el GridView de listar habitaciones
                LoadHabitacionesOcupadas(); // Carga el GridView de Check-out
                LoadHabitacionesDropdown(); // Carga el DropDownList para Check-in

                // Inicializa los labels de huésped en la sección de Check-in
                lblNombreHuesped.Text = "";
                lblApellidoHuesped.Text = "";
                lblEmailHuesped.Text = "";
                lblTelefonoHuesped.Text = "";

                // Asegúrate de que la modal de modificar estado de Check-out esté oculta al inicio
                // No necesitas un control Server para esto si la ocultas con CSS por defecto
                // Sin embargo, si tu lógica de servidor la hace visible en Page_Load por error, es mejor ocultarla
            }
            // Después de cada postback, asegúrate de que la sección correcta esté activa
            // Esto es crucial para que la página no "salte" de sección después de un botón.
            // Puedes usar un HiddenField para guardar la sección activa o deducirlo del control que hizo el postback.
            // Para simplicidad en este ejemplo, no se mantiene la sección activa en postbacks automáticamente
            // (a menos que el botón de postback sea de esa sección específica).
            // Para una UX ideal, usar un UpdatePanel es la mejor solución para evitar recargas completas.
        }

        private void LoadHabitaciones()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("HabitacionID", typeof(int));
            dt.Columns.Add("NumeroHabitacion", typeof(string));
            dt.Columns.Add("TipoHabitacion", typeof(string));
            dt.Columns.Add("Capacidad", typeof(int));
            dt.Columns.Add("Estado", typeof(string));
            dt.Columns.Add("PrecioNoche", typeof(decimal));

            dt.Rows.Add(1, "101", "Doble", 2, "Disponible", 150.00m);
            dt.Rows.Add(2, "102", "Simple", 1, "Ocupada", 100.00m);
            dt.Rows.Add(3, "103", "Suite", 4, "Disponible", 250.00m);
            dt.Rows.Add(4, "201", "Doble", 2, "Mantenimiento", 150.00m);
            dt.Rows.Add(5, "202", "Ocupada", 2, "Ocupada", 150.00m);

            gvHabitaciones.DataSource = dt;
            gvHabitaciones.DataBind();
        }

        private void LoadHabitacionesOcupadas()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ReservaID", typeof(int));
            dt.Columns.Add("HabitacionID", typeof(int));
            dt.Columns.Add("NumeroHabitacion", typeof(string));
            dt.Columns.Add("HuespedPrincipal", typeof(string));
            dt.Columns.Add("FechaLlegada", typeof(DateTime));
            dt.Columns.Add("FechaSalida", typeof(DateTime));
            dt.Columns.Add("Estado", typeof(string)); // Estado de la habitación

            dt.Rows.Add(101, 2, "102", "Juan Pérez", DateTime.Now.AddDays(-2), DateTime.Now.AddDays(1), "Ocupada");
            dt.Rows.Add(102, 5, "202", "María García", DateTime.Now.AddDays(-1), DateTime.Now.AddDays(2), "Ocupada");

            gvHabitacionesOcupadas.DataSource = dt;
            gvHabitacionesOcupadas.DataBind();
        }

        private void LoadHabitacionesDropdown()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("HabitacionID", typeof(int));
            dt.Columns.Add("NumeroTipo", typeof(string));

            DataTable allRooms = new DataTable();
            allRooms.Columns.Add("HabitacionID", typeof(int));
            allRooms.Columns.Add("NumeroHabitacion", typeof(string));
            allRooms.Columns.Add("TipoHabitacion", typeof(string));
            allRooms.Columns.Add("Estado", typeof(string));

            allRooms.Rows.Add(1, "101", "Doble", "Disponible");
            allRooms.Rows.Add(2, "102", "Simple", "Ocupada");
            allRooms.Rows.Add(3, "103", "Suite", "Disponible");
            allRooms.Rows.Add(4, "201", "Doble", "Mantenimiento"); // Ejemplo: no disponible para check-in

            foreach (DataRow row in allRooms.Rows)
            {
                if (row["Estado"].ToString() == "Disponible")
                {
                    dt.Rows.Add(row["HabitacionID"], $"{row["NumeroHabitacion"]} - {row["TipoHabitacion"]}");
                }
            }

            ddlSeleccionarHabitacion.DataSource = dt;
            ddlSeleccionarHabitacion.DataTextField = "NumeroTipo";
            ddlSeleccionarHabitacion.DataValueField = "HabitacionID";
            ddlSeleccionarHabitacion.DataBind();
            ddlSeleccionarHabitacion.Items.Insert(0, new ListItem("-- Seleccione --", ""));
        }


        // **********************************************
        // LÓGICA PARA CHECK-IN SECTION
        // **********************************************

        protected void btnBuscarHuesped_Click(object sender, EventArgs e)
        {
            string dni = txtBuscarHuesped.Text.Trim();
            // Lógica para buscar el huésped en la base de datos
            if (dni == "12345678")
            {
                lblNombreHuesped.Text = "Ana";
                lblApellidoHuesped.Text = "Martínez";
                lblEmailHuesped.Text = "ana.m@example.com";
                lblTelefonoHuesped.Text = "987654321";
                // Guardar DNI en un atributo de datos para que JS pueda copiarlo para "Modificar"
                lblNombreHuesped.Attributes["data-dni"] = dni;
            }
            else
            {
                lblNombreHuesped.Text = "[No encontrado]";
                lblApellidoHuesped.Text = "";
                lblEmailHuesped.Text = "";
                lblTelefonoHuesped.Text = "";
                // No abrir la modal aquí automáticamente, el usuario usará el botón "Registrar Nuevo"
            }
            // Asegúrate de que la sección de Check-in esté visible después del postback
            ClientScript.RegisterStartupScript(this.GetType(), "ShowCheckInSection", "showContentSection('checkInSection');", true);
        }

        protected void btnRegistrarCheckIn_Click(object sender, EventArgs e)
        {
            // Lógica para registrar el Check-in
            string huespedDNI = txtBuscarHuesped.Text;
            string habitacionID = ddlSeleccionarHabitacion.SelectedValue;
            DateTime fechaLlegada = DateTime.Parse(txtFechaLlegada.Text);
            DateTime fechaSalida = DateTime.Parse(txtFechaSalida.Text);

            // Guardar en DB...

            Response.Write("<script>alert('Check-in registrado con éxito para huésped " + huespedDNI + " en habitación " + habitacionID + "!');</script>");
            // Limpiar la sección y mostrarla de nuevo
            ClientScript.RegisterStartupScript(this.GetType(), "ClearCheckInAndShow", "clearCheckInSection(); showContentSection('checkInSection');", true);
        }

        // **********************************************
        // LÓGICA PARA CHECK-OUT SECTION
        // **********************************************

        protected void gvHabitacionesOcupadas_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Se ejecuta cuando el usuario hace clic en el botón "Seleccionar" de una fila del GridView
            if (gvHabitacionesOcupadas.SelectedRow != null)
            {
                // Obtener datos de la fila seleccionada
                string numeroHabitacion = gvHabitacionesOcupadas.SelectedRow.Cells[1].Text; // Ajusta el índice
                string huesped = gvHabitacionesOcupadas.SelectedRow.Cells[2].Text; // Ajusta el índice
                string fechaLlegada = gvHabitacionesOcupadas.SelectedRow.Cells[3].Text; // Ajusta el índice
                string fechaSalidaEst = gvHabitacionesOcupadas.SelectedRow.Cells[4].Text; // Ajusta el índice
                string estadoActual = gvHabitacionesOcupadas.SelectedRow.Cells[5].Text; // Ajusta el índice

                // Llenar los Labels en la MODAL de modificación de estado de Check-out
                lblHuespedCO.Text = huesped;
                lblNumeroHabitacionCO.Text = numeroHabitacion;
                lblFechaLlegadaCO.Text = fechaLlegada;
                lblFechaSalidaEstCO.Text = fechaSalidaEst;
                lblEstadoActualHabCO.Text = estadoActual;
                lblTotalPagarCO.Text = "$ 300.00"; // Ejemplo de cálculo

                // Abre la pequeña modal de modificación de estado
                ClientScript.RegisterStartupScript(this.GetType(), "OpenModificarEstadoModal", "document.getElementById('modificarEstadoCheckoutModal').style.display='block'; showContentSection('checkOutSection');", true);
            }
        }

        protected void btnRegistrarCheckOut_Click(object sender, EventArgs e)
        {
            // Lógica para registrar el Check-out
            if (gvHabitacionesOcupadas.SelectedRow != null)
            {
                string numeroHabitacion = lblNumeroHabitacionCO.Text; // Viene de la modal
                string nuevoEstadoHabitacion = ddlEstadoFinalHabitacion.SelectedValue;

                // Actualizar DB...

                Response.Write("<script>alert('Check-out registrado para habitación " + numeroHabitacion + ". Nuevo estado: " + nuevoEstadoHabitacion + "');</script>");
                // Cerrar la modal y recargar la lista de habitaciones ocupadas, manteniendo la sección de Check-out activa
                ClientScript.RegisterStartupScript(this.GetType(), "CloseCheckoutModalAndRefresh", "document.getElementById('modificarEstadoCheckoutModal').style.display='none'; showContentSection('checkOutSection'); location.reload(true);", true);
            }
            else
            {
                Response.Write("<script>alert('Por favor, seleccione una habitación para hacer Check-out.');</script>");
                ClientScript.RegisterStartupScript(this.GetType(), "ShowCheckoutSection", "showContentSection('checkOutSection');", true);
            }
        }

        // **********************************************
        // LÓGICA PARA GESTIÓN DE CLIENTES (MODAL)
        // **********************************************
        protected void btnGuardarCliente_Click(object sender, EventArgs e)
        {
            string dni = txtClienteDNI.Text.Trim();
            string nombre = txtClienteNombre.Text.Trim();
            string apellido = txtClienteApellido.Text.Trim();
            string email = txtClienteEmail.Text.Trim();
            string telefono = txtClienteTelefono.Text.Trim();
            string nacionalidad = txtClienteNacionalidad.Text.Trim();

            // Simulación de guardar cliente
            bool isNewClient = true; // Lógica real aquí

            if (isNewClient)
            {
                // Insertar cliente
                Response.Write("<script>alert('Nuevo huésped " + nombre + " " + apellido + " registrado con éxito!');</script>");
            }
            else
            {
                // Actualizar cliente
                Response.Write("<script>alert('Datos del huésped " + nombre + " " + apellido + " actualizados con éxito!');</script>");
            }

            // Cerrar la modal del cliente
            ClientScript.RegisterStartupScript(this.GetType(), "CloseClienteModal", "document.getElementById('clienteModal').style.display='none'; showContentSection('checkInSection');", true);
            // Si el cliente fue modificado/registrado desde la sección de Check-in,
            // podrías querer volver a buscarlo para que los labels de Check-in se actualicen.
            // Esto implicaría un postback adicional o una llamada AJAX.
            // Para simplicidad, se cierra la modal y se muestra la sección de check-in.
        }
    }
}