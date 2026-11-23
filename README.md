# Splunk SOC Lab

I built this lab to practise collecting service logs in Splunk and searching the events produced by simulated attacks.

It runs Splunk Enterprise, Nginx, MySQL, syslog-ng, Universal Forwarders, and a Kali container with attack scripts. The focus is the log flow: generate activity, check what arrives, and work on searches from there.

## Log flow

```text
Nginx logs ── Universal Forwarder ──┐
                                  ├── Splunk Enterprise
MySQL logs ── Universal Forwarder ─┘

Kali scripts generate traffic against the lab services.
```

The Compose file also defines a syslog collector, an Ubuntu target, and a log generator. Forwarder configuration examples are under `configs/`.

## Run the lab

You need Docker and Docker Compose. The original setup budget was at least 8 GB of RAM and about 20 GB of disk space.

```bash
git clone https://github.com/luisantoniio1998/soc-lab-splunk.git
cd soc-lab-splunk
docker-compose up -d
```

Watch Splunk start:

```bash
docker logs -f splunk-enterprise
```

Open http://localhost:8000. The lab credentials in the Compose file are `admin` / `ChangeMe123!`.

To run the attack simulation:

```bash
./lab.sh attacks
```

The examples include web attacks, network scans, and generated traffic. Use Splunk to check which events were collected.

## Files

- `docker-compose.yml` — lab services and volumes
- `configs/` — Nginx, MySQL, syslog, and forwarder configuration examples
- `attack-scripts/` — traffic generation and attack scripts
- `lab.sh` — lab helper commands

## Stop the lab

```bash
docker-compose down
```

This is a learning environment with deliberately weak lab credentials. Keep the attack traffic within the lab.
