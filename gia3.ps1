function Show-GIAMenu {
    Clear-Host
    Write-Host "=========================================" -ForegroundColor Blue
    Write-Host "    GIA - Assistente de Ferramentaria    " -ForegroundColor White -BackgroundColor Blue
    Write-Host "=========================================" -ForegroundColor Blue
    Write-Host "Digite 'sair' para encerrar o programa`n" -ForegroundColor Gray
}

function Send-GIAQuestion {
    param (
        [string]$Question
    )
    
    $Body = @{
        question = $Question
    } | ConvertTo-Json
    
    try {
        $Response = Invoke-RestMethod -Uri "https://gia3.onrender.com/ask" -Method Post -Body $Body -ContentType "application/json"
        return $Response
    }
    catch {
        Write-Host "Erro ao consultar a API: $_" -ForegroundColor Red
        return $null
    }
}

$history = @()
$running = $true

Show-GIAMenu

while ($running) {
    Write-Host "Digite sua pergunta:" -ForegroundColor Yellow
    $question = Read-Host "> "
    
    if ($question -eq "sair" -or $question -eq "exit") {
        $running = $false
        continue
    }
    
    if ($question -eq "limpar" -or $question -eq "clear") {
        Show-GIAMenu
        continue
    }
    
    Write-Host "`nConsultando...`n" -ForegroundColor Gray
    
    $response = Send-GIAQuestion -Question $question
    
    if ($response) {
        $history += @{
            Question = $question
            Answer = $response.answer
            Suggestions = $response.suggestions
            Timestamp = Get-Date
        }
        
        # Exibir resposta formatada
        Write-Host $response.answer -ForegroundColor White
        
        Write-Host "`nSugestões:" -ForegroundColor Yellow
        for ($i=0; $i -lt $response.suggestions.Count; $i++) {
            Write-Host "[$($i+1)] $($response.suggestions[$i])" -ForegroundColor Cyan
        }
        
        Write-Host "`nPara usar uma sugestão, digite o número ou faça uma nova pergunta." -ForegroundColor Gray
        $choice = Read-Host "Escolha"
        
        if ($choice -match "^\d+$" -and [int]$choice -ge 1 -and [int]$choice -le $response.suggestions.Count) {
            $question = $response.suggestions[[int]$choice-1]
            Write-Host "`nNova pergunta: $question`n" -ForegroundColor Yellow
            $response = Send-GIAQuestion -Question $question
            
            if ($response) {
                Write-Host $response.answer -ForegroundColor White
                
                Write-Host "`nSugestões:" -ForegroundColor Yellow
                for ($i=0; $i -lt $response.suggestions.Count; $i++) {
                    Write-Host "[$($i+1)] $($response.suggestions[$i])" -ForegroundColor Cyan
                }
                
                $history += @{
                    Question = $question
                    Answer = $response.answer
                    Suggestions = $response.suggestions
                    Timestamp = Get-Date
                }
            }
        }
    }
    
    Write-Host "`n-----------------------------------------`n" -ForegroundColor DarkGray
}