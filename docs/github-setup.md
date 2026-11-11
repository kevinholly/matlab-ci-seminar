# GitHub setup and rehearsal

Prepare before the seminar. The 30-minute demonstration starts with Git access,
MATLAB, the project, and a completed baseline workflow already working.

## 1. Verify the local repository

Use a terminal in the repository root:

```sh
git status --short
git branch --list
git tag --list
```

Expect `main` and `solution`, plus the tags `seminar-start`, `seminar-red`, and
`seminar-fixed`. The delivered active branch is `solution`. In MATLAB R2026b,
open the repository folder and run:

```matlab
openProject(pwd)
buildtool package -report artifacts/build-report
```

Confirm five passing tests, open `artifacts/build-report/index.html`, and confirm
`release/CalendarUtilities.mltbx` exists. This verifies the local environment;
a completed GitHub run is a separate check.

## 2. Connect the public repository

The intended URL is
<https://github.com/kevinholly/matlab-ci-seminar>. If it has already been created
and connected, use that repository and skip creation. Check the configured
remote before adding one:

```sh
git remote -v
```

If publication is still pending, create an empty **public** repository at
**GitHub > New repository**. Use the name `matlab-ci-seminar`; leave the initial
README, license, and `.gitignore` options unchecked because these files already
exist locally. Then, if no `origin` is configured:

```sh
git remote add origin https://github.com/kevinholly/matlab-ci-seminar.git
```

Publish the prepared branches and tags:

```sh
git push -u origin main
git push -u origin solution
git push origin seminar-start seminar-red seminar-fixed
```

The push to `main` triggers the active workflow. Pushing `solution` and tags does
not trigger this workflow because its push filter selects only `main`.

Configure GitHub authentication before presenting. In MATLAB R2026b, use
**Home > Connections** to prepare the GitHub connection used by the pull-request
integration. Test fetch/pull/push and pull-request access beforehand. Avoid
displaying credentials during the demonstration; authentication setup is not
part of the timed lesson.

## 3. Validate GitHub Actions

Open **repository > Actions > MATLAB CI**, then the run triggered by the initial
push. Confirm:

- MATLAB setup reports R2026b on the GitHub-hosted Linux runner.
- The `Test and package` job passes with the three baseline tests.
- The job summary contains MATLAB build and test results.
- The run contains `matlab-ci-reports` and `calendar-utilities-toolbox` artifacts.
- Download and extract the reports before opening `build-report/index.html`.
  GitHub stores the artifact; it does not automatically host the HTML as a site.

Under **Actions > MATLAB CI > Run workflow**, select `solution` and run it once
to verify the five-test corrected state and final toolbox on the hosted runner.
Manual dispatch is available because the workflow is present on the default
branch and declares `workflow_dispatch`.

The public base-MATLAB example requires no MATLAB license secret. If changing to
a private repository or adding transformation products, review the
[MathWorks licensing instructions](https://github.com/matlab-actions/setup-matlab#licensing)
before relying on the same workflow. MATLAB batch tokens belong in GitHub
Actions secrets and map to `MLM_LICENSE_TOKEN`.

## 4. Make checks visible at the merge decision

For the full teaching story, configure a rule for `main` under
**repository > Settings > Rules > Rulesets**:

- Require a pull request before merging.
- Require the `Test and package` status check after it has appeared in a run.
- For this solo demonstration, do not require another person's approval.

Use the exact check name shown by GitHub if the UI qualifies it with the workflow
name. Review the rule on a rehearsal pull request. A failed workflow does not
block merging by itself; the required-check rule creates that gate. Without
permission to configure repository rules, explain that distinction and inspect
the check result without claiming GitHub prevents a merge.

## 5. Rehearse the demonstration

Keep `main` at the teaching baseline until the live demonstration. Start a
separate rehearsal branch from `main` and follow the
[demo walkthrough](demo-walkthrough.md), using `rehearsal/century-year` instead
of `demo/century-year`. Close that rehearsal pull request without merging it.
Bookmark its failed and successful runs and download both report artifacts.

Immediately before presenting, ensure the working tree is clean and return to
the baseline:

```sh
git switch main
git pull --ff-only origin main
```

Confirm three passing baseline tests. Open these windows or browser tabs:

- MATLAB: Project, source, tests, `matlab.toml`, and `buildfile.m`.
- GitHub: repository files, Actions baseline run, and rehearsal red/green runs.
- A local downloaded build report and the packaged toolbox.

Run the entire demonstration against the conference network when possible.
Measure actual runner setup time during rehearsal; use that time for the YAML
and licensing explanation. Keep a short screen recording or screenshots of the
rehearsal in case network access or the hosted runner is delayed.

## Repeat safely

For another rehearsal before merging, start a new uniquely named branch from
the unchanged `main`. After the live fix is merged, use a new demo repository to
repeat the complete `main`-targeted workflow unchanged. For local-only practice,
start a fresh branch from `seminar-start`:

```sh
git switch -c practice/century-year-2 seminar-start
```

Do not force-push or reset the shared `main` branch. A fresh branch from an old
tag is useful for local practice, but opening a pull request against an already
fixed `main` will not recreate the original exercise.
