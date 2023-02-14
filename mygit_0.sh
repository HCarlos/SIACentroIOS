#!/usr/bin/env bash

echo "# SIACentroIOS" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/HCarlos/SIACentroIOS.git
git push -u origin main

exit


