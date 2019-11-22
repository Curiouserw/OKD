FROM docker.io/sentry:9.1.2

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get install -y -q libxslt1-dev libxml2-dev libpq-dev libldap2-dev libsasl2-dev libssl-dev
RUN echo "sentry-ldap-auth\npython-decouple==3.0\ndjango-auth-ldap <=1.2.17" > /tmp/req.txt && \
    pip install -r /tmp/req.txt && \
    apt-get remove -y -q libxslt1-dev libxml2-dev libpq-dev libldap2-dev libsasl2-dev libssl-dev && \
    rm -rf /var/lib/apt/lists/* /tmp/req.txt
