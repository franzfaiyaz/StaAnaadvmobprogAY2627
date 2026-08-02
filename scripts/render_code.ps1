Add-Type -AssemblyName System.Drawing
function Create-Image($file, $out) {
  $text = Get-Content -Raw -Path $file
  $lines = $text -split "`n"
  $font = New-Object System.Drawing.Font 'Consolas',11
  $lineHeight = [int]([Math]::Ceiling($font.GetHeight() + 2))
  $width = 1200
  $height = [Math]::Max(200, ($lines.Count * $lineHeight) + 40)
  $bmp = New-Object System.Drawing.Bitmap $width,$height
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
  $g.Clear([System.Drawing.Color]::FromArgb(255,255,255))
  $brush = [System.Drawing.Brushes]::Black
  $y=10
  foreach ($line in $lines) {
    $g.DrawString($line.TrimEnd("`r"), $font, $brush, 10, $y)
    $y += $lineHeight
  }
  $bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose()
  $bmp.Dispose()
  Write-Host "Saved: $out"
}

Create-Image 'c:\Users\NU\staana_advmobprog\lib\main.dart' 'c:\Users\NU\staana_advmobprog\lib\code_main.dart.png'
Create-Image 'c:\Users\NU\staana_advmobprog\build\run_output.txt' 'c:\Users\NU\staana_advmobprog\build\run_output.png'
