<#
  Genere les cartes SVG des projets (assets/projet-*.svg) pour le README du profil.
  Modifier la liste $projects puis relancer : .\tools\New-ProjectCards.ps1
#>
$ErrorActionPreference = 'Stop'
$out = Join-Path $PSScriptRoot '..\assets'

$projects = @(
  @{ Id='nexus'; Icon='🎮'; Name='Nexus'; Status='v1.0 · utilisé au quotidien'; StatusColor='#22C55E'; From='#8B5CF6'; To='#22D3EE'
     Lines=@('Mon launcher de jeux : Steam, Epic, Riot, Xbox et jeux', 'autonomes dans une seule bibliothèque. Fiche par jeu,', 'temps de jeu exact, jeux possédés non installés,', 'mises à jour automatiques via GitHub Releases.')
     Tags=@('C#', 'WPF', '.NET 10', 'SQLite', 'GitHub Actions') },
  @{ Id='pulse'; Icon='⚡'; Name='Pulse'; Status='v1.0 · en production sur mes PC'; StatusColor='#22C55E'; From='#22D3EE'; To='#8B5CF6'
     Lines=@('Optimisation et surveillance de mes PC : analyse', 'notée sur 100, 42 réglages Windows annulables,', 'nettoyage, espace disque, santé batterie, profil Jeu', 'automatique. Tourne sans droits admin (UAC par lot).')
     Tags=@('C#', 'WPF', 'PowerShell', 'Win32', 'Inno Setup') },
  @{ Id='station-blanche'; Icon='🛡️'; Name='Station Blanche'; Status='Projet d''entreprise · v6 en test'; StatusColor='#F59E0B'; From='#22C55E'; To='#22D3EE'
     Lines=@('Borne de décontamination de clés USB : double', 'moteur antivirus, identification du support,', 'rapports PDF, interface kiosque verrouillée.', 'Procédure de déploiement et scripts écrits de A à Z.')
     Tags=@('Ubuntu 24.04', 'ClamAV', 'GravityZone', 'Bash', 'Kiosque') },
  @{ Id='homelab'; Icon='🏠'; Name='Homelab'; Status='En conception'; StatusColor='#A1A1AA'; From='#F59E0B'; To='#8B5CF6'
     Lines=@('Mon infra perso, isolée du réseau de la maison :', 'hyperviseur, pare-feu virtualisé, NAS de plusieurs To,', 'switch 2,5 Gb. Médias, serveurs de jeu et IA locale.', '')
     Tags=@('Virtualisation', 'pfSense', 'NAS', 'VLAN', 'IA locale') }
)

function Esc([string]$s) { $s.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;') }

foreach ($p in $projects) {
    $tags = ''; $x = 28
    foreach ($t in $p.Tags) {
        $w = [int](14 + 7.6 * $t.Length)
        $tags += "<rect x=`"$x`" y=`"196`" width=`"$w`" height=`"24`" rx=`"12`" fill=`"#1C1C21`" stroke=`"#2E2E35`"/><text x=`"$($x + $w / 2)`" y=`"212`" text-anchor=`"middle`" class=`"tag`">$(Esc $t)</text>"
        $x += $w + 8
    }
    $lines = ''; $y = 104
    foreach ($l in $p.Lines) { if ($l) { $lines += "<text x=`"28`" y=`"$y`" class=`"d`">$(Esc $l)</text>" }; $y += 21 }
    $svg = @"
<svg xmlns="http://www.w3.org/2000/svg" width="580" height="240" viewBox="0 0 580 240" role="img" aria-label="Projet $(Esc $p.Name) : $(Esc (($p.Lines -join ' ').Trim()))">
  <defs>
    <linearGradient id="g" x1="0" x2="1"><stop offset="0" stop-color="$($p.From)"/><stop offset="1" stop-color="$($p.To)"/></linearGradient>
    <radialGradient id="r" cx="1" cy="0" r="0.9"><stop offset="0" stop-color="$($p.To)" stop-opacity=".16"/><stop offset="1" stop-color="$($p.To)" stop-opacity="0"/></radialGradient>
    <style>
      .n { font: 700 24px 'Segoe UI Variable Display', 'Segoe UI', Inter, system-ui, sans-serif; fill: #FAFAFA; }
      .s { font: 600 12px 'Segoe UI', Inter, system-ui, sans-serif; }
      .d { font: 400 14px 'Segoe UI', Inter, system-ui, sans-serif; fill: #A1A1AA; }
      .tag { font: 600 11.5px 'Cascadia Code', Consolas, monospace; fill: #D4D4D8; }
      .bar { animation: sweep 3.5s ease-in-out infinite alternate; }
      @keyframes sweep { from { opacity: .55; } to { opacity: 1; } }
    </style>
  </defs>
  <rect x="0.5" y="0.5" width="579" height="239" rx="16" fill="#0F0F12" stroke="#26262B"/>
  <rect x="0.5" y="0.5" width="579" height="239" rx="16" fill="url(#r)"/>
  <rect x="0" y="0" width="580" height="4" rx="2" fill="url(#g)" class="bar"/>
  <text x="28" y="56" class="n">$($p.Icon) $(Esc $p.Name)</text>
  <circle cx="$([int](552 - 6.35 * $p.Status.Length - 10))" cy="42" r="4" fill="$($p.StatusColor)"/>
  <text x="552" y="46" text-anchor="end" class="s" fill="$($p.StatusColor)">$(Esc $p.Status)</text>
  $lines
  $tags
</svg>
"@
    [IO.File]::WriteAllText((Join-Path $out "projet-$($p.Id).svg"), $svg, [Text.UTF8Encoding]::new($false))
    "Carte : projet-$($p.Id).svg"
}