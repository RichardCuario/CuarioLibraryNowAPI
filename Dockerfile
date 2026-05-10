FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

ENV ASPNETCORE_URLS=http://+:8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project file first for caching
COPY ["CuarioLibraryNowAPI/Properties/CuarioLibraryNowAPI.csproj", "CuarioLibraryNowAPI/Properties/"]

# Restore dependencies
RUN dotnet restore "CuarioLibraryNowAPI/Properties/CuarioLibraryNowAPI.csproj"

# Copy all source files
COPY . .

# Move to project directory
WORKDIR "/src/CuarioLibraryNowAPI"

# Build the project
RUN dotnet build "Properties/CuarioLibraryNowAPI.csproj" -c Release -o /app/build

FROM build AS publish

# Publish the project
RUN dotnet publish "Properties/CuarioLibraryNowAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app

# Copy published files
COPY --from=publish /app/publish .

# Start the app
ENTRYPOINT ["dotnet", "CuarioLibraryNowAPI.dll"]
