#! /bin/sh
# exit this script if any commmand fails
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Get Unity version for $UNITY_VERSION"
url=$(python $DIR/unitydownloadurl.py -v $UNITY_VERSION --os mac)
realVersion=${url/*-/}
realVersion=${realVersion/.pkg*/}
realVersion=${realVersion/.dmg*/}
echo "Got Unity version:$realVersion"
echo "Got Unity url:$url"

dmg=${url/*.dmg*/}
pkgname="Unity.pkg"
echo "Downloading from $url: "
if [ -z $dmg ]; then
    curl -o Unity.dmg "$url"
    sudo hdiutil attach Unity.dmg
    ls /Volumes/Unity\ Download\ Assistant
    pkgname="/Volumes/Unity Download Assistant/Unity.pkg"
else
    curl -o Unity.pkg "$url"
fi

echo 'Installing Unity.pkg'
sudo installer -dumplog -package $pkgname -target /

echo 'replace unity licent'
echo 'sudo cp -f ./Unity_lic.ulf /Library/xApplication Support/Unity/Unity_lic.ulf'
sudo cp -f "./Scripts/Unity_lic.ulf" "/Library/Application Support/Unity/Unity_lic.ulf"
echo "$? __ $0"
echo diff "./Scripts/Unity_lic.ulf" "/Library/Application Support/Unity/Unity_lic.ulf"
