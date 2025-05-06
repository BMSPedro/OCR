page 70007 "bmsDoc. Intell. Mapping Line"
{
    Caption = 'Doc. Intelligence Mapping Line';
    PageType = ListPart;
    SourceTable = "BmsDoc. Intelligence Mapping";
    SourceTableTemporary = true;
    SourceTableView = where("Field Type" = filter('Line'));

    layout
    {
        area(Content)
        {
            repeater(Repeater)
            {
                field(ColumnValues1; columnValues[1])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[1];
                    ToolTip = 'The value of the field.';
                }
                field(ColumnValues2; columnValues[2])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[2];
                    ToolTip = 'The value of the field.';
                }
                field(ColumnValues3; columnValues[3])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[3];
                    ToolTip = 'The value of the field.';
                }
                field(ColumnValues4; columnValues[4])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[4];
                    ToolTip = 'The value of the field.';
                }
                field(ColumnValues5; columnValues[5])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[5];
                    ToolTip = 'The value of the field.';
                }
                field(ColumnValues6; columnValues[6])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[6];
                    ToolTip = 'The value of the field.';
                }
                field(ColumnValues7; columnValues[7])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[7];
                    ToolTip = 'The value of the field.';
                }
                field(ColumnValues8; columnValues[8])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[8];
                    ToolTip = 'The value of the field.';
                }
                field(ColumnValues9; columnValues[9])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[9];
                    ToolTip = 'The value of the field.';
                }
                field(ColumnValues10; columnValues[10])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[10];
                    ToolTip = 'The value of the field.';
                }
                field(ColumnValues11; columnValues[11])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[11];
                    ToolTip = 'The value of the field.';
                }
                field(ColumnValues12; columnValues[12])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[12];
                    ToolTip = 'The value of the field.';
                }
                field(ColumnValues13; columnValues[13])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[13];
                    ToolTip = 'The value of the field.';
                }
                field(ColumnValues14; columnValues[14])
                {
                    ApplicationArea = All;
                    AutoFormatType = 11;
                    CaptionClass = '3,' + columnCaption[14];
                    ToolTip = 'The value of the field.';
                }
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



    var
        TempbmsDocIntelligenceMapping: Record "BmsDoc. Intelligence Mapping" temporary;
        columnValues: array[30] of Text;
        columnCaption: array[30] of Text;
        noOfColumns: Integer;
        lineNo: Integer;

    trigger OnAfterGetRecord()
    begin
        if lineNo <> rec."Line No." then begin
            noOfColumns := 0;
            TempbmsDocIntelligenceMapping.Reset();
            TempbmsDocIntelligenceMapping.SetRange("Field Type", 'Line');
            TempbmsDocIntelligenceMapping.SetRange("Line No.", rec."Line No.");
            if TempbmsDocIntelligenceMapping.FindSet() then
                repeat
                    noOfColumns := noOfColumns + 1;
                    lineNo := TempbmsDocIntelligenceMapping."Line No.";
                    columnCaption[noOfColumns] := TempbmsDocIntelligenceMapping."Field Name";
                    columnValues[noOfColumns] := TempbmsDocIntelligenceMapping."Field Value";
                until TempbmsDocIntelligenceMapping.Next() = 0;
            lineNo := rec."Line No.";


        end;
        rec.SetRange("Field Type", 'Line');

        CurrPage.Update(false);

        /*
        Clear(columnCaption);
        Clear(columnValues);
        TempbmsDocIntelligenceMapping.Reset();
        TempbmsDocIntelligenceMapping.SetRange("Field Type", 'Line');
        if TempbmsDocIntelligenceMapping.FindSet() then
            repeat
                if lineNo = TempbmsDocIntelligenceMapping."Line No." then begin
                    noOfColumns := noOfColumns + 1;
                    lineNo := TempbmsDocIntelligenceMapping."Line No.";
                    columnCaption[noOfColumns] := TempbmsDocIntelligenceMapping."Field Name";
                    columnValues[noOfColumns] := TempbmsDocIntelligenceMapping."Field Value";
                end else begin
                    noOfColumns := noOfColumns + 1;
                    lineNo := TempbmsDocIntelligenceMapping."Line No.";
                    columnCaption[noOfColumns] := TempbmsDocIntelligenceMapping."Field Name";
                    columnValues[noOfColumns] := TempbmsDocIntelligenceMapping."Field Value";
                end;

            until TempbmsDocIntelligenceMapping.Next() = 0;
        CurrPage.Update(false);
        */

    end;



    internal procedure Load(var bmsDocIntelligenceMapping: Record "BmsDoc. Intelligence Mapping" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();
        Rec.Copy(bmsDocIntelligenceMapping, true);
        TempbmsDocIntelligenceMapping.Copy(bmsDocIntelligenceMapping, true);

        CurrPage.Update(false);
    end;
}