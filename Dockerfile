FROM registry.cn-hangzhou.aliyuncs.com/iakuh/base:jdk8-tomcat8-gradle2.14.1

RUN mkdir -p workspace

COPY . workspace/

RUN gradle clean war -p workspace/ && \
    rm -rf $CATALINA_HOME/webapps/* && mkdir $CATALINA_HOME/webapps/ROOT && \
    unzip -o workspace/build/libs/hello-webapp.war -d $CATALINA_HOME/webapps/ROOT/ && \
    rm -rf workspace/

RUN sed -i "7,18d" $CATALINA_HOME/conf/context.xml

