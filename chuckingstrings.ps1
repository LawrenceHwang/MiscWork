
param(
  [Parameter()]
  [string]$string,

  [parameter()]
  [int]$CharPerLine = 100
)

$a = $string.ToCharArray()

for ($i = 0; $i -le $a.count; $i = ($i+$CharPerLine)) {
  $a[$i .. ($i + $CharPerLine - 1)] -join ''
}