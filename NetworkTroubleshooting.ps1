# ==========================================
# NETWORK TROUBLESHOOTING 
# ==========================================

Clear-Host

Write-Host "==============================" -ForegroundColor Cyan
Write-Host " NETWORK TROUBLESHOOTING " -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# ------------------------------------------
# 1. IP CONFIGURATION
# ------------------------------------------

Write-Host "[1] Checking IP configuration..." -ForegroundColor Yellow

$adapter = Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4Address -ne $null -and
        $_.NetAdapter.Status -eq "Up"
    } |
    Select-Object -First 1

if ($adapter) {

    $IPAddress = $adapter.IPv4Address.IPAddress
    $Gateway = $adapter.IPv4DefaultGateway.NextHop
    $Interface = $adapter.InterfaceAlias

    Write-Host "    Adapter: $Interface"
    Write-Host "    IP Address: $IPAddress"
    Write-Host "    Gateway: $Gateway"

    $IPStatus = "PASS"

}
else {

    Write-Host "    No active network adapter found." -ForegroundColor Red

    $IPStatus = "FAIL"
}

Write-Host ""

# ------------------------------------------
# 2. INTERNET CONNECTIVITY
# ------------------------------------------

Write-Host "[2] Testing Internet connectivity..." -ForegroundColor Yellow

$InternetTest = Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet

if ($InternetTest) {

    Write-Host "    Internet connectivity: PASS" -ForegroundColor Green

    $InternetStatus = "PASS"

}
else {

    Write-Host "    Internet connectivity: FAIL" -ForegroundColor Red

    $InternetStatus = "FAIL"
}

Write-Host ""

# ------------------------------------------
# 3. DNS TEST
# ------------------------------------------

Write-Host "[3] Testing DNS..." -ForegroundColor Yellow

try {

    $DNSResult = Resolve-DnsName "google.com" -ErrorAction Stop

    Write-Host "    DNS resolution: PASS" -ForegroundColor Green

    $DNSStatus = "PASS"

}
catch {

    Write-Host "    DNS resolution: FAIL" -ForegroundColor Red

    $DNSStatus = "FAIL"
}

Write-Host ""

# ------------------------------------------
# 4. GATEWAY TEST
# ------------------------------------------

Write-Host "[4] Testing default gateway..." -ForegroundColor Yellow

if ($Gateway) {

    $GatewayTest = Test-Connection -ComputerName $Gateway -Count 1 -Quiet

    if ($GatewayTest) {

        Write-Host "    Gateway connectivity: PASS" -ForegroundColor Green

        $GatewayStatus = "PASS"

    }
    else {

        Write-Host "    Gateway connectivity: FAIL" -ForegroundColor Red

        $GatewayStatus = "FAIL"
    }

}
else {

    Write-Host "    No default gateway detected." -ForegroundColor Red

    $GatewayStatus = "FAIL"
}

Write-Host ""

# ------------------------------------------
# 5. ROUTE TEST
# ------------------------------------------

Write-Host "[5] Testing route..." -ForegroundColor Yellow

$RouteTest = Test-NetConnection -ComputerName "8.8.8.8" -InformationLevel Detailed

if ($RouteTest.PingSucceeded) {

    Write-Host "    Route test: PASS" -ForegroundColor Green

    $RouteStatus = "PASS"

}
else {

    Write-Host "    Route test: FAIL" -ForegroundColor Red

    $RouteStatus = "FAIL"
}

Write-Host ""

# ==========================================
# RESULTS
# ==========================================

Write-Host "==============================" -ForegroundColor Cyan
Write-Host " RESULTS" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan

Write-Host ""

Write-Host ("IP Configuration: " + $IPStatus)
Write-Host ("Internet:         " + $InternetStatus)
Write-Host ("DNS:              " + $DNSStatus)
Write-Host ("Gateway:          " + $GatewayStatus)
Write-Host ("Route:            " + $RouteStatus)

Write-Host ""
Write-Host "==============================" -ForegroundColor Cyan
Write-Host " Troubleshooting Complete"
Write-Host "==============================" -ForegroundColor Cyan