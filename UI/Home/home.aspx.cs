using System;
using System.Web.UI;

namespace trainingLink.UI.Home
{
    public partial class Home : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Aquí puedes escribir lógica 









    }


        protected void btnSalir_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/UI/login/login.aspx");
        }




    }
}
