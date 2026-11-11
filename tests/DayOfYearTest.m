classdef DayOfYearTest < matlab.unittest.TestCase
    %DayOfYearTest - Verify Gregorian calendar day numbers
    %   testCase = DayOfYearTest creates tests for DAYOFYEAR.
    %
    %   DayOfYearTest functions:
    %       januaryFirst             - Start of a calendar year
    %       commonYearDecember31     - End of a common year
    %       ordinaryLeapYearMarch1   - Day after an ordinary leap February
    %       century1900March1        - Century that is not a leap year
    %
    %   See also dayofyear, runtests, matlab.unittest.TestCase

    methods (Test)
        function januaryFirst(testCase)
            %januaryFirst - Verify that January 1 is day 1
            %   januaryFirst(testCase) tests the first day of the year.
            dateText = "2025-01-01";
            actual = dayofyear(dateText);
            testCase.verifyEqual(actual,1);
        end

        function commonYearDecember31(testCase)
            %commonYearDecember31 - Verify the last day of a common year
            %   commonYearDecember31(testCase) checks for 365 days.
            dateText = "2025-12-31";
            actual = dayofyear(dateText);
            testCase.verifyEqual(actual,365);
        end

        function ordinaryLeapYearMarch1(testCase)
            %ordinaryLeapYearMarch1 - Verify an ordinary leap February
            %   ordinaryLeapYearMarch1(testCase) checks March 1 in 2024.
            dateText = "2024-03-01";
            actual = dayofyear(dateText);
            testCase.verifyEqual(actual,61);
        end

        function century1900March1(testCase)
            %century1900March1 - Verify the Gregorian century exception
            %   century1900March1(testCase) checks that 1900 is common.
            dateText = "1900-03-01";
            actual = dayofyear(dateText);
            testCase.verifyEqual(actual,60);
        end
    end
end
