FROM java:8-jdk-alpine

WORKDIR /opt

ADD ce-review /opt/ce-review

ENV cereview.config.location /opt/ce-review/src/main/resources/

WORKDIR /opt/ce-review/build/libs

RUN chmod +x ce-review-0.6.2.jar

EXPOSE 7070

CMD ["java", "-jar", "ce-review-0.6.2.jar"]