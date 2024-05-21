% This functions compares a two tables of marker data, the original TRC
% data and the OpenSim-outputted kinematic fit data, and returns a new
% table containing the marker error for each marker at each frame. 
function errorTable = calculateMarkerErrors(trcTable, stoTable)
    trcTable = Osim.interpret(trcTable, 'TRC');
    stoTable = Osim.interpret(stoTable, 'TRC');
    % reorder tables to be in the same order
    startTime = max(trcTable.Header(1), stoTable.Header(1));
    endTime = min(trcTable.Header(end), stoTable.Header(end));
    labels = intersect(stoTable.Properties.VariableNames, trcTable.Properties.VariableNames, 'stable');
    trcTable = cut(trcTable, startTime, endTime);
    stoTable = cut(stoTable, startTime, endTime);
    trcTable = trcTable(:, labels);
    stoTable = stoTable(:, labels);
    % mm to m conversion.
    mm_to_m = 1e-3;
    stoTable(:,2:end) = stoTable(:,2:end) .* mm_to_m;
    % subtract the two tables
    fullErrors = stoTable{:, 2:end} - trcTable{:, 2:end};
    % calculate the Euclidian distance and convert mm to m
    errorTable = array2table(sqrt(fullErrors(:, 1:3:end).^2 + fullErrors(:, 2:3:end).^2 + fullErrors(:, 3:3:end).^2)/1000);
    % set the variable names
    errorTable.Properties.VariableNames = cellfun(@(x) {strrep(x, '_x', '')}, labels(2:3:end));
    errorTable = [stoTable(:, 1),  errorTable]; % include Header again
end

function out=cut(atable,initial_time,final_time)
%Extract a table by Header time interval
idx=(atable.Header>=initial_time)&(atable.Header<=final_time);
data=atable;
out=data(idx,:);
if isempty(out)
    warning('Interval is empty');
end
end