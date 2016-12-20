using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Grocery.ViewModels;
using Grocery.Models;
using Grocery.Security;

namespace Grocery.Controllers
{
    public class AccountController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Login(AccountViewModel avm)
        {
            AccountModel am = new AccountModel();
            if(string.IsNullOrEmpty(avm.Account.UserName) || string.IsNullOrEmpty(avm.Account.Password)
                || am.login(avm.Account.UserName, avm.Account.Password) == null)
            {
                ViewBag.Error = "Account invalid";
                return View("Index");
            }
            SessionPersister.UserName = avm.Account.UserName;
            return View("Success");
        }
        public ActionResult LogOut()
        {
            SessionPersister.UserName = string.Empty;
            return RedirectToAction("Index");
        }
    }
}