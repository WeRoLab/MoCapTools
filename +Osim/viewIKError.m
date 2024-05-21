function fig_err = viewIKError(errorTable, surfacePlot)
% Osim.viewIKError(errorTable)
% Osim.viewIKError(errorTable, surfacePlot)
% viewIKError plots the error output of Osim.IK in a format that is more
% easily understandable. surfacePlot is a logical value that determines
% whether the data should be plotted in a 3D surface plot that shows all
% the data (surfacePlot = true), or whether the data should be condensed
% over the markers and plotted in 2D (surfacePlot = false, default).

    font_size = 20;
    line_width = 2;

    if ~exist('surfacePlot', 'var')
        surfacePlot = false;
    end

    m_to_mm = 1000;

    fig_err = figure;

    if ~surfacePlot
        data = errorTable{:, 2:end} .* m_to_mm;
        % exclude nan values when calculating rms
        rmsError = sqrt(mean(data.^2, 2, "omitnan")); %rms(data, 2);
        maxError = max(data, [], 2);
        hold on; box on; grid on;
        plot(errorTable.Header, maxError, 'LineWidth', line_width, 'Color', 'r');
        plot(errorTable.Header, rmsError, 'LineWidth', line_width, 'Color', 'b');
        legend('Max', 'RMS');
        xlabel('Time (s)');
        ylabel('Marker error (mm)');
        title('Inverse kinematics marker errors');
        set(gca,'FontSize',font_size);
    else
        e = errorTable(:, 2:end) .* m_to_mm;
        surface(1:width(e), errorTable.Header, e.Variables, 'EdgeColor', 'none')
        set(gca, 'XTick', 1:width(e));
        labels = e.Properties.VariableNames';
        try % come up with compact label names for KB_LowerBody marker set
            beg = cellfun(@(l) {l([1 3 4])}, labels);
            r = cellfun(@(l) {l([2 5:end])}, labels);
            fourthLetter = cellfun(@(l) {l(find(l == '_', 1, 'last') + 1)}, r);
            labels = upper(join([beg, fourthLetter], ''));
        catch 
            labels = cellfun(@(x){x(1:min(4, end))}, labels);
        end
        set(gca, 'XTickLabel', labels)
        xlabel('Marker');
        ylabel('Time (s)');
        zlabel('Marker error (mm)');
        title('Inverse kinematics marker errors');
        % view(-20, 30);
        view(-3.0343,16.6257);
        set(gca,'FontSize',font_size);
        box on; grid on;
    end
end
