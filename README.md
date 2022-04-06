# Pop-Art Relay Chain 

![alt text](https://github.com/Kabocha-Network/polkadot/blob/master/images/pop-art.jpg?raw=true?raw=true)

This branch contains Pop-Art, a custom Rococo relay staging network. It is intended for projects in the Substrate ecosytem (and Edgeware/Kabocha community), so that people can test their parachain integrations, and get experiecne as a validator in a shared network. 


# Launch a Validator

To launch a validator you will need to:

- Create BABE and GRANDPA keys.
- Make an account on Pop-Art relay, get some POP tokens and get that account registered as a validator by an admin.
- Submit BABE and GRANDPA keys to your node keystore.
- Rotate keys then submit keys via an extrinsic.

Then you should start to be included to participate in validation on Pop-Art.

Below is a more detailed guide:
## Launch a node

First you need to compile and launch your node with the --validator flag and the correct chain spec in order to make sure it is peering with the correct network, then you will be able to convert this node into a working validator through a few steps shared below: 

### Boot to the correct network
Make sure nodes are peering, and do that through running the correct chain spec and booting through an node in that network. 

Example of a command:

```bash
./target/release/polkadot \
-- validator \
-- base-path /tmp/relay/MyVal1 \ specify your db path
-- chain ./specs/pop-art-3-val.json \
-- port 30333 \
-- ws-port 9944 \
-- rpc-port 9933 \
-- rpc-methods=Unsafe \
-- name <INSERT CUSTOM NAME> \
-- telemetry-url 'wss://telemetry.polkadot.io/submit/ 0' \
-- node-key <INSERT-KEY> optional
```

_In this instance, our chain spec contains bootnodes, but if you come across a chain spec without any bootnodes, ask someone who is running a node to provide you with a bootnode address and then add the `— bootnodes` tag to your command._


## Register new validators

### Get some POP tokens
Ask in the [Kabocha Technical Chat](https://matrix.to/#/#kabocha.technical:matrix.org) for some POP so that you can add "existential deposit" to your (stash) AccountIds of their validators.

### Ask Sudo to register your AccountIds as Validators
Ask the sudo to register your validators as via the `sudo > validatorManager > registerValidators`


## Submit Keys 

Submit your keys to your node's key store. You can manually add them in or do so by curl. 



## Rotate Keys
Now they are registered you (and your partner) can “rotate keys”, so that new keys are generated and populated in all the session key fields for your validators.

Submitting calls via RPC can be long winded, so a neat trick is to submit the BABE and GRANDPA so the chain produces and finalizes blocks, then you can run author_rotateKeys for each of your validators, which will then generate all your other keys automatically.

```
curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "author_rotateKeys", "params":[]}' http://localhost:9933 
```

Make the RPC call in the terminal of your where your validator’s node is located, which should look like this:

![3 author_rotateKeys calls for my 3 validators. If you have one validator you only need to make the call once.](https://miro.medium.com/max/1400/1*9TxE-iVRz7qxgi3xD_VgWw.png)

Once you have generated the returned hex result you need to submit them as an extrinsic for all the validators you’ve done that for.

`session > setKeys(keys, proof)`

![The UI for the setKeys extrinsic call](https://miro.medium.com/max/1400/0*pWs9X_HF_OcuLWJt.png)

- Be conscious of the account you are using to set the keys.
- In “proof” just add 0x00 (not guaranteed to be secure).
- Submit transaction

_Wait for an epoch to see the changes, and other validators._

A guide for people who forked this relay and need a workflow to add validators.


# Fork this relay chain and launch youre own network 

//ToDo
### Submit keys
This guide assumes you have the sudo account, you've launched your validators, have submitted your babe and grandpa keys and are producing and finalizing blocks.

### Make sure validators are working
Make sure your nodes are producing blocks and finalizing, if they are not, restart nodes, and add keys again, (or use the author_hasKey RPC method to check they have the correct keys).


# Polkadot

Implementation of a <https://polkadot.network> node in Rust based on the Substrate framework.

> **NOTE:** In 2018, we split our implementation of "Polkadot" from its development framework
> "Substrate". See the [Substrate][substrate-repo] repo for git history prior to 2018.

[substrate-repo]: https://github.com/paritytech/substrate

This repo contains runtimes for the Polkadot, Kusama, and Westend networks. The README provides
information about installing the `polkadot` binary and developing on the codebase. For more
specific guides, like how to be a validator, see the
[Polkadot Wiki](https://wiki.polkadot.network/docs/getting-started).

## Installation

If you just wish to run a Polkadot node without compiling it yourself, you may
either run the latest binary from our
[releases](https://github.com/paritytech/polkadot/releases) page, or install
Polkadot from one of our package repositories.

Installation from the Debian or rpm repositories will create a `systemd`
service that can be used to run a Polkadot node. This is disabled by default,
and can be started by running `systemctl start polkadot` on demand (use
`systemctl enable polkadot` to make it auto-start after reboot). By default, it
will run as the `polkadot` user.  Command-line flags passed to the binary can
be customized by editing `/etc/default/polkadot`. This file will not be
overwritten on updating polkadot. You may also just run the node directly from
the command-line.

### Debian-based (Debian, Ubuntu)

Currently supports Debian 10 (Buster) and Ubuntu 20.04 (Focal), and
derivatives. Run the following commands as the `root` user.

```bash
# Import the security@parity.io GPG key
gpg --recv-keys --keyserver hkps://keys.mailvelope.com 9D4B2B6EB8F97156D19669A9FF0812D491B96798
gpg --export 9D4B2B6EB8F97156D19669A9FF0812D491B96798 > /usr/share/keyrings/parity.gpg
# Add the Parity repository and update the package index
echo 'deb [signed-by=/usr/share/keyrings/parity.gpg] https://releases.parity.io/deb release main' > /etc/apt/sources.list.d/parity.list
apt update
# Install the `parity-keyring` package - This will ensure the GPG key
# used by APT remains up-to-date
apt install parity-keyring
# Install polkadot
apt install polkadot

```

### RPM-based (Fedora, CentOS)

Currently supports Fedora 32 and CentOS 8, and derivatives.

```bash
# Install dnf-plugins-core (This might already be installed)
dnf install dnf-plugins-core
# Add the repository and enable it
dnf config-manager --add-repo https://releases.parity.io/rpm/polkadot.repo
dnf config-manager --set-enabled polkadot
# Install polkadot (You may have to confirm the import of the GPG key, which
# should have the following fingerprint: 9D4B2B6EB8F97156D19669A9FF0812D491B96798)
dnf install polkadot
```

## Building

### Install via Cargo

Make sure you have the support software installed from the **Build from Source** section
below this section.

If you want to install Polkadot in your PATH, you can do so with with:

```bash
cargo install --git https://github.com/paritytech/polkadot --tag <version> polkadot --locked
```

### Build from Source

If you'd like to build from source, first install Rust. You may need to add Cargo's bin directory
to your PATH environment variable. Restarting your computer will do this for you automatically.

```bash
curl https://sh.rustup.rs -sSf | sh
```

If you already have Rust installed, make sure you're using the latest version by running:

```bash
rustup update
```

Once done, finish installing the support software:

```bash
sudo apt install build-essential git clang libclang-dev pkg-config libssl-dev
```

Build the client by cloning this repository and running the following commands from the root
directory of the repo:

```bash
git checkout <latest tagged release>
./scripts/init.sh
cargo build --release
```

Note that compilation is a memory intensive process. We recommend having 4 GiB of physical RAM or swap available (keep in mind that if a build hits swap it tends to be very slow).

#### Build from Source with Docker

You can also build from source using 
[Parity CI docker image](https://github.com/paritytech/scripts/tree/master/dockerfiles/ci-linux):

```bash
git checkout <latest tagged release>
docker run --rm -it -w /shellhere/polkadot \
                    -v $(pwd):/shellhere/polkadot \
                    paritytech/ci-linux:production cargo build --release
sudo chown -R $(id -u):$(id -g) target/
```

If you want to reproduce other steps of CI process you can use the following 
[guide](https://github.com/paritytech/scripts#gitlab-ci-for-building-docker-images).

## Networks

This repo supports runtimes for Polkadot, Kusama, and Westend.

### Connect to Polkadot Mainnet

Connect to the global Polkadot Mainnet network by running:

```bash
./target/release/polkadot --chain=polkadot
```

You can see your node on [telemetry] (set a custom name with `--name "my custom name"`).

[telemetry]: https://telemetry.polkadot.io/#list/Polkadot

### Connect to the "Kusama" Canary Network

Connect to the global Kusama canary network by running:

```bash
./target/release/polkadot --chain=kusama
```

You can see your node on [telemetry] (set a custom name with `--name "my custom name"`).

[telemetry]: https://telemetry.polkadot.io/#list/Kusama

### Connect to the Westend Testnet

Connect to the global Westend testnet by running:

```bash
./target/release/polkadot --chain=westend
```

You can see your node on [telemetry] (set a custom name with `--name "my custom name"`).

[telemetry]: https://telemetry.polkadot.io/#list/Westend

### Obtaining DOTs

If you want to do anything on Polkadot, Kusama, or Westend, then you'll need to get an account and
some DOT, KSM, or WND tokens, respectively. See the
[claims instructions](https://claims.polkadot.network/) for Polkadot if you have DOTs to claim. For
Westend's WND tokens, see the faucet
[instructions](https://wiki.polkadot.network/docs/learn-DOT#getting-westies) on the Wiki.

## Hacking on Polkadot

If you'd actually like to hack on Polkadot, you can grab the source code and build it. Ensure you have
Rust and the support software installed. This script will install or update Rust and install the
required dependencies (this may take up to 30 minutes on Mac machines):

```bash
curl https://getsubstrate.io -sSf | bash -s -- --fast
```

Then, grab the Polkadot source code:

```bash
git clone https://github.com/paritytech/polkadot.git
cd polkadot
```

Then build the code. You will need to build in release mode (`--release`) to start a network. Only
use debug mode for development (faster compile times for development and testing).

```bash
./scripts/init.sh   # Install WebAssembly. Update Rust
cargo build # Builds all native code
```

You can run the tests if you like:

```bash
cargo test --all --release
```

You can start a development chain with:

```bash
cargo run -- --dev
```

Detailed logs may be shown by running the node with the following environment variables set:

```bash
RUST_LOG=debug RUST_BACKTRACE=1 cargo run -- --dev
```

### Development

You can run a simple single-node development "network" on your machine by running:

```bash
polkadot --dev
```

You can muck around by heading to <https://polkadot.js.org/apps> and choose "Local Node" from the
Settings menu.

### Local Two-node Testnet

If you want to see the multi-node consensus algorithm in action locally, then you can create a
local testnet. You'll need two terminals open. In one, run:

```bash
polkadot --chain=polkadot-local --alice -d /tmp/alice
```

And in the other, run:

```bash
polkadot --chain=polkadot-local --bob -d /tmp/bob --port 30334 --bootnodes '/ip4/127.0.0.1/tcp/30333/p2p/ALICE_BOOTNODE_ID_HERE'
```

Ensure you replace `ALICE_BOOTNODE_ID_HERE` with the node ID from the output of the first terminal.

### Monitoring

[Setup Prometheus and Grafana](https://wiki.polkadot.network/docs/maintain-guides-how-to-monitor-your-node).

Once you set this up you can take a look at the [Polkadot Grafana dashboards](grafana/README.md) that we currently maintain. 

### Using Docker

[Using Docker](doc/docker.md)

### Shell Completion

[Shell Completion](doc/shell-completion.md)

# For Sudo registering validators

![AccountId’s are the first two address above grandpa](https://miro.medium.com/max/1400/1*yLobLWXVQyFp5URX35qiyg.png)

You can connect to the UI (if you have a RPC node running) to make this extrinsic call.

`sudo > validatorManager > registerValidators(validators)`

![Screenshot of registering new validators to the mix](https://miro.medium.com/max/1400/1*v_4x8ElgmRhKDhvUVCWlhA.png)

You can do more than one at a time (as shown below)

![Screenshot of registering new validators to the mix](https://miro.medium.com/max/1400/1*ay_hGmwSXYGxWBAoKmR-7A.png)

## Contributing

### Contributing Guidelines

[Contribution Guidelines](CONTRIBUTING.md)

### Contributor Code of Conduct

[Code of Conduct](CODE_OF_CONDUCT.md)

## License

Polkadot is [GPL 3.0 licensed](LICENSE).