Class dc.PackageSample.Band Extends %Persistent
{

Index IdxName On Name [ Unique ];

Property Name As %String;

Relationship Musicians As dc.PackageSample.Musician [ Cardinality = children, Inverse = Band ];

ClassMethod FindOrCreateByName(name As %String, Output band As dc.PackageSample.Band) As %Status
{
  Set sc = $$$OK
  Set band = ..IdxNameOpen(name)
  If ($IsObject(band)) Return sc
  Set band = ..%New()
  Set band.Name = name
  Return band.%Save()
}

Storage Default
{
<Data name="BandDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^dc.PackageSample.BandD</DataLocation>
<DefaultData>BandDefaultData</DefaultData>
<IdLocation>^dc.PackageSample.BandD</IdLocation>
<IndexLocation>^dc.PackageSample.BandI</IndexLocation>
<StreamLocation>^dc.PackageSample.BandS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
