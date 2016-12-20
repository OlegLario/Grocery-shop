using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Grocery.Models
{
    public class Account
    {
        [Display(Name = "User name")]
        public string UserName { get; set; }
        [Display(Name = "Password")]
        public string Password { get; set; }
        public string[] Roles { get; set; }
    }
}