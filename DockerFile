FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
# Note: Since the Root Directory is CuarioLibraryNowAPI, 
# the .csproj is now in the current directory.
COPY ["CuarioLibraryNowAPI.csproj", "./"]
RUN dotnet restore "CuarioLibraryNowAPI.csproj"

# Copy everything else and build
COPY . .
RUN dotnet publish "CuarioLibraryNowAPI.csproj" -c Release -o /app/out

FROM base AS final
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "CuarioLibraryNowAPI.dll"]
