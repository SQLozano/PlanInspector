foreach ($function in (Get-ChildItem "$PSScriptRoot\Functions\*.ps1")) {
	. $function.fullname
}