# Stage 1: Build the WAR package using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Minimal runtime image with JRE 17 and Tomcat runner
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/target/greenmart-ptit.war /app/app.war
ADD https://repo1.maven.org/maven2/com/heroku/webapp-runner/9.0.86.0/webapp-runner-9.0.86.0.jar /app/webapp-runner.jar

ENV PORT=8080
EXPOSE 8080

CMD ["sh", "-c", "java -Xmx400m -jar /app/webapp-runner.jar --port ${PORT:-8080} /app/app.war"]
