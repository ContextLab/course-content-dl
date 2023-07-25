#!/bin/bash

cd ../

export BRANCH='main'
wget https://github.com/NeuromatchAcademy/nmaci/archive/refs/heads/$BRANCH.tar.gz
tar -xzf $BRANCH.tar.gz
pip install --upgrade pip
pip install -r nmaci-$BRANCH/requirements.txt
mv nmaci-$BRANCH/scripts/ ci/
rm -r nmaci-$BRANCH
rm -r $BRANCH.tar.gz

pip install -r requirements.txt
pip install jupyter-book==0.10.2 ghp-import
pip install jupyter_client==7.3.5  # downgrade jupyter-client to fix hangs

wget https://github.com/NeuromatchAcademy/precourse/archive/refs/heads/$BRANCH.tar.gz
tar -xzf $BRANCH.tar.gz
mv precourse-$BRANCH/prereqs/ prereqs/
rm -r precourse-$BRANCH
rm -r $BRANCH.tar.gz

python ci/scripts/generate_book_dl.py student
ln -s ../tutorials book/tutorials
ln -s ../projects book/projects
ln -s ../prereqs book/prereqs
jupyter-book build book
python ci/scripts/parse_html_for_errors.py student

ghp-import -n -c "contextlab.github.io" -m "Update course book" book/_build/html
git checkout -f gh-pages
git push origin gh-pages

git checkout main

cd chatify