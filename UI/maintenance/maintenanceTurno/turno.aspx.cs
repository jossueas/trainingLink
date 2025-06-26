using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace trainingLink.UI.maintenance.maintenanceTurno
{
    public partial class turno : Page
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
                CargarAreas();
                CargarUnidadesDeNegocio();
                CargarTurnos();

            }
        }
        private void CargarUnidadesDeNegocio()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT IdBusinessUnit, Name FROM BusinessUnit WHERE Status = 1";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlUnidadNegocio.DataSource = reader;
                        ddlUnidadNegocio.DataTextField = "Name"; // Lo que se muestra
                        ddlUnidadNegocio.DataValueField = "IdBusinessUnit"; // Lo que se guarda
                        ddlUnidadNegocio.DataBind();
                    }

                    ddlUnidadNegocio.Items.Insert(0, new ListItem("-- Seleccione --", ""));
                }
            }
        }

        protected void ddlFiltroStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarTurnos();
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            CargarTurnos();
        }

        private void CargarAreas()
        {
            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT IdArea, Name FROM Area WHERE Status = 1 ORDER BY Name", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlArea.DataSource = dt;
                ddlArea.DataTextField = "Name";
                ddlArea.DataValueField = "IdArea";
                ddlArea.DataBind();

                ddlArea.Items.Insert(0, new ListItem("Seleccione un área", "0"));
            }
        }

        private void CargarTurnos()
        {
            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_SearchTurno", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Busqueda", txtBuscar.Text.Trim());

                if (string.IsNullOrEmpty(ddlFiltroStatusTurno.SelectedValue))
                    cmd.Parameters.AddWithValue("@StatusFilter", DBNull.Value);
                else
                    cmd.Parameters.AddWithValue("@StatusFilter", ddlFiltroStatusTurno.SelectedValue);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTurno.DataSource = dt;
                gvTurno.DataBind();
            }
        }
        protected void btnGuardarTurno_ServerClick(object sender, EventArgs e)
        {
            string nombre = txtNombreTurno.Text.Trim();
            bool status = ddlEstadoTurno.SelectedValue == "1";
            int.TryParse(ddlArea.SelectedValue, out int idArea);
            string idTurno = hdnIdTurno.Value;

            // NUEVOS CAMPOS SOLICITADOS
            TimeSpan.TryParse(txtHoraInicio.Text, out TimeSpan horaInicio);
            TimeSpan.TryParse(txtHoraFin.Text, out TimeSpan horaFin);
            int.TryParse(txtHorasLaboradas.Text, out int horasLaboradas);
            int.TryParse(ddlUnidadNegocio.SelectedValue, out int idBusinessUnit);

            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd;

                if (!string.IsNullOrEmpty(idTurno) && int.TryParse(idTurno, out int id))
                {
                    cmd = new SqlCommand("sp_UpdateTurno", conn);
                    cmd.Parameters.AddWithValue("@IdTurno", id);
                }
                else
                {
                    cmd = new SqlCommand("sp_InsertTurno", conn);
                }

                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Name", nombre);
                cmd.Parameters.AddWithValue("@IdArea", idArea);
                cmd.Parameters.AddWithValue("@Status", status);

                // NUEVOS PARÁMETROS
                cmd.Parameters.AddWithValue("@horaInicio", horaInicio);
                cmd.Parameters.AddWithValue("@horaFin", horaFin);
                cmd.Parameters.AddWithValue("@horaLaboradas", horasLaboradas);
                cmd.Parameters.AddWithValue("@idBusinessUnit", idBusinessUnit);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    CargarTurnos();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "toast", "mostrarToastExitoTurno();", true);
                }
                catch (Exception ex)
                {
                    throw new Exception("Error al guardar/actualizar el turno: " + ex.Message);
                }
            }
        }


        protected void btnEliminarTurno_ServerClick(object sender, EventArgs e)
        {
            int.TryParse(hdnIdTurno.Value, out int idTurno);
            if (idTurno == 0) return;

            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_DeleteTurno", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdTurno", idTurno);
                conn.Open();
                cmd.ExecuteNonQuery();

                // Recargar datos después de eliminar
                CargarTurnos();
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
