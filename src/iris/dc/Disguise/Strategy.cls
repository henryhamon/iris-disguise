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
    $$$ThrowOnError(..WorkMgrInitialize(classname, .queue, .chunks, .nchunks))
		Set start = ""
		For i=1:1:nchunks+1 {
			Set end = $select(i>nchunks:"", 1:$list(chunks,i))
			Set sc = queue.Queue("##class(dc.Disguise.Strategy).RandomizationChunks", classname, propName, type, from, to, start, end)
			Set start = end
		}
		Set sc = queue.WaitForComplete()
		$$$ThrowOnError(sc)
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod RandomizationChunks(classname As %String, propName As %String, type As %String = "", from As %String = "", to As %String = "", start As %String = "", end As %String = "") As %Status
{
  Set sc = $$$OK
  Try {
    If (type="") Set type = "integer"
    If ($ListFind(..#RandomizationTypes, $ZConvert(type,"l")) = 0) {
      Return $$$ERROR(5002,"Randomization type not found")
    }
    $$$THROWONERROR(sc, ##class(dc.Disguise.Core).GetAllData(classname, .results, start, end))
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
    $$$ThrowOnError(..WorkMgrInitialize(classname, .queue, .chunks, .nchunks))
		Set start = ""
		For i=1:1:nchunks+1 {
			Set end = $select(i>nchunks:"", 1:$list(chunks,i))
			Set sc = queue.Queue("##class(dc.Disguise.Strategy).DestructionChunks", classname, propName, mask, start, end)
			Set start = end
		}
		Set sc = queue.WaitForComplete()
		$$$ThrowOnError(sc)
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod DestructionChunks(classname As %String, propName As %String, mask As %String = "CONFIDENTIAL", start As %String = "", end As %String = "") As %Status
{
  Set sc = $$$OK
  Try {
    $$$THROWONERROR(sc, ##class(dc.Disguise.Core).GetAllData(classname, .results, start, end))
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
    $$$ThrowOnError(..WorkMgrInitialize(classname, .queue, .chunks, .nchunks))
		Set start = ""
		For i=1:1:nchunks+1 {
			Set end = $select(i>nchunks:"", 1:$list(chunks,i))
			Set sc = queue.Queue("##class(dc.Disguise.Strategy).ScrambleChunks", classname, propName, start, end)
			Set start = end
		}
		Set sc = queue.WaitForComplete()
		$$$ThrowOnError(sc)
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod ScrambleChunks(classname As %String, propName As %String, start As %String = "", end As %String = "") As %Status
{
  Set sc = $$$OK
  Try {
    $$$THROWONERROR(sc, ##class(dc.Disguise.Core).GetAllData(classname, .results, start, end))
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
    $$$ThrowOnError(..WorkMgrInitialize(classname, .queue, .chunks, .nchunks))
		Set start = ""
		For i=1:1:nchunks+1 {
			Set end = $select(i>nchunks:"", 1:$list(chunks,i))
			Set sc = queue.Queue("##class(dc.Disguise.Strategy).PartialMaskingChunks", classname, propName, prefixLength, suffixLength, mask, start, end)
			Set start = end
		}
		Set sc = queue.WaitForComplete()
		$$$ThrowOnError(sc)
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod PartialMaskingChunks(classname As %String, propName As %String, prefixLength As %Integer = 1, suffixLength As %Integer = 1, mask As %String = "X", start As %String = "", end As %String = "") As %Status
{
  Set sc = $$$OK
  Try {
    $$$THROWONERROR(sc, ##class(Core).GetAllData(classname, .results, start, end))
    //TStart
    While (results.%Next()) {
      Set obj = $Classmethod(classname, "%OpenId", results.ID)
      If ('$IsObject(obj)) {
        Continue
      }
      Set $Property(obj, propName) = ##class(Core).Obfuscating($Property(obj, propName), prefixLength, suffixLength, mask)
      $$$THROWONERROR(sc, $Method(obj,"%Save"))
    }
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

/// Shuffling
/// mixes values within the same columns.
/// This is useful for foreign keys because referential integrity will be kept.
/// 
/// Until now, this method only works on one-to-many relationships.
/// TODO: Work on parent-child relationships.
/// TODO: Improve performance for large datasets.
ClassMethod Shuffling(classname As %String, propName As %String) As %Status
{
  Set sc = $$$OK
  Try {
    $$$THROWONERROR(sc, ##class(Shuffle).Process(classname, propName))
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod WorkMgrInitialize(classname As %String, Output queue As %SYSTEM.AbstractWorkMgr, Output chunks As %List, Output nchunks As %Integer = 0) As %Status
{
  Set sc = $$$OK
  Try {
    $$$THROWONERROR(sc, ##class(dc.Disguise.Core).GetChunks(classname, .chunks))
    Set queue = $system.WorkMgr.Initialize("/multicompile=1", .sc)
		$$$ThrowOnError(sc)
    If (chunks="") {
      Set nchunks = 0
    } Else {
      Set nchunks = $listlength(chunks)
    }
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

}
