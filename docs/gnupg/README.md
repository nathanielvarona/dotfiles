# GnuPG / GPG (GNU Pretty Good Privacy)

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

**Usage:**

To configure your browser, **RUN THE FOLLOWING:**

```bash
PREFIX='/usr/local/opt/browserpass' make hosts-BROWSER-user -f '/usr/local/opt/browserpass/lib/browserpass/Makefile'
```

Where **BROWSER** is one of the following: [`chromium` `chrome` `vivaldi` `brave` `firefox`]

**Example:**

```bash
PREFIX='/usr/local/opt/browserpass' make hosts-chrome-user -f '/usr/local/opt/browserpass/lib/browserpass/Makefile'
```

## Working with Keys

### Public Key

#### Importing Public Key

```bash
gpg --import ./publickey.asc
```

### Private Key

#### Obtain the **Encrypted Private Key** from a secured storage and **Decrypt** it with **PassPhrase**

```bash
gpg ./privatekey.asc.enc
```

#### Importing Private Key

```bash
gpg --import ./privatekey.asc
```
