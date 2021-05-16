#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["NicNas/NicNas.csproj", "NicNas/"]
RUN dotnet restore "NicNas/NicNas.csproj"
COPY . .
WORKDIR "/src/NicNas"
RUN dotnet build "NicNas.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NicNas.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NicNas.dll"]