page 70002 "bmsPDF Viewer Factbox"
{

    Caption = 'PDF Viewer';
    PageType = ListPart;
    SourceTable = "bmsBlob Storage Documents";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;
                usercontrol(PDFViewer; "bmsPDF Viewer")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetPDFDocument();
    end;

    local procedure SetPDFDocument()
    var
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        ABSBlobClient: Codeunit "ABS Blob Client";
        ABSOperationResponse: Codeunit "ABS Operation Response";
        Base64Convert: Codeunit "Base64 Convert";
        Authorization: Interface "Storage Service Authorization";
        AccountAccessKey: text;
        AccountName: Text;
        AccountContainer: Text;
        fileUrlComposeLbl: Label 'https://%1.blob.core.windows.net/%2/', Comment = '%1 = AccountName, %2 = AccountContainer';
        fileUrlCompose: Text;
        instr: InStream;
        PDFAsTxt: Text;
    begin
        AccountAccessKey := 'your key';
        AccountName := 'Your account';
        AccountContainer := 'Your container';
        fileUrlCompose := strSubstNo(fileUrlComposeLbl, AccountName, AccountContainer);
        Authorization := StorageServiceAuthorization.CreateSharedKey(AccountAccessKey);
        ABSBlobClient.Initialize(AccountName, AccountContainer, Authorization);
        Clear(instr);
        ABSOperationResponse := ABSBlobClient.GetBlobAsStream(rec."file Name", instr);
        CurrPage.PDFViewer.SetVisible(true);
        PDFAsTxt := Base64Convert.ToBase64(instr);

        CurrPage.PDFViewer.LoadPDF(PDFAsTxt, true);
        CurrPage.Update(false);
    end;

}
