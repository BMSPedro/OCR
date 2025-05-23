codeunit 70001 "bmsSecrets And Cap Sep Intern"
{
    Subtype = Install;
    InherentEntitlements = X;
    InherentPermissions = X;
    Access = Internal;

    trigger OnInstallAppPerDatabase()
    begin
        RegisterCapability();
    end;

    local procedure RegisterCapability()
    var
        EnvironmentInfo: Codeunit "Environment Information";
        CopilotCapability: Codeunit "Copilot Capability";
    begin
        // Verify that environment in a Business Central online environment
        if EnvironmentInfo.IsSaaSInfrastructure() then
            // Register capability 
            if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Document Intelligence") then
                CopilotCapability.RegisterCapability(
                      Enum::"Copilot Capability"::"Document Intelligence",
                      Enum::"Copilot Availability"::Preview, '');

        IsolatedStorage.Set('Endpoint', 'https://your model.openai.azure.com/');
        IsolatedStorage.Set('Deployment', 'gpt-4');
        IsolatedStorage.Set('Apikey', 'Your key');
    end;
}
