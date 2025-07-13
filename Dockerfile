# Этап сборки
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Копируем файлы решения и проекта
COPY ProjectTgBot.sln .
COPY TgBot/TgBot.csproj ./TgBot/
RUN dotnet restore

# Копируем весь код
COPY . .

# Собираем приложение
WORKDIR /src/TgBot
RUN dotnet publish -c Release -o /app/publish

# Этап запуска
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Переменная среды (значение можно задать при запуске контейнера)
ENV BotToken="8146875897:AAHq9t1i2YIf6wq1MX-jCCskA4SW2Y8GMkQ"

# Запускаем бота
ENTRYPOINT ["dotnet", "TgBot.dll"]
