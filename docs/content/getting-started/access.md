# Requesting Access

TULIP access is managed through [SURF Research Access Management (SRAM)](https://sram.surf.nl/). You join a collaboration once, then issue and revoke your own tokens without contacting the TULIP team.

## Step 1: Join the collaboration

1. Go to [sram.surf.nl](https://sram.surf.nl/).
2. Search for the **TU-Delft-Tulip** collaboration (short name `tudelfttulip`).
3. Request to join. TU Delft affiliation is required.
4. Wait for approval from the collaboration administrators.

Processing usually takes one to two business days. You receive an email once you are approved.

## Step 2: Create an application token

1. Log in to [sram.surf.nl](https://sram.surf.nl/).
2. Go to **Profile** and then **Application Tokens**.
3. Select **Create new token**.
4. Select the TULIP service.
5. Give the token a descriptive name, for example `TULIP research project`.
6. Copy the generated token and store it somewhere safe.

!!! warning "The token is shown only once"
    A token cannot be retrieved after creation. If you lose it, revoke it and create a new one. Never commit tokens to version control.

## Access tiers

Your access tier follows your group membership within the collaboration. Administrators manage that membership; there is nothing to configure on your side.

## Legacy API keys

Keys issued before the SRAM migration (`sk-tulip-...`) were disabled on **September 24, 2026**. Requests with such a key return `401 Unauthorized`. Use an SRAM application token instead, as described above.

Once you have a token, continue with [Your First Request](first-interaction.md).
