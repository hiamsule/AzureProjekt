module "test" {
  source       = "../Modules"
  vm_size      = "Standard_B1ms"
  stage        = "test"
  prefix       = "testteqwerk"
  network_cidr = "10.1.0.0/16"
  subnet_cidr  = "10.1.1.0/24"
  public_ip_name = "webapptest-publicip"
}

output "public_ip_address" {
  value = module.test.public_ip_address
}
