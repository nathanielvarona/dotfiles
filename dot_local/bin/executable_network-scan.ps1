param (
    [string]$Network = "192.168.0.0/24"
)

# Parse IP and CIDR prefix using 64-bit integers to prevent Int32 overflow
$Parts = $Network -split '/'
$IPBytes = ([System.Net.IPAddress]::Parse($Parts[0])).GetAddressBytes()
[Array]::Reverse($IPBytes)
$IPInt = [int64][System.BitConverter]::ToUInt32($IPBytes, 0)
$Prefix = [int]$Parts[1]

# Calculate start and end host IPs
$Mask = ([int64]0xFFFFFFFF -shl (32 - $Prefix)) -band 0xFFFFFFFF
$StartIP = ($IPInt -band $Mask) + 1
$EndIP = ($IPInt -bor ((-bnot $Mask) -band 0xFFFFFFFF)) - 1

Write-Host "Scanning $Network ($($EndIP - $StartIP + 1) hosts)..." -ForegroundColor Cyan

# Use a 64-bit for-loop instead of '..' so IPs above 127.x.x.x work
for ($i = $StartIP; $i -le $EndIP; $i++) {
    $Bytes = [System.BitConverter]::GetBytes([uint32]$i)
    [Array]::Reverse($Bytes)
    $TargetIP = ([System.Net.IPAddress]$Bytes).ToString()
    Start-Process -WindowStyle Hidden ping.exe -ArgumentList "-n 1 -w 200 $TargetIP"
}
Start-Sleep -Seconds 3

# Extract dynamic ARP entries inside the target CIDR range
$Devices = arp -a | ForEach-Object {
    if ($_ -match "^\s*(\d+\.\d+\.\d+\.\d+)\s+([0-9a-f-]{17})\s+dynamic") {
        $FoundIP = $matches[1]
        $FoundMAC = $matches[2]

        $FoundBytes = ([System.Net.IPAddress]::Parse($FoundIP)).GetAddressBytes()
        [Array]::Reverse($FoundBytes)
        $FoundInt = [int64][System.BitConverter]::ToUInt32($FoundBytes, 0)

        if ($FoundInt -ge $StartIP -and $FoundInt -le $EndIP) {
            $Hostname = try { [System.Net.Dns]::GetHostEntry($FoundIP).HostName } catch { "Unknown" }
            [PSCustomObject]@{
                IPAddress  = $FoundIP
                MACAddress = $FoundMAC
                Hostname   = $Hostname
            }
        }
    }
}

if ($Devices) {
    $Devices | Format-Table -AutoSize
} else {
    Write-Host "No active dynamic devices found on $Network." -ForegroundColor Yellow
}
