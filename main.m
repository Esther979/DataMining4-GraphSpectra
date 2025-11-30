%% Initialization
clear; clc; close all;

% Clustering algorithm
if ~exist('spectral_clustering.m', 'file')
    error('Please ensure spectral_clustering.m inside the current file');
end

%% ==========================================================
% Analyse Example 1 (Real data - Medical Innovation)
% ==========================================================
disp('Analysing Example 1...');
file1 = "example1.dat";

% Determine the optimal number of clusters k (Eigengap Heuristic)
% Request a larger k(15) first, to observe the distribution of eigenvalues
k_inspect = 15;
[~, evals1, ~, ~] = spectral_clustering(file1, k_inspect);

% Draw a distribution chart of eigenvalues
figure('Name', 'Example 1 Analysis');
subplot(2, 2, 1);
plot(evals1, 'o-', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
title('Ex1: Eigenvalues');
xlabel('Index k'); ylabel('Eigenvalue \lambda');
grid on;

% The part with smaller and stable eigenvalues corresponds to the number of clusters
% then there will be a jump in the eigenvalues.
% For this dataset (consisting of doctors from 4 towns), there is usually a Gap at k = 4.
k1_optimal = 4; 
xline(k1_optimal, '--r', ['Chosen k=' num2str(k1_optimal)]);
text(k1_optimal, evals1(k1_optimal), '  \leftarrow Gap here', 'Color', 'r');

% Perform the final clustering using the optimal k value.
[labels1, ~, eigvecs1, ~] = spectral_clustering(file1, k1_optimal);

% Visualized result
raw1 = readmatrix(file1);
i1 = raw1(:,1); j1 = raw1(:,2);
if min([i1;j1])==0, i1=i1+1; j1=j1+1; end % 0-based 转 1-based
n1 = max([i1;j1]);
A1 = sparse(i1, j1, 1, n1, n1); A1 = A1 + A1.'; % 对称化

% Sort the nodes according to the clustering results
[~, sort_idx1] = sort(labels1);
sorted_A1 = A1(sort_idx1, sort_idx1);

subplot(2, 2, 2);
spy(sorted_A1);
title(['Ex1: Adjacency Matrix (Sorted by k=' num2str(k1_optimal) ')']);
xlabel('Nodes (sorted)');

% Two-dimensional embedding visualization (if k >= 3)
% The NJW algorithm uses eigenvectors as coordinates.
subplot(2, 2, [3 4]);
% Use the second and third eigenvectors to draw the graph 
scatter(eigvecs1(:,2), eigvecs1(:,3), 30, labels1, 'filled');
title('Ex1: 2D Embedding (Eigenvectors 2 vs 3)');
grid on; colorbar;

%% ==========================================================
%  Analyse Example 2 (Synthetic Data)
% ==========================================================
disp('Analysing Example 2...');
file2 = "example2.dat";

% Determine the optimal number of clusters k
k_inspect = 10;
[~, evals2, ~, ~] = spectral_clustering(file2, k_inspect);

figure('Name', 'Example 2 Analysis');
subplot(2, 2, 1);
plot(evals2, 's-', 'LineWidth', 1.5, 'MarkerFaceColor', 'g');
title('Ex2: Eigenvalues');
xlabel('Index k'); ylabel('Eigenvalue \lambda');
grid on;

% Observe plot，Search for the cliff-like upward point。
% Suppose example2 represents two distinct communities, and set k = 2.
k2_optimal = 2; 
xline(k2_optimal, '--r', ['Chosen k=' num2str(k2_optimal)]);

% Run clustering
[labels2, ~, eigvecs2, ~] = spectral_clustering(file2, k2_optimal);

% Visualized sorting matrix
raw2 = readmatrix(file2);
i2 = raw2(:,1); j2 = raw2(:,2);
if min([i2;j2])==0, i2=i2+1; j2=j2+1; end
n2 = max([i2;j2]);
% Example2 may have weighting columns. 
% If there is a third column serving as the weighting factor
if size(raw2, 2) >= 3
    w2 = raw2(:,3);
    A2 = sparse(i2, j2, w2, n2, n2);
else
    A2 = sparse(i2, j2, 1, n2, n2);
end
A2 = A2 + A2.';

[~, sort_idx2] = sort(labels2);
sorted_A2 = A2(sort_idx2, sort_idx2);

subplot(2, 2, 2);
spy(sorted_A2);
title(['Ex2: Adjacency Matrix (Sorted by k=' num2str(k2_optimal) ')']);

% Two-dimensional embedding visualization
subplot(2, 2, [3 4]);
scatter(eigvecs2(:,1), eigvecs2(:,2), 30, labels2, 'filled');
title('Ex2: 2D Embedding (Eigenvectors 1 vs 2)');
grid on; axis equal;
