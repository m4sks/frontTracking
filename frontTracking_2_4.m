max = 200;
deltaT = 0.1;
bt = 10;
xBottom = -bt;
xTop = bt;
yBottom = -bt;
yTop = bt;
%c = 2;
%epsilon = 5;

rad = 5.0;
resolution = 10;
theta = linspace(0, 2 * pi - 2*pi/resolution, resolution);

x0 = 4.0 * cos(theta)  + 8*sin(theta);
y0 = rad * sin(theta).^3;
%x0 = rad * cos(theta)  + 8*sin(theta);
%y0 = rad * sin(theta).^3;

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
xNext = x;
yNext = y;
for j = 1 : max
    for i = 1 : resolution
        if (i == 1)
            %periodic boundary conditions
            n = normal([x(end) y(end)], [x(i) y(i)], [x(i + 1) y(i + 1)]);
            k = kappa([x(end) y(end)], [x(i) y(i)], [x(i + 1) y(i + 1)]);
        elseif (i == resolution)
            n = normal([x(i - 1) y(i - 1)], [x(i) y(i)], [x(1) y(1)]);
            k = kappa([x(i - 1) y(i - 1)], [x(i) y(i)], [x(1) y(1)]);
        else
            n = normal([x(i - 1) y(i - 1)], [x(i) y(i)], [x(i + 1) y(i + 1)]);
            k = kappa([x(i - 1) y(i - 1)], [x(i) y(i)], [x(i + 1) y(i + 1)]);
        end
        xNext(i) = x(i) - deltaT * n(1) * k;
        yNext(i) = y(i) - deltaT * n(2) * k;
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

function [n] = normal(p0, p1, p2)
    v1 = vector(p0, p1);
    v2 = vector(p1, p2);
    v = v1 + v2;
    %d = sqrt(v(1).^2 + v(2).^2);
    n = v/sqrt(v(1).^2 + v(2).^2);
end

function [v] = vector(p1, p2)
    d = dist(p1, p2);
    xDif = (p2(1) - p1(1)) / d;
    yDif = (p2(2) - p1(2)) / d;
    v = [yDif -xDif];
end

function [k] = kappa(p0, p1, p2)
    xDif = p2(1) - p1(1);
    yDif = p2(2) - p1(2);
    xDifDif = (p2(1) - 2 * p1(1) + p0(1));
    yDifDif = (p2(2) - 2 * p1(2) + p0(2));
    k = (xDif * yDifDif - yDif * xDifDif) / sqrt((xDif.^2 + yDif.^2).^3);
end
