FROM registry.cn-hangzhou.aliyuncs.com/base/tomcat:8.5.29-jre8-gradle2.14.1
RUN mkdir -p workspace

COPY . workspace/

RUN gradle clean war -p workspace/ && \
    rm -rf $CATALINA_HOME/webapps/* && mkdir $CATALINA_HOME/webapps/ROOT && \
    unzip -o workspace/build/libs/hello-webapp.war -d $CATALINA_HOME/webapps/ROOT/ && \
    rm -rf workspace/
