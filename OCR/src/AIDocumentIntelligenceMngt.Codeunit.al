codeunit 70003 "AI Document Intelligence Mngt"
{

    procedure FetchFileAndGetDocType(docUrl: text; prompt: text; documentType: text; var tablestructure: text; var docJsonStructure: text; var match: text)
    var
        AzureOpenAI: Codeunit "Azure OpenAI";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        SendPDFTODocumentIntelligence: Codeunit "bmsdocIntelligenceMngt";
        gettable: Codeunit "bmsGetPageFields";
        AOIToken: Codeunit "AOAI Token";
        MetaPrompt: text;
    begin
        if (tablestructure = '') and (docJsonStructure = '') then begin
            if not AzureOpenAI.IsEnabled(Enum::"Copilot Capability"::"Document Intelligence") then
                exit;

            AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"Document Intelligence");
            SetAuthorization(AzureOpenAI);
            SetParameters(AOAIChatCompletionParams);

            AOAIChatCompletionParams.SetTemperature(0);

            if AOIToken.GetGPT4TokenCount(Metaprompt) + AOIToken.GetGPT4TokenCount(Prompt) <=
               MaxModelRequestTokens() then begin

                docJsonStructure := SendPDFTODocumentIntelligence.SendDocumentToAI(docUrl);
                MetaPrompt := 'Using the following Json structure: ' + docJsonStructure + ' from the Document Intelligente AI process, determine which document it is in the following list:'
                + 'Sales Quote, Sales Order, Sales Invoice, Sales Credit Memo, Sales Return Order, Purchase Quote, Purchase Order, Purchase Invoice, Purchase Credit Memo, Purchase Return Order'
                + 'the response must be unique and strictly the type in the list so that the value can be used directly in a procedure'
                + 'Please note that our company is Cegelec IT and our VAT number is FR88537915530, in order to distinguish whether it is a purchase or a sale invoice for us.';

                AOAIChatMessages.AddSystemMessage(Metaprompt);

                AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);

                if AOAIOperationResponse.IsSuccess() then begin
                    documentType := AOAIChatMessages.GetLastMessage();
                    tableStructure := gettable.GetPageFields(documentType);
                    MatchingDocContectandTableStructure(prompt, tablestructure, docJsonStructure, match);
                end else
                    error(AOAIOperationResponse.GetError());
            end;
        end else
            MatchingDocContectandTableStructure(prompt, tablestructure, docJsonStructure, match);
    end;

    local procedure MatchingDocContectandTableStructure(prompt: text; tablestructure: text; docJsonStructure: text; var match: text): Text;
    var
        AzureOpenAI: Codeunit "Azure OpenAI";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AOIToken: Codeunit "AOAI Token";
        MetaPrompt: text;
    begin
        if not AzureOpenAI.IsEnabled(Enum::"Copilot Capability"::"Document Intelligence") then
            exit;

        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"Document Intelligence");
        SetAuthorization(AzureOpenAI);
        SetParameters(AOAIChatCompletionParams);

        MetaPrompt := 'map the file read ' + docJsonStructure + ' to table structure ' + tablestructure + ' and provide result only with field having values, structure in json format field - value'
        + 'strictly as in the following example: { "field1": "value1", "field2": "value2","Details": [{"field3": "value3", "field4": "value4"}]}';

        AOAIChatCompletionParams.SetTemperature(0);

        if AOIToken.GetGPT4TokenCount(Metaprompt) + AOIToken.GetGPT4TokenCount(Prompt) <=
           MaxModelRequestTokens() then begin

            AOAIChatMessages.AddSystemMessage(Metaprompt);
            AOAIChatMessages.AddUserMessage(Prompt);

            AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);

            if AOAIOperationResponse.IsSuccess() then
                match := AOAIChatMessages.GetLastMessage()
            else
                error(AOAIOperationResponse.GetError());
        end;
    end;

    local procedure SetAuthorization(var AzureOpenAI: Codeunit "Azure OpenAI")
    var
        Endpoint: Text;
        Deployment: Text;
        Apikey: SecretText;
    begin
        IsolatedStorage.Get('Endpoint', Endpoint);
        IsolatedStorage.Get('Deployment', Deployment);
        IsolatedStorage.Get('Apikey', Apikey);

        AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", Endpoint, Deployment, Apikey);
    end;

    local procedure SetParameters(var AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params")
    begin
        AOAIChatCompletionParams.SetMaxTokens(2500);
        AOAIChatCompletionParams.SetTemperature(0);
    end;

    local procedure MaxModelRequestTokens(): integer
    begin
        exit(60000) // Assuming it's GPT-4
    end;

}