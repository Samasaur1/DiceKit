set -o errexit

rm -rf docs
swift package generate-xcodeproj
jazzy
cd docs
git init
git config --global user.name "Documentation Bot"
git config --global user.email "docbot@travis-ci.com"
git add .
git commit -m "Update docs"
git push "https://${GH_TOKEN}@$github.com/Samasaur1/DiceKit.git" gh-pages >/dev/null 2>&1
