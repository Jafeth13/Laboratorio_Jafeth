# -------- BUILD --------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copiar el proyecto API
COPY ["Barber_API/Barber_API.csproj", "Barber_API/"]

# Restaurar dependencias
RUN dotnet restore "Barber_API/Barber_API.csproj"

# Copiar todo el código
COPY . .

# Ir a la carpeta del proyecto
WORKDIR /src/Barber_API

# Publicar
RUN dotnet publish -c Release -o /app/publish

# -------- RUNTIME --------
FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 5000

ENTRYPOINT ["dotnet", "Barber_API.dll"]