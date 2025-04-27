using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace trainingLink.UI.maintenance.maintenanceArea
{
    public partial class area : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarUnidadesNegocio(); // Carga las unidades de negocio
                ddlFiltroBusinessUnit.SelectedValue = "0"; // Establece "Todos" como el valor seleccionado en el filtro
                CargarAreas(); // Carga las áreas según el filtro inicial
            }
        }

        // Función para cargar los filtros de unidades de negocio
        private void CargarUnidadesNegocio()
        {
            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_GetAllBusinessUnits", conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlFiltroBusinessUnit.DataSource = dt;
                ddlFiltroBusinessUnit.DataTextField = "Name";
                ddlFiltroBusinessUnit.DataValueField = "IdBusinessUnit";
                ddlFiltroBusinessUnit.DataBind();

                // Añadir la opción "Todos" al inicio del DropDownList
                ddlFiltroBusinessUnit.Items.Insert(0, new ListItem("Todos", "0"));
            }
        }


        private void CargarAreas()
        {
            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_SearchArea", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                // Parámetro de búsqueda
                cmd.Parameters.AddWithValue("@Busqueda", txtBuscar.Text.Trim());

                // Filtro por estado
                if (string.IsNullOrEmpty(ddlFiltroStatus.SelectedValue))
                    cmd.Parameters.AddWithValue("@StatusFilter", DBNull.Value);
                else
                    cmd.Parameters.AddWithValue("@StatusFilter", ddlFiltroStatus.SelectedValue);

                // Filtro por unidad de negocio (sin valor "Todos")
                if (ddlFiltroBusinessUnit.SelectedValue != "0" && !string.IsNullOrEmpty(ddlFiltroBusinessUnit.SelectedValue))
                    cmd.Parameters.AddWithValue("@BussinesUnitFilter", ddlFiltroBusinessUnit.SelectedValue);
                else
                    cmd.Parameters.AddWithValue("@BussinesUnitFilter", DBNull.Value);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Asignar los datos a la tabla
                gvAreas.DataSource = dt;
                if (dt.Rows.Count > 0)
                {
                    gvAreas.DataSource = dt;
                    gvAreas.DataBind();
                }
                else
                {
                    // Maneja el caso cuando no hay datos
                    gvAreas.DataSource = null;
                    gvAreas.DataBind();
                }

                gvAreas.DataBind();
            }
        }



        // Evento para cuando se cambia el filtro de estado
        protected void ddlFiltroStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarAreas();
        }

        // Evento para cuando se cambia el filtro de unidad de negocio
        protected void ddlFiltroBusinessUnit_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarAreas();
        }

        // Evento de búsqueda
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            CargarAreas();
        }

        // Guardar o actualizar área
        protected void btnGuardarArea_ServerClick(object sender, EventArgs e)
        {
            string nombreArea = txtNombreArea.Text.Trim();
            string descripcionArea = txtDescripcionArea.Text.Trim();
            string estadoArea = ddlEstadoArea.SelectedValue;
            bool estado = estadoArea == "1";
            string idArea = hdnIdArea.Value;

            string connectionString = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd;

                // Verifica si el id del área existe para actualizar o insertar
                if (!string.IsNullOrEmpty(idArea) && int.TryParse(idArea, out int id))
                {
                    cmd = new SqlCommand("sp_UpdateArea", conn); // Procedimiento para actualizar
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IdArea", id);  // Parámetro para actualizar
                }
                else
                {
                    cmd = new SqlCommand("sp_InsertArea", conn);  // Procedimiento para insertar
                    cmd.CommandType = CommandType.StoredProcedure;
                }

                // Parámetros comunes para insertar o actualizar
                cmd.Parameters.AddWithValue("@Name", nombreArea);
                cmd.Parameters.AddWithValue("@Description", descripcionArea);
                cmd.Parameters.AddWithValue("@Status", estado);

                // Si es necesario, agrega el parámetro de la unidad de negocio (ddlBusinessUnit)
                int unidadNegocio = int.Parse(ddlBusinessUnit.SelectedValue);
                cmd.Parameters.AddWithValue("@IdBussinesUnit", unidadNegocio);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();  // Ejecuta la consulta

                    // Después de la operación, recargar las áreas
                    CargarAreas();

                    // Mostrar un toast de éxito
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "toast", "mostrarToastExitoArea();", true);
                }
                catch (SqlException ex)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alertError", $"alert('Error al guardar área: {ex.Message}');", true);
                }
            }
        }

        // Eliminar área
        protected void btnEliminarArea_ServerClick(object sender, EventArgs e)
        {
            int.TryParse(hdnIdArea.Value, out int idArea);
            if (idArea == 0) return;

            string connStr = ConfigurationManager.ConnectionStrings["trainingLinkConnection"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("sp_DeleteArea", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdArea", idArea);
                conn.Open();
                cmd.ExecuteNonQuery();
                CargarAreas();  // Recargar la tabla de áreas
            }
        }
    }
}
