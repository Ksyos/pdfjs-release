#!/bin/bash

RELEASE=$(curl -s https://api.github.com/repos/mozilla/pdf.js/releases/latest)

RELEASE_VERSION=$(echo "$RELEASE" | jq -r .name | cut -c 2-)

if [[ $(echo "$RELEASE" | jq -r '.assets[0].content_type') != *zip* ]]; then
    echo "Unexpected content type for latest release ($RELEASE_VERSION)" >&2
    exit 1
fi

RELEASE_ASSET_URL=$(echo "$RELEASE" | jq -r '.assets[0].browser_download_url')

curl -L $RELEASE_ASSET_URL -o latest.zip
rm -rf build web LICENSE
unzip latest.zip
rm latest.zip

sed -i "/version/s/: .*/: \"$RELEASE_VERSION\",/" package.json

echo
echo "Now check that things are okay and run: npm publish"
