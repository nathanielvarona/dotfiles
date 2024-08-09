# GNU Pretty Good Privacy (PGP)

The `pass` Password Manager and `pinentry` Passphrase Entry Dialog Utilizing the Assuan Protocol

```bash
defaults write org.gpgtools.common UseKeychain false
```

## Troubleshooting

1. Restart the GPG Agent for Any GPG related Configuration Changes

```bash
gpgconf --kill gpg-agent
```

2. Update the BrowserPass Native messaging host, especially Browser Updates and BrowserPass Updates.

```bash
PREFIX='/usr/local/opt/browserpass' \
  make hosts-chrome-user -f '/usr/local/opt/browserpass/lib/browserpass/Makefile'
```
