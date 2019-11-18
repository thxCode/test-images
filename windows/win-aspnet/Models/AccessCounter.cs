using System;

namespace WinAspNet.Models
{
    public static class AccessCounter
    {
        private static readonly String txtPath = @"C:\winaspnet\access.txt";
        private static readonly object lockhelper = new object();
        private static int counter;

        static AccessCounter()
        {
            recover();
        }

        public static void recover()
        {
            try
            {
                string text = System.IO.File.ReadAllText(txtPath);
                counter = int.Parse(text);
                Console.WriteLine(string.Format("AccessCounter has been recovered to {0}!", counter));
            }
            catch
            {
            }
        }

        public static void persist()
        {
            try
            {
                System.IO.File.WriteAllText(txtPath, counter.ToString());
            } catch
            {
            }
        }

        public static int Value()
        {
            return counter;
        }

        public static void Increase()
        {
            lock (lockhelper)
            {
                counter += 1;
                Console.WriteLine(string.Format("AccessCounter has been increased to {0}!", counter));
                persist();
            }
        }
    }
}
