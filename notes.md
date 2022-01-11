# Tools
1. Powershell
2. Azure CLI
3. Azure Az Powershell Module

# Setting up IOT hub
Means: VS Code
Configuration
    Subscription selected: OCTO - MakeIT2
    Resource Group selected: lmg-azurepirecipes-rg
    Location selected: West US 2
    Pricing and scale tier selected: F1: Free tier
    Creating IoT Hub: lmg-azurepirecipes-iothub

Error: 
    The subscription is not registered to use namespace 'Microsoft.Devices'. See https://aka.ms/rps-not-found for how to register subscriptions.

## Running locally

1. Install [Azure Functions Core Tools] manually
2. Resolve extension bundles issue
    
    - **Error**
        ```log
        Azure Functions Core Tools
        Core Tools Version:       3.0.3568 Commit hash: e30a0ede85fd498199c28ad699ab2548593f759b  (64-bit)
        Function Runtime Version: 3.0.15828.0

        [2021-10-13T01:59:51.149Z] Building host: startup suppressed: 'False', configuration suppressed: 'False', startup operation id: '07bfef64-bc44-4ee5-8d11-4be2ee6fd20e'
        [2021-10-13T01:59:51.205Z] Reading host configuration file '/home/laurengeorge/projects/pi-azure-recipes/01_iot/data_processing/host.json'
        [2021-10-13T01:59:51.206Z] Host configuration file read:
        [2021-10-13T01:59:51.206Z] {
        [2021-10-13T01:59:51.206Z]   "version": "2.0",
        [2021-10-13T01:59:51.206Z]   "logging": {
        [2021-10-13T01:59:51.206Z]     "applicationInsights": {
        [2021-10-13T01:59:51.206Z]       "samplingSettings": {
        [2021-10-13T01:59:51.206Z]         "isEnabled": true,
        [2021-10-13T01:59:51.206Z]         "excludedTypes": "Request"
        [2021-10-13T01:59:51.207Z]       }
        [2021-10-13T01:59:51.207Z]     }
        [2021-10-13T01:59:51.207Z]   },
        [2021-10-13T01:59:51.207Z]   "extensionBundle": {
        [2021-10-13T01:59:51.207Z]     "id": "Microsoft.Azure.Functions.ExtensionBundle",
        [2021-10-13T01:59:51.207Z]     "version": "[2.*, 3.0.0)"
        [2021-10-13T01:59:51.207Z]   }
        [2021-10-13T01:59:51.207Z] }
        [2021-10-13T01:59:51.306Z] Loading functions metadata
        [2021-10-13T01:59:51.319Z] FUNCTIONS_WORKER_RUNTIME set to python. Skipping WorkerConfig for language:node
        [2021-10-13T01:59:51.321Z] FUNCTIONS_WORKER_RUNTIME set to python. Skipping WorkerConfig for language:java
        [2021-10-13T01:59:51.323Z] FUNCTIONS_WORKER_RUNTIME set to python. Skipping WorkerConfig for language:powershell
        [2021-10-13T01:59:51.327Z] Reading functions metadata
        [2021-10-13T01:59:51.335Z] 1 functions found
        [2021-10-13T01:59:51.346Z] 1 functions loaded
        [2021-10-13T01:59:51.350Z] Looking for extension bundle Microsoft.Azure.Functions.ExtensionBundle at /home/laurengeorge/.azure-functions-core-tools/Functions/ExtensionBundles/Microsoft.Azure.Functions.ExtensionBundle
        [2021-10-13T01:59:51.352Z] Found a matching extension bundle at /home/laurengeorge/.azure-functions-core-tools/Functions/ExtensionBundles/Microsoft.Azure.Functions.ExtensionBundle/2.6.1
        [2021-10-13T01:59:51.354Z] Fetching information on versions of extension bundle Microsoft.Azure.Functions.ExtensionBundle available on https://functionscdn.azureedge.net/public/ExtensionBundles/Microsoft.Azure.Functions.ExtensionBundle/index.json
        System.ArgumentNullException: Value cannot be null. (Parameter 'provider')
        at Microsoft.Extensions.DependencyInjection.ServiceProviderServiceExtensions.GetRequiredService[T](IServiceProvider provider)
        at Azure.Functions.Cli.Actions.HostActions.StartHostAction.RunAsync() in D:\a\1\s\src\Azure.Functions.Cli\Actions\HostActions\StartHostAction.cs:line 344
        at Azure.Functions.Cli.ConsoleApp.RunAsync[T](String[] args, IContainer container) in D:\a\1\s\src\Azure.Functions.Cli\ConsoleApp.cs:line 66
        [2021-10-13T02:02:09.339Z] Stopping host...
        [2021-10-13T02:02:09.341Z] Host shutdown completed.
        ```

    - **Solution**
        - Removed the `extensionBundle` block from `data_processing/host.json`
        - See: https://github.com/Azure/azure-functions-core-tools/issues/2232#issuecomment-781818217

3. Trigger the function by going to: http://localhost:7071/admin/functions/telemetry_saver
    
    Sample of successful output:

    ```log
    [2021-10-13T02:04:01.978Z] Executing HTTP request: {
    [2021-10-13T02:04:01.979Z]   requestId: "9feadf9a-a28d-477a-9928-010b57c6cb72",
    [2021-10-13T02:04:01.979Z]   method: "GET",
    [2021-10-13T02:04:01.980Z]   userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36 Edg/94.0.992.38",
    [2021-10-13T02:04:01.980Z]   uri: "/admin/functions/telemetry_saver"
    [2021-10-13T02:04:01.981Z] }
    [2021-10-13T02:04:02.094Z] Loading functions metadata
    [2021-10-13T02:04:02.094Z] Reading functions metadata
    [2021-10-13T02:04:02.096Z] 1 functions found
    [2021-10-13T02:04:02.097Z] 1 functions loaded
    [2021-10-13T02:04:02.148Z] Executed HTTP request: {
    [2021-10-13T02:04:02.148Z]   requestId: "9feadf9a-a28d-477a-9928-010b57c6cb72",
    [2021-10-13T02:04:02.148Z]   identities: "(WebJobsAuthLevel:Admin, WebJobsAuthLevel:Admin)",
    [2021-10-13T02:04:02.149Z]   status: "200",
    [2021-10-13T02:04:02.149Z]   duration: "169"
    [2021-10-13T02:04:02.149Z] }
    ```

<!-- References -->
[Azure CLI]: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
[Azure Functions Core Tools]: https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=v3%2Clinux%2Cpython%2Cazurecli%2Cbash%2Ckeda#install-the-azure-functions-core-tools
[Powershell]: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell
