Class dc.Test.Disguise.Strategy Extends %UnitTest.TestCase
{

Method TestPartialMasking() As %Status
{
  Do ##class(dc.PackageSample.Musician).Populate()
  Set musicianID = "1||3"
  Set test = ##class(dc.PackageSample.Musician).%OpenId(musicianID)
  Do $$$AssertEquals(test.Identifier, "576-56-1090")
  Kill test
  Do $$$AssertStatusOK(##class(dc.Disguise.Strategy).PartialMasking("dc.PackageSample.Musician", "Identifier", 2, 3, "X"))
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
  Do $$$AssertStatusOK(##class(dc.Disguise.Strategy).Destruction("dc.PackageSample.Musician", "Identifier"))
  Set test = ##class(dc.PackageSample.Musician).%OpenId(musicianID)
  Do $$$AssertEquals(test.Identifier, "CONFIDENTIAL")
}

Method TestRandomization() As %Status
{
  Do ##class(dc.PackageSample.Musician).Populate()
  Set musicianIDa = "1||9"
  Set musicianIDb = "2||11"
  Set testA = ##class(dc.PackageSample.Musician).%OpenId(musicianIDa)
  Set testB = ##class(dc.PackageSample.Musician).%OpenId(musicianIDb)
  Do $$$AssertEquals(testA.Currency, 1.76)
  Do $$$AssertEquals(testB.Currency, 72020.94)
  Kill testA, testB
  Do $$$AssertStatusOK(##class(dc.Disguise.Strategy).Randomization("dc.PackageSample.Musician", "Currency", "numeric"))
  Set testA = ##class(dc.PackageSample.Musician).%OpenId(musicianIDa)
  Set testB = ##class(dc.PackageSample.Musician).%OpenId(musicianIDb)
  Do $$$AssertNotEquals(testA.Currency, 1.76)
  Do $$$AssertNotEquals(testB.Currency, 72020.94)
  Do $$$AssertTrue( testA.Currency >=1.0 )
  Do $$$AssertTrue( testA.Currency <=100.0 )
  Do $$$AssertTrue( testB.Currency >=1.0 )
  Do $$$AssertTrue( testB.Currency <=100.0 )
}

}
