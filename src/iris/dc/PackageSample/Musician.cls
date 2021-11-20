Class dc.PackageSample.Musician Extends %Persistent
{

Index IdxByInstrument On Instrument;

Property FullName As %String;

Property DoB As %Date;

Property Identifier As %String(MAXLEN = 100);

Property Currency As %Numeric;

Relationship Band As dc.PackageSample.Band [ Cardinality = parent, Inverse = Musicians ];

Relationship Instrument As dc.PackageSample.Instrument [ Cardinality = one, Inverse = Musicians ];

ClassMethod Create(name As %String = "", band As %String, instrument As %String = "", dob As %Date = "", identifier As %String = "", currency As %Numeric = "") As %Status
{
  Set tSC = $$$OK
	Try {
    $$$THROWONERROR(tSC, ##Class(dc.PackageSample.Band).FindOrCreateByName(band, .Band))
    $$$THROWONERROR(tSC, ##Class(dc.PackageSample.Instrument).FindOrCreateByName(instrument, .Instrument))
    Set obj=..%New()
    Set obj.FullName = name
    Set obj.Instrument = Instrument
    Set obj.Identifier = identifier
    Set obj.DoB = dob
    Set obj.Currency = currency
    Do Band.Musicians.Insert(obj)
    Return Band.%Save()
	} Catch tException {
		Set:$$$ISOK(tSC) tSC = tException.AsStatus()
	}
  Return
}

ClassMethod Clear() As %Status
{
  Set sc = $$$OK
	Try {
    $$$THROWONERROR(sc, ..%KillExtent())
    $$$THROWONERROR(sc, ##Class(dc.PackageSample.Instrument).%KillExtent())
    $$$THROWONERROR(sc, ##Class(dc.PackageSample.Band).%KillExtent())

	} Catch tException {
		Set:$$$ISOK(sc) sc = tException.AsStatus()
	}
	Return sc
}

ClassMethod Populate()
{
    Do ..Clear()
    Do ..Create("James Hetfield", "Metallica", "Guitar And Vocals", $zdh("1963-08-03",3), "5019 0370 9193 1964", 4235.83)
    Do ..Create("Lars Ulrich", "Metallica", "Drums", $zdh("1963-12-26",3), "ZY 75 69 92", 727.82)
    Do ..Create("Kirk Hammett","Metallica", "Guitar", $zdh("1962-11-18",3), "576-56-1090", 578.18)
    Do ..Create("Robert Trujillo","Metallica", "Bass", $zdh("1964-10-23",3), "138.25813.75-3", 6805.09)
    Do ..Create("Lloyd Grant","Metallica", "Guitar", $zdh("1961-07-17",3), "HA 95 56 26 D", 2682.71)
    Do ..Create("Ron McGovney","Metallica", "Bass", $zdh("1962-11-02",3), "20.700.04507/81", 3567.34)
    Do ..Create("Dave Mustaine", "Megadeth", "Guitar And Vocals", $zdh("1961-07-13",3), "215 127 317", 1778.04)
    Do ..Create("Cliff Burton", "Metallica", "Bass", $zdh("1962-02-10",3), "IDFRAHANNIBAL<<<<<<<<<<<<<<<<<601123 2111601123453HANNIBAL<<<<<<6608202M6", 8341.32)
    Do ..Create("Jason Newsted", "Metallica", "Bass", $zdh("1963-03-04",3), "531.729.692-74", 1.76)
    Do ..Create("Kiko Loureiro", "Megadeth", "Guitar", $zdh("1972-06-16",3), "37.835.603/0001-13", 51645.24)
    Do ..Create("David Ellefson", "Megadeth", "Bass", $zdh("1964-11-12",3), "4026 1316 2901 8412", 72020.94)
    Do ..Create("Vinnie Colaiuta", "Megadeth", "Drums", $zdh("1956-02-05",3), "IDFRADUGGAN<<<<<<<<<<<<<<<<<<<458123 2111458123451TRICIA<<<<<<<<8904104F1", 419.39)
    Do ..Create("Marty Friedman", "Megadeth", "Guitar", $zdh("1962-12-08",3), "KP 15 24 62 C", 25637.91)
}

Storage Default
{
<Data name="MusicianDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FullName</Value>
</Value>
<Value name="3">
<Value>DoB</Value>
</Value>
<Value name="4">
<Value>Identifier</Value>
</Value>
<Value name="5">
<Value>Currency</Value>
</Value>
<Value name="6">
<Value>Instrument</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Musicians")</DataLocation>
<DefaultData>MusicianDefaultData</DefaultData>
<IdLocation>^dc.PackageSample.BandC("Musicians")</IdLocation>
<IndexLocation>^dc.PackageSample.MusicianI</IndexLocation>
<StreamLocation>^dc.PackageSample.MusicianS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
