//------------------------------------------------------------------------------
// <auto-generated>
//    Este código se generó a partir de una plantilla.
//
//    Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//    Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SistemaTradicional.data
{
    using System;
    using System.Collections.Generic;
    
    public partial class Reservas
    {
        public int ReservaID { get; set; }
        public int HuespedID { get; set; }
        public int HabitacionID { get; set; }
        public System.DateTime Res_FechaLlegada { get; set; }
        public System.DateTime Res_FechaSalida { get; set; }
        public Nullable<System.DateTime> Res_FechaReserva { get; set; }
        public int Res_NumeroHuespedes { get; set; }
        public string Res_EstadoReserva { get; set; }
        public string Res_Notas { get; set; }
    
        public virtual Habitaciones Habitaciones { get; set; }
        public virtual Huespedes Huespedes { get; set; }
    }
}
