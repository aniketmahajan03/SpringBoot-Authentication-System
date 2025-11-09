# Use OpenJDK 17 base image for building
FROM eclipse-temurin:17-jdk-alpine AS build

WORKDIR /app

# Copy project files
COPY . .

# Give execute permission to mvnw
RUN chmod +x mvnw

# Build the application (skip tests for speed)
RUN ./mvnw clean package -DskipTests

# Use a smaller image for running the app
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]
