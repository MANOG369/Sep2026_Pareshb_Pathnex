module "pathnex_vpc" {
  source = "./vpc"
}

module "pathnex_instance" {
  source = "./instance"
  vpc_id = module.pathnex_vpc.vpc_id
}

output "instance_id" {
  value = module.pathnex_instance.instance_id
}
