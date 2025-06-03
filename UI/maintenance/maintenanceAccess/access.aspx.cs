using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace trainingLink.UI.maintenance.maintenanceAccess
{
    public partial class access : Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["TrainingLinkConnection"].ConnectionString;
        string connectionStringGeneralData = ConfigurationManager.ConnectionStrings["GeneralDataConnection"].ConnectionString;

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
                linkEntrenador.Visible = permisos.Contains("entrenadores");
                // linkEntrenamientos.Visible = permisos.Contains("entrenamientos");

                btnSalir.Visible = true; // Siempre visible

                CargarUsuariosModal(); // ddlCode1
                CargarModulos();       // ddlMenuKey
                CargarUsuarios();      // filtro principal
                CargarPermisos();      // tabla
            }
        }

        protected void ddlUsuarios_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarPermisos();
        }

 


        protected void btnGuardarPermiso_Click(object sender, EventArgs e)
        {
            string idPermiso = hdnIdPermiso.Value;
            string code1 = ddlCode1.SelectedValue;
            string menuKey = ddlMenuKey.SelectedValue;
            bool puedeVer = Request.Form["chkPuedeVer"] == "on";


            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                if (string.IsNullOrEmpty(idPermiso))
                {
                    // INSERTAR
                    using (SqlCommand cmd = new SqlCommand("sp_InsertPermiso", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@Code1", code1);
                        cmd.Parameters.AddWithValue("@MenuKey", menuKey);
                        cmd.Parameters.AddWithValue("@PuedeVer", puedeVer);
                        cmd.ExecuteNonQuery();
                    }
                    // Toast + reset
                    ScriptManager.RegisterStartupScript(this, GetType(), "toastYlimpiar", "mostrarToastYLimpiarPermiso();", true);
                }
                else
                {
                    // ACTUALIZAR
                    using (SqlCommand cmd = new SqlCommand("sp_UpdatePermiso", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@IdPermiso", int.Parse(idPermiso));
                        cmd.Parameters.AddWithValue("@PuedeVer", puedeVer);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            // Refrescar la tabla y cerrar modal
            CargarPermisos();

            // Registrar JS para cerrar el modal visualmente

            ScriptManager.RegisterStartupScript(this, GetType(), "toastActualizado", "mostrarToastExitoAcceso('Permiso actualizado exitosamente'); cerrarModalPermiso();", true);

        }

        private void CargarUsuarios()
        {
            using (SqlConnection conn = new SqlConnection(connectionStringGeneralData))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT Code1, FullName FROM [User] ORDER BY FullName", conn);
                ddlUsuarios.DataSource = cmd.ExecuteReader(); // ✅ corregido
                ddlUsuarios.DataTextField = "FullName";
                ddlUsuarios.DataValueField = "Code1";
                ddlUsuarios.DataBind();
            }
            ddlUsuarios.Items.Insert(0, new ListItem("Seleccione un usuario", ""));
        }
        private void CargarModulos()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT MenuKey, NombreMostrar FROM Menu ORDER BY NombreMostrar", conn);
                ddlMenuKey.DataSource = cmd.ExecuteReader();
                ddlMenuKey.DataTextField = "NombreMostrar";
                ddlMenuKey.DataValueField = "MenuKey";
                ddlMenuKey.DataBind();
            }
            ddlMenuKey.Items.Insert(0, new ListItem("Seleccione un módulo", ""));
        }



        private void CargarUsuariosModal()
        {
            using (SqlConnection conn = new SqlConnection(connectionStringGeneralData))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT Code1, FullName FROM [User] ORDER BY FullName", conn))
                {
                    ddlCode1.DataSource = cmd.ExecuteReader();
                    ddlCode1.DataTextField = "FullName";
                    ddlCode1.DataValueField = "Code1";
                    ddlCode1.DataBind();
                }
                ddlCode1.Items.Insert(0, new ListItem("Seleccione un usuario", ""));
            }
        }



        private void CargarPermisos()
        {
            string code1 = ddlUsuarios.SelectedValue;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetPermisos", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Code1", string.IsNullOrEmpty(code1) ? (object)DBNull.Value : code1);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvPermisos.DataSource = dt;
                    gvPermisos.DataBind();
                }
            }
        }

        protected void btnEliminarPermiso_Click(object sender, EventArgs e)
        {
            string idPermiso = hdnIdPermiso.Value;

            if (!string.IsNullOrEmpty(idPermiso))
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand("sp_DeletePermiso", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@IdPermiso", int.Parse(idPermiso));
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            CargarPermisos();

            // Cierra modal + muestra toast
            ScriptManager.RegisterStartupScript(this, GetType(), "cerrarModalPermiso", "cerrarModalPermiso();", true);
            MostrarToastExitoEliminacion();
        }







        private void MostrarToastExitoEliminacion()
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "toastEliminado", "mostrarToastExitoPermiso('Permiso eliminado correctamente');", true);
        }





        protected void btnSalir_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/UI/Login/Login.aspx");
        }








    }
}
