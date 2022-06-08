# -------------------------------------------------------------------------------------------------
# This is an example test using native Terraform tests:
# https://www.terraform.io/language/modules/testing-experiment
# From the root folder, run it with:
#
# terraform test
#
# Note: This is the exact same test as the Go test in ./tests/minimal_test.go, so you can see the
# two tests formats alongside each other and pick your favorite one.
# -------------------------------------------------------------------------------------------------

terraform {
  required_providers {
    # Because we're currently using a built-in provider as
    # a substitute for dedicated Terraform language syntax
    # for now, test suite modules must always declare a
    # dependency on this provider. This provider is only
    # available when running tests, so you shouldn't use it
    # in non-test modules.
    test = {
      source = "terraform.io/builtin/test"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.3.1"
    }
  }
}

# -------------------------------------------------------------------------------------------------
# Computations
# -------------------------------------------------------------------------------------------------

# The universe is vast, let's generate a random ID to name our world
resource "random_id" "world" {
  byte_length = 4
}

locals {
  example_input = format("hello world #%s", random_id.world.id)
}

# -------------------------------------------------------------------------------------------------
# Use module
# -------------------------------------------------------------------------------------------------
module "minimal" {
  source = "../.."

  # Input variables
  example_input = local.example_input
}

# -------------------------------------------------------------------------------------------------
# Test outputs
# -------------------------------------------------------------------------------------------------

# The special test_assertions resource type, which belongs
# to the test provider we required above, is a temporary
# syntax for writing out explicit test assertions.
resource "test_assertions" "test_minimal" {
  # "component" serves as a unique identifier for this
  # particular set of assertions in the test results.
  component = "test_minimal"

  # Expected outputs
  equal "example_output" {
    description = "Example output matches example input."
    got         = module.minimal.example_output
    want        = local.example_input
  }
}
