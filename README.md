# Move resources with Configuration Driven Move

Learn how to move your existing resources to module with the `moved` configuration block.

Follow along with the [Learn Guide](https://learn.hashicorp.com/tutorials/terraform/move-config) at HashiCorp Learn.


## 手順

``` shell
# for Win
scoop update terraform

terraform: 1.0.7 -> 1.1.9
...

'terraform' (1.1.9) was installed successfully!
```

``` shell
terraform init

terraform apply

curl $(terraform output -raw public_ip):8080

```

origin/mainの状態のデプロイ


## リファクタリング

モジュール分割
- modulesフォルダを作成し、main.tfの内容をmodulesフォルダ内のmain.tfへ切り出し
  - dataやresourceはそのまま切りだす
    - data "aws_ami" "ubuntu"　→　modules/compute/main.tf
    - resource "aws_instance" "example"　→　modules/compute/main.tf
    - resource "aws_security_group" "sg_8080"　→　modules/security_group/main.tf
  - 切り出したモジュールは「module」の定義で参照する
    - source：モジュールのパス
    - その他モジュールの変数に対して値を設定
  - 一部の設定値はモジュールに切り出したことにより参照できなくなったため、モジュールの外から受け取る仕組み
    - モジュール内に変数を定義し、モジュールを参照する側でモジュールの変数に値を設定する。

## movedブロック
リソースの変更を記載する。
以前は terraform state mv を用いていた

```
moved {
  from = 変更前リソース
  to = 変更後リソース
}
```

モジュール化による変更以外に、リソース名の変更にも使える
```
moved {
  from = 変更前リソース名
  to = 変更後リソース名
}
```
