output "base_ami" {
  value = {
    id             = local.base_ami.id
    name           = local.base_ami.name
    image_location = local.base_ami.image_location
    description    = local.base_ami.description
    owner_id       = local.base_ami.owner_id
    creation_date  = local.base_ami.creation_date
    most_recent    = local.base_ami.most_recent

    architecture = local.base_ami.architecture
    hypervisor   = local.base_ami.hypervisor

    root_snapshot_id = local.base_ami.root_snapshot_id
  }
}
