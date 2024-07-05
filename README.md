# Bug Bounty Hunting Script

This bash script automates the process of subdomain enumeration for a given domain. It performs DNS enumeration, web scraping, and checks certificate transparency logs to discover subdomains, and then verifies and resolves them.

## Features

- **Tool Check**: Verifies that necessary tools (`host`, `dig`, `curl`, `jq`) are installed.
- **DNS Enumeration**: Uses `dig` to enumerate DNS records (A, AAAA, CNAME, MX, NS).
- **Web Scraping**: Scrapes `crt.sh` and Google for subdomains.
- **Certificate Transparency Logs**: Fetches subdomains from certificate transparency logs.
- **Subdomain Resolution**: Verifies and resolves discovered subdomains.

## Usage

1. Clone the repository:
    ```sh
    git clone https://github.com/yashwankhede/SubHuntMaster.git
    cd SubHuntMaster
    ```

2. Make the script executable:
    ```sh
    chmod +x SubHuntMaster.sh
    ```

3. Run the script:
    ```sh
    ./SubHuntMaster.sh <domain>
    ```

    Replace `<domain>` with the target domain name.

## Example

```sh
./SubHuntMaster.sh example.com

## Requirements

`host`
`dig`
`curl`
`jq`

## Contributing

- **Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

- **This project is licensed under the MIT License - see the LICENSE file for details.
