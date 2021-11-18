Class dc.PackageSample.Band Extends %Persistent
{

Index IdxByName On Name;

Property Name As %String;

Relationship Musicians As dc.PackageSample.Musician [ Cardinality = children, Inverse = Band ];

ClassMethod FindOrCreateByName(name As %String, Output band As dc.PackageSample.Band) As %Status
{
  Set sc = $$$OK
  &sql(SELECT ID
        INTO :id
        FROM dc_PackageSample.Band
        WHERE Name = :name)
  If (id = "") {
    Set band = ..%New()
    Set band.Name = name
    Return band.%Save()
  }
  Set band = ..%OpenId(id)
  Return sc
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
