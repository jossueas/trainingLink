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

                    string code1 = Session["Code1"]?.ToString();
                    var permisos = PermisoHelper.ObtenerMenuKeysParaUsuario(code1);

                    linkInicio.Visible = true;
                    linkAccesos.Visible = permisos.Contains("acceso");
                    linkRegistroEntrenamiento.Visible = permisos.Contains("registroEntrenamiento");
                    linkRol.Visible = permisos.Contains("rol");
                    linkBusinessUnit.Visible = permisos.Contains("businessUnit");
                    linkTurno.Visible = permisos.Contains("turno");
                    linkMuda.Visible = permisos.Contains("muda");
                    linkArea.Visible = permisos.Contains("area");
                    linkScrap.Visible = permisos.Contains("scrap");
                    linkOperacion.Visible = permisos.Contains("operacion");

                    // Comentados pero listos
                     linkEntrenadores.Visible = permisos.Contains("entrenadores");
                    // linkEntrenamientos.Visible = permisos.Contains("entrenamientos");

                    btnSalir.Visible = true; // Siempre visible












                    // Muestra la alerta y cierra el modal
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alertaGuardar", "cerrarModalYMostrarAlerta();", true);
                }
            }


            btnBuscar.Text = "<i class='bi bi-search'></i>";
        
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
            string idRol = hdnIdRol.Value;

            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd;
                if (!string.IsNullOrEmpty(idRol))
                {
                    cmd = new SqlCommand("sp_UpdateRole", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IdRol", idRol);
                }
                else
                {
                    cmd = new SqlCommand("sp_InsertRole", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                }

                cmd.Parameters.AddWithValue("@Name", nombreRol);
                cmd.Parameters.AddWithValue("@Description", descripcionRol);
                cmd.Parameters.AddWithValue("@Status", estado);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    CargarRoles();

                    // resetear y mostrar toast
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "toast", "mostrarToastExito();", true);
                }
                catch (Exception ex)
                {
                    throw new Exception("Error al guardar/actualizar el rol: " + ex.Message);
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
                // Incluimos IdRole y Status para futuras acciones como editar y filtrar
                string query = "SELECT IdRol, Name, Description, Status FROM Role";

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


        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            string busqueda = txtBuscar.Text.Trim();

            if (string.IsNullOrWhiteSpace(busqueda))
            {
                CargarRoles(); // Si no hay texto, mostrar todo
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("sp_SearchRole", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Busqueda", busqueda); // <-- tu parámetro original

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvRoles.DataSource = dt;
                gvRoles.DataBind();
            }
        }

        /*Eliminar*/
        protected void btnEliminarRol_ServerClick(object sender, EventArgs e)
        {
            int idRol = int.Parse(hdnIdRol.Value);
            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("sp_DeleteRole", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdRol", idRol);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    // Mostrar toast y recargar
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "toast", "mostrarToastExito();", true);
                    CargarRoles();
                }
                catch (Exception ex)
                {
                    throw new Exception("Error al eliminar el rol: " + ex.Message);
                }
            }
        }


        protected void btnSalir_Click(object sender, EventArgs e)
        {
            // Eliminar todas las variables de sesión
            Session.Clear();
            Session.Abandon();

            // Redirigir al login
            Response.Redirect("~/UI/login/login.aspx", true); // Asegúrate de que la ruta sea correcta
        }





    }
}
