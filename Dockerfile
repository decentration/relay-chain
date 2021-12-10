
FROM paritytech/ci-linux:production as builder

LABEL description="This is the build stage for polkadot. Here we create the binary."

ARG PROFILE=release
WORKDIR /polkadot

COPY . /polkadot/
#RUN  fallocate -l 1G /swapfile

RUN rustup uninstall nightly
RUN rustup install nightly
RUN rustup update nightly
RUN rustup target add wasm32-unknown-unknown --toolchain nightly
RUN cargo clean
RUN cargo update
#RUN cargo +nightly-2021-11-01 check 
RUN cargo build --release

# ===== SECOND STAGE ======

FROM debian:buster-slim
LABEL description="This is the 2nd stage: a very small image where we copy the polkadot binary."
ARG PROFILE=release
COPY --from=builder /polkadot/target/$PROFILE/polkadot /usr/local/bin
COPY ./specs/ /specs/
RUN apt update && apt install -y ca-certificates 
RUN useradd -m -u 1000 -U -s /bin/sh -d /polkadot polkadot && \
	mkdir -p /polkadot/.local/share && \
	mkdir /data && \
	chown -R polkadot:polkadot /data && \
	ln -s /data /polkadot/.local/share/polkadot && \
	rm -rf /usr/bin /usr/sbin

USER polkadot
EXPOSE 30333-30343 9933-9960 8080 300
VOLUME ["/data"]

CMD ["/usr/local/bin/polkadot"]