using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

using System;
using System.Linq;

namespace trainingLink.UI.maintenance.maintenanceBusinessUnit
{
    public partial class businessUnit : Page
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
                // linkEntrenadores.Visible = permisos.Contains("entrenadores");
                // linkEntrenamientos.Visible = permisos.Contains("entrenamientos");

                btnSalir.Visible = true; // Siempre visible
                CargarBusinessUnits(); // Cargar unidades de negocio al inicio
                                       // CargarOpcionesSelect2(); // llamada para llenar el DropDownList



                // Mostrar toast si corresponde
                if (Session["BusinessUnitSuccess"] != null)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "toast", "mostrarToastExitoBusinessUnit();", true);
                    Session.Remove("BusinessUnitSuccess");
                }

                if (Session["BusinessUnitDeleted"] != null)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "toast", "mostrarToastEliminadoBusinessUnit();", true);
                    Session.Remove("BusinessUnitDeleted");
                }




            }
        }


        // Función que se ejecuta al cambiar el filtro de estado
        protected void ddlFiltroStatusBusinessUnit_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarBusinessUnits();
        }
        protected void ddlFiltroStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Reload the business units based on the selected filter
            CargarBusinessUnits();
        }





        // Función de búsqueda por nombre o descripción
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
         

            CargarBusinessUnits();
        }


      

        // Función para cargar las unidades de negocio
        private void CargarBusinessUnits()
        {
            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_SearchBusinessUnit", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Busqueda", txtBuscar.Text.Trim());

                if (string.IsNullOrEmpty(ddlFiltroStatusBusinessUnit.SelectedValue))
                    cmd.Parameters.AddWithValue("@StatusFilter", DBNull.Value);
                else
                    cmd.Parameters.AddWithValue("@StatusFilter", ddlFiltroStatusBusinessUnit.SelectedValue);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

              

                gvBusinessUnit.DataSource = dt;
                gvBusinessUnit.DataBind();
            }
        }
        /*
        private void CargarOpcionesSelect2()
        {
            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_GetBusinessUnitNames", conn); /
                cmd.CommandType = CommandType.StoredProcedure;

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlBuscarNombre.DataSource = dt;
                ddlBuscarNombre.DataTextField = "Name";   // asegúrate de que la columna se llame 'Name'
                ddlBuscarNombre.DataValueField = "IdBusinessUnit"; /
                ddlBuscarNombre.DataBind();

                ddlBuscarNombre.Items.Insert(0, new ListItem("Seleccione...", ""));
            }
        }

        */


        // Función para guardar o actualizar unidad de negocio
        protected void btnGuardarBusinessUnit_ServerClick(object sender, EventArgs e)
        {
            string nombre = txtNombreBusinessUnit.Text.Trim();
            bool status = ddlEstadoBusinessUnit.SelectedValue == "1";
            string idBusinessUnit = hdnIdBusinessUnit.Value;

            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd;

                if (!string.IsNullOrEmpty(idBusinessUnit) && int.TryParse(idBusinessUnit, out int id))
                {
                    cmd = new SqlCommand("sp_UpdateBusinessUnit", conn);
                    cmd.Parameters.AddWithValue("@IdBusinessUnit", id);
                }
                else
                {
                    cmd = new SqlCommand("sp_InsertBusinessUnit", conn);
                }

                cmd.Parameters.AddWithValue("@Name", nombre);
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    // Guardamos bandera de éxito para mostrar el toast tras redirección
                    Session["BusinessUnitSuccess"] = true;

                    // Redirigir para evitar repost
                    Response.Redirect(Request.RawUrl, false);
                    Context.ApplicationInstance.CompleteRequest();
                }
                catch (Exception ex)
                {
                    throw new Exception("Error al guardar/actualizar la unidad de negocio: " + ex.Message);
                }
            }
        }


        // Eliminar unidad de negocio
        protected void btnEliminarBusinessUnit_ServerClick(object sender, EventArgs e)
        {
            int.TryParse(hdnIdBusinessUnit.Value, out int idBusinessUnit);
            if (idBusinessUnit == 0) return;

            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_DeleteBusinessUnit", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdBusinessUnit", idBusinessUnit);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    Session["BusinessUnitDeleted"] = true;
                    Response.Redirect(Request.RawUrl, false);
                    Context.ApplicationInstance.CompleteRequest();
                }
                catch (Exception ex)
                {
                    throw new Exception("Error al eliminar la unidad de negocio: " + ex.Message);
                }
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
