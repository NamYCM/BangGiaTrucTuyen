using BangGiaTrucTuyen.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;

namespace BangGiaTrucTuyen
{
    public class MvcApplication : System.Web.HttpApplication
    {
        readonly string connString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            Database.KetNoi();

            try
            {
                SqlDependency.Start(connString);
            }
            catch (Exception)
            {
                //the broker hasn't turned on yet
                Database.ExecSqlNonQuery("ALTER DATABASE THITRUONGCHUNGKHOAN SET ENABLE_BROKER with rollback immediate");
                SqlDependency.Start(connString);
            }

            //update bang gia truc tuyen
            Database.ExecSqlNonQuery("EXEC [dbo].[SP_CAP_NHAP_TAT_CA_GIA_KL_MUA_BAN_BGTT]");
        }
    }
}
