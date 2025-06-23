FROM openjdk:8-jdk-alpine

EXPOSE 8080

RUN mkdir /opt/bootcamp-java-maven-app
RUN addgroup -S mygroup && adduser -S myuser -G mygroup
RUN chown -R myuser:mygroup /opt/bootcamp-java-maven-app
USER myuser

COPY ./target/java-maven-app-*.jar /opt/bootcamp-java-maven-app

CMD java -jar /opt/bootcamp-java-maven-app/java-maven-app-*.jar