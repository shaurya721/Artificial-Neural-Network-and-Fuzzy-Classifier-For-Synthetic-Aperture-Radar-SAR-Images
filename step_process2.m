function [V, U, T, E] =step_process2(X, V, c, m, eta)

n = size (X, 1);
p = size (X, 2);
dist =dist_measure(V, X); 
tmp = dist.^(-2/(m-1));      
U = tmp./(ones(c, 1)*sum(tmp));


si = find (tmp == Inf);
U(si) = 1;
if (size (si, 1) ~= 0)
    display ('FPCMC, Warning: Singularity occured and corrected.');
end
tmp = dist.^(-2/(eta-1));      
T = tmp./((sum(tmp')') * ones(1,n));

T(si) = 1; 

tmp = find ((sum (T') - ones (1, c)) > 0.0001);
if (size(tmp,2) ~= 0)
    display ('FPCMC, Warning: Constraint for T is not hold.');
end

V_old = V;
Us = U.^m;
Ts = T.^eta;
V = ((Us+Ts)*X) ./ ((ones(p, 1)*sum((Us+Ts)'))'); % new center
E = norm (V - V_old, 1);

