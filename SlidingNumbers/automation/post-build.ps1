<#
This script is triggered as post-build event
#>

param([string]$projectDir, [string]$outputPath, [string]$configuration);

"ProjectDir = $projectDir"
"OutputPath = $outputPath"
"configuration = $configuration"

"Copying dlls to output dir..."
$dlls_path = if($configuration -eq "Debug")
{
	"dlls"
}
else
{
	"dlls-release"
}
Copy-Item -Path "$projectDir\dependencies\$dlls_path\*" -Destination "$outputPath" -Force -Recurse # this \* will make the .dll files, not the folder.

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
	Compress-Archive "$outputPath\*" -Destination "$outputPath\SlidingNumbers-game.zip"
}

"DONE."