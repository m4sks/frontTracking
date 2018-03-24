clear;

max = 100;
deltaT = 0.1;
bt = 650;
xBottom = 0;
xTop = bt;
yBottom = 0;
yTop = bt;
%c = 2;
%epsilon = 5;

load('xy.mat');
x = xy(:,1);
y = xy(:,2);
resolution = length(x);

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
    pause
end


function [d]  = dist(p1, p2)
    d = sqrt((p1(1) - p1(1))^2 + (p1(2) - p2(2))^2);
end

function [n] = normal(pm, p, pp)
    v1 = vector(pm, p);
    v2 = vector(p, pp);
    v = v1 + v2;
    n = v / sqrt(v(1).^2 + v(2).^2);
end

function [v] = vector(p1, p2)
    d = dist(p1, p2);
    xDif = (p2(1) - p1(1)) / d;
    yDif = (p2(2) - p1(2)) / d;
    v = [yDif -xDif];
end

function [k] = kappa(pm, p, pp)
    xDif = pp(1) - p(1);
    yDif = pp(2) - p(2);
    xDifDif = (pp(1) - 2 * p(1) + pm(1));
    yDifDif = (pp(2) - 2 * p(2) + pm(2));
    k = (xDif * yDifDif - yDif * xDifDif) / sqrt((xDif.^2 + yDif.^2).^3);
end
