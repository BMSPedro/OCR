codeunit 70004 bmsGetPageFields
{
    procedure GetPageFields(documentType: Text): Text
    var
        allControlField: record "All Control Fields";
        headerJsonObject: JsonObject;
        lineJsonObject: JsonObject;
        jsonArray: JsonArray;
        Result: Text;
        linePageID: Integer;
        headerPageID: Integer;
    begin
        case documentType of
            'Sales Quote':
                begin
                    headerPageID := 42;
                    linePageID := 46;
                end;
            'Sales Order':
                begin
                    headerPageID := 42;
                    linePageID := 46;
                end;
            'Sales Credit Memo':
                begin
                    headerPageID := 42;
                    linePageID := 46;
                end;
            'Sales Return Order':
                begin
                    headerPageID := 42;
                    linePageID := 46;
                end;
            'Purchase Quote':
                begin
                    headerPageID := 42;
                    linePageID := 46;
                end;
            'Purchase Order':
                begin
                    headerPageID := 50;
                    linePageID := 54;
                end;
            'Purchase Invoice':
                begin
                    headerPageID := 42;
                    linePageID := 46;
                end;
            'Purhase Credit Memo':
                begin
                    headerPageID := 42;
                    linePageID := 46;
                end;
            'Purchase Return Order':
                begin
                    headerPageID := 42;
                    linePageID := 46;
                end;
        end;

        allControlField.reset();
        allControlField.setrange("object Type", 8);
        allControlField.setrange("Object Id", headerPageID);
        if allControlField.findset() then;
        repeat
            headerJsonObject.Add(allControlField."Control Name", '');
        until allControlField.next() = 0;

        allControlField.reset();
        allControlField.setrange("object Type", 8);
        allControlField.setrange("Object Id", linePageID);
        if allControlField.findset() then;
        repeat
            lineJsonObject.Add(allControlField."Control Name", '');
        until allControlField.next() = 0;

        jsonArray.Add(lineJsonObject);
        headerJsonObject.Add('lines', jsonArray);
        headerJsonObject.WriteTo(Result);
        exit(Result);
    end;

}