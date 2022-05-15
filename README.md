# FunCooApp - 毎日の料理を楽しく -

![fun_coo_app_top](https://user-images.githubusercontent.com/96477692/168478457-18f3700f-29f4-4d1b-a5db-7f7b04cb53db.png)

### アプリ URL: https://fun-coo-app.com

Qiita マイページ(Qiita 記事 12 件投稿)： https://qiita.com/iloveomelette

Qiita アプリ開発紹介記事(開発過程で意識・苦労した点、開発をしてみての感想などを記載しています！)：
https://qiita.com/iloveomelette/items/47f4e13b49cdd6a1a090

学習用 Twitter(学習継続 130 日[執筆時点])： https://twitter.com/icanenrichlife7

## どんなアプリ？

**面倒な献立作りから解放し、レベルを上げて料理を楽しむレコメンド献立アプリ**
**アプリ名は「Fun Cooking Application(料理を楽しむアプリ)」** の各頭 3 文字を取ったものです！

## 何ができるの？

料理に精通した方々が想いを込めて考案したレシピを**あなたの好みに合わせておすすめします。**
そのレシピに「作ってみた！」ボタンを押すことでレベルが上がっていき **「達成感」を味わうことができます。**

＊投稿者は個人農家の方や個人飲食店を経営している方など料理に精通した方々であり、
そのレシピを一般利用の方々に提供し、個人農家の方々と一般利用の方々を繋げることができます。

## 開発背景

私は現在実家に住まわせていただいております。
そんな我が家では、以下のような会話が毎日繰り返されていました。

母 「今日の夕ご飯は何にしようか？」

私 「ん〜、何がいいかな〜。なんでもいいよ！」

> 心の声： どうしよう...何を食べたい気分なのか、がない！

母 「なんでもいいじゃ分からないでしょ！献立を毎日考えたり料理をするのってすごい面倒だよね。」

私 「うん...」

聞く側も「なんでもいい」と言われ **自分で考えて作らなければならない面倒な気持ち** を抱え、聞かれた側も答えられず、**申し訳なさなど** を抱える。

**そんなマイナスしか生まない会話を解消したい** という想いから当アプリが生まれました。

すでにレシピアプリは世に出回っています。
しかし、**その多くは面倒さを省くだけで、料理を楽しくする視点は抜けていると思います。**
これでは、献立や料理に関する**プラスの会話は生まれません。**

では、どうしたら料理が楽しくなるのか考えました。それは **「達成感」** だと思います。
「こんだけ頑張ったんだ」という気持ちが湧くと「もっと頑張ろう」と思えるからです。
それを実現するのが当アプリです！

＊補足
レシピの質を担保するため、投稿者は食に精通した個人農家、個人飲食店経営の方々を想定しています。
ユーザの属性を「法人」と「一般利用」に分けて「法人」のみが投稿をできるように実装しています。

## 使用技術

### フロントエンド

- HTML / CSS / Sass / Tailwind / Javascript

### バックエンド

- Ruby 3.1.0
- Ruby on Rails 6.1.5

### DB

- MariaDB 10.6.7

### インフラ

- AWS(VPC / EC2 / RDS / ACM / ALB / Route53 / S3 / CloudFront / IAM)

### ツール

- Visual Studio Code
- Git / GitHub(Git-flow)
- FontAwesome
- Adobe Color
- Rubocop
- Draw.io
- Figma
- Notion

## インフラ構成図

![Infrastructure diagram](https://user-images.githubusercontent.com/96477692/168478639-b00adce6-c49d-49cb-883e-b873d6011c05.png)

## ER 図

![entity-relation-diagram](https://user-images.githubusercontent.com/96477692/168478822-faf74d3c-814e-47ed-bfa3-cc5214197034.png)

**補足**

- **`Genres`テーブル**：　**レシピのジャンル。全て`enum`型で管理**
  - `staple_food`：　主食
  - `main_dish`：　主菜
  - `side_dish`：　副菜
  - `country_dish`：　各国料理
- **`Users`テーブル**：　**ユーザ**
  - `characteristic`：　属性。法人もしくは一般利用。`enum`型で管理
  - `level`：　レベル
  - `experience-point`：　経験値
  - `rest-point`：　次のレベルまでの残り経験値
  - `url`：　法人が運営する HP の URL
- **`LevelSettings`テーブル**：　**レベル参照テーブル**
  - `passing_level`：　合格レベル
  - `threshold`：　閾値(次のレベルを満たす経験値)

## 主な機能

**【レコメンド機能】**
「作ってみた！」ボタンを押すと、そのレシピ情報に合わせてログインユーザへレシピをレコメンドします。

![recommend-recipe](https://user-images.githubusercontent.com/96477692/168478989-88c63ce4-337c-4e79-a1f1-bb7c39ce7f12.png)

**【レシピ投稿】**
タイトル、内容、調理コストなどの情報、ジャンル、料理イメージを入力して投稿します。

![recipes-form](https://user-images.githubusercontent.com/96477692/168479076-71c469cf-68f8-4b58-b8d9-70aa626de19a.png)

**【レシピ検索】**
レシピタイトル、レシピ内容、調理時間、ジャンルなどから検索をすることができます。

![search-recipes](https://user-images.githubusercontent.com/96477692/168479134-af840f2a-16a3-4c81-bcdd-04a0c14fce11.gif)

**【アカウント登録】**
アカウント登録では、属性を選択して一般利用か法人かを選択します。ユーザ名、メールアドレス、パスワードを入力してアカウント登録します。また、**Google アカウントでもログインができます。**

![user-registration](https://user-images.githubusercontent.com/96477692/168479172-af1d63fc-a563-422d-9ea1-496681068056.png)

**【ユーザページ】**
ユーザページでは、プロフィール画像、メールアドレス、現在のレベルなどの情報、「作ってみた！」ボタンを押した投稿、お気に入りの投稿を閲覧することができます。

![user-mypage](https://user-images.githubusercontent.com/96477692/168479237-07e93552-3879-46d5-8b43-450347fc1cbe.gif)
