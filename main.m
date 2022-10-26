% CopyRight:  Qingjun Chang @USI

clear,clc
close all
clear global
% clf
%
% addpath('d:\github\gptoolbox\mesh');
% to select some points
if 1
    i = 0;
    grid on,hold on,axis equal
    axis([-2.4 2.4 -2 2]);
    while 1
        i = i+1;
        try
            [x,y,button] = ginput(1);

        catch
            return;
        end

        v(:,i) = [x;y];
        if i== 1
            pgon = plot(v(1,:),v(2,:),'b-o','MarkerSize',8,'MarkerFaceColor','b');
        else
            set(pgon,'xdata',v(1,:),'ydata',v(2,:));
        end
        if button ~= 1
            set(pgon,'xdata',[v(1,:) v(1)],'YData',[v(2,:) v(2)]);
            break;
        end
    end
else
    load('G2.mat');      % v:G v1:L v3: convex
end
v0 = v;

n = size(v,2);
[tri,x,y,boundary_markers] = triangle(v',.001);

innerPoints = [x y]';

lambda = zeros(n,length(x));
mvc = lambda;

for i = 1:length(x)

    if boundary_markers(i)
        a = vecnorm(v0 - repmat(innerPoints(:,i),1,n));
        b = zeros(n,1);
        if any(a<1e-6)         % p is one of the vertices
            b(a<1e-6) = 1;
            lambda(:,i) = b;%b;
        else     % p is on one of the edges
            newv = (v0 - repmat(innerPoints(:,i),1,n))./a;
            newv = newv + newv(:,[2:end 1]);
            a = vecnorm(newv);
            [~,c] = min(a);
            d = norm(v0(:,c)-v0(:,mod(c,n)+1));
            b(c) = norm(v0(:,mod(c,n)+1)-innerPoints(:,i))/d;
            b(mod(c,n)+1) = norm(v0(:,c)-innerPoints(:,i))/d;
            lambda(:,i) = b;%b;
        end
        continue;
    end
    [mvc(:,i)] = mvcoordinates(innerPoints(:,i),v0);
end
mvc = mvc + lambda;



load('CQJ_Colormaps')
for i = 1:n

    figure
    hold on,axis equal off
    title('mvc  ');

    h = trisurf(tri(:,2:4),x,y, mvc(i,:));
    set(h,'EdgeAlpha',0)
    shading interp
    caxis([-0.1 1.1]);
    zz = zeros(size(v0(1,:)));
    zz(i) = 1;
    plot3([v0(1,:) v0(1,1)],[v0(2,:) v0(2,1)],[zz zz(1)],'b-o','MarkerSize',8,'MarkerFaceColor','b')
    %     light('Position',[1 1 1])
    caxis([-0.1 1.1]);

    colormap(mycmap)
end
