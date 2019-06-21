# やったことリスト
isucon に向けてやったことをまとめます．だいたい issue を立てて，それへのリンクを貼っていく感じで．
* [first issue](https://github.com/OnizukaLab/isucon-study/issues/1)
* day0501: やることの洗い出し
  * [便利すぎる reservations テーブル](https://github.com/OnizukaLab/isucon-study/issues/8)
  * [sheet テーブルの過剰な呼び出し](https://github.com/OnizukaLab/isucon-study/issues/9)
* day0510 [PR](https://github.com/OnizukaLab/isucon8-qualify/pull/3)
  * sheet テーブルの情報をグローバル変数として保持
  （[sheet テーブルの過剰な呼び出し](https://github.com/OnizukaLab/isucon-study/issues/9) 対策）
  * get_event の for ループ内の SQL クエリをいい感じに消した
* day0531 sqlite 化した
  * [ブランチ１](https://github.com/OnizukaLab/isucon-study/tree/mysql-to-sqlite)
  * [ブランチ２](https://github.com/OnizukaLab/isucon8-qualify/tree/mysql-to-sqlite)
  * [結果](https://bigdata-lab-team.slack.com/archives/CDD0D37GR/p1559323466002100) 遅くなった．
* day0622 MySQL に戻して，onmemory にした
  * [ブランチ１](https://github.com/OnizukaLab/isucon8-qualify/tree/onmemory)
  * [ブランチ２](https://github.com/OnizukaLab/isucon8-qualify/tree/onmemory_tune_sql)
  * 結果：13240
  * 次やること
    * ログを見直して，ダメなことを浮き彫りにする
    * 使用を見直す

## 第8回ISUCON予選
URL: https://github.com/isucon/isucon8-qualify
### とりあえず回す
#### basic/Dockerfile をビルド
```bash
docker build -t isucon8 .
```
#### ウェブアプリ起動
```bash
cd path/to/isucon8-qualify
docker run -p 8080:8080 -it --name app -v `pwd`:/root/isucon8-qualify isucon8 bash run_app.sh
```
#### ベンチマーク実行
初回だけ実行
```bash
docker run -p 8080:8080 -it --name app -v `pwd`:/root/isucon8-qualify isucon8 /bin/bash
cd ../../bench
make deps
make
```

```bash
docker exec -it app /bin/bash
cd ../../bench
./bin/bench -remotes=127.0.0.1:8080 -output result.json
jq . < result.json
```

#### FlameGraph 描画
```bash
docker exec -it app /bin/bash
ps aux | grep python  # app.py の pid を確認
py-spy --flame profile.svg -d 60 -r 100 -p XXXX  # 60 秒間，# 100回/秒 の頻度でサンプリング
```
これが回っている間にベンチマーク実行を行う．
得られた profile.svg をブラウザで開くと[ここにあるような](http://www.brendangregg.com/FlameGraphs/cpuflamegraphs.html)グラフが見れる．

#### 環境構築 issue
* [DB初期化のために MySQL コンテナを切り離す](https://github.com/OnizukaLab/isucon-study/issues/2) 担当者：涌田
* [ホストを 0.0.0.0 にしているのがダサい](https://github.com/OnizukaLab/isucon-study/issues/5) 担当者：瓦