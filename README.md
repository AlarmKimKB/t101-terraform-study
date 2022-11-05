# CloudNeta Terraform Study

T101 Study Weekly Assignment Repo.

We are studying using Terraform Up and Running.




## Weekly Assignment
---

### 1. Week 1 (Chapter 1-2)
* Deploy AWS EC2
* Deploy AWS ASG, ELB

### 2. Week 2 (Chapter 3)
* Learn how to isolate terraform state file (S3, DynamoDB)

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

