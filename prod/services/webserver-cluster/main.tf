provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket       = "terraform-backend-1021-kez"
    key          = "prod/services/web-server/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
module "webserver_cluster" {
  source                 = "github.com/keshavlearndevops/terraform-modules//services/webserver-cluster?ref=v0.0.2"
  cluster_name           = "webserver-prod"
  db_remote_state_bucket = "terraform-backend-1021-kez"
  db_remote_state_key    = "prod/data-store/mysql/terraform.tfstate"
  instance_type          = "t2.micro"
  min_size               = 2
  max_size               = 4
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name  = "scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17  * * *"
  autoscaling_group_name = module.webserver_cluster.asg_name
}
