ARG DOWNLOAD_SOURCE=https://download.visualstudio.microsoft.com/download/pr/10758180-a55d-444d-9b9b-0497d6fce4c0/c8941291391ec67f5a07634048905881/dotnet-sdk-3.1.409-linux-musl-x64.tar.gz
ARG DOWNLOAD_CHECKSUM=ec0e94fbc1b02eee58be344bb201a72cba4cb5c8ac0075adbf2937587ea66e2786e76fcc57cd6e4336ac448be54afbadce063cdc91707d009dc8242e2bfe31a2
ARG INSTALL_TARGET=/opt/dotnet
ARG AVRO_TOOLS_VERSION=1.10.2

FROM alpine:3.13.5 AS download
ARG DOWNLOAD_SOURCE
ARG DOWNLOAD_CHECKSUM
ARG INSTALL_TARGET
RUN apk update; apk upgrade
RUN apk add curl
RUN mkdir -p ${INSTALL_TARGET}
RUN curl -o dotnet.tar.gz ${DOWNLOAD_SOURCE}
RUN echo "${DOWNLOAD_CHECKSUM}  dotnet.tar.gz" > dotnet.tar.gz.sha512
RUN sha512sum -c dotnet.tar.gz.sha512
RUN tar xzf dotnet.tar.gz -C ${INSTALL_TARGET}

FROM alpine:3.13.5
ARG INSTALL_TARGET
ARG AVRO_TOOLS_VERSION
RUN apk update; apk upgrade
RUN apk add icu-libs krb5-libs libgcc libintl libssl1.1 libstdc++ zlib
COPY --from=download ${INSTALL_TARGET} ${INSTALL_TARGET}
RUN ln -s ${INSTALL_TARGET}/dotnet /usr/local/bin/dotnet
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV DOTNET_ROOT=${INSTALL_TARGET}
RUN dotnet tool install --global Apache.Avro.Tools --version ${AVRO_TOOLS_VERSION} && \
    ln -s /root/.dotnet/tools/avrogen /usr/local/bin/avrogen
