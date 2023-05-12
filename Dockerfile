#https://github.com/adoptium/containers/tree/5a7c9b25bbca1cde27828e819f765614f7daf774/17/jdk/ubuntu
FROM eclipse-temurin:17.0.3_7-jdk

ARG DEPENDENCY=build/dependency
COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY ${DEPENDENCY}/META-INF /app/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT java \
    -cp app:app/lib/* \
    -Djava.security.egd=file:/dev/./urandom \
    -XX:+UseG1GC \
    -XX:+UseStringDeduplication \
    -XX:MinRAMPercentage=50 \
    -XX:MaxRAMPercentage=80 \
    $JAVA_OPTS \
    com.philips.telcare.patientservice.PatientServiceApplication
