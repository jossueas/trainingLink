using System;
using System.Data;
using System.Data.SqlClient;
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
            }
        }
private void CargarColaboradores()
{
    using (SqlConnection conn = new SqlConnection(generalDataConnection))
    {
        using (SqlCommand cmd = new SqlCommand("sp_GetColaboradores", conn))
        {
            ddlColaborador.DataSource = EjecutarDataTable(cmd);
            ddlColaborador.DataTextField = "Nombre";
            ddlColaborador.DataValueField = "Id";
            ddlColaborador.DataBind();
            ddlColaborador.Items.Insert(0, new ListItem("Seleccione un colaborador", ""));
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
                ddlEntrenador.DataSource = EjecutarDataTable(cmd);
                ddlEntrenador.DataTextField = "Nombre";
                ddlEntrenador.DataValueField = "Id";
                ddlEntrenador.DataBind();
                ddlEntrenador.Items.Insert(0, new ListItem("Seleccione un entrenador", ""));
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
            if (string.IsNullOrWhiteSpace(ddlColaborador.SelectedValue))
            {
                // Puedes mostrar un mensaje al usuario o lanzar una excepción controlada
                throw new Exception("Debe seleccionar un colaborador.");
            }

            int idColaborador = int.Parse(ddlColaborador.SelectedValue);  
            
            int idOperacion = int.Parse(ddlOperacion.SelectedValue);
            int idEntrenador = int.Parse(ddlEntrenador.SelectedValue);
            int idTurno = int.Parse(ddlTurno.SelectedValue);
            string tipoEntrenamiento = ddlTipoEntrenamiento.SelectedValue;
            string tipoEntrenador = ddlTipoEntrenador.SelectedValue;
            bool estado = ddlEstado.SelectedValue == "1";
            DateTime fechaInicio = DateTime.Parse(txtFechaInicio.Text);
            DateTime fechaFinal = DateTime.Parse(txtFechaFinal.Text);

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
        }
    }
}