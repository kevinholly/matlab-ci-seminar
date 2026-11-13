# Continuous Integration with MATLAB R2026b

Learn how to use GitHub Actions to check MATLAB code, run tests, and build a
downloadable toolbox. Follow a code change from local testing through a GitHub
pull request, and explore how MATLAB Projects, TOML configuration, build tasks,
and YAML workflows work together.

The example calculates the day number within a year from an ISO date string:

```matlab
dayofyear("1900-03-01")
```

The correct result is `60`. The starting version deliberately returns `61`
because its leap-year rule omits the century exception. Adding a regression test
exposes the defect; correcting the rule makes the test pass. This illustrates
why a passing test suite can still miss important cases.

## Start locally

Use MATLAB R2026b. The example requires base MATLAB; MATLAB Test, MATLAB Compiler,
and MATLAB Coder are not required.

To start with the complete implementation, clone the `solution` branch:

```sh
git clone --branch solution https://github.com/kevinholly/matlab-ci-seminar.git
cd matlab-ci-seminar
```

Open the repository folder in MATLAB, then run:

```matlab
openProject(pwd)
buildtool package -report artifacts/build-report
```

`buildtool` runs code analysis and tests before packaging. The solution has
five passing tests. Generated files include the build report at
`artifacts/build-report/index.html` and the toolbox at
`release/CalendarUtilities.mltbx`. Generated files stay out of source control.

## Explore the example versions

Compare the checkpoints to see how a new test reveals a defect and how the fix
changes the build result. Use `solution` for the complete implementation.

| Branch or tag | Meaning | Expected tests |
| --- | --- | --- |
| `seminar-start` | Starting implementation with the intentional century-year defect | 3 pass |
| `seminar-red` | Add the 1900 regression test to expose the defect | 3 pass, 1 fail |
| `solution`, `seminar-fixed` | Correct Gregorian rule and add the year-2000 safeguard | 5 pass |

The tags preserve each checkpoint as the repository evolves. To work through
the example yourself, create a branch from `seminar-start`, add the 1900 test,
and then implement the fix and the year-2000 safeguard.

## Four files with different jobs

| File | Responsibility |
| --- | --- |
| `matlab.toml` | Project configuration and package metadata |
| `buildfile.m` | MATLAB automation: check, test, and package |
| `.github/workflows/ci.yml` | GitHub events, runner, setup, build invocation, and artifact upload |
| `tests/DayOfYearTest.m` | Executable examples of expected behavior |

Source lives in `src/dayofyear.m`. The Project makes the source available on the
MATLAB path. YAML orchestrates the runner; the MATLAB build file defines the
work; tests determine whether the behavior meets expectations.

## GitHub Actions workflow

The workflow is configured for pushes to `main`, pull requests into `main`, and
manual requests. It uses a GitHub-hosted Linux runner with MATLAB
R2026b, invokes the same build as the local command, uploads reports even when
tests fail, and uploads the toolbox only after success. Creating a local branch
does not run CI. The pull-request trigger covers opening the pull request and
pushing subsequent changes to it.

Read the [complete workflow](.github/workflows/ci.yml), or compare it with the
[minimal test-only YAML](docs/minimal-tests.yml.example), which calls
`run-tests` directly. The minimal example is kept outside the workflows folder
so it does not create a second active workflow.

Successful runs provide a toolbox artifact for download. Publishing a release
or deploying that artifact would be a further step in a delivery pipeline.

## What's new in R2026b

R2026b adds TOML-based project and package configuration, declared project test
folders, the built-in `PackageTask`, HTML build reports, and task output caching.
The Connections and Pull Requests panels support working with GitHub from MATLAB.

The MATLAB build tool itself was introduced in R2022b. R2025a improved automatic
project opening, including builds located in project subfolders. GitHub action
version updates are independent of MATLAB release features.

The optional `type-size` coverage metric is new in R2026b and requires MATLAB
Test. This example uses statement coverage, which is available in base MATLAB.

## Licensing and references

For a public repository, the MathWorks actions automatically license ordinary
MATLAB products for CI. Transformation products such as MATLAB Compiler and
MATLAB Coder require additional licensing. Private repositories also require
licensing, commonly a MATLAB batch licensing token stored as a GitHub secret and
mapped to `MLM_LICENSE_TOKEN`. A locally licensed MATLAB installation does not by
itself configure a GitHub-hosted runner's license.

- [MathWorks CI configuration examples](https://github.com/mathworks/ci-configuration-examples)
- [MATLAB and GitHub Actions workshop](https://github.com/mathworks/ci-with-matlab-and-github-actions-workshop)
- [Set up MATLAB: releases and licensing](https://github.com/matlab-actions/setup-matlab)
- [Run MATLAB tests: reports and coverage](https://github.com/matlab-actions/run-tests)
- [Run MATLAB builds](https://github.com/matlab-actions/run-build)
- [MATLAB R2026b release notes](https://www.mathworks.com/help/releases/R2026b/matlab/release-notes.html)
- [R2026b matlab.toml reference](https://www.mathworks.com/help/releases/R2026b/matlab/ref/matlab.toml.html)
- [R2026b buildtool reference](https://www.mathworks.com/help/releases/R2026b/matlab/ref/buildtool.html)

The date-calculation example is adapted from the MathWorks CI examples and uses
a smaller ISO-date interface. See [LICENSE](LICENSE) for the inherited MathWorks
redistribution terms; a copy in `src/` accompanies the toolbox.
