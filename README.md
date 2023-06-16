These tools read an authentication token from ~/.config/synadm.yaml.
This token should be a token for an administrative user.

- set_ratelimit.sh was used to configure the mjolnir user for the first time
- process-all-rooms.sh iterates over every room on the server which whose canonical alias is `:nixos.org`.
  It configures default avatars, invites mjolnir, and verifies other properties like being public and unencrypted.
  It prompts for confirmation before making changes, but I haven't ever seen it behave in a way which would make unattended execution scary.

## Adding a room

1. Join the room as an administrator
1. Add the desired room alias :nixos.org
1. Run `process-all-rooms.sh` to configure Mjolnir
1. Add the room to the appropriate NixOS Subspace
