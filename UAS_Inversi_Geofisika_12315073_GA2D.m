clear all
%UAS Inversi Geofisika
%Mochammad Randy Caesario Harsuko
%12315073
%Genetic Algorithm (2D)
%Versi MATLAB : MATLAB R2017a

%mendefinisikan ruang model
xmin = -3;
xmax = 3;
ymin = -3;
ymax = 3;
[X,Y] = meshgrid(xmin:(xmax-xmin)/48:xmax,ymin:(ymax-ymin)/48:ymax);

%plotting fungsi peak
hold on
Z = peak(X,Y);
[min_x min_y] = find(Z==min(min(Z))); %mencari indeks nilai minimum fungsi peak
clr = pcolor(X,Y,peak(X,Y));
minimum = plot(X(min_x,min_y),Y(min_x,min_y),'*r');
cb = colorbar;
set(clr,'EdgeColor','none')
title(cb,'Misfit')

%menentukan jumlah populasi dan jumlah generasi
npop = 60; %jumlah populasi
ngen = 15; %jumlah generasi

k = 1;
%membuat individu acak sejumlah populasi untuk generasi pertama
for i=1:npop
    model(i,1) = xmin + rand*(xmax-xmin);
    model(i,2) = ymin + rand*(ymax-ymin);
    misfit(i) = peak(model(i,1),model(i,2)); %menghitung misfit
end
titik = plot(model(:,1),model(:,2),'.k','MarkerSize',7); %plot model awal
title('Model Awal')
legend([titik minimum],'Individu','Misfit Minimum')

figure
%looping untuk Algoritma Genetika
for n=1:ngen
    hold on
    %menghitung nilai fitness dan nilai fitness yang dinormalisasi
    fitness = 1./misfit;
    fitness_norm = fitness./sum(fitness);
    
    %menghitung cummulative fitness
    sc = 0;
    for i=1:npop
        sc = sc + fitness_norm(i);
        cumm(i) = sc;
    end

    
    ioff = 1;
    for i=1:npop/2
        %memilih parent 1 dengan mekanisme roulette wheel
        R1 = rand;
        for j=1:npop
            if R1 < cumm(j)
                ipar1 = j;
            break
            end
        end
        
        %memilih parent 2 dengan mekanisme roulette wheel
        R2 = rand;
        for j=1:npop
            if R2 < cumm(j)
                ipar2 = j;
            break
            end
        end
        
        %melakukan crossover dengan mekanisme single arithmetic cross-over
        %(selalu terjadi crossover karena probability crossover = 1
        i1 = rand;
        i2 = rand;
        off(ioff,1) = i1*model(ipar1,1)+(1-i1)*model(ipar2,1);
        off(ioff+1,1) = i1*model(ipar2,1)+(1-i1)*model(ipar1,1);
        off(ioff,2) = i2*model(ipar1,2)+(1-i2)*model(ipar2,2);
        off(ioff+1,2) = i2*model(ipar2,2)+(1-i2)*model(ipar1,2);
        ioff = ioff+2;
    end

    %mengganti generasi sebelumnya dengan generasi terkini
    model = off;

    %menghitung nilai misfit generasi terkini
    for i=1:npop
        misfit(i) = peak(model(i,1),model(i,2));
    end

    %plotting
    clr = pcolor(X,Y,peak(X,Y));
    cb = colorbar;
    set(clr,'EdgeColor','none')
    title(cb,'Misfit')
    titik = plot(model(:,1),model(:,2),'.k','MarkerSize',7);
    minimum = plot(X(min_x,min_y),Y(min_x,min_y),'*r');
    title(['Algoritma Genetika Generasi ke-' num2str(n) n])
    legend([titik minimum],'Individu','Misfit Minimum')
    pause(0.5)
    if n ~= ngen
    clf
    end
end