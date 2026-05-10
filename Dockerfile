FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

# Use SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore
COPY ["CuarioLibraryNowAPI.csproj", "./"]
RUN dotnet restore "CuarioLibraryNowAPI.csproj"

# Copy all files and publish
COPY . .
RUN dotnet publish "CuarioLibraryNowAPI.csproj" -c Release -o /app/out

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "CuarioLibraryNowAPI.dll"]
