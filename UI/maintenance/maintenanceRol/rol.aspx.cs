using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace trainingLink.UI.maintenance.maintenanceRol
{
    public partial class rol : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Lógica de carga si es necesario
        }

        protected void btnGuardarRol_ServerClick(object sender, EventArgs e)
        {
            // Obtener valores desde controles ASP.NET
            string nombreRol = txtNombreRol.Text.Trim();
            string descripcionRol = txtDescripcionRol.Text.Trim();
            string estadoRol = ddlEstadoRol.SelectedValue;

            bool estado = estadoRol == "1";

            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("sp_InsertRole", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Name", nombreRol);
                cmd.Parameters.AddWithValue("@Description", descripcionRol);
                cmd.Parameters.AddWithValue("@Status", estado);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    // Aquí podrías mostrar un mensaje de éxito o recargar tabla
                }
                catch (Exception ex)
                {
                    // Aquí puedes registrar el error o mostrar un mensaje
                    throw new Exception("Error al insertar rol: " + ex.Message);
                }
            }
        }
    }
}
