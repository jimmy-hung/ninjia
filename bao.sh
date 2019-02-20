
# source命令通常用于重新执行刚修改的初始化文件（.env），使之立即生效
source .env
export KEYCHAIN_PASSWORD=12345
export MATCH_PASSWORD=psss65505
# ${}：变量的正规表达式, $value：取用變數
GIT_BRANCH=${APPFILE_APPLE_ID%@${APPFILE_APPLE_ID##*@}}

# cmd >> file：把cmd命令的输出重定向到文件file中，如果file已经存在，则把信息加在原有文件後面。 
rm -f fastlane/Appfile
echo "app_identifier \"$APPFILE_APP_IDENTIFIER\" # The bundle identifier of your app" >> fastlane/Appfile
echo "apple_id \"$APPFILE_APPLE_ID\" # Your Apple email address" >> fastlane/Appfile
echo "" >> fastlane/Appfile
echo "# team_id \"\" # Developer Portal Team ID" >> fastlane/Appfile

rm -f fastlane/Matchfile
echo "git_url \"https://bitbucket.org/taoyuanjimmy/ios-certificates.git\"" >> fastlane/Matchfile
echo "git_branch \"$GIT_BRANCH\"" >> fastlane/Matchfile
echo "" >> fastlane/Matchfile
echo "type \"development\" # The default type, can be: appstore, adhoc, enterprise or development" >> fastlane/Matchfile

#create-keychain    创建钥匙串并加入搜索列表
#list-keychains   显示或设置钥匙串搜索列表
#unlock-keychain    解锁制定的钥匙串
security create-keychain -p $KEYCHAIN_PASSWORD ios-build.keychain
security list-keychain -s ios-build.keychain login.keychain
security unlock-keychain -p $KEYCHAIN_PASSWORD ~/Library/Keychains/ios-build.keychain

bundle exec fastlane ios bao_init

security delete-keychain ios-build.keychain
rm -f ~/Library/MobileDevice/Provisioning\ Profiles/*
