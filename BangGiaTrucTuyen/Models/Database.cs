using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace BangGiaTrucTuyen.Models
{
    public static class Database
    {
        public static SqlConnection conn = new SqlConnection();
        static readonly string connstr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

        public static void KetNoi()
        {
            if (conn != null && conn.State == ConnectionState.Open)
                conn.Close();

            conn.ConnectionString = connstr;
            conn.Open();
        }

        public static void ExecSqlNonQuery(String strLenh)
        {
            SqlCommand sqlcmd = new SqlCommand(strLenh, conn)
            {
                CommandType = CommandType.Text,
                CommandTimeout = 600
            };
            if (conn.State == ConnectionState.Closed) conn.Open();
            
            sqlcmd.ExecuteNonQuery();
            conn.Close();
        }
    }
}