# DNS Ad Blocking Setup

This project provides a comprehensive DNS-based ad and tracker blocking solution using Pi-hole and Unbound in Docker containers. It blocks ads, malware, and tracking domains at the DNS level for all devices on your network.

## Architecture

The setup consists of two main components:

1. **Pi-hole** - A network-wide ad blocker that acts as a DNS sinkhole
2. **Unbound** - A validating, recursive, and caching DNS resolver

Pi-hole uses Unbound as its upstream DNS server, creating a private, secure, and ad-free DNS resolution system.

## Features

- Blocks ads, trackers, malware, and phishing domains
- DNS-level blocking (works for all devices on your network)
- Encrypted DNS-over-TLS for secure upstream queries
- Custom domain blocking lists
- Web interface for monitoring and management
- Local DNS resolution for your network

## Prerequisites

- Docker and Docker Compose
- Basic understanding of DNS concepts

## Quick Start

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd dns
   ```

2. Start the services:
   ```bash
   docker-compose up -d
   ```

3. Access the Pi-hole web interface:
   - Open `http://<your-server-ip>:8080` in your browser
   - Default password: `staple`

## Configuration

### Pi-hole

- Web interface: `http://localhost:8080`
- Password: `staple` (change this in [docker-compose.yml](docker-compose.yml))
please change the password in [docker-compose.yml](docker-compose.yml)
- Timezone: Europe/Kiev (change in [docker-compose.yml](docker-compose.yml))

### Unbound

- Configuration file: [unbound/unbound.conf](unbound/unbound.conf)
- Uses DNS-over-TLS for secure upstream queries to:
  - Cloudflare (1.1.1.1)
  - Google (8.8.8.8, 8.8.4.4)
  - Quad9 (9.9.9.9)

## Block Lists

The setup includes multiple block lists for comprehensive protection:

### Pi-hole Block Lists

Managed through [pihole/add_blocklists.sh](pihole/add_blocklists.sh):
- Hagezi Pro Plus
- Blocklist Project (ads, phishing, fraud, malware)
- Firebog lists
- AnudeepND adservers
- YoYo adservers
- FadeMind lists
- URLhaus

### Unbound Block Lists

Managed through [unbound/update_unbound_blocklist.sh](unbound/update_unbound_blocklist.sh):
- Same sources as Pi-hole for redundancy

## Usage

### Adding Custom Block Lists

To add custom block lists to Pi-hole:
1. Edit [pihole/add_blocklists.sh](pihole/add_blocklists.sh)
2. Add your list in the `BLOCKLISTS` array format: `"name|url"`
3. Run the script: `./pihole/add_blocklists.sh`

### Updating Block Lists

To update Pi-hole block lists:
```bash
docker-compose exec pihole pihole -g
```

To update Unbound block lists:
```bash
./unbound/update_unbound_blocklist.sh
```

### Updating Root Hints

To update Unbound root hints:
```bash
./unbound/update_unbound_roothints.sh
```

## Network Configuration

To use this DNS server on your network:
1. Configure your router's DHCP settings to use this server's IP as the DNS server
2. Or configure individual devices to use this server's IP as their DNS server

Pi-hole listens on port 53535 for DNS queries.

## Directory Structure

```
.
├── docker-compose.yml          # Main Docker Compose configuration
├── pihole/
│   ├── etc/                    # Pi-hole configuration and databases
│   │   ├── pihole.toml         # Pi-hole configuration file
│   │   └── dnsmasq.conf        # DNS configuration
│   └── add_blocklists.sh       # Script to add block lists to Pi-hole
└── unbound/
    ├── unbound.conf            # Unbound DNS resolver configuration
    ├── update_unbound_blocklist.sh  # Script to update Unbound block lists
    └── update_unbound_roothints.sh  # Script to update root hints
```

## Security

- Pi-hole and Unbound communicate internally via Docker network
- Unbound uses DNS-over-TLS for encrypted upstream queries
- Pi-hole web interface has basic authentication (change the default password)

## Troubleshooting

### Check service status
```bash
docker-compose ps
```

### View logs
```bash
docker-compose logs pihole
docker-compose logs unbound
```

### Test DNS resolution
```bash
dig @localhost -p 53535 example.com
```

## Maintenance

Regular maintenance tasks:
1. Update block lists weekly/monthly
2. Update root hints periodically
3. Monitor Pi-hole statistics through the web interface

## Contributing

Feel free to submit issues or pull requests to improve this setup.

## License

This project is provided as-is without any specific license. Use at your own risk.