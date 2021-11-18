Class Test.Disguise.Core Extends %UnitTest.TestCase
{

Method TestObfuscating()
{
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("4567 6365 7987 3783",3,3,"X"), "456X XXXX XXXX X783")
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("3457 732837 82372",1,4,"*"), "3*** ****** *2372")
}

}
