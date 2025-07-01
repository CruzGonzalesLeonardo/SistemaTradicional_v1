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

            using (DBWEBHOTELEntities db = new DBWEBHOTELEntities())
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

                using (DBWEBHOTELEntities db = new DBWEBHOTELEntities())
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

        private void MostrarMensaje(string mensaje)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", $"alert('{mensaje}');", true);
        }

        protected void btnConfirmarCheckIn_Click(object sender, EventArgs e)
        {
            string debugInfo = "Valores recolectados:\n";
            debugInfo += $"ID Huésped: {lblID.Text}\n";
            debugInfo += $"ID Habitación: {txtIdHabitacion.Text}\n";
            debugInfo += $"Fecha Entrada: {txtFechaEntrada.Text}\n";
            debugInfo += $"Fecha Salida: {txtFechaSalida.Text}\n";
            debugInfo += $"Número Huéspedes: {txtNumeroHuespedes.Text}\n";
            debugInfo += $"Estado Seleccionado: {ddlNuevoEstado.SelectedValue}\n";
            debugInfo += $"Notas: {txtNotas.Text}\n";

            // Mostrar esta información (puedes verla en la consola, un alert, o un archivo de log)
            System.Diagnostics.Debug.WriteLine(debugInfo); // Para ver en Output de Visual Studio
            MostrarMensaje(debugInfo);
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
            using (DBWEBHOTELEntities context = new DBWEBHOTELEntities())
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
                    using (DBWEBHOTELEntities context = new DBWEBHOTELEntities())
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

            using (DBWEBHOTELEntities context = new DBWEBHOTELEntities())
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
            using (DBWEBHOTELEntities context = new DBWEBHOTELEntities())
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
    }
}