Class dc.Test.Disguise.Core Extends %UnitTest.TestCase
{

Method TestObfuscating()
{
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("4567 6365 7987 3783",3,3,"X"), "456X XXXX XXXX X783")
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("3457 732837 82372",1,4,"*"), "3*** ****** *2372")
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("60101233321",2,2,"0"), "60000000021")
  Do $$$AssertEquals(##class(dc.Disguise.Core).Obfuscating("Lemmy Kilmister",1,4,"##"), "L######## ##########ster")
}

Method TestRandomInteger()
{
  // Default Values
  Set value = ##class(dc.Disguise.Core).RandomInteger()
  Do $$$AssertTrue( value>=1 )
  Do $$$AssertTrue( value<=100 )
  Do $$$AssertTrue( value'= ##class(dc.Disguise.Core).RandomInteger())
  // 18 and 70
  Set value = ##class(dc.Disguise.Core).RandomInteger(18, 70)
  Do $$$AssertTrue( value>=18 )
  Do $$$AssertTrue( value<=70 )
}

Method TestRandomDate()
{
  Set date = $ZDateH("2015-10-21",3)
  Do $$$AssertNotEquals(##class(dc.Disguise.Core).RandomDate(date), date)
  Set date = $ZDateH("1985-10-26",3)
  Set value = $ZDateH(##class(dc.Disguise.Core).RandomDate(date, 30, 1))
  Do $$$AssertTrue( value>=52894)
  Do $$$AssertTrue( value<=52924)
  Set date = $ZDateH("1955-11-12",3)
  Set value = $ZDateH(##class(dc.Disguise.Core).RandomDate(date, 10, 0))
  Do $$$AssertTrue( value>=41943)
  Do $$$AssertTrue( value<=41953)
}

Method TestRandomNumeric()
{
  // Default Values
  Set value = ##class(dc.Disguise.Core).RandomNumeric()
  Do $$$AssertTrue( value>=1.0 )
  Do $$$AssertTrue( value<=100.0 )
  Do $$$AssertTrue( value'= ##class(dc.Disguise.Core).RandomNumeric())
  Set value = ##class(dc.Disguise.Core).RandomNumeric(1.8, 70.4)
  Do $$$AssertTrue( value>=1.80 )
  Do $$$AssertTrue( value<=70.40 )
  Set value = ##class(dc.Disguise.Core).RandomNumeric(1.80, 2.40)
  Do $$$AssertTrue( value>=1.8 )
  Do $$$AssertTrue( value<=2.4 )
}

}
