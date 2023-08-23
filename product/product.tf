module "product" {
  source       = "../Modules"
  vm_size      = "Standard_B1ms"
  stage        = "product"
  prefix       = "productteqwerk"
  network_cidr = "10.3.0.0/16"
  subnet_cidr  = "10.3.1.0/24"
  public_ip_name = "webappproduct-publicip"
}

output "public_ip_address" {
  value = module.product.public_ip_address
}