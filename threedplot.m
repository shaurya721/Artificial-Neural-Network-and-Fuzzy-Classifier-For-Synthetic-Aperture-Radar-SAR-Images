% Define spatial dimensions
x = linspace(-1, 1, 100);
y = linspace(-1, 1, 100);
z = linspace(-1, 1, 100);

[X, Y, Z] = meshgrid(x, y, z);

% Define wave parameters
lambda = 0.1; % Wavelength
k = 2*pi/lambda; % Wave number
omega = 2*pi; % Angular frequency

% Define time parameter
t = 0;

% Calculate electric field
E_x = real(exp(1i*(k*X - omega*t)));
E_y = real(exp(1i*(k*Y - omega*t)));
E_z = real(exp(1i*(k*Z - omega*t)));

% Plot
figure;
quiver3(X, Y, Z, E_x, E_y, E_z);
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Electromagnetic Wave');
axis tight;
