%% Initialization
clc; clear; close all;

%% Circle related functions
function [x, y] = computeCircle(center, radius, np)
    
    theta = linspace(0, 2*pi, np); % Generate points for the circle
    x = center(1) + radius * cos(theta);
    y = center(2) + radius * sin(theta);

end

function plotCircle(center, cx, cy)
    plot(cx, cy, 'b', 'LineWidth', 2); % Plot the circle
    hold on;
    plot(center(1), center(2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Mark center
    
end

function y_est = computeRadius(params, centers)   
    %{
    y_est = zeros(size(centers(:,1)));
    for i = 1:size(centers, 1)
        y_est(i) = sqrt((params(1) - centers(i, 1)).^2 + (params(2) - centers(i, 2)).^2);
    end
    %}
    y_est = sqrt((params(1) - centers(:, 1)).^2 + (params(2) - centers(:, 2)).^2);
end

function errors = computeErrorsRadii(y_est, radii)
    %{
    errors = zeros(size(y_est(:,1)));
    for i = 1:length(y_est)
        %errors(i) = radii(i)^2 - y_est(i)^2;
        errors(i) = radii(i) - y_est(i);
    end 
    %}
    errors = radii - y_est;
end

%% Levenberg-Marquardt related functions 

%{
function J = computeJacobian(u, params)
   J = zeros(size(u,1), 2);
   for i = 1:length(J(:,1))  % Loop over rows (3)
        J(i, :) = [2*(params(1) - u(i, 1)) 2*(params(2) - u(i, 2))];
   end
end
%}
function J = computeJacobian(u, params)
    diffs = params' - u;
    norms = sqrt(sum(diffs.^2, 2));
    J = -diffs ./ norms;
end

function delta_params = computeDeltaParams(errors, J)
    delta_params = pinv(J' * J) * J'* errors ; %first step, without the error
end

function errors = computeErrors(residuals, J, delta_params)
    errors = residuals - J * delta_params;
end

function errors = computeErrorsStream(radii, y_est, J, delta_params)
    errors = computeErrorsRadii(y_est, radii) - J*delta_params;
end

function min_func = computeMinFunc(errors)
    min_func = errors' * errors;
end

function g = computeG(J, errors)
    g = 2 * J' * errors;
end

function nwparams = computeGN(params, step, J, errors)
    H = J' * J;
    delta = step*pinv(H) * J' * errors;
    nwparams = params - delta;
end

function nwparams = computeLM(params, step, J, alpha, errors)
    H = J' * J;
    delta = step*pinv(H + alpha * eye(2)) * J' * errors;
    nwparams = params - delta;
end

function nwparams = computeWLM(params, step, J, alpha, errors, W)
    H = J' * W * J;
    delta = step*pinv(H + alpha * eye(2)) * J' * W * errors;
    nwparams = params - delta;
end

%% Main
% Initializing circles 
bs1_center = [1, 1];
bs2_center = [10, 5];
bs3_center = [2, 4];

disp(ping_stolp_1);
disp(ping_stolp_2);
disp(ping_stolp_3);

[bs1_x, bs1_y] = computeCircle(bs1_center, ping_stolp_1, 100);
[bs2_x, bs2_y] = computeCircle(bs2_center, ping_stolp_2, 100);
[bs3_x, bs3_y] = computeCircle(bs3_center, ping_stolp_3, 100);

% Visualizing circles
plotCircle(bs1_center, bs1_x, bs1_y);
plotCircle(bs2_center, bs2_x, bs2_y);
plotCircle(bs3_center, bs3_x, bs3_y);
grid on;
xlabel('x');
ylabel('f(x)');
title('Plot of f(x)');

% Initial parameters
params_k0 = [1; 0];
params_x = [];
params_y = [];
delta_params_k0 = [0 0]';
errors_k0 = [0 0]';
centers = [bs1_center;bs2_center;bs3_center];
weights = eye([3 3]);
cumul_errors = zeros([3, 1]);
cumul_var = [];
cumul_cost = [];
cumul_grad = [];

% Measurement of radii
for k=1:5000
    radii(:, k) = [ping_stolp_1; ping_stolp_2; ping_stolp_3];   
end
% Radii shape : [1, 3]
% New radii shape, [n, 3]
weights = diag(var(radii'))^-1; %Inverse of the variance weight matrix 
disp(["Standard deviation of radii", num2str(std(radii'))]);


% Algorithm parameters
eta = 0.01; 
alpha = 0.001;  % Damping factor
maxIter = 3000;  % Maximum number of iterations
tolerance = 1e-6;  % Convergence tolerance
iter_mat = [];
error_iter = [];

prev_error = inf;
%% MainLoop
for iter = 1:length(radii)
    y_est = computeRadius(params_k0, centers);
    errors = computeErrorsRadii(y_est, radii(iter));
    J = computeJacobian(centers, params_k0);
    
    cumul_errors = [cumul_errors, errors];
    cumul_var = [cumul_var, var(errors, 0 ,"all")];
    grad = computeG(J, errors);
    cumul_grad = [cumul_grad, grad];
    
    % Update parameters using the Levenberg-Marquardt update rule
    %params_k1 = computeGN(params_k0, 0.1, J, errors);
    %params_k1 = computeLM(params_k0, eta, J, alpha, errors);
    params_k1 = computeWLM(params_k0, eta, J, alpha, errors, weights);
    delta_params_k0 = params_k1 - params_k0; 

    % Update tracking
    params_x = [params_x; params_k1(1)];
    params_y = [params_y; params_k1(2)];
    
    error_val = norm(errors + 1e-6);
    error_iter = [error_iter; prev_error - error_val];
    iter_mat = [iter_mat; iter];
    cumul_cost = [cumul_cost, errors' * errors];

    if abs(prev_error - error_val) < tolerance
        break;
    end
    
    prev_error = error_val;
    params_k0 = params_k1;
end


%% Result plotting
% Adding on the circle plot the resulting curve
plot(params_x, params_y, '.','LineWidth',0.5); hold on;
grid on;

% Errors plotting over the whole range
figure;
semilogy(iter_mat, error_iter, '.','LineWidth',0.2); hold on;
title("Error calculation");
xlabel("n° iterations");
grid on;
legend();

% Errors plotting
figure;

n_iter = 1:length(cumul_errors(1, :));

subplot(3, 1, 1);
semilogy(n_iter, abs(cumul_errors(1, :)), 'r');
grid on; title("Error of each parameters");
xlabel("n° iteration");
ylabel("Error")
legend("Param 1");

subplot(3, 1, 2);
semilogy(n_iter, abs(cumul_errors(2, :)), 'g');
grid on;
xlabel("n° iteration");
ylabel("Error")
legend("Param 2");

subplot(3, 1, 3);
semilogy(n_iter, abs(cumul_errors(3, :)), 'b');
grid on;
xlabel("n° iteration");
ylabel("Error")
legend("Param 3");

% Cost plotting
figure;
semilogy(iter_mat, cumul_cost, '.','LineWidth',0.2); hold on;
grid on;
title("Cost function / iteration");
xlabel("n° iteration");
ylabel("Cost function")
%legend("Param 1", "Param 2", "Param 3");

% Gradient plotting
figure;
semilogy(iter_mat, cumul_grad(1, :), '.','LineWidth',0.2); hold on;
semilogy(iter_mat, cumul_grad(2, :), '.','LineWidth',0.2);
grid on;
title("Gradient of each parameters");
xlabel("n° iteration");
ylabel("Gradient")
legend("Param 1", "Param 2");

% Final results
disp("== Final results ==");
disp(std(error_iter(2:end)));
disp(mean(error_iter(2:end)));
disp(std(cumul_cost));
disp(mean(cumul_cost));
disp([mean(params_x(end-99:end)), mean(params_y(end-99:end))]);