# Osnovna slika za zagon
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Slika za build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["tripmateapp.csproj", "./"]
RUN dotnet restore "tripmateapp.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "tripmateapp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "tripmateapp.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Končna slika
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "tripmateapp.dll"]
