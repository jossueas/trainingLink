using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace trainingLink.UI.login
{
    public partial class Login : Page
    {
        // Este método se ejecuta cada vez que se carga la página
        protected void Page_Load(object sender, EventArgs e)
        {
            // Aquí podria  poner validaciones si es la primera carga (if !IsPostBack)
        }

        // Evento que se dispara cuando se hace clic en el botón "Ingresar"
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string code1 = txtCode1.Text.Trim();

            if (string.IsNullOrEmpty(code1))
            {
                lblResultado.Text = "Por favor ingrese el código.";
                lblResultado.CssClass = "alert alert-warning d-block";
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["GeneralDataConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT Code1, FullName FROM [User] WHERE Code1 = @Code1";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Code1", code1);

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // ✅ GUARDAR EN SESIÓN
                        Session["Code1"] = reader["Code1"].ToString();
                        Session["FullName"] = reader["FullName"].ToString(); // Opcional, si necesitas mostrar nombre

                        lblResultado.Text = "Inicio de sesión exitoso. Redirigiendo...";
                        lblResultado.CssClass = "alert alert-success d-block";

                        // Redirigir con JavaScript
                        string script = "<script>setTimeout(function() { window.location.href = '/UI/Home/home.aspx'; }, 1500);</script>";
                        Page.ClientScript.RegisterStartupScript(this.GetType(), "RedirectScript", script);
                    }
                    else
                    {
                        lblResultado.Text = "Credenciales incorrectas.";
                        lblResultado.CssClass = "alert alert-danger d-block";
                    }
                }
                catch (Exception ex)
                {
                    lblResultado.Text = "Error al conectar: " + ex.Message;
                    lblResultado.CssClass = "alert alert-danger d-block";
                }
            }
        }

    }

}
