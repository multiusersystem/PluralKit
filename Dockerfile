FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Restore/fetch dependencies excluding app code to make use of caching
COPY PluralKit.sln /app/
COPY Myriad/Myriad.csproj /app/Myriad/
COPY PluralKit.API/PluralKit.API.csproj /app/PluralKit.API/
COPY PluralKit.Bot/PluralKit.Bot.csproj /app/PluralKit.Bot/
COPY PluralKit.Core/PluralKit.Core.csproj /app/PluralKit.Core/
COPY PluralKit.ScheduledTasks/PluralKit.ScheduledTasks.csproj /app/PluralKit.ScheduledTasks/
COPY PluralKit.Tests/PluralKit.Tests.csproj /app/PluralKit.Tests/
COPY .git/ /app/.git
RUN dotnet restore PluralKit.sln

# Copy the rest of the code and build
COPY . /app
RUN dotnet build -c Release -o bin

# Build runtime stage (doesn't include SDK)
FROM mcr.microsoft.com/dotnet/aspnet:6.0
LABEL org.opencontainers.image.source = "https://github.com/xSke/PluralKit"

WORKDIR /app
COPY --from=build /app ./

# Allow overriding CMD from eg. docker-compose to run API layer too
ENTRYPOINT ["dotnet"]
CMD ["bin/PluralKit.Bot.dll"]
