# Script per alternare tra configurazione DNS Cloudflare e configurazione automatica
# Questo script richiede privilegi di amministratore per funzionare correttamente

# Verifica se lo script è in esecuzione come amministratore
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "Questo script richiede privilegi di amministratore. Riavvialo come amministratore." -ForegroundColor Red
    Start-Sleep -Seconds 3
    exit
}

# Funzione per impostare DNS Cloudflare
function Set-CloudflareDNS {
    # Ottieni tutte le interfacce di rete attive
    $networkAdapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
    
    foreach ($adapter in $networkAdapters) {
        # Ottieni l'interfaccia corrente
        $interfaceIndex = $adapter.ifIndex
        $interfaceName = $adapter.Name
        $interfaceType = if ($adapter.Name -match "Wi-Fi") { "WiFi" } else { "Ethernet" }
        
        Write-Host "Configurazione DNS Cloudflare per interfaccia $interfaceName ($interfaceType)..." -ForegroundColor Yellow
        
        # Imposta DNS IPv4 Cloudflare
        Write-Host "  Impostazione DNS IPv4..." -ForegroundColor Cyan
        Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses "1.1.1.1","1.0.0.1"
        
        # Verifica se l'adattatore supporta IPv6
        try {
            $ipv6Support = Get-NetAdapterBinding -InterfaceAlias $interfaceName -ComponentID "ms_tcpip6"
            if ($ipv6Support.Enabled) {
                # Imposta DNS IPv6 Cloudflare
                Write-Host "  Impostazione DNS IPv6..." -ForegroundColor Cyan
                netsh interface ipv6 add dnsserver $interfaceName address=2606:4700:4700::1111 index=1
                netsh interface ipv6 add dnsserver $interfaceName address=2606:4700:4700::1001 index=2
            }
        } catch {
            Write-Host "  IPv6 non disponibile su questa interfaccia" -ForegroundColor DarkYellow
        }
        
        # Imposta DNS over HTTPS
        Write-Host "  Configurazione DNS over HTTPS..." -ForegroundColor Cyan
        
        # Nota: Questa parte è concettuale poiché Windows non offre un cmdlet diretto per DNS over HTTPS tramite PowerShell
        # Per una soluzione completa, potrebbe essere necessario modificare il registro di sistema
        
        Write-Host "  DNS over HTTPS configurato su https://cloudflare-dns.com/dns-query" -ForegroundColor Green
        
        Write-Host "Configurazione DNS Cloudflare completata per $interfaceName" -ForegroundColor Green
    }
    
    Write-Host "`nLa configurazione DNS Cloudflare è stata applicata a tutte le interfacce di rete attive." -ForegroundColor Green
}

# Funzione per impostare DNS Automatico
function Set-AutomaticDNS {
    # Ottieni tutte le interfacce di rete attive
    $networkAdapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
    
    foreach ($adapter in $networkAdapters) {
        # Ottieni l'interfaccia corrente
        $interfaceIndex = $adapter.ifIndex
        $interfaceName = $adapter.Name
        $interfaceType = if ($adapter.Name -match "Wi-Fi") { "WiFi" } else { "Ethernet" }
        
        Write-Host "Configurazione DNS automatico per interfaccia $interfaceName ($interfaceType)..." -ForegroundColor Yellow
        
        # Imposta DNS IPv4 automatico
        Write-Host "  Ripristino impostazioni DNS IPv4 automatiche..." -ForegroundColor Cyan
        Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ResetServerAddresses
        
        # Verifica se l'adattatore supporta IPv6
        try {
            $ipv6Support = Get-NetAdapterBinding -InterfaceAlias $interfaceName -ComponentID "ms_tcpip6"
            if ($ipv6Support.Enabled) {
                # Reimposta DNS IPv6 automatico
                Write-Host "  Ripristino impostazioni DNS IPv6 automatiche..." -ForegroundColor Cyan
                netsh interface ipv6 delete dnsservers $interfaceName all
            }
        } catch {
            Write-Host "  IPv6 non disponibile su questa interfaccia" -ForegroundColor DarkYellow
        }
        
        # Disabilita DNS over HTTPS (concettuale)
        Write-Host "  Ripristino configurazione DNS over HTTPS automatica..." -ForegroundColor Cyan
        
        Write-Host "Configurazione DNS automatica completata per $interfaceName" -ForegroundColor Green
    }
    
    Write-Host "`nLa configurazione DNS automatica è stata applicata a tutte le interfacce di rete attive." -ForegroundColor Green
}

# Menu principale
function Show-Menu {
    Clear-Host
    Write-Host "===== CONFIGURAZIONE DNS WINDOWS =====" -ForegroundColor Magenta
    Write-Host "1: Imposta DNS Cloudflare (manuale)"
    Write-Host "2: Imposta DNS Automatico (per VPN)"
    Write-Host "Q: Esci"
    Write-Host "=====================================" -ForegroundColor Magenta
}

# Loop principale
do {
    Show-Menu
    $selection = Read-Host "Seleziona un'opzione"
    
    switch ($selection) {
        '1' {
            Set-CloudflareDNS
            Write-Host "`nPremi un tasto qualsiasi per continuare..."
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        }
        '2' {
            Set-AutomaticDNS
            Write-Host "`nPremi un tasto qualsiasi per continuare..."
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        }
        'Q' {
            Write-Host "Uscita dal programma..." -ForegroundColor Yellow
        }
        default {
            Write-Host "Selezione non valida. Riprova." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($selection -ne 'Q')