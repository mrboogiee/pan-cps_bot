# Implements the cps_bot python script from github.com/ipzero209/cps_bot
FROM ubuntu:18.04

ENV PANOSVERSION 81

RUN apt update && apt -y upgrade && apt -y install curl unzip snmp snmp-mibs-downloader python python-pip
RUN pip install pudb
RUN download-mibs
RUN curl https://docs.paloaltonetworks.com/content/dam/techdocs/en_US/zip/snmp-mib/pan-${PANOSVERSION}-snmp-mib-modules.zip > pan-90-snmp-mib-modules.zip
RUN unzip pan-${PANOSVERSION}-snmp-mib-modules.zip; for f in *.my; do mv -- "$f" "/usr/share/snmp/mibs/${f%.my}.txt"; done && rm *.md5 && rm pan-${PANOSVERSION}-snmp-mib-modules.zip && echo "mibs +ALL" >> /etc/snmp/snmp.conf
RUN mkdir cps_bot && curl https://raw.githubusercontent.com/ipzero209/cps_bot/master/cps_bot.py > cps_bot/cps_bot.py && chmod +x cps_bot/cps_bot.py

RUN groupadd -g 999 cps_bot && \
    useradd -r -u 999 -g cps_bot cps_bot
RUN chown -R cps_bot:cps_bot cps_bot
USER cps_bot


WORKDIR /cps_bot
ENTRYPOINT ["/bin/bash"]
