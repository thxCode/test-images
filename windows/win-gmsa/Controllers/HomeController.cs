using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WindockerTest.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            var user = this.User?.Identity?.Name;
            var authentType = this.User?.Identity?.AuthenticationType;
            ViewBag.User = string.IsNullOrWhiteSpace(user)?"No user" :user;
            ViewBag.AuthType = string.IsNullOrWhiteSpace(authentType) ? "No auth" : authentType;
            return View();
        }
    }
}