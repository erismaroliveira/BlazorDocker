FROM mcr.microsoft.com/dotnet/sdk:7.0 as build
WORKDIR /app

COPY BlazorDemo.sln ./
COPY ./BlazorDemo/BlazorDemo.csproj ./BlazorDemo/

RUN dotnet restore
COPY . ./
RUN dotnet publish -c Release -o out

FROM nginx:1.23.0-alpine
WORKDIR /app
EXPOSE 8080
ARG Environment
COPY nginx.conf /etc/nginx/nginx.conf
RUN sed -i "s/replaceme/${Environment}/" /etc/nginx/nginx.conf
COPY --from=build /app/out/wwwroot /usr/share/nginx/html