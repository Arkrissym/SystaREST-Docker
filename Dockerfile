FROM alpine as build

RUN apk add --no-cache openjdk11 git

RUN git clone https://github.com/beep-projects/SystaPi

COPY SystaREST.properties /SystaPi/SystaRESTServer/src/

RUN cd SystaPi/SystaRESTServer/ && \
    rm -rf ./bin/* && \
    cp ./src/SystaREST.properties ./bin/ && \
    cp ./src/rawdatamonitor.html ./bin/ && \
    cp ./src/fakeremoteportal.html ./bin/ && \
    cp ./src/systapidashboard.html ./bin/ && \
    javac -encoding utf8 -d ./bin/ -classpath ./bin:./lib/aopalliance-repackaged-3.0.1.jar:./lib/hk2-api-3.0.1.jar:./lib/hk2-locator-3.0.1.jar:./lib/hk2-utils-3.0.1.jar:./lib/jakarta.inject-api-2.0.0.jar:./lib/jakarta.json.bind-api-2.0.0.jar:./lib/jakarta.json-2.0.0-module.jar:./lib/jakarta.json-api-2.0.0.jar:./lib/jakarta.persistence-api-3.0.0.jar:./lib/jakarta.servlet-api-5.0.0.jar:./lib/jakarta.validation-api-3.0.0.jar:./lib/jakarta.ws.rs-api-3.0.0.jar:./lib/jakarta.ws.rs-api-3.0.0-sources.jar:./lib/javassist-3.25.0-GA.jar:./lib/jersey-client-3.0.2.jar:./lib/jersey-common-3.0.2.jar:./lib/jersey-container-jdk-http-3.0.2.jar:./lib/jersey-container-servlet-3.0.2.jar:./lib/jersey-container-servlet-core-3.0.2.jar:./lib/jersey-hk2-3.0.2.jar:./lib/jersey-media-jaxb-3.0.2.jar:./lib/jersey-media-json-binding-3.0.2.jar:./lib/jersey-media-sse-3.0.2.jar:./lib/jersey-server-3.0.2.jar:./lib/org.osgi.core-6.0.0.jar:./lib/osgi-resource-locator-1.0.3.jar:./lib/yasson-2.0.1.jar:./lib/jersey-test-framework-core-3.0.2.jar:./lib/jersey-test-framework-provider-grizzly2-3.0.2.jar ./src/de/freaklamarsch/systarest/*.java

FROM alpine

RUN apk add --no-cache openjdk11

RUN mkdir -p /SystaRESTServer/bin/
RUN mkdir -p /SystaRESTServer/lib/

COPY --from=build /SystaPi/SystaRESTServer/bin/ /SystaRESTServer/bin/
COPY --from=build /SystaPi/SystaRESTServer/lib/ /SystaRESTServer/lib/

EXPOSE 22460/udp
EXPOSE 1337/tcp

CMD [ "java", "-Dfile.encoding=UTF-8", "-classpath", "/SystaRESTServer/bin:/SystaRESTServer/lib/*", "de.freaklamarsch.systarest.SystaRESTServer" ]
