FROM mcr.microsoft.com/dotnet/runtime:9.0 AS base
USER $APP_UID
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["Messaging/Messaging.Worker/Messaging.Worker.csproj", "Messaging/Messaging.Worker/"]
COPY ["Messaging/Messaging.Contracts/Messaging.Contracts.csproj", "Messaging/Messaging.Contracts/"]
RUN dotnet restore "Messaging/Messaging.Worker/Messaging.Worker.csproj"
COPY . .
WORKDIR "/src/Messaging/Messaging.Worker"
RUN dotnet build "Messaging.Worker.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "Messaging.Worker.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Messaging.Worker.dll"]
