using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using trainingLink.UI.maintenance.maintenanceOperacion;

namespace trainingLink.UI.master
{
    public partial class registroEntrenamiento : System.Web.UI.Page
    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["TrainingLinkConnection"].ConnectionString;
        private string generalDataConnection = System.Configuration.ConfigurationManager.ConnectionStrings["GeneralDataConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            int idRegistroHidden;
            if (int.TryParse(hdnIdRegistroSeguimiento.Value, out idRegistroHidden))
            {
                int diasHidden;
                if (int.TryParse(txtDiasEntrenamiento.Text, out diasHidden))
                {
                    GenerarInputsCurva(diasHidden, idRegistroHidden);
                }
            }

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
                CargarTiposEntrenadorDesdeBD();


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
            
            //revisar 
            if (fechaFinal < fechaInicio)
            {
                throw new Exception("La fecha final no puede ser menor que la fecha de inicio.");
            }

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

        private void CargarTiposEntrenadorDesdeBD()
        {
            ddlTipoEntrenador.Items.Clear(); // Limpia si ya había algo

            string query = "SELECT DISTINCT TipoEntrenador FROM Entrenador WHERE TipoEntrenador IS NOT NULL ORDER BY TipoEntrenador";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                ddlTipoEntrenador.Items.Add(new ListItem("Seleccione un tipo", ""));


                while (reader.Read())
                {
                    string tipo = reader["TipoEntrenador"].ToString();
                    ddlTipoEntrenador.Items.Add(new ListItem(tipo, tipo));
                }
            }
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

                        row["ScriptEditCall"] = $"abrirModalSeguimientoEntrenamiento({id}, \"{colaborador}\", \"{operacion}\", \"{entrenador}\", \"{turno}\", \"{fechaInicio}\", \"{fechaFinal}\", \"{tipoEntrenamiento}\", \"{tipoEntrenador}\", \"{estadoVal}\")";
                    }

                    gvEntrenamientos.DataSource = dt;
                    gvEntrenamientos.DataBind();
                }
            }
        }

        [System.Web.Services.WebMethod]
        public static List<object> ObtenerCurvaSeguimiento(int idRegistro)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["TrainingLinkConnection"].ConnectionString;
            List<object> curva = new List<object>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 1. Intentar obtener curva ya registrada
                using (SqlCommand cmd = new SqlCommand("SELECT Dia, Valor FROM CurvaAprendizajeSeguimiento WHERE IdRegistro = @IdRegistro", conn))
                {
                    cmd.Parameters.AddWithValue("@IdRegistro", idRegistro);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            curva.Add(new
                            {
                                Dia = Convert.ToInt32(reader["Dia"]),
                                Valor = Convert.ToInt32(reader["Valor"])
                            });
                        }
                    }
                }

                // 2. Si no hay curva registrada, cargar la cantidad de días desde la operación
                if (curva.Count == 0)
                {
                    using (SqlCommand cmdDias = new SqlCommand(@"
                SELECT DATEDIFF(DAY, FechaInicio, FechaFinal) + 1 AS Dias, IdOperacion
                FROM RegistroEntrenamiento
                WHERE IdRegistro = @IdRegistro", conn))
                    {
                        cmdDias.Parameters.AddWithValue("@IdRegistro", idRegistro);

                        using (SqlDataReader reader = cmdDias.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                int dias = Convert.ToInt32(reader["Dias"]);
                                for (int i = 1; i <= dias; i++)
                                {
                                    curva.Add(new { Dia = i, Valor = 0 });
                                }
                            }
                        }
                    }
                }
            }

            return curva;
        }

        protected void gvEntrenamientos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "VerSeguimiento")
            {
                int idRegistro = Convert.ToInt32(e.CommandArgument);
                hdnIdRegistroSeguimiento.Value = idRegistro.ToString();

                int dias = 0; // declaramos aquí para usarla fuera del reader

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand("sp_GetEntrenamientoDetalle", conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IdRegistro", idRegistro);


                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        // Carga Mudas
                        CargarMudas();
                        if (reader.Read())
                        {
                            txtColaboradorSeguimiento.Text = reader["NombreColaborador"].ToString();
                            txtOperacionSeguimiento.Text = reader["NombreOperacion"].ToString();
                            txtEntrenadorSeguimiento.Text = reader["NombreEntrenador"].ToString();
                            txtTurnoSeguimiento.Text = reader["NombreTurno"].ToString();
                            txtTipoEntrenamientoSeguimiento.Text = reader["TipoEntrenamiento"].ToString();
                            txtHorasEfectivas.Text = reader["HorasEfectivas"]?.ToString();


                            ddlMuda.SelectedValue = reader["IdMuda"]?.ToString();


                            DateTime inicio = Convert.ToDateTime(reader["FechaInicio"]);
                            DateTime fin = Convert.ToDateTime(reader["FechaFinal"]);
                            dias = ((fin - inicio).Days + 1); // ✅ calculamos los días aquí
                            txtDiasEntrenamiento.Text = dias.ToString();

                            string unidadNegocio = reader["UnidadNegocio"].ToString();
                            grupoIGTD.Style["display"] = unidadNegocio == "IGTD" ? "flex" : "none";
                            grupoSRC.Style["display"] = unidadNegocio == "SRC" ? "flex" : "none";
                        }
                    }
                }

               

                //  curva dinámica con los días y el idRegistro
                GenerarInputsCurva(dias, idRegistro);

                // Mostrar el modal con JS
                ScriptManager.RegisterStartupScript(this, GetType(), "abrirModalSeguimiento", @"
    const modal = new bootstrap.Modal(document.getElementById('modalSeguimientoEntrenamiento'));
    modal.show();", true);
            }
        }



        private void CargarMudas()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("SELECT IdMuda, Name FROM Muda WHERE Status = 1 ORDER BY Name", conn))
            {
                conn.Open();
                ddlMuda.Items.Clear();
                ddlMuda.Items.Add(new ListItem("Seleccione una muda", ""));
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ddlMuda.Items.Add(new ListItem(reader["Name"].ToString(), reader["IdMuda"].ToString()));
                    }
                }
            }
        }

        private void GenerarInputsCurva(int dias, int? idRegistro = null)
        {
            phCurvaSeguimiento.Controls.Clear();

            Dictionary<int, int> valoresGuardados = new Dictionary<int, int>();

            if (idRegistro.HasValue)
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Paso 1: Obtener el IdOperacion desde RegistroEntrenamiento
                    int idOperacion = 0;
                    using (SqlCommand cmdOperacion = new SqlCommand("SELECT IdOperacion FROM RegistroEntrenamiento WHERE IdRegistro = @IdRegistro", conn))
                    {
                        cmdOperacion.Parameters.AddWithValue("@IdRegistro", idRegistro.Value);
                        object result = cmdOperacion.ExecuteScalar();
                        if (result != null)
                        {
                            idOperacion = Convert.ToInt32(result);
                        }
                    }

                    // Paso 2: Obtener la curva desde CurvaAprendizajeSeguimiento
                    // Paso 2: Obtener la curva desde CurvaAprendizajeSeguimiento
                    using (SqlCommand cmd = new SqlCommand("SELECT Dia, Valor FROM CurvaAprendizajeSeguimiento WHERE IdEntrenamiento = @IdEntrenamiento", conn))
                    {
                        cmd.Parameters.AddWithValue("@IdEntrenamiento", idRegistro.Value);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                int dia = Convert.ToInt32(reader["Dia"]);
                                int valor = Convert.ToInt32(reader["Valor"]);
                                valoresGuardados[dia] = valor;
                            }
                        }
                    }
                }
            }

            // Generación de inputs visuales 
            for (int i = 1; i <= dias; i++)
            {
                Panel panel = new Panel { CssClass = "col-md-3 mb-2" };

                Label lbl = new Label { Text = $"Día {i}:", CssClass = "form-label" };
                TextBox txt = new TextBox
                {
                    ID = $"inputSeguimientoDia{i}", // CORREGIDO
                    CssClass = "form-control",
                    Text = valoresGuardados.ContainsKey(i) ? valoresGuardados[i].ToString() : "0"
                };

                panel.Controls.Add(lbl);
                panel.Controls.Add(txt);
                phCurvaSeguimiento.Controls.Add(panel);
            }

        }


        protected void btnGuardarSeguimiento_Click(object sender, EventArgs e)
        {
            int idRegistro = int.Parse(hdnIdRegistroSeguimiento.Value);
            int totalDias = int.Parse(txtDiasEntrenamiento.Text);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                //Pasos en el metodo para tener claro como esta trabajando

                // 1. Actualizar HorasEfectivas
                using (SqlCommand cmd = new SqlCommand("UPDATE RegistroEntrenamiento SET HorasEfectivas = @Horas WHERE IdRegistro = @Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Horas", txtHorasEfectivas.Text);
                    cmd.Parameters.AddWithValue("@Id", idRegistro);
                    cmd.ExecuteNonQuery();
                }

                // Obtener IdOperacion
                int idOperacion = 0;
                using (SqlCommand cmd = new SqlCommand("SELECT IdOperacion FROM RegistroEntrenamiento WHERE IdRegistro = @Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", idRegistro);
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                        idOperacion = Convert.ToInt32(result);
                }

                // 2. Insertar o actualizar curva

                for (int i = 1; i <= totalDias; i++)
                {
                    TextBox input = phCurvaSeguimiento.FindControl("inputSeguimientoDia" + i) as TextBox;

                    if (input == null)
                    {
                        System.Diagnostics.Debug.WriteLine("No se encontró el input para Día " + i);
                        continue;
                    }

                    if (string.IsNullOrWhiteSpace(input.Text)) continue;

                    decimal valor;
                    if (!decimal.TryParse(input.Text, out valor)) valor = 0;

                    string checkQuery = @"SELECT COUNT(*) FROM CurvaAprendizajeSeguimiento WHERE IdEntrenamiento = @IdEntrenamiento AND Dia = @Dia";
                    using (SqlCommand check = new SqlCommand(checkQuery, conn))
                    {
                        check.Parameters.AddWithValue("@IdEntrenamiento", idRegistro);
                        check.Parameters.AddWithValue("@Dia", i);
                        int count = (int)check.ExecuteScalar();

                        if (count > 0)
                        {
                            using (SqlCommand update = new SqlCommand(@"
    UPDATE CurvaAprendizajeSeguimiento 
    SET Valor = @Valor 
    WHERE IdEntrenamiento = @IdEntrenamiento AND Dia = @Dia", conn))
                            {
                                update.Parameters.AddWithValue("@Valor", valor);
                                update.Parameters.AddWithValue("@IdEntrenamiento", idRegistro);
                                update.Parameters.AddWithValue("@Dia", i);
                                update.ExecuteNonQuery();
                            }

                        }
                        else
                        {
                            using (SqlCommand insert = new SqlCommand(@"
    INSERT INTO CurvaAprendizajeSeguimiento (IdEntrenamiento, IdOperation, Dia, Valor)
    VALUES (@IdEntrenamiento, @IdOperacion, @Dia, @Valor)", conn))
                            {
                                insert.Parameters.AddWithValue("@IdEntrenamiento", idRegistro);
                                insert.Parameters.AddWithValue("@IdOperacion", idOperacion);
                                insert.Parameters.AddWithValue("@Dia", i);
                                insert.Parameters.AddWithValue("@Valor", valor);
                                insert.ExecuteNonQuery();
                            }

                        }
                    }
                }


                // 3. Insertar o actualizar seguimiento
                string fechaHoy = DateTime.Now.ToString("yyyy-MM-dd");
                string checkSeguimiento = @"
            SELECT COUNT(*) FROM Seguimiento
            WHERE IdEntrenamiento = @IdEntrenamiento AND DiaEntrenamiento = 1 AND CONVERT(date, Fecha) = @Fecha";

                using (SqlCommand check = new SqlCommand(checkSeguimiento, conn))
                {
                    check.Parameters.AddWithValue("@IdEntrenamiento", idRegistro);
                    check.Parameters.AddWithValue("@Fecha", DateTime.Today);

                    bool existe = ((int)check.ExecuteScalar()) > 0;
                    int objetivo = CalcularObjetivoDia(idRegistro, conn);

                    if (existe)
                    {
                        using (SqlCommand update = new SqlCommand(@"
                    UPDATE Seguimiento SET Buenas = @Buenas, Malas = @Malas, Stage = @Stage, 
                        IdMuda = @IdMuda, CantObjetivoDiaEntrenamiento = @Objetivo
                    WHERE IdEntrenamiento = @IdEntrenamiento AND DiaEntrenamiento = 1 AND CONVERT(date, Fecha) = @Fecha", conn))
                        {
                            update.Parameters.AddWithValue("@Buenas", string.IsNullOrWhiteSpace(txtBuenasIGTD.Text) ? (object)DBNull.Value : txtBuenasIGTD.Text);
                            update.Parameters.AddWithValue("@Malas", string.IsNullOrWhiteSpace(txtMalasIGTD.Text) ? (object)DBNull.Value : txtMalasIGTD.Text);
                            update.Parameters.AddWithValue("@Stage", ddlStageSRC.SelectedValue ?? (object)DBNull.Value);
                            update.Parameters.AddWithValue("@IdMuda", ddlMuda.SelectedValue);
                            update.Parameters.AddWithValue("@Objetivo", objetivo);
                            update.Parameters.AddWithValue("@IdEntrenamiento", idRegistro);
                            update.Parameters.AddWithValue("@Fecha", DateTime.Today);
                            update.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        using (SqlCommand insert = new SqlCommand(@"
                    INSERT INTO Seguimiento (IdEntrenamiento, Buenas, Malas, Stage, Fecha, DiaEntrenamiento, IdMuda, CantObjetivoDiaEntrenamiento)
                    VALUES (@IdEntrenamiento, @Buenas, @Malas, @Stage, @Fecha, @Dia, @IdMuda, @Objetivo)", conn))
                        {
                            insert.Parameters.AddWithValue("@IdEntrenamiento", idRegistro);
                            insert.Parameters.AddWithValue("@Buenas", string.IsNullOrWhiteSpace(txtBuenasIGTD.Text) ? (object)DBNull.Value : txtBuenasIGTD.Text);
                            insert.Parameters.AddWithValue("@Malas", string.IsNullOrWhiteSpace(txtMalasIGTD.Text) ? (object)DBNull.Value : txtMalasIGTD.Text);
                            insert.Parameters.AddWithValue("@Stage", ddlStageSRC.SelectedValue ?? (object)DBNull.Value);
                            insert.Parameters.AddWithValue("@Fecha", DateTime.Today);
                            insert.Parameters.AddWithValue("@Dia", 1);
                            insert.Parameters.AddWithValue("@IdMuda", ddlMuda.SelectedValue);
                            insert.Parameters.AddWithValue("@Objetivo", objetivo);
                            insert.ExecuteNonQuery();
                        }
                    }
                }

                // Feedback visual
                CargarEntrenamientos();
                ScriptManager.RegisterStartupScript(this, GetType(), "cerrarModal", "const modal = new bootstrap.Modal(document.getElementById('modalSeguimientoEntrenamiento')); modal.hide();", true);
                ScriptManager.RegisterStartupScript(this, GetType(), "toastSeguimiento", "mostrarToastExitoEntrenamiento();", true);
            }
        }




        private int CalcularObjetivoDia(int idRegistro, SqlConnection conn)
        {
            using (SqlCommand cmd = new SqlCommand("SELECT SUM(Valor) FROM CurvaAprendizajeSeguimiento WHERE IdEntrenamiento = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Id", idRegistro);
                object result = cmd.ExecuteScalar();
                return result != DBNull.Value ? Convert.ToInt32(result) : 0;
            }
        }






















    }
}