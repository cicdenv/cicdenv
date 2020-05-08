locals {
  cluster_name                 = "1-18a-dev.kops.cicdenv.com"
  master_autoscaling_group_ids = [aws_autoscaling_group.master-us-west-2a-masters-1-18a-dev-kops-cicdenv-com.id, aws_autoscaling_group.master-us-west-2b-masters-1-18a-dev-kops-cicdenv-com.id, aws_autoscaling_group.master-us-west-2c-masters-1-18a-dev-kops-cicdenv-com.id]
  master_security_group_ids    = [aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id, aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id, aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id, "sg-01b7dec4801ca3963", "sg-01b7dec4801ca3963", "sg-01b7dec4801ca3963"]
  node_autoscaling_group_ids   = [aws_autoscaling_group.nodes-us-west-2a-1-18a-dev-kops-cicdenv-com.id, aws_autoscaling_group.nodes-us-west-2b-1-18a-dev-kops-cicdenv-com.id, aws_autoscaling_group.nodes-us-west-2c-1-18a-dev-kops-cicdenv-com.id]
  node_security_group_ids      = [aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id, aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id, aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id, "sg-085fcc2a8cfe305e5", "sg-085fcc2a8cfe305e5", "sg-085fcc2a8cfe305e5"]
  node_subnet_ids              = ["subnet-0230bf84c0ca70352", "subnet-0d9574ecb5a5ac0ee", "subnet-0f984b3662e26d4e6"]
  region                       = "us-west-2"
  subnet_ids                   = ["subnet-0230bf84c0ca70352", "subnet-094d995cd873d3728", "subnet-0af21c86ed70071c8", "subnet-0d9574ecb5a5ac0ee", "subnet-0f984b3662e26d4e6", "subnet-0fe6e7b15f31088c5"]
  subnet_us-west-2a_id         = "subnet-0230bf84c0ca70352"
  subnet_us-west-2b_id         = "subnet-0d9574ecb5a5ac0ee"
  subnet_us-west-2c_id         = "subnet-0f984b3662e26d4e6"
  subnet_utility-us-west-2a_id = "subnet-0fe6e7b15f31088c5"
  subnet_utility-us-west-2b_id = "subnet-094d995cd873d3728"
  subnet_utility-us-west-2c_id = "subnet-0af21c86ed70071c8"
  vpc_id                       = "vpc-05e996360e6d81043"
}

output "cluster_name" {
  value = "1-18a-dev.kops.cicdenv.com"
}

output "master_autoscaling_group_ids" {
  value = [aws_autoscaling_group.master-us-west-2a-masters-1-18a-dev-kops-cicdenv-com.id, aws_autoscaling_group.master-us-west-2b-masters-1-18a-dev-kops-cicdenv-com.id, aws_autoscaling_group.master-us-west-2c-masters-1-18a-dev-kops-cicdenv-com.id]
}

output "master_security_group_ids" {
  value = [aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id, aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id, aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id, "sg-01b7dec4801ca3963", "sg-01b7dec4801ca3963", "sg-01b7dec4801ca3963"]
}

output "node_autoscaling_group_ids" {
  value = [aws_autoscaling_group.nodes-us-west-2a-1-18a-dev-kops-cicdenv-com.id, aws_autoscaling_group.nodes-us-west-2b-1-18a-dev-kops-cicdenv-com.id, aws_autoscaling_group.nodes-us-west-2c-1-18a-dev-kops-cicdenv-com.id]
}

output "node_security_group_ids" {
  value = [aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id, aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id, aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id, "sg-085fcc2a8cfe305e5", "sg-085fcc2a8cfe305e5", "sg-085fcc2a8cfe305e5"]
}

output "node_subnet_ids" {
  value = ["subnet-0230bf84c0ca70352", "subnet-0d9574ecb5a5ac0ee", "subnet-0f984b3662e26d4e6"]
}

output "region" {
  value = "us-west-2"
}

output "subnet_ids" {
  value = ["subnet-0230bf84c0ca70352", "subnet-094d995cd873d3728", "subnet-0af21c86ed70071c8", "subnet-0d9574ecb5a5ac0ee", "subnet-0f984b3662e26d4e6", "subnet-0fe6e7b15f31088c5"]
}

output "subnet_us-west-2a_id" {
  value = "subnet-0230bf84c0ca70352"
}

output "subnet_us-west-2b_id" {
  value = "subnet-0d9574ecb5a5ac0ee"
}

output "subnet_us-west-2c_id" {
  value = "subnet-0f984b3662e26d4e6"
}

output "subnet_utility-us-west-2a_id" {
  value = "subnet-0fe6e7b15f31088c5"
}

output "subnet_utility-us-west-2b_id" {
  value = "subnet-094d995cd873d3728"
}

output "subnet_utility-us-west-2c_id" {
  value = "subnet-0af21c86ed70071c8"
}

output "vpc_id" {
  value = "vpc-05e996360e6d81043"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_autoscaling_attachment" "master-us-west-2a-masters-1-18a-dev-kops-cicdenv-com" {
  autoscaling_group_name = aws_autoscaling_group.master-us-west-2a-masters-1-18a-dev-kops-cicdenv-com.id
  elb                    = aws_elb.api-1-18a-dev-kops-cicdenv-com.id
}

resource "aws_autoscaling_attachment" "master-us-west-2b-masters-1-18a-dev-kops-cicdenv-com" {
  autoscaling_group_name = aws_autoscaling_group.master-us-west-2b-masters-1-18a-dev-kops-cicdenv-com.id
  elb                    = aws_elb.api-1-18a-dev-kops-cicdenv-com.id
}

resource "aws_autoscaling_attachment" "master-us-west-2c-masters-1-18a-dev-kops-cicdenv-com" {
  autoscaling_group_name = aws_autoscaling_group.master-us-west-2c-masters-1-18a-dev-kops-cicdenv-com.id
  elb                    = aws_elb.api-1-18a-dev-kops-cicdenv-com.id
}

resource "aws_autoscaling_group" "master-us-west-2a-masters-1-18a-dev-kops-cicdenv-com" {
  enabled_metrics      = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_configuration = aws_launch_configuration.master-us-west-2a-masters-1-18a-dev-kops-cicdenv-com.id
  max_size             = 1
  metrics_granularity  = "1Minute"
  min_size             = 1
  name                 = "master-us-west-2a.masters.1-18a-dev.kops.cicdenv.com"
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "1-18a-dev.kops.cicdenv.com"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "master-us-west-2a.masters.1-18a-dev.kops.cicdenv.com"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "master-us-west-2a"
  }
  tag {
    key                 = "k8s.io/role/master"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "master-us-west-2a"
  }
  tag {
    key                 = "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = ["subnet-0230bf84c0ca70352"]
}

resource "aws_autoscaling_group" "master-us-west-2b-masters-1-18a-dev-kops-cicdenv-com" {
  enabled_metrics      = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_configuration = aws_launch_configuration.master-us-west-2b-masters-1-18a-dev-kops-cicdenv-com.id
  max_size             = 1
  metrics_granularity  = "1Minute"
  min_size             = 1
  name                 = "master-us-west-2b.masters.1-18a-dev.kops.cicdenv.com"
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "1-18a-dev.kops.cicdenv.com"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "master-us-west-2b.masters.1-18a-dev.kops.cicdenv.com"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "master-us-west-2b"
  }
  tag {
    key                 = "k8s.io/role/master"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "master-us-west-2b"
  }
  tag {
    key                 = "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = ["subnet-0d9574ecb5a5ac0ee"]
}

resource "aws_autoscaling_group" "master-us-west-2c-masters-1-18a-dev-kops-cicdenv-com" {
  enabled_metrics      = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_configuration = aws_launch_configuration.master-us-west-2c-masters-1-18a-dev-kops-cicdenv-com.id
  max_size             = 1
  metrics_granularity  = "1Minute"
  min_size             = 1
  name                 = "master-us-west-2c.masters.1-18a-dev.kops.cicdenv.com"
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "1-18a-dev.kops.cicdenv.com"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "master-us-west-2c.masters.1-18a-dev.kops.cicdenv.com"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "master-us-west-2c"
  }
  tag {
    key                 = "k8s.io/role/master"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "master-us-west-2c"
  }
  tag {
    key                 = "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = ["subnet-0f984b3662e26d4e6"]
}

resource "aws_autoscaling_group" "nodes-us-west-2a-1-18a-dev-kops-cicdenv-com" {
  enabled_metrics      = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_configuration = aws_launch_configuration.nodes-us-west-2a-1-18a-dev-kops-cicdenv-com.id
  max_size             = 1
  metrics_granularity  = "1Minute"
  min_size             = 1
  name                 = "nodes-us-west-2a.1-18a-dev.kops.cicdenv.com"
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "1-18a-dev.kops.cicdenv.com"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "nodes-us-west-2a.1-18a-dev.kops.cicdenv.com"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes-us-west-2a"
  }
  tag {
    key                 = "k8s.io/role/node"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes-us-west-2a"
  }
  tag {
    key                 = "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = ["subnet-0230bf84c0ca70352"]
}

resource "aws_autoscaling_group" "nodes-us-west-2b-1-18a-dev-kops-cicdenv-com" {
  enabled_metrics      = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_configuration = aws_launch_configuration.nodes-us-west-2b-1-18a-dev-kops-cicdenv-com.id
  max_size             = 1
  metrics_granularity  = "1Minute"
  min_size             = 1
  name                 = "nodes-us-west-2b.1-18a-dev.kops.cicdenv.com"
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "1-18a-dev.kops.cicdenv.com"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "nodes-us-west-2b.1-18a-dev.kops.cicdenv.com"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes-us-west-2b"
  }
  tag {
    key                 = "k8s.io/role/node"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes-us-west-2b"
  }
  tag {
    key                 = "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = ["subnet-0d9574ecb5a5ac0ee"]
}

resource "aws_autoscaling_group" "nodes-us-west-2c-1-18a-dev-kops-cicdenv-com" {
  enabled_metrics      = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_configuration = aws_launch_configuration.nodes-us-west-2c-1-18a-dev-kops-cicdenv-com.id
  max_size             = 1
  metrics_granularity  = "1Minute"
  min_size             = 1
  name                 = "nodes-us-west-2c.1-18a-dev.kops.cicdenv.com"
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "1-18a-dev.kops.cicdenv.com"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "nodes-us-west-2c.1-18a-dev.kops.cicdenv.com"
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes-us-west-2c"
  }
  tag {
    key                 = "k8s.io/role/node"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes-us-west-2c"
  }
  tag {
    key                 = "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = ["subnet-0f984b3662e26d4e6"]
}

resource "aws_ebs_volume" "a-etcd-events-1-18a-dev-kops-cicdenv-com" {
  availability_zone = "us-west-2a"
  encrypted         = true
  kms_key_id        = "arn:aws:kms:us-west-2:977594567050:key/40375c75-582c-4572-94cb-c6fd87e5bfa9"
  size              = 20
  tags = {
    "KubernetesCluster"                                = "1-18a-dev.kops.cicdenv.com"
    "Name"                                             = "a.etcd-events.1-18a-dev.kops.cicdenv.com"
    "k8s.io/etcd/events"                               = "a/a,b,c"
    "k8s.io/role/master"                               = "1"
    "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com" = "owned"
  }
  type = "gp2"
}

resource "aws_ebs_volume" "a-etcd-main-1-18a-dev-kops-cicdenv-com" {
  availability_zone = "us-west-2a"
  encrypted         = true
  kms_key_id        = "arn:aws:kms:us-west-2:977594567050:key/40375c75-582c-4572-94cb-c6fd87e5bfa9"
  size              = 20
  tags = {
    "KubernetesCluster"                                = "1-18a-dev.kops.cicdenv.com"
    "Name"                                             = "a.etcd-main.1-18a-dev.kops.cicdenv.com"
    "k8s.io/etcd/main"                                 = "a/a,b,c"
    "k8s.io/role/master"                               = "1"
    "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com" = "owned"
  }
  type = "gp2"
}

resource "aws_ebs_volume" "b-etcd-events-1-18a-dev-kops-cicdenv-com" {
  availability_zone = "us-west-2b"
  encrypted         = true
  kms_key_id        = "arn:aws:kms:us-west-2:977594567050:key/40375c75-582c-4572-94cb-c6fd87e5bfa9"
  size              = 20
  tags = {
    "KubernetesCluster"                                = "1-18a-dev.kops.cicdenv.com"
    "Name"                                             = "b.etcd-events.1-18a-dev.kops.cicdenv.com"
    "k8s.io/etcd/events"                               = "b/a,b,c"
    "k8s.io/role/master"                               = "1"
    "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com" = "owned"
  }
  type = "gp2"
}

resource "aws_ebs_volume" "b-etcd-main-1-18a-dev-kops-cicdenv-com" {
  availability_zone = "us-west-2b"
  encrypted         = true
  kms_key_id        = "arn:aws:kms:us-west-2:977594567050:key/40375c75-582c-4572-94cb-c6fd87e5bfa9"
  size              = 20
  tags = {
    "KubernetesCluster"                                = "1-18a-dev.kops.cicdenv.com"
    "Name"                                             = "b.etcd-main.1-18a-dev.kops.cicdenv.com"
    "k8s.io/etcd/main"                                 = "b/a,b,c"
    "k8s.io/role/master"                               = "1"
    "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com" = "owned"
  }
  type = "gp2"
}

resource "aws_ebs_volume" "c-etcd-events-1-18a-dev-kops-cicdenv-com" {
  availability_zone = "us-west-2c"
  encrypted         = true
  kms_key_id        = "arn:aws:kms:us-west-2:977594567050:key/40375c75-582c-4572-94cb-c6fd87e5bfa9"
  size              = 20
  tags = {
    "KubernetesCluster"                                = "1-18a-dev.kops.cicdenv.com"
    "Name"                                             = "c.etcd-events.1-18a-dev.kops.cicdenv.com"
    "k8s.io/etcd/events"                               = "c/a,b,c"
    "k8s.io/role/master"                               = "1"
    "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com" = "owned"
  }
  type = "gp2"
}

resource "aws_ebs_volume" "c-etcd-main-1-18a-dev-kops-cicdenv-com" {
  availability_zone = "us-west-2c"
  encrypted         = true
  kms_key_id        = "arn:aws:kms:us-west-2:977594567050:key/40375c75-582c-4572-94cb-c6fd87e5bfa9"
  size              = 20
  tags = {
    "KubernetesCluster"                                = "1-18a-dev.kops.cicdenv.com"
    "Name"                                             = "c.etcd-main.1-18a-dev.kops.cicdenv.com"
    "k8s.io/etcd/main"                                 = "c/a,b,c"
    "k8s.io/role/master"                               = "1"
    "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com" = "owned"
  }
  type = "gp2"
}

resource "aws_elb" "api-1-18a-dev-kops-cicdenv-com" {
  cross_zone_load_balancing = false
  health_check {
    healthy_threshold   = 2
    interval            = 10
    target              = "SSL:443"
    timeout             = 5
    unhealthy_threshold = 2
  }
  idle_timeout = 300
  internal     = true
  listener {
    instance_port      = 443
    instance_protocol  = "TCP"
    lb_port            = 443
    lb_protocol        = "TCP"
    ssl_certificate_id = ""
  }
  name            = "api-1-18a-dev-kops-cicden-kq68md"
  security_groups = [aws_security_group.api-elb-1-18a-dev-kops-cicdenv-com.id, "sg-05648b405f7e40884"]
  subnets         = ["subnet-0230bf84c0ca70352", "subnet-0d9574ecb5a5ac0ee", "subnet-0f984b3662e26d4e6"]
  tags = {
    "KubernetesCluster"                                = "1-18a-dev.kops.cicdenv.com"
    "Name"                                             = "api.1-18a-dev.kops.cicdenv.com"
    "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com" = "owned"
  }
}

resource "aws_key_pair" "kubernetes-1-18a-dev-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd" {
  key_name   = "kubernetes.1-18a-dev.kops.cicdenv.com-1e:f6:29:6b:4c:ef:0a:19:53:af:0b:f6:26:29:a1:bd"
  public_key = file("${path.module}/data/aws_key_pair_kubernetes.1-18a-dev.kops.cicdenv.com-1ef6296b4cef0a1953af0bf62629a1bd_public_key")
}

resource "aws_launch_configuration" "master-us-west-2a-masters-1-18a-dev-kops-cicdenv-com" {
  associate_public_ip_address = false
  enable_monitoring           = true
  ephemeral_block_device {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }
  iam_instance_profile = "kops-master"
  image_id             = "ami-0a5a445878d40f4e8"
  instance_type        = "c5d.large"
  key_name             = aws_key_pair.kubernetes-1-18a-dev-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd.id
  lifecycle {
    create_before_destroy = true
  }
  name_prefix = "master-us-west-2a.masters.1-18a-dev.kops.cicdenv.com-"
  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }
  security_groups = [aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id, "sg-01b7dec4801ca3963"]
  user_data       = file("${path.module}/data/aws_launch_configuration_master-us-west-2a.masters.1-18a-dev.kops.cicdenv.com_user_data")
}

resource "aws_launch_configuration" "master-us-west-2b-masters-1-18a-dev-kops-cicdenv-com" {
  associate_public_ip_address = false
  enable_monitoring           = true
  ephemeral_block_device {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }
  iam_instance_profile = "kops-master"
  image_id             = "ami-0a5a445878d40f4e8"
  instance_type        = "c5d.large"
  key_name             = aws_key_pair.kubernetes-1-18a-dev-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd.id
  lifecycle {
    create_before_destroy = true
  }
  name_prefix = "master-us-west-2b.masters.1-18a-dev.kops.cicdenv.com-"
  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }
  security_groups = [aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id, "sg-01b7dec4801ca3963"]
  user_data       = file("${path.module}/data/aws_launch_configuration_master-us-west-2b.masters.1-18a-dev.kops.cicdenv.com_user_data")
}

resource "aws_launch_configuration" "master-us-west-2c-masters-1-18a-dev-kops-cicdenv-com" {
  associate_public_ip_address = false
  enable_monitoring           = true
  ephemeral_block_device {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }
  iam_instance_profile = "kops-master"
  image_id             = "ami-0a5a445878d40f4e8"
  instance_type        = "c5d.large"
  key_name             = aws_key_pair.kubernetes-1-18a-dev-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd.id
  lifecycle {
    create_before_destroy = true
  }
  name_prefix = "master-us-west-2c.masters.1-18a-dev.kops.cicdenv.com-"
  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }
  security_groups = [aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id, "sg-01b7dec4801ca3963"]
  user_data       = file("${path.module}/data/aws_launch_configuration_master-us-west-2c.masters.1-18a-dev.kops.cicdenv.com_user_data")
}

resource "aws_launch_configuration" "nodes-us-west-2a-1-18a-dev-kops-cicdenv-com" {
  associate_public_ip_address = false
  enable_monitoring           = true
  ephemeral_block_device {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }
  iam_instance_profile = "kops-node"
  image_id             = "ami-0a5a445878d40f4e8"
  instance_type        = "r5dn.xlarge"
  key_name             = aws_key_pair.kubernetes-1-18a-dev-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd.id
  lifecycle {
    create_before_destroy = true
  }
  name_prefix = "nodes-us-west-2a.1-18a-dev.kops.cicdenv.com-"
  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }
  security_groups = [aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id, "sg-085fcc2a8cfe305e5"]
  user_data       = file("${path.module}/data/aws_launch_configuration_nodes-us-west-2a.1-18a-dev.kops.cicdenv.com_user_data")
}

resource "aws_launch_configuration" "nodes-us-west-2b-1-18a-dev-kops-cicdenv-com" {
  associate_public_ip_address = false
  enable_monitoring           = true
  ephemeral_block_device {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }
  iam_instance_profile = "kops-node"
  image_id             = "ami-0a5a445878d40f4e8"
  instance_type        = "r5dn.xlarge"
  key_name             = aws_key_pair.kubernetes-1-18a-dev-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd.id
  lifecycle {
    create_before_destroy = true
  }
  name_prefix = "nodes-us-west-2b.1-18a-dev.kops.cicdenv.com-"
  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }
  security_groups = [aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id, "sg-085fcc2a8cfe305e5"]
  user_data       = file("${path.module}/data/aws_launch_configuration_nodes-us-west-2b.1-18a-dev.kops.cicdenv.com_user_data")
}

resource "aws_launch_configuration" "nodes-us-west-2c-1-18a-dev-kops-cicdenv-com" {
  associate_public_ip_address = false
  enable_monitoring           = true
  ephemeral_block_device {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }
  iam_instance_profile = "kops-node"
  image_id             = "ami-0a5a445878d40f4e8"
  instance_type        = "r5dn.xlarge"
  key_name             = aws_key_pair.kubernetes-1-18a-dev-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd.id
  lifecycle {
    create_before_destroy = true
  }
  name_prefix = "nodes-us-west-2c.1-18a-dev.kops.cicdenv.com-"
  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }
  security_groups = [aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id, "sg-085fcc2a8cfe305e5"]
  user_data       = file("${path.module}/data/aws_launch_configuration_nodes-us-west-2c.1-18a-dev.kops.cicdenv.com_user_data")
}

resource "aws_route53_record" "api-1-18a-dev-kops-cicdenv-com" {
  alias {
    evaluate_target_health = false
    name                   = aws_elb.api-1-18a-dev-kops-cicdenv-com.dns_name
    zone_id                = aws_elb.api-1-18a-dev-kops-cicdenv-com.zone_id
  }
  name    = "api.1-18a-dev.kops.cicdenv.com"
  type    = "A"
  zone_id = "/hostedzone/Z09422972460V9DOBEONQ"
}

resource "aws_security_group_rule" "all-master-to-master" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id
  source_security_group_id = aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "all-master-to-node" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id
  source_security_group_id = aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "all-node-to-node" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id
  source_security_group_id = aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "api-elb-egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.api-elb-1-18a-dev-kops-cicdenv-com.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "https-api-elb-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.api-elb-1-18a-dev-kops-cicdenv-com.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "https-elb-to-master" {
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id
  source_security_group_id = aws_security_group.api-elb-1-18a-dev-kops-cicdenv-com.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "icmp-pmtu-api-elb-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 3
  protocol          = "icmp"
  security_group_id = aws_security_group.api-elb-1-18a-dev-kops-cicdenv-com.id
  to_port           = 4
  type              = "ingress"
}

resource "aws_security_group_rule" "master-egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "node-egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  from_port                = 1
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id
  source_security_group_id = aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id
  to_port                  = 2379
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000" {
  from_port                = 2382
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id
  source_security_group_id = aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id
  to_port                  = 4000
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  from_port                = 4003
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id
  source_security_group_id = aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  from_port                = 1
  protocol                 = "udp"
  security_group_id        = aws_security_group.masters-1-18a-dev-kops-cicdenv-com.id
  source_security_group_id = aws_security_group.nodes-1-18a-dev-kops-cicdenv-com.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group" "api-elb-1-18a-dev-kops-cicdenv-com" {
  description = "Security group for api ELB"
  name        = "api-elb.1-18a-dev.kops.cicdenv.com"
  tags = {
    "KubernetesCluster"                                = "1-18a-dev.kops.cicdenv.com"
    "Name"                                             = "api-elb.1-18a-dev.kops.cicdenv.com"
    "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com" = "owned"
  }
  vpc_id = "vpc-05e996360e6d81043"
}

resource "aws_security_group" "masters-1-18a-dev-kops-cicdenv-com" {
  description = "Security group for masters"
  name        = "masters.1-18a-dev.kops.cicdenv.com"
  tags = {
    "KubernetesCluster"                                = "1-18a-dev.kops.cicdenv.com"
    "Name"                                             = "masters.1-18a-dev.kops.cicdenv.com"
    "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com" = "owned"
  }
  vpc_id = "vpc-05e996360e6d81043"
}

resource "aws_security_group" "nodes-1-18a-dev-kops-cicdenv-com" {
  description = "Security group for nodes"
  name        = "nodes.1-18a-dev.kops.cicdenv.com"
  tags = {
    "KubernetesCluster"                                = "1-18a-dev.kops.cicdenv.com"
    "Name"                                             = "nodes.1-18a-dev.kops.cicdenv.com"
    "kubernetes.io/cluster/1-18a-dev.kops.cicdenv.com" = "owned"
  }
  vpc_id = "vpc-05e996360e6d81043"
}

terraform {
  required_version = ">= 0.12.0"
}
