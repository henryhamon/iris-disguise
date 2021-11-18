Class dc.Test.Disguise.Core Extends %UnitTest.TestCase
{

Method TestObfuscating()
{
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("4567 6365 7987 3783",3,3,"X"), "456X XXXX XXXX X783")
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("3457 732837 82372",1,4,"*"), "3*** ****** *2372")
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("60101233321",2,2,"0"), "60000000021")
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("Lemmy Kilmister",1,4,"##"), "L######## ##########ster")
}

Method TestPartialMasking() As %Status
{
  Do ##class(dc.PackageSample.Musician).Populate()
  Set musicianID = "1||3"
  Set test = ##class(dc.PackageSample.Musician).%OpenId(musicianID)
  Do $$$AssertEquals(test.Identifier, "576-56-1090")
  Kill test
  Do $$$AssertStatusOK(##class(dc.Disguise.Core).PartialMasking("dc.PackageSample.Musician", "Identifier", 2, 3, "X"))
  Set test = ##class(dc.PackageSample.Musician).%OpenId(musicianID)
  Do $$$AssertEquals(test.Identifier, "57X-XX-X090")
}

Method TestDestruction() As %Status
{
  Do ##class(dc.PackageSample.Musician).Populate()
  Set musicianID = "1||9"
  Set test = ##class(dc.PackageSample.Musician).%OpenId(musicianID)
  Do $$$AssertEquals(test.Identifier, "531.729.692-74")
  Kill test
  Do $$$AssertStatusOK(##class(dc.Disguise.Core).Destruction("dc.PackageSample.Musician", "Identifier"))
  Set test = ##class(dc.PackageSample.Musician).%OpenId(musicianID)
  Do $$$AssertEquals(test.Identifier, "CONFIDENTIAL")
}

}
