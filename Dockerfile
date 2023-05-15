# First stage: Build the application and the custom JRE
FROM eclipse-temurin:17 as app-build

# Specify the Java release version
ENV RELEASE=17

# Create a non-root user for running the application
RUN groupadd --gid 1000 spring-app \
  && useradd --uid 1000 --gid spring-app --shell /bin/bash --create-home spring-app

# Use the non-root user and set the working directory
USER spring-app:spring-app
WORKDIR /opt/build

# Copy the application JAR file into the image
COPY ./build/libs/*-SNAPSHOT.jar ./application.jar

USER root
RUN mkdir -p /opt/build/dependencies \
  && chown -R spring-app:spring-app /opt/build

# Switch back to spring-app user
USER spring-app:spring-app

# Use Spring Boot's layer tools to extract the application layers
RUN java -Djarmode=layertools -jar application.jar extract

# Use jlink to build a custom JRE based on the modules the application needs
# Note: This will fail if any of the JAR files are multi-release JAR files
RUN $JAVA_HOME/bin/jlink \
         --add-modules `jdeps --ignore-missing-deps -q -recursive --multi-release ${RELEASE} --print-module-deps -cp "dependencies/BOOT-INF/lib/*":"snapshot-dependencies/BOOT-INF/lib/*" application.jar` \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output jdk

# Second stage: Build the final Docker image
FROM debian:buster-slim

# Specify the path of the build directory
ARG BUILD_PATH=/opt/build

# Set the JAVA_HOME environment variable
ENV JAVA_HOME=/opt/jdk

# Add the Java binaries to the PATH
ENV PATH "${JAVA_HOME}/bin:${PATH}"

## Create the same non-root user as in the first stage
#RUN groupadd --gid 1000 spring-app \
#  && useradd --uid 1000 --gid spring-app --shell /bin/bash --create-home spring-app
#
## Use the non-root user and set the working directory
#USER spring-app:spring-app
WORKDIR /opt/workspace

# Copy the JRE and the application layers from the first stage
COPY --from=app-build $BUILD_PATH/jdk $JAVA_HOME
COPY --from=app-build $BUILD_PATH/spring-boot-loader/ ./
COPY --from=app-build $BUILD_PATH/dependencies/ ./
COPY --from=app-build $BUILD_PATH/snapshot-dependencies/ ./
COPY --from=app-build $BUILD_PATH/application/ ./

# Specify the command to run when the Docker container starts
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
