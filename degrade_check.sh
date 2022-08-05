echo "
# --------------------------------------------------
#
# flutter clean and pub get
#
# --------------------------------------------------
"
flutter clean
flutter pub get


echo "
# --------------------------------------------------
#
# build_runner
#
# --------------------------------------------------
"
flutter pub run build_runner build --delete-conflicting-outputs


# --------------------------------------------------
#
# flutter test 
#
# --------------------------------------------------
# flutter test test/goldens_test test/widget_test test/unit_test

echo "
# --------------------------------------------------
#
# flutter unit test 
#
# --------------------------------------------------
"
flutter test test/unit_test



echo "
# --------------------------------------------------
#
# flutter widget test 
#
# --------------------------------------------------
"
flutter test test/widget_test



echo "
# --------------------------------------------------
#
# flutter goldens test 
#
# --------------------------------------------------
"
flutter test test/goldens_test 



echo "
# --------------------------------------------------
#
# flutter integration_test 
#
# --------------------------------------------------
"
echo flutter drive --driver=test_driver/integration_test.dart --target=integration_test/home_page_test.dart -d "iPhone 13 mini"



# --------------------------------------------------
#
# flutter pub deps
#
# --------------------------------------------------
# flutter pub outdated --color
# pkg="meta";
# flutter pub deps -s list | grep -E "^- |$pkg" | grep -v "\- $pkg ^" | grep -E "\- $pkg" -B 1

