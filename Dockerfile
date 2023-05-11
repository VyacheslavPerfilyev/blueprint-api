# Stage 1: Compile and build .jar
FROM adoptopenjdk:17-jdk-hotspot as builder
WORKDIR /app
COPY . .
RUN ./gradlew clean build

# Stage 2: Run
FROM adoptopenjdk:17-jre-hotspot
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar ./app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
