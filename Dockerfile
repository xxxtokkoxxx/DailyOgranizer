FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["DailyOgranizer/DailyOrganizer.csproj", "DailyOrganizer/"]
RUN dotnet restore "DailyOgranizer/DailyOrganizer.csproj"

COPY . .
WORKDIR "/src/DailyOgranizer"
RUN dotnet build "DailyOrganizer.csproj" -c Release -o /app/build

# Публікуємо додаток
FROM build AS publish
RUN dotnet publish "DailyOrganizer.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DailyOrganizer.dll"]