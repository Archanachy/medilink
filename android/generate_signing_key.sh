#!/bin/bash

# Android Production Signing Key Generation Script
# This script generates a keystore for signing Android release builds

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
KEYSTORE_PATH="$SCRIPT_DIR/medilink.keystore"
VALIDITY=10000

echo "======================================"
echo "MediLink Android Signing Key Generator"
echo "======================================"
echo ""

# Check if keystore already exists
if [ -f "$KEYSTORE_PATH" ]; then
    echo "⚠️  Keystore already exists at: $KEYSTORE_PATH"
    read -p "Do you want to regenerate it? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted. Using existing keystore."
        exit 0
    fi
fi

# Validate keytool availability
if ! command -v keytool &> /dev/null; then
    echo "❌ Error: keytool not found. Please ensure Java Development Kit (JDK) is installed."
    exit 1
fi

echo "Generating production signing key..."
echo ""
echo "Please enter the following information:"
echo ""

# Collect user information
read -p "First name (e.g., 'MediLink'): " first_name
read -p "Last name (e.g., 'Healthcare'): " last_name
read -p "Organization (e.g., 'Archana'): " organization
read -p "City: " city
read -p "State/Province: " state
read -p "Country Code (e.g., 'US'): " country

read -sp "Keystore password (min 6 chars): " keystore_password
echo
read -sp "Confirm keystore password: " keystore_password_confirm
echo

if [ "$keystore_password" != "$keystore_password_confirm" ]; then
    echo "❌ Keystore passwords do not match!"
    exit 1
fi

read -sp "Key password (min 6 chars): " key_password
echo
read -sp "Confirm key password: " key_password_confirm
echo

if [ "$key_password" != "$key_password_confirm" ]; then
    echo "❌ Key passwords do not match!"
    exit 1
fi

# Create the DN (Distinguished Name)
DN="CN=$first_name $last_name,OU=$organization,L=$city,ST=$state,C=$country"

echo ""
echo "Generating keystore with the following details:"
echo "  Keystore: $KEYSTORE_PATH"
echo "  Alias: medilink_key"
echo "  Validity: $VALIDITY days"
echo "  DN: $DN"
echo ""

# Generate the keystore
keytool -genkey -v \
    -keystore "$KEYSTORE_PATH" \
    -keyalg RSA \
    -keysize 2048 \
    -validity $VALIDITY \
    -alias "medilink_key" \
    -storepass "$keystore_password" \
    -keypass "$key_password" \
    -dname "$DN"

if [ $? -ne 0 ]; then
    echo "❌ Failed to generate keystore!"
    exit 1
fi

# Update key.properties file
echo ""
echo "Updating key.properties file..."

cat > "$SCRIPT_DIR/key.properties" << EOF
# Android Keystore Configuration
storeFile=medilink.keystore
storePassword=$keystore_password
keyAlias=medilink_key
keyPassword=$key_password
EOF

# Update permissions
chmod 600 "$KEYSTORE_PATH"
chmod 600 "$SCRIPT_DIR/key.properties"

echo ""
echo "✅ Keystore generation completed successfully!"
echo ""
echo "📁 Files created:"
echo "   - Keystore: $KEYSTORE_PATH"
echo "   - Config: $SCRIPT_DIR/key.properties"
echo ""
echo "🔐 Security reminder:"
echo "   1. Never commit key.properties or medilink.keystore to version control"
echo "   2. Keep key.properties in a secure location"
echo "   3. For CI/CD, use environment variables:"
echo "      - KEYSTORE_FILE=/path/to/medilink.keystore"
echo "      - KEYSTORE_PASSWORD=$keystore_password"
echo "      - KEYSTORE_ALIAS=medilink_key"
echo "      - KEY_PASSWORD=$key_password"
echo ""
echo "SHA-1 Fingerprint:"
keytool -list -v -keystore "$KEYSTORE_PATH" -storepass "$keystore_password"
