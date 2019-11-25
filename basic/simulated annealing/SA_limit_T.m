clear all
clc
hold on
min_x = -3;
max_x = 3;
min_y = -3;
max_y = 3;

Z = 10-peaks();
[X Y] = meshgrid(min_x:(max_x-min_x)/(length(Z)-1):max_x,min_y:(max_y-min_y)/(length(Z)-1):max_y);
clr = pcolor(X,Y,Z);
cb = colorbar;
set(clr,'EdgeColor','none')
title(cb,'Error')

mo = [1.5 -1];
model_awal = plot(mo(1),mo(2),'.r','MarkerSize',10);

T = 5;
dec = 0.02;
T_lim = 0.05;
max_perturb = 10;

k=1;
while(T>T_lim)
    for i = 1:max_perturb
    m(1) = min_x + rand*(max_x-min_x);
    m(2) = min_y + rand*(max_y-min_y);
    
    E1 = peak(m(1),m(2));
    E2 = peak(mo(1),mo(2));
    delta_E = E1-E2;
    
    if delta_E < 0
        mo = m;
        terima = plot(mo(1),mo(2),'.k','MarkerSize',5);
    else
        P = exp(-delta_E/T);
        R = rand;
        if R <= P
            mo = m;
            terima = plot(mo(1),mo(2),'.k','MarkerSize',5);
        else
            tolak = plot(m(1),m(2),'.b','MarkerSize',5);
        end
    end
    %pause(0.1)
    end
    T_iter(k) = T;
    k_iter(k)=k;
    k=k+1;
    T = T*(1-dec);
end
solusi = plot(mo(1),mo(2),'or','MarkerSize',5);
mo
E2
legend([model_awal terima tolak solusi],'Model awal','Model Diterima','Model Ditolak','Solusi')

figure
plot(k_iter,T_iter,'-b')

% function z = peak(x,y)
%     z = 10-peaks(x,y);
% end