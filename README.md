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

## リファクタリング
