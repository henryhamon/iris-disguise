Class dc.PackageSample.Instrument Extends %Persistent
{

Index IdxName On Name;

Property Name As %String;

Relationship Musicians As dc.PackageSample.Musician [ Cardinality = many, Inverse = Instrument ];

ClassMethod FindOrCreateByName(name As %String, Output instrument As dc.PackageSample.Instrument) As %Status
{
  Set sc = $$$OK
  &sql(SELECT ID
        INTO :id
        FROM dc_PackageSample.Band
        WHERE Name = :name)
  If ((SQLCODE=0)||(id = "")) {
    Set instrument = ..%New()
    Set instrument.Name = name
    Return instrument.%Save()
  }
  Set instrument = ..%OpenId(id)
  Return sc
}

Storage Default
{
<Data name="InstrumentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^dc.PackageSample.InstrumentD</DataLocation>
<DefaultData>InstrumentDefaultData</DefaultData>
<IdLocation>^dc.PackageSample.InstrumentD</IdLocation>
<IndexLocation>^dc.PackageSample.InstrumentI</IndexLocation>
<StreamLocation>^dc.PackageSample.InstrumentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
