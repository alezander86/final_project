# Build the application first using Maven
#FROM maven:3.8-openjdk-11 as build
#WORKDIR /app
#COPY . .
#RUN mvn install

# Inject the JAR file into a new container to keep the file small
#FROM openjdk:8-jre-alpine
#WORKDIR /app
#COPY --from=build /app/target/hello-java-*.jar /app/app.jar
#EXPOSE 8080
#ENTRYPOINT ["sh", "-c"]
#CMD ["java -jar app.jar"]

FROM openjdk:8-jre-alpine
RUN mkdir /app && addgroup -S taryraiev && adduser -S -s /bin/false -G taryraiev taryraiev
WORKDIR /app
COPY /var/lib/jenkins/workspace/final_project/app.jar /app
RUN chown -R taryraiev:taryraiev /app && ls -la
USER taryraiev
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]