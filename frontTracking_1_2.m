max = 100;
deltaT = 0.01;
bt = 10;
xBottom = -bt;
xTop = bt;
yBottom = -bt;
yTop = bt;
c = 2;
epsilon = 3;

rad = 1.0;
resolution = 40;
theta = linspace(0, 2 * pi - 2*pi/resolution, resolution);

x0 = rad * cos(theta);
y0 = rad * sin(theta);

x = x0;
y = y0;

plot(x, y, 'k');
hold on;
plot([x(end) x(1)], [y(end) y(1)], 'k');
hold off;
axis equal square;
xlim([xBottom, xTop]);
ylim([yBottom, yTop]);
pause
%N = length(x);
for k = 1 : max
    for i = 1 : resolution
        if (i == resolution)
            %periodic boundary conditions
            n = normal([x(i) y(i)], [x(1) y(1)]);
        else
            n = normal([x(i) y(i)], [x(i + 1) y(i + 1)]);
        end
        xNext(i) = x(i) + deltaT * n(1) * (c + rand * epsilon);
        yNext(i) = y(i) + deltaT * n(2) * (c + rand * epsilon);
        %pause%(0.1)
    end
    x = xNext;
    y = yNext;
    plot(x, y, 'k');
    hold on;
    plot([x(end) x(1)], [y(end) y(1)], 'k');
    hold off;
    axis equal square;
    xlim([xBottom, xTop]);
    ylim([yBottom, yTop]);
    pause(0.1)
end


function [d]  = dist(p1, p2)
    d = sqrt((p1(1) - p1(1))^2 + (p1(2) - p2(2))^2);
end

function [n] = normal(p1, p2)
    d = dist(p1, p2);
    xDif = (p2(1) - p1(1)) / d;
    yDif = (p2(2) - p1(2)) / d;
    ds = sqrt(xDif.^2 + yDif.^2);
    %n = [-p1(2)/(sqrt(xDif.^2 + yDif.^2)) p1(1)/(sqrt(xDif.^2 + yDif.^2))];
    n = [yDif/ds -xDif/ds];
end
