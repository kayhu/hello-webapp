FROM harbor.dev.chinacsci.com/loansystem/jdk8u92-tomcat8.5.29-gradle2.14.1:0.1

RUN mkdir -p workspace

COPY . workspace/

RUN gradle clean war -p workspace/ && \
    rm -rf $CATALINA_HOME/webapps/* && mkdir $CATALINA_HOME/webapps/ROOT && \
    unzip -o workspace/build/libs/hello-webapp.war -d $CATALINA_HOME/webapps/ROOT/ && \
    rm -rf workspace/

RUN sed -i "7,18d" $CATALINA_HOME/conf/context.xml

