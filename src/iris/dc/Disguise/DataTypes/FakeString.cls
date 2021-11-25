Class dc.Disguise.DataTypes.FakeString Extends %Library.String
{

/// Field Strategy Type
/// Could be a Email, First Name, Company, etc.
Parameter FieldStrategy [ Constraint = ",FIRSTNAME,LASTNAME,FULLNAME,COMPANY,COUNTRY,CITY,EMAIL", Flags = ENUMEDIT ] = "FULLNAME";

}
