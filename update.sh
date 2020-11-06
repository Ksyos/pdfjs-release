#!/bin/bash

RELEASE=$(curl -s https://api.github.com/repos/mozilla/pdf.js/releases/latest)

RELEASE_VERSION=$(echo "$RELEASE" | jq -r .name | cut -c 2-)

ES5_RELEASE_VERSION=$(cat package.json | jq  '.config.es5Version' | xargs)

if [[ $(echo "$RELEASE" | jq -r '.assets | length') < 1 ]]; then
    echo "Unexpected number of assets for latest release ($RELEASE_VERSION)" >&2
    exit 1
fi

if [[ $(echo "$RELEASE" | jq -r '.assets[1].content_type') != *zip* ]]; then
    echo "Unexpected content type for latest release ($RELEASE_VERSION)" >&2
    exit 1
fi

if [[ $(echo "$RELEASE" | jq -r '.assets[1].name') != *es5* ]]; then
    echo "Unexpected asset name for latest release ($RELEASE_VERSION)" >&2
    exit 1
fi

if [[ $ES5_RELEASE_VERSION != *es5* ]]; then
      FINAL_RELEASE_VERSION=$RELEASE_VERSION
else
      FINAL_RELEASE_VERSION=$ES5_RELEASE_VERSION
fi

RELEASE_ASSET_URL=$(echo "$RELEASE" | jq -r '.assets[1].browser_download_url')

curl -L $RELEASE_ASSET_URL -o latest.zip
rm -rf build web LICENSE
unzip latest.zip
rm latest.zip

sed -i "/version/s/: .*/: \"$FINAL_RELEASE_VERSION\",/" package.json

echo
echo "Now check that things are okay and run: npm publish"
