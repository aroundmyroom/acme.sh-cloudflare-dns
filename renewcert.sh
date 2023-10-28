#!/bin/sh

# Set your Cloudflare API credentials
export CF_Zone_ID="id"
export CF_Token="token"

# Define the domain for which you want to renew the certificate
DOMAIN="domain.ltd.net"
SUBDOMAIN="*.domain.ltd.net"

# Specify the target directory for certificate files
CERT_DIR="/export/certificate"

# Check if the certificate directory exists
if [ -d "$CERT_DIR" ]; then
    echo "Certificate directory already exists. Renewing certificate..."
    # Force renewal with --force
    ./acme.sh --renew -d "$DOMAIN" --dns dns_cf --force
else
    echo "Certificate directory does not exist. Creating directory and issuing certificate..."
    # Create the certificate directory
    mkdir -p "$CERT_DIR"
    # Run acme.sh to issue the certificate
    ./acme.sh --issue -d "$DOMAIN" --dns dns_cf -d "$SUBDOMAIN" --force
fi

# Check if acme.sh was successful
if [ "$?" -eq 0 ]; then
    echo "Certificate issued/renewed successfully."

    # Determine the certificate directory path
    CERT_PATH="/root/.acme.sh/$DOMAIN"

    # Append "_ecc" to the domain to get the correct path
    ECC_DOMAIN="${DOMAIN}_ecc"
    ECC_CERT_PATH="/root/.acme.sh/$ECC_DOMAIN"

    # Copy the certificate files from the ECC directory to the target directory

    cd "$ECC_CERT_PATH"
    for file in *; do
    echo "First Move"

        mv "$file" "*.$file"
    done

    cp -r "$ECC_CERT_PATH/"* "$CERT_DIR/"


echo "now the files need to be renamed"

# Specify the directory where your files are located
directory="/root/.acme.sh/aroundtheworld.net_ecc"
echo "$directory"

# Loop through files with an asterisk (*) in the name in the specified directory
for file in "$directory"/*.*; do
    # Check if there are any matching files
    if [ -e "$file" ]; then
        # Extract the file name without the path
        file_name=$(basename "$file")

echo "$file_name"

        # Remove the asterisk from the filename
        # new_file_name="${file_name/\*./}"

        new_file_name=$(echo "$file_name" | sed 's/\*\.//')

echo "$new_file_name"
        # Rename the file without the asterisk
        mv "$file" "$directory/$new_file_name"

echo "$file and $directory/$new_filename"

        echo "Renamed $file to $new_file_name"
    else
        echo "No matching files found."
    fi
done

  # Copy the certificate files to the remote machine using SCP with password-based authentication

# Set the variables
USER="user"
PASSWORD="password"
LOCAL_FOLDER="/export/certificate/"
REMOTE_FOLDER="/export/certificate/"
REMOTE_MACHINE="[ipaddress]"

# Use rsync to copy data from the local folder to the remote folder
rsync -delete -rav -e "sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no" "$LOCAL_FOLDER" "$USER@$REMOTE_MACHINE:$REMOTE_FOLDER"


    echo "Certificate files copied to $REMOTE_IP:/export/certificate/"

else
    echo "Certificate issuance/renewal failed."
fi
