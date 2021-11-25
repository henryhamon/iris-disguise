Class dc.Disguise.DataTypes.String Extends %Library.String
{

/// Field Strategy Type
/// Could be Destruction, Scramble, or Shuffling
Parameter FieldStrategy [ Constraint = ",DESTRUCTION,SCRAMBLE,SHUFFLING", Flags = ENUMEDIT ] = "DESTRUCTION";

Parameter Mask = "X";

}
