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
                CargarAreas();
                CargarTurnos();
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

                cmd.Parameters.AddWithValue("@Name", nombre);
                cmd.Parameters.AddWithValue("@IdArea", idArea);
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.CommandType = CommandType.StoredProcedure;

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






    }
}
