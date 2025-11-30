clear; clc; close all;



%   Example 2

filename2 = "example2.dat";

% A 的特征值分析
E2 = readmatrix(filename2);
i2 = E2(:,1); j2 = E2(:,2);

% 若节点编号从 0 开始，调整为从 1 开始
if min([i2; j2]) == 0
    i2 = i2 + 1;
    j2 = j2 + 1;
end

n2 = max([i2; j2]);

% 构造无向图邻接矩阵 A
A2 = sparse(i2, j2, 1, n2, n2);
A2 = A2 + A2.';
A2 = full(A2);

% 求 A 的特征值
[VA2, DA2] = eig(A2);
lambdaA2 = sort(diag(DA2));

figure;
plot(lambdaA2, 'o');
title('Example2：Sorted eigenvalues of adjacency matrix A');
xlabel('Index'); ylabel('\lambda');
grid on;


% 谱聚类算法 
k2 = 3;   
[labels2, eigvals2, eigvecs2, L2] = spectral_clustering(filename2, k2);

% 绘制 L 最小的 k 个特征值
figure;
stem(sort(eigvals2), 'filled');
title('Example2：k smallest eigenvalues of normalized Laplacian L');
xlabel('Index (1..k)'); ylabel('\lambda');
grid on;


% 绘制 Fiedler 向量
if k2 >= 2
    fiedler2 = eigvecs2(:,2);
    [sortedF2, idxF2] = sort(fiedler2);

    figure;
    plot(sortedF2, '-');
    title('Example2：Sorted Fiedler vector entries');
    xlabel('Node index (sorted)'); ylabel('Value');
    grid on;
end


% 画二维嵌入空间的聚类结果
% 使用特征向量的前两维
U2 = eigvecs2 ./ vecnorm(eigvecs2, 2, 2);
figure;
scatter(U2(:,1), U2(:,2), 25, labels2, 'filled');
title('Example2：Nodes embedded in R^2 and colored by cluster');
xlabel('u_1'); ylabel('u_2');
grid on; axis equal;


