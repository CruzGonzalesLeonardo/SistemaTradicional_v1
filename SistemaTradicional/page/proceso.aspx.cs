using SistemaTradicional.data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SistemaTradicional.page
{
    public partial class proceso : System.Web.UI.Page
    {


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadHabitaciones();

            }

        }

        private void LoadHabitaciones()
        {
            try
            {
                using (DBWEBHOTELEntities VistaHabitacion = new DBWEBHOTELEntities())
                {
                    var consulta = from C in VistaHabitacion.Habitaciones
                                   where C.Hab_Estado != "Ocupada" // o "Ocupada" según tu nomenclatura
                                   select C;
                    gvHabitaciones.DataSource = consulta.ToList();
                    gvHabitaciones.DataBind();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al cargar las habitaciones: " + ex.Message);

            }
        }

        protected void gvHabitaciones_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {


                TableCell estadoCell = e.Row.Cells[3]; // Índice 3 para la columna "Estado"
                string estado = estadoCell.Text; // Obtiene el texto de la celda de estado.

                switch (estado)
                {
                    case "Disponible":
                        estadoCell.ForeColor = System.Drawing.Color.DarkGreen;  // Texto verde oscuro
                        break;
                    case "Ocupada":
                        estadoCell.ForeColor = System.Drawing.Color.DarkRed;    // Texto rojo oscuro
                        break;
                    case "Mantenimiento":
                        estadoCell.ForeColor = System.Drawing.Color.DarkSlateGray; // Texto gris oscuro
                        break;
                    default:
                        estadoCell.BackColor = System.Drawing.Color.Transparent;
                        estadoCell.ForeColor = System.Drawing.Color.Black;
                        break;
                }

                estadoCell.Font.Bold = true;
            }
        }

        protected void gvHabitaciones_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Seleccionar")
            {
                string numeroHabitacion = e.CommandArgument.ToString();

                // Redirigir a checkin.aspx con el parámetro de la habitación
                Response.Redirect($"checkin.aspx?habitacion={numeroHabitacion}");
            }
        }
    }
}