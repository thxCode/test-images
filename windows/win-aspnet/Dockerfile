ARG DONET=4.8

FROM mcr.microsoft.com/dotnet/framework/sdk:$DONET as build
MAINTAINER frank "https://github.com/thxcode"
SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
COPY . /src/
WORKDIR /src
RUN nuget restore; \
    MSBUILD WinAspNet.csproj /p:Configuration=Release /p:DeployOnBuild=true /p:DeployTarget=Package /p:AutoParameterizationWebConfigConnectionStrings=false; \
    MKDIR dist; \
    XCOPY obj\Release\Package\PackageTmp dist /i /e

FROM mcr.microsoft.com/dotnet/framework/aspnet:$DONET
MAINTAINER frank "https://github.com/thxcode"
SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN Enable-WindowsOptionalFeature -Online -FeatureName IIS-WindowsAuthentication;
VOLUME c:/winaspnet
COPY --from=build /src/dist /inetpub/wwwroot
