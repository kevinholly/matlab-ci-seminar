function plan = buildfile
%BUILDFILE - Define the seminar check, test, and package pipeline
%   PLAN = BUILDFILE creates a build plan that checks source code, runs
%   project tests, collects statement coverage, and builds a package.
%
%   See also buildtool, buildplan

import matlab.buildtool.tasks.*

plan = buildplan;

% The built-in analyzer fails on errors; warnings remain informational.
% Factory settings keep the check consistent locally and in CI.
plan("check") = CodeIssuesTask("src", ...
    Configuration="factory",ErrorThreshold=0);

% The built-in test task discovers tests from the open project.
% It creates machine-readable and human-readable results in one test run.
testTask = TestTask( ...
    Dependencies="check", ...
    SourceFiles="src", ...
    TestResults=["artifacts/tests/results.xml", ...
                 "artifacts/tests/report.html"]);

% Explicit statement coverage works with base MATLAB on every machine.
testTask = addCodeCoverage(testTask, ...
    "artifacts/coverage/report.html",Metrics="statement");
plan("test") = testTask;

% R2026b PackageTask reads package identity and contents from matlab.toml.
% The dependency prevents packaging when checking or testing fails.
plan("package") = PackageTask(Dependencies="test");
plan.DefaultTasks = "package";
end
