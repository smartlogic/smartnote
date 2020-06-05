#/bin/bash

sha=$(git rev-parse HEAD)

docker build -t oestrich/smart_note:${sha} .
docker push oestrich/smart_note:${sha}
cd kubernetes && helm upgrade production smartnote --set image.tag=${sha}
