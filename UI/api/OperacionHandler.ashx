<%@ WebHandler Language="C#" Class="OperacionHandler" %>

using System;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;

public class OperacionHandler : IHttpHandler {
    public void ProcessRequest(HttpContext context) {
        string idOperacion = context.Request.QueryString["idOperacion"];
        string connectionString = ConfigurationManager.ConnectionStrings["TrainingLinkConnection"].ConnectionString;

        int leadTime = 0;
        using (SqlConnection conn = new SqlConnection(connectionString))
        using (SqlCommand cmd = new SqlCommand("SELECT LeadTime FROM Operacion WHERE IdOperation = @Id", conn)) {
            cmd.Parameters.AddWithValue("@Id", idOperacion);
            conn.Open();
            var result = cmd.ExecuteScalar();
            if (result != null) {
                leadTime = Convert.ToInt32(result);
            }
        }

        var json = new JavaScriptSerializer().Serialize(new { leadTime });
        context.Response.ContentType = "application/json";
        context.Response.Write(json);
    }

    public bool IsReusable {
        get { return false; }
    }
}
