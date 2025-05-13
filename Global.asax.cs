using System;
using System.Web;

namespace trainingLink
{
    public class Global : HttpApplication
    {
        void Application_AcquireRequestState(object sender, EventArgs e)
        {
            var context = HttpContext.Current;
            if (context != null && context.Session != null)
            {
                if (context.Session["Code1"] == null)
                {
                    var path = context.Request.Path.ToLower();
                    if (!path.EndsWith("login.aspx"))
                    {
                        context.Response.Redirect("~/login.aspx");
                    }
                }
            }
        }
    }
}
