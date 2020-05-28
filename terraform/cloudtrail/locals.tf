locals {
  main_account = {
    id        = data.aws_caller_identity.current.account_id
    partition = data.aws_partition.current.partition
  }
}
