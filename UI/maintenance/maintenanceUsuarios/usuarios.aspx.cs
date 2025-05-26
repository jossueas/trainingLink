using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace trainingLink.UI.maintenance.maintenanceUsuario
{
    public partial class usuario : System.Web.UI.Page

    {
        private string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["TrainingLinkConnection"].ConnectionString;
        private string generalDataConnection = System.Configuration.ConfigurationManager.ConnectionStrings["GeneralDataConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCode1DesdeGeneral();
                CargarRoles();
                CargarUsuarios();
            }
        }
        private void CargarCode1DesdeGeneral()
        {
            string query = @"
        SELECT 
            Code1, 
            FullName, 
            (Code1 + ' - ' + FullName) AS Display
        FROM GeneralData.dbo.[User]
        ORDER BY FullName";

            using (SqlConnection conn = new SqlConnection(generalDataConnection))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                ddlCode1.DataSource = reader;
                ddlCode1.DataTextField = "Display";     // Lo que se ve
                ddlCode1.DataValueField = "Code1";      // Lo que se guarda
                ddlCode1.DataBind();
            }

            ddlCode1.Items.Insert(0, new ListItem("Seleccione un colaborador", ""));
        }



        private void CargarRoles()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT IdRol, Name FROM Role", conn);
                conn.Open();
                ddlRol.DataSource = cmd.ExecuteReader();
                ddlRol.DataValueField = "IdRol";   // Este campo es el que uso en JS para asignar
                ddlRol.DataTextField = "Name";
                ddlRol.DataBind();
            }

            ddlRol.Items.Insert(0, new ListItem("Seleccione un rol", ""));
        }


        private void CargarUsuarios()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("sp_GetUsuarios", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(reader);
                gvUsuarios.DataSource = dt;
                gvUsuarios.DataBind();
            }
        }

        protected void ddlCode1_SelectedIndexChanged(object sender, EventArgs e)
        {
            string code1 = ddlCode1.SelectedValue;
            string query = "SELECT FullName FROM GeneralData.dbo.[User] WHERE Code1 = @Code1";
            using (SqlConnection conn = new SqlConnection(generalDataConnection))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Code1", code1);
                conn.Open();
                txtNombreUsuario.Text = cmd.ExecuteScalar()?.ToString();
            }
        }

        protected void btnGuardarUsuario_Click(object sender, EventArgs e)
        {
            int idUsuario = string.IsNullOrEmpty(hdnIdUsuario.Value) ? 0 : int.Parse(hdnIdUsuario.Value);
            string code1 = ddlCode1.SelectedValue;
            string nombre = txtNombreUsuario.Text;
            int idRol = int.Parse(ddlRol.SelectedValue);
            int status = int.Parse(ddlEstadoUsuario.SelectedValue);


            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(idUsuario == 0 ? "sp_InsertUsuario" : "sp_UpdateUsuario", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Code1", code1);
                cmd.Parameters.AddWithValue("@Nombre", nombre);
                cmd.Parameters.AddWithValue("@IdRol", idRol);
                cmd.Parameters.AddWithValue("@Status", status);


                if (idUsuario != 0)
                    cmd.Parameters.AddWithValue("@IdUsuario", idUsuario);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            CargarUsuarios();
        }

        public void RaisePostBackEvent(string eventArgument)
        {
            if (Page.Request["__EVENTTARGET"] == "EliminarUsuario")
            {
                int idUsuario = int.Parse(eventArgument);
                using (SqlConnection conn = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand("sp_DeleteUsuario", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IdUsuario", idUsuario);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                CargarUsuarios();
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
