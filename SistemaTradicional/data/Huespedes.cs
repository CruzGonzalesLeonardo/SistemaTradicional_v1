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
    
    public partial class Huespedes
    {
        public Huespedes()
        {
            this.Reservas = new HashSet<Reservas>();
        }
    
        public int HuespedID { get; set; }
        public string H_NombreCompleto { get; set; }
        public string H_Email { get; set; }
        public string H_Telefono { get; set; }
        public string H_Direccion { get; set; }
    
        public virtual ICollection<Reservas> Reservas { get; set; }
    }
}
