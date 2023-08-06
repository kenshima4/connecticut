using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Diagnostics;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Drawing;
using System.Web.UI.WebControls;

namespace connecticut.Classes
{
    public class ClientCodeGenerator
    {
        public Dictionary<string, int> dictAllCodes;
        SqlConnection myCon = new SqlConnection(ConfigurationManager.ConnectionStrings["DBConnection"].ConnectionString);

        public ClientCodeGenerator() {
            dictAllCodes = new Dictionary<string, int>();
        }

        public void GetAllCodes() {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.GetClientCodes", myCon))
                {
                    myCom.Connection = myCon;
                    myCom.CommandType = CommandType.StoredProcedure;

                    SqlDataReader myDr = myCom.ExecuteReader();

                    while (myDr.Read()) {

                        string code = (string)myDr["ClientCode"];
                        var tuple = GetCodeParts(code);
                        dictAllCodes[tuple.Item1] = tuple.Item2;

                    }

                    myDr.Close();
                }
            }
            catch (Exception ex) {
                Debug.WriteLine(ex);
            }
            finally { myCon.Close(); }
        }

        

        public string GenerateClientCode(string name)        
        {
            GetAllCodes();
            string code = "";
            //trim end and start
            name = name.TrimEnd();
            name = name.TrimStart();

            //case 1: pad with AB
            if (name.Length == 1)
            {
                code += name[0];
                code += "A";
                code += "B";
            }

            //case 2: pad with A
            else if (name.Length == 2)
            {
                code += name[0];
                code += name[1];
                code += "A";
            }

            while (code.Length < 3) {
                
                string[] strSplit = name.Split(' ');
                
                //case3: has whitespace - loop through split string
                int lastPlace = -1;
                for (int i = 0; i < (strSplit.Length); i++)
                {
                    if (code.Length == 3) { break; }
                    //get first char
                    code += strSplit[i][0];
                    //keep track of place
                    lastPlace++;

                }
                
                
                //case4: has no whitespace - loop through chars
                for (int i = lastPlace; i < name.Length; i++)
                {
                    if (code.Length == 3) { break; }
                    //start after current place
                    code += strSplit[lastPlace][i + 1];

                }
                
                
                
                
                
            }

            return code.ToString().ToUpper();
        }

        // Method to get the unique numeric part of the client code
        public string AddUniqueNumericPart(string code)
        {
            //if no key add it
            if (!dictAllCodes.ContainsKey(code)) {
                dictAllCodes.Add(code, 1);
                return code + PadNumbers(1);
            }

            int numericPart = dictAllCodes[code];
            numericPart++;

            dictAllCodes[code] = numericPart;
            return code + PadNumbers(numericPart);
        }

        private string PadNumbers(int number) {

            //at least one char
            string paddedNumber = number.ToString("D3");
            return paddedNumber;
        }

        private static Tuple<string, int> GetCodeParts(string clientCode)
        {

            //get code
            string code = clientCode.Substring(0, 3);
            //get int part
            int num = Int32.Parse(clientCode.Substring(3, 3));

            return Tuple.Create(code, num);

        }

    }
}