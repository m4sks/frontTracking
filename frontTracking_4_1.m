max = 200;
deltaT = 0.1;
bt = 10;
xBottom = -bt;
xTop = bt;
yBottom = -bt;
yTop = bt;
%c = 2;
%epsilon = 5;

distMin = 1.0;
distMax = 4.0;

rad = 5.0;
resolution = 40;
theta = linspace(0, 2 * pi - 2*pi/resolution, resolution);

x0 = rad * cos(theta);
y0 = rad * sin(theta);
%x0 = 6 * cos(theta)  ;%+ 10 * sin(theta);
%y0 = 5 * sin(theta);
%x0 = rad * cos(theta)  + 8*sin(theta);
%y0 = rad * sin(theta).^3;

x = x0;
y = y0;

plot(x, y, '-ok');
hold on;
plot([x(end) x(1)], [y(end) y(1)], '-ok');
hold off;
axis equal square;
xlim([xBottom, xTop]);
ylim([yBottom, yTop]);
pause
for j = 1 : max
    if (resolution == 0)
        error('no point');
    end
    i = 1;
    while i <= resolution
        if (i == 1)
            d = dist([x(end) y(end)], [x(i) y(i)]) + dist([x(i) y(i)], [x(i + 1) y(i + 1)]);
        elseif (i == resolution)
            d = dist([x(i - 1) y(i - 1)], [x(i) y(i)]) + dist([x(i) y(i)], [x(1) y(1)]);
        else
            d = dist([x(i - 1) y(i - 1)], [x(i) y(i)]) + dist([x(i) y(i)], [x(i + 1) y(i + 1)]);
        end
        if (d < distMin)
            fprintf('(%d)', length(x))
            x(i) = [;];
            y(i) = [;];
            resolution = resolution - 1;
            %i = i - 1;
            fprintf('erase!to(%d), ', length(x))
        elseif (d > distMax)
            fprintf('(%d)', length(x))
            disp(x)
            insertCols(x, (x(i) + x(i + 1)) / 2, i);
            insertCols(y, (y(i) + y(i + 1)) / 2, i);
            fprintf('add!(%d)to(%d), ', (x(i) + x(i + 1)) / 2, length(x))
            disp(i)
            disp(x)
        end
        if (length(x) ~= resolution)
            error('not fit resolution ')
        end
        i = i + 1;
    end
    fprintf(', resolution:%d\n', resolution)
    xNext = x;
    yNext = y;
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
    end
    x = xNext;
    y = yNext;
    plot(x, y, '-ok');
    %for i = 1 : resolution
    %    str = string(i);
    %    text(x(i), y(i), str);
    %end
    hold on;
    plot([x(end) x(1)], [y(end) y(1)], 'k');
    hold off;
    axis equal square;
    xlim([xBottom, xTop]);
    ylim([yBottom, yTop]);
    pause(0.1)
    %disp(x)
    %disp(y)
end


function [d]  = dist(p1, p2)
    d = sqrt((p1(1) - p1(1))^2 + (p1(2) - p2(2))^2);
end

function [n] = normal(p0, p1, p2)
    v1 = vector(p0, p1);
    v2 = vector(p1, p2);
    v = v1 + v2;
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

%function [kap] = kpar(pm, p, pp)
%    dx
%    
%end

function [output] = insertCols(insertedMat, insertMat, col)
    [rows1, cols1] = size(insertedMat);
    [rows2, cols2] = size(insertMat);
    if (rows1 > rows2) 
        error('too few rows of inserting Mat');
    elseif (rows1 < rows2) 
        error('too many rows of inserting Mat');
    end
    output = cat(2, insertedMat(:,1:col - 1), insertMat, insertedMat(:,col:cols1));
end