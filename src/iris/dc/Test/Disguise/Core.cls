Class dc.Test.Disguise.Core Extends %UnitTest.TestCase
{

Method TestObfuscating()
{
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("4567 6365 7987 3783",3,3,"X"), "456X XXXX XXXX X783")
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("3457 732837 82372",1,4,"*"), "3*** ****** *2372")
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("60101233321",2,2,"0"), "60000000021")
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("Lemmy Kilmister",1,4,"##"), "L######## ##########ster")
}

}
