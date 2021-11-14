FROM ubuntu:latest AS base

RUN set -xe \
	&& apt-get update \
	&& apt-get upgrade -y

FROM base AS dependencies

ENV VERSION 1.6.0
ENV MAUDE_URL http://maude.cs.illinois.edu/w/images/2/27/Maude-3.0%2Byices2-linux.zip

RUN set -xe \
	&& apt-get install -y curl zip

RUN set -xe \
	&& mkdir -p /dependencies \
	&& curl -q -s -S -L --create-dirs -o maude.zip $MAUDE_URL \
	&& unzip maude.zip -d /dependencies \
	&& mv /dependencies/maude-Yices2.linux64 /dependencies/maude \
	&& curl -q -s -S -L --create-dirs -o tamarin.tar.gz https://github.com/tamarin-prover/tamarin-prover/releases/download/$VERSION/tamarin-prover-$VERSION-linux64-ubuntu.tar.gz \
	&& tar -x -C /dependencies -f tamarin.tar.gz \
	&& chmod -R +x /dependencies

FROM base AS runtime

VOLUME /workspace

EXPOSE 3001

COPY --from=dependencies /dependencies /usr/local/bin

RUN set -xe \
	&& addgroup tamarin \
	&& adduser --disabled-password --gecos '' --ingroup tamarin tamarin \
	&& apt-get install -y graphviz libtinfo5 \
	&& apt-get clean

USER tamarin

WORKDIR /workspace

ENTRYPOINT ["tamarin-prover"]

CMD ["interactive", "."]
