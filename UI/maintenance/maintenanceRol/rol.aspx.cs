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
            if (!IsPostBack)
            {
                CargarRoles();

                if (Request.QueryString["success"] == "true")
                {
                    // Muestra la alerta y cierra el modal
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alertaGuardar", "cerrarModalYMostrarAlerta();", true);
                }
            }
        }
        protected void ddlFiltroStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            string filtro = ddlFiltroStatus.SelectedValue;
            CargarRoles(filtro); // recargar la tabla con el filtro
        }




        protected void btnGuardarRol_ServerClick(object sender, EventArgs e)
        {
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

                    // Aquí mostramos el toast de éxito y recargamos la tabla
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "toast", "mostrarToastExito();", true);
                    CargarRoles(); // vuelve a llenar el GridView
                }
                catch (Exception ex)
                {
                    // Manejo de errores si falla el insert
                    throw new Exception("Error al insertar rol: " + ex.Message);
                }
            }
        }


        /* private void CargarRoles()
         {
             string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

             using (SqlConnection conn = new SqlConnection(connectionString))
             {
                 SqlCommand cmd = new SqlCommand("SELECT Name, Description FROM Role", conn);
                 SqlDataAdapter da = new SqlDataAdapter(cmd);
                 DataTable dt = new DataTable();
                 da.Fill(dt);
                 gvRoles.DataSource = dt;
                 gvRoles.DataBind();
             }
         }
        */


        private void CargarRoles(string statusFiltro = "")
        {
            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT Name, Description FROM Role";
                if (!string.IsNullOrEmpty(statusFiltro))
                {
                    query += " WHERE Status = @Status";
                }

                SqlCommand cmd = new SqlCommand(query, conn);
                if (!string.IsNullOrEmpty(statusFiltro))
                {
                    cmd.Parameters.AddWithValue("@Status", statusFiltro);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvRoles.DataSource = dt;
                gvRoles.DataBind();
            }
        }

       









    }
}
