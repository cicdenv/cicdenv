output "base_amis" {
  # filesystems => [root, instance-stores]
  value = { for fs, ami in local.base_ami : fs => {
    id             = ami.id
    name           = ami.name
    image_location = ami.image_location
    description    = ami.description
    owner_id       = ami.owner_id
    creation_date  = ami.creation_date
    most_recent    = ami.most_recent

    architecture = ami.architecture
    hypervisor   = ami.hypervisor

    root_snapshot_id = ami.root_snapshot_id
  }}
}
