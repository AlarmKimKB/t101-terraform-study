# CloudNeta Terraform Study

T101 Study Weekly Assignment Repo.

We are studying using Terraform Up and Running.

<br>

## Weekly Assignment
---

### 1. Week 1 (Chapter 1-2)
* Deploy AWS EC2
* Deploy AWS ASG, ELB

<br>

### 2. Week 2 (Chapter 3)
* Learn how to isolate terraform state file (S3, DynamoDB)

<br>

### 3. Week 3 (Chapter 3)
* Learn how to share remote state file
```bash
03_week3
├── 01_backend
│   ├── 01.variables.tf
│   ├── 10.backend.tf
│   └── 99.output.tf
└── 02_dev
    ├── 01_vpc
    │   ├── 00.backend_dev_vpc.tf
    │   ├── 01.variables.tf
    │   ├── 10.vpc_dev.tf
    │   └── 99.output.tf
    ├── 02_rds
    │   ├── 00.backend_dev_rds.tf
    │   ├── 01.variables.tf
    │   ├── 10.sg_rds_dev.tf
    │   ├── 20.rds_dev.tf
    │   └── 99.output.tf
    └── 03_ec2
        ├── 00.backend_dev_ec2.tf
        ├── 01.variables.tf
        ├── 10.sg_ec2_dev.tf
        ├── 20.ec2_dev.tf
        ├── 21.user-data.sh
        └── 30.alb_dev.tf

## Command
01_backend$ terraform init && plan && apply -auto-approve
02_dev/01_vpc$ terraform init && plan && apply -auto-approve
02_dev/02_rds$ terraform init && plan && apply -auto-approve
02_dev/03_ec2$ terraform init && plan && apply -auto-approve
```

<br>

### 4. Week 4 (Chapter 4)
* Learn how to make terraform module

```bash
04_week4
├── 01_global
│   └── 01_s3
│       ├── 01_s3.tf
│       └── 99_outputs.tf
├── 02_module
│   ├── 01_mysql
│   │   ├── 01_variables.tf
│   │   ├── 10_main_vpc.tf
│   │   ├── 11_main_rds.tf
│   │   └── 99_outputs.tf
│   └── 02_web
│       ├── 01_variables.tf
│       ├── 10_main_web.tf
│       └── 99_outputs.tf
└── 03_stage
    ├── 01_mysql
    │   ├── 10_main.tf
    │   └── 99_outputs.tf
    └── 02_web
        ├── 10_main_web.tf
        ├── 11_user-data.sh
        └── 99_outputs.tf

## Command
01_global/01_s3$ terraform init && plan && apply -auto-approve
03_stage/01_mysql$ terraform init && plan && apply -auto-approve
03_stage/02_web$ terraform init && plan && apply -auto-approve

```

<br>

### 5. Week 5 (Chapter 5)
* count 반복문 사용    : Subnet 생성, Route Table Association
* for 반복문 사용      : DB subnet 에 Subnet ID 연결, ASG에 Subnet ID 연결
* Local 변수 사용     : SG Config 에 사용
* 3항 연산자 조건문 사용 : S3 버킷 생성

<br>

``` bash
05_week5
├── 01_global
│   └── 01_s3
│       ├── 01_variables.tf
│       ├── 10_s3.tf
│       ├── 99_outputs.tf
│       ├── terraform.tfstate
│       └── terraform.tfstate.backup
├── 02_module
│   ├── 01_mysql
│   │   ├── 01_variables.tf
│   │   ├── 02_locals.tf
│   │   ├── 10_main_vpc.tf
│   │   ├── 11_main_rds.tf
│   │   └── 99_outputs.tf
│   └── 02_web
│       ├── 01_variables.tf
│       ├── 02_locals.tf
│       ├── 10_main_web.tf
│       └── 99_outputs.tf
└── 03_stage
    ├── 01_mysql
    │   ├── 10_main.tf
    │   └── 99_outputs.tf
    └── 02_web
        ├── 10_main_web.tf
        ├── 11_user-data.sh
        └── 99_outputs.tf

## Command
01_global/01_s3$ terraform init && plan && apply -auto-approve
03_stage/01_mysql$ terraform init && plan && apply -auto-approve
03_stage/02_web$ terraform init && plan && apply -auto-approve
```