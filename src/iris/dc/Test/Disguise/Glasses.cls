Class dc.Test.Disguise.Glasses Extends %UnitTest.TestCase
{

Method TestFindProperties()
{
  Do ##class(dc.PackageSample.Musician).Populate()
  Do ##class(dc.PackageSample.Band).ScanProperties(.props)
  Do $$$AssertEquals(props.Count(), 1)
}

}
