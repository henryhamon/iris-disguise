Class dc.Disguise.Core
{

/// Destruction
/// Sometimes the fastest and the best approach to anonymize a data is to replace all the values with the word CONFIDENTIAL.
ClassMethod Destruction(classname As %String, propName As %String, mask As %String = "CONFIDENTIAL") As %Status
{
  Set sc = $$$OK
  Try {
    $$$THROWONERROR(sc, ..GetAllData(classname, .results))
    $$$THROWONERROR(sc, ..AbstractDestruction(classname, propName, mask, .results))
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

/// Partial Masking
/// leaves out some part of the data.
ClassMethod PartialMasking(classname As %String, propName As %String, prefixLength As %Integer = 1, suffixLength As %Integer = 1, mask As %String = "X") As %Status
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

/// obfuscator
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

ClassMethod AbstractDestruction(classname As %String, propName As %String, mask As %String = "CONFIDENTIAL", ByRef values As %SQL.StatementResult = "") As %Status [ Private ]
{
  Set sc = $$$OK
  Try {
    If ('values.%Next()) {
      Return sc
    }
    Set obj = $Classmethod(classname, "%OpenId", values.ID)
    If ('$IsObject(obj)) {
      $$$THROWONERROR(sc, ..AbstractDestruction(classname, propName, mask, .values))
    }
    Set $Property(obj, propName) = mask
    $$$THROWONERROR(sc, $Method(obj,"%Save"))
    $$$THROWONERROR(sc, ..AbstractDestruction(classname, propName, mask, .values))
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
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

/// Get all data from persistent class
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
