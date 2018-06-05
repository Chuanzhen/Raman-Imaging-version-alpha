clc; clear; close all;
%%
exposure = 1;
dd = 0.01*exposure;

xcenter = 4.00;% vertical
ycenter = 8.20;% horizontal
% 1/4
xrange = 0.35; % max = 0.8, 0.2/110
yrange = 0.35; % max = 0.8, 0.2/130

% 1280x1024
pixel2voltagex = 214/0.35;
pixel2voltagey = 200/0.35;


ImageX = xrange*pixel2voltagex;
ImageY = yrange*pixel2voltagey;

% distance between two spots is about 20 pixels
r = 5; % radius of laser spot 5
xcount = round(ImageX/r);
ycount = round(ImageY/r);

disp({['Total times ', num2str(xcount*ycount*exposure/60), ' min']; ...
    ['Total Image Size ', num2str(round(ImageY)), 'x', num2str(round(ImageX)), ' Pixels']; ...
    ['Horizontal ', num2str(ycount), '; Vertical ', num2str(xcount)]; ['Total Frames ', num2str(xcount*ycount)]});
%%
% x0 = -2.7;
x0 = xcenter - xrange/2;
xstep = xrange/(xcount-1);

% y0 = 2.75;
y0 = ycenter + yrange/2;
ystep = yrange/(ycount-1);
disp([x0, y0])
%%
x = zeros(2*xcount, 2);
xexposure = exposure*ycount;

x(1, :) = [0 x0];
for i = 2:xcount
    x1 = xexposure*(i-1)-dd/2;
    x2 = x0+(i-2)*xstep;
    x(2*i-2, :) = [x1, x2];
    x1 = xexposure*(i-1)+dd/2;
    x2 = x0+(i-1)*xstep;
    x(2*i-1, :) = [x1, x2];
end
x(end, :) = [xexposure*(xcount), x0+(xcount-1)*xstep];
% figure;
% plot(x(:, 1), x(:, 2))
%%
yy = zeros(2*ycount, 2);
yexposure = exposure;

yy(1, :) = [0 y0];
for i = 2:ycount
    y1 = exposure*(i-1)-dd/2;
    y2 = y0-(i-2)*ystep;
    yy(2*i-2, :) = [y1, y2];
    y1 = exposure*(i-1)+dd/2;
    y2 = y0-(i-1)*ystep;
    yy(2*i-1, :) = [y1, y2];
end
yy(end, :) = [exposure*(ycount), y0-(ycount-1)*ystep];
% figure;
% plot(yy(:, 1), yy(:, 2))
%%
yyminus = yy;
yyplus = yy;

for i = 1:length(yyplus)
    yyplus(i, :) = [yyminus(i, 1), yyminus(length(yy)-i+1, 2)];
end

% figure;
% plot(yy(:, 1), yyplus(:, 2), yy(:, 1), yyminus(:, 2))
%%
y = zeros(xcount*(2*ycount -1)+1, 2);
% %
mark = 0;
for i = 1:xcount
    if i == 1
        y(1:length(yy), :) = yyminus;
        mark = length(yy);
    else
        if mod(i, 2) ~= 0
            y(mark:(mark+length(yy)-1), :) = yyminus + repmat([(i-1)*xexposure, 0], length(yy), 1);
            mark = mark + length(yy)-1;
        else
            y(mark:(mark+length(yy)-1), :) = yyplus + repmat([(i-1)*xexposure, 0], length(yy), 1);
            mark = mark + length(yy)-1;
        end
    end
end
%%
simpley = zeros(2*(2*ycount -1)+1, 2);
mark = 0;
for i = 1:2
    if i == 1
        simpley(1:length(yy), :) = yyminus;
        mark = length(yy);
    else
        if mod(i, 2) ~= 0
            simpley(mark:(mark+length(yy)-1), :) = yyminus + repmat([(i-1)*xexposure, 0], length(yy), 1);
            mark = mark + length(yy)-1;
        else
            simpley(mark:(mark+length(yy)-1), :) = yyplus + repmat([(i-1)*xexposure, 0], length(yy), 1);
            mark = mark + length(yy)-1;
        end
    end
end



figure;
plot(y(:, 1), y(:, 2)-mean(y(:, 2)), x(:, 1), x(:, 2) - mean(x(:, 2)));
hold on
plot(simpley(:, 1), simpley(:, 2)-mean(mean(y(:, 2))));
legend('horizontal', 'vertical', 'one circle');
xlim([y(1, 1) y(end, 1)]);
xlabel('time/second')
ylabel('valtage/V')
set(gca, 'FontSize', 18)
%% x.lvm
fid = fopen('vertical.lvm', 'w');
% fprintf(fid,'\t');
fprintf(fid,'LabVIEW Measurement\r\n');
fprintf(fid,'Writer_Version	2\r\n');
fprintf(fid,'Reader_Version	2\r\n');
fprintf(fid,'Separator	Tab\r\n');
fprintf(fid,'Decimal_Separator	.\r\n');
fprintf(fid,'Multi_Headings	Yes\r\n');
fprintf(fid,'X_Columns	No\r\n');
fprintf(fid,'Time_Pref	Relative\r\n');
fprintf(fid,'Operator	light\r\n');
fprintf(fid,'Date	2017/06/13\r\n');
fprintf(fid,'Time	19:49:00.9943318367004394532\r\n');
fprintf(fid,'***End_of_Header***	\r\n');
fprintf(fid,'	\r\n');
fprintf(fid,'Channels	2	\r\n');


fprintf(fid,'Samples	%d	%d	\r\n', length(x), length(x));


fprintf(fid,'Date	2017/06/13	2017/06/13	\r\n');
fprintf(fid,'Time	19:49:00.9943318367004394532	19:49:00.9943318367004394532	\r\n');
fprintf(fid,'X_Dimension	Time	Time	\r\n');
fprintf(fid,'X0	0.0000000000000000E+0	0.0000000000000000E+0	\r\n');
fprintf(fid,'Delta_X	1.000000	1.000000	\r\n');
fprintf(fid,'***End_of_Header***			\r\n');
fprintf(fid,'X_Value	X Array	Y Array	Comment\r\n');

for ij = 1:length(x) 
    fprintf(fid,'\t%0.6f\t%0.6f\r\n',x(ij,1), x(ij,2));
end

fclose(fid);
%% y.lvm
fid = fopen('horizontal.lvm', 'w');
% fprintf(fid,'\t');
fprintf(fid,'LabVIEW Measurement\r\n');
fprintf(fid,'Writer_Version	2\r\n');
fprintf(fid,'Reader_Version	2\r\n');
fprintf(fid,'Separator	Tab\r\n');
fprintf(fid,'Decimal_Separator	.\r\n');
fprintf(fid,'Multi_Headings	Yes\r\n');
fprintf(fid,'X_Columns	No\r\n');
fprintf(fid,'Time_Pref	Relative\r\n');
fprintf(fid,'Operator	light\r\n');
fprintf(fid,'Date	2017/06/13\r\n');
fprintf(fid,'Time	19:49:00.9943318367004394532\r\n');
fprintf(fid,'***End_of_Header***	\r\n');
fprintf(fid,'	\r\n');
fprintf(fid,'Channels	2	\r\n');


fprintf(fid,'Samples	%d	%d	\r\n', length(y), length(y));


fprintf(fid,'Date	2017/06/13	2017/06/13	\r\n');
fprintf(fid,'Time	19:49:00.9943318367004394532	19:49:00.9943318367004394532	\r\n');
fprintf(fid,'X_Dimension	Time	Time	\r\n');
fprintf(fid,'X0	0.0000000000000000E+0	0.0000000000000000E+0	\r\n');
fprintf(fid,'Delta_X	1.000000	1.000000	\r\n');
fprintf(fid,'***End_of_Header***			\r\n');
fprintf(fid,'X_Value	X Array	Y Array	Comment\r\n');

for ij = 1:length(y) 
    fprintf(fid,'\t%0.6f\t%0.6f\r\n',y(ij,1), y(ij,2));
end

fclose(fid);

%% simplehor.lvm
fid = fopen('simplehorizontal.lvm', 'w');
% fprintf(fid,'\t');
fprintf(fid,'LabVIEW Measurement\r\n');
fprintf(fid,'Writer_Version	2\r\n');
fprintf(fid,'Reader_Version	2\r\n');
fprintf(fid,'Separator	Tab\r\n');
fprintf(fid,'Decimal_Separator	.\r\n');
fprintf(fid,'Multi_Headings	Yes\r\n');
fprintf(fid,'X_Columns	No\r\n');
fprintf(fid,'Time_Pref	Relative\r\n');
fprintf(fid,'Operator	light\r\n');
fprintf(fid,'Date	2017/06/13\r\n');
fprintf(fid,'Time	19:49:00.9943318367004394532\r\n');
fprintf(fid,'***End_of_Header***	\r\n');
fprintf(fid,'	\r\n');
fprintf(fid,'Channels	2	\r\n');


fprintf(fid,'Samples	%d	%d	\r\n', length(simpley), length(simpley));


fprintf(fid,'Date	2017/06/13	2017/06/13	\r\n');
fprintf(fid,'Time	19:49:00.9943318367004394532	19:49:00.9943318367004394532	\r\n');
fprintf(fid,'X_Dimension	Time	Time	\r\n');
fprintf(fid,'X0	0.0000000000000000E+0	0.0000000000000000E+0	\r\n');
fprintf(fid,'Delta_X	1.000000	1.000000	\r\n');
fprintf(fid,'***End_of_Header***			\r\n');
fprintf(fid,'X_Value	X Array	Y Array	Comment\r\n');

for ij = 1:length(simpley) 
    fprintf(fid,'\t%0.6f\t%0.6f\r\n',y(ij,1), y(ij,2));
end

fclose(fid);
%%
disp({['Vertical min ', num2str(min(x(:, 2))), 'V; max ', num2str(max(x(:, 2))), 'V']; ...
    ['Horizontal min ', num2str(min(y(:, 2))), 'V; max ', num2str(max(y(:, 2))), 'V']; ...
    ['Vertical ', num2str(length(x)), '; Horizontal ', num2str(length(y))]});
clear;