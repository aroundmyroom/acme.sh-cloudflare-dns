# acme.sh-cloudflare-dns
Acme.sh renewal script on my proxmox cluster with cloudflare API DNS
with this a acme_challenge is auto-added to your DNS so that you do not need open ports or add it yourself.
if you are not sure if cloudflare and acme.sh working fine, its hard to debug.

I first added the Acme feature to my Proxmox installation and after that was working on the host via the frontend I was confident enough to use it in my shell.

I had acme installed on one of my proxmox host (I have a cluster of 2 machines)
my domain is hosted at cloudflare. I created an token and got the ID for my account

Acme is installed in /root/.acme.sh/
also the acme.sh script is in the folder /root/acme.sh (no typwriting error)
This script is in this folder as well next to the acme.sh file (can you follow). ;)

Btw before I used this script I made sure that Acme could renew my certificate
ie I was sure that acme was working as in the past I was able to create a wildcard certificate with a DNS challenge function but that took too much effort
all the time.

in Shell I wrote:

export CF_Zone_ID="xxxxx"

export CF_Token="xxxxxx"

and than started the new start line

./acme.sh --issue -d domain.ltd.net --dns dns_cf -d *.domain.ltd.net

After this was working I created the script to automate

What does this script

I named the script 'renewscript.sh' 
start the ./renewscript.sh checking the certificate in /root/.acme.sh/domain.ltd.net_ecc
during test I used a --force to keep renewing the certificate to find mistakes in this script

as my system used a *.domain.ltd.net I had to rename the certificates and copy it in /export/certificate.
/export/certificate is configured in lxc as mp0 so that it is a 'virtual folder' making it possible
that a LXC can get the certficate from the host

the rename to *.domain.ltd.net is not wanted by acme.sh when renewing so after the copy I had to revert that
so that a new certificate can be made. the next time.

As I have a 2nd machine an rsync session is set up to copy the data to the next machine.

btw a lot of this script was generated by chatgpt ;_) I only added some vanilla to change it to my needs and to instruct chatgpt to
change certain parts as it did not do what I wanted. Ie. I was unable to use a simple rename but had to use SED where in a
2nd script I had to use to fix mistakes in a folder where it was no issue to use the first generated proposal.
