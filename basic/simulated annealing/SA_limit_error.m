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

mo = [0 -1.5];
model_awal = plot(mo(1),mo(2),'.r','MarkerSize',10);

T = 5;
dec = 0.05;
err_lim = 0.2;
max_perturb = 20;

while(abs((peak(mo(1),mo(2)))-min(min(Z))>=err_lim))
    for i = 1:max_perturb
    m(1) = min_x + rand*(max_x-min_x);
    m(2) = min_y + rand*(max_y-min_y);
    
    E1 = peak(m(1),m(2));
    E2 = peak(mo(1),mo(2));
    delta_E = E1-E2;
    
    if delta_E < 0
        mo = m;
        titik = plot(mo(1),mo(2),'.k','MarkerSize',5);
    else
        P = exp(-delta_E/T);
        R = rand;
        if R <= P
            mo = m;
            titik = plot(mo(1),mo(2),'.k','MarkerSize',5);
        end
    end
    %pause(0.1)
    end
    T = T*(1-dec);
end

solusi = plot(mo(1),mo(2),'or','MarkerSize',5);
mo
E2
legend([model_awal titik solusi],'Model awal','Perturbasi','Solusi')

% function z = peak(x,y)
%     z = 10-peaks(x,y);
% end
