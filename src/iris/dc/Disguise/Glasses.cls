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
        Set mask = prop.Parameters.GetAt("Mask")
        Set prefx = prop.Parameters.GetAt("prefixLength")
        Set sufx = prop.Parameters.GetAt("suffixLength")
        $$$ThrowOnError(##class(Strategy).PartialMasking($Classname($This),prop.Name,prefx,sufx,mask))
      }
    }
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

}
