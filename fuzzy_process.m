function [V, U, T, E] = fuzzy_process(X, c, options, init_V)


n = size(X, 1);
p = size(X, 2);
m = options(1);	        	
eta = options(2);	        
max_iter = options(3);		
term_thr = options(4);		
display = options(5);		
E = zeros(max_iter, 1);	
V = init_V;



for i = 1:max_iter,
	[V, U, T, E(i)] =step_process2(X, V, c, m, eta);

    if display, 
		fprintf('Iteration Count = %d, Error Measure Value = %f\n', i, E(i));
	end
	if E(i) <= term_thr, break; end,
end

iter_n = i;	
E(iter_n+1:max_iter) = [];
