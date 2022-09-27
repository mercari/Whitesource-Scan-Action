# Whitesource Scan Using Unified Agent

A Github action which uses the Whitesource Unified Agent to scan a given repository. 

# Description

This Action will auto-resolve dependencies, so no configuration file is required (unless specified).

- This action offers a quick scan of a repository with minimal configuration.
    - **For more advanced use, please include a config file. (See usage below)**
    - If you need to perform some commands beforehand, please also include the path to the script file.

    - Please raise an issue for a specific request e.g. alternative configuration. I will update this over time.
    
For Details Unified Agent configuration, please see the page [Unified Agent Configuration File and Parameters](https://whitesource.atlassian.net/wiki/spaces/WD/pages/804814917/Unified+Agent+Configuration+File+and+Parameters)

# Usage

## Example Usage (Quick Setup without Config File)

Uses the Auto Resolve Dependencies flag.
You must have the Whitesource API key set in your Github secrets. 

```yaml
name: Whitesource Security Scan Example

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3

    - name: Run Whitesource Action
      uses: mercari/Whitesource-Scan-Action@v1.0.0
      with:
        wssUrl: https://app-eu.whitesourcesoftware.com/agent
        apiKey: ${{ secrets.WSS_API_KEY }}
        productName: 'Microservices'
        projectName: 'My-Example-Microservice'

```

## Example Usage (With Config File and optionally install file)

```yaml
name: Whitesource Security Scan Example

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3

    - name: Run Whitesource Action
      uses: mercari/Whitesource-Scan-Action@v1.0.0
      with:
        wssUrl: https://app-eu.whitesourcesoftware.com/agent
        apiKey: ${{ secrets.WSS_API_KEY }}
        configFile: 'whitesource-fs-agent.config'
        extraCommandsFile: 'install_commands.sh' # Optional Extra

```

## Parameter reference

### Inputs

| Input                           | Description                                                  | Required? | Type     | Default Value      |
|---------------------------------|--------------------------------------------------------------|-----------|----------|--------------------|
| `wssURL`                        | The relevent URL to your org's WS Server.                    | yes       | `string` | -                  |
| `apiKey`                        | API key from Whitesource.                                    | yes       | `string` | -                  |
| `productName`                   | Name of the Product that this project falls under            | no        | `string` | My Product         |
| `projectName`                   | Name of the Project. Repository name if not set.             | no        | `string` | {Repository Name}  |
| `configFile`                    | Filename of whitesource configuration (including file path)  | no        | `string` | -                  |
| `extraCommandsFile`             | Filename of a file to run before the scan begins.            | no        | `string` | -                  |
| `failBuildOnPolicyViolations`   | Enables policy violations, fails build if violations found.  | no        | `string` | false              |

## Contributions

Please read the [CLA](https://www.mercari.com/cla/) carefully before submitting your contribution to Mercari. Under any circumstances, by submitting your contribution, you are deemed to accept and agree to be bound by the terms and conditions of the CLA.

## License

Copyright 2022 Mercari, Inc.

Licensed under the MIT License.

## Credits
Originally developed by [TheAxZim/Whitesource-Scan-Action](https://github.com/TheAxZim/Whitesource-Scan-Action)
