using SistemaTradicional.data;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SistemaTradicional.page
{
    public partial class checkin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {


            if (!IsPostBack)
            {
                // Verificar si se recibió un parámetro de habitación
                if (!string.IsNullOrEmpty(Request.QueryString["habitacion"]))
                {
                    string numeroHabitacion = Request.QueryString["habitacion"];

                    lblNumeroHabitacion.Text = numeroHabitacion;
                    BuscarHabitacion(numeroHabitacion);

                }
            }

            gvHuespedes.CssClass += " visible";
        }

        protected void btnBuscarHuesped_Click(object sender, EventArgs e)
        {
            string terminoBusqueda = txtBuscarHuesped.Text.Trim();

            if (string.IsNullOrEmpty(terminoBusqueda))
            {
                MostrarMensaje("Por favor ingrese un término de búsqueda");
                return;
            }

            using (DBWEBHOTELV1 db = new DBWEBHOTELV1())
            {
                var resultados = db.Huespedes
                    .Where(h => h.H_NombreCompleto.Contains(terminoBusqueda) ||
                               h.H_Email.Contains(terminoBusqueda) ||
                               h.H_Telefono.Contains(terminoBusqueda))
                    .OrderBy(h => h.H_NombreCompleto)
                    .ToList();

                if (resultados.Any())
                {
                    gvHuespedes.DataSource = resultados;
                    gvHuespedes.DataBind();
                }
                else
                {
                    MostrarMensaje("No se encontraron huéspedes con ese criterio");
                }
            }
        }

        protected void gvHuespedes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Seleccionar")
            {
                btnEditarHuesped.Visible = true;
                btnNuevoHuesped.Visible = false;
                ScriptManager.RegisterStartupScript(this, GetType(), "actualizarBotones", "actualizarBotonesHuesped(true);", true);
                int huespedId = Convert.ToInt32(e.CommandArgument);

                using (DBWEBHOTELV1 db = new DBWEBHOTELV1())
                {
                    var huesped = db.Huespedes.Find(huespedId);

                    if (huesped != null)
                    {
                        // Mostrar datos en los controles
                        lblID.Text = Convert.ToString(huespedId);
                        lblNombreCompleto.Text = huesped.H_NombreCompleto;
                        lblEmail.Text = huesped.H_Email;
                        lblTelefono.Text = huesped.H_Telefono;

                    }
                }
            }
        }



        protected void btnConfirmarCheckIn_Click(object sender, EventArgs e)
        {
            // Always good to perform basic validation before database operations
            if (string.IsNullOrWhiteSpace(lblID.Text) ||
                string.IsNullOrWhiteSpace(txtIdHabitacion.Text) ||
                string.IsNullOrWhiteSpace(txtFechaEntrada.Text) ||
                string.IsNullOrWhiteSpace(txtFechaSalida.Text) ||
                string.IsNullOrWhiteSpace(txtNumeroHuespedes.Text))
            {
                MostrarAlertaChek("Por favor, complete todos los campos obligatorios.", false);
                return;
            }

            // Parse values from textboxes
            int idHuesped;
            int idHabitacion;
            DateTime fechaEntrada;
            DateTime fechaSalida;
            int numeroHuespedes;

            // Use TryParse for robust conversion
            if (!int.TryParse(lblID.Text, out idHuesped))
            {
                MostrarAlertaChek("ID Huésped no válido.", false);
                return;
            }
            if (!int.TryParse(txtIdHabitacion.Text, out idHabitacion))
            {
                MostrarAlertaChek("ID Habitación no válido.", false);
                return;
            }
            if (!DateTime.TryParse(txtFechaEntrada.Text, out fechaEntrada))
            {
                MostrarAlertaChek("Formato de Fecha de Entrada no válido (esperado YYYY-MM-DD).", false);
                return;
            }
            if (!DateTime.TryParse(txtFechaSalida.Text, out fechaSalida))
            {
                MostrarAlertaChek("Formato de Fecha de Salida no válido (esperado YYYY-MM-DD).", false);
                return;
            }
            if (!int.TryParse(txtNumeroHuespedes.Text, out numeroHuespedes))
            {
                MostrarAlertaChek("Número de Huéspedes no válido.", false);
                return;
            }

            string estadoSeleccionado = ddlNuevoEstado.SelectedValue;
            string notas = txtNotas.Text;

            // Debug info (optional, keep for development)
            string debugInfo = "Valores recolectados:\n";
            debugInfo += $"ID Huésped: {idHuesped}\n";
            debugInfo += $"ID Habitación: {idHabitacion}\n";
            debugInfo += $"Fecha Entrada: {fechaEntrada.ToShortDateString()}\n";
            debugInfo += $"Fecha Salida: {fechaSalida.ToShortDateString()}\n";
            debugInfo += $"Número Huéspedes: {numeroHuespedes}\n";
            debugInfo += $"Estado Seleccionado: {estadoSeleccionado}\n";
            debugInfo += $"Notas: {notas}\n";
            System.Diagnostics.Debug.WriteLine(debugInfo);

            // --- Database Operations ---
            using (var db = new DBWEBHOTELV1()) // Instantiate context within a using block
            {
                try
                {
                    // 1. Find the Room (Habitacion)
                    var habitacion = db.Habitaciones.FirstOrDefault(h => h.HabitacionID == idHabitacion); // Adjust IdHabitacion property name
                    if (habitacion == null)
                    {
                        MostrarAlertaChek($"Habitación con ID {idHabitacion} no encontrada.", false);
                        return;
                    }

                    // 2. Determine States based on ddlNuevoEstado
                    string estadoHabitacion;
                    string estadoReserva;

                    if (estadoSeleccionado == "Reserva")
                    {
                        estadoHabitacion = "Reservado"; // Update Habitacion state
                        estadoReserva = "Pendiente";    // Set Reserva state
                    }
                    else if (estadoSeleccionado == "Alquilar")
                    {
                        estadoHabitacion = "Ocupada";   // Update Habitacion state
                        estadoReserva = "Confirmada";   // Set Reserva state
                    }
                    else
                    {
                        // Handle other potential states or default
                        MostrarAlertaChek("Estado de selección no reconocido.", false);
                        return;
                    }

                    // 3. Update Habitacion State
                    habitacion.Hab_Estado = estadoHabitacion; // Assuming 'Estado' is the property name for the room status

                    // 4. Create a new Reserva entry
                    var nuevaReserva = new Reservas // Assuming 'Reserva' is your EF model class
                    {
                        HuespedID = idHuesped,          // Foreign Key to Huesped
                        HabitacionID = idHabitacion,    // Foreign Key to Habitacion
                        Res_FechaLlegada = fechaEntrada,
                        Res_FechaSalida = fechaSalida,
                        Res_NumeroHuespedes = numeroHuespedes,
                        Res_EstadoReserva = estadoReserva,
                        Res_Notas = notas
                    };

                    db.Reservas.Add(nuevaReserva); // Add the new reservation to the context

                    db.SaveChanges();

                    MostrarAlertaChek($"Operación completada con éxito. Habitación {idHabitacion} ahora está '{estadoHabitacion}' y la reserva está '{estadoReserva}'.", true);

                    // Optionally, clear the form or redirect
                    // LimpiarCampos();
                    // Response.Redirect("success.aspx");

                }
                catch (System.Data.UpdateException ex)
                {
                    // Handle specific database update errors
                    MostrarAlertaChek($"Error al actualizar la base de datos: {ex.InnerException?.Message ?? ex.Message}", false);
                    System.Diagnostics.Debug.WriteLine($"Database Update Error: {ex.InnerException?.Message ?? ex.Message}");
                }
                catch (Exception ex)
                {
                    // Catch any other general exceptions
                    MostrarAlertaChek($"Ocurrió un error inesperado: {ex.Message}", false);
                    System.Diagnostics.Debug.WriteLine($"General Error: {ex.Message}\nStackTrace: {ex.StackTrace}");
                }
            }
        }
        private void MostrarAlertaChek(string mensaje, bool esExito = true)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage", $"alert('{mensaje.Replace("'", "\\'")}')", true);
        }
        protected void btnCancelarCheckIn_Click(object sender, EventArgs e)
        {
            Response.Redirect("proceso.aspx");
        }


        string Modo = "nuevo";
        protected void btnEditarHuesped_Click(object sender, EventArgs e)
        {
            Modo = "editar";
            txtModalDNI.Text = lblID.Text;
            txtModalDNI.Enabled= false;
            txtModalNombre.Text = lblNombreCompleto.Text;
            txtModalEmail.Text = lblEmail.Text;
            txtModalTelefono.Text = lblTelefono.Text;
            
            ScriptManager.RegisterStartupScript(this, GetType(), "mostrarModal", "document.getElementById('modalHuesped').style.display = 'block';", true);

            btnGuardarHuesped.Visible = false;
        }

        protected void btnNuevoHuesped_Click(object sender, EventArgs e)
        {
            txtModalDNI.Enabled = false;
            Modo = "nuevo";
            int ultimoId = 0;
            using (DBWEBHOTELV1 context = new DBWEBHOTELV1())
            {
                ultimoId = context.Huespedes
                                     .OrderByDescending(h => h.HuespedID)
                                     .FirstOrDefault()?.HuespedID ?? 0;
            }
            txtModalDNI.Text = Convert.ToString(ultimoId + 1);
            txtModalNombre.Text = "";
            txtModalEmail.Text = "";
            txtModalTelefono.Text = "";
            ScriptManager.RegisterStartupScript(this, GetType(), "mostrarModal", "document.getElementById('modalHuesped').style.display = 'block';", true);

            btnActualizarHuesped.Visible = false;
  
        }
        protected void btnGuardarHuesped_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrWhiteSpace(txtModalNombre.Text) && !string.IsNullOrWhiteSpace(txtModalEmail.Text))
            {
                    // **Lógica para NUEVO huésped**
                    using (DBWEBHOTELV1 context = new DBWEBHOTELV1())
                    {
                        Huespedes nuevoHuesped = new Huespedes()
                        {
                            HuespedID = Convert.ToInt32(txtModalDNI.Text),
                            H_NombreCompleto = txtModalNombre.Text,
                            H_Email = txtModalEmail.Text,
                            H_Telefono = txtModalTelefono.Text
                        };

                        context.Huespedes.Add(nuevoHuesped);
                        context.SaveChanges();

                        ScriptManager.RegisterStartupScript(this, GetType(), "exito",
                            "alert('Huésped creado correctamente');", true);
                    }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error",
                    "alert('Complete todos los campos obligatorios');", true);
            }
        }

        protected void btnActualizarHuesped_Click(object sender, EventArgs e)
        {

            // **Lógica para EDITAR huésped**
            int idHuesped = Convert.ToInt32(txtModalDNI.Text); // ID oculto

            using (DBWEBHOTELV1 context = new DBWEBHOTELV1())
            {
                var huesped = context.Huespedes.Find(idHuesped);

                if (huesped != null)
                {
                    // Actualizar campos editables (excepto ID y DNI si es clave primaria)
                    
                    huesped.H_NombreCompleto = txtModalNombre.Text;
                    huesped.H_Email = txtModalEmail.Text;
                    huesped.H_Telefono = txtModalTelefono.Text;

                    context.SaveChanges();

                    ScriptManager.RegisterStartupScript(this, GetType(), "exito",
                        "alert('Huésped actualizado correctamente');", true);
                }
            }
        }

        protected void BuscarHabitacion(string numeroHabitacion)
        {
            using (DBWEBHOTELV1 context = new DBWEBHOTELV1())
            {
                var habitacion = context.Habitaciones
                                      .FirstOrDefault(h => h.Hab_NumeroHabitacion == numeroHabitacion);

                if (habitacion != null)
                {
                    // Llenar los controles con los datos de la habitación
                    txtIdHabitacion.Text = habitacion.HabitacionID.ToString ();
                    lblNumeroHabitacion.Text = habitacion.Hab_NumeroHabitacion;
                    lblTipoHabitacion.Text = $"{habitacion.Hab_NombreTipo} (Capacidad: {habitacion.Hab_Capacidad})";
                    lblEstadoActual.Text = habitacion.Hab_Estado;
                    lblPrecioNoche.Text = habitacion.Hab_TarifaBase.ToString("C");

                    // Configurar el TextBox de huéspedes con la capacidad máxima
                    txtNumeroHuespedes.Attributes["max"] = habitacion.Hab_Capacidad.ToString();
                    txtNumeroHuespedes.ToolTip = $"Máximo {habitacion.Hab_Capacidad} huéspedes";

                }
                else
                {
                    // Habitación no encontrada
                    ScriptManager.RegisterStartupScript(this, GetType(), "habNoEncontrada",
                        "alert('Habitación no encontrada');", true);
                }
            }
        }
        private void MostrarMensaje(string mensaje)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('{mensaje}');", true);
        } 
    }
}