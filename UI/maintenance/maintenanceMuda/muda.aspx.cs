﻿using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace trainingLink.UI.maintenance.maintenanceMuda
{
    public partial class muda : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string code1 = Session["Code1"]?.ToString();
                var permisos = PermisoHelper.ObtenerMenuKeysParaUsuario(code1);

                linkInicio.Visible = true;
                linkAccesos.Visible = permisos.Contains("acceso");
                linkRegistroEntrenamiento.Visible = permisos.Contains("registroEntrenamiento");
                linkRol.Visible = permisos.Contains("rol");
                linkBusinessUnit.Visible = permisos.Contains("businessUnit");
                linkTurno.Visible = permisos.Contains("turno");
                linkMuda.Visible = permisos.Contains("muda");
                linkArea.Visible = permisos.Contains("area");
                linkScrap.Visible = permisos.Contains("scrap");
                linkOperacion.Visible = permisos.Contains("operacion");

                // Comentados pero listos
                linkEntrenadores.Visible = permisos.Contains("entrenadores");
                // linkEntrenamientos.Visible = permisos.Contains("entrenamientos");

                btnSalir.Visible = true; // Siempre visible
                CargarMudas();
            }
        }

        protected void ddlFiltroStatusMuda_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarMudas();
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            CargarMudas();
        }

        private void CargarMudas()
        {
            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_SearchMuda", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Busqueda", txtBuscar.Text.Trim());
                cmd.Parameters.AddWithValue("@StatusFilter", string.IsNullOrEmpty(ddlFiltroStatusMuda.SelectedValue) ? (object)DBNull.Value : ddlFiltroStatusMuda.SelectedValue);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvMuda.DataSource = dt;
                gvMuda.DataBind();
            }
        }

        protected void btnGuardarMuda_ServerClick(object sender, EventArgs e)
        {
            string nombre = txtNombreMuda.Text.Trim();
            bool status = ddlEstadoMuda.SelectedValue == "1";
            string idMuda = hdnIdMuda.Value;

            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd;

                if (!string.IsNullOrEmpty(idMuda) && int.TryParse(idMuda, out int id))
                {
                    cmd = new SqlCommand("sp_UpdateMuda", conn);
                    cmd.Parameters.AddWithValue("@IdMuda", id);
                }
                else
                {
                    cmd = new SqlCommand("sp_InsertMuda", conn);
                }

                cmd.Parameters.AddWithValue("@Name", nombre);
                cmd.Parameters.AddWithValue("@Status", status);

                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    CargarMudas();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "toast", "mostrarToastExitoMuda();", true);
                }
                catch (Exception ex)
                {
                    throw new Exception("Error al guardar/actualizar la muda: " + ex.Message);
                }
            }
        }

        protected void btnEliminarMuda_ServerClick(object sender, EventArgs e)
        {
            int.TryParse(hdnIdMuda.Value, out int idMuda);
            if (idMuda == 0) return;

            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_DeleteMuda", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdMuda", idMuda);
                conn.Open();
                cmd.ExecuteNonQuery();
                CargarMudas();
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
