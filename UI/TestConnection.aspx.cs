using System;
using System.Configuration;
using System.Data.SqlClient;

namespace trainingLink.UI
{
    public partial class TestConnection : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblResultado.Text = "Esperando prueba...";

            try
            {
                string connString = ConfigurationManager.ConnectionStrings["GeneralDataConnection"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    lblResultado.Text = "✅ Conexión exitosa a la base de datos.";
                    lblResultado.Text += "<br/><small>Connection string: " + conn.ConnectionString + "</small>";
                }
            }
            catch (Exception ex)
            {
                lblResultado.Text = "❌ Error al conectar: " + ex.Message;
                lblResultado.Text += "<br/><small>Connection string: " + ConfigurationManager.ConnectionStrings["GeneralDataConnection"].ConnectionString + "</small>";
            }
        }
    }
}
