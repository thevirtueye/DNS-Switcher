DNS-Switcher

What it does:
DNS-Switcher is a PowerShell script that automates switching between different DNS configurations on Windows systems. Specifically, it allows you to toggle between using Cloudflare's DNS servers (1.1.1.1) with DNS over HTTPS and the automatic DNS configuration provided by your ISP or VPN. The script modifies DNS settings for all active network interfaces, both Wi-Fi and Ethernet, with a simple command.
How to use it:

Save the script as a .ps1 file (e.g., DNS-Switcher.ps1)
Create a shortcut to the script with administrator execution:

Right-click on the file → Create shortcut
Right-click on the shortcut → Properties
Edit the target to: powershell.exe -ExecutionPolicy Bypass -File "path\to\your\DNS-Switcher.ps1"
Go to Advanced → select "Run as administrator"


Run the shortcut with a double-click
Select the desired option from the menu:

Option 1: Configure Cloudflare DNS (1.1.1.1) with DNS over HTTPS
Option 2: Restore automatic DNS settings



Why use it:

Enhanced Privacy: Cloudflare DNS offers private DNS resolution and doesn't log queries
Advanced Security: DNS over HTTPS (DoH) encrypts your DNS requests, protecting them from interception
Faster Browsing: Cloudflare DNS servers are among the fastest available, reducing page load times
VPN Compatibility: The option to return to automatic settings is useful when using a VPN that requires its own DNS servers
Censorship Protection: Can help bypass some forms of DNS-based website blocking
Integrated DNSSEC: Protects against DNS spoofing attacks

The script works with all modern Windows systems (Windows 10 and 11) and has been tested in both physical and virtualized environments. It doesn't require additional software beyond PowerShell, which comes pre-installed in Windows.
