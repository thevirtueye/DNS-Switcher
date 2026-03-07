# DNS-Switcher for Windows

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)
![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

A lightweight PowerShell utility to toggle DNS configurations on Windows systems. Switch between your ISP's automatic DNS servers and Cloudflare's secure DNS (1.1.1.1 / 1.0.0.1) with a single command, including IPv6 and DNS over HTTPS (DoH) support.

---

## Why Use This

Most ISPs assign their own DNS servers via DHCP. These servers may be slow, unencrypted, and subject to logging or content filtering. Switching to a privacy-focused resolver like Cloudflare addresses several concerns:

- **Privacy** — Cloudflare commits to not logging querying IP addresses and purges all logs within 24 hours.
- **Security** — DNS over HTTPS encrypts DNS queries, protecting them from eavesdropping and man-in-the-middle attacks. DNSSEC validation ensures response integrity.
- **Performance** — Cloudflare operates one of the fastest public DNS resolvers globally, reducing lookup latency.
- **Censorship circumvention** — Bypasses some forms of DNS-based blocking applied at the ISP level.
- **VPN compatibility** — The restore option reverts to DHCP-assigned DNS, which is often required for proper VPN operation.

---

## Features

- Applies Cloudflare DNS (1.1.1.1 / 1.0.0.1) to all active network adapters automatically
- Supports both IPv4 and IPv6 DNS configuration (2606:4700:4700::1111 / 2606:4700:4700::1001)
- References the Cloudflare DoH endpoint — actual DoH enforcement requires OS-level configuration (see Limitations)
- Restores automatic DNS settings (DHCP) with a single option
- Detects and configures all active interfaces (Wi-Fi and Ethernet)
- Handles IPv6 availability gracefully — skips if not supported on the adapter
- Interactive menu with color-coded output for clear feedback
- Built-in administrator privilege check

---

## Requirements

- Windows 10 or Windows 11
- PowerShell 5.1 or later 
- Administrator privileges 

No additional software or modules are required.

---

## Installation

1. Download or clone the repository:

```bash
git clone https://github.com/thevirtueye/DNS-Switcher.git
```

2. If you have never run PowerShell scripts on your system, you need to allow script execution first. Open PowerShell as administrator and run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

This only needs to be done once. It allows locally created scripts to run while still blocking unsigned scripts downloaded from the internet.

3. Optionally, create a desktop shortcut for quick access:
   - Right-click on `DNS-Switcher.ps1` and select **Create shortcut**
   - Right-click the shortcut, open **Properties**, click **Advanced**, and enable **Run as administrator**

---

## Usage

Right-click the script (or the shortcut) and select **Run as administrator**, or launch it from an elevated PowerShell terminal:

```powershell
.\DNS-Switcher.ps1
```

The interactive menu presents the following options:

```
===== DNS CONFIGURATION FOR WINDOWS =====
1: Set Cloudflare DNS (manual)
2: Set Automatic DNS (for VPN)
Q: Quit
==========================================
```

**Option 1** configures all active network adapters to use Cloudflare DNS servers with DoH. Useful as a default configuration for everyday browsing.

**Option 2** removes all custom DNS settings and restores DHCP-assigned configuration. Use this before connecting to a VPN or when returning to a network that requires its own DNS servers.

---

## How It Works

The script operates on all currently active network adapters detected via `Get-NetAdapter`. For each adapter:

1. **Cloudflare mode** — Sets primary and secondary DNS via `Set-DnsClientServerAddress` (IPv4) and `netsh` (IPv6). References the DoH endpoint for encrypted resolution.
2. **Automatic mode** — Calls `ResetServerAddresses` to clear manual DNS entries and removes IPv6 DNS servers, reverting to whatever the DHCP server provides.

The script checks for IPv6 support on each adapter before attempting configuration, avoiding errors on interfaces where IPv6 is disabled.

---

## Limitations

- DNS over HTTPS configuration is referenced but not fully enforced via PowerShell. Windows 11 supports native DoH through Settings or registry modifications. On Windows 10, a third-party DoH client may be needed for full encrypted resolution.
- The script configures DNS at the adapter level. System-wide DNS policies set via Group Policy or MDM may override these settings.
- On networks with captive portals (hotels, airports), custom DNS may prevent the portal from loading. Use Option 2 to restore automatic DNS in these cases.

---

## Compatibility

Tested and verified on:

| OS | Status |
|----|--------|
| Windows 11 | Fully supported |
| Windows 10 | Fully supported |

Works on both physical and virtualized machines (VMware, VirtualBox, Hyper-V).

---

## License

This project is released under the **MIT License**.
Free to use, modify, and distribute. Please credit the author where applicable.

---

## Author

Created by **Alberto Cirillo** — 2025
