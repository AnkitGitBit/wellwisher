# Stage 1: compile a JAR file
FROM maven:3-eclipse-temurin-17-alpine as builder

# Copy local code to the container image.
WORKDIR /app
COPY pom.xml .
COPY src ./src

# Build a release artifact.
RUN mvn package -DskipTests

# Stage 2: run the previously built JAR file
FROM adoptopenjdk/openjdk11:jdk-11.0.11_9-alpine-slim

COPY --from=builder /app/target/cloudrun-*.jar /cloudrun.jar

# Run the web service on container startup.
CMD ["java","-Djava.security.egd=file:/dev/./urandom","-Dserver.port=${PORT}","-jar","/cloudrun.jar"]
