# Home Assistant app: Wealthfolio-wrapper

Wealthfolio-wrapper is a wrapper in order to run the Wealthfolio container 
within Home Assistant.

## Installation

Add this repository to Home Assistant, install the Wealthfolio-wrapper app, then start
it. Open the application with Home Assistant's **Open Web UI** button.

The app supports `amd64` and `aarch64` hosts. To enable direct HTTPS access,
open the add-on's **Network** settings, assign a host port for `8443/tcp`, then
access `https://<home-assistant-host>:<configured-port>`. By default, the app
uses the Home Assistant certificates mounted at `/ssl/fullchain.pem` and
`/ssl/privkey.pem`.

## Configuration

- `secret_key`: optional. The app generates and persists a key automatically on
  first start when this is omitted.
- `password`: password required for access.
- `log_level`: Wealthfolio application log verbosity. Options are `error`,
  `warn`, `info`, `debug`, and `trace`; the default is `info`.
- `cors`: list of origin URLs allowed to make cross-origin requests. Add at
  least one origin for the app to function properly; the default is an empty
  list.
- `ssl_tls.certificate_file`: certificate filename in `/ssl`; defaults to
  `fullchain.pem`.
- `ssl_tls.private_key_file`: private key filename in `/ssl`; defaults to
  `privkey.pem`.

Back up `secret_key`. Losing it makes encrypted credentials in the data volume
unrecoverable. The app listens internally on port 8089 behind the Nginx proxy,
which listens on container port 8088. The external host port is disabled by
default for HTTP; the optional HTTPS port 8443 can be assigned externally when
the Home Assistant SSL certificate files are available.

See [DOCS.md](DOCS.md) for configuration and backup details.

## Local development

Use the repository's Dev Container so you get the nested Docker and containerd
daemons, Home Assistant Supervisor tooling, and the VS Code extensions used by
this project.

1. Install the Dev Containers extension.
2. Open this repository in VS Code and run **Dev Containers: Reopen in
   Container**.
3. Start the local Home Assistant Supervisor from the container terminal:

   ```sh
   supervisor_run
   ```

   Alternatively, use the VS Code task **Start Home Assistant**.

4. Open the app through Home Assistant's **Open Web UI** ingress button.

The Dev Container publishes these local ports:

- `7123`: Home Assistant (`8123` in the container).
- `7180`: Home Assistant HTTP (`80` in the container).
- `7357`: Supervisor diagnostics (`4357` in the container).
- `7443`: app HTTPS (`8443` in the container).

The container runs with the privileges and persistent Docker, containerd, and
Supervisor volumes required by the nested Home Assistant environment. Its
startup command runs `devcontainer_bootstrap` and then
`.devcontainer/create-test-certificates.sh`. The latter creates a self-signed
certificate for `localhost` at `/mnt/supervisor/ssl/fullchain.pem` and
`/mnt/supervisor/ssl/privkey.pem` if they do not already exist.

For local HTTPS testing, use `https://localhost:7443` after assigning the
add-on's `8443/tcp` port. The add-on exposes the Supervisor's certificate
directory as `/ssl` at runtime. Browsers will show a certificate warning unless
the generated certificate is trusted locally.

This project does not include a standalone local server command. The supported
workflow is to run the app through Home Assistant's local Supervisor integration
inside the devcontainer.
