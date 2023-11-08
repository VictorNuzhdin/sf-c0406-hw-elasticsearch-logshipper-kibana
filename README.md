# sf-c0406-hw-elasticsearch-logshipper-kibana
For Skill Factory study project (C04, HW2)

<br>


### Quick Info

```bash
#Общее описание
Terraform IaC конфигурация для развертывания в облаке Yandex Cloud
тестового стенда на основе стека EFK (Elasticsearch + Fluent + Kibana).

Данный стек является альтернативой общепринятому стеку ELK (Elasticsearch + Logstash + Kibana)
в котором используется логшиппер "Fluent" вместо "Logstash"

#Основные ссылки с описанием используемых технологий
Terraform by HashiCorp
https://www.terraform.io/

Yandex Cloud by Yandex
https://cloud.yandex.com/en-ru/

Elasticsearch
https://en.wikipedia.org/wiki/Elasticsearch
https://www.elastic.co/

Logstash
https://wikitech.wikimedia.org/wiki/Logstash
https://www.elastic.co/logstash

Fluentd
https://en.wikipedia.org/wiki/Fluentd
https://www.fluentd.org/

Kibana
https://en.wikipedia.org/wiki/Kibana
https://www.elastic.co/kibana

```
<br>

### Quick UserGuide

```bash
#01 :: Select "terraform" directory
$ cd terraform

#02 :: Retrieve new auth token from Cloud (configured "yc" tool is required)
$ export TF_VAR_yc_token=$(yc iam create-token) && echo $TF_VAR_yc_token

#03 :: Check configuration, Build/Rebuild execution plan an Create/Recreate Cloud resources
$ terraform validate
$ terraform plan
$ terraform apply -auto-approve
..or
$ terraform validate && terraform plan && terraform apply -auto-approve
..or
$ terraform destroy -auto-approve && terraform validate && terraform plan && terraform apply -auto-approve

#04 :: Check site home pages of created cloud hosts with your preferred web browser
https://srv1.dotspace.ru    ## 
https://srv2.dotspace.ru    ## 

#05 :: Destroy cloud resources if they are not needed
$ terraform destroy -auto-approve


```
<br>

### Changelog

```bash
2023.11.07 :: Разработана каркасная базовая Terraform конфигурация создающая два сервера "srv1", "srv2" на основе образа Ubuntu 22.04

```
<br>
