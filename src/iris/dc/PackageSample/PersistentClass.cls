Class dc.PackageSample.PersistentClass Extends %Persistent
{

Property Test As %VarString;

Property FullName As %String;

Property Instrument As %String;

Property DoB As %Date;

Property Identifier As %String(MAXLEN = 100);

Property Currency As %Numeric;

ClassMethod Create(name As %String = "", instrument As %String = "", dob As %Date = "", identifier As %String = "", currency As %Numeric = "") As %Status
{
    Set objPC=..%New()
    Set objPC.Test="Test string"
    Set objPC.FullName = name
    Set objPC.Instrument = instrument
    Set objPC.Identifier = identifier
    Set objPC.DoB = dob
    Set objPC.Currency = currency
    Return objPC.%Save()
}

ClassMethod Clear() As %Status
{
    Return ..%KillExtent()
}

ClassMethod Populate()
{
    Do ##class(dc.PackageSample.PersistentClass).Clear()
    Do ##class(dc.PackageSample.PersistentClass).Create("James Hetfield", "Guitar And Vocals", $zdh("1963-08-03",3), "5019 0370 9193 1964", 235.83)
    Do ##class(dc.PackageSample.PersistentClass).Create("Lars Ulrich", "Drums", $zdh("1963-12-26",3), "ZY 75 69 92", 727.82)
    Do ##class(dc.PackageSample.PersistentClass).Create("Kirk Hammett","Guitar", $zdh("1962-11-18",3), "576-56-1090", 578.18)
    Do ##class(dc.PackageSample.PersistentClass).Create("Robert Trujillo","Bass", $zdh("1964-10-23",3), "138.25813.75-3", 6805.09)
    Do ##class(dc.PackageSample.PersistentClass).Create("Lloyd Grant","Guitar", $zdh("1961-07-17",3), "HA 95 56 26 D", 2682.71)
    Do ##class(dc.PackageSample.PersistentClass).Create("Ron McGovney","Bass", $zdh("1962-11-02",3), "20.700.04507/81", 3567.34)
    Do ##class(dc.PackageSample.PersistentClass).Create("Dave Mustaine", "Guitar And Vocals", $zdh("1961-07-13",3), "215 127 317", 1778.04)
    Do ##class(dc.PackageSample.PersistentClass).Create("Cliff Burton", "Bass", $zdh("1962-02-10",3), "IDFRAHANNIBAL<<<<<<<<<<<<<<<<<601123 2111601123453HANNIBAL<<<<<<6608202M6", 8341.32)
    Do ##class(dc.PackageSample.PersistentClass).Create("Jason Newsted", "Bass", $zdh("1963-03-04",3), "531.729.692-74", 1.76)
}

Storage Default
{
<Data name="PersistentClassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Test</Value>
</Value>
<Value name="3">
<Value>FullName</Value>
</Value>
<Value name="4">
<Value>Number</Value>
</Value>
<Value name="5">
<Value>Currency</Value>
</Value>
<Value name="6">
<Value>DoB</Value>
</Value>
<Value name="7">
<Value>Band</Value>
</Value>
<Value name="8">
<Value>Instrument</Value>
</Value>
<Value name="9">
<Value>Identifier</Value>
</Value>
</Data>
<DataLocation>^dc.Package4C8F.PersistentC1A93D</DataLocation>
<DefaultData>PersistentClassDefaultData</DefaultData>
<IdLocation>^dc.Package4C8F.PersistentC1A93D</IdLocation>
<IndexLocation>^dc.Package4C8F.PersistentC1A93I</IndexLocation>
<StreamLocation>^dc.Package4C8F.PersistentC1A93S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
