using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using trainingLink.UI.maintenance.maintenanceUsuario;

namespace trainingLink.UI.maintenance.maintenanceEntrenador
{
    public partial class entrenador : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                CargarEntrenadores();

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
                    linkEntrenador.Visible = permisos.Contains("entrenadores");
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
            CargarEntrenadores(filtro); // recargar la tabla con el filtro
        }





        protected void btnGuardarEntrenador_ServerClick(object sender, EventArgs e)
        {
            string nombreEntrenador = txtNombreEntrenador.Text.Trim();
            string tipoEntrenador = txtTipoEntrenador.Text.Trim();
            string estadoEntrenador = ddlEstadoEntrenador.SelectedValue;
            bool estado = estadoEntrenador == "1";
            string idEntrenador = hdnIdEntrenador.Value;

            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd;
                if (!string.IsNullOrEmpty(idEntrenador))
                {
                    cmd = new SqlCommand("sp_UpdateEntrenador", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IdEntrenador", idEntrenador);
                }
                else
                {
                    cmd = new SqlCommand("sp_InsertEntrenador", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                }

                cmd.Parameters.AddWithValue("@Nombre", nombreEntrenador);
                cmd.Parameters.AddWithValue("@TipoEntrenador", tipoEntrenador);
                cmd.Parameters.AddWithValue("@Estado", estado);
                cmd.Parameters.AddWithValue("@IdUsuario",hdnIdUsuario); 


                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    CargarEntrenadores();

                    // resetear y mostrar toast
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "toast", "mostrarToastExito();", true);
                }
                catch (Exception ex)
                {
                    throw new Exception("Error al guardar/actualizar el entrenador: " + ex.Message);
                }
            }
        }





        private void CargarEntrenadores(string statusFiltro = "")
        {
            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("sp_GetEntrenadoresFull", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                // Si el SP acepta parámetro para filtrar estado, inclúyelo
                if (!string.IsNullOrEmpty(statusFiltro))
                {
                    cmd.Parameters.AddWithValue("@Estado", statusFiltro); // solo si tu SP lo permite
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvEntrenadores.DataSource = dt;
                gvEntrenadores.DataBind();
            }
        }


        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            string busqueda = txtBuscar.Text.Trim();

            if (string.IsNullOrWhiteSpace(busqueda))
            {
                CargarEntrenadores(); // Si no hay texto, mostrar todo
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("sp_SearchEntrenador", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Busqueda", busqueda); // <-- tu parámetro original

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvEntrenadores.DataSource = dt;
                gvEntrenadores.DataBind();
            }
        }

        /*Eliminar*/
        protected void btnEliminarEntrenador_ServerClick(object sender, EventArgs e)
        {
            int idEntrenador = int.Parse(hdnIdEntrenador.Value);
            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("sp_DeleteEntrenador", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdRol", idEntrenador);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    // Mostrar toast y recargar
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "toast", "mostrarToastExito();", true);
                    CargarEntrenadores();
                }
                catch (Exception ex)
                {
                    throw new Exception("Error al eliminar el entrenador: " + ex.Message);
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