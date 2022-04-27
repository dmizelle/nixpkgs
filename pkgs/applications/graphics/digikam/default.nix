{ mkDerivation, lib, fetchurl, fetchpatch, cmake, doxygen, extra-cmake-modules, wrapGAppsHook

# For `digitaglinktree`
, perl, sqlite

, qtbase
, qtxmlpatterns
, qtsvg
, qtwebengine

, akonadi-contacts
, kcalendarcore
, kconfigwidgets
, kcoreaddons
, kdoctools
, kfilemetadata
, knotifications
, knotifyconfig
, ktextwidgets
, kwidgetsaddons
, kxmlgui

, bison
, boost
, eigen
, exiv2
, ffmpeg
, flex
, graphviz
, imagemagick
, lcms2
, lensfun
, libgphoto2
, libkipi
, libksane
, liblqr1
, libqtav
, libusb1
, marble
, libGL
, libGLU
, opencv
, pcre
, threadweaver
, x265
, jasper

# For panorama and focus stacking
, enblend-enfuse
, hugin
, gnumake

, breeze-icons
, oxygen
}:

mkDerivation rec {
  pname   = "digikam";
  version = "7.6.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/digiKam-${version}.tar.xz";
    sha256 = "sha256-2OHucyHT/DE5FvUVdW4wKaxBh9xFO2kzhI1N5TFLZkE=";
  };

  patches = [
    (fetchpatch {
      name = "akonadi-22.04.patch";
      url = "https://github.com/archlinux/svntogit-packages/raw/1b3c76a4482055524120f598325d90545ff9c020/trunk/akonadi-22.04.patch";
      sha256 = "sha256-ittgkl2t/nAD0ci2fNYoAd4E2M6Gg0vqqjxqZugBuko=";
    })
  ];

  nativeBuildInputs = [ cmake doxygen extra-cmake-modules kdoctools wrapGAppsHook ];

  buildInputs = [
    bison
    boost
    eigen
    exiv2
    ffmpeg
    flex
    graphviz
    imagemagick
    lcms2
    lensfun
    libgphoto2
    libkipi
    libksane
    liblqr1
    libqtav
    libusb1
    libGL
    libGLU
    opencv
    pcre
    x265
    jasper

    qtbase
    qtxmlpatterns
    qtsvg
    qtwebengine

    akonadi-contacts
    kcalendarcore
    kconfigwidgets
    kcoreaddons
    kfilemetadata
    knotifications
    knotifyconfig
    ktextwidgets
    kwidgetsaddons
    kxmlgui

    breeze-icons
    marble
    oxygen
    threadweaver
  ];

  cmakeFlags = [
    "-DENABLE_MYSQLSUPPORT=1"
    "-DENABLE_INTERNALMYSQL=1"
    "-DENABLE_MEDIAPLAYER=1"
    "-DENABLE_QWEBENGINE=on"
    "-DENABLE_APPSTYLES=on"
    "-DCMAKE_CXX_FLAGS=-I${libksane}/include/KF5" # fix `#include <ksane_version.h>`
  ];

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
    qtWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ gnumake hugin enblend-enfuse ]})
    qtWrapperArgs+=(--suffix DK_PLUGIN_PATH : ${placeholder "out"}/${qtbase.qtPluginPrefix}/${pname})
    substituteInPlace $out/bin/digitaglinktree \
      --replace "/usr/bin/perl" "${perl}/bin/perl" \
      --replace "/usr/bin/sqlite3" "${sqlite}/bin/sqlite3"
  '';

  meta = with lib; {
    description = "Photo Management Program";
    license = licenses.gpl2;
    homepage = "https://www.digikam.org";
    platforms = platforms.linux;
  };
}
