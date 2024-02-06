<#
This script is triggered as post-build event
#>

param([string]$projectDir, [string]$outputPath, [string]$configuration);

"ProjectDir = $projectDir"
"OutputPath = $outputPath"
"configuration = $configuration"

"Copying dlls to output dir..."
$dlls_path = if($configuration -eq "Release")
{
	"dlls-release"
}
else
{
	"dlls"
}
Copy-Item -Path "$projectDir\dependencies\$dlls_path\*" -Destination "$outputPath" -Force -Recurse # without \*, $dlls_path subdirectory will be copied to output.

"Copying assets to output dir..."
Copy-Item -Path "$projectDir\assets" -Destination "$outputPath" -Force -Recurse # copies assets folder

"Copying shaders to output dir..."
Copy-Item -Path "$projectDir\shaders" -Destination "$outputPath" -Force -Recurse # copies shaders folder

"Copying imgui.ini settings to output..."
Copy-Item "$projectDir\imgui.ini" -Destination $outputPath

if($configuration -eq "Release")
{
	"Remove .pdb files from output..."
	Get-ChildItem $outputPath *.pdb | foreach { Remove-Item -Path $_.FullName }

	"Compressing the output..."
	Compress-Archive "$outputPath\*" -Destination "$outputPath\SlidingNumbers-TheGame.zip"
}

"DONE."
