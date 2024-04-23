module "networking" {
  source              = "./modules/networking"
  cidr_block          = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.8.0/24", "10.0.9.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  azs                 = ["ca-central-1a", "ca-central-1b"]
}

module "compute" {
  source      = "./modules/compute"
  subnets     = module.networking.public_subnets_ids
  image_id    = "ami-0f168a624c65f5699"
  instance_type = "t2.micro"
  min_size    = 1
  max_size    = 3
  key_name    = "pro1"
  vpc_id = module.networking.vpc_id
  db_host      = module.database.db_instance_address
  db_security_group_id = module.database.db_security_group_id
  target_group_arn = module.web_load_balancer.target_group_arns
  depends_on = [ module.networking ]
}

module "database" {
  source          = "./modules/database"
  db_instance_type = "db.t2.micro"
  db_name        = "mydb"
  db_user        = "admin"
  db_password    = "strongpassword123"
  subnet_ids     = module.networking.private_subnets_ids
  web_security_group_id = module.compute.web_security_group_id
  vpc_id = module.networking.vpc_id
  depends_on = [ module.networking ]
}


module "web_load_balancer" {
  source          = "./modules/aws-load-balancer"
  name            = "three-tier-web-lb"
  internal        = false
  subnets         = module.networking.public_subnets_ids
  security_groups = [module.compute.web_security_group_id]
  vpc_id          = module.networking.vpc_id
  web_instance_id = module.compute.instance_id
  depends_on      = [module.networking]
}
