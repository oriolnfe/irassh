FROM debian:10


RUN apt-get -y update
RUN apt-get -y install apt-utils
RUN apt-get -y install python2 python-virtualenv python-pip python2-dev build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev zlib1g-dev wget libmariadb-dev-compat default-libmysqlclient-dev ssh python-tk gcc vim byobu

WORKDIR /usr/src/irassh

ENV PATH="/usr/local/opt/mysql-client/bin/bin:$PATH"

ENV PATH="$PATH:/usr/local/mysql/bin/" 

RUN mkdir -p /usr/include/mysql/ && wget https://raw.githubusercontent.com/paulfitz/mysql-connector-c/master/include/my_config.h -O /usr/include/mysql/my_config.h

RUN mkdir -p /usr/include/mysql/server/ && wget https://raw.githubusercontent.com/paulfitz/mysql-connector-c/master/include/my_config.h -O /usr/include/mysql/my_config.h

COPY src .

RUN useradd -m irassh
RUN chown -R irassh:irassh /usr/src/irassh/
RUN chown -R irassh:irassh /usr/include/mysql/

USER irassh
ENV PATH="$PATH:/home/irassh/.local/bin"
RUN pip2 install typing
RUN pip2 install automat==0.5.0
RUN pip2 install incremental==17.5.0
RUN pip2 install twisted==17.1.0
RUN python2 -m pip install -r requirements.txt
RUN pip2 install matplotlib
RUN pip2 install arrow
RUN pip2 uninstall -y backports.functools_lru_cache
RUN pip2 install backports.functools_lru_cache==1.2.1

RUN mkdir -p log && mkdir -p log/tty
# run irassh as user irassh
CMD ["bin/irassh", "start"]
# CMD ["tail", "-f", "/dev/null"]


