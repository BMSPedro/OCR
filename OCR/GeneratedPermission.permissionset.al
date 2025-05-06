namespace BlobDC;

permissionset 70001 GeneratedPermission
{
    Assignable = true;
    Permissions = tabledata "bmsBlob Storage Documents" = RIMD,
        table "bmsBlob Storage Documents" = X,
        page "bmsBlob Storage Documents" = X,
        tabledata "bmsDoc. Intelligence Mapping" = RIMD,
        table "bmsDoc. Intelligence Mapping" = X,
        codeunit "AI Document Intelligence Mngt" = X,
        codeunit bmsdocIntelligenceMngt = X,
        codeunit bmsGetPageFields = X,
        codeunit "bmsSecrets And Cap Sep Intern" = X,
        page "bmsPDF Viewer Factbox" = X,
        page bmstest = X;
}