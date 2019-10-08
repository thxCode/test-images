ARG SERVERCORE=1809

FROM mcr.microsoft.com/windows/servercore:$SERVERCORE
MAINTAINER frank "https://github.com/thxcode"
SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
USER ContainerAdministrator
ENV chocolateyUseWindowsCompression false
RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco feature disable --name showDownloadProgress
RUN choco install -y bind-toolsonly --version=9.14.2
RUN choco install -y openssl.light --version=1.1.1.20181020
RUN choco install -y openssh --version=8.0.0.1
RUN choco install -y diskspd --version=2.0.21
RUN choco install -y iperf2 --version=2.0.14.1
RUN choco install -y iperf3 --version=3.1.3
RUN Invoke-WebRequest -UseBasicParsing -OutFile tcpdump.zip -Uri https://www.microolap.com/downloads/files/tcpdump/tcpdump_trial_license.zip; \
    Expand-Archive -Force -Path tcpdump.zip -DestinationPath c:\tcpdump; \
    Remove-Item -Force -Recurse -Path tcpdump.zip; \
    $env:PATH=$('c:\tcpdump;{0}' -f $env:PATH); \
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)
