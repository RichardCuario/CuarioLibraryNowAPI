FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only the project file first to cache layers
COPY ["CuarioLibraryNowAPI/CuarioLibraryNowAPI.csproj", "CuarioLibraryNowAPI/"]
RUN dotnet restore "CuarioLibraryNowAPI/CuarioLibraryNowAPI.csproj"

# Copy the rest of the code
COPY . .
WORKDIR "/src/CuarioLibraryNowAPI"
RUN dotnet build "CuarioLibraryNowAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CuarioLibraryNowAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CuarioLibraryNowAPI.dll"]
