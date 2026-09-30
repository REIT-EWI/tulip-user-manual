# Requesting Access

TULIP access is managed through [SURF Research Access Management (SRAM)](https://sram.surf.nl/).
You only need to complete this setup once: if you already have a collaboration invite, go straight to [Step 2](#step-2-create-an-application-token); otherwise complete [Step 1](#step-1-join-the-collaboration) and then [Step 2](#step-2-create-an-application-token).

## Step 1: Join the collaboration

1. Follow the link to [**TU-Delft-Tulip** SRAM collaboration](https://sram.surf.nl/registration?collaboration=6378c522-a708-427d-82be-ad43d86765e8).
2. Request to join. TU Delft affiliation is required.
3. Wait for approval from the collaboration administrators.

Processing usually takes one to two business days. You receive an email once you are approved.

## Step 2: Create an application token

This SRAM application token is the API key you use with TULIP clients and examples.

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

Once you have your API key, continue with [Your First Request](first-interaction.md).
