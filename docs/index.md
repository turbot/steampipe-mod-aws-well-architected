---
repository: "https://github.com/turbot/steampipe-mod-aws-well-architected"
---

# AWS Well-Architected Mod

Run controls across all of your AWS accounts to check if they are following AWS Well-Architected Framework best practices.

<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-aws-well-architected/main/docs/aws_well_architected_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-aws-well-architected/main/docs/aws_well_architected_reliability_pillar_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-aws-well-architected/main/docs/aws_well_architected_security_pillar_dashboard.png" width="50%" type="thumbnail"/>

## References

[AWS](https://aws.amazon.com/) provides on-demand cloud computing platforms and APIs to authenticated customers on a metered pay-as-you-go basis.

[AWS Well-Architected](https://aws.amazon.com/architecture/well-architected/) helps cloud architects build secure, high-performing, resilient, and efficient infrastructure for a variety of applications and workloads.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.

## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/aws_well_architected/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/aws_well_architected/queries)**

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

Install the AWS plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install aws
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-aws-well-architected.git
cd steampipe-mod-aws-well-architected
```

Install all dependent mods:

```sh
steampipe mod install
```

### Usage

Before running any benchmarks, it's recommended to generate your AWS credential report:

```sh
aws iam generate-credential-report
```

Start your dashboard server to get started:

```sh
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser
window at https://localhost:9194. From here, you can run benchmarks by
selecting one or searching for a specific one.

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `steampipe check` command:

Run all benchmarks:

```sh
steampipe check all
```

Run a single benchmark:

```sh
steampipe check benchmark.security
```

Run a benchmark for a specific pillar:

```sh
steampipe check benchmark.security
```

Run a benchmark for a specific pillar best practice:

```sh
steampipe check benchmark.security_1
```

Different output formats are also available, for more information please see
[Output Formats](https://steampipe.io/docs/reference/cli/check#output-formats).

### Credentials

This mod uses the credentials configured in the [Steampipe AWS plugin](https://hub.steampipe.io/plugins/turbot/aws).

### Configuration

No extra configuration is required.

### Common and Tag Dimensions

The benchmark queries use common properties (like `account_id`, `connection_name` and `region`) and tags that are defined in the dependent [AWS Compliance mod](https://github.com/turbot/steampipe-mod-aws-compliance). These properties can be executed in the following ways:

- Copy and rename the `steampipe.spvars.example` file to `steampipe.spvars`, and then modify the variable values inside that file

- Pass in a value on the command line:

  ```shell
  steampipe check benchmark.security --var 'common_dimensions=["account_id", "connection_name", "region"]'
  ```

  ```shell
  steampipe check benchmark.security --var 'tag_dimensions=["Environment", "Owner"]'
  ```

## Contributing

If you have an idea for additional controls or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join our Slack community →](https://steampipe.io/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-aws-well-architected/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [AWS Well-Architected Mod](https://github.com/turbot/steampipe-mod-aws-well-architected/labels/help%20wanted)
