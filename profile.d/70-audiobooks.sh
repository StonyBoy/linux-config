# Steen Hegelund - 3-mar-2019
# Home stuff

function get_audiobooks()
{
    adb pull "/sdcard/Android/data/dk.ereolen/files/356yth7uj4567u34t734e56yuijt456y7uij3ret/fg8hj534t80g5h7v9085ut39-28ug-k32f94230g" ~/Downloads
}

function delete_audiobooks()
{
    adb shell "cd /sdcard/Android/data/dk.ereolen/files/356yth7uj4567u34t734e56yuijt456y7uij3ret/fg8hj534t80g5h7v9085ut39-28ug-k32f94230g && rm -rf *"
}

function start_ereolen()
{
    emulator @steen_ereolen
}

function list_androidsdk()
{
    sdkmanager --list --verbose
}

function update_androidsdk()
{
    sdkmanager platform-tools
    sdkmanager "system-images;android-28;google_apis;x86"
    sdkmanager "platforms;android-28"
}

