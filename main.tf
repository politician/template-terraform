# -------------------------------------------------------------------------------------------------
# Computations
# -------------------------------------------------------------------------------------------------
locals {
  example = var.example
}

# -------------------------------------------------------------------------------------------------
# Outputs
# -------------------------------------------------------------------------------------------------
output "example" {
  description = "Example output."
  value       = local.example
}
