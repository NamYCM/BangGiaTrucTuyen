using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace BangGiaTrucTuyen.Models
{
    public class SQLDependency
    {
        readonly SqlConnection con = new SqlConnection(System.Web.Configuration.WebConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
        public List<BangGia> GetAllMessages()
        {
            var messages = new List<BangGia>();
            using (var cmd = new SqlCommand(@"SELECT [MACP]
                    , [GIAMUA3], [KLMUA3], [GIAMUA2], [KLMUA2], [GIAMUA1], [KLMUA1]
                    , [GIABAN1], [KLBAN1], [GIABAN2], [KLBAN2], [GIABAN3], [KLBAN3]
                    , [GIAKHOP], [KLKHOP], [TONGKL]
                FROM [dbo].[BANGGIATRUCTUYEN]", con))
            {
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                var dependency = new SqlDependency(cmd);
                dependency.OnChange += new OnChangeEventHandler(Dependency_OnChange);
                DataSet ds = new DataSet();
                da.Fill(ds);
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    messages.Add(item: new BangGia
                    {
                        MaCoPhieu = ds.Tables[0].Rows[i][0].ToString(),
                        GiaMua3 = ds.Tables[0].Rows[i][1].ToString(),
                        SoLuongMua3 = ds.Tables[0].Rows[i][2].ToString(),
                        GiaMua2 = ds.Tables[0].Rows[i][3].ToString(),
                        SoLuongMua2 = ds.Tables[0].Rows[i][4].ToString(),
                        GiaMua1 = ds.Tables[0].Rows[i][5].ToString(),
                        SoLuongMua1 = ds.Tables[0].Rows[i][6].ToString(),
                        GiaBan1 = ds.Tables[0].Rows[i][7].ToString(),
                        SoLuongBan1 = ds.Tables[0].Rows[i][8].ToString(),
                        GiaBan2 = ds.Tables[0].Rows[i][9].ToString(),
                        SoLuongBan2 = ds.Tables[0].Rows[i][10].ToString(),
                        GiaBan3 = ds.Tables[0].Rows[i][11].ToString(),
                        SoLuongBan3 = ds.Tables[0].Rows[i][12].ToString(),
                        GiaKhop = ds.Tables[0].Rows[i][13].ToString(),
                        SoLuongKhop = ds.Tables[0].Rows[i][14].ToString(),
                        TongSo = ds.Tables[0].Rows[i][15].ToString(),
                    });
                }
            }
            return messages;
        }

        private void Dependency_OnChange(object sender, SqlNotificationEventArgs e) //this will be called when any changes occur in db table. 
        {
            if (e.Type == SqlNotificationType.Change)
            {
                MyHub.SendMessages();
            }
        }
    }
}