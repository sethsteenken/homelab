bw login --apikey

BW_SESSION=$( bw unlock --passwordenv BW_PASSWORD --raw )

RUN $env:BW_SESSION=$( bw unlock --passwordenv BW_PASSWORD --raw )
bw export --output /documents/bitwarden_vault_backup --format encrypted_json