<#
  Remplace les champs {{NOM}}, {{LINKEDIN}}, {{EMAIL}}, {{ENTREPRISE}} du profil.
  Exemple : .\tools\Set-ProfileInfo.ps1 -Nom 'Charly Dupont' -LinkedIn 'https://www.linkedin.com/in/...' -Email 'contact@...' -Entreprise 'Société (Ville)'
#>
param(
    [Parameter(Mandatory)] [string]$Nom,
    [Parameter(Mandatory)] [string]$LinkedIn,
    [Parameter(Mandatory)] [string]$Email,
    [Parameter(Mandatory)] [string]$Entreprise
)
$root = Join-Path $PSScriptRoot '..'
function Esc([string]$s) { $s.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;') }
$files = @(Get-ChildItem (Join-Path $root 'README.md')) + @(Get-ChildItem (Join-Path $root 'assets\*.svg'))
foreach ($f in $files) {
    $isSvg = $f.Extension -eq '.svg'
    $t = [IO.File]::ReadAllText($f.FullName)
    $new = $t.Replace('{{NOM}}', $(if ($isSvg) { Esc $Nom } else { $Nom })).Replace('{{LINKEDIN}}', $LinkedIn).Replace('{{EMAIL}}', $Email).Replace('{{ENTREPRISE}}', $(if ($isSvg) { Esc $Entreprise } else { $Entreprise }))
    if ($new -ne $t) { [IO.File]::WriteAllText($f.FullName, $new, [Text.UTF8Encoding]::new($false)); "Mis à jour : $($f.Name)" }
}
# Banniere : le prenom seul devient le nom complet
$banner = Join-Path $root 'assets\banner.svg'
$b = [IO.File]::ReadAllText($banner).Replace('class="name" fill="url(#accent)">Charly</text>', "class=`"name`" fill=`"url(#accent)`">$(Esc $Nom)</text>")
[IO.File]::WriteAllText($banner, $b, [Text.UTF8Encoding]::new($false))