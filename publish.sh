#!/usr/bin/env bash

BUCKET=s3://datum.somos.world

echo "Building Sass Assets"
cd assets/sass && (npm run build)
cd ..

echo "Building JS Assets"
cd js && (npm run build)
cd ../..

echo "Building Elm Assets..."
./build.sh

echo "Publishing New Assets..."
aws s3 sync assets/images/ $BUCKET/images/ --profile tap-in
aws s3 cp assets/index.html $BUCKET --profile tap-in
aws s3 cp assets/elm.min.js $BUCKET --profile tap-in
aws s3 cp assets/css/ $BUCKET/css/ --recursive --profile tap-in
aws s3 cp assets/fonts/ $BUCKET/fonts/ --recursive --profile tap-in
aws s3 cp assets/js/bundle.js $BUCKET/js/ --profile tap-in

echo "Invalidating CloudFront Cache..."
aws cloudfront create-invalidation --distribution-id E7ZLZHFUERPJK --paths "/*" --profile tap-in
