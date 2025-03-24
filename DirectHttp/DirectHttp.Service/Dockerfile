FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["DirectHttp/DirectHttp.Service/DirectHttp.Service.csproj", "DirectHttp/DirectHttp.Service/"]
RUN dotnet restore "DirectHttp/DirectHttp.Service/DirectHttp.Service.csproj"
COPY . .
WORKDIR "/src/DirectHttp/DirectHttp.Service"
RUN dotnet build "DirectHttp.Service.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "DirectHttp.Service.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DirectHttp.Service.dll"]
