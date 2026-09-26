provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket       = "terraform-backend-1021-kez"
    key          = "stage/services/web-server/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
module "webserver_cluster" {
  source                 = "github.com/keshavlearndevops/terraform-modules//services/webserver-cluster?ref=v0.0.2"
  cluster_name           = "webserver-stage"
  db_remote_state_bucket = "terraform-backend-1021-kez"
  db_remote_state_key    = "stage/data-store/mysql/terraform.tfstate"
  instance_type          = "t2.micro"
  min_size               = 2
  max_size               = 2
}

# resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
#   scheduled_action_name = "scale-out-during-business-hours"
#   min_size              = 2
#   max_size              = 10
#   desired_capacity      = 10
#   recurrence            = "0 9 * * *"
# }

# resource "aws_autoscaling_schedule" "scale_in_at_night" {
#   scheduled_action_name = "scale-in-at-night"
#   min_size              = 2
#   max_size              = 10
#   desired_capacity      = 2
#   recurrence            = "0 17  * * *"
# }
resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 1234
  to_port     = 1234
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
