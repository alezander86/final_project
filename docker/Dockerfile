FROM openjdk:8-jre-alpine
RUN mkdir /app && addgroup -S taryraiev && adduser -S -s /bin/false -G taryraiev taryraiev
WORKDIR /app
COPY ./docker /app
RUN chown -R taryraiev:taryraiev /app && ls -la
USER taryraiev
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]