%%��������һά�������Ŀ�������
function[dist] = ChiSquareDistance(X,Y)

X_mean = mean(X,2);
Y_mean = mean(Y,2);

dist = sqrt(sum(((X - X_mean)/X_mean).^2,2) + sum(((Y - Y_mean)/Y_mean).^2,2));