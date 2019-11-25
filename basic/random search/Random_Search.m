clear all
xs = [30 80 50];
ys = [30 100 50];
zs = [1 1 1];

xg = 73
yg = 40
zg = -60

min_x = -150;
max_x = 150;
min_y = -150;
max_y = 150;
min_z = -150;
max_z = 0;

for i=1:1000
    xx(i) = min_x + rand*(max_x-min_x);
    yy(i) = min_y + rand*(max_y-min_y);
    zz(i) = min_z + rand*(max_z-min_z);
end

vp = 7;

scatter3(xx,yy,zz,'.b')
title('Starting model')

tobs = calc_t(xs,ys,zs,xg,yg,zg,vp,0.5);

k=1;
for i=1:length(xx)
    total_e = 0;
    for j=1:length(xs)
        tcal(i,j) = calc_t(xs(j),ys(j),zs(j),xx(i),yy(i),zz(i),vp,0.5);
        e = abs(tcal(i,j)-tobs(j));
        total_e = total_e + e;
    end
    error(i) = total_e;
end

index_error = find(error==min(error));
koordinat = [xx(index_error) yy(index_error) zz(index_error)]

figure
hold on
gempa = scatter3(xg,yg,zg,'*r');
stasiun = scatter3(xs,ys,zs,'vk');
solusi = scatter3(xx(index_error),yy(index_error),zz(index_error),'.b');
legend([gempa,stasiun,solusi],'Earthquake location','Station','Random search result')
xlim([-150 150])
ylim([-150 150])
zlim([-150 50])
title('Inversion result')
grid on