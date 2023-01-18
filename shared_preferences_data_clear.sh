# データ消去対象のアプリを指定
bundleId="com.shintaisousa.stackremote"

echo "
# --------------------------------------------------
#
# shared preferences data clear 
# Android Emurator
#
# --------------------------------------------------
"

# データ消去対象アプリの存在を確認
packageName=$(echo 'pm list package' | adb shell | grep $bundleId)
appName=$(echo $packageName | sed -e 's/package://g')
echo "data clear target appName : $appName"

# 対象アプリのデータ消去
echo "pm clear $appName" | adb shell

echo "
# --------------------------------------------------
#
# shared preferences data clear 
# iOS Simulator
#
# --------------------------------------------------
"

# データ削除対象デバイスのリスト作成
# xcrun simctl list | grep Booted | sed -e 's/.*generation) (//g' | sed -e 's/).*//g'
deviceList=$(flutter devices | grep ios | awk -F'•' '{print $2}' | sed -e 's/ //g')
echo "delete target device list"
echo "$deviceList"

# もしデバイスのリストが0件の場合、終了
if [ -z "$deviceList" ]; then echo "    no device.\n    done.\n"; exit; fi

# 各デバイス毎に、アプリをアンインストール
echo "$deviceList" | while read targetDevice; do 
    echo "      --------------------------------------------------"
    echo "      targetDevice: $targetDevice" 

    echo "      delete app before"
    xcrun simctl listapps $targetDevice | grep $bundleId

    echo "      delete app"
    xcrun simctl uninstall $targetDevice $bundleId 

    echo "      delete app after"
    xcrun simctl listapps $targetDevice | grep $bundleId
done

