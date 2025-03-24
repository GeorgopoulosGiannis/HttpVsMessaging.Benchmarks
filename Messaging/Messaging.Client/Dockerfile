FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Messaging/Messaging.Client/Messaging.Client.csproj", "Messaging/Messaging.Client/"]
COPY ["Messaging/Messaging.Contracts/Messaging.Contracts.csproj", "Messaging/Messaging.Contracts/"]
RUN dotnet restore "Messaging/Messaging.Client/Messaging.Client.csproj"
COPY . .
WORKDIR "/src/Messaging/Messaging.Client"
RUN dotnet build "Messaging.Client.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "Messaging.Client.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Messaging.Client.dll"]
