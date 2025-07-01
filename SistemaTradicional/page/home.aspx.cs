using SistemaTradicional.data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SistemaTradicional.page
{
    public partial class home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Recargar_datos();
        }

        private void Recargar_datos()
        {
            using (DBWEBHOTELV1 dbMostrar = new DBWEBHOTELV1())
            {
                int habitacioneslibres = dbMostrar.Habitaciones.Count(h => h.Hab_Estado == "Disponible");
                int HabitacionesReservadas = dbMostrar.Habitaciones.Count(h => h.Hab_Estado == "Reservado");
                int habitacionesOcupadas = dbMostrar.Habitaciones.Count(h => h.Hab_Estado == "Ocupada");

                lblHlibres.Text = Convert.ToString(habitacioneslibres);
                lblOcupadas.Text = Convert.ToString(habitacionesOcupadas);
                lblReservadas.Text = Convert.ToString(HabitacionesReservadas);

            }
        }
    }
}