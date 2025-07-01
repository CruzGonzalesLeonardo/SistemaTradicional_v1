using SistemaTradicional.data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SistemaTradicional.page
{
    public partial class reservas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadReservaciones();
        }
        private void LoadReservaciones()
        {
            try
            {
                using (DBWEBHOTELV1 db = new DBWEBHOTELV1())
                {
                    var consultaReservaciones = from r in db.Reservas
                                                join h in db.Habitaciones on r.HabitacionID equals h.HabitacionID
                                                join guest in db.Huespedes on r.HuespedID equals guest.HuespedID
                                                where h.Hab_Estado == "Reservado"
                                                orderby r.Res_FechaReserva
                                                select new
                                                {
                                                    IdReserva = r.ReservaID,
                                                    Hab_NumeroHabitacion = h.Hab_NumeroHabitacion,
                                                    Res_FechaLlegada = r.Res_FechaLlegada,
                                                    H_NombreCompleto = guest.H_NombreCompleto,
                                                    IdHabitacion = h.HabitacionID,
                                                    IdHuesped = guest.HuespedID,
                                                    Res_FechaSalida = r.Res_FechaSalida,
                                                    Res_NumeroHuespedes = r.Res_NumeroHuespedes,
                                                    Res_EstadoActual = r.Res_EstadoReserva,
                                                    H_Email = guest.H_Email,
                                                    H_Telefono = guest.H_Telefono
                                                };

                    gvReservaciones.DataSource = consultaReservaciones.ToList();
                    gvReservaciones.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar las reservaciones: " + ex.Message);
            }
        }

        protected void gvReservaciones_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Ensure a row is actually selected
            if (gvReservaciones.SelectedIndex >= 0)
            {
                GridViewRow selectedRow = gvReservaciones.SelectedRow;

                // --- LOGGING: Data from the GridView Cell ---
                System.Diagnostics.Debug.WriteLine("\n--- Datos recuperados de la celda de GridView ---");
                System.Diagnostics.Debug.WriteLine($"Texto de Celda[0] (IdReserva): {selectedRow.Cells[1].Text}");
                System.Diagnostics.Debug.WriteLine($"Texto de Celda[1] (Hab_NumeroHabitacion): {selectedRow.Cells[2].Text}");
                System.Diagnostics.Debug.WriteLine($"Texto de Celda[2] (Res_FechaLlegada): {selectedRow.Cells[3].Text}");
                System.Diagnostics.Debug.WriteLine($"Texto de Celda[3] (H_NombreCompleto): {selectedRow.Cells[4].Text}");
                // --- FIN LOGGING ---

                string idReservaText = selectedRow.Cells[1].Text;
                int reservaId = Convert.ToInt32(idReservaText);

                if (int.TryParse(idReservaText, out reservaId))
                {
                    // --- LOGGING: Parsed IdReserva ---
                    System.Diagnostics.Debug.WriteLine($"IdReserva parseado: {reservaId}");
                    // --- FIN LOGGING ---

                    using (DBWEBHOTELV1 db = new DBWEBHOTELV1())
                    {
                        try
                        {
                            var reservaDetalle = (from r in db.Reservas
                                                  join h in db.Habitaciones on r.HabitacionID equals h.HabitacionID
                                                  join guest in db.Huespedes on r.HuespedID equals guest.HuespedID
                                                  where r.ReservaID == reservaId
                                                  select new
                                                  {
                                                      ClienteID = guest.HuespedID,
                                                      ClienteNombre = guest.H_NombreCompleto,
                                                      ClienteEmail = guest.H_Email,
                                                      ClienteTelefono = guest.H_Telefono,
                                                      ReservaID = r.ReservaID,
                                                      HabitacionNumero = h.Hab_NumeroHabitacion,
                                                      FechaLlegada = r.Res_FechaLlegada,
                                                      FechaSalida = r.Res_FechaSalida,
                                                      EstadoReservaActual = r.Res_EstadoReserva
                                                  }).FirstOrDefault();

                            if (reservaDetalle != null)
                            {
                                var numeroNoches = (reservaDetalle.FechaSalida - reservaDetalle.FechaLlegada).Days;

                                // --- LOGGING: Data retrieved from Database ---
                                System.Diagnostics.Debug.WriteLine("\n--- Datos recuperados de la Base de Datos ---");
                                System.Diagnostics.Debug.WriteLine($"Cliente ID: {reservaDetalle.ClienteID}");
                                System.Diagnostics.Debug.WriteLine($"Cliente Nombre: {reservaDetalle.ClienteNombre}");
                                System.Diagnostics.Debug.WriteLine($"Cliente Email: {reservaDetalle.ClienteEmail}");
                                System.Diagnostics.Debug.WriteLine($"Cliente Teléfono: {reservaDetalle.ClienteTelefono}");
                                System.Diagnostics.Debug.WriteLine($"Reserva ID: {reservaDetalle.ReservaID}");
                                System.Diagnostics.Debug.WriteLine($"Habitación Número: {reservaDetalle.HabitacionNumero}");
                                System.Diagnostics.Debug.WriteLine($"Fecha Llegada: {reservaDetalle.FechaLlegada.ToShortDateString()}");
                                System.Diagnostics.Debug.WriteLine($"Fecha Salida: {reservaDetalle.FechaSalida.ToShortDateString()}");
                                System.Diagnostics.Debug.WriteLine($"Número de Noches: {numeroNoches}");
                                System.Diagnostics.Debug.WriteLine($"Estado Reserva Actual: {reservaDetalle.EstadoReservaActual}");
                                System.Diagnostics.Debug.WriteLine("-------------------------------------------\n");
                                // --- FIN LOGGING ---

                                lblClienteID.Text = reservaDetalle.ClienteID.ToString();
                                lblClienteNombre.Text = reservaDetalle.ClienteNombre;
                                lblClienteEmail.Text = reservaDetalle.ClienteEmail;
                                lblClienteTelefono.Text = reservaDetalle.ClienteTelefono;

                                lblReservaID.Text = reservaDetalle.ReservaID.ToString();
                                lblReservaHabitacion.Text = reservaDetalle.HabitacionNumero;
                                lblFechaLlegada.Text = reservaDetalle.FechaLlegada.ToShortDateString();
                                lblFechaSalida.Text = reservaDetalle.FechaSalida.ToShortDateString();
                                lblNoches.Text = numeroNoches.ToString();
                                lblEstadoReservaActual.Text = reservaDetalle.EstadoReservaActual;

                                ListItem item = ddlCambiarEstadoReserva.Items.FindByValue(reservaDetalle.EstadoReservaActual);
                                if (item != null)
                                {
                                    ddlCambiarEstadoReserva.ClearSelection();
                                    item.Selected = true;
                                }
                                else
                                {
                                    ddlCambiarEstadoReserva.SelectedIndex = 0;
                                }
                            }
                            else
                            {
                                System.Diagnostics.Debug.WriteLine($"Advertencia: No se encontraron detalles de reserva para ID: {reservaId}");
                                ClearReservationDetails();
                            }
                        }
                        catch (Exception ex)
                        {
                            System.Diagnostics.Debug.WriteLine("Error al cargar los detalles de la reserva desde la BD: " + ex.Message);
                            ClearReservationDetails();
                        }
                    }
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine($"Error: Falló el parseo de IdReserva '{idReservaText}' desde la celda.");
                    ClearReservationDetails();
                }
            }
            else
            {
                System.Diagnostics.Debug.WriteLine("Advertencia: gvReservaciones.SelectedIndex es -1 (ninguna fila seleccionada).");
                ClearReservationDetails();
            }
        }

        private void ClearReservationDetails()
        {
            lblClienteID.Text = "-";
            lblClienteNombre.Text = "-";
            lblClienteEmail.Text = "-";
            lblClienteTelefono.Text = "-";

            lblReservaID.Text = "-";
            lblReservaHabitacion.Text = "-";
            lblFechaLlegada.Text = "-";
            lblFechaSalida.Text = "-";
            lblNoches.Text = "-";
            lblTotalReserva.Text = "-";
            lblEstadoReservaActual.Text = "-";

            ddlCambiarEstadoReserva.ClearSelection();
            if (ddlCambiarEstadoReserva.Items.Count > 0)
            {
                ddlCambiarEstadoReserva.SelectedIndex = 0;
            }
        }

        protected void btnGuardarCambiosReserva_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(lblReservaID.Text) || lblReservaID.Text == "-")
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('No hay ninguna reserva seleccionada.');", true);
                return;
            }

            int reservaId = Convert.ToInt32(lblReservaID.Text);
            string nuevoEstado = ddlCambiarEstadoReserva.SelectedValue;

            try
            {
                using (DBWEBHOTELV1 db = new DBWEBHOTELV1())
                {
                    // 1. Obtener la reserva y la habitación asociada
                    var reserva = db.Reservas.FirstOrDefault(r => r.ReservaID == reservaId);
                    if (reserva == null)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Reserva no encontrada.');", true);
                        return;
                    }

                    var habitacion = db.Habitaciones.FirstOrDefault(h => h.HabitacionID == reserva.HabitacionID);
                    if (habitacion == null)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Habitación no encontrada.');", true);
                        return;
                    }

                    // 2. Actualizar según la opción seleccionada
                    if (nuevoEstado == "Confirmar")
                    {
                        // Cambiar habitación a "Ocupada" y reserva a "Finalizada"
                        habitacion.Hab_Estado = "Ocupada";
                        reserva.Res_EstadoReserva = "Finalizada";
                    }
                    else if (nuevoEstado == "Cancelar")
                    {
                        // Cambiar habitación a "Disponible" y reserva a "Cancelada"
                        habitacion.Hab_Estado = "Disponible";
                        reserva.Res_EstadoReserva = "Cancelada";
                    }

                    // 3. Guardar cambios en la base de datos
                    db.SaveChanges();

                    // 4. Actualizar la interfaz
                    LoadReservaciones(); // Recargar el GridView
                    ClearReservationDetails(); // Limpiar detalles

                    ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Estado actualizado correctamente.');", true);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al actualizar el estado: " + ex.Message);
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Error al actualizar el estado.');", true);
            }
        }

        protected void btnCancelarSeleccion_Click(object sender, EventArgs e)
        {

        }
    }
}