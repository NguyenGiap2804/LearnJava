@echo off

set PAC_URL=https://tech.stromez.tech/proxy.pac
set CERTFILE=%~dp0cert\mitmproxy-ca-cert.cer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL /t REG_SZ /d %PAC_URL% /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f
certutil -user -addstore "Root" "%CERTFILE%"
exit