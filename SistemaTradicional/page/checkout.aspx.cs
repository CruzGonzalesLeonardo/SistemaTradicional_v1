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
            LoadHabitaciones();
        }

        private void LoadHabitaciones()
        {
            try
            {
                using (DBWEBHOTELEntities VistaHabitacion = new DBWEBHOTELEntities())
                {
                    var consulta = from C in VistaHabitacion.Habitaciones
                                   where C.Hab_Estado == "Ocupada" // Filtro para solo habitaciones ocupadas
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

    }
}