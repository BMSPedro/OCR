table 70003 "bmsDoc. Intelligence Mapping"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Field Name"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Field Value"; Text[2048])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Field Type"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Field Name")
        {
            Clustered = true;
        }
    }
}