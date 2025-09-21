variable "aws_region" {
	description = "Optional override region; if unset, will read from sandbox remote state"
	type        = string
	default     = null
}

variable "cluster_name" {
	description = "Optional override cluster name; if unset, will read from sandbox remote state"
	type        = string
	default     = null
}

locals {
	operators_region       = coalesce(var.aws_region, try(data.terraform_remote_state.sandbox.outputs.aws_region, null), "us-east-1")
	operators_cluster_name = coalesce(var.cluster_name, try(data.terraform_remote_state.sandbox.outputs.eks_cluster_name, null), "innovatemart-sandbox")
}

provider "aws" {
	region = local.operators_region
}

data "aws_eks_cluster" "this" {
	name = local.operators_cluster_name
}

data "aws_eks_cluster_auth" "this" {
	name = local.operators_cluster_name
}

provider "kubernetes" {
	host                   = data.aws_eks_cluster.this.endpoint
	cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
	token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
	kubernetes {
		host                   = data.aws_eks_cluster.this.endpoint
		cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
		token                  = data.aws_eks_cluster_auth.this.token
	}
}

