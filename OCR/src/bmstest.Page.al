page 70006 bmstest
{
    PageType = list;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "All Control Fields";

    layout
    {
        area(Content)
        {
            repeater(RepeaterName)
            {

                field("object Type"; rec."object Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'The type of the object.';
                }
                field("Object Id"; rec."Object Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'The unique identifier of the object.';
                }
                field("Field No"; rec."Control Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'The number of the field.';
                }
                field("Field Name"; rec."Option Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'The name of the field.';
                }
                field("Field Type"; rec."Data Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'The type of the field.';
                }

            }
        }
    }


}