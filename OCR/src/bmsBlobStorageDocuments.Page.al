page 70001 "bmsBlob Storage Documents"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "bmsBlob Storage Documents";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                repeater(RepeaterName)
                {
                    field(EntryNo; rec."Entry No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'The unique identifier of the document.';
                    }
                    field("file Name"; rec."file Name")
                    {
                        ApplicationArea = All;
                        ToolTip = 'The name of the file.';
                    }
                    field("Creation Date"; rec."Creation Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'The date and time when the document was created.';
                    }
                    field(Size; rec.Size)
                    {
                        ApplicationArea = All;
                        ToolTip = 'The size of the document in bytes.';
                    }
                    field("Document origin"; rec."Document origin")
                    {
                        ApplicationArea = All;
                        ToolTip = 'The unique identifier of the document.';
                    }
                    field(Status; rec.Status)
                    {
                        ApplicationArea = All;
                        ToolTip = 'The status of the document.';
                    }
                    field("File Url"; rec."File Url")
                    {
                        ApplicationArea = All;
                        ExtendedDatatype = Url;
                        ToolTip = 'The URL of the file.';
                    }
                }
            }
        }
        area(FactBoxes)
        {
            part("bmsPDFV PDF Viewer Factbox"; "bmsPDF Viewer Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "file Name" = field("file Name");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ProcessDoc)
            {
                ApplicationArea = All;
                ToolTip = 'Process Document intelligence AI.';
                Caption = 'Process Document';
                Image = NewOpportunity;
                trigger OnAction()
                var
                    bmsDocIntelligenceProcess: Page "bmsDoc. Intelligence Process";
                begin
                    bmsDocIntelligenceProcess.SetFile(rec);
                    bmsDocIntelligenceProcess.RunModal();
                end;
            }
        }
        area(Promoted)
        {
            group(Process)
            {
                actionref(ProcessDoc_Prom; ProcessDoc)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        rec.ReadContainerfile();
    end;


}

