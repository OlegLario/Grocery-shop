using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.Mvc;

namespace Grocery.Controllers
{
    public class ContactsController : Controller
    {
        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Index(string name,  string message)
        {
            MailMessage mail = new MailMessage();
            mail.To.Add("ollarimvc@gmail.com");
            mail.From = new MailAddress("ollarimvc@gmail.com", "Oleg Larionov");
            mail.Subject = name;
            mail.Body = message;

            SmtpClient smtp = new SmtpClient();
            smtp.Host = "smtp.gmail.com";
            smtp.Port = 587;
            smtp.EnableSsl = true;
            smtp.Credentials = new NetworkCredential("ollarimvc@gmail.com", "0674389829");

            if(name != " " && message != " ")
            {
                smtp.Send(mail);
                ViewBag.Text = "Thank you for feed back.";
            }
            else
            {
                ViewBag.Error = "Please, complete all fields.";
            }
            return View();
        }
    }
}