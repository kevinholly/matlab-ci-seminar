# Continuous Integration with MATLAB R2026b

A seminar example for a 60-minute beginner session: 25 minutes of slides,
30 minutes of demonstration, and 5 minutes of questions. Follow one change from
MATLAB, through Git and a GitHub pull request, to automated checks, tests, and a
downloadable toolbox.

The example calculates the day number within a year from an ISO date string:

```matlab
dayofyear("1900-03-01")
```

The correct result is `60`. The prepared teaching baseline deliberately returns
`61` for this case: its leap-year rule considers divisibility by four but omits
the century exception. The lesson is that passing tests establish the behaviors
you tested; they do not establish that every input is correct.

## Start locally

Use MATLAB R2026b. The main example needs base MATLAB; it does not require
MATLAB Test, MATLAB Compiler, or MATLAB Coder. Open this repository folder in
MATLAB, then run:

```matlab
openProject(pwd)
buildtool package -report artifacts/build-report
```

`buildtool` runs the task dependencies before packaging. The final solution has
five passing tests. Generated files include the build report at
`artifacts/build-report/index.html` and the toolbox at
`release/CalendarUtilities.mltbx`. Generated files stay out of source control.

## Prepared teaching states

The delivered checkout is `solution`, so opening the repository starts with
correct code. Switch to `main` during presenter preparation to begin the lesson.

| Branch or tag | Meaning | Expected tests |
| --- | --- | --- |
| `main`, `seminar-start` | Starting implementation with the intentional century-year defect | 3 pass |
| `seminar-red` | Add the 1900 regression test to expose the defect | 3 pass, 1 fail |
| `solution`, `seminar-fixed` | Correct Gregorian rule and add the year-2000 safeguard | 5 pass |

Tags preserve the prepared states. After the live pull request is merged, `main`
will contain the corrected implementation. For another presentation, use a new
repository or a fresh branch from `seminar-start`; do not rewrite shared history.

## Four files with different jobs

| File | Responsibility |
| --- | --- |
| `matlab.toml` | Project configuration and package metadata |
| `buildfile.m` | MATLAB automation: check, test, and package |
| `.github/workflows/ci.yml` | GitHub events, runner, setup, build invocation, and artifact upload |
| `tests/DayOfYearTest.m` | Executable examples of expected behavior |

Source lives in `src/dayofyear.m`. The Project makes the source available on the
MATLAB path. YAML orchestrates the runner; the MATLAB build file defines the
work; tests determine whether the behavior meets expectations. TOML is project
configuration, not a second GitHub workflow.

## Run the seminar

- [GitHub setup and rehearsal](docs/github-setup.md): publish a public repository,
  enable the workflow, and prepare the demonstration.
- [30-minute demo walkthrough](docs/demo-walkthrough.md): presenter actions,
  observations, and recovery steps.
- [Minimal test-only YAML](docs/minimal-tests.yml.example): a shorter teaching
  example. Its location and extension keep it inactive.

There is one active workflow. It runs for pushes to `main`, pull requests into
`main`, and manual requests. It uses a GitHub-hosted Linux runner with MATLAB
R2026b, invokes the same build as the local command, uploads reports even when
tests fail, and uploads the toolbox only after success. Creating a local branch
does not run CI. Opening its pull request starts the first branch check; later
pushes to that open pull request trigger new checks.

The final artifact demonstrates a build ready for delivery. This repository does
not publish a GitHub Release, deploy software, or install the toolbox on another
machine automatically.

## R2026b talking points

The presentation distinguishes features introduced in R2026b from established
workflows. R2026b topics include TOML-based project/package configuration, the
package build task, build reports, and task output caching. The MATLAB build tool
itself was introduced in R2022b; automatic opening of a build file's project
dates to R2025a. GitHub action version updates are independent of MATLAB release
features.

The optional `type-size` coverage metric is new in R2026b and requires MATLAB
Test. It is not enabled in this base-MATLAB example. Statement and function
coverage are sufficient for the introductory discussion.

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

The date-calculation teaching idea comes from the MathWorks CI examples. This
repository uses a smaller ISO-date interface for the seminar. The build creates
local artifacts; GitHub runs and publication must be verified separately during
rehearsal. See [LICENSE](LICENSE) for the inherited MathWorks redistribution
terms; a copy in `src/` accompanies the toolbox.
