FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project file from the subfolder
# We use */*.csproj to find it regardless of the folder name
COPY ["CuarioLibraryNowAPI/CuarioLibraryNowAPI.csproj", "CuarioLibraryNowAPI/"]
RUN dotnet restore "CuarioLibraryNowAPI/CuarioLibraryNowAPI.csproj"

# Copy everything and build
COPY . .
WORKDIR "/src/CuarioLibraryNowAPI"
RUN dotnet build "CuarioLibraryNowAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CuarioLibraryNowAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final Stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CuarioLibraryNowAPI.dll"]
