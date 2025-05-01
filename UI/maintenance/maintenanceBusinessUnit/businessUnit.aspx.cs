using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

using System;
using System.Linq;

namespace trainingLink.UI.maintenance.maintenanceBusinessUnit
{
    public partial class businessUnit : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarBusinessUnits(); // Cargar unidades de negocio al inicio
            }
        }

        // Función que se ejecuta al cambiar el filtro de estado
        protected void ddlFiltroStatusBusinessUnit_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarBusinessUnits();
        }
        protected void ddlFiltroStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Reload the business units based on the selected filter
            CargarBusinessUnits();
        }





        // Función de búsqueda por nombre o descripción
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
         

            CargarBusinessUnits();
        }


      

        // Función para cargar las unidades de negocio
        // Función para cargar las unidades de negocio
        private void CargarBusinessUnits()
        {
            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_SearchBusinessUnit", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Busqueda", txtBuscar.Text.Trim());

                if (string.IsNullOrEmpty(ddlFiltroStatusBusinessUnit.SelectedValue))
                    cmd.Parameters.AddWithValue("@StatusFilter", DBNull.Value);
                else
                    cmd.Parameters.AddWithValue("@StatusFilter", ddlFiltroStatusBusinessUnit.SelectedValue);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

              

                gvBusinessUnit.DataSource = dt;
                gvBusinessUnit.DataBind();
            }
        }





        // Función para guardar o actualizar unidad de negocio
        protected void btnGuardarBusinessUnit_ServerClick(object sender, EventArgs e)
        {
            string nombre = txtNombreBusinessUnit.Text.Trim();
            bool status = ddlEstadoBusinessUnit.SelectedValue == "1";
            string idBusinessUnit = hdnIdBusinessUnit.Value;

            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd;

                // Si tiene ID, actualizamos, si no insertamos
                if (!string.IsNullOrEmpty(idBusinessUnit) && int.TryParse(idBusinessUnit, out int id))
                {
                    cmd = new SqlCommand("sp_UpdateBusinessUnit", conn); // Procedimiento de actualización
                    cmd.Parameters.AddWithValue("@IdBusinessUnit", id);
                }
                else
                {
                    cmd = new SqlCommand("sp_InsertBusinessUnit", conn); // Procedimiento de inserción
                }

                // Asignar los valores de los parámetros
                cmd.Parameters.AddWithValue("@Name", nombre); // Aquí asignamos correctamente el nombre
                cmd.Parameters.AddWithValue("@Status", status);

                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery(); // Ejecuta la consulta

                    //Despúes de la oporación, recargar datos 
                    CargarBusinessUnits();


                    //Mostrar un toast exito 
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "toast", "mostrarToastExitoBusinessUnit();", true);
                }
                catch (Exception ex)
                {
                    throw new Exception("Error al guardar/actualizar la unidad de negocio: " + ex.Message);
                }
            }
        }

        // Eliminar unidad de negocio
        protected void btnEliminarBusinessUnit_ServerClick(object sender, EventArgs e)
        {
            int.TryParse(hdnIdBusinessUnit.Value, out int idBusinessUnit);
            if (idBusinessUnit == 0) return;

            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_DeleteBusinessUnit", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdBusinessUnit", idBusinessUnit);
                conn.Open();
                cmd.ExecuteNonQuery();
                CargarBusinessUnits();
            }
        }
    }
}
