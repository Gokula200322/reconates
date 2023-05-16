import argparse
import requests

DEFAULT_WORDLISTS = ["/Users/gokul.s/Documents/tool/modules/tool/wordlist/subdomains-top1million-110000.txt"]

def main(target_domain, wordlists):
    subdomains = enumerate_subdomains(wordlists, target_domain)
    resolved_subdomains = resolve_subdomains(subdomains)
    report_subdomains(resolved_subdomains)

def enumerate_subdomains(wordlists, target_domain):
    subdomains = []
    for wordlist in wordlists:
        with open(wordlist, 'r') as f:
            for line in f:
                subdomain = line.strip()
                if subdomain:
                    url = f'http://{subdomain}.{target_domain}'
                    try:
                        requests.get(url)
                        subdomains.append(subdomain)
                    except:
                        pass
    return subdomains

def resolve_subdomains(subdomains):
    resolved_subdomains = {}
    for subdomain in subdomains:
        try:
            ip_address = socket.gethostbyname(subdomain)
            resolved_subdomains[subdomain] = ip_address
        except:
            pass
    return resolved_subdomains

def report_subdomains(resolved_subdomains):
    for subdomain, ip_address in resolved_subdomains.items():
        print(f'{subdomain}: {ip_address}')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Find subdomains')
    parser.add_argument('target_domain', help='The target domain to search')
    parser.add_argument('--wordlists', '-w', nargs='*', help='The path to one or more wordlists of subdomains to try')
    args = parser.parse_args()

    if args.wordlists:
        wordlists = args.wordlists
    else:
        wordlists = DEFAULT_WORDLISTS

    main(args.target_domain, wordlists)