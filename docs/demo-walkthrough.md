# 30-minute GitHub Actions demonstration

Begin with the prepared public repository, working authentication, a clean
working tree on `main`, three passing baseline tests, and a completed baseline
GitHub run. Use the [setup checklist](github-setup.md) before presenting.

The story: an apparently healthy project misses a real edge case. A regression
test makes the missing behavior visible in CI. Correcting the implementation
turns the check green and makes a toolbox available for download.

## 0:00-4:00 — Open the project and run the same local build

In MATLAB, open the repository as a Project. If using the Command Window from
the repository root:

```matlab
openProject(pwd)
buildtool package -report artifacts/build-report
```

Show the three passing tests and `release/CalendarUtilities.mltbx`. State that
the baseline contains a deliberate gap in its leap-year rule; green means the
current tests passed. The next change will make that gap explicit.

Open `matlab.toml` and point to the project path and package metadata. Show
`src/dayofyear.m` and `tests/DayOfYearTest.m`. Explain the ISO input with a normal
example:

```matlab
dayofyear("2026-01-01")
```

Expected result: `1`. Projects make the path and project configuration
reproducible when a teammate or CI runner opens the repository.

## 4:00-8:00 — Read the automation files

Open `buildfile.m`: identify the check, test, and package tasks and their
dependencies. The command `buildtool package` runs prerequisite checks and
tests; a test failure prevents the package task from running.

Open `.github/workflows/ci.yml` and read from the outside in:

| YAML element | Explain while pointing at the file |
| --- | --- |
| `name` | The workflow label in GitHub |
| `on` | Events: push to `main`, pull request into `main`, or manual run |
| `jobs` | A job is scheduled on a runner |
| `runs-on` | The machine running the job, here `ubuntu-latest` |
| `steps` and `-` | An ordered list of steps within that job |
| `uses` | A reusable action and its version |
| `with` | Inputs to that action, including `release: R2026b` |
| `if: always()` | Keep reports even when an earlier step failed |

Indentation expresses nesting; use spaces. Explain that `.yml` and `.yaml` both
name YAML files, and GitHub looks in `.github/workflows/`. The job is configured
in YAML, but `buildfile.m` keeps the MATLAB automation reusable locally.

Show `docs/minimal-tests.yml.example` briefly only if the audience needs the
simplest starting point. It runs tests directly with `run-tests@v3`; it is not
an active second workflow. Return to the single build workflow used by the demo.

## 8:00-14:00 — Add an edge-case test and open a pull request

Create `demo/century-year` from `main` using MATLAB's Git branch controls. Terminal
equivalent, with a clean working tree:

```sh
git switch -c demo/century-year main
```

Open `tests/DayOfYearTest.m` and add this method inside `methods (Test)`:

```matlab
function century1900March1(testCase)
    testCase.verifyEqual(dayofyear("1900-03-01"),60)
end
```

Explain arrange/act/assert using the input, function call, and expected value.
1900 was divisible by 100 but not 400, so it was not a leap year. Run locally:

```matlab
buildtool test
```

Expect four tests, with the new test failing because the current implementation
returns `61`. Review the failed expectation and the diff. This intentional red
commit lets attendees see the same diagnostic on the remote runner.

Use MATLAB's Git controls to stage the test file, commit, and push. The exact
terminal equivalent is:

```sh
git add tests/DayOfYearTest.m
git commit -m "Add regression test for century years"
git push -u origin demo/century-year
```

In MATLAB R2026b, use **Push Changes dialog > Create Pull Request**. Select the
GitHub remote and base branch `main`; use the title **Handle century years
correctly**. Explain the source branch and target branch. If the connection is
unavailable, use **GitHub repository > Pull requests > New pull request** with
base `main` and compare `demo/century-year`.

The pull-request event starts CI. The earlier branch push alone does not,
because this workflow's push filter selects only `main`.

To find the pull request again inside MATLAB, use **Source Control panel > More
source control options > Pull Requests**, or right-click the Files/Project panel
and choose **Source Control > Pull Requests**.

## 14:00-19:00 — Inspect the failed check

Open **pull request > Checks > Test and package** or follow the check's
**Details** link to the Actions run. Point out checkout, MATLAB setup, and the
build step. While the runner starts, recap local Git versus remote GitHub, and
continuous integration versus delivery/deployment.

Show the failed test and expected/actual values in the job summary or logs.
Confirm the package task did not run. Download `matlab-ci-reports`, extract it,
and open `build-report/index.html` to inspect the build report. The failed run
must not have a `calendar-utilities-toolbox` artifact.

If the required-check rule is enabled, show why the pull request cannot yet be
merged. Distinguish that repository rule from the workflow's test failure.

## 19:00-25:00 — Fix the implementation and get a green check

In `src/dayofyear.m`, change the leap-year rule to follow the Gregorian calendar:
a year is a leap year if divisible by 4, except years divisible by 100, unless
also divisible by 400. Replace the existing leap-year `if` block with:

```matlab
if mod(dateValue.Year,4) == 0 && ...
        (mod(dateValue.Year,100) ~= 0 || mod(dateValue.Year,400) == 0)
    daysPerMonth(2) = 29;
end
```

Add the complementary test inside `methods (Test)`:

```matlab
function century2000March1(testCase)
    testCase.verifyEqual(dayofyear("2000-03-01"),61)
end
```

Run the full build locally:

```matlab
buildtool package -report artifacts/build-report
```

Expect five passing tests and a toolbox. Review both file diffs in MATLAB, then
stage, commit, and push using its Git controls. Terminal equivalent:

```sh
git add src/dayofyear.m tests/DayOfYearTest.m
git commit -m "Handle Gregorian century-year exceptions"
git push
```

The open pull request gets a new workflow run automatically. Show the new commit
on the same pull request, then the green test and build summaries. Download the
new `calendar-utilities-toolbox` artifact and show `CalendarUtilities.mltbx`.
The artifact is attached to the workflow run; no GitHub Release or deployment
has occurred.

## 25:00-28:00 — Merge, pull, and close the collaboration loop

After the required checks pass, use **GitHub pull request > Merge pull request**
and confirm the merge. Return to MATLAB, switch to `main`, and use **Pull** to
bring the merged change into the local repository. Terminal equivalent:

```sh
git switch main
git pull --ff-only origin main
```

Show the corrected source and five tests on local `main`. The merge also pushes
a new commit to remote `main`, triggering the workflow again. There is no need
to wait for that duplicate verification to teach another concept.

## 28:00-30:00 — Connect the lesson to R2026b

Point back to what the audience has seen:

- `matlab.toml`: R2026b text-based Project/package configuration.
- `PackageTask`: R2026b standard task for the toolbox built here.
- `-report artifacts/build-report`: R2026b build report used to inspect results.
- Optional next step: R2026b `-outputCache` plus the build action's `cache: true`
  preserves task outputs across builds. This is different from caching the MATLAB
  installation, and it is not enabled in this introductory workflow.

The build tool dates to R2022b; Git integration and unit tests are established
capabilities. Mention `type-size` coverage only as an optional R2026b MATLAB Test
feature, since the demonstration requires base MATLAB only.

## Recovery without changing the lesson

- **Runner or network is slow:** open the bookmarked rehearsal run with the same
  test state; say it was recorded during rehearsal. Continue the edit and local
  build live, then revisit the new run if it completes.
- **Authentication or pull-request integration fails:** use the prepared GitHub
  browser session and terminal equivalents. Do not spend the demonstration
  debugging authentication.
- **Local edits make branch switching unsafe:** stop switching; inspect
  `git status` and preserve the edits. Use the prepared solution checkout or
  recorded run to finish the explanation. Do not reset or force-push.
- **Time is short:** prioritize failed test, fix, green check, and toolbox.
  Skip the minimal-YAML comparison and optional caching discussion.

After the live merge, preserve shared history. Use a new repository for another
complete live cycle, or a fresh branch from `seminar-start` for local practice.
