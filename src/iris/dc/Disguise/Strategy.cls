/// iris Disguise anonymization strategies
Class dc.Disguise.Strategy
{

/// Radomization Types
Parameter RandomizationTypes = {$ListFromString("integer,numeric,date",",")};

/// Randomization
/// Generate purely random data
ClassMethod Randomization(classname As %String, propName As %String, type As %String = "", from As %String = "", to As %String = "") As %Status
{
  Set sc = $$$OK
  Try {
    If (type="") Set type = "integer"
    If ($ListFind(..#RandomizationTypes, $ZConvert(type,"l")) = 0) {
      Return $$$ERROR(5002,"Randomization type not found")
    }
    $$$THROWONERROR(sc, ##class(dc.Disguise.Core).GetAllData(classname, .results))
    $$$THROWONERROR(sc, ##class(dc.Disguise.Core).ProcessRandomization(classname, propName, type, from, to, .results))
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

/// Destruction
/// Sometimes the fastest and the best approach to anonymize a data is to replace all the values with the word CONFIDENTIAL.
ClassMethod Destruction(classname As %String, propName As %String, mask As %String = "CONFIDENTIAL") As %Status
{
  Set sc = $$$OK
  Try {
    $$$THROWONERROR(sc, ##class(dc.Disguise.Core).GetAllData(classname, .results))
    $$$THROWONERROR(sc, ##class(dc.Disguise.Core).ProcessDestruction(classname, propName, mask, .results))
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

/// Scramble
/// 
ClassMethod Scramble(classname As %String, propName As %String) As %Status
{
  Set sc = $$$OK
  Try {
    $$$THROWONERROR(sc, ##class(dc.Disguise.Core).GetAllData(classname, .results))
    $$$THROWONERROR(sc, ##class(dc.Disguise.Core).ProcessScramble(classname, propName, .results))
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
    $$$THROWONERROR(sc, ##class(dc.Disguise.Core).GetAllData(classname, .results))
    //TStart
    While (results.%Next()) {
      Set obj = $Classmethod(classname, "%OpenId", results.ID)
      If ('$IsObject(obj)) {
        Continue
      }
      Set $Property(obj, propName) = ##class(dc.Disguise.Core).Obfuscating($Property(obj, propName), prefixLength, suffixLength, mask)
      $$$THROWONERROR(sc, $Method(obj,"%Save"))
    }
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

}
