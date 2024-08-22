## Set up

```
docker compose run --rm rails bundle install
```

コンテナをビルド
```
docker compose build --no-cache
```

コンテナを起動
```
docker compose up -d
```

railsコンテナに入る
```
docker compose exec rails /bin/bash
```

サーバーを起動
```
rails s -b '0.0.0.0'
```
