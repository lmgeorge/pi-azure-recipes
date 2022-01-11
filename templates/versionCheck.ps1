[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string] $Path
)    
$templatePath = Resolve-Path -Path "$Path"

$listOfResources = @()

Get-ChildItem $templatePath -Recurse -Filter *.arm-template.json |
    ForEach-Object {

        $content = (Get-Content $_.FullName | ConvertFrom-Json)

        foreach ($resource in $content.resources) {
            $resourceObject = New-Object -TypeName pscustomobject -Property @{
                'fileName' = $_.FullName
                'resourceName' = $($resource.type)
                'apiVersion' = ''
                'apiVersionVariableName' = ''
                'apiVersionParameterName' = ''
                'latestApiVersion' = ''
            }

            if ($($resource.apiVersion) -like '*variables*') {
                $apiVariable = ($resource.apiVersion).replace("[variables('", '').replace("')]", '')


                $resourceObject.apiVersionVariableName = $apiVariable
                $resourceObject.apiVersion = $($($content.variables).$apiVariable)
            }
            elseif ($resource.apiVersion -like '*parameters*') {
                $apiVariable = ($resource.apiVersion).replace("[parameters('", '').replace("')]", '')


                $apiParameter = ($resource.apiVersion).replace("[parameters('", '').replace("')]", '')

                $resourceObject.apiVersionParameterName = $apiParameter
                $resourceObject.apiVersion = $($($content.parameters).$apiParameter)
            }
            else {
                $resourceObject.apiVersion = $($resource.apiVersion)
            }

            $listOfResources += $resourceObject
        }
    }

$resources = $listOfResources.resourceName | Sort-Object | Get-Unique

Foreach ($i in $resources) {	
    $providerNamespace, $resourceTypeName = $i.split('/', 2)
    $latestApiVersion = ((Get-AzureRmResourceProvider -ProviderNamespace $providerNamespace).ResourceTypes | Where-Object ResourceTypeName -EQ $resourceTypeName).ApiVersions | Select-Object -First 1

    $editObj = $listOfResources | Where-Object { $_.resourceName -eq $i }
    foreach ($r in $editObj) {
        $r.latestApiVersion = $latestApiVersion	
    }

}

Foreach ($resource in $listOfResources) {
    if ($resource.latestApiVersion -ne $resources.apiVersion) {
        Write-Host "`nThere is a new ApiVersion for $($resource.resourceName)"
        Write-Host "Filename: [$($resource.fileName)]"
        Write-Host "Current ApiVersion: [$($resource.apiVersion)]"
        Write-Host "Latest ApiVersion: [$($resource.latestApiVersion)]"
    }
}