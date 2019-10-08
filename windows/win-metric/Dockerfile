ARG SERVERCORE=1809

FROM mcr.microsoft.com/windows/servercore:$SERVERCORE as builder
MAINTAINER frank "https://github.com/thxcode"
SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV NODE_VERSION 10.16.0
RUN Invoke-WebRequest -UseBasicParsing -OutFile node.zip -Uri ('https://nodejs.org/dist/v{0}/node-v{0}-win-x64.zip' -f $env:NODE_VERSION); \
    Expand-Archive -Force -Path node.zip -DestinationPath c:\; \
    Rename-Item -Path $('c:\node-v{0}-win-x64' -f $env:NODE_VERSION) -NewName 'c:\nodejs'; \
    Remove-Item -Force -Recurse -Path c:\node.zip

FROM mcr.microsoft.com/powershell:nanoserver-$SERVERCORE
MAINTAINER frank "https://github.com/thxcode"
SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
USER ContainerAdministrator
COPY --from=builder /Windows/System32/certoc.exe /Windows/System32/netapi32.dll /Windows/System32/
COPY --from=builder /nodejs /nodejs
COPY web/*.js /web/
EXPOSE 80
CMD Start-Process -NoNewWindow -Wait -FilePath c:/nodejs/node.exe -ArgumentList c:/web/app.js
