function ordinalDay = dayofyear(dateText)
%DAYOFYEAR - Convert an ISO date to its day number within the year
%   ordinalDay = DAYOFYEAR(dateText) returns the day number for scalar
%   text in yyyy-MM-dd format, using the Gregorian leap-year rule.
%
%   Example: The century-year exception
%       ordinalDay = dayofyear("1900-03-01")
%
%   See also datetime, day

% Copyright 2022 The MathWorks, Inc.
% Adapted from the MathWorks CI configuration examples for this seminar.
% See LICENSE for redistribution terms.

arguments
    dateText {mustBeTextScalar}
end

dateValue = datetime(dateText,InputFormat="yyyy-MM-dd");
daysPerMonth = [31 28 31 30 31 30 31 31 30 31 30 31];

% Gregorian years divisible by 100 are leap years only if divisible by 400.
if mod(dateValue.Year,4) == 0 && ...
        (mod(dateValue.Year,100) ~= 0 || mod(dateValue.Year,400) == 0)
    daysPerMonth(2) = 29;
end

ordinalDay = sum(daysPerMonth(1:dateValue.Month-1)) + dateValue.Day;
end
