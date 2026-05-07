# terraform-google-secret-manager

## Overview

This Terraform module provisions a GCP Secret Manager secret using `google_secret_manager_secret` and stores an initial secret value using `google_secret_manager_secret_version`. It standardises secret provisioning across projects so that these resources do not need to be defined as inline raw resources in each project's deploy configuration.

## Usage

`Basic (automatic replication)`:

```hcl
module "secret" {
  source = "git::https://github.com/nurdsoft/terraform-google-secret-manager.git?ref=v0.1.0"

  project_id  = "my-gcp-project"
  secret_id   = "my-app-secret"
  secret_data = jsonencode({ DB_HOST = "10.0.0.1", DB_NAME = "mydb" })
}
```

`With user-managed replication`:

```hcl
module "secret" {
  source = "git::https://github.com/nurdsoft/terraform-google-secret-manager.git?ref=v0.1.0"

  project_id            = "my-gcp-project"
  secret_id             = "my-app-secret"
  secret_data           = jsonencode({ DB_HOST = "10.0.0.1", DB_NAME = "mydb" })
  replication_type      = "user_managed"
  replication_locations = ["us-central1", "us-east1"]
}
```

`Complete`:

```hcl
module "secret" {
  source = "git::https://github.com/nurdsoft/terraform-google-secret-manager.git?ref=v0.1.0"

  project_id            = "my-gcp-project"
  secret_id             = "my-app-secret"
  secret_data           = jsonencode({ DB_HOST = "10.0.0.1", DB_NAME = "mydb" })
  replication_type      = "user_managed"
  replication_locations = ["us-central1", "us-east1"]

  secret_version_deletion_policy = "DISABLE"

  labels = {
    env  = "production"
    team = "platform"
  }
}
```

## Assumptions

- A basic understanding of [Git](https://git-scm.com/). Git version `>= 2.33.0`.
- An existing GCP IAM user or role with permission to create/update/delete `google_secret_manager_secret` and `google_secret_manager_secret_version` resources.
- [GCloud CLI](https://cloud.google.com/sdk/docs/install) `>= 465.0.0`
- A basic understanding of [Terraform](https://www.terraform.io/). Terraform version `>= 1.3`.

## Test

```sh
gcloud init
gcloud auth application-default login
cd examples/minimal
terraform init
terraform plan
terraform apply
terraform destroy
```

## Contributions

Contributions are always welcome. As such, this project uses the `main` branch as the source of truth to track changes.

**Step 1**. Clone this project.

```sh
# Using Git
$ git clone git@github.com:nurdsoft/terraform-google-secret-manager.git

# Using HTTPS
$ git clone https://github.com/nurdsoft/terraform-google-secret-manager.git
```

**Step 2**. Checkout a feature branch: `git checkout -b feat/abc`.

**Step 3**. Validate the change/s locally by executing the steps defined under [Test](#test).

**Step 4**. If testing is successful, commit and push the new change/s to the remote.

```sh
$ git add file1 file2 ...

$ git commit -m "Adding some change"

$ git push --set-upstream origin feat/abc
```

**Step 5**. Once pushed, create a [PR](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) and assign it to a member for review.

- **Important Note**: It can be helpful to attach the `terraform plan` output in the PR.

**Step 6**. A team member reviews/approves/merges the change/s.

**Step 7**. Once merged, deploy the required changes as needed.

**Step 8**. Once deployed, verify that the changes have been deployed.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |
| google | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | GCP project ID | `string` | n/a | yes |
| secret\_id | The ID of the secret. Must be unique within the project | `string` | n/a | yes |
| secret\_data | The secret payload to store in the secret version | `string` | n/a | yes |
| replication\_type | Replication policy: `automatic` or `user_managed` | `string` | `"automatic"` | no |
| replication\_locations | GCP regions to replicate the secret into. Required when `replication_type` is `user_managed` | `list(string)` | `[]` | no |
| secret\_version\_deletion\_policy | Deletion policy when a secret version is replaced: `DISABLE` keeps it recoverable, `DELETE` permanently removes it, `ABANDON` removes it from Terraform state without destroying it in GCP (import/migration use only) | `string` | `"DISABLE"` | no |
| labels | Labels to apply to the secret | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| secret\_id | The short ID of the secret |
| secret\_name | Full resource name of the secret (`projects/{project}/secrets/{secret_id}`) |
| secret\_version\_id | Full resource name of the secret version (`projects/{project}/secrets/{secret_id}/versions/{version}`) |

## Authors

Module is maintained by [Nurdsoft](https://github.com/nurdsoft).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/nurdsoft/terraform-google-secret-manager/blob/main/LICENSE) for full details.
