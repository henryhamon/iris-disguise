Class dc.Disguise.Glasses [ Abstract, System = 2 ]
{

/// Process
ClassMethod DisguiseProcess() As %Status
{
    Set sc = $$$OK
    Try {
      $$$ThrowOnError(..ScanProperties(.props))
      $$$ThrowOnError(..DisguiseStrategyProcess(props))
    } Catch ex {
      Set sc=ex.AsStatus()
    }
    Return sc
}

/// Find Properties
ClassMethod ScanProperties(Output props As %ListOfDataTypes = "") As %Status
{
    Set sc = $$$OK
    Try {
      Set props = ##class(%ListOfDataTypes).%New()
      Set klassname = $CLASSNAME($This)
      &sql(DECLARE C1 CURSOR FOR
        SELECT ID
        INTO :name
        From %Dictionary.PropertyDefinition
        where Parent = :klassname
        AND Type %StartsWith 'dc.Disguise.DataTypes.')
      &sql(Open C1)
        QUIT:(SQLCODE'=0)
      &sql(Fetch C1)
      While (SQLCODE = 0) {
        Do props.Insert(name)
        &sql(Fetch C1)
      }
      &sql(Close C1)
    } Catch ex {
      Set sc=ex.AsStatus()
    }
  Return sc
}

ClassMethod DisguiseStrategyProcess(props As %ListOfDataTypes) As %Status [ Private ]
{
  Set sc = $$$OK
  Try {
    For idx=1:1:props.Count() {
      Set prop = ##class(%Dictionary.PropertyDefinition).%OpenId(props.GetAt(idx))
      If (prop.Type = "dc.Disguise.DataTypes.PartialMaskString") {
        $$$ThrowOnError(..PartialMaskString(prop))
      }
      If ((prop.Type = "dc.Disguise.DataTypes.RandomInteger")||(prop.Type = "dc.Disguise.DataTypes.RandomNumeric")) {
        $$$ThrowOnError(..RandomNumber(prop))
      }
      If (prop.Type = "dc.Disguise.DataTypes.String") {
        $$$ThrowOnError(..DisguiseStringType(prop))
      }
      If (prop.Type = "dc.Disguise.DataTypes.FakeString") {
        $$$ThrowOnError(..FakeString(prop))
      }
    }
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod PartialMaskString(prop As %Dictionary.PropertyDefinition) As %Status [ Private ]
{
  Set sc = $$$OK
  Try {
    Set mask = prop.Parameters.GetAt("Mask")
    Set prefx = prop.Parameters.GetAt("prefixLength")
    Set sufx = prop.Parameters.GetAt("suffixLength")
    $$$ThrowOnError(##class(Strategy).PartialMasking($Classname($This), prop.Name, prefx, sufx, mask))
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod RandomNumber(prop As %Dictionary.PropertyDefinition) As %Status [ Private ]
{
  Set sc = $$$OK
  Try {
    Set from = prop.Parameters.GetAt("From")
    Set to = prop.Parameters.GetAt("To")
    If (from="") Set from = prop.Parameters.GetAt("MINVAL")
    If (to="") Set to = prop.Parameters.GetAt("MAXVAL")
    Set typ = "integer"
    If (prop.Type = "dc.Disguise.DataTypes.RandomNumeric") Set typ = "numeric"
    $$$ThrowOnError(##class(Strategy).Randomization($Classname($This), prop.Name, typ, from, to))
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod DisguiseStringType(prop As %Dictionary.PropertyDefinition) As %Status [ Private ]
{
  Set sc = $$$OK
  Try {
    Set strategy = prop.Parameters.GetAt("FieldStrategy")
    If (strategy = "DESTRUCTION") {
      Set mask = prop.Parameters.GetAt("Mask")
      W !,$CLASSNAME($This)
      W !, prop.Name
      $$$ThrowOnError(##class(Strategy).Destruction($Classname($This), prop.Name, mask))
    }
    If (strategy = "SCRAMBLE") {
      $$$ThrowOnError(##class(Strategy).Scramble($Classname($This), prop.Name))
    }
    If (strategy = "SHUFFLING") {
      $$$ThrowOnError(##class(Strategy).Shuffling($Classname($This), prop.Name))
    }
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod FakeString(prop As %Dictionary.PropertyDefinition) As %Status [ Private ]
{
  Set sc = $$$OK
  Try {
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

}
