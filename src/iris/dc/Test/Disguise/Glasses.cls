Class dc.Test.Disguise.Glasses Extends %UnitTest.TestCase
{

Method TestFindProperties()
{
  Do ##class(dc.PackageSample.Musician).Populate()
  Do ##class(dc.PackageSample.Band).ScanProperties(.props)
  Do $$$AssertEquals(props.Count(), 2)
}

Method TestProcess()
{
  Do ..BandsCreate()
  Set band = ##class(dc.PackageSample.Band).IdxNameOpen("Led Zeppelin")
  Do $$$AssertEquals(band.Manager, "Peter Grant")
  kill band
  Do $$$AssertStatusOK(##class(dc.PackageSample.Band).DisguiseProcess())
  Set band = ##class(dc.PackageSample.Band).IdxNameOpen("Led Zeppelin")
  Do $$$AssertEquals(band.Manager, "CONFIDENTIAL")
}

ClassMethod BandsCreate()
{
  Do ##class(dc.PackageSample.Musician).Populate()
  Set band1 = ##class(dc.PackageSample.Band).%New()
  Set band1.Name = "Led Zeppelin"
  Set band1.Manager = "Peter Grant"
  Do band1.%Save()
  Set band2 = ##class(dc.PackageSample.Band).%New()
  Set band2.Name = "Sex Pistols"
  Set band2.Manager = "Malcolm McLaren"
  Do band2.%Save()
}

}
