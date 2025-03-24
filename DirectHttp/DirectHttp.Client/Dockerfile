FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["DirectHttp/DirectHttp.Client/DirectHttp.Client.csproj", "DirectHttp/DirectHttp.Client/"]
RUN dotnet restore "DirectHttp/DirectHttp.Client/DirectHttp.Client.csproj"
COPY . .
WORKDIR "/src/DirectHttp/DirectHttp.Client"
RUN dotnet build "DirectHttp.Client.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "DirectHttp.Client.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DirectHttp.Client.dll"]
