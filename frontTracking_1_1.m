max = 10;
deltaT = 0.01;

rad = 1.0;
resolution = 40;
theta = linspace(0, 2 * pi, resolution);

x0 = rad * cos(theta);
y0 = rad * sin(theta);

x = x0;
y = y0;

%hold on;
plot(x, y, 'k');
axis equal square;
xlim([-1, 1.5]);
ylim([-1, 1.5]);
pause
%N = length(x);
for k = 1 : max
    for i = 1 : resolution
        if (i == resolution)
            %periodic boundary conditions
            %ds = dist([x(i), y(i)], [x(1), y(1)]);
            x(i) = x(i) + deltaT;
            y(i) = y(i) + deltaT;
        else
            %ds = dist([x(i), y(i)], [x(i + 1), y(i + 1)]);
            x(i) = x(i) + deltaT;
            y(i) = y(i) + deltaT;
        end
    end
    plot(x, y, 'k');
    axis equal square;
    pause(0.1)
end


function [d]  = dist(p1, p2)
    d = sqrt((p1(1) - p1(1))^2 + (p1(2) - p2(2))^2);
end

function [n] = normal(x1, y1, x2, y2)
    p1 = [x1; y1];
    p2 = [x2; y2];
    xDif = (x2 - x1) / dist(p1, p2);
    yDif = (y2 - y1) / dist(p1. p2);
    n = [-y / {sqrt(xDif.^2 + yDif.^2)} ; x / {sqrt(xDif.^2 + yDif.^2)}];
end
