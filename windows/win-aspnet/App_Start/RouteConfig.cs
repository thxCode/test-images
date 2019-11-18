using System.Web.Mvc;
using System.Web.Routing;

namespace WinAspNet
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "Metrics",
                url: "metrics",
                defaults: new { controller = "Home", action = "Metrics" }
            );

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}",
                defaults: new { controller = "Home", action = "Show" }
            );

            
        }
    }
}
