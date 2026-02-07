# Secrets

This directory contains encrypted secrets managed by sops-nix.

## Initial Setup

1. Generate an age keypair (if you don't have one):
   ```bash
   nix-shell -p age --run "age-keygen"
   ```

2. Save the full output (including the public key comment) to Bitwarden:
   - Create a Secure Note named `age-key`
   - Paste the entire output into the notes field

3. Run the bootstrap script on this machine:
   ```bash
   install-age-key
   ```

4. Update `.sops.yaml` in the repo root with your public key

5. Create the encrypted secrets file:
   ```bash
   nix-shell -p sops --run "sops secrets/secrets.yaml"
   ```

   This opens your editor. Enter your secrets in YAML format:
   ```yaml
   ssh:
     id_rsa: |
       -----BEGIN OPENSSH PRIVATE KEY-----
       ... your private key ...
       -----END OPENSSH PRIVATE KEY-----
     id_rsa_pub: "ssh-rsa AAAA... your-email@example.com"
   ```

6. Save and exit - sops encrypts the file automatically

7. Run `switch` to deploy

## Adding a New Machine

1. Generate age keypair on the new machine
2. Save to Bitwarden (same `age-key` note, or create machine-specific ones)
3. Add the new public key to `.sops.yaml`
4. Re-encrypt secrets to include the new key:
   ```bash
   nix-shell -p sops --run "sops updatekeys secrets/secrets.yaml"
   ```
5. Commit and push
6. On new machine: `install-age-key && switch`

## Editing Secrets

```bash
nix-shell -p sops --run "sops secrets/secrets.yaml"
```
