FROM openjdk:8

ENV DOTCMS_HOME /srv
ENV DOTCMS_VERSION 5.0.3



RUN apt-get update -y && apt-get install dos2unix
RUN mkdir -p ${DOTCMS_HOME}



WORKDIR ${DOTCMS_HOME}

COPY ./docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh && dos2unix /entrypoint.sh

COPY ./srv ${DOTCMS_HOME} 

RUN chmod +x $DOTCMS_HOME/bin/*.sh \
    && chmod +x $DOTCMS_HOME/*.sh \
    && chmod +x $DOTCMS_HOME/dotserver/tomcat-8.5.32/bin/*.sh

VOLUME ["/srv"]

ADD log4j2.xml dotserver/tomcat-8.5.32/webapps/ROOT/WEB-INF/log4j/log4j2.xml
RUN mv plugins plugins-dist && mkdir plugins

EXPOSE 8080 8009 8000


ENTRYPOINT ["/entrypoint.sh"]
