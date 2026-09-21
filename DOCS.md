# Wealthfolio-wrapper app documentation

## Configuration

The configurable app options are:

- `secret_key`: optional. When omitted, the app generates a key on first start
  and persists it in the app configuration.
- `password`: password required for access.
- `log_level`: Wealthfolio application log verbosity. Options are `error`,
  `warn`, `info`, `debug`, and `trace`; the default is `info`.
- `cors`: list of origin URLs allowed to make cross-origin requests. At least
  one origin must be specified for the app to function properly. The default
  is an empty list.
- `ssl_tls.certificate_file`: certificate filename in `/ssl`; default
  `fullchain.pem`.
- `ssl_tls.private_key_file`: private key filename in `/ssl`; default
  `privkey.pem`.

Back up `secret_key` together with the app data. Changing or losing it makes
existing encrypted secrets unreadable.

## Ingress

The server listens on port 8089 internally and is exposed through Nginx on
container port 8088 for Home Assistant ingress. Direct HTTP host access is not
supported.

The server uses the configured files in `/ssl` for HTTPS. If either file is not
available at startup, the HTTPS listener is disabled. To enable direct HTTPS
access, choose a host port for `8443/tcp` in the add-on's **Network** settings
and access `https://<home-assistant-host>:<port>`.

## Persistent data

Home Assistant persists `/data`, which contains the SQLite database and
encrypted secrets. 

## Updating

The app currently pins `wealthfolio/wealthfolio:3.6.3`. Update the version,
test ingress thoroughly, and publish matching architecture images before changing
the app version.
