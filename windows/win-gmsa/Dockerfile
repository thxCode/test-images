ARG DONET=4.8

FROM mcr.microsoft.com/dotnet/framework/sdk:$DONET as build
MAINTAINER frank "https://github.com/thxcode"
SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
COPY . /src/
WORKDIR /src
RUN nuget restore; \
    MSBUILD WindockerTest.csproj /p:Configuration=Release /p:DeployOnBuild=true /p:DeployTarget=Package /p:AutoParameterizationWebConfigConnectionStrings=false; \
    MKDIR dist; \
    XCOPY obj\Release\Package\PackageTmp dist /i /e

FROM mcr.microsoft.com/dotnet/framework/aspnet:$DONET
ARG DUMMY_USER=dummy
ARG DUMMY_PWD=Password@1234
MAINTAINER frank "https://github.com/thxcode"
SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV DUMMY_USER=$DUMMY_USER
ENV DUMMY_PWD=$DUMMY_PWD
RUN NET USER $env:DUMMY_USER $env:DUMMY_PWD /add
RUN Enable-WindowsOptionalFeature -Online -FeatureName IIS-WindowsAuthentication; \
    Set-WebConfigurationProperty -filter /system.WebServer/security/authentication/AnonymousAuthentication -name enabled -value false -PSPath 'IIS:\Sites\'; \
    Set-WebConfigurationProperty -filter /system.webServer/security/authentication/windowsAuthentication -name enabled -value true -PSPath 'IIS:\Sites\'
COPY --from=build /src/dist /inetpub/wwwroot
