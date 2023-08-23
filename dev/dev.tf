module "dev" {
  source         = "../Modules"
  vm_size        = "Standard_B1ms"
  stage          = "dev"
  prefix         = "devteqwerk"
  network_cidr   = "10.2.0.0/16"
  subnet_cidr    = "10.2.1.0/24"
  public_ip_name = "webappdev-publicip"
}

output "public_ip_address" {
  value = module.dev.public_ip_address
}