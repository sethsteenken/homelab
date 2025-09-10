# Plex Server Troubleshooting

## How To Claim Your Server

After "log out on all devices" you may need to claim your server again.

1. Go to [https://plex.tv/claim](https://plex.tv/claim)
2. Copy the claim code
3. SSH into your Plex server
4. Go to the volume for the Plex container at `/var/lib/docker/volumes/plex_config_data/_data/`
5. Run `sudo bash`
6. Edit the file `Preferences.xml` with `nano Preferences.xml`
7. Find the value `ProcessedMachineIdentifier`
8. Run curl command (on local machine or server) to get the new machine identifier:

   ```bash
   curl -X POST -s -H "X-Plex-Client-Identifier: {processed_machine_identifier}" "https://plex.tv/api/claim/exchange?token={claim_token}"
   ```

See [reference here](https://www.plexopedia.com/plex-media-server/general/claim-server/).
