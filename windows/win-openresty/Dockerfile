ARG SERVERCORE=1809

FROM mcr.microsoft.com/windows/servercore:$SERVERCORE as builder
MAINTAINER frank "https://github.com/thxcode"
SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV OPEN_RESTY_VERSION "1.15.8.2"
RUN Invoke-WebRequest -UseBasicParsing -OutFile c:\openresty.zip -Uri ('https://openresty.org/download/openresty-1.15.8.2-win64.zip' -f $env:OPEN_RESTY_VERSION); \
	Expand-Archive -Force -Path openresty.zip -DestinationPath c:\; \
	Rename-Item -Path $('c:\openresty-{0}-win64' -f $env:OPEN_RESTY_VERSION) -NewName 'c:\openresty'; \
	Remove-Item -Force -Recurse -Path c:\openresty.zip

FROM mcr.microsoft.com/powershell:nanoserver-$SERVERCORE
MAINTAINER frank "https://github.com/thxcode"
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
USER ContainerAdministrator
COPY --from=builder /Windows/System32/certoc.exe /Windows/System32/netapi32.dll /Windows/System32/
COPY --from=builder /openresty /openresty
RUN hostname | Out-File -Encoding ascii -Force -FilePath c:\openresty\html\name.html; \
	hostname | Out-File -Encoding ascii -Force -FilePath c:\openresty\html\name.htm
EXPOSE 80 443
WORKDIR /openresty
CMD Start-Process -FilePath nginx.exe; \
	Add-Content logs/access.log 'openresty started...' ; \
	Get-Content -Wait logs/access.log
