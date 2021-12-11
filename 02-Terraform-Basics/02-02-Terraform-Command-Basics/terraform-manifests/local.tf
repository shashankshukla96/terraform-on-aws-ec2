variable "environment" {
	description = "environment"
	default = "test1_use1"
}

locals {
  team_name     = "ckg"
  product_suite = "cacdi"
  project_name  = "ckg-iks"

  _use_case = {
    sandbox    = "clakec"
    test1_use1 = "claimadmc"
    test2_use1 = "claimadmc"
    test3_use1 = "claimadmc"
    test4_use1 = "claimadmc"
		prod  = "claimadmc"
  }

  use_case = local._use_case["${var.environment}"]

  _region = {
    sandbox    = "use1"
    test1_use1 = "use1"
    test2_use1 = "use1"
    test3_use1 = "use1"
    test4_use1 = "use1"
		prod  = "use1"
  }

  region = local._region["${var.environment}"]

  _region_full_desc = {
    use1 = "us-east-1"
  }

  region_full_desc = local._region_full_desc[local.region]

  _segment = {
    sandbox    = "test"
    test1_use1 = "test1"
    test2_use1 = "test2"
    test3_use1 = "test3"
    test4_use1 = "test4"
		prod  = "prod"
  }

  segment = local._segment["${var.environment}"]

  _parent_segment = {
    test  = "test"
    test1 = "test"
    test2 = "test"
    test3 = "test"
    test4 = "test"
		prod = "prod"
  }

  parent_segment = local._parent_segment[local.segment]

	_ou = {
		test = "test"
		test1 = "test"
		test2 = "test"
		test3 = "test"
		test4 = "test"
		prod = "prod"
	}

	ou = local._ou[local.segment]

	_pcat_segment = {
		test = "test5"
		prod = "prod1"
	}

	pcat_segment = local._pcat_segment[local.parent_segment]
}

output "domain" {
	value = "${local.use_case}.${local.segment}.ic1.statefarm"
}