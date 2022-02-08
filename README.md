# Matrix Synapse (Docker Compose)

## Prerequisites

1. [Docker](https://docs.docker.com/engine/install/)
2. [Docker Compose](https://docs.docker.com/compose/install/)
3. A domain

## Setup

### Create a `.env` file

1. Create a copy of `.env.example`:

```bash
cp .env.example .env
```

2. Replace `VOLUME_PATH` variable if you wish to change where volume data is stored

3. Replace `SERVER_NAME` variable with your Matrix server's domain name (e.g. `matrix.example.com`)

4. Replace `TZ` variable with your timezone

5. Create the required PostgreSQL secret file `postgres_password.txt` and insert a secure password (you should consider restricting access to this file)

### Generate `homeserver.yaml`

1. Run the following command to use the `matrixdotorg/synapse` image to generate a `homeserver.yaml` file (replace `$VOLUME_PATH` with the value you set in your [.env](.env) file and `example.com` with your domain):

```bash
sudo docker run -it --rm \
    --mount type=bind,src=$VOLUME_PATH/data,dst=/data \
    -e SYNAPSE_SERVER_NAME=example.com \ `# Replace with your domain`
    -e SYNAPSE_REPORT_STATS=no \ `# Change to yes if you wish to report stats to Matrix`
    matrixdotorg/synapse:latest generate
```

The `homeserver.yaml` file should now exist at `$VOLUME_PATH/data/homeserver.yaml`

2. Open the newly created `homeserver.yaml` in your favourite editor

3. Locate the following lines in the config:

```yaml
database:
  name: sqlite3
  args:
    database: /data/homeserver.db
```

4. Replace these lines with the following (replace `secretpassword` with the password you put into [postgres_password.txt](postgres_password.txt)):

```yaml
database:
  name: psycopg2
  txn_limit: 10000
  args:
    user: synapse_user
    password: secretpassword
    database: synapse
    host: postgres
    port: 5432
    cp_min: 5
    cp_max: 10
```

5. Locate the `public_baseurl` setting in `homeserver.yaml` and set it to the URL of your Matrix server domain name (e.g. `matrix.example.com`)

6. Bring up the containers!

```bash
sudo docker-compose -p matrix-synapse up -d
```
