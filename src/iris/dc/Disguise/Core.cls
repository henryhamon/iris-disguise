Class dc.Disguise.Core
{

/*
Destruction

Pseudonymization
pseudo

Faking

Randomization
random

shuffling

Partial Scrambling
partial

Content	Name	Description
Text	LoremIpsum	Generates a random Lorep Ipsum String
Text	RandomString	Generates a random string of equal length
Text	StringTemplate	Generates a string based on provided template
Text	SelectFromList	Randomly selects a string from a provided list
Text	SelectFromFile	Randomly selects a string from a provided file
Text	FormattedStringNumber	Randomize digits in a string while maintaining the format
Text	SelectFromDatabase	Selects randomly from the result of a query on a database
Text	RandomUrl	Anonymizes a URL while mainting the structure
Content	Name	Description
Number	RandomInteger	Generates a random integer between provided limits (default 0 to 100)
Number	RandomIntegerDelta	Generates a random integer within -delta and delta of original integer
Number	RandomFloat	Generates a random float between provided limits (default 0.0 to 100.0)
Number	RandomFloatDelta	Generates a random float within -delta and delta of original float
Number	RandomBigDecimalDelta	Similar to previous but creates a big decimal object
*/
/// Partial Scrambling
/// leaves out some part of the data.
ClassMethod PartialScramble(classname As %String, propName As %String, prefixLength As %Integer = 1, suffixLength As %Integer = 1, mask As %String = "X") As %Status
{
  Set sc = $$$OK
  Try {
    $$$THROWONERROR(sc, ..GetAllData(classname, .results))
    //TStart
    While (results.%Next()) {
      Set obj = $Classmethod(classname, "%OpenId", results.ID)
      If ('$IsObject(obj)) {
        Continue
      }
      Set $Property(obj, propName) = ..Obfuscating($Property(obj, propName), prefixLength, suffixLength, mask)
      $$$THROWONERROR(sc, $Method(obj,"%Save"))
    }
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

/// Scramble obfuscator
/// Write ##class(dc.Disguise.Core).Obfuscating("4567 6365 7987 3783",3,3,"X")
/// ; 456X XXXX XXXX X783
/// Write ##class(dc.Disguise.Core).Obfuscating("3457 732837 82372",1,4,"*")
/// ; 3*** ****** *2372
ClassMethod Obfuscating(value As %String, prefixLength As %Integer = 1, suffixLength As %Integer = 1, mask As %String) As %String
{
  If ((prefixLength + suffixLength) > $Length(value)) {
    Set output = ""
    For i=1:1:$Length(value) {
      Set output = output _ mask
    }
    Return output
  }
  Set replacement = $E(value, prefixLength + 1, * - suffixLength)
  Set matcher=##class(%Regex.Matcher).%New("[A-Za-z0-9]")
  Set matcher.Text = replacement
  Set output = $Replace(value, replacement, matcher.ReplaceAll(mask))
  Return output
}

/// Get SQL table name of the class
ClassMethod SQLTableName(classname As %String) As %String [ Private ]
{
  Set class = ##class(%Dictionary.CompiledClass).%OpenId(classname, .sc)
  If ($$$ISERR(sc)) {
    Return ""
  }
  Return class.SqlQualifiedNameQ
}

/// Description
ClassMethod GetAllData(classname As %String, results As %SQL.StatementResult) As %Status [ Private ]
{
  Set sc = $$$OK
  Try {
    Set tablename = ..SQLTableName(classname)
    If (tablename = "") {
      Throw $$$ERROR(5517)
    }
    Set tStatement = ##class(%SQL.Statement).%New()
    Set sc = tStatement.%Prepare("Select ID From "_tablename)
    If ($$$ISERR(sc)) {
      Throw sc
    }
    Set results = tStatement.%Execute()
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

}
