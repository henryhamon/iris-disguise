Class dc.PackageSample.Instrument Extends %Persistent
{

Index IdxName On Name [ Unique ];

Property Name As %String;

Relationship Musicians As dc.PackageSample.Musician [ Cardinality = many, Inverse = Instrument ];

ClassMethod FindOrCreateByName(name As %String, Output instrument As dc.PackageSample.Instrument) As %Status
{
  Set sc = $$$OK
  Set instrument = ..IdxNameOpen(name)
  If ($IsObject(instrument)) {
    Return sc
  }
  Set instrument = ..%New()
  Set instrument.Name = name
  Return instrument.%Save()
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
