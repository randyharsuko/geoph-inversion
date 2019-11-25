clear all
clc
%mendefinisikan koordinat stasiun
xs = [30 80 50];
ys = [30 100 50];
zs = [1 1 1];

%mendefinisikan koordinat gempa
xg = 73
yg = 40
zg = -60

%mendefinisikan grid
min_x = -150;
max_x = 150;
inc_x = 10;
min_y = -150;
max_y = 150;
inc_y = 10;
min_z = -150;
max_z = 0;
inc_z = 10;

x_limit = min_x:inc_x:max_x;
y_limit = min_y:inc_y:max_y;
z_limit = min_z:inc_z:max_z;

%mendefinisikan kecepatan gelombang P
vp = 7;

%gridding
[X,Y,Z] = meshgrid(x_limit,y_limit,z_limit);
x = X(:);
y = Y(:);
z = Z(:);
scatter3(x,y,z,'.b')

%menghitung Tobs
tobs = calc_t(xs,ys,zs,xg,yg,zg,vp,0.5);

%grid search
k=1;
for i=1:length(x)
    total_e = 0;
    for j=1:length(xs)
        tcal(i,j) = calc_t(xs(j),ys(j),zs(j),x(i),y(i),z(i),vp,0.5);
        e = abs(tcal(i,j)-tobs(j));
        total_e = total_e + e;
    end
    error(i) = total_e;
end

index_error = find(error==min(error));
koordinat = [x(index_error) y(index_error) z(index_error)]
fprintf('Hiposenter : \n');
fprintf('X = %f, Y = %f, Z = %f \n',x(index_error),y(index_error),z(index_error));

figure
hold on
gempa = scatter3(xg,yg,zg,'*r');
stasiun = scatter3(xs,ys,zs,'vk');
solusi = scatter3(x(index_error),y(index_error),z(index_error),'.b');
legend([gempa,stasiun,solusi],'Lokasi gempa','Stasiun','Hasil grid search')
xlim([-150 150])
ylim([-150 150])
zlim([-150 50])
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Depth (m)')
grid on

figure
error_rshp = reshape(error,length(x_limit),length(y_limit),length(z_limit));
slice(X,Y,Z,error_rshp,[],[],[min_z:30:max_z])
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Depth (m)')
colorbar