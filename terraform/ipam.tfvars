ipam = {
  main = {
    shared = {
      network_cidr = "10.16.0.0/16"
    }
    backend = {
      network_cidr = "192.168.64.0/22"
    }
  }

  prod = {
    shared = {
      network_cidr = "10.17.0.0/16"
    }
  }

  test = {
    shared = {
      network_cidr = "10.18.0.0/16"
    }
  }

  dev = {
    shared = {
      network_cidr = "10.19.0.0/16"
    }
  }

  infra = {
    shared = {
      network_cidr = "10.20.0.0/16"
    }
  }
}
