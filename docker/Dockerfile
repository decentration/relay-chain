
#FROM decentration/ci-linux:production as builder


FROM decentration/polkadot:master as builder


#RUN rustup uninstall nightly
#RUN rustup install nightly-2022-01-11
#RUN rustup update 
#RUN rustup update nightly
#RUN rustup target add wasm32-unknown-unknown --toolchain nightly-2022-01-11

RUN cargo clean
RUN cargo update
RUN cargo cargo +nightly-2022-01-11 build --release

#WORKDIR /polkadot

#COPY . /polkadot/