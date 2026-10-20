# Abre uma versão antiga numa pasta separada (versoes-antigas\vX.Y.Z), sem mexer nos arquivos atuais.
# Uso normal: dar dois cliques em "abrir-versao.bat" na pasta do projeto.
param([string]$Versao = '')
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

$tags = @(git tag -l 'v*' --sort=-v:refname)
if (-not $tags) { Write-Host 'Ainda não há versões salvas.'; exit 1 }

if (-not $Versao) {
  Write-Host 'Versões salvas (a mais nova primeiro):'
  git tag -l 'v*' --sort=-v:refname --format='  %(refname:short)   %(creatordate:short)   %(contents:subject)'
  Write-Host ''
  $Versao = (Read-Host 'Qual versão abrir? (ex.: v1.0.0)').Trim()
}
if ($Versao -and -not $Versao.StartsWith('v')) { $Versao = "v$Versao" }
if ($tags -notcontains $Versao) { Write-Host "A versão '$Versao' não existe."; exit 1 }

$destino = Join-Path (Get-Location) "versoes-antigas\$Versao"
if (Test-Path $destino) { Write-Host "Essa versão já está aberta em: $destino" }
else {
  New-Item -ItemType Directory -Force (Split-Path $destino) | Out-Null
  $zip = "$destino.zip"
  git archive --format=zip -o $zip $Versao
  if ($LASTEXITCODE -ne 0) { Write-Host 'Não consegui extrair a versão.'; exit 1 }
  Expand-Archive $zip $destino
  Remove-Item $zip
  Write-Host "Versão $Versao aberta em: $destino"
}
Write-Host 'Para voltar a ela, copie os arquivos dessa pasta por cima dos atuais e salve uma versão nova.'
if (-not $env:SEM_EXPLORER) { Invoke-Item $destino }
