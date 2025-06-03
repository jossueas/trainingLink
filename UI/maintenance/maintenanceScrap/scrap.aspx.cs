using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace trainingLink.UI.maintenance.maintenanceScrap
{
    public partial class scrap : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
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
                CargarScraps();
            }
        }

        protected void ddlFiltroStatusScrap_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarScraps();
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            CargarScraps();
        }

        private void CargarScraps()
        {
            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_SearchScrap", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Busqueda", txtBuscar.Text.Trim());
                if (string.IsNullOrEmpty(ddlFiltroStatusScrap.SelectedValue))
                    cmd.Parameters.AddWithValue("@StatusFilter", DBNull.Value);
                else
                    cmd.Parameters.AddWithValue("@StatusFilter", ddlFiltroStatusScrap.SelectedValue);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvScrap.DataSource = dt;
                gvScrap.DataBind();
            }
        }

        protected void btnGuardarScrap_ServerClick(object sender, EventArgs e)
        {
            string nombre = txtNombreScrap.Text.Trim();
            bool status = ddlEstadoScrap.SelectedValue == "1";
            string idScrap = hdnIdScrap.Value;

            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd;
                if (!string.IsNullOrEmpty(idScrap) && int.TryParse(idScrap, out int id))
                {
                    cmd = new SqlCommand("sp_UpdateScrap", conn);
                    cmd.Parameters.AddWithValue("@IdScrap", id);
                }
                else
                {
                    cmd = new SqlCommand("sp_InsertScrap", conn);
                }

                cmd.Parameters.AddWithValue("@Name", nombre);
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    CargarScraps();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "toast", "mostrarToastExitoScrap();", true);
                }
                catch (Exception ex)
                {
                    throw new Exception("Error al guardar/actualizar Scrap: " + ex.Message);
                }
            }
        }

        protected void btnEliminarScrap_ServerClick(object sender, EventArgs e)
        {
            int.TryParse(hdnIdScrap.Value, out int idScrap);
            if (idScrap == 0) return;

            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_DeleteScrap", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdScrap", idScrap);
                conn.Open();
                cmd.ExecuteNonQuery();
                CargarScraps();
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