ARG DOWNLOAD_SOURCE=https://download.visualstudio.microsoft.com/download/pr/6f3836d9-506e-4284-aa31-93ab52c5395c/8eb25aa85c3953bae3cd1935a893b938/dotnet-sdk-5.0.203-linux-musl-x64.tar.gz
ARG DOWNLOAD_CHECKSUM=188c4b0259941a69787f8a619b44acea9443eacec04cbe3ed3bd93a35bf801ce41aeb9ae8078f5b05c422e6340b57dbe9ca7373e6a71e126812bff54062db507
ARG INSTALL_TARGET=/opt/dotnet

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
RUN apk update; apk upgrade
RUN apk add icu-libs krb5-libs libgcc libintl libssl1.1 libstdc++ zlib
COPY --from=download ${INSTALL_TARGET} ${INSTALL_TARGET}
RUN ln -s ${INSTALL_TARGET}/dotnet /usr/local/bin/dotnet
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV DOTNET_ROOT=${INSTALL_TARGET}
