locals = {
  cluster_name                 = "1-16-a-test.kops.cicdenv.com"
  master_autoscaling_group_ids = ["${aws_autoscaling_group.master-us-west-2a-masters-1-16-a-test-kops-cicdenv-com.id}", "${aws_autoscaling_group.master-us-west-2b-masters-1-16-a-test-kops-cicdenv-com.id}", "${aws_autoscaling_group.master-us-west-2c-masters-1-16-a-test-kops-cicdenv-com.id}"]
  master_security_group_ids    = ["${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}", "sg-0c67bb02683e78a9e"]
  node_autoscaling_group_ids   = ["${aws_autoscaling_group.nodes-us-west-2a-1-16-a-test-kops-cicdenv-com.id}", "${aws_autoscaling_group.nodes-us-west-2b-1-16-a-test-kops-cicdenv-com.id}", "${aws_autoscaling_group.nodes-us-west-2c-1-16-a-test-kops-cicdenv-com.id}"]
  node_security_group_ids      = ["${aws_security_group.nodes-1-16-a-test-kops-cicdenv-com.id}", "sg-0f75890eb3093643f"]
  node_subnet_ids              = ["subnet-0106f437908a18262", "subnet-0134d4be839fccb5f", "subnet-02540ba483bc09b46"]
  region                       = "us-west-2"
  subnet_ids                   = ["subnet-0058efe68bab0c57e", "subnet-0106f437908a18262", "subnet-0134d4be839fccb5f", "subnet-02540ba483bc09b46", "subnet-079cb4b9f95e7e03e", "subnet-0f3f5ba6e75476a47"]
  subnet_us-west-2a_id         = "subnet-0134d4be839fccb5f"
  subnet_us-west-2b_id         = "subnet-02540ba483bc09b46"
  subnet_us-west-2c_id         = "subnet-0106f437908a18262"
  subnet_utility-us-west-2a_id = "subnet-0058efe68bab0c57e"
  subnet_utility-us-west-2b_id = "subnet-079cb4b9f95e7e03e"
  subnet_utility-us-west-2c_id = "subnet-0f3f5ba6e75476a47"
  vpc_id                       = "vpc-09c82684402367116"
}

output "cluster_name" {
  value = "1-16-a-test.kops.cicdenv.com"
}

output "master_autoscaling_group_ids" {
  value = ["${aws_autoscaling_group.master-us-west-2a-masters-1-16-a-test-kops-cicdenv-com.id}", "${aws_autoscaling_group.master-us-west-2b-masters-1-16-a-test-kops-cicdenv-com.id}", "${aws_autoscaling_group.master-us-west-2c-masters-1-16-a-test-kops-cicdenv-com.id}"]
}

output "master_security_group_ids" {
  value = ["${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}", "sg-0c67bb02683e78a9e"]
}

output "node_autoscaling_group_ids" {
  value = ["${aws_autoscaling_group.nodes-us-west-2a-1-16-a-test-kops-cicdenv-com.id}", "${aws_autoscaling_group.nodes-us-west-2b-1-16-a-test-kops-cicdenv-com.id}", "${aws_autoscaling_group.nodes-us-west-2c-1-16-a-test-kops-cicdenv-com.id}"]
}

output "node_security_group_ids" {
  value = ["${aws_security_group.nodes-1-16-a-test-kops-cicdenv-com.id}", "sg-0f75890eb3093643f"]
}

output "node_subnet_ids" {
  value = ["subnet-0106f437908a18262", "subnet-0134d4be839fccb5f", "subnet-02540ba483bc09b46"]
}

output "region" {
  value = "us-west-2"
}

output "subnet_ids" {
  value = ["subnet-0058efe68bab0c57e", "subnet-0106f437908a18262", "subnet-0134d4be839fccb5f", "subnet-02540ba483bc09b46", "subnet-079cb4b9f95e7e03e", "subnet-0f3f5ba6e75476a47"]
}

output "subnet_us-west-2a_id" {
  value = "subnet-0134d4be839fccb5f"
}

output "subnet_us-west-2b_id" {
  value = "subnet-02540ba483bc09b46"
}

output "subnet_us-west-2c_id" {
  value = "subnet-0106f437908a18262"
}

output "subnet_utility-us-west-2a_id" {
  value = "subnet-0058efe68bab0c57e"
}

output "subnet_utility-us-west-2b_id" {
  value = "subnet-079cb4b9f95e7e03e"
}

output "subnet_utility-us-west-2c_id" {
  value = "subnet-0f3f5ba6e75476a47"
}

output "vpc_id" {
  value = "vpc-09c82684402367116"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_autoscaling_attachment" "master-us-west-2a-masters-1-16-a-test-kops-cicdenv-com" {
  elb                    = "${aws_elb.api-1-16-a-test-kops-cicdenv-com.id}"
  autoscaling_group_name = "${aws_autoscaling_group.master-us-west-2a-masters-1-16-a-test-kops-cicdenv-com.id}"
}

resource "aws_autoscaling_attachment" "master-us-west-2b-masters-1-16-a-test-kops-cicdenv-com" {
  elb                    = "${aws_elb.api-1-16-a-test-kops-cicdenv-com.id}"
  autoscaling_group_name = "${aws_autoscaling_group.master-us-west-2b-masters-1-16-a-test-kops-cicdenv-com.id}"
}

resource "aws_autoscaling_attachment" "master-us-west-2c-masters-1-16-a-test-kops-cicdenv-com" {
  elb                    = "${aws_elb.api-1-16-a-test-kops-cicdenv-com.id}"
  autoscaling_group_name = "${aws_autoscaling_group.master-us-west-2c-masters-1-16-a-test-kops-cicdenv-com.id}"
}

resource "aws_autoscaling_group" "master-us-west-2a-masters-1-16-a-test-kops-cicdenv-com" {
  name                 = "master-us-west-2a.masters.1-16-a-test.kops.cicdenv.com"
  launch_configuration = "${aws_launch_configuration.master-us-west-2a-masters-1-16-a-test-kops-cicdenv-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["subnet-0134d4be839fccb5f"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "1-16-a-test.kops.cicdenv.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-west-2a.masters.1-16-a-test.kops.cicdenv.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-us-west-2a"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }

  tag = {
    key                 = "kops.k8s.io/instancegroup"
    value               = "master-us-west-2a"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "master-us-west-2b-masters-1-16-a-test-kops-cicdenv-com" {
  name                 = "master-us-west-2b.masters.1-16-a-test.kops.cicdenv.com"
  launch_configuration = "${aws_launch_configuration.master-us-west-2b-masters-1-16-a-test-kops-cicdenv-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["subnet-02540ba483bc09b46"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "1-16-a-test.kops.cicdenv.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-west-2b.masters.1-16-a-test.kops.cicdenv.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-us-west-2b"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }

  tag = {
    key                 = "kops.k8s.io/instancegroup"
    value               = "master-us-west-2b"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "master-us-west-2c-masters-1-16-a-test-kops-cicdenv-com" {
  name                 = "master-us-west-2c.masters.1-16-a-test.kops.cicdenv.com"
  launch_configuration = "${aws_launch_configuration.master-us-west-2c-masters-1-16-a-test-kops-cicdenv-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["subnet-0106f437908a18262"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "1-16-a-test.kops.cicdenv.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "master-us-west-2c.masters.1-16-a-test.kops.cicdenv.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-us-west-2c"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }

  tag = {
    key                 = "kops.k8s.io/instancegroup"
    value               = "master-us-west-2c"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "nodes-us-west-2a-1-16-a-test-kops-cicdenv-com" {
  name                 = "nodes-us-west-2a.1-16-a-test.kops.cicdenv.com"
  launch_configuration = "${aws_launch_configuration.nodes-us-west-2a-1-16-a-test-kops-cicdenv-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["subnet-0134d4be839fccb5f"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "1-16-a-test.kops.cicdenv.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes-us-west-2a.1-16-a-test.kops.cicdenv.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes-us-west-2a"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }

  tag = {
    key                 = "kops.k8s.io/instancegroup"
    value               = "nodes-us-west-2a"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "nodes-us-west-2b-1-16-a-test-kops-cicdenv-com" {
  name                 = "nodes-us-west-2b.1-16-a-test.kops.cicdenv.com"
  launch_configuration = "${aws_launch_configuration.nodes-us-west-2b-1-16-a-test-kops-cicdenv-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["subnet-02540ba483bc09b46"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "1-16-a-test.kops.cicdenv.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes-us-west-2b.1-16-a-test.kops.cicdenv.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes-us-west-2b"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }

  tag = {
    key                 = "kops.k8s.io/instancegroup"
    value               = "nodes-us-west-2b"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "nodes-us-west-2c-1-16-a-test-kops-cicdenv-com" {
  name                 = "nodes-us-west-2c.1-16-a-test.kops.cicdenv.com"
  launch_configuration = "${aws_launch_configuration.nodes-us-west-2c-1-16-a-test-kops-cicdenv-com.id}"
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = ["subnet-0106f437908a18262"]

  tag = {
    key                 = "KubernetesCluster"
    value               = "1-16-a-test.kops.cicdenv.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Name"
    value               = "nodes-us-west-2c.1-16-a-test.kops.cicdenv.com"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes-us-west-2c"
    propagate_at_launch = true
  }

  tag = {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }

  tag = {
    key                 = "kops.k8s.io/instancegroup"
    value               = "nodes-us-west-2c"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_ebs_volume" "a-etcd-events-1-16-a-test-kops-cicdenv-com" {
  availability_zone = "us-west-2a"
  size              = 20
  type              = "gp2"
  kms_key_id        = "arn:aws:kms:us-west-2:686087570203:key/839040de-4eb0-4188-b1f5-fc641877f886"
  encrypted         = true

  tags = {
    KubernetesCluster                                    = "1-16-a-test.kops.cicdenv.com"
    Name                                                 = "a.etcd-events.1-16-a-test.kops.cicdenv.com"
    "k8s.io/etcd/events"                                 = "a/a,b,c"
    "k8s.io/role/master"                                 = "1"
    "kubernetes.io/cluster/1-16-a-test.kops.cicdenv.com" = "owned"
  }
}

resource "aws_ebs_volume" "a-etcd-main-1-16-a-test-kops-cicdenv-com" {
  availability_zone = "us-west-2a"
  size              = 20
  type              = "gp2"
  kms_key_id        = "arn:aws:kms:us-west-2:686087570203:key/839040de-4eb0-4188-b1f5-fc641877f886"
  encrypted         = true

  tags = {
    KubernetesCluster                                    = "1-16-a-test.kops.cicdenv.com"
    Name                                                 = "a.etcd-main.1-16-a-test.kops.cicdenv.com"
    "k8s.io/etcd/main"                                   = "a/a,b,c"
    "k8s.io/role/master"                                 = "1"
    "kubernetes.io/cluster/1-16-a-test.kops.cicdenv.com" = "owned"
  }
}

resource "aws_ebs_volume" "b-etcd-events-1-16-a-test-kops-cicdenv-com" {
  availability_zone = "us-west-2b"
  size              = 20
  type              = "gp2"
  kms_key_id        = "arn:aws:kms:us-west-2:686087570203:key/839040de-4eb0-4188-b1f5-fc641877f886"
  encrypted         = true

  tags = {
    KubernetesCluster                                    = "1-16-a-test.kops.cicdenv.com"
    Name                                                 = "b.etcd-events.1-16-a-test.kops.cicdenv.com"
    "k8s.io/etcd/events"                                 = "b/a,b,c"
    "k8s.io/role/master"                                 = "1"
    "kubernetes.io/cluster/1-16-a-test.kops.cicdenv.com" = "owned"
  }
}

resource "aws_ebs_volume" "b-etcd-main-1-16-a-test-kops-cicdenv-com" {
  availability_zone = "us-west-2b"
  size              = 20
  type              = "gp2"
  kms_key_id        = "arn:aws:kms:us-west-2:686087570203:key/839040de-4eb0-4188-b1f5-fc641877f886"
  encrypted         = true

  tags = {
    KubernetesCluster                                    = "1-16-a-test.kops.cicdenv.com"
    Name                                                 = "b.etcd-main.1-16-a-test.kops.cicdenv.com"
    "k8s.io/etcd/main"                                   = "b/a,b,c"
    "k8s.io/role/master"                                 = "1"
    "kubernetes.io/cluster/1-16-a-test.kops.cicdenv.com" = "owned"
  }
}

resource "aws_ebs_volume" "c-etcd-events-1-16-a-test-kops-cicdenv-com" {
  availability_zone = "us-west-2c"
  size              = 20
  type              = "gp2"
  kms_key_id        = "arn:aws:kms:us-west-2:686087570203:key/839040de-4eb0-4188-b1f5-fc641877f886"
  encrypted         = true

  tags = {
    KubernetesCluster                                    = "1-16-a-test.kops.cicdenv.com"
    Name                                                 = "c.etcd-events.1-16-a-test.kops.cicdenv.com"
    "k8s.io/etcd/events"                                 = "c/a,b,c"
    "k8s.io/role/master"                                 = "1"
    "kubernetes.io/cluster/1-16-a-test.kops.cicdenv.com" = "owned"
  }
}

resource "aws_ebs_volume" "c-etcd-main-1-16-a-test-kops-cicdenv-com" {
  availability_zone = "us-west-2c"
  size              = 20
  type              = "gp2"
  kms_key_id        = "arn:aws:kms:us-west-2:686087570203:key/839040de-4eb0-4188-b1f5-fc641877f886"
  encrypted         = true

  tags = {
    KubernetesCluster                                    = "1-16-a-test.kops.cicdenv.com"
    Name                                                 = "c.etcd-main.1-16-a-test.kops.cicdenv.com"
    "k8s.io/etcd/main"                                   = "c/a,b,c"
    "k8s.io/role/master"                                 = "1"
    "kubernetes.io/cluster/1-16-a-test.kops.cicdenv.com" = "owned"
  }
}

resource "aws_elb" "api-1-16-a-test-kops-cicdenv-com" {
  name = "api-1-16-a-test-kops-cicd-i4uhj6"

  listener = {
    instance_port     = 443
    instance_protocol = "TCP"
    lb_port           = 443
    lb_protocol       = "TCP"
  }

  security_groups = ["${aws_security_group.api-elb-1-16-a-test-kops-cicdenv-com.id}", "sg-07fb8bfa440a835f7"]
  subnets         = ["subnet-0106f437908a18262", "subnet-0134d4be839fccb5f", "subnet-02540ba483bc09b46"]
  internal        = true

  health_check = {
    target              = "SSL:443"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    timeout             = 5
  }

  cross_zone_load_balancing = false
  idle_timeout              = 300

  tags = {
    KubernetesCluster                                    = "1-16-a-test.kops.cicdenv.com"
    Name                                                 = "api.1-16-a-test.kops.cicdenv.com"
    "kubernetes.io/cluster/1-16-a-test.kops.cicdenv.com" = "owned"
  }
}

resource "aws_key_pair" "kubernetes-1-16-a-test-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd" {
  key_name   = "kubernetes.1-16-a-test.kops.cicdenv.com-1e:f6:29:6b:4c:ef:0a:19:53:af:0b:f6:26:29:a1:bd"
  public_key = "${file("${path.module}/data/aws_key_pair_kubernetes.1-16-a-test.kops.cicdenv.com-1ef6296b4cef0a1953af0bf62629a1bd_public_key")}"
}

resource "aws_launch_configuration" "master-us-west-2a-masters-1-16-a-test-kops-cicdenv-com" {
  name_prefix                 = "master-us-west-2a.masters.1-16-a-test.kops.cicdenv.com-"
  image_id                    = "ami-0cedfe31df8f93717"
  instance_type               = "c5d.large"
  key_name                    = "${aws_key_pair.kubernetes-1-16-a-test-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd.id}"
  iam_instance_profile        = "kops-master"
  security_groups             = ["${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}", "sg-0c67bb02683e78a9e"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-west-2a.masters.1-16-a-test.kops.cicdenv.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = true
}

resource "aws_launch_configuration" "master-us-west-2b-masters-1-16-a-test-kops-cicdenv-com" {
  name_prefix                 = "master-us-west-2b.masters.1-16-a-test.kops.cicdenv.com-"
  image_id                    = "ami-0cedfe31df8f93717"
  instance_type               = "c5d.large"
  key_name                    = "${aws_key_pair.kubernetes-1-16-a-test-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd.id}"
  iam_instance_profile        = "kops-master"
  security_groups             = ["${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}", "sg-0c67bb02683e78a9e"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-west-2b.masters.1-16-a-test.kops.cicdenv.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = true
}

resource "aws_launch_configuration" "master-us-west-2c-masters-1-16-a-test-kops-cicdenv-com" {
  name_prefix                 = "master-us-west-2c.masters.1-16-a-test.kops.cicdenv.com-"
  image_id                    = "ami-0cedfe31df8f93717"
  instance_type               = "c5d.large"
  key_name                    = "${aws_key_pair.kubernetes-1-16-a-test-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd.id}"
  iam_instance_profile        = "kops-master"
  security_groups             = ["${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}", "sg-0c67bb02683e78a9e"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-west-2c.masters.1-16-a-test.kops.cicdenv.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = true
}

resource "aws_launch_configuration" "nodes-us-west-2a-1-16-a-test-kops-cicdenv-com" {
  name_prefix                 = "nodes-us-west-2a.1-16-a-test.kops.cicdenv.com-"
  image_id                    = "ami-0cedfe31df8f93717"
  instance_type               = "r5dn.xlarge"
  key_name                    = "${aws_key_pair.kubernetes-1-16-a-test-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd.id}"
  iam_instance_profile        = "kops-node"
  security_groups             = ["${aws_security_group.nodes-1-16-a-test-kops-cicdenv-com.id}", "sg-0f75890eb3093643f"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes-us-west-2a.1-16-a-test.kops.cicdenv.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = true
}

resource "aws_launch_configuration" "nodes-us-west-2b-1-16-a-test-kops-cicdenv-com" {
  name_prefix                 = "nodes-us-west-2b.1-16-a-test.kops.cicdenv.com-"
  image_id                    = "ami-0cedfe31df8f93717"
  instance_type               = "r5dn.xlarge"
  key_name                    = "${aws_key_pair.kubernetes-1-16-a-test-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd.id}"
  iam_instance_profile        = "kops-node"
  security_groups             = ["${aws_security_group.nodes-1-16-a-test-kops-cicdenv-com.id}", "sg-0f75890eb3093643f"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes-us-west-2b.1-16-a-test.kops.cicdenv.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = true
}

resource "aws_launch_configuration" "nodes-us-west-2c-1-16-a-test-kops-cicdenv-com" {
  name_prefix                 = "nodes-us-west-2c.1-16-a-test.kops.cicdenv.com-"
  image_id                    = "ami-0cedfe31df8f93717"
  instance_type               = "r5dn.xlarge"
  key_name                    = "${aws_key_pair.kubernetes-1-16-a-test-kops-cicdenv-com-1ef6296b4cef0a1953af0bf62629a1bd.id}"
  iam_instance_profile        = "kops-node"
  security_groups             = ["${aws_security_group.nodes-1-16-a-test-kops-cicdenv-com.id}", "sg-0f75890eb3093643f"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes-us-west-2c.1-16-a-test.kops.cicdenv.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  ephemeral_block_device = {
    device_name  = "/dev/sdc"
    virtual_name = "ephemeral0"
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = true
}

resource "aws_route53_record" "api-1-16-a-test-kops-cicdenv-com" {
  name = "api.1-16-a-test.kops.cicdenv.com"
  type = "A"

  alias = {
    name                   = "${aws_elb.api-1-16-a-test-kops-cicdenv-com.dns_name}"
    zone_id                = "${aws_elb.api-1-16-a-test-kops-cicdenv-com.zone_id}"
    evaluate_target_health = false
  }

  zone_id = "/hostedzone/Z09538592GF93UD87ZEFK"
}

resource "aws_security_group" "api-elb-1-16-a-test-kops-cicdenv-com" {
  name        = "api-elb.1-16-a-test.kops.cicdenv.com"
  vpc_id      = "vpc-09c82684402367116"
  description = "Security group for api ELB"

  tags = {
    KubernetesCluster                                    = "1-16-a-test.kops.cicdenv.com"
    Name                                                 = "api-elb.1-16-a-test.kops.cicdenv.com"
    "kubernetes.io/cluster/1-16-a-test.kops.cicdenv.com" = "owned"
  }
}

resource "aws_security_group" "masters-1-16-a-test-kops-cicdenv-com" {
  name        = "masters.1-16-a-test.kops.cicdenv.com"
  vpc_id      = "vpc-09c82684402367116"
  description = "Security group for masters"

  tags = {
    KubernetesCluster                                    = "1-16-a-test.kops.cicdenv.com"
    Name                                                 = "masters.1-16-a-test.kops.cicdenv.com"
    "kubernetes.io/cluster/1-16-a-test.kops.cicdenv.com" = "owned"
  }
}

resource "aws_security_group" "nodes-1-16-a-test-kops-cicdenv-com" {
  name        = "nodes.1-16-a-test.kops.cicdenv.com"
  vpc_id      = "vpc-09c82684402367116"
  description = "Security group for nodes"

  tags = {
    KubernetesCluster                                    = "1-16-a-test.kops.cicdenv.com"
    Name                                                 = "nodes.1-16-a-test.kops.cicdenv.com"
    "kubernetes.io/cluster/1-16-a-test.kops.cicdenv.com" = "owned"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}"
  source_security_group_id = "${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-1-16-a-test-kops-cicdenv-com.id}"
  source_security_group_id = "${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.nodes-1-16-a-test-kops-cicdenv-com.id}"
  source_security_group_id = "${aws_security_group.nodes-1-16-a-test-kops-cicdenv-com.id}"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "api-elb-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.api-elb-1-16-a-test-kops-cicdenv-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-api-elb-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.api-elb-1-16-a-test-kops-cicdenv-com.id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-elb-to-master" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}"
  source_security_group_id = "${aws_security_group.api-elb-1-16-a-test-kops-cicdenv-com.id}"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "icmp-pmtu-api-elb-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = "${aws_security_group.api-elb-1-16-a-test-kops-cicdenv-com.id}"
  from_port         = 3
  to_port           = 4
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nodes-1-16-a-test-kops-cicdenv-com.id}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}"
  source_security_group_id = "${aws_security_group.nodes-1-16-a-test-kops-cicdenv-com.id}"
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4000" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}"
  source_security_group_id = "${aws_security_group.nodes-1-16-a-test-kops-cicdenv-com.id}"
  from_port                = 2382
  to_port                  = 4000
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}"
  source_security_group_id = "${aws_security_group.nodes-1-16-a-test-kops-cicdenv-com.id}"
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.masters-1-16-a-test-kops-cicdenv-com.id}"
  source_security_group_id = "${aws_security_group.nodes-1-16-a-test-kops-cicdenv-com.id}"
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

terraform = {
  required_version = ">= 0.9.3"
}
