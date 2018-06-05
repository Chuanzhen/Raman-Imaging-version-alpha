clc; clear; close all;
%%
exposure = 0.1;
dd = 0.001;

% x0 = -2.7;
x0 = -1.86 - 1.5/2;
xcount = 10;
xstep = 1.5/xcount;

% y0 = 2.75;
y0 = 1.555 + 2.25/2;
ycount = 10;
ystep = 2.25/ycount;
%%
x = zeros(2*xcount+2, 2);
x(1, :) = [0 x0];

for i = 2:xcount+1
    x1 = exposure*(ycount+1)*(i-1);
    x2 = x0+(i-2)*xstep;
    x(2*i-2, :) = [x1, x2];
    x2 = x0+(i-1)*xstep;
    x(2*i-1, :) = [x1+dd, x2];
end

x(end, :) = [exposure*(ycount+1)*(xcount+1), x0+(xcount)*xstep];

figure;
plot(x(:, 1), x(:, 2))
%%
y = zeros(4*ycount+2, 2);
y(1, :) = [0 y0];

for i = 2:ycount+1
    y1 = exposure*(i-1);
    y2 = y0-(i-2)*ystep;
    y(2*i-2, :) = [y1, y2];
    y2 = y0-(i-1)*ystep;
    y(2*i-1, :) = [y1+dd, y2];
end
y(2*(ycount+1), :) = [exposure*(ycount+1), y0-(ycount)*ystep];

yy0 = y0-(ycount)*ystep;
tt0 = exposure*(ycount+1);
count0 = 2*(ycount+1);

for i = 1:ycount+1
    y1 = tt0+exposure*(i-1);
    y2 = yy0+(i-1)*ystep;
    y(count0+i*2-1, :) = [y1, y2];
    y1 = tt0+exposure*i-dd;
    y(count0+i*2, :) = [y1, y2];
end
y(end, :) = [(ycount+1)*exposure+tt0, yy0+ycount*ystep];
figure;
plot(y(:, 1), y(:, 2))

%%
[m,n]=size(y);
Y = zeros(m*6, n);
t = y(end, 1);
for k = 1:6
    for i = 1:m
        for j = 1:n
            if j == n
                Y((k-1)*m+i, n) = y(i, j);
            else
                Y((k-1)*m+i, 1) = y(i, 1)+(k-1)*t;
            end
        end
    end
    
end
figure;
plot(x(:, 1), x(:, 2), 'r', 'linewidth', 2);
hold on;
plot(Y(:, 1), Y(:, 2), 'b', 'linewidth', 2);
xlim([0, x(end, 1)]);
xlabel('Time/s');
ylabel('Voltage/V')
legend('X axis', 'Y axis')
set(gca, 'fontsize', 20)
%%
% fid = fopen('x.lvm', 'a');
% [m,n]=size(x);
%  for i=1:m
%     for j=1:n
%        if j==n
%            fprintf(fid,'%0.6f\r\n',x(i,j));
%        else
%            fprintf(fid,'\t');
%            fprintf(fid,'%0.6f\t',x(i,j));
%        end
%     end
%  end
%  fprintf(fid,'\t');
%  fprintf(fid,'\t');
% fclose(fid);
% %%
% fid = fopen('y.lvm', 'a');
% [m,n]=size(y);
% t = y(end, 1);
% for k = 1:6
%     for i = 1:m
%         for j = 1:n
%             if j == n
%                 fprintf(fid,'%0.6f\r\n',y(i,j));
%             else
%                 if i == 1
%                     fprintf(fid,'\t');
%                 end
%                 fprintf(fid,'\t');
%                 fprintf(fid,'%0.6f\t',y(i,j)+(k-1)*t);
%             end
%         end
%     end
%     
% end
% fclose(fid);