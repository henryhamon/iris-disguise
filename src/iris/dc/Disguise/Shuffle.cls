Class dc.Disguise.Shuffle
{

ClassMethod Process(classname As %String, propName As %String) As %Status
{
  Set sc = $$$OK
  Try {
    Set list = ##class(%ListOfDataTypes).%New()
    $$$THROWONERROR(sc, ##class(Shuffle).RowCount(classname, .total))
    Set rows = total
    While (rows > 1) {
      Set first = ..ChooseRandom(total, .list)
      Set second = ..ChooseRandom(total, .list)
      $$$THROWONERROR(sc, ..ColumnPermutation(classname, propName, first, second))
      Set rows = rows - 2
    }
    If (rows = 1) {
      Set first = ..ChooseRandom(total, .list)
      Set second = ..ChooseRandom(total)
      $$$THROWONERROR(sc, ..ColumnPermutation(classname, propName, first, second))
    }
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod RowCount(classname As %String, Output rows As %Integer = 0) As %Status [ Private ]
{
  Set sc = $$$OK
  Try {
    Set tablename = ##class(Core).SQLTableName(classname)
    If (tablename = "") {
      Throw $$$ERROR(5517)
    }
    Set tStatement = ##class(%SQL.Statement).%New()
    Set sc = tStatement.%Prepare("Select Count(ID) as total From "_tablename)
    If ($$$ISERR(sc)) {
      Throw sc
    }
    Set results = tStatement.%Execute()
    If (results.%Next()) {
      Set rows = results.total
    }
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod ChooseRandom(size As %Integer, ByRef list As %ListOfDataTypes = "") As %String [ Private ]
{
  If (list = "") Set list = ##class(%ListOfDataTypes).%New()
  Set output = $Random(size) + 1
  While (list.Find(output)) {
    Set output = $Random(size) + 1
  }
  Do list.Insert(output)

  Return output
}

/// Probably there is a better way to do this
ClassMethod GetRow(classname As %String, row As %Integer, Output objId As %String) As %Status [ Private ]
{
  Set sc = $$$OK
  Try {
    Set tablename = ##class(Core).SQLTableName(classname)
    If (tablename = "") {
      Throw $$$ERROR(5517)
    }
    Set tStatement = ##class(%SQL.Statement).%New()
    Set sc = tStatement.%Prepare("SELECT *,%vid FROM (Select ID From "_tablename_") WHERE %VID = "_row)
    If ($$$ISERR(sc)) {
      Throw sc
    }
    Set results = tStatement.%Execute()
    If (results.%Next()) {
      Set objId = results.ID
    }
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod ColumnPermutation(classname As %String, propName As %String, first As %String, second As %String) As %Status [ Private ]
{
  Set sc = $$$OK
  Try {
    Set tablename = ##class(Core).SQLTableName(classname)
    Set col = ..SqlPropName(classname, propName)
    $$$THROWONERROR(sc, ..GetRow(classname, first, .firstId))
    $$$THROWONERROR(sc, ..GetRow(classname, second, .secondId))
    $$$THROWONERROR(sc, ..ColumnValue(tablename, col, firstId, .firstValue))
    $$$THROWONERROR(sc, ..ColumnValue(tablename, col, secondId, .secondValue))
    Set sql = "UPDATE "_tablename_" SET "_col_" = '"_secondValue_"' WHERE ID = '"_firstId_"' "
    $$$THROWONERROR(sc, ..UpdateExecute(sql))
    Set sql = " UPDATE "_tablename_" SET "_col_" = '"_firstValue_"' WHERE ID = '"_secondId_"' "
    $$$THROWONERROR(sc, ..UpdateExecute(sql))
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod UpdateExecute(sql As %String) As %Status [ Private ]
{
  Set sc = $$$OK
  Try {
    Set tStatement = ##class(%SQL.Statement).%New()
    Set tStatement.%SelectMode = 1
    Set sc = tStatement.%Prepare(sql)
    If ($$$ISERR(sc)) {
      Throw sc
    }
    Set rs = tStatement.%Execute()
    Throw:rs.%SQLCODE<0 ##class(%Exception.SQL).CreateFromSQLCODE(rs.%SQLCODE, "SQL ERROR: " _rs.%SQLCODE)
    If ($$$ISERR(sc)) {
      Throw sc
    }
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod ColumnValue(tablename As %String, col As %String, dataId As %String, Output value As %String) As %Status [ Private ]
{
  Set sc = $$$OK
  Try {
    Set tStatement = ##class(%SQL.Statement).%New()
    Set tStatement.%SelectMode = 1
    Set sc = tStatement.%Prepare("Select "_col_" as Value From "_tablename_" WHERE ID = '"_dataId_"'")
    If ($$$ISERR(sc)) {
      Throw sc
    }
    Set rs = tStatement.%Execute()
    If (rs.%Next()) {
      Set value = rs.Value
    }
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

ClassMethod SqlPropName(classname As %String, propName As %String) As %String [ Private ]
{
  Set class = ##class(%Dictionary.PropertyDefinition).%OpenId(classname _ "||" _ propName, .sc)
  If ($$$ISERR(sc)) {
    Return ""
  }
  Set col = class.SqlFieldName
  If (col = "") Set col = propName
  Return col
}

}
