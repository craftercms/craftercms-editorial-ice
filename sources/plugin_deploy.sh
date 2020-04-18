#!/usr/bin/env bash

printRelative() {
  VALUE=$1
  REPLACE="{site}"
  echo "${VALUE//$SANDBOX_DIR/$REPLACE}"
}

cd "$(dirname "$0")" || {
  echo "Unable to cd into current directory."
  exit 1
}

readonly SOURCES_DIR=$(pwd)
cd ../ || {
  echo "Unable to cd into sandbox directory."
  exit 1
}

readonly SANDBOX_DIR=$(pwd)
cd $SANDBOX_DIR/sources || {
  echo "Unable to cd into sources directory."
  exit 1
}

DEFAULT_TYPE=apps
TYPE_ARG=
NAME_ARG=
BLANK="{site}"

PLUGINS_DIR=$SANDBOX_DIR/config/studio/plugins
TYPE_DIR=$PLUGINS_DIR/$DEFAULT_TYPE
TARGET_DIR=
BUILD_TARGET=
BUILD_TARGET_DIR=

for ARG in "$@"; do
  case "$ARG" in
  --category=*)
    TYPE_ARG=${ARG#--category=}
    TYPE_DIR=$PLUGINS_DIR/$TYPE_ARG
    ;;
  --name=*)
    NAME_ARG=${ARG#--name=}
    TARGET_DIR=$TYPE_DIR/$NAME_ARG
    ;;
  --target=*)
    BUILD_TARGET=${ARG#--target=}
    ;;
  *)
    echo "Unknown option $ARG."
    exit 1
    ;;
  esac
done

echo "============>"

if [ -z "$BUILD_TARGET" ]; then
  echo "[ERROR] Oops. The build target is required but wasn't supplied. Please call script with \`--target={pluginSourceDirName}\`."
  echo "<============"
  exit 1
fi

BUILD_TARGET_DIR=$SOURCES_DIR/$BUILD_TARGET

if [ -z "$NAME_ARG" ]; then
  TARGET_DIR=$TYPE_DIR/$BUILD_TARGET
fi

if [ -z "$TYPE_ARG" ]; then
  echo "[INFO] Category not supplied, assuming \`apps\` as the category. You may call this script with \`--category={categoryName}\` to modify."
fi

if [ -z "$NAME_ARG" ]; then
  echo "[INFO] Plugin name wasn't supplied. Using \`$BUILD_TARGET\` as the name. You may call this script with \`--name={pluginName}\` to modify."
fi

printRelative "[INFO] Your plugin will be at deployed at \`$TARGET_DIR\`."

echo "• Beginning app build & deploy"

if [[ ! -d $TARGET_DIR ]]; then
  printRelative "• Plugin directory does not exist. Creating \"$TARGET_DIR\"."
  mkdir -p "$TARGET_DIR"
else
  echo "• Removing old build"
  # shellcheck disable=SC2115
  rm -rf "$TARGET_DIR/*"
fi

cd "$BUILD_TARGET" || {
  echo "[ERROR] Oops. Build target directory does not exist. Bye."
  echo "<============"
  exit 1
}

if [[ ! -f package.json ]]; then
  echo "• No \`package.json\` found. Assuming the source is same as build."
  printRelative "• Copying $BUILD_TARGET_DIR/* into $TARGET_DIR."
  cp -r "$BUILD_TARGET_DIR/." "$TARGET_DIR" || {
    echo "[ERROR] Copy failed"
    exit 0
  }
  if [[ -f "$TARGET_DIR/build.sh" ]]; then
    rm -rf "$TARGET_DIR/build.sh"
  fi
else

  PKG_MAN=""
  if command -v yarn >/dev/null 2>&1; then
    echo "• Yarn found on your system. Using yarn as package manager."
    PKG_MAN="yarn"
  elif command -v npm >/dev/null 2>&1; then
    echo "• Yarn not found on your system. Found npm; using as package manager."
    PKG_MAN="npm"
  else
    echo "• Oops. No yarn or npm in your system. Don't know how to build this. Bye."
    exit 1
  fi

  echo "• Ensuring npm deps are up to date..."
  if [ "$PKG_MAN" == "yarn" ]; then
    yarn
  else
    npm install
  fi
  echo ""

  echo "• Running package.json build script"
  if [ "$PKG_MAN" == "yarn" ]; then
    yarn build
  else
    npm run build
  fi
  echo ""

  if [[ ! -d "$BUILD_TARGET_DIR/build" ]]; then
    echo "[ERROR] Oops. No build folder found. Make sure your $PKG_MAN build creates a \`build\` directory with the full plugin build to deploy. Bye."
    exit 1
  fi

  printRelative "• Copying $BUILD_TARGET_DIR/build/* to $TARGET_DIR"
  cp -r "$BUILD_TARGET_DIR/build/." "$TARGET_DIR" || {
    echo "[ERROR] Copy operation failed"
    exit 0
  }

  echo "• Removing build directory"
  rm -rf ./build

fi

echo "• Adding stuff to git (so studio can see changes)"
git add "$TARGET_DIR"

echo "• Committing changes"
git commit "$TARGET_DIR" -m "Plugin build"
echo ""

echo ""
echo "All done. Arrivederci!️ 🙂"
echo "<============"
echo ""
