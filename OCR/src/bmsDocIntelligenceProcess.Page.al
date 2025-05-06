page 70005 "bmsDoc. Intelligence Process"
{
    PageType = PromptDialog;
    ApplicationArea = All;
    Extensible = false;
    PromptMode = Prompt;
    Caption = 'Process Document Intelligence AI';

    layout
    {
        area(Prompt)
        {
            field("File Name"; pageTitle + ' ' + documentType)
            {
                Caption = 'File Name';
                ToolTip = 'File Name';
                Editable = false;
            }
            field(PromptText; prompt)
            {
                Caption = 'Prompt';
                MultiLine = true;
                ToolTip = 'Prompt';
                Visible = true;
            }
        }
        area(Content)
        {
            part("Doc. Intelligence Mapping"; "bmsDoc. Intelligence Mapping")
            {
                ApplicationArea = all;
                ShowFilter = false;
                Caption = 'Document Intelligence Mapping';
            }
            part("Doc. Intelligence Mapping Line"; "bmsDoc. Intell. Mapping Line")
            {
                ApplicationArea = all;
                ShowFilter = false;
                Editable = false;
                Caption = 'Document Intelligence Mapping Line';
            }

        }
    }
    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Generate';
                ToolTip = 'Generate from Copilot.';
                trigger OnAction()
                var
                    docIntelligenceMngt: Codeunit "AI Document Intelligence Mngt";
                    matchJson: JsonObject;
                    linesJsonArray: JsonArray;
                    jsonTokenValue: JsonToken;
                    jkeyHeader: Text;
                    jkeyDetails: Text;
                    linesJsonObject: JsonObject;
                    listDetails: List of [Text];
                    listHeader: List of [Text];
                    LineNo: Integer;
                begin
                    docIntelligenceMngt.FetchFileAndGetDocType(bmsStorageDocument."File Url", prompt, documentType, tableStructure, docJsonStructure, match);
                    /*
                     match := '{"Order Date": "01/01/2025","Client Name": "Client 1","VAT Number": "FR777777777777","Address": "France","Order Number": "000001","Quote Number": "1","Delivery Condition": "",'
   + '"Details": [{"Item Number": "01","Description": "Sac Charbon","Quantity": "2","Unit": "Palettes","Unit Price (Excl. VAT)": "30,00","VAT Rate": "10","Line Amount": "60,00"},'
   + '{"Item Number": "02","Description": "Sac Charbon","Quantity": "4","Unit": "Palettes","Unit Price (Excl. VAT)": "30,00","VAT Rate": "10","Line Amount": "60,00"}],"Subtotal": "60,00","VAT Amount": "6,00","Total (Incl. VAT)": "66,00"}';
 */
                    matchJson.ReadFrom(match);

                    listHeader := matchJson.Keys;
                    foreach jkeyHeader in listHeader do
                        if jkeyHeader <> 'Details' then begin
                            matchJson.Get(jkeyHeader, jsonTokenValue);
                            TempbmsdocIntelligenceMapping."Field Name" := CopyStr(jkeyHeader, 1, 200);
                            TempbmsdocIntelligenceMapping."Field Value" := CopyStr(jsonTokenValue.AsValue().AsText(), 1, 2028);
                            TempbmsdocIntelligenceMapping."Field Type" := 'Header';
                            TempbmsdocIntelligenceMapping.Insert();
                        end else begin
                            clear(linesJsonArray);
                            matchJson.Get(jkeyHeader, jsonTokenValue);
                            linesJsonArray := jsonTokenValue.AsArray();
                            foreach jsonTokenValue in LinesJsonArray do begin
                                linesJsonObject := jsonTokenValue.AsObject();
                                listDetails := linesJsonObject.Keys;
                                LineNo := LineNo + 1;
                                foreach jkeyDetails in listDetails do begin
                                    TempbmsdocIntelligenceMapping."Field Name" := CopyStr(jkeyDetails, 1, 200);
                                    linesJsonObject.Get(jkeyDetails, jsonTokenValue);
                                    TempbmsdocIntelligenceMapping."Field Value" := CopyStr(jsonTokenValue.AsValue().AsText(), 1, 2048);
                                    TempbmsdocIntelligenceMapping."Field Type" := 'Line';
                                    TempbmsdocIntelligenceMapping."Line No." := LineNo;
                                    TempbmsdocIntelligenceMapping.Insert();
                                end;
                            end;
                        end;

                    CurrPage."Doc. Intelligence Mapping".Page.Load(TempbmsdocIntelligenceMapping);
                    CurrPage."Doc. Intelligence Mapping Line".Page.Load(TempbmsdocIntelligenceMapping);
                end;
            }
        }
    }

    var
        bmsStorageDocument: Record "bmsBlob Storage Documents";
        TempbmsdocIntelligenceMapping: Record "bmsDoc. Intelligence Mapping" temporary;
        prompt: Text;
        pageTitle: Text;
        match: text;
        documentType: Text;
        tableStructure: Text;
        docJsonStructure: Text;

    trigger OnOpenPage()
    begin
        pageTitle := bmsStorageDocument."file Name";
        CurrPage.Caption := pageTitle + ' ' + documentType;
    end;

    procedure setFile(bmsBlobStorageDocumentsP: Record "bmsBlob Storage Documents")
    begin
        bmsStorageDocument := bmsBlobStorageDocumentsP;
    end;
}