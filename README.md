# CDKTF CLI Custom Action

This action will provide a wrapper around cdktf cli to make its use easier within other GitHub Actions workflows.

It supports plan and deploy options. Plan option will also check the drift status of deployed resources and won't proceed if a drift is detected.

## Parameters
There are two parameters required to use this action:
* `workdir`: Relative path of CDK code you want to work with. Default value is `.` meaning that it will use the root of your repository you checked in before this action run.
* `action`: The action you want to take. (Supported options are: `plan` and `deploy`)


## Outputs
This action generates two different types of outputs. One within the Github Actions context and the other one as a file which contains the outputs of CDK operation that's been run.
Plan option will generate a `plan.out` file that you can find at the workdir you passed as an argument. (Or root of your repo if you haven't explicitly pass a workdir.)
Similarly deploy option will generate a `deploy.out` at the same location.

The output in actions context is `drift-status` and can either `DRIFTED` or `IN-SYNC`.

## Example

```
- name: CDK Plan
  id: plan
  uses: infrastructure/cdktf-cli@v0.0.1
    with:
      workdir: ${{ inputs.acccount_id }}
      action: plan
- name: Drift result
  run: echo "${{ steps.plan.outputs.drift-status }}"
```