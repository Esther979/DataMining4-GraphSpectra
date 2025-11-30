function [labels, eigvals, eigvecs, L] = spectral_clustering(filename, k)

    % Read edge list 
    E = readmatrix(filename);      % each row: (i, j)
    i = E(:, 1);
    j = E(:, 2);

    
    min_id = min([i; j]);
    if min_id == 0
        i = i + 1;
        j = j + 1;
    end

    n = max([i; j]);               % number of nodes

    % Build adjacency matrix A 
    A = sparse(i, j, 1, n, n);
    A = A + A.';                  

    % remove self-loops
    A = A - diag(diag(A));

    % Degree matrix D and normalized Laplacian L 
    d = full(sum(A, 2));           
    d(d == 0) = eps;

    D_inv_sqrt = spdiags(1 ./ sqrt(d), 0, n, n);
    L = speye(n) - D_inv_sqrt * A * D_inv_sqrt;

    % Compute k smallest eigenvectors of L 
   
    [eigvecs, Dmat] = eigs(L, k, 'smallestabs');
    eigvals = diag(Dmat);

    % Row-normalize eigenvectors 
    row_norms = vecnorm(eigvecs, 2, 2);
    row_norms(row_norms == 0) = 1;    % avoid division by zero
    U = eigvecs ./ row_norms;

    % Run k-means in the embedded space
    labels = kmeans(U, k, 'Replicates', 10);

end
