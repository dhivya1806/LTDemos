# Stage 1: Build the Java application
FROM eclipse-temurin:17-jdk AS builder
 
# Set working directory
WORKDIR /app
 
# Copy project files
COPY . .
 
# Build the application using Maven
RUN ./mvnw clean package -DskipTests
 
# Stage 2: Create a minimal runtime image with a non-root user
FROM eclipse-temurin:17-jre
 
# Set a non-root user
RUN useradd -m appuser
 
# Set working directory
WORKDIR /app
 
# Copy only the necessary artifact (JAR file) from the builder stage
COPY --from=builder /app/target/*.jar app.jar
 
# Change ownership to the non-root user
RUN chown -R appuser:appuser /app
 
# Switch to non-root user
USER appuser
 
# Expose application port (modify as needed)
EXPOSE 3000
 
# Run the Java application
CMD ["java", "-jar", "app.jar"]
