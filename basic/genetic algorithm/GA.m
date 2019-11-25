clear all
xmin = -5;
xmax = 5;
x = xmin:0.05:xmax;
y = peak_1D(x);
nbit = 16;
npop = 40;
ngen = 20;
bin_max = (2^nbit)-1;

for i=1:npop
    random = rand(nbit);
    for j=1:nbit
        if random(j) <= 0.5
            model_bin(i,j) = 1;
        else
            model_bin(i,j) = 0;
        end
    end
end

for i=1:npop
    ssum = 0;
    ibit = nbit;
    for j=1:nbit
        if model_bin(i,j) == 1
        temp = 2^(ibit-1);
        ssum = ssum+temp;
        end
        ibit = ibit-1;
    end
    model_ril(i) = ssum;
    model(i) = xmin+(model_ril(i)/bin_max*(xmax-xmin));
    y_model(i) = peak_1D(model(i));
end
hold on
plot(x,y)
plot(model,y_model,'.r','MarkerSize',10)
title('Starting model')

figure()
for n=1:ngen
hold on
plot(x,y)

fitness = 1./y_model;
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
        icross1 = round((nbit)*rand);
        %if icross1 == 0 
         %   icross1 = icross1+1;        
        %elseif icross1 == nbit
         %   icross1 = icross1-1;
        %end
        
        off(ioff,1:icross1) = model_bin(ipar1,1:icross1);
        off(ioff,icross1+1:nbit) = model_bin(ipar2,icross1+1:nbit);
        off(ioff+1,1:icross1) = model_bin(ipar2,1:icross1);
        off(ioff+1,icross1+1:nbit) = model_bin(ipar1,icross1+1:nbit);
    else
        off(ioff,:) = model_bin(ipar1,:);
        off(ioff+1,:) = model_bin(ipar2,:);
    end
    ioff = ioff+2;
end

model_bin = off;
for i=1:npop
    ssum = 0;
    ibit = nbit;
    for j=1:nbit
        if model_bin(i,j) == 1
        temp = 2^(ibit-1);
        ssum = ssum+temp;
        end
        ibit = ibit-1;
    end
    model_ril(i) = ssum;
    model(i) = xmin+(ssum/bin_max*(xmax-xmin));
    y_model(i) = peak_1D(model(i));
end
plot(model,y_model,'.r','MarkerSize',10)
title(['Inversion result of gen no.',num2str(n)])
pause(0.5)
if n ~= ngen
clf
end
end

% function [y] = peak_1D(x)
% y = x + 10 * sin(4*x+1) + 4 * cos(5*x) + 20;
% end