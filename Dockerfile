ARG DOWNLOAD_SOURCE=https://download.visualstudio.microsoft.com/download/pr/21fdb75c-4eb5-476d-a8b8-1d096e4b7b14/c1f853410a58713cf5a56518ceeb87e8/dotnet-sdk-5.0.202-linux-musl-x64.tar.gz
ARG DOWNLOAD_CHECKSUM=cb367c4b5d011a233465fd2c674e1259eee2a888e9dfc3ec674e59542111b6e0c559a128b3641b4b1872c16429c1b9be9052f8c07462eb4a6148eeb40a19d29a
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
