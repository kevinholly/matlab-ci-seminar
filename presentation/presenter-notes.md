# Presenter notes — Continuous Integration with MATLAB

Audience: MATLAB users new to CI. Demo: public GitHub repository, base MATLAB, R2026b.

The slide deck is `Continuous-Integration-with-MATLAB.pptx` or the offline `slides.html`.
PowerPoint speaker notes contain these slide-specific notes and source links.

## 1. Continuous Integration with MATLAB

**Timing: 00:00–01:00**

Open with the outcome: by the end, attendees can explain what a CI workflow does,
read its YAML, and connect MATLAB tests and a project to GitHub Actions.
The running example is intentionally small so the workflow stays visible.
This is a 25-minute introduction, a 30-minute guided demo, then 5 minutes of Q&A.

## 2. A change should come with evidence

**Timing: 01:00–03:00**

Ask for a show of hands: who has heard 'it works on my machine'?
Name three common causes: files were not committed, the path or environment differs,
or an important input was never tested. CI creates a repeatable check after a change.
It does not replace engineering judgment or good tests. It makes their execution routine.
Success today means following one small change all the way to a downloadable package.

## 3. CI and CD describe different steps

**Timing: 03:00–06:00**

CI is the practice of integrating changes frequently and checking them automatically.
In this seminar those checks include static analysis and automated MATLAB tests.
Continuous delivery keeps validated changes ready to release, with a human release decision.
Continuous deployment automatically deploys successful changes to the target environment.
A downloadable toolbox demonstrates a useful build artifact. Do not describe artifact
creation alone as a complete continuous-delivery system, or as deployment to production.

## 4. Follow one change through the system

**Timing: 06:00–07:00**

Trace the boxes left to right. MATLAB and Git are where the change is prepared.
The pull request is the review surface. GitHub Actions schedules the runner.
The runner checks out the committed revision, starts the selected MATLAB release,
and runs the build. Reports and the toolbox are outputs from that revision.
A required successful check can gate merging. We configure that gate before the demo.

## 5. Git records changes. Actions runs checks.

**Timing: 07:00–10:00**

Explain the commands in terms of where data moves. Commit records a local snapshot;
push sends committed changes to the remote. Pull brings remote changes into the local branch.
A branch isolates a line of work. A pull request proposes integrating that branch.
Actions is automation attached to events, such as opening or updating a pull request.
We will compare, commit, and push in MATLAB; inspect the Actions results in GitHub;
then merge in GitHub and pull the merged result into MATLAB.
General Git operations are established MATLAB features. Connections and the Pull Requests
panel are specific R2026b additions that we show later.

Sources:

- https://www.mathworks.com/help/releases/R2026b/matlab/matlab_prog/connect-github-from-matlab.html
- https://www.mathworks.com/help/releases/R2026b/matlab/matlab_prog/review-pull-requests-in-matlab.html

## 6. A test states expected behavior

**Timing: 10:00–13:00**

Read the test aloud. Arrange the input, act by calling the public function,
then verify the expected result. A MATLAB test class derives from matlab.unittest.TestCase.
The Test attribute identifies methods to run. verifyEqual reports a failed expectation.
Use known values and boundary cases. For numerical computations, choose tolerances
appropriate to the requirement; this example returns an integer day count.
Tests should be independent and deterministic. Coverage helps find unexecuted code;
it does not tell us that all important inputs or requirements were tested.
Keep the century-year test as the reveal in the live demo, not on this first test slide.

Sources:

- https://github.com/matlab-actions/run-tests

## 7. Three files, three responsibilities

**Timing: 13:00–15:00**

These files work together rather than replace one another.
matlab.toml describes the project: source paths, test folders, dependencies, and package metadata.
buildfile.m is MATLAB code defining tasks and their dependencies.
The GitHub workflow YAML says when and where those tasks run.
Commit all three with the source and tests. Keep generated reports and packages out of Git.
The central portability point is that local MATLAB and GitHub call the same build.

Sources:

- https://www.mathworks.com/help/releases/R2026b/matlab/ref/matlab.toml.html
- https://www.mathworks.com/help/releases/R2026b/matlab/ref/buildtool.html
- https://github.com/matlab-actions/run-build

## 8. A readable project definition

**Timing: 15:00–17:00**

Explain TOML syntax: key = value, quoted strings, arrays, [table], and [[array of tables]].
Show that src goes on the project path and tests identifies project test folders.
Opening the TOML project establishes the shared project context; project-aware test discovery
uses the declared test folders. All files beneath a TOML project root are project files.
The package section adds a name, version, stable UUID, source root, and output location.
The real demo file contains the complete package metadata; the slide is a project-only excerpt.
Dependencies can also be declared in TOML. This introductory repository needs no external packages.
R2026b still defaults new projects to XML metadata unless Settings > MATLAB > Project >
Project definition files is changed to matlab.toml. We prepare a TOML project explicitly.

Sources:

- https://www.mathworks.com/help/releases/R2026b/matlab/ref/matlab.toml.html
- https://www.mathworks.com/help/releases/R2026b/matlab/matlab_prog/identify-and-run-tests-in-projects.html

## 9. Read YAML from the outside in

**Timing: 17:00–20:00**

Walk through the nesting: name, event triggers, jobs, the runner, and ordered steps.
Indentation expresses structure. Use spaces, not tabs. A dash begins a list item.
uses invokes an action; with supplies that action's inputs. run executes shell commands.
Pin the MATLAB release so a new release does not silently change the demonstration.
The slide omits artifact uploads for legibility; the complete runnable workflow includes them.
The main demo uses run-build so the MATLAB build plan owns test and package ordering.
The appendix shows run-tests as a smaller starting point when a project has only tests.
Action version changes are independent of MATLAB release changes; these versions were
verified in official repositories while preparing the seminar in November 2026.

Sources:

- https://github.com/matlab-actions/setup-matlab
- https://github.com/matlab-actions/run-build

## 10. What R2026b adds to this workflow

**Timing: 20:00–23:00**

Separate new capabilities from established workflows. R2026b adds TOML project definitions
and project test folders, Connections and Pull Requests integration, PackageTask for package
creation, and HTML build reports through buildtool -report followed by a folder argument.
The build report entry point in the demo is artifacts/build-report/index.html.
Additional R2026b features include task output caching and runtests(...,UseTestBrowser=true).
Cache behavior is an advanced follow-up, not necessary for the first demonstration.
The build tool itself was introduced in R2022b. Projects, unit testing, and Git are established.
Do not label current GitHub action versions as features of the MATLAB release.

Sources:

- https://www.mathworks.com/help/releases/R2026b/matlab/release-notes.html
- https://www.mathworks.com/help/releases/R2026b/matlab/ref/matlab.toml.html
- https://www.mathworks.com/help/releases/R2026b/matlab/ref/matlab.buildtool.tasks.packagetask-class.html
- https://www.mathworks.com/help/releases/R2026b/matlab/ref/buildtool.html
- https://www.mathworks.com/help/releases/R2026b/matlab/matlab_prog/review-pull-requests-in-matlab.html

## 11. Choose the runner and check licensing

**Timing: 23:00–25:00**

GitHub-hosted runners give us a clean, disposable environment. A self-hosted runner can use
an existing properly licensed MATLAB installation and access local resources.
Official MATLAB integrations also support workflows in Jenkins and Azure DevOps; examples
cover other CI systems including GitLab. The portable asset is the MATLAB build command.
For this public repository, base MATLAB is within the setup-matlab automatic licensing policy.
Do not generalize this to every public workflow. Private repositories and transformation
products such as MATLAB Coder or MATLAB Compiler require additional arrangements.
A batch licensing token, when required, belongs in a GitHub secret and is exposed through
MLM_LICENSE_TOKEN. Never display credentials live. Connections is already authenticated.
Statement coverage and creating a .mltbx need neither MATLAB Test nor MATLAB Compiler.
Verify the official licensing documentation close to delivery; policies can change.

Sources:

- https://github.com/matlab-actions/setup-matlab
- https://www.mathworks.com/help/releases/R2026b/matlab/ref/matlab.buildtool.tasks.testtask-class.html
- https://www.mathworks.com/help/releases/R2026b/matlab/ref/matlab.buildtool.tasks.packagetask-class.html
- https://github.com/mathworks/ci-configuration-examples

## 12. Live demo: make the checks tell a story

**Timing: 25:00–55:00**

Switch to MATLAB and follow presenter-notes.md or the repository's demo walkthrough.
25–29: open the TOML project, show Connections, pull main, inspect the source/tests,
and run buildtool package -report artifacts/build-report. Three baseline tests pass.
29–33: explain the build task dependencies and ci.yml; inspect a baseline GitHub run.
33–39: branch demo/century-year, add the 1900 test, run locally, compare, commit, push,
and create a draft PR from MATLAB. Expected result 60; incomplete rule returns 61.
39–44: inspect the failed CI test and preserved reports. Packaging is skipped.
44–50: fix the rule and add the 2000 test, run locally, commit, push, and inspect green
checks, coverage, the HTML build report, and the downloadable toolbox.
50–53: mark the PR ready, merge in GitHub, switch to main in MATLAB and pull.
53–55: recap the R2026b capabilities the audience has just seen.
The delivered local solution branch has the complete implementation. Before rehearsal,
switch to the prepared main baseline; tags seminar-start, seminar-red, and seminar-fixed
are reference states. Do not merge the rehearsal branch into main before the live demo.
If a runner is still queued after a minute, use the corresponding bookmarked rehearsal run.
Keep the local edit and test activity live and return to the new run when it is ready.

Sources:

- https://github.com/mathworks/ci-configuration-examples
- https://www.mathworks.com/help/releases/R2026b/matlab/matlab_prog/review-pull-requests-in-matlab.html

## 13. Start with one useful test and one workflow

**Timing: 55:00–60:00**

Invite questions about the first step attendees would take on their own projects.
Reinforce three ideas: tests express intended behavior, project/build configuration makes
the work repeatable, and GitHub Actions executes the same build after a change.
The published demo repository is https://github.com/kevinholly/matlab-ci-seminar.
The draft rehearsal PR is https://github.com/kevinholly/matlab-ci-seminar/pull/1.
Publication is verified; use the repository verification record to check hosted-run status.
Useful follow-ups: Simulink tests, multi-release matrices, task caching, MEX compilation,
code generation, and a separately designed release/deployment workflow.
The appendix contains starter YAML, the build definition, the century fix, and references.

Sources:

- https://github.com/kevinholly/matlab-ci-seminar
- https://github.com/kevinholly/matlab-ci-seminar/pull/1
- https://github.com/mathworks/ci-configuration-examples
- https://github.com/mathworks/ci-with-matlab-and-github-actions-workshop
- https://www.mathworks.com/help/releases/R2026b/matlab/release-notes.html

## 14. The smallest useful test workflow

**Timing: Reference**

This is an alternative starting point, not a second active workflow in the demo repository.
It runs tests directly, so it does not demonstrate the complete check/test/package plan.
The real demo uses run-build. Keep this sample outside .github/workflows to avoid duplicate runs.
source-folder adds the source location; select-by-folder selects the tests.
The workflow demonstrates release selection and manual/pull-request triggers.
Add result upload steps when turning the starter into a team workflow.

Sources:

- https://github.com/matlab-actions/run-tests
- https://github.com/matlab-actions/setup-matlab

## 15. Keep reports when a build fails

**Timing: Reference**

These steps follow checkout and setup-matlab in the actual workflow.
The build-options string matches the local command exactly. The -report flag requires a folder.
Upload the full report directory, not only index.html, because reports can use supporting files.
if: always() preserves available diagnostics even after a failed build.
The package upload uses the normal successful-step condition. Failed tests stop PackageTask.
Generated artifacts and release outputs are excluded from source control.
A .mltbx is a MATLAB package/toolbox installer, not a standalone executable.

Sources:

- https://github.com/matlab-actions/run-build
- https://www.mathworks.com/help/releases/R2026b/matlab/ref/buildtool.html
- https://www.mathworks.com/help/releases/R2026b/matlab/ref/matlab.buildtool.tasks.packagetask-class.html

## 16. MATLAB owns the task dependencies

**Timing: Reference**

CodeIssuesTask uses the factory analyzer configuration for consistency; errors fail the task.
Warnings remain visible. TestTask discovers the tests declared by the current project.
Statement coverage is explicitly selected so a local MATLAB Test license does not change
the chosen coverage metric. The HTML/JUnit outputs and package output are build artifacts.
PackageTask reads the [[package]] TOML section; its dependency ensures tests pass first.
buildtool opens the containing project automatically before evaluating the build file.
This is the build composition from the repository; source comments are omitted on the slide.

Sources:

- https://www.mathworks.com/help/releases/R2026b/matlab/ref/matlab.buildtool.tasks.testtask-class.html
- https://www.mathworks.com/help/releases/R2026b/matlab/ref/matlab.buildtool.tasks.packagetask-class.html
- https://www.mathworks.com/help/releases/R2026b/matlab/ref/buildtool.html

## 17. A boundary case changes the requirement

**Timing: Reference**

The original teaching baseline uses divisibility by four alone. It predicts 61 for
March 1, 1900, but Gregorian calendar rules require 60 because 1900 is not a leap year.
Years divisible by 400 are leap years, so March 1, 2000 is day 61.
Add the first test before changing the implementation; observe the failed diagnostic.
Add the second test with the fix to protect the exception to the century rule.
No randomness, services, or locale-dependent input parsing is needed in this example.
The sample is adapted from the MathWorks CI configuration example; retain its license attribution.

Sources:

- https://github.com/mathworks/ci-configuration-examples

## 18. References and extensions

**Timing: Reference**

Verified references are embedded in these notes and in presenter-notes.md.
Suggested next topics: a release matrix, output caching, Simulink tests, MEX builds,
code generation, private-repository licensing, and versioned package releases.
These require their own preparation; keep them outside the beginner live-demo path.
The presentation materials do not claim that a hosted run has already been completed.
The repository's rehearsal/verification record is the source of truth for executed checks.

Sources:

- https://github.com/mathworks/ci-configuration-examples
- https://github.com/mathworks/ci-with-matlab-and-github-actions-workshop
- https://www.mathworks.com/help/releases/R2026b/matlab/release-notes.html
- https://www.mathworks.com/help/releases/R2026b/matlab/ref/matlab.toml.html
- https://www.mathworks.com/help/releases/R2026b/matlab/ref/matlab.buildtool.tasks.packagetask-class.html
- https://github.com/matlab-actions/setup-matlab
- https://github.com/matlab-actions/run-build
- https://github.com/matlab-actions/run-tests


## Live demonstration: exact 30-minute run of show

Keep MATLAB, the prepared pull-request page, and the Actions page open before the session.
The local repository is delivered on the correct `solution` branch. Switch to the prepared
`main` teaching baseline before demonstrating; do not merge rehearsal work into `main`.
Use the repository's `docs/demo-walkthrough.md` for the exact file edits and Git operations.

| Seminar time | Action | Expected evidence |
|---|---|---|
| 25–29 | Open `matlab.toml`; show Connections; pull `main`; inspect the function/tests and run `buildtool package -report artifacts/build-report`. | Three passing baseline tests, task order, and a toolbox. |
| 29–33 | Read `buildfile.m` and `.github/workflows/ci.yml`; inspect a prepared green run. | Task dependencies are in MATLAB; YAML selects the event, runner, and steps. |
| 33–39 | Create `demo/century-year`; add March 1, 1900; run locally; compare, commit, push; create a draft PR. | Four tests total; new test fails, expected 60 versus actual 61. |
| 39–44 | Open the failed GitHub check and report. | Same diagnostic in CI; package task is skipped. |
| 44–50 | Fix the Gregorian condition; add March 1, 2000; run locally; commit and push; inspect green reports and download the toolbox. | Five passing tests and evidence attached to the tested revision. |
| 50–53 | Mark PR ready, merge in GitHub, switch to `main` in MATLAB, pull. | Local source contains the merged fix. |
| 53–55 | Recap TOML, PackageTask, build reports, and the source-control integration. | Attendees can identify the R2026b additions. |

## Rehearsal and recovery

- Authenticate GitHub in MATLAB before the session. Never enter or display tokens live.
- Verify the actual hosted R2026b build and required merge check before presenting.
- Bookmark a green baseline run, a red century-test run, and a green fixed run.
- Download the reports and toolbox; keep a short screen recording of the Actions results.
- If the runner is still pending after a minute, inspect the matching rehearsal run while
  continuing the local edit/test narrative. Return to the new run when it is ready.
- Reference tags `seminar-start`, `seminar-red`, and `seminar-fixed` preserve the code states.
  Use a fresh branch or repository for another rehearsal; avoid force pushes or destructive resets.
- After rehearsing, reopen the intended baseline before attendees arrive. Close unrelated windows.
- If time is short, omit the MATLAB PR-panel revisit, then inspect saved artifacts. Keep the
  new failing test, CI diagnostic, fix, and successful result: those carry the central lesson.

## Delivery notes

- The demo creates a validated build artifact. It does not automatically publish or deploy it.
- Packaging a `.mltbx` and statement coverage use base MATLAB; they do not need MATLAB Compiler
  or MATLAB Test. Private repositories and transformation products have separate licensing needs.
- Published repository: https://github.com/kevinholly/matlab-ci-seminar. The prepared draft
  rehearsal PR is https://github.com/kevinholly/matlab-ci-seminar/pull/1. Publication is verified;
  hosted-run status is recorded separately in the repository verification materials.
