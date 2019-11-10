# Purpose
Python `unittest` std. library module tests for:
* environmental,
* helper code 
* arg parsing (TODO)

Other items are best maintained / testing by directly using the tool
against a target account.

## Usage
```
cicdenv$ . bin/activate
cicdenv$ cicdctl test
...
```

This scans all modules under `tests/test`.

## Running Test Sub Sets
```
cicdenv$ . bin/activate

# Test Single Class
cicdenv$ cicdctl test aws.test_credentials.TestMfaCodeGenerator
.
----------------------------------------------------------------------
Ran 1 test in 0.666s

OK

# Test Single Method
cicdenv$ cicdctl test aws.test_credentials.TestMfaCodeGenerator.test_next
Waiting for next mfa-code ...
.
----------------------------------------------------------------------
Ran 1 test in 8.523s

OK

```

## Repo Organization
The `tests` top-level folder is added to `PYTHONPATH` by the `test` sub-command.

Within this folder is a parallel set of packages under the `test` package.
These should self load in their respective `__init__.py` module initializers.

The individual test modules should match their lib code counterparts with a `test_` filename prefix.

Example:
```
module: aws.credentials

code:        lib/aws/     credentials.py
test: tests/test/aws/test_credentials.py
```
