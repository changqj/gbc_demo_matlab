function [mvc] = mvcoordinates(x,p)
% CopyRight:  Qingjun Chang @USI
% meav value coordinates 

n = size(p,2);

% projection step
v = p - repmat(x,1,n);

r0 = vecnorm(v);
v = v./r0;    % projected points on unit circle


thetas = acos(dot(v,v(:,[2:end,1]))).*sign(dot(cross([v;ones(1,n)],...
    [v(:,[2:end,1]);ones(1,n)]),repmat([0;0;1],1,n)));

T = tan(thetas/2);

d = T + T([end 1:end-1]);
d = d./r0;
d = d'/sum(d);
mvc = d;

end
