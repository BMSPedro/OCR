page 70004 "bmsDoc. Intelligence Mapping"
{
    Caption = 'Doc. Intelligence Mapping Card';
    PageType = CardPart;
    SourceTable = "BmsDoc. Intelligence Mapping";
    SourceTableTemporary = true;
    SourceTableView = where("Field Type" = filter('Header'));

    layout
    {
        area(Content)
        {
            group(Group1)
            {
                ShowCaption = false;
                field(ColumnValues1; columnValues[1])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[1];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group2)
            {
                Visible = NoOfColumns >= 2;
                ShowCaption = false;
                field(ColumnValues2; columnValues[2])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[2];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group3)
            {
                Visible = NoOfColumns >= 3;
                ShowCaption = false;
                field(ColumnValues3; columnValues[3])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[3];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group4)
            {
                Visible = NoOfColumns >= 4;
                ShowCaption = false;
                field(ColumnValues4; columnValues[4])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[4];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group5)
            {
                Visible = NoOfColumns >= 5;
                ShowCaption = false;
                field(ColumnValues5; columnValues[5])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[5];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group6)
            {
                Visible = NoOfColumns >= 6;
                ShowCaption = false;
                field(ColumnValues6; columnValues[6])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[6];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group7)
            {
                Visible = NoOfColumns >= 7;
                ShowCaption = false;
                field(ColumnValues7; columnValues[7])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[7];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group8)
            {
                Visible = NoOfColumns >= 8;
                ShowCaption = false;
                field(ColumnValues8; columnValues[8])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[8];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group9)
            {
                Visible = NoOfColumns >= 9;
                ShowCaption = false;
                field(ColumnValues9; columnValues[9])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[9];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group10)
            {
                Visible = NoOfColumns >= 10;
                ShowCaption = false;
                field(ColumnValues10; columnValues[10])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[10];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group11)
            {
                Visible = NoOfColumns >= 11;
                ShowCaption = false;
                field(ColumnValues11; columnValues[11])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[11];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group12)
            {
                Visible = NoOfColumns >= 12;
                ShowCaption = false;
                field(ColumnValues12; columnValues[12])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[12];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group13)
            {
                Visible = NoOfColumns >= 13;
                ShowCaption = false;
                field(ColumnValues13; columnValues[13])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[13];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group14)
            {
                Visible = NoOfColumns >= 14;
                ShowCaption = false;
                field(ColumnValues14; columnValues[14])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[14];
                    ToolTip = 'The value of the field.';
                }
            }
            group(Group15)
            {
                Visible = NoOfColumns >= 15;
                ShowCaption = false;
                field(ColumnValues15; columnValues[15])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[15];
                    ToolTip = 'The value of the field.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Clear(columnCaption);
        Clear(columnValues);
        TempbmsDocIntelligenceMapping.Reset();
        TempbmsDocIntelligenceMapping.SetRange("Field Type", 'Header');
        if TempbmsDocIntelligenceMapping.FindSet() then
            repeat
                noOfColumns := noOfColumns + 1;
                columnCaption[noOfColumns] := TempbmsDocIntelligenceMapping."Field Name";
                columnValues[noOfColumns] := TempbmsDocIntelligenceMapping."Field Value";
            until TempbmsDocIntelligenceMapping.Next() = 0;
        CurrPage.Update(false);
    end;

    internal procedure Load(var bmsDocIntelligenceMappingP: Record "BmsDoc. Intelligence Mapping" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();
        rec.Copy(bmsDocIntelligenceMappingP, true);
        TempbmsDocIntelligenceMapping.Copy(bmsDocIntelligenceMappingP, true);

        CurrPage.Update(false);
    end;

    var
        TempbmsDocIntelligenceMapping: Record "BmsDoc. Intelligence Mapping" temporary;
        columnValues: array[30] of Text;
        columnCaption: array[30] of Text;
        noOfColumns: Integer;
}