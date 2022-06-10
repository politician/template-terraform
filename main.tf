# -------------------------------------------------------------------------------------------------
# Computations
# -------------------------------------------------------------------------------------------------
locals {
  example_local = var.example_input
}

# -------------------------------------------------------------------------------------------------
# Output variables
# -------------------------------------------------------------------------------------------------
output "example_output" {
  description = "Example output."
  value       = local.example_local
}