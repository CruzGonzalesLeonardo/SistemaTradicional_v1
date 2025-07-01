using SistemaTradicional.data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SistemaTradicional.page
{
    public partial class checkout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CargarHabitacionesOcupadas();
        }

        private void CargarHabitacionesOcupadas()
        {
            try
            {
                using (DBWEBHOTELV1 db = new DBWEBHOTELV1())
                {
                    var habitacionesOcupadas = from r in db.Reservas
                                               join h in db.Habitaciones on r.HabitacionID equals h.HabitacionID
                                               join guest in db.Huespedes on r.HuespedID equals guest.HuespedID
                                               where h.Hab_Estado == "Ocupada" 
                                               orderby r.Res_FechaSalida
                                               select new
                                               {
                                                   IdReserva = r.ReservaID,
                                                   h.Hab_NumeroHabitacion,
                                                   r.Res_FechaSalida,
                                                   guest.H_NombreCompleto
                                               };

                    gvHabitaciones.DataSource = habitacionesOcupadas.ToList();
                    gvHabitaciones.DataBind();
                }
            }
            catch (Exception ex)
            {
                MostrarError("Error al cargar habitaciones ocupadas: " + ex.Message);
            }
        }

        protected void gvHabitaciones_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvHabitaciones.SelectedIndex >= 0)
            {
                int reservaId = Convert.ToInt32(gvHabitaciones.SelectedValue);
                MostrarDetallesCheckout(reservaId);
            }
        }

        private void MostrarDetallesCheckout(int reservaId)
        {
            try
            {
                using (DBWEBHOTELV1 db = new DBWEBHOTELV1())
                {
                    var reserva = db.Reservas
                        .Include("Habitaciones")
                        .Include("Huespedes")
                        .FirstOrDefault(r => r.ReservaID == reservaId);

                    if (reserva != null)
                    {
                        // Mostrar información en el modal
                        lblReservaId.Text = reserva.ReservaID.ToString();
                        lblHabitacionNumero.Text = reserva.Habitaciones.Hab_NumeroHabitacion;
                        lblFechaSalida.Text = reserva.Res_FechaSalida.ToShortDateString();
                        lblHuespedNombre.Text = reserva.Huespedes.H_NombreCompleto;

                        // Guardar ID de reserva en ViewState para usar después
                        ViewState["ReservaID"] = reservaId;

                        // Mostrar el modal
                        modalCheckout.Visible = true;
                        ScriptManager.RegisterStartupScript(this, GetType(), "MostrarModal", "mostrarModal();", true);
                    }
                }
            }
            catch (Exception ex)
            {
                MostrarError("Error al cargar detalles de reserva: " + ex.Message);
            }
        }


        protected void btnConfirmarCheckout_Click(object sender, EventArgs e)
        {
            if (ViewState["ReservaID"] == null)
            {
                MostrarError("No se ha seleccionado una reserva válida.");
                return;
            }

            int reservaId = (int)ViewState["ReservaID"];
            string accion = ddlAccionCheckout.SelectedValue;
            string notas = txtNotasCheckout.Text.Trim();

            try
            {
                using (DBWEBHOTELV1 db = new DBWEBHOTELV1())
                {
                    var reserva = db.Reservas.Find(reservaId);
                    if (reserva != null)
                    {
                        var habitacion = db.Habitaciones.Find(reserva.HabitacionID);

                        if (accion == "Normal")
                        {
                            // Check-out normal
                            reserva.Res_EstadoReserva = "Finalizada";
                            habitacion.Hab_Estado = "Disponible";
                        }
                        else if (accion == "Cancelacion")
                        {
                            // Check-out por cancelación
                            reserva.Res_EstadoReserva = "Cancelada";
                            habitacion.Hab_Estado = "Disponible";
                        }

                        reserva.Res_Notas = notas;
                        db.SaveChanges();

                        MostrarExito("Check-out procesado correctamente.");
                        CargarHabitacionesOcupadas();
                        modalCheckout.Visible = false;
                    }
                }
            }
            catch (Exception ex)
            {
                MostrarError("Error al procesar check-out: " + ex.Message);
            }
        }

        private void MostrarError(string mensaje)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('{mensaje}');", true);
        }

        private void MostrarExito(string mensaje)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('{mensaje}');", true);
        }

    }
}