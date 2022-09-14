# nuxt-spa-terraform

## Build Setup

```bash
# install dependencies
$ yarn install

# serve with hot reload at localhost:3000
$ yarn dev

# build for production and launch server
$ yarn build
$ yarn start

# generate static project
$ yarn generate
```

For detailed explanation on how things work, check out the [documentation](https://nuxtjs.org).

## Deploy

```sh
$ yarn install
$ yarn run build
# s3 に dist/ を同期
$ aws s3 sync dist/ s3://${DEPLOY_BUCKET} --delete
# cloudfrontのキャッシュ全て（--paths "/*"） を削除
$ aws cloudfront create-invalidation --distribution-id ${DISTRIBUTION_ID} --paths "/*" --region ap-northeast-1
```
