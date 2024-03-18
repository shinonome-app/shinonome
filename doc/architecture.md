# 開発者向け文書

## ShinonomeとKomadome

Komadomeはwww.aozora.gr.jpのHTMLを生成するためのStatic Site Generatorで、ShinonomeはCMS本体になっている。

KomadomeはViewComponentを使ってHTMLを生成しており、Shinonomeのプレビュー機能にはそのCompomentsをコピーしている。

またKomadomeはHTML生成用の元データをRailsのモデルとして利用しているため、Shinonomeのモデルをコピーしている。
Railsエンジンにして共有することも検討したが、無駄に複雑になりそうだったのであきらめた。

生成に必要なものはDBの情報だけであるため、理論的にはRailsでなくても生成は可能。
ただしShinonomeのプレビュー機能は必要になるため、そのための考慮は必要となる。

今のところは概ねapp/models直下はShinonomeがプライマリ、app/components/pages以下はKomadomeがプライマリの扱いにしている。

## ディレクトリ構成

### app/forms

いわゆるフォームオブジェクト用。
特に共通のスーパークラスは用意していない。必要に応じてActiveModel::*をincludeする。

### app/libs

ライブラリ用。root直下での`/lib`でも良かったが、`lib/tasks`等で使っており紛らわしいため別途ここに置くようにする。

#### `ActiveStorage::Service::FilenameBasedDiskService`

ストレージのファイルを直接いじる必要があるかも、という要求仕様により独自のストレージ構成に変更した
通常のDiskServiceとは異なり、keyではなくfilenameをベースに保存されるフォルダが決まるようになっている。
keyからファイル名を取得する必要があるため、ActiveStorage::Blobにアクセスしている。DBにアクセスできないと破綻するのに注意。

なおストレージはNFSで共有することが前提とされている。これでWebサーバの複数台構成に耐えられるようにする。
あまり同時アクセス等もないと思われるため。

### app/models

ふつうのmodelsだが、shinonome以外のモデルはkomadomeにコピーして使う。
しばらくは手動で同期する（しくみを使っても面倒になるため）。

### app/services

いわゆるサービスクラス。

`【名詞】_【動詞】er.rb`的な命名を目指す。
使うときには`Foo.new.bar`というようにnewを経由して実行する。
外部から呼び出すためのクラスメソッドは定義しない（別になくても困らないため）。また呼び出し用の統一メソッド(callやexec等)は使わなず、冗長でも分かりやすいメソッド名にする。

## DB、テーブル関連

### secrets

`*_secrets`というテーブルがいくつかある。
これは公開されない（公開したくない）情報を記述するためのテーブルになっている。
具体的にはkomadomeには渡さない。

`foo`と`foo_secrets`は1対1対応(Railsなのでhas_one)になっている。
基本的にはoptionalにはしないが、生成タイミングもあるので必須属性はつけていない。

`*_secrets`側の属性は基本的にはNULL禁止にしており、空文字列が入る場合もある。

モデルとしては、`Shinonome::Foo`といったようにShinonomeモジュール以下に置くようにしている。
komadomeには`Shinonome::*`を渡さないので、それでアクセスできなくなるはず、という仕組みにしている。

そのため`has_one`では`class_name`を指定する必要がある。`class_name`は文字列で指定する(komadomeに渡したときに破綻させないため)

### seeds

Rails標準の`rails db:seed`でシードをインポートする。

基本はマスター的なテーブルの更新を行うが、開発環境と、環境変数`USE_ALL_SEEDS`を有効にしている場合はダミーデータも生成する

マスターデータについてはRailsのUPSERT機能を使っているため、リエントラントになるよう注意する。また不要になっても削除はされないため、その場合は手動で削除するか、テーブルを作り直す必要がある。

## ツール

#### `Shinonome::DbMigrator`

旧システムのDBをダンプしたCSVからインポートする際に使用する。移行が落ち着いた段階で削除する予定。

#### `Shinonome::FileMigrator`

旧システムのファイルをインポートする際に使用する。移行が落ち着いた段階で削除する予定。

