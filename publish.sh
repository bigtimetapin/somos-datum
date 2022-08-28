#!/usr/bin/env bash

BUCKET=s3://datum.somos.world

echo "Building Elm Assets..."
./build.sh

echo "Building Sass Assets"
cd web/sass && (npm run build)
cd ..

echo "Building JS Assets"
cd js && (npm run build)
cd ../..

echo "Publishing New Assets..."
aws s3 sync web/images/ $BUCKET/images/ --profile tap-in
aws s3 cp web/index.html $BUCKET --profile tap-in
aws s3 cp web/elm.min.js $BUCKET --profile tap-in
aws s3 cp web/css/ $BUCKET/css/ --recursive --profile tap-in
aws s3 cp web/fonts/ $BUCKET/fonts/ --recursive --profile tap-in
aws s3 cp web/js/bundle.js $BUCKET/js/ --profile tap-in

echo "Invalidating CloudFront Cache..."
aws cloudfront create-invalidation --distribution-id E3LZQABNPVM9O1 --paths "/*" --profile tap-in
