Class dc.Test.Disguise.Strategy Extends %UnitTest.TestCase
{

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
