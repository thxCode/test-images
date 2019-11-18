using System;
using System.Web.Mvc;
using WinAspNet.Models;

namespace WinAspNet.Controllers
{
    public class HomeController : Controller
    {
        private string podIP, hostIP;

        public ActionResult Show()
        {
            AccessCounter.Increase();
            ViewBag.PodIP = Environment.GetEnvironmentVariable("POD_IP");
            ViewBag.HostIP = Environment.GetEnvironmentVariable("HOST_IP");
            ViewBag.AccessCounter = AccessCounter.Value();
            return View();
        }

        public void Metrics()
        {
            Response.ContentType = "text/plain";
            Response.Write(string.Format("winaspnet_access_total {0}", AccessCounter.Value()));
            Response.End();
        }
    }
}