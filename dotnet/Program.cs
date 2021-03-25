using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace Test
{
    class Thang : IEnumerable
    {
        public string Thung
        {
            get;
            set;
        }

        public void Add(string s)
        {
            Thung = s;
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return new[] { Thung }.GetEnumerator();
        }
    }

    class Thing
    {
        private readonly Thang _thang;
        public Thing(Thang thang)
        {
            _thang = thang;
        }
        public Thang Thang
        {
            get { return _thang; }
        }
    }

    class Program
    {
        static void Main()
        {
            var t = new Thing(new Thang { Thung = "lol" })
            {
                Thang = { { "OMG" } }
            };

            Console.WriteLine(t.Thang.Thung);
        }
    }
}
