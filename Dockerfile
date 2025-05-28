# Start with OpenJDK image to run Java apps
FROM openjdk:17-jdk-slim

# Set working directory inside container
WORKDIR /app

# Copy built JAR file from host into container
COPY target/cmdb-app.jar app.jar

# Expose port (optional, if app runs on 8080)
EXPOSE 8080

# Command to run app
ENTRYPOINT ["java", "-jar", "app.jar"]

