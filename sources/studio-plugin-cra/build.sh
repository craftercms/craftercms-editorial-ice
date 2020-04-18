PLUGINS_DIR=../../config/studio/plugins
TYPE_DIR=$PLUGINS_DIR/apps
TARGET_DIR=$TYPE_DIR/react-app

echo "=>"
echo "==> Beginning app build & deploy"

echo "==> Ensuring npm deps are up to date..."
yarn
echo ""

echo "==> Running React build scripts"
react-scripts build
echo ""

if [[ ! -d $TARGET_DIR ]]; then
  echo "==> Plugin directory does not exist. Creating \"$TARGET_DIR\"."
  mkdir -p "$TARGET_DIR"
else
  echo "==> Removing old build"
  # shellcheck disable=SC2115
  rm -rf $TARGET_DIR/*
fi

echo "==> Moving react build to target plugin directory"
mv ./build/* "$TARGET_DIR"

echo "==> Removing react build directory"
rm -rf ./build

echo "==> Adding stuff to git (so studio can see changes)"
git add "$TARGET_DIR"
echo ""

echo "==> Committing changes"
git commit "$TARGET_DIR" -m "create-react-app plugin build"
echo ""

echo ""
echo "All done. Arrivederci!️ 🙂"
echo "<="
