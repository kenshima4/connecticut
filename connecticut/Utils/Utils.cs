using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text.RegularExpressions;

namespace connecticut.Classes
{
    public static class Utils
    {
        public static bool isValidEmail(string email)
        {
            // Use the same regular expression pattern for email validation
            // that you used in the RegularExpressionValidator on the client-side
            string emailPattern = @"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$";
            return Regex.IsMatch(email, emailPattern);
        }
    }
}