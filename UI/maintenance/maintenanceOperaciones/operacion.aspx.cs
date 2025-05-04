// operacion.aspx.cs
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;



namespace trainingLink.UI.maintenance.maintenanceOperacion



{
    public partial class operacion : Page
    {
        private readonly string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["TrainingLinkConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarAreas();
                CargarOperaciones();
            }
        }
        protected void ddlFiltroStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarOperaciones();
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            CargarOperaciones();
        }

        private void CargarAreas()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("SELECT IdArea, Name FROM Area WHERE Status = 1", conn))
            {
                conn.Open();

                // Crear y llenar DataTable
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Asignar DataTable al DropDownList
                ddlAreaOperacion.DataSource = dt;
                ddlAreaOperacion.DataValueField = "IdArea";
                ddlAreaOperacion.DataTextField = "Name";
                ddlAreaOperacion.DataBind();
            }

            ddlAreaOperacion.Items.Insert(0, new ListItem("Seleccione un área", ""));
        }
        private void CargarOperaciones()
        {
            int? status = null;
            if (!string.IsNullOrEmpty(ddlFiltroStatus.SelectedValue))
                status = int.Parse(ddlFiltroStatus.SelectedValue);

            string nombre = txtBuscar.Text.Trim();

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("sp_GetAllOperations", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@StatusFilter", status.HasValue ? (object)status.Value : DBNull.Value);
                cmd.Parameters.AddWithValue("@NameFilter", !string.IsNullOrEmpty(nombre) ? (object)nombre : DBNull.Value);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds.Tables.Count > 0)
                {
                    DataTable dt = ds.Tables[0];

                    // Asegurar que exista la columna para el botón editar
                    if (!dt.Columns.Contains("ScriptEditCall"))
                        dt.Columns.Add("ScriptEditCall", typeof(string));

                    foreach (DataRow row in dt.Rows)
                    {
                        int id = Convert.ToInt32(row["IdOperation"]);
                        string name = row["Name"].ToString().Replace("\"", "\\\"");
                        string output = row["OutputTarget"].ToString();
                        string yield = row["YieldTarget"].ToString();
                        string training = row["OutputTargetTraining"].ToString();
                        string leadTime = row["LeadTime"].ToString();
                        string days = row["NumberDays"].ToString();
                        string areaId = row["IdArea"].ToString();
                        string statusStr = Convert.ToBoolean(row["Status"]) ? "1" : "0";
                        string percentOutput = row["PercentOutput"].ToString();
                        string percentYieldTarget = row["PercentYieldTarget"].ToString();

                        row["ScriptEditCall"] = $"abrirModalEditarOperacion({id}, \"{name}\", {output}, {yield}, {training}, {leadTime}, {days}, \"{areaId}\", \"{statusStr}\", {percentOutput}, {percentYieldTarget})";
                    }

                    gvOperacion.DataSource = dt;
                    gvOperacion.DataBind();
                }

                if (ds.Tables.Count > 1)
                {
                    ViewState["Curvas"] = ds.Tables[1];
                }
            }
        }





        protected void btnGuardarOperacion_ServerClick(object sender, EventArgs e)
        {
            int idOperacion = string.IsNullOrWhiteSpace(hdnIdOperacion.Value) ? 0 : Convert.ToInt32(hdnIdOperacion.Value);

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(idOperacion == 0 ? "sp_InsertOperation" : "sp_UpdateOperation", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Name", txtNombreOperacion.Text);
                cmd.Parameters.AddWithValue("@IdArea", ddlAreaOperacion.SelectedValue);
                cmd.Parameters.AddWithValue("@OutputTarget", txtOutputTarget.Text);
                cmd.Parameters.AddWithValue("@OutputTargetTraining", txtOutputTargetTraining.Text);

                cmd.Parameters.AddWithValue("@PercentOutput", txtPercentOutput.Text); // este debo agregarse en el .aspx
                cmd.Parameters.AddWithValue("@YieldTarget", txtYieldTarget.Text);
                cmd.Parameters.AddWithValue("@PercentYieldTarget", txtPercentYieldTarget.Text); // este deb oagregarse en el .aspx
                cmd.Parameters.AddWithValue("@LeadTime", txtLeadTime.Text);
                cmd.Parameters.AddWithValue("@NumberDays", txtNumberDays.Text);
                cmd.Parameters.AddWithValue("@Status", ddlEstadoOperacion.SelectedValue);

                if (idOperacion > 0)
                    cmd.Parameters.AddWithValue("@IdOperation", idOperacion);

                conn.Open();
                object result = cmd.ExecuteScalar();
                int newId = idOperacion > 0 ? idOperacion : Convert.ToInt32(result);

                GuardarCurvaAprendizaje(conn, newId);
            }

            CargarOperaciones();
            // Mostrar el toast de éxito
            ScriptManager.RegisterStartupScript(this, this.GetType(), "mostrarToast", "mostrarToastExitoOperacion();", true);
        }
        //Tomado de chatGTP
        [System.Web.Services.WebMethod]
        public static List<object> ObtenerCurvaPorOperacion(int idOperacion)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["TrainingLinkConnection"].ConnectionString;
            List<object> curva = new List<object>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("SELECT Dia, Valor FROM CurvaAprendizaje WHERE IdOperation = @IdOperation", conn))
            {
                cmd.Parameters.AddWithValue("@IdOperation", idOperacion);
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        curva.Add(new { Dia = reader["Dia"], Valor = reader["Valor"] });
                    }
                }
            }

            return curva;
        }


        private void GuardarCurvaAprendizaje(SqlConnection conn, int idOperacion)
        {
            using (SqlCommand deleteCmd = new SqlCommand("sp_DeleteCurvaAprendizaje", conn))
            {
                deleteCmd.CommandType = CommandType.StoredProcedure;
                deleteCmd.Parameters.AddWithValue("@IdOperation", idOperacion);
                deleteCmd.ExecuteNonQuery();
            }

            for (int i = 1; i <= Convert.ToInt32(txtNumberDays.Text); i++)
            {
                string controlId = "inputDia" + i;
                string valor = Request.Form[controlId];
                if (!string.IsNullOrWhiteSpace(valor))
                {
                    using (SqlCommand insertCmd = new SqlCommand("sp_InsertCurvaAprendizaje", conn))
                    {
                        insertCmd.CommandType = CommandType.StoredProcedure;
                        insertCmd.Parameters.AddWithValue("@IdOperation", idOperacion);
                        insertCmd.Parameters.AddWithValue("@Dia", i);
                        insertCmd.Parameters.AddWithValue("@Valor", valor);
                        insertCmd.ExecuteNonQuery();
                    }
                }
            }
        }

        protected void btnEliminarOperacion_ServerClick(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("sp_DeleteOperation", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdOperation", hdnIdOperacion.Value); // asegúrate que este valor no venga vacío
                conn.Open();
                cmd.ExecuteNonQuery(); // 🔥 Esto ahora elimina primero los hijos (CurvaAprendizaje) y luego Operation
            }

            CargarOperaciones(); // Recarga el GridView
        }

    }
}
