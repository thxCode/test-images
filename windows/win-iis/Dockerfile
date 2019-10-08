ARG SERVERCORE=1809

FROM mcr.microsoft.com/windows/servercore:$SERVERCORE
MAINTAINER frank "https://github.com/thxcode"
SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Add-WindowsFeature Web-Server
ENV SVCM_VERSION 2.0.1.6
RUN Invoke-WebRequest -UseBasicParsing -OutFile c:\ServiceMonitor.exe -Uri ('https://dotnetbinaries.blob.core.windows.net/servicemonitor/{0}/ServiceMonitor.exe' -f $env:SVCM_VERSION)
EXPOSE 80
CMD hostname | Out-File -Encoding ascii -Force -FilePath c:\inetpub\wwwroot\name.html; \
    hostname | Out-File -Encoding ascii -Force -FilePath c:\inetpub\wwwroot\name.htm; \
    Start-Process -Wait -NoNewWindow -FilePath c:/ServiceMonitor.exe -ArgumentList w3svc
