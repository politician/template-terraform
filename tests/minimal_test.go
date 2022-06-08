// ------------------------------------------------------------------------------------------------
// This is an example test using Go tests with the help of Terratest
// https://terratest.gruntwork.io
// From the tests folder, run it with:
//
// go test
//
// Note: This is the exact same test as the Terraform test in ./tests/minimal, so you can see the
// two tests formats alongside each other and pick your favorite one.
// ------------------------------------------------------------------------------------------------
package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

func TestMinimal(t *testing.T) {
	t.Parallel()

	// The universe is vast, let's generate a random ID to name our world
	worldId := random.UniqueId()

	// Input variables
	exampleInput := fmt.Sprintf("Hello world #%s", worldId)

	// Expected outputs
	expectedExampleOutput := exampleInput

	// Copy the terraform folder to a temp folder
	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, "..", ".")

	// Set Terraform options
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: tempTestFolder,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"example_input": exampleInput,
		},
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables.
	outputExampleOutput := terraform.Output(t, terraformOptions, "example_output")

	// Check the output variables have the expected values
	assert.Equal(t, expectedExampleOutput, outputExampleOutput)
}
