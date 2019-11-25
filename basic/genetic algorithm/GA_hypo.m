clear all
xmin = -100;
xmax = 100;
ymin = -100;
ymax = 100;
zmin = -100;
zmax = 0;
npop = 500;
ngen = 15;

xs = [30 80 50];
ys = [30 100 50];
zs = [30 10 20];

xg = -40;
yg = 0;
zg = -60;

vp = 7;
tobs = calc_t(xs,ys,zs,xg,yg,zg,vp,0.5);

for i=1:npop
    model(i,1) = xmin + rand*(xmax-xmin);
    model(i,2) = ymin + rand*(ymax-ymin);
    model(i,3) = zmin + rand*(zmax-zmin);
    tcal(i,:) = calc_t(xs,ys,zs,model(i,1),model(i,2),model(i,3),vp,0.5);
    misfit(i) = sum(abs(tobs(1,:)-tcal(i,:)));
end

plot3(model(:,1),model(:,2),model(:,3),'.k','MarkerSize',7)
xlim([xmin xmax])
ylim([ymin ymax])
zlim([zmin zmax])
title('Starting model')

figure()
for n=1:ngen
hold on
plot3(xg,yg,zg,'*r')

fitness = 1./misfit;
fitness_norm = fitness./sum(fitness);

sc = 0;
for i=1:npop
    sc = sc + fitness_norm(i);
    cumm(i) = sc;
end

ioff = 1;
for i=1:npop/2
    R1 = rand;
    for j=1:npop
        if R1 < cumm(j)
            ipar1 = j;
            break
        end
    end
    
    R2 = rand;
    for j=1:npop
        if R2 < cumm(j)
            ipar2 = j;
            break
        end
    end
    
    R3 = rand;
    if R3 < 0.9
        i1 = rand;
        i2 = rand;
        i3 = rand;
        off(ioff,1) = i1*model(ipar1,1)+(1-i1)*model(ipar2,1);
        off(ioff+1,1) = i1*model(ipar2,1)+(1-i1)*model(ipar1,1);
        off(ioff,2) = i2*model(ipar1,2)+(1-i2)*model(ipar2,2);
        off(ioff+1,2) = i2*model(ipar2,2)+(1-i2)*model(ipar1,2);
        off(ioff,3) = i3*model(ipar1,3)+(1-i3)*model(ipar2,3);
        off(ioff+1,3) = i3*model(ipar2,3)+(1-i3)*model(ipar1,3);
    else
        off(ioff,:) = model(ipar1,:);
        off(ioff+1,:) = model(ipar2,:);
    end
    ioff = ioff+2;
end

model = off;
for i=1:npop
    tcal(i,:) = calc_t(xs,ys,zs,model(i,1),model(i,2),model(i,3),vp,0.5);
    misfit(i) = sum(abs(tobs(1,:)-tcal(i,:)));
end
plot3(model(:,1),model(:,2),model(:,3),'.k','MarkerSize',7)
xlim([xmin xmax])
ylim([ymin ymax])
zlim([zmin zmax])
title(['Inversion result of gen no.',num2str(n)])
grid on
pause(0.5)
if n ~= ngen
clf
end
end

% function [y] = peak_1D(x)
% y = x + 10 * sin(4*x+1) + 4 * cos(5*x) + 20;
% end