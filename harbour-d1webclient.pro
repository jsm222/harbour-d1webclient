# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-d1webclient

CONFIG += sailfishapp



SOURCES += src/harbour-d1webclient.cpp \
    src/webclient.cpp \
    src/settings.cpp \
    src/controllistmodel.cpp \
    src/webcontrol.cpp

OTHER_FILES += qml/harbour-d1webclient.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-d1webclient.spec \
    rpm/harbour-d1webclient.yaml \
    translations/*.ts \
    harbour-d1webclient.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-d1webclient-de.ts

HEADERS += \
    src/webclient.h \
    src/settings.h \
    src/controllistmodel.h \
    src/webcontrol.h

DISTFILES += \
    icons/108x108/harbour-d1webclient.png \
    icons/128x128/harbour-d1webclient.png \
    icons/256x256/harbour-d1webclient.png \
    icons/86x86/harbour-d1webclient.png \
    qml/cover/iot.svg \
    qml/pages/ThirdPage.qml \
    rpm/harbour-d1webclient.changes
