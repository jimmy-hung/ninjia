source .env
export KEYCHAIN_PASSWORD=12345
export MATCH_PASSWORD=Info@declo.com.tw123
GIT_BRANCH=${APPFILE_APPLE_ID%@${APPFILE_APPLE_ID##*@}}

rm -f fastlane/Appfile
echo "app_identifier \"$APPFILE_APP_IDENTIFIER\" # The bundle identifier of your app" >> fastlane/Appfile
echo "apple_id \"$APPFILE_APPLE_ID\" # Your Apple email address" >> fastlane/Appfile
echo "" >> fastlane/Appfile
echo "# team_id \"\" # Developer Portal Team ID" >> fastlane/Appfile

rm -f fastlane/Matchfile
echo "git_url \"https://bitbucket.org/larvata-tw/larvata-ios-certificates.git\"" >> fastlane/Matchfile
echo "git_branch \"$GIT_BRANCH\"" >> fastlane/Matchfile
echo "" >> fastlane/Matchfile
echo "type \"development\" # The default type, can be: appstore, adhoc, enterprise or development" >> fastlane/Matchfile

security create-keychain -p $KEYCHAIN_PASSWORD ios-build.keychain
security list-keychain -s ios-build.keychain login.keychain
security unlock-keychain -p $KEYCHAIN_PASSWORD ~/Library/Keychains/ios-build.keychain

bundle exec fastlane ios bao_init

security delete-keychain ios-build.keychain
rm -f ~/Library/MobileDevice/Provisioning\ Profiles/*
