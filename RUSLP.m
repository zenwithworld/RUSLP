function [dumb, feature_idx] = RUSLP(X, m, W, F, G, L, lambda1, lambda2, lambda3, lambda4, ITER1, ITER2)
%, lambda4
% This code is for the algorithm described in "Orthogonally constrained
% Matrix Factorization for Robust Unsupervised Feature Selection with Local
% Preserving"


%% Problem:
% min_W,b,B,E ||XW + b1' - GF'||^2,1 + lambda1 * Tr(W'X'L'XW) + lambda2 * ||W||_21
% s.t. B'B = I, E'E = I, E>=0
%% Input and output:
% [Input]
% X: the data matrix
% G: the encoding matix 
% F: the orthogonal basis matrix
% W: the feature selection matrix 

% [Output]
% feature_idx: indices of selected features
%% 
[n, d] = size(X);
d2 = ones(d, 1);
d3 = ones(n, 1);

% lambda3 = 100;
% lambda4 = 100000;
X = X - ones(n,1) * mean(X,1); 

% H = zeros(size(G));
% Y = zeros(n, m);

H = rand(size(G));
Y = rand(n, m);
b = zeros(1, m);
 XX = X' * X;
obj = zeros(1,50);

for iter = 1 : ITER1
    
    %¼ÇÂ¼obj value
%     if lambda1 == 10000  && lambda2 == 100 && lambda4 == 0.000001
%         obj(iter)=L21(X*W - G*F')+lambda1* trace(W'*X'*L*X*W)+lambda2* L21(W);
%     end
    obj(iter)=L21(X*W - G*F')+lambda1* trace(W'*X'*L*X*W)+lambda2* L21(W);
    iter2 = 1;
%     WXB = (W' * X + b * ones(1, n))' * F;
    %updating G,H 
    E = X * W + ones(n, 1) * b - G * F';
%     obj(iter)= L21((X*W - G*F'- E));
    while(iter2 <= ITER2)               
%         [LE, ~, RE] = svd(WXB + lambda2 * H, 'econ'); G = LE * RE';
        G = (lambda4 * X * W * F - lambda4 * E * F + 2 * lambda3 * H + Y * F) / ((2*lambda3*eye(m) + lambda4 * F' * F));
        H = 0.5 * (G + abs(G));   
        iter2 = iter2 + 1;    
    end
     
    %updating F
    AB = G' * (X * W + ones(n, 1) * b - E + Y/lambda4);
    [LE, ~, RE] = svd(AB', 'econ');
    F = LE * RE'; 
    
    
    %updating W
    EB = G * F';
    D2 = spdiags(d2, 0, d, d);
    W = (2 * lambda1 * X' * L * X + lambda4 * XX + 2 * lambda2 * D2) \ (X' * (lambda4 * E + lambda4 * EB - ones(n, 1) * b - Y)) ;
%      b = mean(EB' - W'*X, 2);
    d2 = 1./ (2 * (sqrt(sum(W .* W, 2) + eps)));
    
    %updating E
    J = X * W + ones(n, 1) * b - G * F' + Y/lambda4;
    D3 = spdiags(d3, 0, n, n);
    E = (2 * D3 + lambda4 * eye(n)) \ (lambda4 * J);
    d3 = 1./ (2 * (sqrt(sum(E .* E, 2) + eps)));
    
    %updating Y
    Y = Y + lambda4 * (E - (X * W + ones(n, 1) * b - G * F'));
    
    %updating lambda4
%     lambda4 = min(1.2 * lambda4, 10^6);


    
end

[dumb,idx] = sort(sum(W.*W,2), 'descend');
feature_idx = idx;

% if lambda1 == 10000  && lambda2 == 100 && lambda4 == 0.000001
%     if obj(30) < obj(1) 
%    %display the figure of iterative process
%     fontsize = 20; 
%     figure1 = figure('Color',[1 1 1]);
%     axes1 = axes('Parent',figure1,'FontSize',fontsize,'FontName','Times New Roman');
% %     obj1 = obj/10^15;
% %     plot(obj,'LineWidth',3,'Color',[0 0 1]);
%     xlim(axes1,[0.8 15]);
%     a = [1:1:15] ;
%     semilogy(obj(1:15),'LineWidth',3,'Color',[0 0 1])
% %         ylim(axes1,[16000,36000]);%Cifar
%     % set(gca,'yscale','log') 
%      set(gca,'FontName','Times New Roman','FontSize',fontsize);
%     xlabel('Iteration number');
%     ylabel('Objective function value');
%     end
% end
end
