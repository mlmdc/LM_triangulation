function [x, y] = computeCircle(center, radius, np)
    
    theta = linspace(0, 2*pi, np); % Generate points for the circle
    x = center(1) + radius * cos(theta);
    y = center(2) + radius * sin(theta);

end

function plotCircle(center, cx, cy)
    plot(cx, cy, 'b', 'LineWidth', 2); % Plot the circle
    hold on;
    plot(center(1), center(2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Mark center
    
end