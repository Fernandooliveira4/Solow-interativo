# Salva uma nova versão: registra no CHANGELOG, faz commit, cria a etiqueta (tag) e envia para o GitHub.
# Uso normal: dar dois cliques em "salvar-versao.bat" na pasta do projeto.
param(
  [ValidateSet('', '1', '2', '3')][string]$Tipo = '',
  [string]$Descricao = ''
)
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

function Sair($msg) { Write-Host $msg; exit 1 }

if (-not (git status --porcelain)) {
  # sem mudanças: aproveita para enviar versões que ficaram pendentes (ex.: salvas sem internet)
  $pendentes = [int](git rev-list --count '@{u}..HEAD' 2>$null)
  if ($pendentes -gt 0) {
    git push -q --follow-tags
    if ($LASTEXITCODE -ne 0) { Sair 'Há versões salvas que ainda não foram para o GitHub, e o envio falhou de novo. Tente mais tarde.' }
    Write-Host 'Nada mudou, mas enviei para o GitHub as versões que estavam pendentes.'; exit 0
  }
  Sair 'Nada mudou desde a última versão. Nenhuma versão nova foi criada.'
}

Write-Host 'Arquivos alterados:'
git status --short
Write-Host ''

$ultima = git tag -l 'v*' --sort=-v:refname | Select-Object -First 1
if (-not $ultima) { $ultima = 'v0.0.0' }
$n = $ultima.TrimStart('v').Split('.') | ForEach-Object { [int]$_ }
Write-Host "Versão atual: $ultima"

if (-not $Tipo) {
  Write-Host 'Que tipo de mudança foi?'
  Write-Host '  1 = pequena correção (texto, cor, ajuste)'
  Write-Host '  2 = novidade (controle, gráfico ou recurso novo)'
  Write-Host '  3 = mudança grande (reformulação do modelo)'
  $Tipo = Read-Host 'Escolha 1, 2 ou 3 (Enter = 1)'
  if (-not $Tipo) { $Tipo = '1' }
}
switch ($Tipo) {
  '1' { $nova = "v$($n[0]).$($n[1]).$($n[2] + 1)" }
  '2' { $nova = "v$($n[0]).$($n[1] + 1).0" }
  '3' { $nova = "v$($n[0] + 1).0.0" }
  default { Sair 'Opção inválida. Nada foi salvo.' }
}

if (-not $Descricao) { $Descricao = Read-Host 'Descreva em uma frase o que mudou' }
$Descricao = $Descricao.Trim()
if (-not $Descricao) { Sair 'Sem descrição. Nada foi salvo.' }

# registra no topo do CHANGELOG, logo abaixo do título
$log = Join-Path (Get-Location) 'CHANGELOG.md'
$entrada = "## $nova ($(Get-Date -Format 'yyyy-MM-dd'))`n- $Descricao`n"
$texto = if (Test-Path $log) { [IO.File]::ReadAllText($log) } else { "# Histórico de versões`n" }
$i = $texto.IndexOf("`n")
$resto = $texto.Substring($i + 1).TrimStart("`r", "`n")
$texto = $texto.Substring(0, $i + 1) + "`n" + $entrada + $(if ($resto) { "`n" + $resto })
[IO.File]::WriteAllText($log, $texto, (New-Object Text.UTF8Encoding $false))

git add -A
git commit -q -m "${nova}: $Descricao"
if ($LASTEXITCODE -ne 0) { Sair 'O commit falhou. Nada foi enviado.' }
git tag -a $nova -m $Descricao
git push -q --follow-tags
if ($LASTEXITCODE -ne 0) { Sair "A versão $nova foi salva no computador, mas o envio para o GitHub falhou. Quando tiver internet, rode o salvar-versao.bat de novo para enviar." }

Write-Host ''
Write-Host "Pronto: versão $nova salva e enviada para o GitHub."
