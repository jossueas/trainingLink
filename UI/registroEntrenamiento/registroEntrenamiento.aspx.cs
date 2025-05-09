using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace trainingLink.UI.master
{
    public partial class registroEntrenamiento : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["TrainingLinkConnection"].ConnectionString;
        private string generalDataConnection = System.Configuration.ConfigurationManager.ConnectionStrings["GeneralDataConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarColaboradores();
                CargarOperaciones();
                CargarEntrenadores();
                CargarTurnos();
                CargarTiposEntrenamiento();
                CargarTiposEntrenador();
                ddlEstado.SelectedValue = "1"; // Activo por defecto
                CargarEntrenamientos(); // cargar entrenamientos para seguimiento
                CargarColaboradoresParaRegistro();
            }
        }

        protected void ddlFiltroEstado_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarEntrenamientos();
        }

        protected void btnBuscarEntrenamiento_Click(object sender, EventArgs e)
        {
            CargarEntrenamientos();
        }
        private void CargarColaboradores()
        {
            ddlFiltroColaborador.Items.Clear();
            ddlFiltroColaborador.Items.Add(new ListItem("Todos", ""));

            string query = @"
        SELECT DISTINCT U.Code1, U.FullName
        FROM RegistroEntrenamiento RE
        INNER JOIN GeneralData.dbo.[User] U ON RE.IdUsuario = U.Code1
        ORDER BY U.FullName";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    ddlFiltroColaborador.Items.Add(new ListItem(
                        reader["FullName"].ToString(),
                        reader["Code1"].ToString()
                    ));
                }
            }
        }



        private void CargarColaboradoresParaRegistro()
        {
            ddlColaborador.Items.Clear();
            ddlColaborador.Items.Add(new ListItem("Seleccione un colaborador", ""));

            string query = "SELECT Code1, FullName FROM GeneralData.dbo.[User] ORDER BY FullName";

            using (SqlConnection conn = new SqlConnection(generalDataConnection))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string code1 = reader["Code1"].ToString();
                    string fullName = reader["FullName"].ToString();
                    ddlColaborador.Items.Add(new ListItem(fullName, code1));
                }
            }
        }




        private void CargarOperaciones()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("sp_GetOperaciones", conn))
            {
                ddlOperacion.DataSource = EjecutarDataTable(cmd);
                ddlOperacion.DataTextField = "Name";
                ddlOperacion.DataValueField = "IdOperation";
                ddlOperacion.DataBind();
                ddlOperacion.Items.Insert(0, new ListItem("Seleccione una operación", ""));
            }
        }

        private void CargarEntrenadores()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("sp_GetEntrenadores", conn))
            {
                DataTable dt = EjecutarDataTable(cmd);

                // Para el modal de registro
                ddlEntrenador.DataSource = dt;
                ddlEntrenador.DataTextField = "Nombre";
                ddlEntrenador.DataValueField = "Id";
                ddlEntrenador.DataBind();
                ddlEntrenador.Items.Insert(0, new ListItem("Seleccione un entrenador", ""));

                // Para el filtro de búsqueda
                ddlFiltroEntrenador.DataSource = dt;
                ddlFiltroEntrenador.DataTextField = "Nombre";
                ddlFiltroEntrenador.DataValueField = "Id";
                ddlFiltroEntrenador.DataBind();
                ddlFiltroEntrenador.Items.Insert(0, new ListItem("Todos", ""));
            }
        }


        private void CargarTurnos()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("sp_GetTurnos", conn))
            {
                ddlTurno.DataSource = EjecutarDataTable(cmd);
                ddlTurno.DataTextField = "Name";
                ddlTurno.DataValueField = "IdTurno";
                ddlTurno.DataBind();
                ddlTurno.Items.Insert(0, new ListItem("Seleccione un turno", ""));
            }
        }
        private void CargarTiposEntrenamiento()
        {
            ddlTipoEntrenamiento.Items.Add(new ListItem("Teórico", "1"));   // IdTypeOfTraining = 1
            ddlTipoEntrenamiento.Items.Add(new ListItem("Práctico", "2"));  // IdTypeOfTraining = 2
        }


        private void CargarTiposEntrenador()
        {
            ddlTipoEntrenador.Items.Add(new ListItem("Trainer", "Trainer"));
            ddlTipoEntrenador.Items.Add(new ListItem("Train the trainer", "TrainTheTrainer"));
        }

        private DataTable EjecutarDataTable(SqlCommand cmd)
        {
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        protected void btnGuardarEntrenamiento_Click(object sender, EventArgs e)
        {
            // Validar que el colaborador haya sido seleccionado
            if (string.IsNullOrWhiteSpace(ddlColaborador.SelectedValue))
            {
                throw new Exception("Debe seleccionar un colaborador.");
            }

            // Validar que el estado haya sido seleccionado
            if (String.IsNullOrWhiteSpace(ddlEstado.SelectedValue))
            {
                throw new Exception("Debe seleccionar un estado.");
            }

            // Convertir valores seleccionados a sus tipos correspondientes
            int idColaborador = int.Parse(ddlColaborador.SelectedValue);
            int idOperacion = int.Parse(ddlOperacion.SelectedValue);
            int idEntrenador = int.Parse(ddlEntrenador.SelectedValue);
            int idTurno = int.Parse(ddlTurno.SelectedValue);
            string tipoEntrenamiento = ddlTipoEntrenamiento.SelectedValue;
            string tipoEntrenador = ddlTipoEntrenador.SelectedValue;

            int estado = int.Parse(ddlEstado.SelectedValue);


            // Validar las fechas
            DateTime fechaInicio = DateTime.Parse(txtFechaInicio.Text);
            DateTime fechaFinal = DateTime.Parse(txtFechaFinal.Text);

            // Inserción en la base de datos
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("sp_InsertEntrenamiento", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdColaborador", idColaborador);
                cmd.Parameters.AddWithValue("@IdOperacion", idOperacion);
                cmd.Parameters.AddWithValue("@IdEntrenador", idEntrenador);
                cmd.Parameters.AddWithValue("@IdTurno", idTurno);

                int idTipoEntrenamiento = int.Parse(ddlTipoEntrenamiento.SelectedValue);
                cmd.Parameters.AddWithValue("@IdTipoEntrenamiento", idTipoEntrenamiento);

                cmd.Parameters.AddWithValue("@TipoEntrenador", tipoEntrenador);
                cmd.Parameters.AddWithValue("@Estado", estado);
                cmd.Parameters.AddWithValue("@FechaInicio", fechaInicio);
                cmd.Parameters.AddWithValue("@FechaFinal", fechaFinal);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            // Mostrar un mensaje de éxito (toast)
            ScriptManager.RegisterStartupScript(this, GetType(), "toastEntrenamiento", "mostrarToastExitoEntrenamiento();", true);
        }
     


        private void CargarEntrenamientos()
        {
            string estado = ddlFiltroEstado.SelectedValue;
            string idUsuario = string.IsNullOrEmpty(ddlFiltroColaborador.SelectedValue) ? null : ddlFiltroColaborador.SelectedValue;
            int? idEntrenador = string.IsNullOrEmpty(ddlFiltroEntrenador.SelectedValue) ? (int?)null : int.Parse(ddlFiltroEntrenador.SelectedValue);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetEntrenamientosFiltrados", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Estado", (object)estado ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@IdUsuario", (object)idUsuario ?? DBNull.Value); // string
                    cmd.Parameters.AddWithValue("@IdEntrenador", (object)idEntrenador ?? DBNull.Value);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    DataTable dt = new DataTable();
                    dt.Load(reader);
                


                    dt.Columns.Add("ScriptEditCall", typeof(string));
                    foreach (DataRow row in dt.Rows)
                    {
                        string id = row["IdRegistro"].ToString();
                        string colaborador = row["NombreColaborador"].ToString().Replace("'", "\\'");
                        string operacion = row["NombreOperacion"].ToString().Replace("'", "\\'");
                        string entrenador = row["NombreEntrenador"].ToString().Replace("'", "\\'");
                        string turno = row["NombreTurno"].ToString().Replace("'", "\\'");
                        string tipoEntrenamiento = row["TipoEntrenamiento"].ToString();
                        string tipoEntrenador = row["TipoEntrenador"].ToString();
                        string estadoVal = row["Estado"].ToString();
                        string fechaInicio = Convert.ToDateTime(row["FechaInicio"]).ToString("yyyy-MM-dd");
                        string fechaFinal = Convert.ToDateTime(row["FechaFinal"]).ToString("yyyy-MM-dd");

                        row["ScriptEditCall"] = $"abrirModalEditarEntrenamiento('{id}', '{colaborador}', '{operacion}', '{entrenador}', '{turno}', '{fechaInicio}', '{fechaFinal}', '{tipoEntrenamiento}', '{tipoEntrenador}', '{estadoVal}')";
                    }

                    gvEntrenamientos.DataSource = dt;
                    gvEntrenamientos.DataBind();
                }
            }
        }





    }
}