# Shelltest
This repository is setup for automated shell script testing using the workflow file from https://github.com/vargiuscuola/gen-sh-unittest.git.

## Automated Testing
The `.github/workflows/gen-sh-unittest.yml` file defines the automated testing process. It triggers on every push using [shunit2](https://github.com/kward/shunit2) and [bash-spec-2](https://github.com/holmesjr/bash-spec-2) unit test frameworks. This will run all unit testing files found in the directory `test` in the root of the repository.

## Usage
Create unit test cases with the syntax of [shunit2](https://github.com/kward/shunit2) and [bash-spec-2](https://github.com/holmesjr/bash-spec-2) unit test frameworks. Store them in one or more script files named `<filename>.shunit2` or `<filename>.bashspec2`, accordingly to the framework used, and residing in a `test` directory on the root of the repository.

### Workflow Details
- **Trigger**: On every push to the repository.
- **Generation**: Generates units test for shell scripts placed in the test directory in the root of the repo.
- **Test Execution**: Frameworks begin on any script appended with .shunit2 in the test directory.
- **Results**: The GitHub Action fails with verbose output referencing the error location/info found in the script.
