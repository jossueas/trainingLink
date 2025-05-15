using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

public static class PermisoHelper
{
    public static List<string> ObtenerMenuKeysParaUsuario(string code1)
    {
        var permisos = new List<string>();
        string connectionString = ConfigurationManager.ConnectionStrings["TrainingLinkConnection"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            string query = "SELECT MenuKey FROM PermisoUsuario WHERE Code1 = @Code1 AND PuedeVer = 1";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Code1", code1);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    permisos.Add(reader["MenuKey"].ToString());
                }
            }
        }

        return permisos;
    }
}
