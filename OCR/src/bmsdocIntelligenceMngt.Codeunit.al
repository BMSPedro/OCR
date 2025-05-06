codeunit 70002 "bmsdocIntelligenceMngt"
{
    procedure SendDocumentToAI(docUrl: Text): Text
    var
        HttpClient: HttpClient;
        RequestHeader: HttpHeaders;
        RequestURILbl: Label 'https://doccapturebc.cognitiveservices.azure.com/documentintelligence/documentModels/prebuilt-layout';
        apiVersionLbl: Label 'api-version=2024-11-30';
        RequestURI: Text;
        httpContent: HttpContent;
        httpReponseMsg: HttpResponseMessage;
        httpRequestMsg: HttpRequestMessage;
        Response: array[3] of text;
    begin
        Response[2] := '{"urlSource": "' + docUrl + '?sp=Your token"}';
        httpcontent.WriteFrom(response[2]);

        RequestHeader.Clear();
        httpContent.GetHeaders(RequestHeader);
        RequestHeader.Remove('Content-Type');
        RequestHeader.Add('Content-Type', 'application/json');
        RequestHeader.Add('Ocp-Apim-Subscription-Key', 'Your key');

        //RequestURI := 'https://doccapturebc.cognitiveservices.azure.com/documentintelligence/documentModels/prebuilt-layout:analyze?_overload=analyzeDocument&api-version=2024-11-30';
        RequestURI := RequestURILbl + ':analyze?_overload=analyzeDocument&' + apiVersionLbl;
        httpRequestMsg.SetRequestUri(RequestURI);
        httpRequestMsg.Method('POST');

        httpRequestMsg.Content := httpContent;

        httpclient.Send(httpRequestMsg, httpReponseMsg);


        if not httpReponseMsg.IsSuccessStatusCode() then
            error(httpReponseMsg.ReasonPhrase)
        else begin
            Sleep(5000);

            httpReponseMsg.Headers.GetValues('apim-request-id', Response);
            Clear(HttpClient);
            Clear(httpRequestMsg);
            Clear(httpReponseMsg);
            RequestHeader.Clear();
            httpContent.GetHeaders(RequestHeader);
            RequestHeader.Add('Ocp-Apim-Subscription-Key', 'Your key');

            RequestURI := RequestURILbl + '/analyzeResults/' + Response[1] + '?' + apiVersionLbl;
            httpRequestMsg.SetRequestUri(RequestURI);
            httpRequestMsg.Method('GET');

            httpRequestMsg.Content := httpContent;

            httpclient.Send(httpRequestMsg, httpReponseMsg);

            if not httpReponseMsg.IsSuccessStatusCode() then
                error(httpReponseMsg.ReasonPhrase)
            else begin
                httpContent := httpReponseMsg.Content;
                httpContent.ReadAs(Response[3]);
                exit(Response[3]);
            end;
        end;
    end;
}
