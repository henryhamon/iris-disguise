Class dc.Disguise.Core
{

/// TLD options
Parameter TLD = {$ListBuild("com","org","net","edu","gov","mil","biz","info")};

/// Number of chunks to divide the table
Parameter Chunks = 8;

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

/// RandomNumeric
/// Generates a random float between provided limits (default 1.00 to 100.00)
ClassMethod RandomNumeric(from As %Numeric = 1.00, to As %Numeric = 100.00, scale As %Integer = 2) As %Numeric
{
	Set value = ""
  If (from = "") Set from = 1.00
  If (to = "") Set to = 100.00
  Set min = $Translate($Fnumber(from,,scale),".","")
  Set max = $Translate($fnumber(to,,scale),".","")
	While ('..In(value,min,max)) {
		Set value = $Random(max + 1)
	}
  Return $Extract(value,1,*-scale)_"."_$Extract(value,*-(scale-1),*)
}

/// RandomInteger
/// Generates a random integer between provided limits (default 1 to 100)
ClassMethod RandomInteger(from As %Integer = 1, to As %Integer = 100) As %Integer
{
	Set value = ""
  If (from = "") Set from = 1
  If (to = "") Set to = 100
	While ('..In(value,from,to)) {
		Set value = $Random(to + 1)
	}
	Return value
}

/// RandomDate
/// Shifts date randomly within given delta range. Default shits date within 10 days + or -
ClassMethod RandomDate(date As %Date = "", delta As %Integer = 365, foward As %Boolean = "") As %Date
{
  If (foward = "") {
    Set foward = $Random(2) - 1
  }
  If (date = "") {
    Set date = $Horolog
  }
  Set aux = $Random(delta) +1
  Set value = $Case(foward,1:(date + aux),:((date - aux)+1))
  Return $ZDate(value)
}

/// Scramble
/// Given "ABCDEFG", return something like "GEFBDCA"
ClassMethod Scrambling(value As %String) As %String
{
  Set len = $Length(value)
  For idx=1:1:len {
    Set tmp = $Extract(value, idx, idx)
    Set rand = $Random(len) + 1
    Set $Extract(value, idx, idx) = $Extract(value, rand, rand)
    Set $Extract(value, rand, rand) = tmp
  }
  Return value
}

/// RandomEmail
/// Generates email randomly using the given HOSTNAME and TLD. By defaults generates hostname randomly along with email id.
ClassMethod RandomEmail(username As %String = "", hostname As %String = "", TLD As %String = "") As %String
{
  If (username = "") Set username = $ZConvert(##class(%Library.PopulateUtils).FirstName()  _ ##class(%Library.PopulateUtils).LastName() _ ##class(%Library.PopulateUtils).String(4), "l")
  If (hostname = "") Set hostname = $Translate($ZConvert(##class(%Library.PopulateUtils).Company(), "l"),",. *&","")
  If (TLD = "") Set TLD = $List(..#TLD, $Random($ListLength(..#TLD))+1)
  Return $Replace(username," ","") _ "@" _ hostname _ "." _ TLD
}

/// Check if a value is in a range
ClassMethod In(value As %Integer, min As %Integer, max As %Integer) As %Boolean [ Private ]
{
	Return ((value>=min)&&(value<=max))
}

/// FakeCity
/// returns a city from %Library.PopulateUtils
ClassMethod FakeCity() As %String
{
  Return ##class(%Library.PopulateUtils).City()
}

/// returns a country from %Library.PopulateUtils
ClassMethod FakeCountry()
{
  Return ##class(%Library.PopulateUtils).City()
}

/// returns a generic company name from %Library.PopulateUtils
ClassMethod FakeCompany()
{
  Return ##class(%Library.PopulateUtils).Company()
}

/// returns a valid email address
ClassMethod FakeEmail()
{
  Return ..RandomEmail()
}

///  returns a generic first name from %Library.PopulateUtils
ClassMethod FakeFirstName()
{
  Return ##class(%Library.PopulateUtils).FirstName()
}

///  returns a generic last name from %Library.PopulateUtils
ClassMethod FakeLastName()
{
  Return ##class(%Library.PopulateUtils).LastName()
}

///  returns a generic full name from %Library.PopulateUtils
ClassMethod FakeFullName()
{
  Return ##class(%Library.PopulateUtils).Name()
}

ClassMethod ProcessDestruction(classname As %String, propName As %String, mask As %String = "CONFIDENTIAL", ByRef values As %SQL.StatementResult = "") As %Status
{
  Set sc = $$$OK
  Try {
    If ('values.%Next()) {
      Return sc
    }
    Set obj = $Classmethod(classname, "%OpenId", values.ID)
    If ('$IsObject(obj)) {
      $$$THROWONERROR(sc, ..ProcessDestruction(classname, propName, mask, .values))
    }
    Set $Property(obj, propName) = mask
    $$$THROWONERROR(sc, $Method(obj,"%Save"))
    $$$THROWONERROR(sc, ..ProcessDestruction(classname, propName, mask, .values))
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod ProcessScramble(classname As %String, propName As %String, ByRef values As %SQL.StatementResult = "") As %Status
{
  Set sc = $$$OK
  Try {
    If ('values.%Next()) {
      Return sc
    }
    Set obj = $Classmethod(classname, "%OpenId", values.ID)
    If ('$IsObject(obj)) {
      $$$THROWONERROR(sc, ..ProcessScramble(classname, propName, .values))
    }
    Set $Property(obj, propName) = ..Scrambling($Property(obj, propName))
    $$$THROWONERROR(sc, $Method(obj,"%Save"))
    $$$THROWONERROR(sc, ..ProcessScramble(classname, propName, .values))
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod ProcessRandomization(classname As %String, propName As %String, type As %String = "integer", from As %String = "", to As %String = "", ByRef values As %SQL.StatementResult = "") As %Status
{
  Set sc = $$$OK
  Try {
    If ('values.%Next()) {
      Return sc
    }
    Set obj = $Classmethod(classname, "%OpenId", values.ID)
    If ('$IsObject(obj)) {
      $$$THROWONERROR(sc, ..ProcessRandomization(classname, propName, type, from, to, .values))
    }
    Set randomMethod = "Random"_$ZConvert($Extract(type,1,1),"U")_$Extract(type,2,*)
    If (type = "date") {
      Set $Property(obj, propName) = $Classmethod("dc.Disguise.Core", randomMethod)
    } Else {
      Set $Property(obj, propName) = $Classmethod("dc.Disguise.Core", randomMethod, from, to)
    }
    $$$THROWONERROR(sc, $Method(obj,"%Save"))
    $$$THROWONERROR(sc, ..ProcessRandomization(classname, propName, type, from, to, .values))
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

/// RandomFormattedStringNumber
/// Randomize digits in a string while maintaining the format
ClassMethod RandomFormattedStringNumber(template As %String, mask As %String = "#") As %String
{
  If (mask = "") Set mask = "#"
	Set pos = $Find(template, mask,0)

	While pos'=$$$NO {
		Set value = $Random(10)
		Set template = $Extract(template,0,pos-2)_value_$Extract(template,pos,*),
			pos = $Find(template, mask,0)
	}
	Return template
}

/// Get SQL table name of the class
ClassMethod SQLTableName(classname As %String) As %String
{
  Set class = ##class(%Dictionary.CompiledClass).%OpenId(classname, .sc)
  If ($$$ISERR(sc)) {
    Return ""
  }
  Return class.SqlQualifiedNameQ
}

/// Split table data in chunks
ClassMethod GetChunks(classname As %String, Output chunks As %List = "") As %Status
{
  Set sc = $$$OK
  Try {
    Set class = ##class(%Dictionary.ClassDefinition).%OpenId(classname, .sc)
    If ($$$ISERR(sc)) {
      Throw $$$ERROR(5517)
    }
    If (class.Storages.Count() = 0) {
      Throw $$$ERROR(5518)
    }
    Set split = $$SplitSize^%GSIZE(class.Storages.GetAt(1).DataLocation, "N", ..#Chunks,,)
    Set returnCode = $list(split, 1)
		Set chunks = $list(split, 2)
    If (returnCode = 0) { // SubscriptList - I don't know yet how to solve this
      Set chunks = ""
      Return sc
    }
    If (returnCode'=1) $$$ThrowStatus($$$ERROR(5002, "Split Size error: "_returnCode))
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

/// Get all data from persistent class
ClassMethod GetAllData(classname As %String, Output results As %SQL.StatementResult, start As %String = "", end As %String = "") As %Status
{
  Set sc = $$$OK
  Try {
    Set tablename = ..SQLTableName(classname)
    If (tablename = "") {
      Throw $$$ERROR(5517)
    }

    // Split in chunks
    Set where = ""
    Set start = ..removebadwrd(start)
    Set end = ..removebadwrd(end)
		If start'="",end'="" {
			Set where = " WHERE ID >= '"_ start _"' AND ID < '"_end_"'"
		}
		ElseIf start="",end'="" {
			Set where = " WHERE ID < '"_end_"'"
		}
		ElseIf end="",start'="" {
			Set where = " WHERE ID >='"_ start_"'"
		}

    Set tStatement = ##class(%SQL.Statement).%New()
    Set sc = tStatement.%Prepare("Select ID From "_tablename_where)
    If ($$$ISERR(sc)) {
      Throw sc
    }
    Set results = tStatement.%Execute()
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod removebadwrd(raw As %String = "") As %String [ Private ]
{
  If (raw = "") Return ""
  Set aux = $ZConvert(raw, "l")
  If ($Find(aux, "select ", 1)||$Find(aux, "delete ")||$Find(aux, "insert ")) {
    Return ""
  }
  Return raw
}

}
