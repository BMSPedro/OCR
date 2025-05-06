table 70001 "bmsBlob Storage Documents"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "file Name"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Creation Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Size; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Document origin"; Enum "bmsDocument Origin")
        {
            DataClassification = ToBeClassified;
        }
        field(6; Status; Enum "Blob Storage Document Status")
        {
            DataClassification = ToBeClassified;
        }
        field(7; "File Url"; Text[2048])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Url;
        }
    }

    keys
    {
        key(Key1; "file Name")
        {
            Clustered = true;
        }
    }


    procedure ReadContainerfile()
    var
        ABSContainerContent: Record "ABS Container Content";
        blobDocument: Record "bmsBlob Storage Documents";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        ABSBlobClient: Codeunit "ABS Blob Client";
        ABSOperationResponse: Codeunit "ABS Operation Response";
        Authorization: Interface "Storage Service Authorization";
        blobStorageStatus: Enum "Blob Storage Document Status";
        AccountAccessKey: text;
        AccountName: Text;
        AccountContainer: Text;
        fileUrlComposeLbl: Label 'https://%1.blob.core.windows.net/%2/', Comment = '%1 = AccountName, %2 = AccountContainer';
        fileUrlCompose: Text;
    begin
        AccountAccessKey := 'x5e70oCNv5DWA2gRJK6rBJgr7TdtduKfkr3yK1GhwIpPU3pwCWDApxq1+aSX1av+LC0Jns7X7qCL+ASt9xjpIQ==';
        AccountName := 'solerbc';
        AccountContainer := 'soleredi';
        fileUrlCompose := strSubstNo(fileUrlComposeLbl, AccountName, AccountContainer);
        Authorization := StorageServiceAuthorization.CreateSharedKey(AccountAccessKey);
        ABSBlobClient.Initialize(AccountName, AccountContainer, Authorization);
        ABSOperationResponse := ABSBlobClient.ListBlobs(ABSContainerContent);
        if ABSOperationResponse.IsSuccessful() then begin
            ABSContainerContent.Reset();
            if ABSContainerContent.FindSet() then
                repeat
                    if not Rec.get(ABSContainerContent."Full Name") then begin
                        blobDocument.Reset();
                        if blobDocument.FindLast() then
                            Rec."Entry No." := blobDocument."Entry No.";

                        Rec."Entry No." := Rec."Entry No." + 1;
                        Rec."file Name" := ABSContainerContent."Full Name";
                        rec."File Url" := fileUrlCompose + ABSContainerContent."Full Name";
                        Rec."Creation Date" := ABSContainerContent."Creation Time";
                        Rec.Size := ABSContainerContent."Content Length";
                        Rec.Status := blobStorageStatus::Received;
                        Rec.Insert();
                    end;
                until ABSContainerContent.Next() = 0;
        end;
    end;

}
