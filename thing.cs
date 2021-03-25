using System;
using System.Collections;

class Thang : List<string>
{
  public string Thung
  {
    get { return this.FirstOrDefault(); }
    set { this.Add(value); }
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

var t = new Thing(new Thang { Thung = "lol" })
{
  Thang = { { "x" } }
};
Console.WriteLine(t.Thang.Thung);