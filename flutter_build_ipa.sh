# -------------------------------------------------- 
# 
# create app icon
# 
# -------------------------------------------------- 
 flutter pub run flutter_launcher_icons -f flutter_launcher_icons.yaml

# -------------------------------------------------- 
# 
# flutter buiid ipa
# 
# -------------------------------------------------- 
flutter build ipa --release --export-options-plist=ExportOptions.plist
