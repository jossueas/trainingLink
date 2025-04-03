using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace trainingLink.UI.login
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string code1 = txtCode1.Text.Trim();

            if (string.IsNullOrEmpty(code1))
            {
                // Muestra un mensaje si está vacío
                Response.Write("<script>alert('Por favor ingrese el código.');</script>");
                return;
            }

            // Obtiene la cadena de conexión desde Web.config
            string connString = ConfigurationManager.ConnectionStrings["GeneralDataConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT COUNT(*) FROM [User] WHERE Code1 = @Code1";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Code1", code1);

                try
                {
                    conn.Open();
                    int count = (int)cmd.ExecuteScalar();

                    if (count > 0)
                    {
                        // Usuario encontrado: redireccionar o hacer login
                        Response.Redirect("~/UI/dashboard/index.aspx");
                    }
                    else
                    {
                        // Usuario no encontrado
                        Response.Write("<script>alert('Código no válido.');</script>");
                    }
                }
                catch (Exception ex)
                {
                    // Manejo de errores (log opcional)
                    Response.Write($"<script>alert('Error al conectar: {ex.Message}');</script>");
                }
            }
        }
    }
}
