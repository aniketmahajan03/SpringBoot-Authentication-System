# Use OpenJDK 17 base image
FROM eclipse-temurin:17-jdk-alpine AS build

# Set working directory
WORKDIR /app

# Copy Maven wrapper and project files
COPY . .

# Build the project (skipping tests for faster build)
RUN ./mvnw clean package -DskipTests

# Use a smaller JDK image for runtime
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the built jar from the previous build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port 8080
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
