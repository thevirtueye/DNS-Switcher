# 🔄 DNS-Switcher for Windows

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)
![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

DNS-Switcher is a simple yet powerful PowerShell script that lets you switch DNS configurations on the fly on your Windows system. With a single command, toggle between your ISP's automatic DNS servers and Cloudflare's secure DNS (1.1.1.1) with DNS over HTTPS (DoH).

---

## ✨ Key Features

* **🔒 Enhanced Privacy:** Leverages Cloudflare's DNS, which doesn't log your queries and provides a more private Browse experience.
* **🛡️ Advanced Security:** With DNS over HTTPS (DoH), your DNS requests are encrypted, protecting you from eavesdropping and man-in-the-middle attacks.
* **🚀 Faster Browse:** Cloudflare's servers are among the fastest in the world. Reduce page load times and improve your online experience.
* **🌐 Bypass Censorship:** Helps circumvent some types of DNS-based website blocking imposed at the ISP level.
* **🔗 VPN Compatibility:** Need to use your VPN's DNS? No problem. The "restore" option lets you switch back to default settings with one click.
* **✅ Integrated DNSSEC:** Built-in protection against DNS spoofing attacks, ensuring that DNS responses are authentic and untampered with.


## 🚀 Getting Started

Follow these simple steps to get up and running.

### 1. Save the Script

Save the code as a `.ps1` file, for example: `DNS-Switcher.ps1`.

### 2. Create a Shortcut

For easy access, create a shortcut to the file:
* Right-click on the `DNS-Switcher.ps1` file → `Create shortcut`.

### 3. Configure to Run as Administrator

We need to ensure the script runs with the necessary permissions.

* Right-click on the newly created **shortcut** → `Properties`.
* In the `Target` field, modify the path to look like this:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "C:\path\to\your\DNS-Switcher.ps1"
```

Note: Be sure to replace "C:\path\to\your\DNS-Switcher.ps1" with the actual file path on your system.

* Click Advanced... and check the "Run as administrator" box.
* Click OK to save.


## ⚙️ How to Use
Double-click the shortcut you just configured. An interactive menu will appear:


```powershell
DNS-Switcher 

Select an option:

[1] Set Cloudflare DNS (1.1.1.1) with DoH
[2] Restore Automatic DNS (DHCP)

[Q] Quit
```

* Option 1: Configures all active network adapters (Wi-Fi and Ethernet) to use Cloudflare's DNS servers (1.1.1.1, 1.0.0.1) and enables DNS over HTTPS.
* Option 2: Removes any custom DNS settings and restores the automatic configuration provided by your router/ISP (via DHCP).


## 💻 Compatibility
The script is tested and works on all modern Windows operating systems:

* Windows 10
* Windows 11
  
It runs on both physical and virtualized machines without needing any additional software beyond PowerShell, which comes pre-installed on Windows.
